require("game.util.JJGameUtil")
require("game.def.JJGameDefine")
local JJViewGroup = import("sdk.ui.JJViewGroup")
local LobbyView = class("LobbyView", JJViewGroup)
local roarInterface = require("game.thirds.RoarInterface")

local TAG = "LobbyView"

LobbyView.RETURN_BTN = 1
LobbyView.MENU_BTN = 2

--[[
params
@scene
@packageId
@gameId
@title: 标题
@zone:
]]
function LobbyView:ctor(params, customParam)
    LobbyView.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.params_ = params
    self.packageId_ = params.packageId
    self.controller_ = params.controller
    self.urlColor_ = params.urlColor
    self.registerColor = params.registerColor
    self.topicUrl_ = params.topicUrl
    self.customParam_ = customParam
--    dump(params)

    self.scene_ = params.scene
    self.gameId_ = params.gameId
    self:setAnchorPoint(ccp(0,0))
    self:setPosition(ccp(0,0))
    self:setViewSize(self.dimens_.width, self.dimens_.height)
    self.isLordSingle_ = self.gameId_ == JJGameDefine.GAME_ID_LORD_SINGLE
    self.backHanding_ = false

    if self.isLordSingle_ then
    	self.lordSingleMatchDatas = params.lordSingleMatchDatas
    	self.singleGameManager = params.singleGameManager
        self.singleGameMatchPromotionManager = params.singleGameMatchPromotionManager
        self.singleUserInfoManager = params.singleUserInfoManager
    end

    JJLog.i(TAG, "ctor IN lordSingleMatchDatas is ", self.lordSingleMatchDatas)
    JJLog.i(TAG, "ctor IN singleGameManager is ", self.singleGameManager)
    JJLog.i(TAG, "ctor IN singleGameMatchPromotionManager is ", self.singleGameMatchPromotionManager)

    -- url font color
    if self.urlColor_ == nil then
        self.urlColor_ = ccc3(0x11, 0x44, 0x77)
    end

    if self.registerColor == nil then
        self.registerColor = ccc3(255, 255, 255)
    end

    -- backgroud
    self.scene_:setBg(self.theme_:getImage("matchselect/bg.jpg"))

    -- title bg
    self.scene_:setTitle(self.params_.title)

    --  return btn
    local images = nil
    if RUNNING_MODE == RUNNING_MODE_HALL and self.packageId_ ~= JJGameDefine.GAME_ID_LORD_UNION then
        images = {
            normal = self.theme_:getImage("main/return_hall_n.png"),
        }
    else
        local images = {
            normal = self.theme_:getImage("common/return_btn_n.png"),
        }
    end

    self.scene_:setBackBtn(true, images)

    -- menu btn
    local menuBtn = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("main/menu_btn_n.png"),
        },
        viewSize = CCSize(100,70),
    })
    menuBtn:setAnchorPoint(ccp(1,1))
    menuBtn:setPosition(self.dimens_.width-self.dimens_:getDimens(10), self.dimens_.height-self.dimens_:getDimens(10))
    menuBtn:setScale(self.dimens_.scale_)
    menuBtn:setId(self.MENU_BTN)
    menuBtn:setOnClickListener(handler(self, self.onClick))
    self:addView(menuBtn)

    -- 私信或公告未读
    local count = NoteManager:getUnreadCount(MainController:getCurPackageId(), UserInfo.userId_)
    -- 咆哮未读
    -- roarRemindMsgFlag_

    self.unreadFlag = jj.ui.JJImage.new({
        image = self.theme_:getImage("main/unread_flag.png"),
    })
    self.unreadFlag:setAnchorPoint(ccp(1,1))
    self.unreadFlag:setPosition(self.dimens_.width-self.dimens_:getDimens(10), self.dimens_.height-self.dimens_:getDimens(10))
    self.unreadFlag:setScale(self.dimens_.scale_)
    self.unreadFlag:setVisible(count > 0 or roarRemindMsgFlag_)
    self:addView(self.unreadFlag)
--  单机斗地主情况
    if self.isLordSingle_ then
        local imageId = nil
        self.zoneId_ = 1
        imageId = string.format(self.params_.zone, self.zoneId_)
        self.scene_:setTitle(self.theme_:getImage(imageId))
        self.matchListView_ = require("game.ui.view.MatchListView").new({
            theme = self.theme_,
            dimens = self.dimens_,
            scene = self,
            zoneId = self.zoneId_,
            gameId = self.gameId_,
            packageId = self.packageId_,
            urlColor = self.urlColor_,
            lordSingleMatchDatas = self.lordSingleMatchDatas,
            singleGameManager = self.singleGameManager,
            singleGameMatchPromotionManager = self.singleGameMatchPromotionManager
        },self.customParam_)
        self.matchListView_:setAnchorPoint(ccp(0, 0.5))
        self.matchListView_:setPosition(0, self.dimens_.cy)
        self:addView(self.matchListView_)
        if self.unreadFlag then
            self.unreadFlag:setVisible(false)
        end
--  单赛区情况直接进去列表界面
    elseif self.customParam_.maxZone < 2 then
        self:showMatchListView(1, false)
    else
--  不是列表界面,如之前处于列表界面恢复时即不画zone界面，提高程序效率
        if self.controller_.viewIndex_ ~= 1 then
            self.zonesview_ = import("game.ui.view.ZonesView").new(self, self.theme_, self.dimens_, self.controller_,self.customParam_)
            self.zonesview_:setScale(self.dimens_.scale_)
            self.zonesview_:setAnchorPoint(ccp(0, 0.5))
            self.zonesview_:setPosition(0, self.dimens_.cy)
            self:addView(self.zonesview_)
        end
        if self.unreadFlag then
            self.unreadFlag:setVisible(count > 0 or roarRemindMsgFlag_)
        end
    end

    -- bottomview
    self.bottomView_ = import("game.ui.view.BottomView").new({
        scene = self.scene_,
        packageId = self.packageId_,
        gameId = self.gameId_,
        theme = self.theme_,
        dimens = self.dimens_,
        topicUrl = self.topicUrl_,
        singleUserInfoManager = self.singleUserInfoManager
    })
    self.bottomView_:setAnchorPoint(ccp(0,0))
    self.bottomView_:setPosition(0, 0)
    self:addView(self.bottomView_, 10)

    local url = jj.ui.JJLabel.new({
            text = "www.jj.cn",
            fontSize = self.dimens_:getDimens(22),
            color = self.urlColor_,
        })
    url:setAnchorPoint(ccp(1, 0))
    url:setPosition(ccp(self.dimens_.width - self.dimens_:getDimens(20), self.dimens_:getDimens(40)))
    self:addView(url)

    if not self.isLordSingle_ then
        -- matchlist view
        self.matchListView_ = nil
    end
    if self.controller_.viewIndex_ == 1 then
        self:resumeMatchListView(self.controller_.zoneId_)
    end
    -- self:showMsg()
    -- 注册
    if self.packageId_ ~= JJGameDefine.GAME_ID_LORD_UNION then
        self.btnRegister_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("main/register_btn_n.png"),
            },
            text = "注册",
            fontSize = self.dimens_:getDimens(24),
            color = self.registerColor,
            viewSize = CCSize(self.dimens_:getDimens(100), self.dimens_:getDimens(70)),
        })
        self.btnRegister_:setAnchorPoint(ccp(1, 1))
        self.btnRegister_:setPosition(self.dimens_.width - self.dimens_:getDimens(120), self.dimens_.height - self.dimens_:getDimens(10))
        -- self.btnRegister_:setScale(self.dimens_.scale_)
        self.btnRegister_:setOnClickListener(handler(self, self.onClick))
        self:addView(self.btnRegister_)
        self.btnRegister_:setVisible(false)

        self:isVisibleBtnRegister()
    end

end

--[[
    刷新用户信息
]]
function LobbyView:isVisibleBtnRegister()
    JJLog.i(TAG, "isVisibleBtnRegister")

    -- 如果是JJ帐号登录，否则显示注册按钮
    local lc = require("game.controller.LoginController")
    lc:init()
    JJLog.i("Util:isQihu360() = ",Util:isQihu360(),UserInfo:isLogin(),lc.type_, LOGIN_TYPE_JJ)
    if self.btnRegister_ then
        if Util:isQihu360() or (UserInfo:isLogin() and lc.type_ == LOGIN_TYPE_JJ) then            
            self.btnRegister_:setVisible(false)            
        else
            self.btnRegister_:setVisible(true)          
        end
    end
end

function LobbyView:resumeMatchListView(zoneId)
    self.zoneId_ = zoneId
    if self.matchListView_ then
        self:removeMatchListView()
    end
    local imageId = nil
    imageId = string.format(self.params_.zone, self.zoneId_)
    self.scene_:setTitle(self.theme_:getImage(imageId))

    self.matchListView_ = require("game.ui.view.MatchListView").new({
        theme = self.theme_,
        dimens = self.dimens_,
        scene = self,
        zoneId = zoneId,
        gameId = self.gameId_,
        packageId = self.packageId_,
        urlColor = self.urlColor_,
    },self.customParam_)
    self.matchListView_:setAnchorPoint(ccp(0, 0.5))
    self.matchListView_:setPosition(0, self.dimens_.cy)
    self:addView(self.matchListView_)
    self.controller_.viewIndex_ = 1
    self.controller_.zoneId_ = zoneId
    local images = {
        normal = self.theme_:getImage("common/return_btn_n.png"),
    }
    self.scene_:setBackBtn(true, images)
end

function LobbyView:showMatchListView(zoneId, mutiZone)
    JJLog.i(TAG, "showMatchListView zoneId = " .. zoneId)
    if self.btnRegister_ then
        self.btnRegister_:setVisible(false)
    end

    if mutiZone == false then
        self.zoneId_ = zoneId
        if self.matchListView_ then
            self:removeMatchListView()
        end
        local imageId = nil
        imageId = string.format(self.params_.zone, self.zoneId_)
        self.scene_:setTitle(self.theme_:getImage(imageId))

        self.matchListView_ = require("game.ui.view.MatchListView").new({
            theme = self.theme_,
            dimens = self.dimens_,
            scene = self,
            zoneId = zoneId,
            gameId = self.gameId_,
            packageId = self.packageId_,
            urlColor = self.urlColor_,
        },self.customParam_)
        self.matchListView_:setAnchorPoint(ccp(0, 0.5))
        self.matchListView_:setPosition(0, self.dimens_.cy)
        self:addView(self.matchListView_)
        self.controller_.zoneId_ = zoneId

        local images = {
            normal = self.theme_:getImage("common/return_btn_n.png"),
        }
        self.scene_:setBackBtn(true, images)
    else
        self.zoneId_ = zoneId
        if self.matchListView_ then
            self:removeMatchListView()
        end
        local imageId = nil
        imageId = string.format(self.params_.zone, self.zoneId_)
        self.scene_:setTitle(self.theme_:getImage(imageId))

        self.matchListView_ = require("game.ui.view.MatchListView").new({
            theme = self.theme_,
            dimens = self.dimens_,
            scene = self,
            zoneId = zoneId,
            gameId = self.gameId_,
            packageId = self.packageId_,
            urlColor = self.urlColor_,
        },self.customParam_)
        self.matchListView_:setAnchorPoint(ccp(0, 0.5))
        self.matchListView_:setPosition(self.dimens_.width, self.dimens_.cy)
        self:addView(self.matchListView_)
        self.controller_.viewIndex_ = 1
        self.controller_.zoneId_ = zoneId

        local action = CCMoveBy:create(0.3, ccp(-self.dimens_.width, 0))
        self.zonesview_:runAction(action)

        action = CCMoveBy:create(0.3, ccp(-self.dimens_.width, 0))
        self.matchListView_:runAction(action)

        local images = {
            normal = self.theme_:getImage("common/return_btn_n.png"),
        }
        self.scene_:setBackBtn(true, images)
    end
end

function LobbyView:removeMatchListView()
    if self.matchListView_ then
        self.backHanding_ = false
        self.controller_.viewIndex_ = 0
        self.controller_.zoneId_ = 1
        self:removeView(self.matchListView_)
        self.matchListView_ = nil
        self.scene_:setTitle(self.params_.title)
        local images = nil
        if RUNNING_MODE == RUNNING_MODE_HALL and self.packageId_ ~= JJGameDefine.GAME_ID_LORD_UNION then
            images = {
                normal = self.theme_:getImage("main/return_hall_n.png"),
            }
        else
            images = {
                normal = self.theme_:getImage("common/return_btn_n.png"),
            }
        end
        self.scene_:setBackBtn(true, images)

    end
end


function LobbyView:removeMatchDesView()
    if self.matchDesView_ then
        self:removeView(self.matchDesView_)
        self.matchDesView_ = nil
    end
end

function LobbyView:removeMatchDesViewForBackPress()
    if self.matchDesView_ then
        if self.matchDesView_:hasCannotSingupDialog() then
            self.matchDesView_:showCannotSingupDialog(false)
        elseif self.matchDesView_:hasChargeDialog() then
            self.matchDesView_:showChargeDialog(false)
        else
            self:removeView(self.matchDesView_)
            self.matchDesView_ = nil
        end
    end
end


function LobbyView:showMatchDesView(params)
    if not MainController:isLogin() and not self.isLordSingle_ then
        LoginController:reInitLastRecord()
        self.scene_.controller_:startLogin()
        return
    end

    if self.matchDesView_ then
        self:removeMatchDesView()
    end

    local getNewMatchDesViewParam = function ()
        if self.isLordSingle_ then
            return {scene = self, gameId = self.gameId_, singleMatchData = params.singleMatchData, theme = self.theme_, dimens = self.dimens_, singleGameManager = self.singleGameManager, singleGameMatchPromotionManager = self.singleGameMatchPromotionManager,packageId = self.packageId_}
        else
            return {scene = self, gameId = self.gameId_, tourneyInfo = params.tourneyInfo, theme = self.theme_, dimens = self.dimens_,packageId = self.packageId_}
        end
    end

    self.matchDesView_ = import("game.ui.view.MatchDesView").new(getNewMatchDesViewParam(),self.customParam_)
    self.matchDesView_:setAnchorPoint(ccp(0.5, 0.5))
    self.matchDesView_:setPosition(self.dimens_.cx, self.dimens_.cy)
    -- self.matchDesView_:setScale(self.dimens_.scale_)
    self:addView(self.matchDesView_, 20)
end

function LobbyView:onClick(view)
    local btnId = view:getId()
    if btnId == self.RETURN_BTN then
        self.scene_.controller_:onBackPressed()

    elseif btnId == self.MENU_BTN then
        if self.bottomView_ ~= nil then
            self.bottomView_:changeState(nil)
        end
     -- 注册
    elseif view == self.btnRegister_ then
        self.scene_.controller_:onClickRegister()
    end
end

-- 询问是否退出的对话框
function LobbyView:showExitDialog(show)
    if show then
        local function onClick(self)
            JJLog.i(TAG, "showExitDialog, onClick, exit")
            -- app:exit()
            MainController:exit()
        end

        self.exitDialog_ = require("game.ui.view.AlertDialog").new({
            title = "提示",
            prompt = "您确认要退出吗？",
            onDismissListener = function() self.exitDialog_ = nil end,
            theme = self.theme_,
            dimens = self.dimens_
        })

        self.exitDialog_:setButton1("退出", onClick)
        self.exitDialog_:setButton2("取消", nil)
        self.exitDialog_:setCanceledOnTouchOutside(true)

        self.exitDialog_:show(self)
    else
        if self.exitDialog_ ~= nil then
            self.exitDialog_:dismiss()
        end
    end
end

function LobbyView:onBackPressed()
    if self.bottomView_ ~= nil and self.bottomView_:isOpen() then
        self.bottomView_:changeState()
    elseif self.matchDesView_ then
        self:removeMatchDesViewForBackPress()
    elseif self.NoteManagerView_ and self.NoteManagerView_:isVisible()then
        self:showMsg(false)
        return true
    elseif self.matchListView_ and not self.isLordSingle_ and self.customParam_.maxZone > 1 then
        if self.backHanding_ == false then
            self.backHanding_ = true
            local action = CCMoveBy:create(0.3, ccp(self.dimens_.width, 0))
            if self.zonesview_ == nil then
                self.zonesview_ = import("game.ui.view.ZonesView").new(self, self.theme_, self.dimens_, self.controller_,self.customParam_)
                self.zonesview_:setScale(self.dimens_.scale_)
                self.zonesview_:setAnchorPoint(ccp(0, 0.5))
                self.zonesview_:setPosition(-self.dimens_.width, self.dimens_.cy)
                self:addView(self.zonesview_)
            end
            self.zonesview_:runAction(action)
            self.zonesview_:setEnable(true)

            local arr = CCArray:create()
            action = CCMoveBy:create(0.3, ccp(self.dimens_.width, 0))
            arr:addObject(action)
            arr:addObject(CCCallFunc:create(handler(self, self.removeMatchListView)))
            self.matchListView_:runAction(CCSequence:create(arr))
            self.controller_.viewIndex_ = 0
            self.controller_.zoneId_ = 1
            if self.btnRegister_ then
                self:isVisibleBtnRegister()
            end
        end
    else
       if RUNNING_MODE == RUNNING_MODE_HALL then
            JJSDK:popScene()
        else
            -- TODO: 对于单包游戏，这儿需要增加退出提示框
            if MainController:getCurPackageId() == JJGameDefine.GAME_ID_LORD_UNION or  MainController:getCurPackageId() == JJGameDefine.GAME_ID_LORD_UNION_HL then
                JJSDK:popScene()
            elseif self.exitDialog_ ~= nil then
                self:showExitDialog(false)
            else
                self:showExitDialog(true)
            end
        end

    end
end

function LobbyView:updateForSignupMsg(tourneyId)
    if self.matchDesView_ then
        self.matchDesView_:updateForSignupMsg(tourneyId)
    end
    if self.matchListView_ then
        self.matchListView_:refresh()
    end
    if self.NoteManagerView_ ~= nil then
        self.NoteManagerView_:refresh()
    end
end

function LobbyView:doSignupResult(tourneyId,matchType, matchPoint,curPlayer,maxPlayer,interVal)
    if self.matchDesView_ then
        self.matchDesView_:doSignupResult(tourneyId,matchType, matchPoint,curPlayer,maxPlayer,interVal)
    end
end

function LobbyView:showEnterMatchCountDown(matchType,matchPoint,signupPlayer,matchPlayer,tourneyId,interVal)
    if self.matchDesView_ then
        self.matchDesView_:showEnterMatchCountDown(matchType,matchPoint,signupPlayer,matchPlayer,tourneyId,interVal)
    end
end


function LobbyView:refresh(msg)
    if self.matchDesView_ then
        self.matchDesView_:refreshMatchPointLabel()
    end
    if self.matchListView_ then
        self.matchListView_:refresh()
    end
end

function LobbyView:refreshUserInfo()
    self.bottomView_:refreshUserInfo()

    JJLog.i(TAG, "refreshUserInfo1222", self.btnRegister_)
    self:isVisibleBtnRegister()
end

function LobbyView:dialogIsExist()
    if self.matchDesView_ ~= nil then
        return self.matchDesView_:dialogIsExist()
    else
        return false
    end
end

function LobbyView:secondViewIsExist()
    if self.matchListView_ ~= nil then
        return true
    else
        return false
    end
end

function LobbyView:removeSignupWaitDialog()
    if self.matchDesView_ ~= nil then
        self.matchDesView_:removeSignupWaitDialog()
    end
end

function LobbyView:showMsg(show)
    if show then
        if not self.isLordSingle_ then
            local count = NoteManager:getUnreadCount(MainController:getCurPackageId(), UserInfo.userId_)
            if(NoteManager:getUnreadCountShowDialog(MainController:getCurPackageId(), UserInfo.userId_) > 0) and NoteManager.hasPoped == false then
                if self.NoteManagerView_ ~= nil then
                    self:removeView(self.NoteManagerView_)
                    self.NoteManagerView_ = nil
                end
                self.NoteManagerView_ = import("game.ui.view.NoteManagerView").new({theme = self.theme_,
                    dimens = self.dimens_, scene = self})
                self.NoteManagerView_:setAnchorPoint(ccp(0.5, 0.5))
                self.NoteManagerView_:setPosition(self.dimens_.cx, self.dimens_.cy)
                self:addView(self.NoteManagerView_, 20)
                NoteManager.hasPoped = true
                count = 0--弹出消息框时，不根据是否有未读消息个数判断
            end
            if self.unreadFlag then
                self.unreadFlag:setVisible(count > 0 or roarRemindMsgFlag_)
            end
            if self.bottomView_ and self.bottomView_.updatePcenterNewMsgInfo then
              self.bottomView_:updatePcenterNewMsgInfo(count)
            end
        end
    else
        if self.NoteManagerView_ then
            self.NoteManagerView_:setVisible(false)
        end
        self:checkUnreadMsg()
    end
end

function LobbyView:removeMsgView()
    if self.NoteManagerView_ ~= nil then
        self.NoteManagerView_ = nil
    end
    self:checkUnreadMsg()
end

function LobbyView:refreshRoarNewMsgInfo()
    JJLog.i(TAG, "refreshRoarNewMsgInfo")

     if self.bottomView_ ~= nil then
          self.bottomView_:updateRoarNewMsgInfo()
     end
     self:checkUnreadMsg()
end

function LobbyView:checkUnreadMsg()
    local count = NoteManager:getUnreadCount(MainController:getCurPackageId(), UserInfo.userId_)
    -- 咆哮未读
    -- roarRemindMsgFlag_

    if self.unreadFlag then
        self.unreadFlag:setVisible(count > 0 or roarRemindMsgFlag_)
    end

    if self.bottomView_ and self.bottomView_.updatePcenterNewMsgInfo then
        self.bottomView_:updatePcenterNewMsgInfo(count)
    end
end

function LobbyView:onExit()
    JJLog.i(TAG, "LobbyView:onExit")
    if self.zonesview_ ~= nil then
        self.zonesview_ = nil
    end
    if self.bottomView_ ~= nil then
        self.bottomView_ = nil
    end
    if self.matchDesView_ then
        self.matchDesView_ = nil
    end
    if self.matchListView_ then
        self.matchListView_ = nil
    end
    if self.btnRegister_ then
        self.btnRegister_ = nil
    end

    self:removeMsgView()
end


function LobbyView:refreshMatchConfigMsg()
    if self.matchDesView_ then
        self.matchDesView_:refreshMatchConfigMsg()
    end
    if self.matchListView_ then
        self.matchListView_:refresh()
    end
end

function LobbyView:refreshBottomViewBtn()
    if self.bottomView_ then
        self.bottomView_:refreshBtn()
    end
end
return LobbyView