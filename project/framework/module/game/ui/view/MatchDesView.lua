local JJViewGroup = import("sdk.ui.JJViewGroup")

local MatchDesView = class("MatchDesView", JJViewGroup)
local CannotSignupDialog = import(".CannotSignupDialog")

local function _onClickMask(self)
    self.scene_:removeMatchDesView()
end

MatchDesView.signBgNormal_ = "matchselect/match_item_detail_signup_new_btn_n.png"
MatchDesView.signBgHighlight_ = "matchselect/match_item_detail_signup_new_btn_d.png"
MatchDesView.unsignBgNormal_ = "matchselect/match_item_detail_unsignup_new_btn_n.png"
MatchDesView.unsignBgHighlight_ = "matchselect/match_item_detail_unsignup_new_btn_d.png"
MatchDesView.signBgDisable_ = "matchselect/match_item_detail_signup_new_btn_disable.png"
function MatchDesView:ctor(params, customParam)
    MatchDesView.super.ctor(self)

    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.scene_ = params.scene
    self.gameId_ = params.gameId
    self.packageId_ = params.packageId
    self.scheduler_ = require(cc.PACKAGE_NAME .. ".scheduler")
    self.isLordSingle_ = self.gameId_ == JJGameDefine.GAME_ID_LORD_SINGLE
    self.customParam_ = customParam
    local isSelectTable = false

    if self.isLordSingle_ then
        self.singleMatchData_ = params.singleMatchData
        self.entryFee_ = self.singleMatchData_.signupcost
        self.singleGameManager = params.singleGameManager
        self.singleGameMatchPromotionManager = params.singleGameMatchPromotionManager
        self.singleGameManager:setCurrentMatch(self.singleMatchData_.matchid)
    else
        self.tourneyInfo_ = params.tourneyInfo
        self.entryFee_ = self.tourneyInfo_:getEntryFee()
        isSelectTable = self.tourneyInfo_:isSelectTable()
    end

    self.entryIndex_ = 1
    self.width_ = self.dimens_:getDimens(671)
    self.height_ = self.dimens_:getDimens(355)
    local menuWidth = self.dimens_:getDimens(280)
    local marginLeft = (self.dimens_.width - self.width_) / 2
    local left = marginLeft
    local marginTop = (self.dimens_.height - self.height_) / 2 + self.height_
    local top = marginTop
    self:setViewSize(self.dimens_.width, self.dimens_.height)
    -- 背景遮罩
    self.bgMask_ = require("game.ui.view.JJFullScreenMask").new()
    self:addView(self.bgMask_)
    self.bgMask_:setOnClickListener(handler(self, _onClickMask))

    -- 背景框
    self.bg_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_dialog_small.png"),
    })
    self.bg_:setAnchorPoint(ccp(0, 1))
    self.bg_:setPosition(left, top)
    self.bg_:setScale(self.dimens_.scale_)
    self.bg_:setTouchEnable(true)
    self.bg_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.bg_)

    local fntSize = self.dimens_:getDimens(self.customParam_.matchDesTitleFontSize)
    -- 标题
    self.matchName_ = jj.ui.JJLabel.new({
        singleLine = true,
        fontSize = fntSize,
        color = self.customParam_.matchDesTitleFontColor,
        text = "200金币入场",
    })
    top = marginTop - self.dimens_:getDimens(30)
    self.matchName_:setAnchorPoint(ccp(0.5, 1))
    self.matchName_:setPosition(self.dimens_.width / 2, top)
    self:addView(self.matchName_)

    --分割线
    left = self.dimens_:getDimens(20)
    top = marginTop - self.dimens_:getDimens(80)
    self.split_h_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_split_h.png"),
        scale9 = true,
        viewSize = CCSize(self.width_ - self.dimens_:getDimens(80), 2)
    })
    self.split_h_:setAnchorPoint(ccp(0.5, 1))
    self.split_h_:setPosition(self.dimens_.width / 2, top)
    self:addView(self.split_h_)

    -- 关闭按钮
    self.btnClose_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_dialog_close_btn_n.png"),
            highlight = self.theme_:getImage("common/common_dialog_close_btn_d.png"),
        },
    })
    left = marginLeft + self.width_ - self.dimens_:getDimens(15)
    top = marginTop - self.dimens_:getDimens(15)
    self.btnClose_:setAnchorPoint(ccp(0.5, 0.5))
    self.btnClose_:setPosition(left, top)
    self.btnClose_:setScale(self.dimens_.scale_)
    self.btnClose_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnClose_)

    -- 返回按钮
    left = self.dimens_:getDimens(10) + marginLeft
    self.btnReturn_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("matchselect/return_btn_n.png"),
            highlight = self.theme_:getImage("matchselect/return_btn_d.png"),
        },
    })
    self.btnReturn_:setAnchorPoint(ccp(0, 1))
    self.btnReturn_:setPosition(left, marginTop - self.dimens_:getDimens(5))
    self.btnReturn_:setVisible(false)
    self.btnReturn_:setScale(self.dimens_.scale_)
    self.btnReturn_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnReturn_)

    self.contentHeight_ = self.dimens_:getDimens(260)
    left = marginLeft + self.dimens_:getDimens(30)
    top = marginTop - self.dimens_:getDimens(80)
    self.contentLayer_ = jj.ui.JJViewGroup.new()
    self.contentLayer_:setViewSize(self.width_, self.contentHeight_)
    self.contentLayer_:setAnchorPoint(ccp(0, 1))
    self.contentLayer_:setPosition(left, top)
    self:addView(self.contentLayer_)

    -- 开赛时间
    left = 0
    top = self.contentHeight_
    self.matchPointLayer_ = jj.ui.JJViewGroup.new()
    self.matchPointLayer_:setViewSize(menuWidth, self.dimens_:getDimens(85))
    self.matchPointLayer_:setAnchorPoint(ccp(0, 1))
    self.matchPointLayer_:setPosition(left, top)
    self.contentLayer_:addView(self.matchPointLayer_)

    left = self.dimens_:getDimens(20)
    top = self.dimens_:getDimens(20)
    self.matchPoint_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_match_point.png"),
    })
    self.matchPoint_:setAnchorPoint(ccp(0, 0))
    self.matchPoint_:setPosition(left, top)
    self.matchPoint_:setScale(self.dimens_.scale_)
    self.matchPointLayer_:addView(self.matchPoint_)

    fntSize = self.dimens_:getDimens(self.customParam_.matchDesTimeProFontSize)
    local fontColor = self.customParam_.matchDesTimeProFontColor
    left = left + self.dimens_:getDimens(45)
    top = self.dimens_:getDimens(25)
    self.timeTitle_ = jj.ui.JJLabel.new({
        singleLine = true,
        fontSize = fntSize,
        color = fontColor,
        text = "开赛时间:",
    })
    self.timeTitle_:setAnchorPoint(ccp(0, 0))
    self.timeTitle_:setPosition(left, top)
    self.matchPointLayer_:addView(self.timeTitle_)

    left = left + self.timeTitle_:getViewSize().width + self.dimens_:getDimens(5)
    top = self.dimens_:getDimens(40)
    fntSize = self.dimens_:getDimens(self.customParam_.matchDesTimeFontSize)
    fontColor = self.customParam_.matchDesTimeFontColor
    local width = menuWidth - left
    self.timeLabel_ = jj.ui.JJLabel.new({
        singleLine = false,
        fontSize = fntSize,
        color = fontColor,
        text = "报名即开",
        viewSize = CCSize(width, self.dimens_:getDimens(60))
    })
    self.timeLabel_:setAnchorPoint(ccp(0, 0.5))
    self.timeLabel_:setPosition(left, top)
    self.matchPointLayer_:addView(self.timeLabel_)

    -- 分割线
    left = self.dimens_:getDimens(20)
    top = self.contentHeight_ - self.dimens_:getDimens(85)
    local split_h = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_split_h.png"),
        scale9 = true,
        viewSize = CCSize(menuWidth - self.dimens_:getDimens(20), 2)
    })
    split_h:setAnchorPoint(ccp(0, 1))
    split_h:setPosition(left, top)
    self.contentLayer_:addView(split_h)


    -- 比赛详情
    left = 0
    top = self.contentHeight_ - self.dimens_:getDimens(80 + 2)
    self.matchInfoLayer_ = jj.ui.JJViewGroup.new()
    self.matchInfoLayer_:setViewSize(menuWidth, self.dimens_:getDimens(85))
    self.matchInfoLayer_:setAnchorPoint(ccp(0, 1))
    self.matchInfoLayer_:setPosition(left, top)
    self.matchInfoLayer_:setOnClickListener(handler(self, self.onClick))
    self.contentLayer_:addView(self.matchInfoLayer_)

    left = self.dimens_:getDimens(20)
    top = self.dimens_:getDimens(20)
    local matchInfoIcon = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_match_info_icon.png"),
    })
    matchInfoIcon:setAnchorPoint(ccp(0, 0))
    matchInfoIcon:setPosition(left, top)
    matchInfoIcon:setScale(self.dimens_.scale_)
    self.matchInfoLayer_:addView(matchInfoIcon)

    left = left + self.dimens_:getDimens(45)
    top = self.dimens_:getDimens(25)
    fntSize = self.dimens_:getDimens(self.customParam_.matchDesInfoFontSize)
    fontColor = self.customParam_.matchDesInfoFontColor
    local matchInfoText = jj.ui.JJLabel.new({
        singleLine = true,
        fontSize = fntSize,
        color = fontColor,
        text = "比赛详情",
    })
    matchInfoText:setAnchorPoint(ccp(0, 0))
    matchInfoText:setPosition(left, top)
    self.matchInfoLayer_:addView(matchInfoText)

    left = left + matchInfoText:getViewSize().width + self.dimens_:getDimens(60)
    top = self.dimens_:getDimens(20)
    local matchInfoArrow = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_button_arrow.png"),
    })
    matchInfoArrow:setAnchorPoint(ccp(0, 0))
    matchInfoArrow:setPosition(left, top)
    matchInfoArrow:setScale(self.dimens_.scale_)
    self.matchInfoLayer_:addView(matchInfoArrow)

    --分割线
    left = self.dimens_:getDimens(20)
    top = self.contentHeight_ - self.dimens_:getDimens(85 + 85 + 2)
    split_h = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_split_h.png"),
        scale9 = true,
        viewSize = CCSize(menuWidth - self.dimens_:getDimens(20), 2)
    })
    split_h:setAnchorPoint(ccp(0, 1))
    split_h:setPosition(left, top)
    self.contentLayer_:addView(split_h)

    -- 奖励方案
    left = 0
    top = self.contentHeight_ - self.dimens_:getDimens(80 + 85 + 4)
    self.matchAwardLayer_ = jj.ui.JJViewGroup.new()
    self.matchAwardLayer_:setViewSize(menuWidth, self.dimens_:getDimens(75))
    self.matchAwardLayer_:setAnchorPoint(ccp(0, 1))
    self.matchAwardLayer_:setPosition(left, top)
    self.matchAwardLayer_:setOnClickListener(handler(self, self.onClick))
    self.contentLayer_:addView(self.matchAwardLayer_)

    left = self.dimens_:getDimens(20)
    top = self.dimens_:getDimens(15)
    local matchAwardIcon = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_arward_icon.png"),
    })
    matchAwardIcon:setAnchorPoint(ccp(0, 0))
    matchAwardIcon:setPosition(left, top)
    matchAwardIcon:setScale(self.dimens_.scale_)
    self.matchAwardLayer_:addView(matchAwardIcon)

    left = left + self.dimens_:getDimens(45)
    top = self.dimens_:getDimens(20)
    fntSize = self.dimens_:getDimens(self.customParam_.matchDesAwardFontSize)
    fontColor = self.customParam_.matchDesAwardFontColor
    local matchAwardText = jj.ui.JJLabel.new({
        singleLine = true,
        fontSize = fntSize,
        color = fontColor,
        text = "奖励方案",
    })
    matchAwardText:setAnchorPoint(ccp(0, 0))
    matchAwardText:setPosition(left, top)
    self.matchAwardLayer_:addView(matchAwardText)

    left = left + matchInfoText:getViewSize().width + self.dimens_:getDimens(60)
    top = self.dimens_:getDimens(15)
    local matchInfoArrow = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_button_arrow.png"),
    })
    matchInfoArrow:setAnchorPoint(ccp(0, 0))
    matchInfoArrow:setPosition(left, top)
    matchInfoArrow:setScale(self.dimens_.scale_)
    self.matchAwardLayer_:addView(matchInfoArrow)

    -- 分割线

    left = menuWidth + self.dimens_:getDimens(20)
    top = self.contentHeight_ - self.dimens_:getDimens(15)
    split_h = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_split_v.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_:getDimens(2), self.dimens_:getDimens(230))
    })
    split_h:setAnchorPoint(ccp(0, 1))
    split_h:setPosition(left, top)
    self.contentLayer_:addView(split_h)

    -- 报名条件以及报名按钮区域

    left = menuWidth + self.dimens_:getDimens(20 + 35 + 5)
    top = self.contentHeight_
    self.signupLayer_ = jj.ui.JJViewGroup.new()
    self.signupLayer_:setViewSize(self.dimens_:getDimens(280), self.dimens_:getDimens(280))
    self.signupLayer_:setAnchorPoint(ccp(0, 1))
    self.signupLayer_:setPosition(left, top)
    self.contentLayer_:addView(self.signupLayer_)

    left = self.dimens_:getDimens(280 / 2) - self.dimens_:getDimens(12)
    top = self.dimens_:getDimens(280 - 130)
    local signupsize = CCSize(self.dimens_:getDimens(252), self.dimens_:getDimens(110))
    local tablesize = CCSize(self.dimens_:getDimens(200), self.dimens_:getDimens(70))
    if (isSelectTable) then
        signupsize = tablesize
        top = top + self.dimens_:getDimens(40)
        self.signBgNormal_ = "matchselect/match_item_detail_signup_samll_btn_n.png"
        self.signBgHighlight_ = "matchselect/match_item_detail_signup_samll_btn_d.png"
        self.signBgDisable_ = "matchselect/match_item_detail_signup_samll_btn_disable.png"
        self.unsignBgNormal_ = "matchselect/match_item_detail_unsignup_small_btn_n.png"
        self.unsignBgHighlight_ = "matchselect/match_item_detail_unsignup_small_btn_d.png"
    end

    self.btnSignup_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage(self.signBgNormal_),
            highlight = self.theme_:getImage(self.signBgHighlight_),
            disable = self.theme_:getImage(self.signBgDisable_),
            --            scale9 = true,
            viewSize = signupsize
        },
        fontSize = self.dimens_:getDimens(36),
        color = display.COLOR_WHITE,
        text = "报 名",
        viewSize = signupsize
    })
    self.btnSignup_:setAnchorPoint(ccp(0.5, 1))
    self.btnSignup_:setPosition(left, top)
    -- self.btnSignup_:setScale(self.dimens_.scale_)
    self.btnSignup_:setOnClickListener(handler(self, self.onClick))
    self.signupLayer_:addView(self.btnSignup_)

    top = self.dimens_:getDimens(100)
    self.btnTableSelect_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("matchselect/match_item_detail_signup_samll_btn_n.png"),
            highlight = self.theme_:getImage("matchselect/match_item_detail_signup_samll_btn_d.png"),
            disable = self.theme_:getImage("matchselect/match_item_detail_signup_samll_btn_disable.png"),
            --            scale9 = true,
            viewSize = tablesize
        },
        fontSize = self.dimens_:getDimens(36),
        color = display.COLOR_WHITE,
        text = "选 桌",
        viewSize = tablesize
    })
    self.btnTableSelect_:setAnchorPoint(ccp(0.5, 1))
    self.btnTableSelect_:setPosition(left, top)
    -- self.btnTableSelect_:setScale(self.dimens_.scale_)
    self.btnTableSelect_:setVisible(isSelectTable)
    self.btnTableSelect_:setOnClickListener(handler(self, self.onClick))
    self.signupLayer_:addView(self.btnTableSelect_)

    self.btnConditionBg_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_condition_bg.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_:getDimens(252), self.dimens_:getDimens(56))
    })
    self.btnConditionBg_:setAnchorPoint(ccp(0, 1))
    self.btnConditionBg_:setPosition(0, self.dimens_:getDimens(280 - 20))
    self.signupLayer_:addView(self.btnConditionBg_)

    if self.isLordSingle_ then
        local levelCondition = string.format("等级需要%d级或以上", self.singleMatchData_.level)
        local notEnoughLevelFontColor = ccc3(200, 56, 31)
        local levelColor = self.singleGameManager:checkLevel() and fontColor or notEnoughLevelFontColor
        local singleLordLevel = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = fntSize,
            color = levelColor,
            text = levelCondition,
        })
        singleLordLevel:setAnchorPoint(ccp(0, 1))
        singleLordLevel:setPosition(self.dimens_:getDimens(30), self.dimens_:getDimens(200))
        self.signupLayer_:addView(singleLordLevel)
    end

    left = 0
    top = self.dimens_:getDimens(280 - 20)
    self.conditionLayer_ = jj.ui.JJViewGroup.new()
    self.conditionLayer_:setViewSize(self.dimens_:getDimens(252), self.dimens_:getDimens(110))
    self.conditionLayer_:setAnchorPoint(ccp(0, 1))
    self.conditionLayer_:setPosition(left, top)
    self.signupLayer_:addView(self.conditionLayer_)

    self.btnCondition_ = jj.ui.JJButton.new({
        fontSize = self.dimens_:getDimens(22),
        -- color = ccc3(157, 129, 18),
        -- text = "免费",
        -- align = ui.TEXT_ALIGN_CENTER,
        viewSize = CCSize(self.dimens_:getDimens(252), self.dimens_:getDimens(54)),
    })
    self.btnCondition_:setAnchorPoint(ccp(0, 1))
    self.btnCondition_:setPosition(0, self.dimens_:getDimens(110))
    self.btnCondition_:setOnClickListener(handler(self, self.onClick))
    self.conditionLayer_:addView(self.btnCondition_)

    fntSize = self.dimens_:getDimens(self.customParam_.matchDesConditionFontSize)
    fontColor = self.customParam_.matchDesConditionFontColor
    self.btnConditionLabel_ = jj.ui.JJLabel.new({
        fontSize = fntSize,
        color = fontColor,
        text = "免费",
        align = ui.TEXT_ALIGN_CENTER,
        viewSize = CCSize(self.dimens_:getDimens(252), self.dimens_:getDimens(54)),
    })
    self.btnConditionLabel_:setAnchorPoint(ccp(0.5, 0.5))
    self.btnConditionLabel_:setPosition(self.dimens_:getDimens(252) / 2, self.dimens_:getDimens(54) / 2)
    self.btnCondition_:addView(self.btnConditionLabel_)


    left = self.dimens_:getDimens(252 - 10)
    self.questionIcon_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_can_not_sign_up_btn.png")
    })
    self.questionIcon_:setAnchorPoint(ccp(1, 1))
    self.questionIcon_:setPosition(left, self.dimens_:getDimens(110 - 7))
    self.questionIcon_:setVisible(false)
    self.questionIcon_:setScale(self.dimens_.scale_)
    self.conditionLayer_:addView(self.questionIcon_)

    self.choosebtn_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_condition_arrow_down.png"),
    })
    self.choosebtn_:setAnchorPoint(ccp(1, 1))
    self.choosebtn_:setScale(self.dimens_.scale_)
    self.choosebtn_:setVisible(false)
    self.choosebtn_:setPosition(left, self.dimens_:getDimens(110 - 7))
    self.conditionLayer_:addView(self.choosebtn_)

    self:refreshView()
    -- self:registTouchHandler()
end

function MatchDesView:onClick(target)
    local getParam = function()
        if self.isLordSingle_ then
            return { theme = self.theme_, dimens = self.dimens_, scene = self, gameId = self.gameId_, singleMatchData = self.singleMatchData_, width = self.width_, height = self.contentHeight_ - self.dimens_:getDimens(10), }
        else
            return { theme = self.theme_, dimens = self.dimens_, scene = self, gameId = self.gameId_, tourneyInfo = self.tourneyInfo_, width = self.width_, height = self.contentHeight_ - self.dimens_:getDimens(10), }
        end
    end
    if target == self.bg_ then
        -- return true
    elseif target == self.matchInfoLayer_ then
        if self.contentLayer_ ~= nil then
            self.contentLayer_:setVisible(false)
        end
        local left = (self.dimens_.width - self.width_) / 2 + self.dimens_:getDimens(30)
        local top = (self.dimens_.height - self.height_) / 2 + self.height_ - self.dimens_:getDimens(80)

        self.matchInfoView_ = import("game.ui.view.MatchInfoView").new(getParam(), self.customParam_)
        self.matchInfoView_:setAnchorPoint(ccp(0, 1))
        self.matchInfoView_:setPosition(left, top)
        self:addView(self.matchInfoView_)
        self.btnClose_:setVisible(false)
        self.btnReturn_:setVisible(true)
        self.split_h_:setVisible(false)

    elseif target == self.matchAwardLayer_ then
        if self.contentLayer_ ~= nil then
            self.contentLayer_:setVisible(false)
        end
        local left = (self.dimens_.width - self.width_) / 2 + self.dimens_:getDimens(30)
        local top = (self.dimens_.height - self.height_) / 2 + self.height_ - self.dimens_:getDimens(80)
        self.matchAwardView_ = import("game.ui.view.MatchAwardView").new(getParam(), self.customParam_)
        self.matchAwardView_:setAnchorPoint(ccp(0, 1))
        self.matchAwardView_:setPosition(left, top)
        self:addView(self.matchAwardView_)
        self.btnClose_:setVisible(false)
        self.split_h_:setVisible(false)
        self.btnReturn_:setVisible(true)

    elseif target == self.btnClose_ then
        self.scene_:removeMatchDesView()

    elseif target == self.btnReturn_ then
        if self.matchInfoView_ ~= nil then
            self:removeView(self.matchInfoView_)
            self.btnReturn_:setVisible(false)
            self.btnClose_:setVisible(true)
            self.split_h_:setVisible(true)
            self.contentLayer_:setVisible(true)
            self.matchInfoView_ = nil
        elseif self.matchAwardView_ ~= nil then
            self:removeView(self.matchAwardView_)
            self.btnReturn_:setVisible(false)
            self.btnClose_:setVisible(true)
            self.split_h_:setVisible(true)
            self.contentLayer_:setVisible(true)
            self.matchAwardView_ = nil
        end

    elseif target == self.btnCondition_ then
        if self.tourneyInfo_ then
            if self.entryFee_[self.entryIndex_].useable_ == false or self.questionIcon_:isVisible() == true then
                self:showCannotSingupDialog(true)
            else
                if self.feeListView_ == nil then
                    if self.entryFee_ ~= nil and #self.entryFee_ > 1 then
                        self:showMatchFeeListView()
                        self:refreshView()
                    end
                else
                    self:removeMatchFeeListView()
                    self:refreshView()
                end
            end
        end
    elseif target == self.btnTableSelect_ then
        MatchInfoMsg:sendGetTableList(self.tourneyInfo_.tourneyId_, 1, 1000)
    elseif target == self.btnSignup_ then
        if self.isLordSingle_ then
            if self.singleMatchData_ then
                JJLog.i(TAG, "ctor IN singleGameManager is ", self.singleGameManager)
                JJLog.i(TAG, "ctor IN singleGameMatchPromotionManager is ", self.singleGameMatchPromotionManager)

                if self.singleGameManager:checkCanSignup(true) then
                    self.singleGameManager:costSignupCoin()
                    self.singleGameMatchPromotionManager:reset()
                    self.singleGameMatchPromotionManager:createSingleMatchData(self.singleMatchData_.matchid)
                    MainController:pushScene(JJGameDefine.GAME_ID_LORD_UNION, JJSceneDef.ID_SINGLE_LORD_PLAY, { isLoad = false })
                end
            end
        else
            if self.tourneyInfo_.status_ == MatchDefine.STATUS_SIGNOUTABLE then

                local gameId = tonumber(self.tourneyInfo_.matchconfig_ and self.tourneyInfo_.matchconfig_.gameId)
                local tourneyId = self.tourneyInfo_.tourneyId_
                self:showUnSignupWaitDialog(true)
                LobbyDataController:unSignupMatch(tourneyId)
            elseif self.tourneyInfo_.status_ == MatchDefine.STATUS_OUT_OF_REQUIREMENT or self.tourneyInfo_.status_ == MatchDefine.STATUS_WAITING_DATA then
                local isHintTochange = function()
                    local charge = false
                    local entryFee = self.tourneyInfo_:getEntryFee()
                    if entryFee ~= nil and #entryFee > 0 then
                        local fee = entryFee[1]
                        if fee ~= nil and fee.useable_ == false then
                            local cannotReason = fee.reason_
                            if cannotReason ~= nil and string.find(cannotReason, "金币数量大于") then
                                charge = true
                            end
                        end
                    end
                    return charge
                end
                if isHintTochange() == true then
                    self:showChargeDialog(true)
                end
            elseif self.tourneyInfo_.status_ == MatchDefine.STATUS_SIGNUPABLE then
                local isHintTochange = function()
                    local charge = false
                    local entryFee = self.tourneyInfo_:getEntryFee()
                    if entryFee ~= nil and #entryFee > 0 then
                        local fee = entryFee[1]
                        if fee ~= nil and fee.useable_ == false then
                            local cannotReason = fee.reason_
                            if cannotReason ~= nil and string.find(cannotReason, "金币数量大于") then
                                charge = true
                            end
                        end
                    end
                    return charge
                end
                if isHintTochange == true then
                else
                    local gameId = tonumber(self.tourneyInfo_.matchconfig_ and self.tourneyInfo_.matchconfig_.gameId)
                    local tourneyId = self.tourneyInfo_.tourneyId_
                    local matchPoint = self.tourneyInfo_:getSignupTime()
                    local matchType = self.tourneyInfo_.matchconfig_ and self.tourneyInfo_.matchconfig_.matchType_
                    local signupType = self.entryFee_[self.entryIndex_].type_
                    if SignupStatusManager:getSignupedItem(tourneyId) == nil and SignupStatusManager:getSignupingItem(tourneyId) == nil then
                        self:showSignupWaitDialog(true)  
                    end                    
                    self:removeMatchFeeListView()
                    LobbyDataController:signupMatch(gameId, tourneyId, matchPoint, signupType, 0, 0)
                end
            end
        end
    end
end

function MatchDesView:showChargeDialog(show)
    if show then
        self:setViewSize(self.dimens_.width, self.dimens_.height)
        self.chargeDialog_ = require("game.ui.view.AlertDialog").new({
            title = "金币不足",
            prompt = "哎呀，金币不够了，快去充点吧，多种支付方式实时到账哦！",
            onDismissListener = function() 
                self.chargeDialog_ = nil 
            end,
            theme = self.theme_,
            dimens = self.dimens_,
        })

        self.chargeDialog_:setButton1("去充值", function()
            local pcm = require("game.data.config.PayConfigManager")
            PayDef:chargeBtnHandler(pcm:getParam())
        end)
        self.chargeDialog_:setCloseButton(nil)
        self.chargeDialog_:setCanceledOnTouchOutside(true)
        self.chargeDialog_:show(self)

    else
        if self.chargeDialog_ ~= nil then
            self:removeView(self.chargeDialog_)
            self.chargeDialog_ = nil
        end
    end
end

function MatchDesView:hasChargeDialog()
    if self.chargeDialog_ ~= nil then
        return true
    else
        return false
    end
end


function MatchDesView:hasCannotSingupDialog()
    if self.cannotSignupDialog_ ~= nil then
        return true
    else
        return false
    end
end

function MatchDesView:showCannotSingupDialog(show)
    if show then
        self:setViewSize(self.dimens_.width, self.dimens_.height)

        self.cannotSignupDialog_ = import("game.ui.view.CannotSignupDialog").new({
            scene = self,
            tourneyInfo = self.tourneyInfo_,
            theme = self.theme_,
            dimens = self.dimens_,
            packageId = self.packageId_,
        }, self.customParam_)
        self.cannotSignupDialog_:setAnchorPoint(ccp(0, 0))
        self.cannotSignupDialog_:setPosition(0, 0)
        self:addView(self.cannotSignupDialog_, 200)
    else
        if self.cannotSignupDialog_ ~= nil then
            self:removeView(self.cannotSignupDialog_)
            self.cannotSignupDialog_ = nil
        end
    end
end

function MatchDesView:showMatchFeeListView()
    local entryFeeCount = 1
    if self.entryFee_ ~= nil and #self.entryFee_ > 0 then
        entryFeeCount = #self.entryFee_
    end
    self.btnConditionBg_:setViewSize(self.dimens_:getDimens(252), self.dimens_:getDimens(54 * (entryFeeCount + 1)))
    local left = 0
    local top = self.dimens_:getDimens(280 - 20 - 54)
    self.feeListView_ = import("game.ui.view.MatchFeeListView").new({
        theme = self.theme_,
        dimens = self.dimens_,
        scene = self,
        tourneyInfo = self.tourneyInfo_,
        width = self.dimens_:getDimens(252),
        height = self.dimens_:getDimens(54 * entryFeeCount)
    }, self.customParam_)
    self.feeListView_:setAnchorPoint(ccp(0, 1))
    self.feeListView_:setPosition(left, top)
    self.signupLayer_:addView(self.feeListView_)
end

function MatchDesView:removeMatchFeeListView()
    if self.feeListView_ ~= nil then
        self.signupLayer_:removeView(self.feeListView_)
        self.feeListView_ = nil
        self.btnConditionBg_:setViewSize(self.dimens_:getDimens(252), self.dimens_:getDimens(54))
    end
end

function MatchDesView:selectEntryFeeList(index)
    self:removeMatchFeeListView()
    self.entryIndex_ = index
    self:refreshView(self.entryIndex_)
end

function _getShortNoteCutStr(str)
    local newStr = str
    if string.find(str, "扣除") ~= nil then
        newStr = string.sub(str, string.len("扣除") + 1)
    end
    return newStr
end

function MatchDesView:refreshView(entryIndex)
    if self.isLordSingle_ or (self.tourneyInfo_.matchconfig_ and self.tourneyInfo_.matchconfig_.matchType == tostring(MatchDefine.MATCH_TYPE_ISLAND)) then
        self.timeLabel_:setText("报名即开")
    else
        self.timeLabel_:setText(self.tourneyInfo_:getStartTimeString())
    end
    if self.isLordSingle_ then
        if self.singleMatchData_ then
            self.matchName_:setText(self.singleMatchData_.matchname)
        end
    else
        if self.tourneyInfo_.matchconfig_ then
            self.matchName_:setText(self.tourneyInfo_.matchconfig_.productName)
        end
    end

    if self.isLordSingle_ then
        if self.singleMatchData_ then
            if self.entryFee_ ~= nil then
                if self.entryFee_ > 0 then
                    self.btnConditionLabel_:setText(string.format("报名需要%d铜板", self.singleMatchData_.signupcost))
                    if self.singleGameManager:checkCanSignup(false, self.singleMatchData_.matchid) then
                        self.btnSignup_:setEnable(true)
                    else
                        self.btnSignup_:setEnable(false)
                    end
                else
                    self.btnConditionLabel_:setText("免费")
                end
            end
        end
    else
        if self.entryFee_ ~= nil and #self.entryFee_ > 0 then
            if entryIndex == nil then
                for i = 1, #self.entryFee_ do
                    if self.entryIndex_ == 1 and self.entryFee_[i].useable_ == true and self.entryFee_[i].goldReq_ == false then
                        self.entryIndex_ = i
                        break
                    end
                end
                for i = 1, #self.entryFee_ do
                    if self.entryIndex_ == 1 and self.entryFee_[i].useable_ == true then
                        self.entryIndex_ = i
                        break
                    end
                end
            end
            if self.tourneyInfo_.status_ == MatchDefine.STATUS_OUT_OF_REQUIREMENT or self.tourneyInfo_.status == MatchDefine.STATUS_WAITING_DATA then
                self.questionIcon_:setVisible(true)
                self.btnConditionLabel_:setViewSize(self.dimens_:getDimens(252 - 50), self.dimens_:getDimens(54))
                self.btnConditionLabel_:setPosition(self.dimens_:getDimens(202) / 2, self.dimens_:getDimens(54) / 2)
                local str = "比赛要求"
                str = str .. self.tourneyInfo_:getSignupRequireItemList()[1].note_
                self.btnConditionLabel_:setText(str)
                self.btnConditionLabel_:setColor(self.customParam_.matchDesConditionUnsignFontColor)
            elseif self.entryFee_[self.entryIndex_].useable_ == true then
                self.questionIcon_:setVisible(false)
                self.btnConditionLabel_:setViewSize(self.dimens_:getDimens(252), self.dimens_:getDimens(54))
                self.btnConditionLabel_:setPosition(self.dimens_:getDimens(252) / 2, self.dimens_:getDimens(54) / 2)
                self.btnConditionLabel_:setText(_getShortNoteCutStr(self.entryFee_[self.entryIndex_].note_))
                self.btnConditionLabel_:setColor(self.customParam_.matchDesConditionFontColor)

            else
                self.questionIcon_:setVisible(true)
                self.btnConditionLabel_:setViewSize(self.dimens_:getDimens(252 - 50), self.dimens_:getDimens(54))
                self.btnConditionLabel_:setPosition(self.dimens_:getDimens(202) / 2, self.dimens_:getDimens(54) / 2)
                self.btnConditionLabel_:setText(_getShortNoteCutStr(self.entryFee_[1].note_))
                self.btnConditionLabel_:setColor(self.customParam_.matchDesConditionUnsignFontColor)
            end
        end
        if self.entryFee_ ~= nil and #self.entryFee_ > 1 then
            if self.entryFee_[self.entryIndex_].useable_ == true and self.questionIcon_:isVisible() == false then
                self.choosebtn_:setVisible(true)
                self.btnConditionLabel_:setViewSize(self.dimens_:getDimens(252 - 50), self.dimens_:getDimens(54))
                self.btnConditionLabel_:setPosition(self.dimens_:getDimens(202) / 2, self.dimens_:getDimens(54) / 2)
            end
            if self.feeListView_ ~= nil then
                local image = CCTextureCache:sharedTextureCache():addImage(self.theme_:getImage("matchselect/match_item_condition_arrow_up.png"))
                self.choosebtn_:setTexture(image)
            else
                local image = CCTextureCache:sharedTextureCache():addImage(self.theme_:getImage("matchselect/match_item_condition_arrow_down.png"))
                self.choosebtn_:setTexture(image)
            end
        end
    end
    if self.tourneyInfo_ then
        self:updateForSignupMsg(self.tourneyInfo_.tourneyId_)
    end
end

function MatchDesView:updateForSignupMsg(tourneyId)
    if self.tourneyInfo_.tourneyId_ ~= tourneyId then
        return 
    end
    local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tourneyId)
    self:showSignupWaitDialog(false)
    self:showUnSignupWaitDialog(false)
    if tourneyInfo ~= nil then
        if tourneyInfo.status_ == MatchDefine.STATUS_SIGNOUTABLE then
            self.btnSignup_:setButtonImage("normal", self.theme_:getImage(self.unsignBgNormal_))
            self.btnSignup_:setButtonImage("highlight", self.theme_:getImage(self.unsignBgHighlight_))
            self.btnSignup_:setButtonImage("disable", self.theme_:getImage(self.signBgDisable_))
            self.btnSignup_:setText("退 赛")
            if self.countDownScheduler_ == nil then
                local matchType = tonumber(tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.matchType)
                if matchType == MatchDefine.MATCH_TYPE_FIXED then
                    local signupitem = SignupStatusManager:getSignupedItem(tourneyInfo.tourneyId_)
                    if signupitem then
                        self:doSignupResult(tourneyId,matchType, signupitem.startTime_, 0, 0, 0)
                    end
                elseif matchType == MatchDefine.MATCH_TYPE_TIMELY then
                    MatchInfoMsg:sendGetSignCountReq(tourneyInfo.tourneyId_)
                end
            end

        elseif tourneyInfo.status_ == MatchDefine.STATUS_SIGNUPABLE then
            self.btnSignup_:setButtonImage("normal", self.theme_:getImage(self.signBgNormal_))
            self.btnSignup_:setButtonImage("highlight", self.theme_:getImage(self.signBgHighlight_))
            self.btnSignup_:setButtonImage("disable", self.theme_:getImage(self.signBgDisable_))
            self.btnSignup_:setText("报 名")
            self.btnConditionBg_:setVisible(true)
            self.conditionLayer_:setVisible(true)
            if self.countDownLayer_ ~= nil then
                self.signupLayer_:removeView(self.countDownLayer_)
                self.countDownLayer_ = nil
                if self.countDownScheduler_ ~= nil then
                    self.scheduler_.unscheduleGlobal(self.countDownScheduler_)
                    self.countDownScheduler_ = nil
                end
                if self.timelyCountDownScheduler_ ~= nil then
                    self.scheduler_.unscheduleGlobal(self.timelyCountDownScheduler_)
                    self.timelyCountDownScheduler_ = nil;
                end
            end
        elseif tourneyInfo.status_ == MatchDefine.STATUS_OUT_OF_REQUIREMENT or tourneyInfo.status_ == MatchDefine.STATUS_WAITING_DATA then
            local isHintTochange = function()
                local charge = false
                local entryFee = self.tourneyInfo_:getEntryFee()
                if entryFee ~= nil and #entryFee > 0 then
                    local fee = entryFee[1]
                    if fee ~= nil and fee.useable_ == false then
                        local cannotReason = fee.reason_
                        if cannotReason ~= nil and string.find(cannotReason, "金币数量大于") then
                            charge = true
                        end
                    end
                end
                return charge
            end
            if isHintTochange() == false then
                self.btnSignup_:setButtonImage("normal", self.theme_:getImage(self.signBgNormal_))
                self.btnSignup_:setButtonImage("highlight", self.theme_:getImage(self.signBgHighlight_))
                self.btnSignup_:setButtonImage("disable", self.theme_:getImage(self.signBgDisable_))
                self.btnSignup_:setEnable(false)
                self.btnSignup_:setText("报 名")
                self.btnConditionBg_:setVisible(true)
                self.conditionLayer_:setVisible(true)
                if self.countDownLayer_ ~= nil then
                    self.signupLayer_:removeView(self.countDownLayer_)
                    self.countDownLayer_ = nil
                    if self.countDownScheduler_ then
                        self.scheduler_.unscheduleGlobal(self.countDownScheduler_)
                        self.countDownScheduler_ = nil
                    end
                    if self.timelyCountDownScheduler_ ~= nil then
                        self.scheduler_.unscheduleGlobal(self.timelyCountDownScheduler_)
                        self.timelyCountDownScheduler_ = nil;
                    end
                end
            end
        end
    end
end

local timeToMatch = 0
local function _reflushTimeToMatch(matchPoint)
    local now = JJTimeUtil:getCurrentServerTime()
    timeToMatch = matchPoint - (math.modf(now / 1000))
    _getMatchStartPointPrompt(timeToMatch)
end

function _getMatchStartPointPrompt(time)
    local prompt = ""
    if time > 0 then
        local second = math.fmod(time, 60)
        local nMin = math.modf(time / 60)
        if nMin > 0 then
            local nHour = math.modf(nMin / 60)
            local nDay = math.modf(nHour / 24)
            nMin = nMin - nHour * 60
            nHour = nHour - nDay * 24
            --超过1天
            if nDay > 0 then
                prompt = prompt .. nDay .. "天"
            end
            if nHour > 0 then
                prompt = prompt .. nHour .. "小时"
            end
            if nMin > 0 then
                prompt = prompt .. nMin .. "分钟"
            end
            if second > 0 then
                prompt = prompt .. second .. "秒"
            end
        else
            if second > 0 then
                prompt = prompt .. second .. "秒"
            end
        end
    end

    return prompt
end

function MatchDesView:onExit()
    self.countDownLabel_ = nil    
    if self.countDownScheduler_ ~= nil then
        self.scheduler_.unscheduleGlobal(self.countDownScheduler_)
        self.countDownScheduler_ = nil
    end
    if self.timelyCountDownScheduler_ ~= nil then
        self.scheduler_.unscheduleGlobal(self.timelyCountDownScheduler_)
        self.timelyCountDownScheduler_ = nil;
    end
    if self.chargeDialog_ ~= nil then
        self.chargeDialog_ = nil
    end
    if self.cannotSignupDialog_ ~= nil then
        self.cannotSignupDialog_ = nil
    end
end

function MatchDesView:showCountdown(matchType, matchPoint, curPlayer, maxPlayer, interVal)
    self.conditionLayer_:setVisible(false)
    self.btnConditionBg_:setVisible(false)
    local left = 0
    local top = self.dimens_:getDimens(280 - 20)
    if self.countDownLayer_ ~= nil then
        self.signupLayer_:removeView(self.countDownLayer_)
        self.countDownLayer_ = nil
    end
    self.countDownLayer_ = jj.ui.JJViewGroup.new()
    self.countDownLayer_:setViewSize(self.dimens_:getDimens(275), self.dimens_:getDimens(110))
    self.countDownLayer_:setAnchorPoint(ccp(0, 1))
    self.countDownLayer_:setPosition(left, top)
    self.signupLayer_:addView(self.countDownLayer_)
    local fontColor = self.customParam_.CountDownFontColor
    local fontSize = self.dimens_:getDimens(20)

    if matchType == MatchDefine.MATCH_TYPE_FIXED then
        _reflushTimeToMatch(matchPoint)
        self.countDownLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = fontSize,
            color = fontColor,
            text = "距离开赛时间：5分钟8秒",
            align = ui.TEXT_ALIGN_CENTER,
            viewSize = CCSize(self.dimens_:getDimens(240), self.dimens_:getDimens(30))
        })
        self.countDownLabel_:setAnchorPoint(ccp(0, 1))
        self.countDownLabel_:setPosition(self.dimens_:getDimens(15), self.dimens_:getDimens(110))
        self.countDownLayer_:addView(self.countDownLabel_)

        self.countDownTimeLabel_ = jj.ui.JJLabel.new({
            fontSize = fontSize,
            singleLine = true,
            color = fontColor,
            align = ui.TEXT_ALIGN_CENTER,
            text = "5分钟8秒",
            viewSize = CCSize(self.dimens_:getDimens(240), self.dimens_:getDimens(30))
        })
        self.countDownTimeLabel_:setAnchorPoint(ccp(0, 1))
        self.countDownTimeLabel_:setPosition(self.dimens_:getDimens(15), self.dimens_:getDimens(80))
        self.countDownLayer_:addView(self.countDownTimeLabel_)
        self:countDown()
        if self.countDownScheduler_ ~= nil then
            self.scheduler_.unscheduleGlobal(self.countDownScheduler_)
            self.countDownScheduler_ = nil
        end        
        self.countDownScheduler_ = self.scheduler_.scheduleGlobal(function() self:countDown() end, 1)
    else
        local startMatchTime = 0
        if curPlayer >= maxPlayer then
            startMatchTime = 1
        else
            startMatchTime = math.modf(interVal / maxPlayer * (maxPlayer - curPlayer))
        end
        if startMatchTime < 1 then
            startMatchTime = 1
        end
        left = self.dimens_:getDimens(15)
        top = self.dimens_:getDimens(110)
        self.countDownLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = fontSize,
            color = fontColor,
            text = "目前平均开赛时间为",
            align = ui.TEXT_ALIGN_LEFT,
            -- viewSize = CCSize(self.dimens_:getDimens(240), self.dimens_:getDimens(30))
        })
        self.countDownLabel_:setAnchorPoint(ccp(0, 1))
        self.countDownLabel_:setPosition(left, top)
        -- self.countDownLabel_:setScale(self.dimens_.scale_)
        self.countDownLayer_:addView(self.countDownLabel_)

        left = left + self.countDownLabel_:getViewSize().width
        self.intervalLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = fontSize,
            color = self.customParam_.CountDownHightFontColor,
            text = tostring(interVal),
            align = ui.TEXT_ALIGN_LEFT,
            -- viewSize = CCSize(self.dimens_:getDimens(20), self.dimens_:getDimens(30))
        })
        self.intervalLabel_:setAnchorPoint(ccp(0, 1))
        self.intervalLabel_:setPosition(left, top)
        -- self.intervalLabel_:setScale(self.dimens_.scale_)
        self.countDownLayer_:addView(self.intervalLabel_)

        left = left + self.intervalLabel_:getViewSize().width
        self.miaoLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = fontSize,
            color = fontColor,
            text = "秒",
            align = ui.TEXT_ALIGN_LEFT,
        })
        self.miaoLabel_:setAnchorPoint(ccp(0, 1))
        self.miaoLabel_:setPosition(left, top)
        -- self.miaoLabel_:setScale(self.dimens_.scale_)
        self.countDownLayer_:addView(self.miaoLabel_)

        --left = 0
        --top = self.dimens_:getDimens(85)
        self.startTimeLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = fontSize,
            color = fontColor,
            text = "大约还有",
            align = ui.TEXT_ALIGN_LEFT,
            -- viewSize = CCSize(self.dimens_:getDimens(240), self.dimens_:getDimens(30))
        })
        self.startTimeLabel_:setAnchorPoint(ccp(0, 1))
        self.countDownLayer_:addView(self.startTimeLabel_)

        self.startIntervalLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = fontSize,
            color = self.customParam_.CountDownHightFontColor,
            text = tostring(startMatchTime),
            align = ui.TEXT_ALIGN_LEFT,
            -- viewSize = CCSize(self.dimens_:getDimens(20), self.dimens_:getDimens(30))
        })
        self.startIntervalLabel_:setAnchorPoint(ccp(0, 1))
        self.countDownLayer_:addView(self.startIntervalLabel_)

        self.proLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = fontSize,
            color = fontColor,
            text = "秒开赛...",
            align = ui.TEXT_ALIGN_LEFT,
        })
        self.proLabel_:setAnchorPoint(ccp(0, 1))
        self.countDownLayer_:addView(self.proLabel_)

        local width = self.startTimeLabel_:getViewSize().width + self.startIntervalLabel_:getViewSize().width + self.proLabel_:getViewSize().width
        left = (self.dimens_:getDimens(275) - width) / 2
        top = self.dimens_:getDimens(80)
        self.startTimeLabel_:setPosition(left, top)
        left = left + self.startTimeLabel_:getViewSize().width
        self.startIntervalLabel_:setPosition(left, top)
        left = left + self.startIntervalLabel_:getViewSize().width
        self.proLabel_:setPosition(left, top)



        left = 0 --self.dimens_:getDimens(15)
        top = self.dimens_:getDimens(45)
        self.progressBg_ = jj.ui.JJImage.new({
            image = self.theme_:getImage("matchselect/match_item_time_progress_bg.png"),
        })
        self.progressBg_:setAnchorPoint(ccp(0, 1))
        self.progressBg_:setScale(self.dimens_.scale_)
        self.progressBg_:setPosition(left, top)
        self.countDownLayer_:addView(self.progressBg_)

        self.progress_ = jj.ui.JJImage.new({
            image = self.theme_:getImage("matchselect/match_item_time_progress.png"),
        })
        self.progress_:setAnchorPoint(ccp(0, 1))
        self.progress_:setScale(self.dimens_.scale_)
        self.progress_:setPosition(left, top)
        if curPlayer >= maxPlayer then
            width = self.dimens_:getDimens(252)
        else
            width = self.dimens_:getDimens(252) * curPlayer / maxPlayer
        end
        local textureRect = CCRectMake(0, 0, width, self.dimens_:getDimens(21))
        self.progress_:setTextureRect(textureRect)
        self.progress_:setViewSize(width, self.dimens_:getDimens(21))
        self.countDownLayer_:addView(self.progress_)

        left = self.dimens_:getDimens(15)
        local playerStr = curPlayer .. "/" .. maxPlayer
        top = self.dimens_:getDimens(47)
        self.personLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = self.dimens_:getDimens(13),
            color = display.COLOR_BLACK,
            text = playerStr,
            align = ui.TEXT_ALIGN_CENTER,
            viewSize = CCSize(self.dimens_:getDimens(240), self.dimens_:getDimens(20))
        })
        self.personLabel_:setAnchorPoint(ccp(0, 1))
        self.personLabel_:setPosition(left, top - self.dimens_:getDimens(2))
        self.countDownLayer_:addView(self.personLabel_)
        if self.timelyCountDownScheduler_ ~= nil then
            self.scheduler_.unscheduleGlobal(self.timelyCountDownScheduler_)
            self.timelyCountDownScheduler_ = nil;
        end
        self.timelyCountDownScheduler_ = self.scheduler_.scheduleGlobal(function()
            MatchInfoMsg:sendGetSignCountReq(self.tourneyInfo_.tourneyId_)
        end, 3)
    end
end

function MatchDesView:countDown()
    if self.countDownLabel_ ~= nil then     
        timeToMatch = timeToMatch - 1
        local str = _getMatchStartPointPrompt(timeToMatch)
        if string.len(str) <= 8 then
            self.countDownLabel_:setText("距离开赛时间：" .. str)
            self.countDownTimeLabel_:setVisible(false)
        else
            self.countDownLabel_:setText("距离开赛时间：")
            self.countDownTimeLabel_:setText(str)
            self.countDownTimeLabel_:setVisible(true)
        end
    else
        if self.countDownScheduler_ ~= nil then
            self.scheduler_.unscheduleGlobal(self.countDownScheduler_)
            self.countDownScheduler_ = nil
        end
        if self.timelyCountDownScheduler_ ~= nil then
            self.scheduler_.unscheduleGlobal(self.timelyCountDownScheduler_)
            self.timelyCountDownScheduler_ = nil;
        end        
    end        
end

function MatchDesView:showSignupWaitDialog(show)
    if show then
        if self.waitDialog_ ~= nil then
            self.waitDialog_:dismiss()
        end
        self.waitDialog_ = require("game.ui.view.ProgressDialog").new(self.theme_, self.dimens_, {
            text = "正在报名，请稍等...",
            mask = false,
            onDismissListener = function() self.waitDialog_ = nil end
        })
        self.waitDialog_:setCanceledOnTouchOutside(false)
        self.waitDialog_:show(self)
        local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
        scheduler.performWithDelayGlobal(function()
            self:showSignupWaitDialog(false)
        end, 5)
    else
        if self.waitDialog_ ~= nil then
            self.waitDialog_:dismiss()
            self.waitDialog_ = nil
        end
    end
end

function MatchDesView:dialogIsExist()
    if self.waitDialog_ ~= nil or self.unSignupWaitDialog_ ~= nil then
        return true
    else
        return false
    end
end

function MatchDesView:showUnSignupWaitDialog(show)
    if show then
        if self.unSignupWaitDialog_ ~= nil then
            self.unSignupWaitDialog_:dismiss();
        end
        self.unSignupWaitDialog_ = require("game.ui.view.ProgressDialog").new(self.theme_, self.dimens_, {
            text = "正在退赛，请稍等...",
            mask = false,
            onDismissListener = function() self.unSignupWaitDialog_ = nil end
        })
        self.unSignupWaitDialog_:setCanceledOnTouchOutside(false)
        self.unSignupWaitDialog_:show(self)

        local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
        scheduler.performWithDelayGlobal(function()
            self:showUnSignupWaitDialog(false)
        end, 5)
    else
        if self.unSignupWaitDialog_ ~= nil then
            self.unSignupWaitDialog_:dismiss()
            self.unSignupWaitDialog_ = nil
        end
    end
end


function MatchDesView:doSignupResult(tourneyId, matchType, matchPoint, curPlayer, maxPlayer, interVal)
    if self.tourneyInfo_.tourneyId_ ~= tourneyId then
        return 
    end
    self:showCountdown(matchType, matchPoint, curPlayer, maxPlayer, interVal)
end

function MatchDesView:removeSignupWaitDialog()
    self:showSignupWaitDialog(false)
    self:showUnSignupWaitDialog(false)
end

function MatchDesView:refreshMatchPointLabel()
    if self.isLordSingle_ or (self.tourneyInfo_.matchconfig_ and self.tourneyInfo_.matchconfig_.matchType == tostring(MatchDefine.MATCH_TYPE_ISLAND)) then
        self.timeLabel_:setText("报名即开")
    else
        self.timeLabel_:setText(self.tourneyInfo_:getStartTimeString())
    end
end

function MatchDesView:refreshMatchConfigMsg()
    if self.isLordSingle_ then
        if self.singleMatchData_ then
            self.matchName_:setText(self.singleMatchData_.matchname)
        end
    else
        if self.tourneyInfo_.matchconfig_ then
            self.matchName_:setText(self.tourneyInfo_.matchconfig_.productName)
        end
    end
end

return MatchDesView