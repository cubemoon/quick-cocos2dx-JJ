local MatchSelectScene = class("MatchSelectScene", require("game.ui.scene.JJGameSceneBase"))
local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")
local TAG = "MatchSelectScene"

MatchSelectScene.loginDialog_ = nil -- 登录等待框
MatchSelectScene.noNetworkDialog_ = nil -- 无网络提示框

function MatchSelectScene:ctor(controller)
    MatchSelectScene.super.ctor(self, controller)
end

function MatchSelectScene:onDestory()
    MatchSelectScene.super.onDestory(self)
    self.loginDialog_ = nil
    self.noNetworkDialog_ = nil
    self.bindNoRegDialog_ = nil
end


function MatchSelectScene:_createView()
    local param = {
        dimens = self.dimens_,
        theme = self.theme_,
        scene = self,
        packageId = self.controller_.params_.packageId,
        gameId = self.controller_.params_.gameId,
        title = self.controller_.params_.title,
        zone = self.controller_.params_.zone,
        urlColor = self.controller_.params_.urlColor,
        registerColor = self.controller_.params_.registerColor,
        topicUrl = self.controller_.params_.topicUrl,
        controller = self.controller_,
    }
    if self.controller_.params_.gameId == JJGameDefine.GAME_ID_LORD_SINGLE then
        param.lordSingleMatchDatas = self.controller_.params_.lordSingleMatchDatas
        param.singleGameManager = self.controller_.params_.singleGameManager
        param.singleUserInfoManager = self.controller_.params_.singleUserInfoManager
        param.singleGameMatchPromotionManager = self.controller_.params_.singleGameMatchPromotionManager
    end
    local customParam = self.controller_.customParam_
    self.currentView_ = require("game.ui.view.LobbyView").new(param, customParam)
    self.currentView_:setAnchorPoint(ccp(0,0))
    self:addView(self.currentView_)
    self.currentView_:setPosition(ccp(0,0))
    self.currentView_:setViewSize(self.dimens_.width, self.dimens_.height)
end

function MatchSelectScene:initView()
    MatchSelectScene.super.initView(self)
    DynamicDisplayManager:initFromFile()
    self:_createView()
end

function MatchSelectScene:handleMsg(msg)
    JJLog.i(TAG, "handleMsg")
    if msg.type == GameMsgDef.ID_CUSTOM_TOURNEY_CHANGE then
        self.currentView_:refresh(msg)

    elseif msg[MSG_CATEGORY] == LOBBY_ACK_MSG and (msg[MSG_TYPE] == PUSHACCNUMMONEY_ACK or msg[MSG_TYPE] == PUSH_USER_MONEY_ACK) then
        self.currentView_:refresh(msg)

            -- 用户物品变化：
    elseif msg[MSG_CATEGORY] == LOBBY_ACK_MSG and(msg[MSG_TYPE] == GETUSERALLWARE_ACK or msg[MSG_TYPE] == PUSH_USER_WARE_ACK) then
            self.currentView_:refresh(msg)

    elseif msg[MSG_CATEGORY] == LOBBY_ACK_MSG and msg[MSG_TYPE] == TOURNEYUNSIGNUP_ACK then
        local ack = msg.lobby_ack_msg.tourneyunsignup_ack_msg
        self:updateForSignupMsg(ack.tourneyid)

    elseif msg[MSG_CATEGORY] == LOBBY_ACK_MSG and msg[MSG_TYPE] == TOURNEYSIGNUPEX_ACK then
        local ack = msg.lobby_ack_msg.tourneysignupex_ack_msg
        if msg.param == MatchDefine.TK_MATCHSIGNUP_SUCCESS then
            MatchInfoMsg:sendGetSignCountReq(ack.tourneyid)
            local tourneyInfo = LobbyDataController:getTourneyInfoByTourneyId(ack.tourneyid)
            if tourneyInfo ~= nil then
                local matchType = tonumber(tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.matchType)
                if matchType ~= MatchDefine.MATCH_TYPE_TIMELY and matchType ~= MatchDefine.MATCH_TYPE_ISLAND then
                    local matchPoint = 0
                    -- if tourneyInfo.signupedTime_ ~= 0 then
                    --     matchPoint = tourneyInfo.signupedTime_
                    -- else
                    --     matchPoint = tourneyInfo:getSignupTime()
                    -- end
                    local signupitem = SignupStatusManager:getSignupedItem(tourneyInfo.tourneyId_)
                    self:doSignupResult(tourneyInfo.tourneyId_,matchType, signupitem.startTime_,0,0,0)
                end
            end

        else
        end
        self:updateForSignupMsg(ack.tourneyid)

    elseif msg[MSG_CATEGORY] == MATCHINFO_ACK_MSG and msg[MSG_TYPE] == MATCH_SIGN_COUNT_INFO_ACK then
        local ack = msg.matchinfo_ack_msg.getsigncount_ack_msg
        local tourneyInfo = LobbyDataController:getTourneyInfoByTourneyId(ack.tourneyid)
        if tourneyInfo ~= nil then
            local matchType = tonumber(tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.matchType)
            if matchType == MatchDefine.MATCH_TYPE_TIMELY then
                local matchPoint = 0
                if tourneyInfo.signupedTime_ ~= 0 then
                    matchPoint = tourneyInfo.signupedTime_
                else
                    matchPoint = tourneyInfo:getSignupTime()
                end
                local signupitem = SignupStatusManager:getSignupedItem(tourneyInfo.tourneyId_)
                if signupitem ~= nil then
                    self:doSignupResult(tourneyInfo.tourneyId_,matchType, signupitem.startTime_,ack.signupplayer,ack.matchplayercount,ack.matchcreateinterval)
                end
            end
        end
    elseif msg[MSG_CATEGORY] == HTTP_ACK_MSG and (msg[MSG_TYPE] == COMMON_HTTP_GET_NOTE_MSG_ACK or msg[MSG_TYPE] == COMMON_HTTP_GET_PRI_MSG_ACK) then
        self.currentView_:showMsg(true)
    elseif msg[MSG_CATEGORY] == HTTP_ACK_MSG and msg[MSG_TYPE] == COMMON_HTTP_GET_MATCH_CONFIG_ACK then
        self.currentView_:refreshMatchConfigMsg()
    end
end

function MatchSelectScene:updateForSignupMsg(tourneyId)
    if self.currentView_ ~= nil then
        self.currentView_:updateForSignupMsg(tourneyId)
    end
end

function MatchSelectScene:doSignupResult(tourneyId, matchType, matchPoint,curPlayer,maxPlayer,interVal)
    if self.currentView_ ~= nil then
        self.currentView_:doSignupResult(tourneyId, matchType, matchPoint,curPlayer,maxPlayer,interVal)
    end
end

function MatchSelectScene:showEnterMatchCountDown(matchType,matchPoint,signupPlayer,matchPlayer,tourneyId,interVal)
    if self.currentView_ ~= nil then
        self.currentView_:showEnterMatchCountDown(matchType,matchPoint,signupPlayer,matchPlayer,tourneyId,interVal)
    end
end

function MatchSelectScene:onBackPressed()
    if self.loginDialog_ ~= nil then
        self:showLoginDialog(false)
        MainController:disconnect()
    elseif self.bindNoRegDialog_ then
        self:showGuideToBindNoRegDialog(false)
    elseif self.noNetworkDialog_ ~= nil then
        self:showNoNetworkDialog(false)
    elseif MatchSelectScene.super.isExistSignupConfirmDialog(self) == true then
        MatchSelectScene.super.closeSignupConfirmDialog(self)
    elseif self.currentView_ ~= nil then
        self.currentView_:onBackPressed()
    end
end

--[[
刷新用户信息
]]
function MatchSelectScene:refreshUserInfo()
    JJLog.i(TAG, "refreshUserInfo")
    if self.currentView_ ~= nil then
        self.currentView_:refreshUserInfo()
    end
end

function MatchSelectScene:refreshRoarNewMsgInfo()
    JJLog.i(TAG, "refreshRoarNewMsgInfo")

    if self.currentView_ ~= nil then
        self.currentView_:refreshRoarNewMsgInfo()
    end
end

--[[
免注册登录注册引导
]]
local UIUtil = require("game.ui.UIUtil")
function MatchSelectScene:showGuideToBindNoRegDialog(show)
    JJLog.i(TAG, "showGuideToBindNoRegDialog IN! and show : ", show)
    if show then
        local function onClick()
            JJLog.i(TAG, "showGuideToBindNoRegDialog, onClick, onClickRegister")
            self.controller_:onClickRegister()
        end

        local function closeDialog()
            self.bindNoRegDialog_ = nil
        end

        self.bindNoRegDialog_ = UIUtil.showGuideToBindNoRegDialog({
            btn1CB = nil,
            btn2CB = onClick,
            dismissCB = closeDialog,
            theme = self.theme_,
            dimens = self.dimens_,
            scene = self,
            prompt = "亲，建议您注册升级为JJ帐号，JJ帐号会自动保留您当前的所有财物和账户信息，方便又安全。",
        })

    else
        UIUtil.dismissDialog(self.bindNoRegDialog_)
        self.bindNoRegDialog_ = nil
    end
end

-- 报名弹出比赛界面
function MatchSelectScene:dialogIsExist()
    if self.currentView_ ~= nil then
        return self.currentView_:dialogIsExist()
    else
        return false
    end
end

-- 是否二级界面
function MatchSelectScene:secondViewIsExist()
    if self.currentView_ ~= nil then
        return self.currentView_:secondViewIsExist()
    else
        return false
    end
end

-- 去除报名提示框
function MatchSelectScene:removeSignupWaitDialog()
    if self.currentView_ ~= nil then
        return self.currentView_:removeSignupWaitDialog()
    else
        return false
    end
end

function MatchSelectScene:showMsg()
    if self.currentView_ ~= nil then
        self.currentView_:showMsg(true)
    end
end

-- 显隐登录等待对话框
function MatchSelectScene:showLoginDialog(show)
    JJLog.i(TAG, "showLoginDialog, show=", show)
    if show then

        UIUtil.dismissDialog(self.loginDialog_)
        self.loginDialog_ = UIUtil.showLoginDialog(self, self.theme_, self.dimens_, function() self.loginDialog_ = nil end)

    else

        UIUtil.dismissDialog(self.loginDialog_)
        self.loginDialog_ = nil
    end
end

-- 是否处于登录等待
function MatchSelectScene:isLoginDialog()
    return self.loginDialog_ ~= nil
end

--[[
    无网络提示框
]]
function MatchSelectScene:showNoNetworkDialog(show)
    if show then
        local function _dismissCB()
            JJLog.i(TAG, "_dismissCB")
            self.noNetworkDialog_ = nil
        end

        local function _btn1CB()
            JJLog.i(TAG, "_btn1CB")
            Util:callNetworkSetting()
        end

        self.noNetworkDialog_ = UIUtil.showNoNetworkDialog(self, self.theme_, self.dimens_, _dismissCB, _btn1CB)
    else
        UIUtil.dismissDialog(self.noNetworkDialog_)
        self.noNetworkDialog_ = nil
    end
end

function MatchSelectScene:refreshBottomViewBtn()
    if self.currentView_ then
        self.currentView_:refreshBottomViewBtn()
    end
end

return MatchSelectScene
