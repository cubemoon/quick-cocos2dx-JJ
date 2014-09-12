
local JJViewGroup = require("sdk.ui.JJViewGroup")
local UIView = class("UIView", JJViewGroup)
local PlayerInfo = require("interim.data.InterimPlayerInfo")
local MaskView = require("interim.ui.view.MaskView")
local RankDetailView = require("interim.ui.view.RankDetailView")
local MenuView = require("interim.ui.view.MenuView")
local SettingView = require("interim.ui.view.SettingView")
local BuyChipView = require("interim.ui.view.BuyChipView")
local TrustSettingView = require("interim.ui.view.TrustSettingView")
local GameTip = require("interim.ui.view.GameTip")
local HelpView = require("interim.ui.view.HelpView")
local ExitView = require("interim.ui.view.ExitView")
local LotteryView = require("interim.ui.view.LotteryView")
local EmoteView = require("interim.ui.view.EmoteView")
local DrawCardView = require("interim.ui.view.DrawCardView")
local PositionConfig = require("interim.util.PositionConfig")
local RankView = require("interim.ui.view.RankView")
local SwitchButton = require("interim.ui.view.SwitchButton")
local PlayerInfoView = require("interim.ui.view.PlayerInfoView")
local MessageView = require("interim.ui.view.MessageView")
local LotteryDetail = require("interim.ui.view.LotteryDetail")
--local MatchAwardView = require("interim.ui.view.MatchAwardView")
local AlertView = require("interim.ui.view.AlertView")
local AwardView = require("interim.ui.view.AwardView")
local MatchInfoView = require("interim.ui.view.MatchInfoView")
local InterimRoundWaitView = require("interim.ui.view.InterimRoundWaitView")
--local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_PLAYER_STATUS_EMPTY = InterimUtilDefine.INTERIM_PLAYER_STATUS_EMPTY
local INTERIM_PLAYER_STATUS_ENGAGED = InterimUtilDefine.INTERIM_PLAYER_STATUS_ENGAGED
local INTERIM_PLAYER_STATUS_STANDBY = InterimUtilDefine.INTERIM_PLAYER_STATUS_STANDBY
local INTERIM_PLAYER_STATUS_FOLD = InterimUtilDefine.INTERIM_PLAYER_STATUS_FOLD
local INTERIM_RESULT = InterimUtilDefine.INTERIM_RESULT 

local INTERIM_POPVIEW_NONE = InterimUtilDefine.INTERIM_POPVIEW_NONE
local INTERIM_POPVIEW_MATCHAWARD = InterimUtilDefine.INTERIM_POPVIEW_MATCHAWARD 
local INTERIM_POPVIEW_RANKDETAIL = 2
local INTERIM_POPVIEW_MENU = 3
local INTERIM_POPVIEW_SETTING = 4
local INTERIM_POPVIEW_TRUST = 5
local INTERIM_POPVIEW_HELP = 6
local INTERIM_POPVIEW_BUYCHIP = 7
local INTERIM_POPVIEW_EXIT = 8
local INTERIM_POPVIEW_EMOTE = 9
local INTERIM_POPVIEW_DRAWCARD = 10
local INTERIM_POPVIEW_PLAYERINFO = 11
local INTERIM_POPVIEW_LOTTERY = 12
local INTERIM_POPVIEW_ALERTVIEW = 14
local INTERIM_POPVIEW_MATCHINFOVIEW = 15
local AUTO_FOLD_CHECKBOX_ID = 1
local STANDBY_BUTTON_ID = 2

local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND

function UIView:ctor(parentScene)
	UIView.super.ctor(self)
    self.positionConfig = parentScene.positionConfig

	self.parentScene = parentScene
    self.theme_ = parentScene.theme_
    self.dimens_ = parentScene.dimens_
    self.startCountDown = false
    self.raiseMin_ = 0 
    self.raiseSec_ = 0 
    self.raiseTime_ =0
	self:initView()
end

function UIView:setPopViewStatus(var)
    self.popviewStatus = var
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    gameData.popviewStatus = var
end

-- function UIView:setPopViewVisible(var)
--     local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    
--     if gameData.popviewStatus == INTERIM_POPVIEW_RANKDETAIL then
--         self.rankDetailViewHide
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_MENU then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_SETTING then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_TRUST then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_HELP then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_BUYCHIP then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_EXIT then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_EMOTE then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_DRAWCARD then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_PLAYERINFO then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_LOTTERY then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_MATCHAWARD then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_ALERTVIEW then
--     elseif gameData.popviewStatus == INTERIM_POPVIEW_MATCHINFOVIEW then


--      end 


-- end

function UIView:initView()
    self.popviewStatus = INTERIM_POPVIEW_NONE
    
	function onButtonClicked(sender)
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	    if sender.name == "menu" then
            self:showMenuView()
        elseif sender.name == "max" then
            self.parentScene:onViewCallback(sender, sender.name)
            self:hideActionBar()
            gameData.isAction = true
            self.parentScene:stopCountDown()
        elseif sender.name == "min" then
            self.parentScene:onViewCallback(sender, sender.name)
            self:hideActionBar()
            gameData.isAction = true
            self.parentScene:stopCountDown()
        elseif sender.name == "25percent" then
            self.parentScene:onViewCallback(sender, sender.name)
            self:hideActionBar()
            gameData.isAction = true
            self.parentScene:stopCountDown()
        elseif sender.name == "50percent" then
            -- self.parentScene:onViewCallback(sender, sender.name)
            -- self:hideActionBar()
            -- gameData.isAction = true
            -- self.parentScene:stopCountDown()
        elseif sender.name == "fold" then            
            self.parentScene:onViewCallback(sender, sender.name)
            self:hideActionBar()
            gameData.isAction = true
        elseif sender.name == "emote" then
            self:showEmoteView()
        elseif sender.name == "stand" then
            MatchMsg:sendMarkPlayerIdleReq(INTERIM_MATCH_ID, true)
           -- self.toggleBar:setVisible(false)
            self.parentScene:standUp()
        elseif sender.name == "exit" then
            self:exitGame()
        elseif sender.name == "trust" then
            self:onMenuButtonClicked("Trust")
        elseif sender.name == "auto" then
            self:onMenuButtonClicked("BuyChip")
        elseif sender.name == "change" then
            self:changeTableBtnClicked()
        elseif sender.name == "fastSitDown" then
            self.parentScene:fastSit()
            self:fastSitDispose()
        end
	end

    self.lotteryView = LotteryView.new(self)
    self:addView(self.lotteryView)
    self.lotteryView:setPosition(self.dimens_.right/2, self.dimens_.top)
    self.lotteryView:setScale(self.dimens_.scale_)

    self.rankView = RankView.new(self)
    self:addView(self.rankView)
    self.rankView:setPosition(self.positionConfig.rankView)

    local button = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/ui/menu_btn.png",   
            highlight = "img/interim/ui/menu_btn_f.png",
        },
    })
    button:setAnchorPoint(ccp(1, 1))
    self:addView(button)
    button.name = "menu"
    button:setScale(self.dimens_.scale_)
    button:setPosition(ccp(self.dimens_.right-self.dimens_:getDimens(9),
        self.dimens_.top-self.dimens_:getDimens(7)))
    button:setOnClickListener(onButtonClicked)

    self.actionBar = JJViewGroup.new(self)
    self:addView(self.actionBar)

    self.maxButton = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/ui/max.png",   
            highlight = "img/interim/ui/max_f.png",
        },
    })
    self.maxButton:setAnchorPoint(ccp(0.5, 0.5))
    self.actionBar:addView(self.maxButton)
    self.maxButton.name = "max"
    self.maxButton:setScale(self.dimens_.scale_)
    self.maxButton:setPosition(ccp(self.dimens_.right*0.86,
        self.dimens_:getDimens(36)))
    self.maxButton:setOnClickListener(onButtonClicked)

    -- 压满的数值
    self.maxLabel = self:createButtonLabel()
    self.maxLabel:setScale(1.2*self.dimens_.scale_)
    self.maxLabel:setPosition(self.maxButton:getPositionX(), self.dimens_:getDimens(34))
    self.actionBar:addView(self.maxLabel)

    button = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/ui/fold.png",   
            highlight = "img/interim/ui/fold_f.png",
        },
        fontSize = 25,
    })
    button:setAnchorPoint(ccp(0.5, 0.5))
    self.actionBar:addView(button)
    button.name = "fold"
    button:setScale(self.dimens_.scale_)
    button:setPosition(ccp(self.dimens_.right*0.6,
        self.dimens_:getDimens(36)))
    button:setOnClickListener(onButtonClicked)

    self.minButton = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/ui/max.png",   
            highlight = "img/interim/ui/max_f.png",
        },
        fontSize = 25,
    })
    self.minButton:setAnchorPoint(ccp(0.5, 0.5))
    self.actionBar:addView(self.minButton)
    self.minButton.name = "min"
    self.minButton:setScale(self.dimens_.scale_)
    self.minButton:setPosition(ccp(self.dimens_.right*0.115,
        self.dimens_:getDimens(36)))
    self.minButton:setOnClickListener(onButtonClicked)

    -- 压最小的数值
    self.minLabel = self:createButtonLabel()
    self.minLabel:setPosition(self.minButton:getPositionX(), self.dimens_:getDimens(33))
    self.actionBar:addView(self.minLabel)

    self.p25Button = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/ui/max.png",   
            highlight = "img/interim/ui/max_f.png",
        },
        fontSize = 25,
    })
    self.p25Button:setAnchorPoint(ccp(0.5, 0.5))
    self.actionBar:addView(self.p25Button)
    self.p25Button.name = "25percent"
    self.p25Button:setScale(self.dimens_.scale_)
    self.p25Button:setPosition(ccp(self.dimens_.right*0.35,
        self.dimens_:getDimens(36)))
    self.p25Button:setOnClickListener(onButtonClicked)

    -- 压25%的数值
    self.p25Label = self:createButtonLabel()
    self.p25Label:setPosition(self.p25Button:getPositionX(), self.dimens_:getDimens(33))
    self.actionBar:addView(self.p25Label)

    -- self.p50Button = jj.ui.JJButton.new({
    --     images = {
    --         normal = "img/interim/ui/min.png",   
    --         highlight = "img/interim/ui/min_f.png",
    --     },
    --     fontSize = 25,
    -- })
    -- self.p50Button:setAnchorPoint(ccp(0.5, 0.5))
    -- self.actionBar:addView(self.p50Button)
    -- self.p50Button.name = "50percent"
    -- self.p50Button:setScale(self.dimens_.scale_)
    -- self.p50Button:setPosition(ccp(self.dimens_.right*0.40,
    --     self.dimens_:getDimens(36)))
    -- self.p50Button:setOnClickListener(onButtonClicked)

    -- -- 压50%的数值
    -- self.p50Label = self:createButtonLabel()
    -- self.p50Label:setPosition(self.p50Button:getPositionX(), self.p50Button:getPositionY())
    -- self.actionBar:addView(self.p50Label)

    self.actionBar:setVisible(false)

    self.toggleBar = JJViewGroup.new(self)
    self:addView(self.toggleBar)

    self.trustButton = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/ui/buttonBg.png",   
            highlight = "img/interim/ui/buttonBg.png",
        },
        text = "托管"
    })
    self.trustButton:setAnchorPoint(ccp(0.5, 0.5))
    self.toggleBar:addView(self.trustButton)
    self.trustButton.name = "trust"
    self.trustButton:setScale(self.dimens_.scale_)
    self.trustButton:setPosition(self.dimens_:getDimens(98),
        self.dimens_:getDimens(36))
    self.trustButton:setOnClickListener(onButtonClicked)

    self.autoFoldButton = jj.ui.JJCheckBox.new({
        images={
           on="img/interim/ui/checkBox_on.png",
           off="img/interim/ui/checkBox_off.png" 
        },
        clickSound = "sound/BackButtonSound.mp3"
    })
    self.toggleBar:addView(self.autoFoldButton)
    self.autoFoldButton:setScale(self.dimens_.scale_)
    self.autoFoldButton:setAnchorPoint(ccp(0.5, 0.5))
    self.autoFoldButton:setPosition(ccp(self.dimens_.right*0.565,self.dimens_:getDimens(7)))    --(self.dimens_:getDimens(30), self.dimens_:getDimens(7))
    self.autoFoldButton:setId(AUTO_FOLD_CHECKBOX_ID)
    self.autoFoldButton:setTouchEnable(true)
    self.autoFoldButton:setOnCheckedChangeListener(handler(self, self.onCheckedChangeListener))
    self.autoFoldButton:setVisible(false)

    self.autoFoldLabel = jj.ui.JJLabel.new({
        font = "Arial",
        fontSize = self.dimens_:getDimens(20),
        color = ccc3(255, 255, 255),
        text = "一直弃牌",
    })
    self.autoFoldLabel:setAnchorPoint(ccp(0.5, 0.5))
    self.autoFoldLabel:setPosition(ccp(self.dimens_.right*0.565+self.dimens_:getDimens(80),self.dimens_:getDimens(36)))   --(self.dimens_:getDimens(110), self.dimens_:getDimens(36))
    self.autoFoldLabel:setVisible(false)
    self.toggleBar:addView(self.autoFoldLabel)

    self.autoRechargeButton = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/ui/buttonBg.png",   
            highlight = "img/interim/ui/buttonBg.png",
        },
         text = "补充筹码"
    })
    self.autoRechargeButton:setAnchorPoint(ccp(0.5, 0.5))
    self.toggleBar:addView(self.autoRechargeButton)
    self.autoRechargeButton.name = "auto"
    self.autoRechargeButton:setScale(self.dimens_.scale_)
    self.autoRechargeButton:setPosition(self.dimens_:getDimens(260),
        self.dimens_:getDimens(36))
    self.autoRechargeButton:setOnClickListener(onButtonClicked)

    

    self.standButton = jj.ui.JJCheckBox.new({
        images={
           on="img/interim/ui/checkBox_on.png",
           off="img/interim/ui/checkBox_off.png" 
        },
        clickSound = "sound/BackButtonSound.mp3"
    })
    self.toggleBar:addView(self.standButton)
    self.standButton:setScale(self.dimens_.scale_)
    self.standButton:setAnchorPoint(ccp(0.5, 0.5))
    self.standButton:setPosition(self.dimens_:getDimens(360), self.dimens_:getDimens(7))
    self.standButton:setId(STANDBY_BUTTON_ID)
    self.standButton:setTouchEnable(true)
    self.standButton:setOnCheckedChangeListener(handler(self, self.onCheckedChangeListener))

    self.standByLabel = jj.ui.JJLabel.new({
        font = "Arial",
        fontSize = self.dimens_:getDimens(20),
        color = ccc3(255, 255, 255),
        text = "下局旁观",
    })
    self.standByLabel:setAnchorPoint(ccp(0.5, 0.5))
    self.standByLabel:setPosition(self.dimens_:getDimens(440), self.dimens_:getDimens(35))
    self.toggleBar:addView(self.standByLabel)

    self.canNotEngaedTip = jj.ui.JJLabel.new({
        fontSize = 18*self.dimens_.scale_,
        color = ccc3(255, 255, 255),
        text = "桌面筹码不多于您方可开始游戏",
    })
    self.canNotEngaedTip:setAnchorPoint(ccp(1, 0.5))
    self.canNotEngaedTip:setPosition(self.dimens_:getDimens(850), self.dimens_:getDimens(30))
    self.canNotEngaedTip:setVisible(false)
    self.toggleBar:addView(self.canNotEngaedTip)
    

    self.toggleBar:setVisible(false)      --隐藏或显示toggleBar

    self.standBar = JJViewGroup.new(self)
    self:addView(self.standBar)

    self.titleLabel = jj.ui.JJLabel.new({
        fontSize = 22*self.dimens_.scale_,
        color = ccc3(255, 255, 255),
        text = "当前旁观",
    })
    self.titleLabel:setAnchorPoint(ccp(0.5, 0.5))
    self.titleLabel:setPosition(self.dimens_:getDimens(450), self.dimens_:getDimens(30))
    self.titleLabel:setVisible(false)
    self.standBar:addView(self.titleLabel)
    self.standBar:setVisible(false)

    self.standByTipLabel = jj.ui.JJLabel.new({
        fontSize = 22*self.dimens_.scale_,
        color = ccc3(255, 255, 255),
        text = "当前处于托管状态",
    })
    self.standByTipLabel:setAnchorPoint(ccp(1, 0.5))
    self.standByTipLabel:setPosition(self.dimens_:getDimens(820), self.dimens_:getDimens(30))
    self.toggleBar:addView(self.standByTipLabel)
    self.standByTipLabel:setVisible(false)

    self.changeTable = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/ui/buttonBg.png",   
            highlight = "img/interim/ui/buttonBg.png",
        },
        font = "Arial",
        fontSize = self.dimens_:getDimens(20),
        color = ccc3(255, 255, 255),
        text = "换桌"
    })
    self.changeTable:setAnchorPoint(ccp(0.5, 0.5))
    self.standBar:addView(self.changeTable)
    self.changeTable.name = "change"
    self.changeTable:setScale(self.dimens_.scale_)
    self.changeTable:setPosition(ccp(self.dimens_.right*0.9,
        self.dimens_:getDimens(33)))
    self.changeTable:setOnClickListener(onButtonClicked)
    self.changeTable:setVisible(false)

     self.fastSitDown = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/ui/buttonBg.png",   
            highlight = "img/interim/ui/buttonBg.png",
        },
        font = "Arial",
        fontSize = self.dimens_:getDimens(20),
        color = ccc3(255, 255, 255),
        text = "快速坐下"
    })
    self.fastSitDown:setAnchorPoint(ccp(0.5, 0.5))
    self.standBar:addView(self.fastSitDown)
    self.fastSitDown.name = "fastSitDown"
    self.fastSitDown:setScale(self.dimens_.scale_)
    self.fastSitDown:setPosition(ccp(self.dimens_.right*0.7,
        self.dimens_:getDimens(33)))
    self.fastSitDown:setOnClickListener(onButtonClicked)
    self.fastSitDown:setVisible(false)

    self.emoteButton = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/ui/emote.png",   
        },
    })
    self.emoteButton:setAnchorPoint(ccp(0.5, 0.5))
    self:addView(self.emoteButton)
    self.emoteButton.name = "emote"
    self.emoteButton:setScale(self.dimens_.scale_)
    self.emoteButton:setPosition(self.dimens_:getDimens(50),
        self.dimens_:getDimens(136))
    self.emoteButton:setOnClickListener(onButtonClicked)
    self.emoteButton:setVisible(false)

    self.netStateLabel = jj.ui.JJLabel.new({
        fontSize = 22*self.dimens_.scale_,
        color = ccc3(255, 255, 255),
        text = "您的网络慢",
    })
    self.netStateLabel:setAnchorPoint(ccp(0, 0.5))
    self.netStateLabel:setPosition(self.dimens_:getDimens(100), self.dimens_:getDimens(136))
    self:addView(self.netStateLabel)
    self.netStateLabel:setVisible(false)

    self.groupInfo = JJViewGroup.new(self)
    self:addView(self.groupInfo)

    self.sysTime = require("interim.ui.view.HelperSysTime").new(self)
    self.sysTime:setAnchorPoint(ccp(0, 1))
    self.sysTime:setScale(self.dimens_.scale_)
    self.sysTime:setPosition(self.dimens_:getDimens(30), 0)
    self.groupInfo:addView(self.sysTime)

    --信号强度
    self.signal = require("interim.ui.view.HelperSignal").new(self)
    self.signal:setAnchorPoint(ccp(0, 1))
    self.signal:setScale(self.dimens_.scale_)
    self.signal:setPosition(self.dimens_:getDimens(-30),self.dimens_:getDimens(3))
    self.groupInfo:addView(self.signal)
    
    --电池电量
    self.battery = require("interim.ui.view.HelperBattery").new(self)
    self.battery:setAnchorPoint(ccp(0, 1))
    self.battery:setScale(self.dimens_.scale_)
    self.battery:setPosition(0, self.dimens_:getDimens(-5))
    self.groupInfo:addView(self.battery)

    self.groupInfo:setPosition(self.dimens_.right - self.dimens_:getDimens(250),
    self.dimens_.top - self.dimens_:getDimens(10))

    local versionLabel = jj.ui.JJLabel.new({
        fontSize = 30*self.dimens_.scale_,
        color = ccc3(255, 255, 255),
        text = "",
    })
    self:addView(versionLabel)
    versionLabel:setPosition(self.dimens_:getDimens(25),self.dimens_:getDimens(20))

    -- 遮罩层
    self.maskView = MaskView.new(self)
    self:addView(self.maskView)
    self.maskView:setVisible(true)

    self.interimRoundWaitView = InterimRoundWaitView.new(self)
    self:addView(self.interimRoundWaitView)
    self.interimRoundWaitView:setZOrder(5)

    self.interimRoundWaitView:setVisible(true)

    self.messageView = MessageView.new(self)
    self:addView(self.messageView)
    self.messageView:setZOrder(0)
    self.messageView:setPosition(self.dimens_.right/2, self.dimens_.top/2)
    self.messageView:setVisible(false)

    self.buyChipView = BuyChipView.new(self)
    self.buyChipView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self:addView(self.buyChipView)
    self.buyChipView:setZOrder(1)
    self.buyChipView:setVisible(false) ---************GL

    self.menuView = MenuView.new(self)
    self:addView(self.menuView)
    local menuSize = self.menuView.bgSize
    self.menuView:setPosition(self.dimens_.right-menuSize.width/2, self.dimens_.top+menuSize.height)
    self.menuView:setVisible(false)
    self.menuView:setZOrder(1)

    self.exitView = ExitView.new(self)
    self:addView(self.exitView)
    self.exitView:setPosition(-self.dimens_.right, -self.dimens_.top)
    self.exitView:setVisible(false)
    self.exitView:setZOrder(1)

    self.rankDetailView = RankDetailView.new(self)
    self:addView(self.rankDetailView)
    self.rankDetailView:setVisible(false)
    self.rankDetailView:setZOrder(1)

    self.matchInfoView = MatchInfoView.new(self)
    self.matchInfoView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.matchInfoView:setVisible(false) ----------MatchInfoview
    self:addView(self.matchInfoView)
    self.matchInfoView:setZOrder(1)

    self.settingView = SettingView.new(self)
    self:addView(self.settingView)
    self.settingView:setVisible(false)
    self.settingView:setZOrder(1)

    self.trustSettingView = TrustSettingView.new(self)
    self:addView(self.trustSettingView)
    self.trustSettingView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.trustSettingView:setVisible(false)
    self.trustSettingView:setZOrder(1)

    self.helpView = HelpView.new(self)
    self:addView(self.helpView)
    self.helpView:setVisible(false)
    self.helpView:setZOrder(1)
    
    self.emoteView = EmoteView.new(self)
    self:addView(self.emoteView)
    self.emoteView:setVisible(false)
    self.emoteView:setZOrder(1)

    self.playerInfoView = PlayerInfoView.new(self)
    self:addView(self.playerInfoView)
    self.playerInfoView:setVisible(false)
    self.playerInfoView:setZOrder(1)

    self.lotteryDetail = LotteryDetail.new(self)
    self:addView(self.lotteryDetail)
    self.lotteryDetail:setVisible(false)
    self.lotteryDetail:setZOrder(1)

    self.drawCardView = DrawCardView.new(self)
    self:addView(self.drawCardView)
    self.drawCardView:setPosition(self.dimens_.right/2, self.dimens_.top/2)
    self.drawCardView:setVisible(false)
    self.drawCardView:setZOrder(1)

    -- self.matchAward = MatchAwardView.new(self)
    -- self:addView(self.matchAward)
    -- self.matchAward:setPosition(self.dimens_.right/2, self.dimens_.top/2)
    -- self.matchAward:setVisible(false)
    -- self.matchAward:setZOrder(1)

    self.alertView = AlertView.new(self)
    self:addView(self.alertView)
    self.alertView:setPosition(self.dimens_.right/2, self.dimens_.top/2)
    self.alertView:setVisible(false)
    self.alertView:setZOrder(1)

    self.awardView = AwardView.new(self, self.startGameParam_)
    self:addView(self.awardView)
  --self.awardView:setPosition(self.dimens_.right/2, self.dimens_.top/2)
    self.awardView:setVisible(false)
    self.awardView:setZOrder(0)

    --第一次进入游戏时显示帮助界面
    do
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        if gameData.notFirstEnterGame == false then
            self:showHelpView()
            gameData.notFirstEnterGame = true
            CCUserDefault:sharedUserDefault():setBoolForKey("Interim_FirstPlay", true)
        end
    end
    self:initTipMsgView()  --系统换桌中请等待
    --self:showTipMsg("系统将重新调整位置,请稍候")
    --self:handleNetPoorMsg()  it is a test

    self:refreshData()

end

function UIView:initTipMsgView()
    self.gameTip = GameTip.new(self)
    self.gameTip:setVisible(false)
    self:addView(self.gameTip) 
    --self.gameTip:setZOrder(1000)
end

function UIView:showTipMsg(strMsg)
    if  self.gameTip and strMsg then
        self.gameTip:showTipMessage(strMsg)
        self.gameTip:setVisible(true)
    end
end

function UIView:closeTip()
    if (self.gameTip) then
        self.gameTip:closeDisplay()
        self.gameTip:setVisible(false)
    end
end

function UIView:setTrustAndAutoByButtonVisible( visible )
    self.trustButton:setVisible(visible)
    self.autoRechargeButton:setVisible(visible)

    self.standButton:setVisible(false)
    self.standByLabel:setVisible(false)

    self.actionBar:setVisible(false)
    self.toggleBar:setVisible(true)
end

function UIView:stopLoadingAnim()
    if self.popviewStatus == INTERIM_POPVIEW_NONE then
       self.maskView:setVisible(false)
    end
    self.interimRoundWaitView:stopAnimation()
    self.interimRoundWaitView:setVisible(false)
end

function UIView:handleNetPoorMsg()
    if not self.netStateLabel:isVisible() then
        self.netStateLabel:setVisible(true)
    end

    self:schedule(function()
        if self.netStateLabel:isVisible() then
            self.netStateLabel:setVisible(false)
        end
    end, 10)
end

function UIView:hideChangeAndSitButton( visible )
    self.changeTable:setVisible(visible)
    self.fastSitDown:setVisible(visible)
end

function UIView:changeTableBtnClicked()
    
    local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)
    if matchData then
        if matchData.isSupportChangeTable_ then
            MatchMsg:sendChangeTable(INTERIM_MATCH_ID)
        else
            jj.ui.JJToast:show({
                text = "当前比赛不支持换桌。",
                dimens = self.dimens_,
            })
        end
    end
end

function UIView:fastSitDispose()  --下局旁观按钮恢复初始状态
   self.standButton:setChecked(false)
end

function UIView:createButtonLabel()
    -- local label = jj.ui.JJLabelBMFont.new({
    --      text="0",
    --      font="img/interim/ui/button_um.fnt",
    -- })
    -- label:setScale(self.dimens_.scale_)
    -- label:setAnchorPoint(ccp(0.5,0.5))

    local label = jj.ui.JJLabel.new({
        fontSize = 20*self.dimens_.scale_,
        color = ccc3(255, 255, 255),
        text = "",
    })
    label:setScale(self.dimens_.scale_)
    label:setAnchorPoint(ccp(0.5,0.5))

    return label
end

function UIView:callFakeCom()
    local array = CCArray:create()
    array:addObject(CCDelayTime:create(2))
    array:addObject(CCCallFunc:create(handler(self, self.fakeShowComData)))
    local seq = CCSequence:create(array)
    self.actionBar:runAction(seq) 

end

function UIView:fakeShowComData()
    local handCard = {}
    handCard[1] = 1
    handCard[2] = 5
    handCard[3] = 10
    
    local myself = 0

    if myself == 1 then
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        local playerInfo = gameData:getMyPlayerInfo()
        self:showDrawCardView(41, handCard, playerInfo)
        self.drawCardView.myself = true
    else
        self:showDrawCardView(41, handCard, nil)
        local array = CCArray:create()
        array:addObject(CCDelayTime:create(3))
        array:addObject(CCCallFunc:create(handler(self, self.fakeCombData)))
        local seq = CCSequence:create(array)
        self.actionBar:runAction(seq) 
    end
end

function UIView:fakeCombData()
   local data = {}
    data.conGamb = {}
    data.conGamb.card = 1
    data.conGamb.seat = 2
    data.conGamb.winCoin = 10000
    data.conGamb.everyWin = 1110
    data.conGamb.enResult = INTERIM_RESULT.Foursamestraight
    data.conGamb.cardCount = 30
    data.conGamb.click = 2 
    self:updateConGambAck(data)

    local array = CCArray:create()
    array:addObject(CCDelayTime:create(6))
    array:addObject(CCCallFunc:create(handler(self, self.fakeCombEnd)))
    local seq = CCSequence:create(array)
    self.actionBar:runAction(seq) 
end

function UIView:fakeCombEnd()
    local data = {}
    data.gambData = {}
    data.gambData.card = 15
    data.gambData.click = 15
    data.gambData.seat = 2
    -- data.gambData.winCoin = 0
    -- data.gambData.enResult = INTERIM_RESULT.ErrorRuler
    data.gambData.winCoin = 1450
    data.gambData.everyWin = 111
    data.gambData.enResult = INTERIM_RESULT.Skysamestraight
    self:updateGambEndAck(data) 
end

function UIView:onEnter()
    self.super:onEnter()
    -- self.standBar:setVisible(true)
    -- self.emoteButton:setVisible(false)
end

function UIView:setAutoRechargeButtonStatus(var)
    --self.autoRechargeButton:setSwitchStatus(var)
end

function UIView:createButton(buttonText)
	local btn = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/common/blue_button02.png",   
            highlight = "img/interim/common/yellow_button02.png",
       		scale9 = true
        },
        viewSize = CCSize(120, 50),
        fontSize = 28,
        color = ccc3(255, 255, 255),
        text = buttonText,
    })
    btn:setAnchorPoint(ccp(0.5, 0.5))
    return btn
end

function UIView:onCheckedChangeListener(target)   
    local id = target:getId()
    if id == STANDBY_BUTTON_ID then
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        gameData.standFlag = target:isSelected()
        MatchMsg:sendMarkPlayerIdleReq(INTERIM_MATCH_ID, target:isSelected())                      --下局旁观
        self.standByTipLabel:setVisible(target:isSelected() )
        self.standByTipLabel:setText("当前处于托管状态")
        self.standByTipLabel:setAnchorPoint(ccp(1, 0.5))
        self.standByTipLabel:setPosition(self.dimens_:getDimens(820), self.dimens_:getDimens(30))
        self.canNotEngaedTip:setVisible(false)  


    elseif id == AUTO_FOLD_CHECKBOX_ID then
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        gameData.autoFold = target:isSelected()
        if gameData.autoFold == false then
            self.autoFoldButton:setVisible(false)
            self.autoFoldLabel:setVisible(false)
        end
        self.standByTipLabel:setVisible(target:isSelected())
        self.standByTipLabel:setText("已进入自动弃牌状态")
        self.standByTipLabel:setAnchorPoint(ccp(0, 0.5))
        self.standByTipLabel:setPosition(self.dimens_:getDimens(10), self.dimens_:getDimens(30))
    end
    JJLog.i("*********************onCheckedChangeListener************")
end

function UIView:onSwitchStatusChanged(button, status)
    if button.name == "trust" then
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        gameData.delegated = status                              --托管
    
    elseif button.name == "auto" then                            --自动补码
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        gameData.autoBuyChip = status
        -- self.buyChipView.checkBoxAutoBuy:setChecked(gameData.autoBuyChip)
        -- MatchMsg:sendMarkAutoAddHPReq(INTERIM_MATCH_ID, status)
    elseif button.name == "stand" then
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        gameData.standFlag = status                        --下局旁观
    end
end

function UIView:showChangeAndTrustButton()   
    self:showStandBar()
    self:setTrustAndAutoByButtonVisible(true)
    self:hideEmoteButton()
end

function UIView:updateInitCardDisplay(gameData)

    for i,v in ipairs(gameData.anBottomCoin) do
        gameData.tableCoin = gameData.tableCoin + v
    end

    for i,v in ipairs(gameData.anTax) do
        gameData.tableCoin = gameData.tableCoin - v
    end


    local playerInfo = gameData:getMyPlayerInfo()
    if playerInfo == nil then
        self:showChangeAndTrustButton()
    else
        
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        if playerInfo.status == INTERIM_PLAYER_STATUS_ENGAGED then
            
            self:showEmoteButton()
            self:hideStandBar()
            self:showToggleBar()
            if gameData.delegated == true then
                self.standByTipLabel:setVisible(true)
            end
            if gameData.property.isTourny == false then
                self.canNotEngaedTip:setVisible(false)
            end
            
        end
    end

    -- 刷新游戏信息
    self:refreshRankInfo()
end


--涨盲时间处理

local countDownScheduleHandler_ = nil

function UIView:updateBlindTime()
     if self.raiseMin_ ==0 and self.raiseSec_ ==0 then
        local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)
        if matchData == nil then
            return;
        end
        --涨盲倒计时
        local raiseDate = os.date("*t", matchData.baseRaiseTime_-JJTimeUtil:getCurrentServerTime()/1000)
        local currHour, currMin, currSec, raiseHour, raiseMin, raiseSec = 0, 0, 0, 0, 0, 0
        if raiseDate ~= nil then
            raiseHour, raiseMin, raiseSec = raiseDate.hour, raiseDate.min, raiseDate.sec

            if self.raiseTime_ == matchData.baseRaiseTime_ then
            --不用处理
            else
                self.raiseMin_ =  raiseDate.min
                self.raiseSec_ = raiseDate.sec
                self.raiseTime_ = matchData.baseRaiseTime_
            end
        end
        JJLog.i(TAG,"updateBlindTime  raiseHour=",raiseHour,",raiseMin=",raiseMin,",raiseSec=",raiseSec)
    else
        if self.raiseSec_ >0 then
            self.raiseSec_ = self.raiseSec_ -1
        elseif self.raiseSec_ == 0 then
            self.raiseSec_ = 59
            self.raiseMin_ = self.raiseMin_ -1
        end

    end

    local raiseInfo = string.format("%02d:%02d",  self.raiseMin_, self.raiseSec_)
    -- local raiseInfo=  string.format("%d%d:%d%d", nTenMin, nMin, nTenSecond, nSecond);
    raiseInfo = "涨盲 " .. raiseInfo
    self.rankView:setRaise(raiseInfo)
   
end

function UIView:stopUpdateTimer()
    if self.scheduleHandler_ ~= nil then
        JJLog.i("停止定时器**************************")
        self:unschedule(self.scheduleHandler_)
        self.scheduleHandler_ = nil 
    end
end

function UIView:refreshRankInfo()
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)

    if self.scheduleHandler_ == nil and gameData.showAward == false then
        JJLog.i("启动定时器**************************")
        self.scheduleHandler_ = self:schedule(function() self:updateBlindTime() end, 1)
    end
    JJLog.i( "localTime:" .. os.time() ) 


    if gameData.property.isTourny == true then   --锦标赛  
       --显示排名
       self.rankView:setRoomTitle("排名：".. gameData.rank .. "/" .. gameData.leavePlayer)  --锦标赛这个label显示排名
       --显示基数和涨盲倒计时
       local baseText = nil
       if matchData.roundInfo_ ~= nil then
            local scoreString = InterimUtil:getStandBetChipsDispShort(matchData.roundInfo_.scoreBase_)
            baseText = "基数:" ..  scoreString 
       else
            baseText = "基数:" ..  0 
       end

       self.rankView:setBase(baseText)
       self.rankView:setRankVisible(false)
       self.rankView:setBaseVisible(true)
       self.rankView:setRaiseVisible(true)

    else                     --自由桌排名显示
        self.rankView:setRoomTitle(gameData.matchName)  --设置房间名称
        self.rankView:setBaseVisible(false)
        self.rankView:setRaiseVisible(false)

        local playerCount = gameData:getPlayerCount()

        local rank = 1
        for i,v in ipairs(gameData.allPlayerInfo) do
            if v.tkInfo.score > gameData.myCoin then
                rank = rank + 1
            end
        end

        gameData.rank = rank
        local rankText = "奖励进度："
        self.rankDetailView.rankLabel:setText(rankText)

        local baseText = "基数：" 
        if matchData.roundInfo_ ~= nil then
            local scoreString = InterimUtil:getStandBetChipsDispShort(matchData.roundInfo_.scoreBase_)
            baseText = baseText .. scoreString
        else
            baseText = "基数：0" 
        end

        self.rankDetailView.baseLabel:setText(baseText)

        local qiuka = ""
        local emerald = ""
        if matchData.roundInfo_ ~= nil then
            if matchData.gameCountAwardInfo_ then
                if matchData.gameCountAwardInfo_[1] ~= nil then
                    qiuka = matchData.gameCountAwardInfo_[1].note_
                    self.rankDetailView.qiukaLabel:setText(qiuka)
                    JJLog.i("99999999999999999999999999" .. qiuka)
                    local sIdx, eIdx = string.find(qiuka,"%d+", 1)
                    local totalRound = string.sub(qiuka,sIdx,eIdx)
                    
                    local round = math.mod(matchData.finishCount, totalRound)
                    local progress = round .. "/" ..totalRound
                    rankText = rankText .. progress
                    self.rankView:setRank(rankText)
                    self.rankDetailView.qiukaProgLabel:setText(progress)
                else
                    self.rankDetailView.qiukaLabel:setVisible(false)
                end

                if matchData.gameCountAwardInfo_[2] ~= nil then
                    emerald = matchData.gameCountAwardInfo_[2].note_
                    self.rankDetailView.emeraldLabel:setText(emerald)

                    local sIdx, eIdx = string.find(emerald,"%d+", 1)
                    local totalRound = string.sub(emerald,sIdx,eIdx)
                  
                    local round = math.mod(matchData.finishCount, totalRound)
                    local progress = round .. "/" ..totalRound

                    self.rankDetailView.emeraldProgLabel:setText(progress)
                else
                    self.rankDetailView.emeraldLabel:setVisible(false)
                end
            end
        end
    end
end

function UIView:handlePushPlayerGameData( gameData )

    self:refreshRankInfo()
end


function UIView:playerSitdown( playerInfo )

    if playerInfo.tkInfo.userid == UserInfo.userId_ then
            
        self:showToggleBar()
        self:hideStandBar()
    
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        gameData.standFlag = false
        if gameData.tableCoin > gameData.property.poolBottom 
            and gameData.property.isTourny == false then
            JJLog.i("桌面筹码不多于,,, " .. gameData.property.poolBottom)
             self.canNotEngaedTip:setText("桌面筹码不多于" .. gameData.property.poolBottom .. "您方可开始游戏")
             self.canNotEngaedTip:setVisible(true)  
        end
        
    end
end

function UIView:handleAutoFoldAndTrust()
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)
    local bDelegate = false
        for i=1,5 do
            if gameData.delegateMatchID[i] == matchData.productId_ then
                bDelegate = true
            end
        end
        if bDelegate then
            self.trustButton:setVisible(true)
            self.autoFoldButton:setVisible(false)
            self.autoFoldLabel:setVisible(false)
        else        
            self.trustButton:setVisible(false)
            --self.autoFoldButton:setVisible(true)
            --self.autoFoldLabel:setVisible(true)
        end 

        self.autoRechargeButton:setVisible(false)
        self.standButton:setVisible(false)
        self.standByLabel:setVisible(false)
        if gameData.autoFold == true then
            self.standByTipLabel:setText("已进入自动弃牌状态")
            self.standByTipLabel:setVisible(true)
            self.autoFoldButton:setChecked(true)
            self.autoFoldLabel:setVisible(true)
            self.autoFoldButton:setVisible(true)
            self.standByTipLabel:setAnchorPoint(ccp(0, 0.5))
            self.standByTipLabel:setPosition(self.dimens_:getDimens(10), self.dimens_:getDimens(30))
        elseif gameData.delegated == true then
            self.standByTipLabel:setText("当前处于托管状态")
            self.standByTipLabel:setVisible(true)
            self.standByTipLabel:setAnchorPoint(ccp(1, 0.5))
            self.standByTipLabel:setPosition(self.dimens_:getDimens(820), self.dimens_:getDimens(30))
        end
end

function UIView:showToggleBar()
    self.actionBar:setVisible(false)
  
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)
    local var = gameData.delegated
    
    if gameData.property.isTourny == true then
        self:handleAutoFoldAndTrust()
    else
        self.autoRechargeButton:setVisible(true)
        self.standButton:setVisible(true)
        self.standByLabel:setVisible(true)
        self.trustButton:setVisible(true)
    end
    self.toggleBar:setVisible(true)
end

function UIView:setActionBarValue(min, p25, p50, max)

    local function showNode(node, value)
        if value == 0 or value >= max then
            node:setVisible(false)
        else
            node:setVisible(true)
        end
    end
    
    
    self.minButton.value = min
    self.p25Button.value = p25
    self.maxButton.value = max

    if min ~= nil then
        local scoreString = InterimUtil:getStandBetChipsDispShort(min)
        self.minLabel:setText(scoreString)
    end

    if p25 ~= nil then
        local scoreString = InterimUtil:getStandBetChipsDispShort(p25)
        self.p25Label:setText(scoreString)
    end

   

    if max ~= nil then
        local scoreString = InterimUtil:getStandBetChipsDispShort(max)
        self.maxLabel:setText(scoreString)
    end

    showNode(self.minButton, min)
    showNode(self.minLabel, min)

    showNode(self.p25Button, p25)
    showNode(self.p25Label, p25)

 
end

function UIView:showActionBar()
    self.actionBar:setVisible(true)
    self.actionBar:setPosition(0, 0)
    self.toggleBar:setVisible(false)

    -- self:calculateBetByExpect(tableCoin*0.25)

    -- if self.actionBar:isVisible() == true then
    --     return
    -- end
    -- self.actionBar:setVisible(true)
    -- self.actionBar:stopAllActions()
    -- self.actionBar:setPosition(self.positionConfig.actionBarHidden)
    -- local moveTo = CCMoveTo:create(0.1, ccp(0, 0))
    -- local easeAction = CCEaseExponentialOut:create(moveTo)
    -- self.actionBar:runAction(easeAction)

    -- self.toggleBar:setVisible(false)
    --assert(false, "showActionBar")    
end

function UIView:hideActionBar()
    if self.actionBar:isVisible() == false then
        return
    end
    self:hideActionBarFinished()
    -- self.actionBar:stopAllActions()
    -- self.actionBar:setPosition(ccp(0, 0))
    -- local targetPos = self.positionConfig.actionBarHidden
    -- local moveTo = CCMoveTo:create(0.1, targetPos)
    -- local easeAction = CCEaseExponentialOut:create(moveTo)
    
    -- local array = CCArray:create()
    -- array:addObject(easeAction)
    -- array:addObject(CCCallFunc:create(handler(self, self.hideActionBarFinished)))
    -- local seq = CCSequence:create(array)
    -- self.actionBar:runAction(easeAction) 

    -- assert(false, "hideActionBar")
   
end

function UIView:hideActionBarFinished()
    self.actionBar:setVisible(false)
end

function UIView:maskViewTouched()
    if self.popviewStatus == INTERIM_POPVIEW_RANKDETAIL then
        self.rankDetailView:stopAllActions()
        self:hideRankDetail()
        JJLog.i("UIView:maskViewTouched.. INTERIM_POPVIEW_RANKDETAIL")
    elseif self.popviewStatus == INTERIM_POPVIEW_MENU then
        self.menuView:stopAllActions()
        self:hideMenuView()
    elseif self.popviewStatus == INTERIM_POPVIEW_SETTING then
        self:hideSettingView()
    elseif self.popviewStatus == INTERIM_POPVIEW_BUYCHIP then
        self:hideBuyChipView()
    elseif self.popviewStatus == INTERIM_POPVIEW_TRUST then
        self:hideTrustSettingView()
    elseif self.popviewStatus == INTERIM_POPVIEW_HELP then
        self:hideHelpView()
    elseif self.popviewStatus == INTERIM_POPVIEW_EXIT then
        self:hideExitView()
    elseif self.popviewStatus == INTERIM_POPVIEW_EMOTE then        
        self:hideEmoteView()
    elseif self.popviewStatus == INTERIM_POPVIEW_PLAYERINFO then
        self:hidePlayerInfoView()
    elseif self.popviewStatus == INTERIM_POPVIEW_LOTTERY then
        self:hideLotteryDetail()
    elseif self.popviewStatus == INTERIM_POPVIEW_MATCHAWARD then
       -- 显示比赛结果不能关闭
       -- self:hideMatchAward()
    elseif self.popviewStatus == INTERIM_POPVIEW_ALERTVIEW then
        self:hideAlertView()
    elseif self.popviewStatus == INTERIM_POPVIEW_MATCHINFOVIEW then
        self:hideMatchInfoView()
    end
end

function UIView:showRankDetail()
    self:setPopViewStatus(INTERIM_POPVIEW_RANKDETAIL)
    self.maskView:show(false)
    self.rankDetailView:setPosition(self.positionConfig.rankDetailViewHide)
    local targetPos = self.positionConfig.rankDetailView 
    local moveTo = CCMoveTo:create(0.2, targetPos)
    local easeAction = CCEaseExponentialOut:create(moveTo)
    self.rankDetailView:setVisible(true)
    self.rankDetailView:runAction(easeAction)
    self.rankDetailView:show()
end

function UIView:showRankDetailInstant()
    self:setPopViewStatus(INTERIM_POPVIEW_RANKDETAIL)
    self.maskView:show(false)
     local targetPos = self.positionConfig.rankDetailView 
    self.rankDetailView:setPosition(targetPos)
    self.rankDetailView:setVisible(true)
    self.rankDetailView:show()
end

function UIView:hideRankDetail()
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
    self.rankDetailView:setPosition(self.positionConfig.rankDetailView)
    local targetPos = self.positionConfig.rankDetailViewHide
    local moveTo = CCMoveTo:create(0.2, targetPos)
    local easeAction = CCEaseExponentialIn:create(moveTo)
   
    local array = CCArray:create()
    array:addObject(easeAction)
    array:addObject(CCCallFunc:create(handler(self, self.hideRankDetailFinished)))
    local seq = CCSequence:create(array)
    self.rankDetailView:runAction(seq)
end

function UIView:hideRankDetailFinished()
    self.rankDetailView:setVisible(false)
end

function UIView:showMenuView()
    self:setPopViewStatus(INTERIM_POPVIEW_MENU)
    self.maskView:show(false)
     self.menuView:refreshLayout()

    local yPos = self.dimens_.top - self.dimens_:getDimens(190)
    local startPos = ccp(self.dimens_.right + self.dimens_:getDimens(150)
        , yPos)
        -- self.dimens_.top/2)
    local targetPos = ccp(self.dimens_.right + self.dimens_:getDimens(-105)
        , yPos)
    local menuSize = self.menuView.bgSize
    self.menuView:setPosition(startPos)
    
    local moveTo = CCMoveTo:create(0.2, targetPos)
    local easeAction = CCEaseExponentialOut:create(moveTo)
    self.menuView:setVisible(true)
    self.menuView:runAction(easeAction)
end

function UIView:showMenuViewInstant()
    self:setPopViewStatus(INTERIM_POPVIEW_MENU)
    self.maskView:show(false)
     self.menuView:refreshLayout()

    local yPos = self.dimens_.top - self.dimens_:getDimens(190)
    local targetPos = ccp(self.dimens_.right + self.dimens_:getDimens(-105)
        , yPos)
    local menuSize = self.menuView.bgSize
    self.menuView:setVisible(true)
    self.menuView:setPosition(targetPos)
end

function UIView:hideMenuView()
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
    
    local yPos = self.dimens_.top - self.dimens_:getDimens(190)
    local targetPos = ccp(self.dimens_.right + self.dimens_:getDimens(150)
        , yPos)
    local startPos = ccp(self.dimens_.right + self.dimens_:getDimens(-103)
        , yPos)
    

    local menuSize = self.menuView.bgSize
    self.menuView:setPosition(startPos)
    local moveTo = CCMoveTo:create(0.2, targetPos)
    local easeAction = CCEaseExponentialIn:create(moveTo)
   
    local array = CCArray:create()
    array:addObject(easeAction)
    array:addObject(CCCallFunc:create(handler(self, self.hideMenuViewFinished)))
    local seq = CCSequence:create(array)
    self.menuView:runAction(seq)
end


function UIView:hideMenuViewFinished()
    self.menuView:setVisible(false)
end

function UIView:showSettingView()
    self.maskView:show(false)
    self:setPopViewStatus(INTERIM_POPVIEW_SETTING)
    self.settingView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.settingView:setVisible(true)
end

function UIView:hideSettingView()
    self.settingView:setVisible(false)
    self.maskView:setVisible(false)
    self.settingView:setPosition(-self.dimens_.right, -self.dimens_.top)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:showBuyChipView()
    self.maskView:show(false)
    self:setPopViewStatus(INTERIM_POPVIEW_BUYCHIP)
    self.buyChipView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.buyChipView:setVisible(true) 
    self.buyChipView:show()
end

function UIView:hideBuyChipView()
    self.buyChipView:setVisible(false)
    self.buyChipView:setPosition(-self.dimens_.right, -self.dimens_.top)
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:showTrustSettingView()
    self.maskView:show(false)
    self:setPopViewStatus(INTERIM_POPVIEW_TRUST)
    self.trustSettingView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.trustSettingView:refreshData()
    self.trustSettingView:setVisible(true) 
end
 
function UIView:hideTrustSettingView()
    self.trustSettingView:setVisible(false)
    self.trustSettingView:setPosition(-self.dimens_.right, -self.dimens_.top)
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:showHelpView()
    self.maskView:show(false)
    self:setPopViewStatus(INTERIM_POPVIEW_HELP)
    self.helpView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.helpView:reloadData()
    self.helpView:setVisible(true)    
end

function UIView:hideHelpView()
    self.helpView:setVisible(false)
    self.helpView:setPosition(-self.dimens_.right, -self.dimens_.top)
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:showExitView()
    self.maskView:show(false)
    self:setPopViewStatus(INTERIM_POPVIEW_EXIT)
    self.exitView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.exitView:setVisible(true)
    self.exitView:refreshData()
end

function UIView:hideExitView()
    self.exitView:setVisible(false)
    self.exitView:setPosition(-self.dimens_.right, -self.dimens_.top)
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:showEmoteView()
    self.maskView:show(false)
    self:setPopViewStatus(INTERIM_POPVIEW_EMOTE)
    self.maskView:show(false)
    self.emoteView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.emoteView:setVisible(true) 
end

function UIView:hideEmoteView()
    self.emoteView:setVisible(false)
    self.emoteView:setPosition(-self.dimens_.right, -self.dimens_.top)
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:showAlertView(title, message)
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    if gameData.property.isTourny == true then
        return
    end

    self:setPopViewStatus(INTERIM_POPVIEW_ALERTVIEW)
    self.maskView:show(false)
    self.alertView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.alertView:show(title, message)
end

function UIView:hideAlertView()
    JJLog.i("隐藏提示框")
    self.alertView:setVisible(false)
    self.alertView:setPosition(-self.dimens_.right, -self.dimens_.top)
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:showLotteryDetail()
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    if gameData.property.isTourny == true then
        return
    end

    self:setPopViewStatus(INTERIM_POPVIEW_LOTTERY)
    self.maskView:show(false)
    self.lotteryDetail:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.lotteryDetail:show()
end

function UIView:hideLotteryDetail()
    self.lotteryDetail:setVisible(false)
    self.lotteryDetail:setPosition(-self.dimens_.right, -self.dimens_.top)
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:showMatchInfoView()
    self:setPopViewStatus(INTERIM_POPVIEW_MATCHINFOVIEW)
    self.maskView:show(false)
    self.matchInfoView:setVisible(true)
    --获取比赛房间名称
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    self.matchInfoView:show( gameData.matchName )
end

function UIView:hideMatchInfoView()
    JJLog.i("*************************hiddeMatchIinfoView")
    self.matchInfoView:setVisible(false)
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:showMatchAward()

    local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)
    local matchAward = matchData.awardData_
    self:hideAllView()
    self:setPopViewStatus(INTERIM_POPVIEW_MATCHAWARD)
    self:stopUpdateTimer()
    
    self.maskView:show(false)
    if matchAward then
       self.awardView:setResult(matchAward)
    end
    self.awardView:setVisible(true)   
end

function UIView:hideMatchAward()
    self.awardView:setVisible(false) 
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:showDrawCardView(cardCount, handCard, playerInfo)
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    gameData.isDiggerEnd = false
    
    self:maskViewTouched()
    self:setPopViewStatus(INTERIM_POPVIEW_DRAWCARD)
    self.maskView:show(false)
    self.drawCardView:setPosition(ccp(self.dimens_.right/2, self.dimens_.top/2))
    self.drawCardView:setVisible(true)
    self.drawCardView:show(cardCount, handCard, playerInfo)
end

function UIView:hideDrawCardView()
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    gameData.isDiggerEnd = true

    self.drawCardView:setVisible(false)
    self.drawCardView:setPosition(-self.dimens_.right, -self.dimens_.top)
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:updateConGambAck(data)
    self.drawCardView:updateConGambAck(data)
end

function UIView:updateGambEndAck(data)
    self.drawCardView:stopCountDown()
    self.drawCardView:selectCard(data.gambData.card, data.gambData.click)
    if data.gambData.winCoin == 0 then      
        self.drawCardView:missCard()
    else
        self.drawCardView:winCard(data) --博彩环节结束 自己赢得彩金
    end
end

function UIView:onDrawCardViewClicked()
    self:hideDrawCardView()
end

function UIView:showPlayerInfoView(playerInfo)
    JJLog.i("显示玩家信息")
    self.playerInfoView:show(playerInfo)
    self.maskView:show(false)
    self.playerInfoView:setPosition(self.dimens_.right/2, self.dimens_.top/2)
    self:setPopViewStatus(INTERIM_POPVIEW_PLAYERINFO)
end

function UIView:hidePlayerInfoView()
    self.playerInfoView:setVisible(false)
    self.playerInfoView:setPosition(-self.dimens_.right, -self.dimens_.top)
    self.maskView:setVisible(false)
    self:setPopViewStatus(INTERIM_POPVIEW_NONE)
end

function UIView:onMenuButtonClicked(tag)
    SoundManager:playEffect(INTERIM_SOUND.BUTTON)
    if tag == "Setting" then
        self.menuView:setVisible(false)
        local menuSize = self.menuView.bgSize
        local pos = ccp(self.dimens_.right-menuSize.width/2, self.dimens_.top+menuSize.height/2)
        self.menuView:setPosition(pos)

        self:showSettingView()
    elseif tag == "BuyChip" then
        self.menuView:setVisible(false)
        local menuSize = self.menuView.bgSize
        local pos = ccp(self.dimens_.right-menuSize.width/2, self.dimens_.top+menuSize.height/2)
        self.menuView:setPosition(pos)
        self:showBuyChipView()        
      --  self:showMatchAward()
    elseif tag == "Trust" then
        self.menuView:setVisible(false)
        local menuSize = self.menuView.bgSize
        local pos = ccp(self.dimens_.right-menuSize.width/2, self.dimens_.top+menuSize.height/2)
        self.menuView:setPosition(pos)
        self:showTrustSettingView()
    elseif tag == "Help" then
        self.menuView:setVisible(false)
        local menuSize = self.menuView.bgSize
        local pos = ccp(self.dimens_.right-menuSize.width/2, self.dimens_.top+menuSize.height/2)
        self.menuView:setPosition(pos)
        self:showHelpView()        
    elseif tag == "Quit" then
        self.menuView:setVisible(false)
        local menuSize = self.menuView.bgSize
        local pos = ccp(self.dimens_.right-menuSize.width/2, self.dimens_.top+menuSize.height/2)
        self.menuView:setPosition(pos)
        self:showExitView()
    elseif tag == "CloseDrawCard" then
        -- self:hideDrawCardView()
    end
end

function UIView:exitGame()
    self.parentScene:exitGame()
    self:stopUpdateTimer()
    self:stopLoadingAnim() --解决长时间不进入游戏，游戏结束而没有自动切回到比赛选择界面的bug
end

function UIView:playAgain()
    self.parentScene:playAgain()
    self:stopUpdateTimer()
end

function UIView:shareGame()
    self.parentScene:shareGame()
end

function UIView:rankViewTouched()
    --JJLog.i("show************************")
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    if gameData.property.isTourny == true then   --锦标赛  
        self:showMatchInfoView()
    else  
        self:showRankDetail()
    end
end

function UIView:showEmoteButton()
    self.emoteButton:setVisible(true)
end

function UIView:hideEmoteButton()
    self.emoteButton:setVisible(false)
end

function UIView:onEnableTrust(var)          --托管开关
    if self.toggleBar:isVisible() == true then
        JJLog.i("onEnableTrust self.trustButton " .. tostring(var))
        --self.trustButton:setSwitchStatus(var)      
    end
end

function UIView:showPlayerInfo(playerInfo, layoutIndex)
    
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    
    if gameData.property.isTourny == true then
        playerInfo.score = playerInfo.tkInfo.score
        
    else
        playerInfo.score = playerInfo.tkInfo.score
        local playerCount = gameData:getPlayerCount()
        local rank = 1
        for i,v in ipairs(gameData.allPlayerInfo) do
            if v.tkInfo.score > playerInfo.score then
                rank = rank + 1
            end
        end
        playerInfo.rank = rank
    end

    self:showPlayerInfoView(playerInfo)
    local seatPosition = self.positionConfig.seatPositionTable[layoutIndex]
    if layoutIndex == 1 then
      --  self.playerInfoView:setAnchorPoint(ccp(0, 0))
        seatPosition = ccp(seatPosition.x + self.dimens_:getDimens(78), 
            seatPosition.y + self.dimens_:getDimens(40))
    elseif layoutIndex == 2 then
      --  self.playerInfoView:setAnchorPoint(ccp(1, 0))
        seatPosition = ccp(seatPosition.x + self.dimens_:getDimens(-78), 
            seatPosition.y + self.dimens_:getDimens(40))
    elseif layoutIndex == 3 then
       -- self.playerInfoView:setAnchorPoint(ccp(1, 1))
        seatPosition = ccp(seatPosition.x + self.dimens_:getDimens(-78), 
            seatPosition.y + self.dimens_:getDimens(-40))
    elseif layoutIndex == 4 then
      --  self.playerInfoView:setAnchorPoint(ccp(0, 1))
        seatPosition = ccp(seatPosition.x + self.dimens_:getDimens(78), 
           seatPosition.y + self.dimens_:getDimens(-40))
    elseif layoutIndex == 5 then
        --self.playerInfoView:setAnchorPoint(ccp(0, 0))
        seatPosition = ccp(seatPosition.x + self.dimens_:getDimens(78), 
           seatPosition.y + self.dimens_:getDimens(40))
    end
    JJLog.i("layoutIndex：" .. layoutIndex)
    JJLog.i("设置playerInfoView坐标：" .. seatPosition.x .. " " .. seatPosition.y)
    self.playerInfoView:setPosition(seatPosition)
end

function UIView:showStandBar()
    self.actionBar:setVisible(false)

    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    local playerInfo = gameData:getMyPlayerInfo()
    if playerInfo == nil then
        self.emoteButton:setVisible(false)
    end

    self.standBar:setVisible(true)              --正在旁观 即站起状态
    if gameData.standFlag == true then
        self.changeTable:setVisible(true)
        self.fastSitDown:setVisible(true)
    end
    self.standByTipLabel:setVisible(false)
    self.titleLabel:setVisible(true)
end

function UIView:hideStandBar( )
    self.standBar:setVisible(false)
    self.changeTable:setVisible(false)
    self.fastSitDown:setVisible(false)
end

function UIView:showEmptyTableNextRound()
    self.messageView:showEmptyTableNextRound()
    self.messageView:setZOrder(0)
end

function UIView:showNotEnoughMoney()
    self.alertDialog = require("game.ui.view.AlertDialog").new({
        title = "补充筹码失败",
        prompt = "您的金币不足",
        theme = self.theme_,
        dimens = self.dimens_,
    })

    self.alertDialog:setButton1("确定", nil)
    self.alertDialog:setCanceledOnTouchOutside(false)
    self.alertDialog:show(self, 1000)
end

function UIView:getTakenSeats()
    return self.parentScene:getTakenSeats()
end


function UIView:hideAllView()
    self:hideMenuView()
    self:hideEmoteView()
    self:hideRankDetail()
    self:hideMatchInfoView()
    self:hideSettingView()
    self:hideHelpView()
    self:hideExitView()
    self:hideDrawCardView()
    self:hideTrustSettingView()
    self:hideBuyChipView()
    self:hideLotteryDetail()
    self:hidePlayerInfoView()
    self:hideAlertView()

end

function UIView:refreshData()
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)
    self:setAutoRechargeButtonStatus(gameData.autoBuyChip)
    gameData.autoFold = false
    if gameData.property.isTourny == false then
        JJLog.i("UIView:refreshData()>>>>>>>>>>>>>>>>>>>>>>>>>")
        self.lotteryView.numberLabel:setVisible(true)
    else
        self.lotteryView.numberLabel:setVisible(false)
        --self:showEmoteButton()  --解决从后台切回时不显示emotionbutton 的bug
    end

    if gameData.popviewStatus ~= nil then
         JJLog.i("gameData.popviewStatus" .. gameData.popviewStatus)
        if gameData.popviewStatus == INTERIM_POPVIEW_RANKDETAIL then
                self:showRankDetailInstant()
        elseif gameData.popviewStatus == INTERIM_POPVIEW_MENU then
                self:showMenuViewInstant()
        elseif gameData.popviewStatus == INTERIM_POPVIEW_SETTING then     
                self:showSettingView()
        elseif gameData.popviewStatus == INTERIM_POPVIEW_TRUST then
                self:showTrustSettingView()
        elseif gameData.popviewStatus == INTERIM_POPVIEW_HELP then
                self:showHelpView()
        elseif gameData.popviewStatus == INTERIM_POPVIEW_BUYCHIP then
                self:showBuyChipView()
        elseif gameData.popviewStatus == INTERIM_POPVIEW_EXIT then
                self:showExitView()
        elseif gameData.popviewStatus == INTERIM_POPVIEW_EMOTE then
                self:showEmoteView()
        elseif gameData.popviewStatus == INTERIM_POPVIEW_PLAYERINFO then
                --self:showPlayerInfo()
        elseif gameData.popviewStatus == INTERIM_POPVIEW_LOTTERY then
                self:showLotteryDetail()
        elseif gameData.popviewStatus == INTERIM_POPVIEW_MATCHAWARD then
                self:showMatchAward(gameData.matchAward)
        elseif gameData.popviewStatus == INTERIM_POPVIEW_MATCHINFOVIEW then
            --self:showMatchInfoView()
        end
    end

   self:refreshRankInfo()
   --self:updateInitCardDisplay(gameData)
    local playerInfo = gameData:getMyPlayerInfo()  --手机端玩家坐下但是由于底池金币数很大还未参与游戏，未显示托管按钮和提示信息
    if playerInfo then
        self:playerSitdown(playerInfo)
        if playerInfo.status == INTERIM_PLAYER_STATUS_ENGAGED then    --解决从后台切回时不显示emotionbutton 的bug
            self:showEmoteButton()   
        end
    end
    
    if gameData.status ~= INTERIM_PLAYER_STATUS_ENGAGED and gameData.standFlag == true then
        self:showChangeAndTrustButton()
    end

    if matchData.awardData_ ~= nil then          --如果有奖状信息，显示奖状，停止loading
        self:stopLoadingAnim()
        self:showMatchAward()
    end

    if gameData.bMyTurn == true then
        self:stopLoadingAnim()
    end
    
end

function UIView:playDivideTableCoinAck(gameData)
    
    if gameData.lastPlayer == true then
        return
    end

    if gameData.hasPlayerOut == true then
        self.messageView:showDividTable(true)
    else
        self.messageView:showDividTable(false)
    end
    self.messageView:setZOrder(0)
end

function UIView:handlePushGameCountAwardInfo(matchData)
    self:refreshRankInfo()
end

function UIView:handleAddHPAck(gameData)
    self.messageView:showHPAdded(gameData.hpadded)
    self.messageView:setZOrder(0)
end

function UIView:showForceMessage(msg, zOder)
    self.messageView:showForceMessage(msg)
    self.messageView:setZOrder(zOder)
end

function UIView:handleJackPotWinner(gameData)
    --if  gameData.enteringScene == true then
       self.lotteryView:lightBlink()
       SoundManager:playEffect(INTERIM_SOUND.GAMB)
       JJLog.i("UIView:handleJackPotWinner")
       local date = os.date("*t",  JJTimeUtil:getCurrentSecond())
       JJLog.i("date.hour" .. date.hour .. "date.min" .. date.min)
    --end
end
    
return UIView
