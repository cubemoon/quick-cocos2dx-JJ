local JJViewGroup = require("sdk.ui.JJViewGroup")
local HelpView = class("HelpView", JJViewGroup)

local SegmentedButton = require("interim.ui.view.SegmentedButton")
local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND

function HelpView:ctor(parentView)
	HelpView.super.ctor(self, parentView)
	self.parentView = parentView
	self.dimens_ = parentView.dimens_
	self:initView()
end

function HelpView:initView()
	self.background = jj.ui.JJImage.new({
		 image = "img/interim/ui/help_bg.png",
      })
    self.background:setAnchorPoint(ccp(0.5, 0.5))
    self.background:setPosition(0, 0)
    self.background:setScale(self.dimens_.scale_)
    self:addView(self.background)

    self.background_2 = jj.ui.JJImage.new({
         image = "img/interim/ui/emote_bg.png",
      })
    self.background_2:setAnchorPoint(ccp(0.5, 0.5))
    self.background_2:setPosition(0, 0)
    self.background_2:setScale(self.dimens_.scale_)
    self:addView(self.background_2)
   
    self:setAnchorPoint(ccp(0.5, 0.5))

    self.bgSize = CCSizeMake(self.background:getViewSize().width*self.background:getScaleX(),
    self.background:getViewSize().height*self.background:getScaleY())
    
    self.normalHelp = JJViewGroup.new()
    self:addView(self.normalHelp)

    -- local titleImage = jj.ui.JJImage.new({
    --      image = "img/interim/ui/help_title.png",
    --   })
    -- titleImage:setAnchorPoint(ccp(0.5, 0.5))
    -- titleImage:setPosition(self.dimens_:getDimens(-5), self.dimens_:getDimens(115))
    -- titleImage:setScale(self.dimens_.scale_)
    -- self.normalHelp:addView(titleImage)

    local titleLabel = jj.ui.JJLabel.new({
        fontSize = 30*self.dimens_.scale_,
        color = ccc3(253, 210, 97),
        text = "帮 助",
    })
    titleLabel:setAnchorPoint(ccp(0.5,0.5))
    titleLabel:setPosition(self.dimens_:getDimens(-10), self.dimens_:getDimens(117))
    self.normalHelp:addView(titleLabel)

    local normalLabel = jj.ui.JJLabel.new({
        fontSize = 22*self.dimens_.scale_,
        color = ccc3(252, 211, 97),
        viewSize = CCSize(430*self.dimens_.scale_, 0),
        text = "每人发2张牌，搏第3张牌，点数若在两张牌之间，则赢。",
    })
    normalLabel:setAnchorPoint(ccp(0.5,0.5))
    normalLabel:setPosition(0, self.dimens_:getDimens(-20))
    self.normalHelp:addView(normalLabel)

    self.islandHelp = JJViewGroup.new()
    self:addView(self.islandHelp)

    self.islandTitle = SegmentedButton.new({
        onImage = "img/interim/ui/island_help_title_1.png",
        offImage = "img/interim/ui/island_help_title_2.png"
    })
    self.islandHelp:addView(self.islandTitle)
    self.islandTitle:setPosition(self.dimens_:getDimens(-5), self.dimens_:getDimens(120))
    self.islandTitle:setScale(self.dimens_.scale_)
    self.islandTitle.delegate = self

    self.treasureNode = JJViewGroup.new()
    self.islandHelp:addView(self.treasureNode)

    local normalLabel = jj.ui.JJLabel.new({
        fontSize = 18*self.dimens_.scale_,
        color = ccc3(252, 211, 97),
        viewSize = CCSize(400*self.dimens_.scale_, 0),
        text = "宝藏是对特殊牌型的奖励。在自由桌卡中特殊牌型时，将在剩余牌库中抽取第4张甚至第5张牌，当组成特定牌型时，有以下奖励情况:",
    })
    normalLabel:setAnchorPoint(ccp(0.5,0.5))
    normalLabel:setPosition(0, self.dimens_:getDimens(60))
    self.treasureNode:addView(normalLabel)

    local fiveSequenceLabel = self:createTreasureLabel("五张同花顺")
    fiveSequenceLabel:setPosition(self.dimens_:getDimens(-200), self.dimens_:getDimens(0))
    self.treasureNode:addView(fiveSequenceLabel)

    self.treasureLabel_1 = self:createTreasureLabel("：总奖池0%")
    self.treasureLabel_1:setPosition(0, self.dimens_:getDimens(0))
    self.treasureNode:addView(self.treasureLabel_1)

    local foourAOrJLabel = self:createTreasureLabel("四条A/四条J")
    foourAOrJLabel:setPosition(self.dimens_:getDimens(-200), self.dimens_:getDimens(-30))
    self.treasureNode:addView(foourAOrJLabel)

    self.treasureLabel_2 = self:createTreasureLabel("：总奖池0%")
    self.treasureLabel_2:setPosition(0, self.dimens_:getDimens(-30))
    self.treasureNode:addView(self.treasureLabel_2)

    local foourSequenceLabel = self:createTreasureLabel("四张同花顺")
    foourSequenceLabel:setPosition(self.dimens_:getDimens(-200), self.dimens_:getDimens(-60))
    self.treasureNode:addView(foourSequenceLabel)

    self.treasureLabel_3 = self:createTreasureLabel("：总奖池0%")
    self.treasureLabel_3:setPosition(0, self.dimens_:getDimens(-60))
    self.treasureNode:addView(self.treasureLabel_3)

    local generalSequenceLabel = self:createTreasureLabel("普通四条")
    generalSequenceLabel:setPosition(self.dimens_:getDimens(-200), self.dimens_:getDimens(-90))
    self.treasureNode:addView(generalSequenceLabel)

    self.treasureLabel_4 = self:createTreasureLabel("：总奖池0%")
    self.treasureLabel_4:setPosition(0, self.dimens_:getDimens(-90))
    self.treasureNode:addView(self.treasureLabel_4)

    self.treasureNode:setPosition(0, self.dimens_:getDimens(-20))

    self.islandLabel = jj.ui.JJLabel.new({
        fontSize = 22*self.dimens_.scale_,
        color = ccc3(252, 211, 97),
        viewSize = CCSize(430*self.dimens_.scale_, 0),
        text = "每人发2张牌，搏第3张牌，点数若在两张牌之间，则赢。",
    })
    self.islandLabel:setAnchorPoint(ccp(0.5,0.5))
    self.islandLabel:setPosition(0, self.dimens_:getDimens(0))
    self.islandHelp:addView(self.islandLabel)
    self.islandLabel:setVisible(false)

    self:showIslandHelp()

    self:setTouchEnable(true)
end

function HelpView:onSegmentStatusChanged(button, status)
    if self.islandHelp:isVisible() ~= true then
        return
    end

    if status == true then
        self:showGameRule()
    else
        self:showTreasureHelp()
    end
end

function HelpView:reloadData()
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    self:showIslandHelp()

    local property = gameData.property
    local rate = property.fiveFlushRewardRate*100
    local text = "：总奖池" .. rate .. "%"
    self.treasureLabel_1:setText(text)

    rate = property.AJ4RewardRate*100
    text = "：总奖池" .. rate .. "%"
    self.treasureLabel_2:setText(text)

    rate = property.flushRewardRate*100
    text = "：总奖池" .. rate .. "%"
    self.treasureLabel_3:setText(text)

    rate = property.normal4RewardRate*100
    text = "：总奖池" .. rate .. "%"
    self.treasureLabel_4:setText(text)
end

function HelpView:createTreasureLabel(string)
    local treasureLabel = jj.ui.JJLabel.new({
        fontSize = 20*self.dimens_.scale_,
        color = ccc3(252, 211, 97),
        viewSize = CCSize(200*self.dimens_.scale_, 40*self.dimens_.scale_),
        text = string,
    })
    treasureLabel:setAnchorPoint(ccp(0,0.5))
    return treasureLabel
end

function HelpView:onTouchBegan(x, y)
    if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
        self:setTouchedIn(true)
        local pos = self:convertToNodeSpace(ccp(x, y))
        --JJLog.i("x y " .. pos.x .. " " .. pos.y)
        if pos.x > 186*self.dimens_.scale_
         and pos.y > 108*self.dimens_.scale_ then
            self.parentView:hideHelpView()
            SoundManager:playEffect(INTERIM_SOUND.BUTTON)
        
        end

        return true
    end
    return false
end

function HelpView:showIslandHelp()
    self.background_2:setVisible(false)
    self.background:setVisible(true)
    self.normalHelp:setVisible(false)
    self.islandHelp:setVisible(true) 
    self.islandTitle:setSwitchStatus(true)
    self:showGameRule()
end

function HelpView:showGameRule()
    self.islandLabel:setVisible(true)
    self.treasureNode:setVisible(false)
end

function HelpView:showTreasureHelp( ... )
    self.treasureNode:setVisible(true)
    self.islandLabel:setVisible(false)
end

return HelpView
