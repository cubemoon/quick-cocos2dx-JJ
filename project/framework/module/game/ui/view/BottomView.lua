--[[
    主界面和比赛列表界面中，底端的菜单界面
]]
local rankInterface = require("game.thirds.RankInterface")
local roarInterface = require("game.thirds.RoarInterface")
local JJViewGroup = import("sdk.ui.JJViewGroup")
local BottomView = class("BottomView", JJViewGroup)
local WebViewController = require("game.ui.controller.WebViewController")
local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")

local TAG = "BottomView"

local ROAR_TYPE_ROAR = 0
local ROAR_TYPE_NEWS = 7
local ROAR_TYPE_QUESTION = 3

BottomView.STATE_INFO = 1 -- 只显示信息
BottomView.STATE_MENU = 2 -- 菜单
BottomView.viewState_ = BottomView.STATE_INFO

BottomView.time_ = nil -- 系统时间
BottomView.lastMin_ = nil -- 最后一次的分，用于优化刷新

local ACHIEVEMENT_CONTROLLER_PATH = "lordunion.ui.controller.LordUnionSingleAchievementSceneController"
local ACHIEVEMENT_SCENE_PATH = "lordunion.ui.scene.LordUnionSingleAchievementScene"
local PCENTER_CONTROLLER_PATH = "lordunion.ui.controller.LordUnionSinglePCenterSceneController"
local PCENTER_SCENE_PATH = "lordunion.ui.scene.LordUnionSinglePCenterScene"

local ID_BG_MASK = 1
local ID_MENU_BG = 3
local ID_INFO_BG = 4
local ID_TIME = 5

local ID_INFO_LAYER = 6
local ID_MENU_LAYER = 7

local menuHeight_ = 0
local infoLayerHeight_ = 34
local infoLayerMarginTop_ = 2
local initTop_ = 0

local _onClick = nil

local btnElementArray_ = {}
local bottomVisibleParams_ = {} --显示的menu项

local function _onClickMask(self)
    JJLog.i(TAG, "_onClickMask")
    self:changeState(self.STATE_INFO)
end

local function _updateTime(self)
    local date = os.date("*t", JJTimeUtil:getCurrentSecond())
    local hour, min = 0, 0
    if date ~= nil then
        hour, min = date.hour, date.min
    end

    if min ~= self.lastMin_ then
        self.lastMin_ = min
        local menuLayer = self:getViewById(ID_MENU_LAYER)
        if menuLayer ~= nil then
            local infoLayer = menuLayer:getViewById(ID_INFO_LAYER)
            if infoLayer ~= nil then
                local time = infoLayer:getViewById(ID_TIME)
                if time ~= nil then
                    time:setText(string.format("%02d:%02d", hour, min))
                end
            end
        end
    end
end

function BottomView:initBaseElement()

end

--[[
    参数
    @scene:
    @packageId:
    @gameId
    @scene:
    @dimens
]]
function BottomView:ctor(params)
    BottomView.super.ctor(self)

    infoLayerHeight_ = 34

    self.scene_ = params.scene
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.packageId_ = params.packageId
    self.gameId_ = params.gameId
    self.rowCount_ = self.gameId_ == JJGameDefine.GAME_ID_LORD_SINGLE and 1 or 2
    self.verCount_ = self.gameId_ == JJGameDefine.GAME_ID_LORD_SINGLE and 5 or 4
    self.topicUrl_ = params.topicUrl
    self.totalCount_ = 8 --总共8项
    self:setViewSize(self.dimens_.width, self.dimens_.height)
    self.singleUserInfoManager = params.singleUserInfoManager
    package.loaded["game.ui.BottomStyle"] = nil
    self.bottomStyleParams = require("game.ui.BottomStyle")

    menuHeight_ = self.dimens_:getDimens(145) * self.rowCount_ + self.dimens_:getDimens(20) * (2 - self.rowCount_)
    initTop_ = self.dimens_:getDimens(infoLayerHeight_ + infoLayerMarginTop_) - menuHeight_
    JJLog.i(TAG, "initTop_ is ", initTop_)

    -- 背景遮罩
    local bgMask = require("game.ui.view.JJFullScreenMask").new()
    bgMask:setId(ID_BG_MASK)
    self:addView(bgMask)
    bgMask:setVisible(false)
    bgMask:setOnClickListener(handler(self, _onClickMask))

    -- 菜单
    self.menuLayer = jj.ui.JJViewGroup.new()
    self.menuLayer:setId(ID_MENU_LAYER)
    self.menuLayer:setViewSize(self.dimens_.width, menuHeight_)
    self.menuLayer:setAnchorPoint(ccp(0, 0))
    self.menuLayer:setPosition(0, initTop_)
    self:addView(self.menuLayer)

    -- 菜单背景
    self.btnLayer_ = jj.ui.JJViewGroup.new()
    self.btnLayer_:setViewSize(self.dimens_.width, menuHeight_)
    self.btnLayer_:setAnchorPoint(ccp(0, 0))
    self.btnLayer_:setPosition(0, 0)
    self.menuLayer:addView(self.btnLayer_)
    self.btnLayer_:setVisible(false)

    -- 信息背景
    local infoBg = jj.ui.JJImage.new({
        image = self.theme_:getImage("bottomview/info_bg.png"),
    })
    infoBg:setId(ID_INFO_BG)
    -- infoBg:setScale(self.dimens_.scale_ * infoLayerHeight_ / 34)
    infoBg:setScale(self.dimens_.wScale_)
    -- infoBg:setScaleX(self.dimens_.wScale_)
    infoBg:setAnchorPoint(ccp(0, 1))
    infoBg:setPosition(0, menuHeight_ - self.dimens_:getDimens(infoLayerMarginTop_))
    self.menuLayer:addView(infoBg)

    -- 信息布局
    infoLayerHeight_ = infoLayerHeight_ * self.dimens_.scale_
    local infoLayer = jj.ui.JJViewGroup.new()
    infoLayer:setId(ID_INFO_LAYER)
    infoLayer:setViewSize(self.dimens_.width, infoLayerHeight_)
    infoLayer:setAnchorPoint(ccp(0, 1))
    infoLayer:setPosition(0, menuHeight_ - self.dimens_:getDimens(infoLayerMarginTop_))
    -- infoLayer:setScale(self.dimens_.scale_)
    self.menuLayer:addView(infoLayer)

    local left = self.dimens_:getDimens(10)
    local margin = self.dimens_:getDimens(10) -- 左右间隔
    -- 头像
    self.figureIcon_ = jj.ui.JJImage.new({
        image = "img/figure/jj_figure_default.png",
    })
    self.figureIcon_:setScale(30/144*self.dimens_.scale_)
    self.figureIcon_:setAnchorPoint(ccp(0, 0.5))
    self.figureIcon_:setPosition(left, infoLayerHeight_ / 2)
    infoLayer:addView(self.figureIcon_)

    left = left + self.dimens_:getDimens(30) + margin -- 图片宽度 + 间隔
    -- 昵称
    self.nickname_ = jj.ui.JJLabel.new({
        text = UserInfo.nickname_,
        fontSize = self.dimens_:getDimens(20),
        bSingleLine_ = true,
    })
    self.nickname_:setAnchorPoint(ccp(0, 0.5))
    self.nickname_:setPosition(left, infoLayerHeight_ / 2)
    infoLayer:addView(self.nickname_)

    left = left + self.dimens_:getDimens(100) + margin
    -- 金币
    self.goldIcon_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("bottomview/jj_gold.png"),
    })
    self.goldIcon_:setAnchorPoint(ccp(0, 0.5))
    self.goldIcon_:setPosition(left, infoLayerHeight_ / 2)
    self.goldIcon_:setScale(self.dimens_.scale_)
    infoLayer:addView(self.goldIcon_)

    left = left + self.dimens_:getDimens(30) + margin
    self.gold_ = jj.ui.JJLabel.new({
        text = tostring(UserInfo.gold_),
        fontSize = self.dimens_:getDimens(20),
        bSingleLine_ = true,
    })
    self.gold_:setAnchorPoint(ccp(0, 0.5))
    self.gold_:setPosition(left, infoLayerHeight_ / 2)
    infoLayer:addView(self.gold_)

    left = left + self.dimens_:getDimens(100) + margin
    -- 秋卡
    self.qiukaIcon_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("bottomview/qiuka.png"),
        viewSize = CCSize(30, 30),
    })
    self.qiukaIcon_:setAnchorPoint(ccp(0, 0.5))
    self.qiukaIcon_:setPosition(left, infoLayerHeight_ / 2)
    self.qiukaIcon_:setScale(self.dimens_.scale_)
    infoLayer:addView(self.qiukaIcon_)

    left = left + self.dimens_:getDimens(30) + margin
    self.qiuka_ = jj.ui.JJLabel.new({
        text = tostring(UserInfo:getQiuKaCount()),
        fontSize = self.dimens_:getDimens(20),
        bSingleLine_ = true,
    })
    self.qiuka_:setAnchorPoint(ccp(0, 0.5))
    self.qiuka_:setPosition(left, infoLayerHeight_ / 2)
    infoLayer:addView(self.qiuka_)

    local time = jj.ui.JJLabel.new({
            text = "系统时间",
            fontSize = self.dimens_:getDimens(20),
            bSingleLine_ = true,
        })
    time:setId(ID_TIME)
    time:setAnchorPoint(ccp(1, 0.5))
    time:setPosition((self.dimens_.width - self.dimens_:getDimens(20)), infoLayerHeight_ / 2)
    infoLayer:addView(time)

    _updateTime(self)
    self:refreshUserInfo()
end

function BottomView:initBtnLayer(refresh)
    -- 菜单: 分为两行、五列。从第一行第一个开始，按行进行布局
    JJLog.i(TAG, "initBtnLayer, self.btnLayer_=", self.btnLayer_, ", self.btnLayer_:getViewById(ID_MENU_BG)=", self.btnLayer_:getViewById(ID_MENU_BG))
    local menuBg = self.btnLayer_:getViewById(ID_MENU_BG)
    if self.btnLayer_ ~= nil and (menuBg == nil or refresh) then
        if (refresh and menuBg ~= nil) then
            menuBg:removeSelf()
        end
        local menuBg = jj.ui.JJImage.new({
            image = self.theme_:getImage("bottomview/menu_bg.jpg"),
        })
        menuBg:setId(ID_MENU_BG)
        menuBg:setScale(self.dimens_.scale_)
        menuBg:setAnchorPoint(ccp(0, 1))
        menuBg:setPosition(0, menuHeight_)
        menuBg:setTouchEnable(true)
        menuBg:setOnClickListener(handler(self, _onClick))
        self.btnLayer_:addView(menuBg)

        local lineHeight = (menuHeight_ - infoLayerHeight_) / self.rowCount_
        JJLog.i(TAG, "lineHeight is ", lineHeight)
        local itemWidth = self.dimens_.width / self.verCount_
        local txtMarginIcon = self.dimens_:getDimens(50) -- 文字和图片的间距
        local x = itemWidth / 2
        local y = lineHeight * 3 / 2 - (menuHeight_ - infoLayerHeight_ + 2) * (2 - self.rowCount_)
        local iconY = y + self.dimens_:getDimens(10) -- 图片比中心稍微偏移往上一些
        local fontSize = self.bottomStyleParams.fontSize
        local fontColor = self.bottomStyleParams.fontColor

        local btnWidth = self.gameId_ == JJGameDefine.GAME_ID_LORD_SINGLE and 168 or 210
        local btnHeight = 125
        -- 按钮的参数
        local btnParams = {
            images = {
                normal = "img/ui/transparence.png",
                highlight = self.theme_:getImage("bottomview/click.png"),
                scale9 = true,
            },
            viewSize = CCSize(btnWidth, btnHeight),
        }
        local index = 1
        btnElementArray_ = {}

        self:getBottomVisibleParams()
        for j=1, self.rowCount_ do
            if j > 1 then
                div = jj.ui.JJImage.new({
                    image = self.theme_:getImage("common/common_view_list_div_h.png"),
                })
                div:setPosition(self.dimens_.cx, lineHeight)
                div:setScaleX(self.dimens_.width / 23)
                div:setScaleY(self.dimens_.scale_)
                self.btnLayer_:addView(div)

                y = lineHeight / 2
                iconY = y + self.dimens_:getDimens(10)
                index = 1
            end
            for i=1, self.verCount_ do
                local arrayIndex = (j - 1)*self.verCount_ + i--计算数值下标
                if arrayIndex > self.totalCount_ then
                    break
                end
                local paramNum = #bottomVisibleParams_
                if arrayIndex <= paramNum then
                    local resElementArray = {}
                    local img = jj.ui.JJImage.new({
                    })
                    img:setAnchorPoint(ccp(0.5, 0.5))
                    img:setPosition(ccp(x * index, iconY))
                    img:setScale(self.dimens_.scale_)
                    resElementArray.img = img
                    self.btnLayer_:addView(img)

                    local btn = jj.ui.JJButton.new(btnParams)
                    btn:setAnchorPoint(ccp(0.5, 0.5))
                    btn:setPosition(x * index, y)
                    btn:setScale(self.dimens_.scale_)
                    resElementArray.btn = btn
                    self.btnLayer_:addView(btn)

                    btnTxt = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = self.dimens_:getDimens(fontSize),
                        color = fontColor,
                    })
                    btnTxt:setAnchorPoint(ccp(0.5, 0.5))
                    btnTxt:setPosition(x * index, iconY - txtMarginIcon)
                    -- btnTxt:setScale(self.dimens_.scale_)
                    resElementArray.btnTxt = btnTxt
                    table.insert(btnElementArray_, resElementArray)
                    self.btnLayer_:addView(btnTxt)

                    --创建时不特殊处理，刷新时也需要特殊处理
                    if self.gameId_ ~= JJGameDefine.GAME_ID_LORD_SINGLE then
                        JJLog.i(TAG, "bottomVisibleParams_[arrayIndex].id ", bottomVisibleParams_[arrayIndex].id)
                        JJLog.i(TAG, "self.bottomStyleParams.BOTTOM_MENU_PCENTER ", self.bottomStyleParams.BOTTOM_MENU_PCENTER)
                        if (bottomVisibleParams_[arrayIndex].id == self.bottomStyleParams.BOTTOM_MENU_PCENTER) then
                            --私信未读
                            local count = NoteManager:getUnreadCount(MainController:getCurPackageId(), UserInfo.userId_)
                            JJLog.i(TAG, "HallBottomView:ctor IN! and count : ", count)
--                            self.btnPcenterNew_ = jj.ui.JJImage.new({
--                                image = self.theme_:getImage("bottomview/roar_new_msg_icon.png"),
--                            })
--                            self.btnPcenterNew_:setAnchorPoint(ccp(0.5, 0.5))
--                            self.btnPcenterNew_:setPosition(ccp(x * index, iconY))
--                            self.btnPcenterNew_:setScale(self.dimens_.scale_)
--                            self.btnPcenterNew_:setVisible(count > 0)
--                            self.menuLayer:addView(self.btnPcenterNew_)

                            self.btnPcenterNew_= jj.ui.JJImage.new({
                                 image = self.theme_:getImage("pcenter/pcenter_remind_new.png"),
                                 --viewSize = params.btnSize,
                               })
                            self.btnPcenterNew_:setAnchorPoint(ccp(0.5, 0.5))
                            self.btnPcenterNew_:setPosition(x * index + self.dimens_:getDimens(btnWidth)/2 - self.dimens_:getDimens(75), iconY + self.dimens_:getDimens(btnHeight)/2 - self.dimens_:getDimens(40))
                            self.btnPcenterNew_:setScale(self.dimens_.scale_*0.8)
                            self.btnPcenterNew_:setVisible(count > 0)
                            self.menuLayer:addView(self.btnPcenterNew_)

                            self.tipLabel_ = jj.ui.JJLabel.new({
                                                singleLine = true,
                                                fontSize = self.dimens_:getDimens(13),
                                                color = ccc3(255,255,255),
                                                text = count,
                                                align = ui.TEXT_ALIGN_CENTER,
                                                viewSize = CCSize(self.dimens_:getDimens(30), self.dimens_:getDimens(30)),
                                            })
                            self.tipLabel_:setAnchorPoint(ccp(0.5, 0.5))
                            self.tipLabel_:setPosition(x * index + self.dimens_:getDimens(btnWidth)/2 - self.dimens_:getDimens(75), iconY + self.dimens_:getDimens(btnHeight)/2 - self.dimens_:getDimens(40))
                            self.tipLabel_:setVisible(count > 0)
                            self.menuLayer:addView(self.tipLabel_)
                        end
                    end
                    if (((bottomVisibleParams_[arrayIndex].id == self.bottomStyleParams.BOTTOM_MENU_FORUM)or(bottomVisibleParams_[arrayIndex].id == self.bottomStyleParams.BOTTOM_MENU_SINGLE_ROAR)) and (bottomVisibleParams_[arrayIndex].visible == true)) then
                        --咆哮未读
                        self.btnRoarNew_ = jj.ui.JJImage.new({
                            image = self.theme_:getImage("bottomview/roar_new_msg_icon.png"),
                        })
                        self.btnRoarNew_:setAnchorPoint(ccp(0.5, 0.5))
                        self.btnRoarNew_:setPosition(ccp(x * index, iconY))
                        self.btnRoarNew_:setScale(self.dimens_.scale_)
                        self.btnRoarNew_:setVisible(roarRemindMsgFlag_)
                        self.menuLayer:addView(self.btnRoarNew_)
                    end
                end

                index = index + 1
                local div = jj.ui.JJImage.new({
                    image = self.theme_:getImage("common/common_view_list_div_v.png"),
                })
                div:setPosition(x * index, y)
                div:setScaleX(self.dimens_.scale_)
                div:setScaleY(lineHeight / 23)
                self.btnLayer_:addView(div)

                index = index + 1
            end
        end

        if self.rowCount_ == 1 then
            self:initSingleLordData()
        else
            self:initLordData()
        end
    end
end

function BottomView:getBottomVisibleParams()
   JJLog.i(TAG, "getBottomVisibleParams is ", #self.bottomStyleParams.mergedParams)
   bottomVisibleParams_ = {}
   local originalBottomVisibleParams = {}
   if self.gameId_ ~= JJGameDefine.GAME_ID_LORD_SINGLE then
       originalBottomVisibleParams = self.bottomStyleParams.mergedParams
   else
       originalBottomVisibleParams = self.bottomStyleParams.mergedSingleLordParams
   end
   JJLog.i(TAG, "getBottomVisibleParams is ", #originalBottomVisibleParams)
   for i=1, #originalBottomVisibleParams do
       JJLog.i(TAG, "visible is ", originalBottomVisibleParams[i].visible == true, i)
       if (originalBottomVisibleParams[i].visible == true) then
          table.insert(bottomVisibleParams_, originalBottomVisibleParams[i])
       end
   end
   JJLog.i(TAG, vardump(bottomVisibleParams_,"bottomVisibleParams_"))
end

function BottomView:initLordData()
    if btnElementArray_ then
        for k,v in pairs(btnElementArray_) do
            if v and v.img then
                if bottomVisibleParams_[k].iconNormal ~= "" then
                    local image = self.theme_:getImage(bottomVisibleParams_[k].iconNormal)
                    if image then
                        v.img:setImage(image,false)
                    end
                end
                v.btnTxt:setText(bottomVisibleParams_[k].text)

                v.img:setVisible(bottomVisibleParams_[k].visible)
                v.btnTxt:setVisible(bottomVisibleParams_[k].visible)
            end
        end
        self:initLordOnClickListener()
    end
end

function BottomView:initSingleLordData()
    if btnElementArray_ then
        JJLog.i(TAG, "initSingleLordData IN btnElementArray_ size is ", #btnElementArray_)
        for k,v in pairs(btnElementArray_) do
        JJLog.i(TAG, "initSingleLordData IN k is ", k)
            if v and v.img then
                if bottomVisibleParams_[k].iconNormal ~= "" then
                    local image = self.theme_:getImage(bottomVisibleParams_[k].iconNormal)
                    if image then
                        v.img:setImage(image,false)
                    end
                end
                v.btnTxt:setText(bottomVisibleParams_[k].text)

                v.img:setVisible(bottomVisibleParams_[k].visible)
                v.btnTxt:setVisible(bottomVisibleParams_[k].visible)
            end
        end
        self:initSingleLordOnClickListener()
    end
end

function BottomView:initLordOnClickListener()
    if btnElementArray_ and self.bottomStyleParams.lordOnClickListenerArray then
        for k,v in pairs(btnElementArray_) do
            JJLog.i(TAG, "initLordOnClickListener IN self.bottomStyleParams.lordOnClickListenerArray[k] is ", bottomVisibleParams_[k].OnClickListener)
            if v and bottomVisibleParams_[k].OnClickListener then
                JJLog.i(TAG, "v.btnTxt:getText() is ", v.btnTxt:getText())
                if bottomVisibleParams_[k].visible then
                    v.btn:setTouchEnable(true)
                    v.btn:setOnClickListener(handler(self, bottomVisibleParams_[k].OnClickListener))
                    if v.btnTxt:getText() == "" then
                        v.btn.images_ = nil
                        v.btn:_updateButtonImage()
                    end
                else
                    v.btn:setTouchEnable(false)
                end
            end
        end
    end
end

function BottomView:initSingleLordOnClickListener()
    if btnElementArray_ and self.bottomStyleParams.singleLordOnClickListenerArray then
        for k,v in pairs(btnElementArray_) do
            if v and bottomVisibleParams_[k].OnClickListener then
                if bottomVisibleParams_[k].visible then
                    v.btn:setTouchEnable(true)
                    v.btn:setOnClickListener(handler(self, bottomVisibleParams_[k].OnClickListener))
                else
                    v.btn:setTouchEnable(false)
                end
            end
        end
    end
end

--[[
    触屏消息处理
]]
function BottomView:onTouch(event, x, y)
    JJLog.i(TAG, "onTouch, event=", event, ", x=", x, ", y=", y)
    local ret = false
    if event == "began" and self.viewState_ == self.STATE_INFO and y <= infoLayerHeight_ then
        self.touchDownY_ = y
        ret = true

    elseif event == "moved" and self.touchDownY_ ~= 0 and (y-self.touchDownY_) > self.dimens_:getDimens(20) then
        self.touchDownY_ = 0
        self:changeState(self.STATE_MENU)
        ret = true

    elseif event == "ended" then

        self.touchDownY_ = 0
        ret = true
    end
    return ret
end

function BottomView:onEnter()
    JJLog.i(TAG, "BottomView:onEnter")
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    self.scheduleHandler_ = scheduler.scheduleGlobal(handler(self, _updateTime), 1)
end

function BottomView:onExit()
    JJLog.i(TAG, "BottomView:onExit")
    if self.scheduleHandler_ ~= nil then
        local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
        scheduler.unscheduleGlobal(self.scheduleHandler_)
        self.scheduleHandler_ = nil
    end
    if self.btnLayer_ ~= nil then
        self.btnLayer_ = nil
    end
    if self.bottomStyleParams ~= nil then
        self.bottomStyleParams = nil
    end
end

--[[
    切换到信息状态
]]
local function _changeToInfo(self)
    JJLog.i(TAG, "_changeToInfo")
    self.viewState_ = self.STATE_INFO
    local bgMask = self:getViewById(ID_BG_MASK)
    if bgMask ~= nil then
        bgMask:setVisible(false)
    end

    local menuLayer = self:getViewById(ID_MENU_LAYER)
    if menuLayer ~= nil then
        menuLayer:stopAllActions()
        menuLayer:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.1, ccp(0, initTop_)), CCCallFuncN:create(function()
            local menuLayer = self:getViewById(ID_MENU_LAYER)
            if menuLayer ~= nil then
                if self.btnLayer_ ~= nil then
                    self.btnLayer_:setVisible(false)
                end
            end
        end)))
    end
end

--[[
    切换到菜单状态
]]
local function _changeToMenu(self)
    JJLog.i(TAG, "_changeToMenu")
    self.viewState_ = self.STATE_MENU

    local bgMask = self:getViewById(ID_BG_MASK)
    if bgMask ~= nil then
        bgMask:setVisible(true)
    end

    local menuLayer = self:getViewById(ID_MENU_LAYER)
    if menuLayer ~= nil then
        menuLayer:stopAllActions()
        menuLayer:runAction(CCMoveTo:create(0.1, ccp(0, 0)))
        if self.btnLayer_ ~= nil then
            self:initBtnLayer()
            self.btnLayer_:setVisible(true)
        end
    end
end

--[[
    是否打开的 Menu 状态
]]
function BottomView:isOpen()
    return self.viewState_ == self.STATE_MENU
end

--[[
    切换状态
    @state: 为空切换到另一个状态
]]
function BottomView:changeState(state)
    JJLog.i(TAG, "changeState, state=", state)
    if state == nil then
        if self.viewState_ == self.STATE_INFO then
            state = self.STATE_MENU
        else
            state = self.STATE_INFO
        end
    end

    if state == self.STATE_INFO then
        _changeToInfo(self)
    else
        _changeToMenu(self)
    end
end

function BottomView:setUserInco(imagePath)
    if self.theme_:getImage(imagePath) then
        self.figureIcon_:setImage(self.theme_:getImage(imagePath),false)
    end
end

function BottomView:setUserName(userName)
    if userName then
        self.nickname_:setText(userName)
    end
    self:refreshInfoPosition()
end

function BottomView:setGoldIcon(imagePath)
    if self.theme_:getImage(imagePath) then
        self.goldIcon_:setImage(self.theme_:getImage(imagePath),false)
    end
end

function BottomView:setUserCopper(userCopper)
    if userCopper then
        self.gold_:setText(userName)
    end
    self:refreshInfoPosition()
end

function BottomView:setUserLevelIcon(imagePath)
    if self.theme_:getImage(imagePath) then
        self.qiukaIcon_:setImage(self.theme_:getImage(imagePath),false)
    end
end

function BottomView:setUserLevel(level)
    if level then
        self.qiuka_:setText(userName)
    end
end

function BottomView:refreshInfoPosition()
    local left = self.dimens_:getDimens(50) -- 10 + 30 + 10
    local marginIconText = self.dimens_:getDimens(6) -- 文字和自己图片的距离
    local margin = self.dimens_:getDimens(50) -- 图片和上一个文字最右边的距离
    local iconWidth = self.dimens_:getDimens(30)

    local width = self.nickname_:getWidth()
    left = left + width + margin
    self.goldIcon_:setPositionX(left)

    left = left + iconWidth + marginIconText
    self.gold_:setPositionX(left)

    width = self.gold_:getWidth()
    left = left + width + margin
    self.qiukaIcon_:setPositionX(left)

    left = left + iconWidth + marginIconText
    self.qiuka_:setPositionX(left)
end

function BottomView:onClickDoNothing()
end

function BottomView:chargeBtnOnClick()
    JJLog.i(TAG, "_onClick, btnCharge_")
    if MainController:isLogin() then
        local pcm = require("game.data.config.PayConfigManager")
        PayDef:chargeBtnHandler(pcm:getParam())
    else
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

function BottomView:inventoryBtnOnClick()
    JJLog.i(TAG, "_onClick, btnInventory_")
    if MainController:isLogin() then
        WebViewController:showActivity({
            title = "我的物品箱",
            back = true,
            sso = true,
            url = JJWebViewUrlDef.URL_GOODS_LIST
        })
    else
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

function BottomView:warecomposeBtnOnClick()
    JJLog.i(TAG, "_onClick, btnWarecompose_")
    if MainController:isLogin() then
        WebViewController:showActivity({
            title = "合成炉",
            back = true,
            sso = true,
            url = JJWebViewUrlDef.URL_COMPOSE
        })
    else
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

function BottomView:exchangeBtnOnClick()
    JJLog.i(TAG, "_onClick, btnExchange_")
    if MainController:isLogin() then
        WebViewController:showActivity({
            title = "兑奖中心",
            back = true,
            sso = true,
            url = JJWebViewUrlDef.URL_SHOP
        })
    else
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

function BottomView:switchAccountBtnOnClick()
    JJLog.i(TAG, "_onClick, btnSwitchAccount_")
    MainController:pushScene(self.packageId_,  JJSceneDef.ID_JJ_LOGIN)
end

function BottomView:roarBtnOnClick()
    JJLog.i(TAG, "_onClick, btnRoar_")
    if MainController:isLogin() then
        roarInterface:enteRoar(0)
        JJLog.i(TAG, "_onClick, btnRoar_ 2")
    else
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

function BottomView:personalCenterBtnOnClick()
    JJLog.i(TAG, "_onClick, btnPersonalCenter_")
    if MainController:isLogin() then
        MainController:pushScene(self.packageId_,  JJSceneDef.ID_PERSONAL_CENTER)
    else
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

function BottomView:rankingBtnOnClick()
    JJLog.i(TAG, "_onClick, btnRanking_")
    if MainController:isLogin() then
        JJLog.i(TAG, "_onClick, btnRanking_ 2")
        rankInterface:enteRank(2)
    else
        JJLog.i(TAG, "_onClick, btnRanking_ 3")
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

function BottomView:topicBtnOnClick()
    JJLog.i(TAG, "_onClick, btnTopic_")
    if MainController:isLogin() then
        local url = ""
        if self.topicUrl_ then
            url = self.topicUrl_
        else
            url = JJWebViewUrlDef[self.gameId_]
        end
        WebViewController:showActivity({
                title = "活动",
                back = true,
                sso = false,
                url = url
            })
    else
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

function BottomView:settingsBtnOnClick()
    JJLog.i(TAG, "_onClick, btnSettings_")
    MainController:pushScene(self.packageId_, JJSceneDef.ID_SETTINGS)
end

function BottomView:singleLordPcenterBtnOnClick()
    JJLog.i(TAG, "_onClick, btnSinglePcenter_")
    JJSDK:pushScene(JJSceneDef.ID_PERSONAL_CENTER_SINGLE, PCENTER_CONTROLLER_PATH, PCENTER_SCENE_PATH)
end

function BottomView:singleLordAchievementBtnOnClick()
    JJLog.i(TAG, "_onClick, btnAchievement_")
    JJSDK:pushScene(JJSceneDef.ID_ACHIEVEMENT_SINGLE, ACHIEVEMENT_CONTROLLER_PATH, ACHIEVEMENT_SCENE_PATH)
end

function BottomView:singleLordRoarBtnOnClick()
    JJLog.i(TAG, "_onClick, singlelord btnRoar_")
    if MainController:checkConnectedForSingleLordRoar() then
        roarInterface:enteRoar(ROAR_TYPE_ROAR)
        JJLog.i(TAG, "_onClick, btnRoar_ 2")
    else
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

function BottomView:singleLordNewsBtnOnClick()
    JJLog.i(TAG, "_onClick, btnNews_")
    if MainController:checkConnectedForSingleLordRoar() then
        roarInterface:enteRoar(ROAR_TYPE_NEWS)
        JJLog.i(TAG, "_onClick, btnNews_ 2")
    else
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

function BottomView:singleLordQuestionBtnOnClick()
    JJLog.i(TAG, "_onClick, btnQuestion_")
    if MainController:checkConnectedForSingleLordRoar() then
        roarInterface:enteRoar(ROAR_TYPE_QUESTION)
        JJLog.i(TAG, "_onClick, btnQuestion_ 2")
    else
        if self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

--[[
    按键响应
    @target
]]
function _onClick(self, target)

end

--[[
    刷新用户信息
]]
function BottomView:refreshUserInfo(upd)
    JJLog.i(TAG, "refreshUserInfo")
    if self.gameId_ ~= JJGameDefine.GAME_ID_LORD_SINGLE then
        if UserInfo:isLogin() then
            local path = HeadImgManager:getImg(UserInfo.userId_, UserInfo.figureId_) --HeadImgManager:getImg(UserInfo.figureId_)
            if path ~= nil then
                local texture = CCTextureCache:sharedTextureCache():addImage(path)
                -- 如需要更新，需要从新创建一下头像缓存
                if upd and texture then
                    CCTextureCache:sharedTextureCache():removeTexture(texture)
                    texture = CCTextureCache:sharedTextureCache():addImage(path)
                end

                if texture ~= nil then
                    self.figureIcon_:setTexture(texture)
                end
            end

            self.nickname_:setText(UserInfo.nickname_)
            self.gold_:setText(tostring(UserInfo.gold_))
            self.qiuka_:setText(tostring(UserInfo:getQiuKaCount()))
        else
            JJLog.i(TAG, "refresh to default")
            local texture = CCTextureCache:sharedTextureCache():addImage("img/figure/jj_figure_default.png")
            self.figureIcon_:setTexture(texture)
            self.nickname_:setText("")
            self.gold_:setText("")
            self.qiuka_:setText("")
        end


        local left = self.dimens_:getDimens(50) -- 10 + 30 + 10
        local marginIconText = self.dimens_:getDimens(6) -- 文字和自己图片的距离
        local margin = self.dimens_:getDimens(50) -- 图片和上一个文字最右边的距离
        local iconWidth = self.dimens_:getDimens(30)

        local width = self.nickname_:getWidth()
        left = left + width + margin
        self.goldIcon_:setPositionX(left)

        left = left + iconWidth + marginIconText
        self.gold_:setPositionX(left)

        width = self.gold_:getWidth()
        left = left + width + margin
        self.qiukaIcon_:setPositionX(left)

        left = left + iconWidth + marginIconText
        self.qiuka_:setPositionX(left)
    else
        if self.nickname_ then
            self.nickname_:setText(self.bottomStyleParams.singleLordUserName)
        end
        if self.figureIcon_ then
            self.figureIcon_:setImage(self.theme_:getImage(self.bottomStyleParams.singleLordUserIcon),false)
        end
        if self.goldIcon_ then
            self.goldIcon_:setImage(self.theme_:getImage(self.bottomStyleParams.singleLordGoldIcon),false)
        end
        if self.qiukaIcon_ then
            self.qiukaIcon_:setImage(self.theme_:getImage(self.bottomStyleParams.singleLordLevelIcon),false)
        end
        if self.gold_ and self.qiuka_ then
            JJLog.i(TAG, "initSingleLordData IN self.singleUserInfoManager is ", self.singleUserInfoManager)
            if self.singleUserInfoManager then
                local singleUserData = self.singleUserInfoManager:getSingleUserInfo()
                if singleUserData then
                    self.gold_:setText(tostring(singleUserData.copper_))
                end
                self.qiuka_:setText(tostring(self.singleUserInfoManager:getLevel()))
            end
        end

        self:refreshInfoPosition()
    end
end

function BottomView:updatePcenterNewMsgInfo(count)
    if self.btnPcenterNew_ and self.gameId_ ~= JJGameDefine.GAME_ID_LORD_SINGLE then
        if count > 0 then
            self.btnPcenterNew_:setVisible(true)
            if self.tipLabel_ then
                self.tipLabel_:setText(count)
            end

        else
            self.btnPcenterNew_:setVisible(false)
            if self.tipLabel_ then
                self.tipLabel_:setVisible(false)
            end
        end


    end
end

function BottomView:updateRoarNewMsgInfo()
   JJLog.i(TAG, "updateRoarNewMsgInfo")
   if self.btnRoarNew_ then
        self.btnRoarNew_:setVisible(roarRemindMsgFlag_)
   end
end

function BottomView:refreshBtn()
    JJLog.i(TAG,"refreshBtn")
    if self.gameId_ ~= JJGameDefine.GAME_ID_LORD_SINGLE then
        self.bottomStyleParams.lordVisibleArray = {
          DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_CHARGE),
          true,
          DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_EXCHANGE_PRIZE),
          DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_WARE),
          DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR),
          DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_RANK),
          DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_TOPIC),
          true,
        }
        self.bottomStyleParams.mergedParams[1].visible = self.bottomStyleParams.lordVisibleArray[1]
        self.bottomStyleParams.mergedParams[2].visible = self.bottomStyleParams.lordVisibleArray[2]
        self.bottomStyleParams.mergedParams[3].visible = self.bottomStyleParams.lordVisibleArray[3]
        self.bottomStyleParams.mergedParams[4].visible = self.bottomStyleParams.lordVisibleArray[4]
        self.bottomStyleParams.mergedParams[5].visible = self.bottomStyleParams.lordVisibleArray[5]
        self.bottomStyleParams.mergedParams[6].visible = self.bottomStyleParams.lordVisibleArray[6]
        self.bottomStyleParams.mergedParams[7].visible = self.bottomStyleParams.lordVisibleArray[7]
        self.bottomStyleParams.mergedParams[8].visible = self.bottomStyleParams.lordVisibleArray[8]
--        self:initLordData()
    else
        self.bottomStyleParams.singleLordVisibleArray = {
          true,
          true,
          DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR),
          DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR),
          DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR),
        }
        self.bottomStyleParams.mergedSingleLordParams[1].visible = self.bottomStyleParams.singleLordVisibleArray[1]
        self.bottomStyleParams.mergedSingleLordParams[2].visible = self.bottomStyleParams.singleLordVisibleArray[2]
        self.bottomStyleParams.mergedSingleLordParams[3].visible = self.bottomStyleParams.singleLordVisibleArray[3]
        self.bottomStyleParams.mergedSingleLordParams[4].visible = self.bottomStyleParams.singleLordVisibleArray[4]
        self.bottomStyleParams.mergedSingleLordParams[5].visible = self.bottomStyleParams.singleLordVisibleArray[5]
--        self:initSingleLordData()
    end
--    if self.btnLayer_ ~= nil then
--        self.btnLayer_:removeSelf()
--        self.btnLayer_ = nil
--    end
    self:initBtnLayer(true)
end

return BottomView