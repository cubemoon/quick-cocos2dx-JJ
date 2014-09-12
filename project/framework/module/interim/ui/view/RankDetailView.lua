local JJViewGroup = require("sdk.ui.JJViewGroup")
local RankDetailView = class("RankDetailView", JJViewGroup)

function RankDetailView:ctor(parentView)
	RankDetailView.super.ctor(self, parentView)
	self.parentView = parentView
	self.dimens_ = parentView.dimens_
	self:initView()
end

function RankDetailView:initView()
	local background = jj.ui.JJImage.new({
		 image = "img/interim/ui/rank_detail.png",
      })
    background:setAnchorPoint(ccp(0.0, 0.0))
    background:setPosition(0, 0)
    background:setScale(self.dimens_.scale_)
    self:addView(background)

    local tmpviewSize = background:getViewSize()
   -- JJLog.i("viewSize " .. viewSize.width .. " " .. viewSize.height)
    self:setViewSize(tmpviewSize.width*self.dimens_.scale_, tmpviewSize.height*self.dimens_.scale_)
    local viewSize = background:getViewSize()
    self.titleLabel = jj.ui.JJLabel.new({
        fontSize = 22*self.dimens_.scale_,
        color = ccc3(253, 210, 97),
        text = "任务",
    })
    self:addView(self.titleLabel)
    self.titleLabel:setAnchorPoint(ccp(0.5, 1))
    self.titleLabel:setPosition( self.dimens_:getDimens(viewSize.width/2) ,self.dimens_:getDimens(viewSize.height*0.95))
 
    local separatorUp = jj.ui.JJImage.new({
         image = "img/interim/ui/separator.png",
      })
    separatorUp:setPosition( self.dimens_:getDimens(viewSize.width/2), self.dimens_:getDimens(viewSize.height*0.8))
    separatorUp:setScale(0.6 * self.dimens_.scale_ )
    self:addView(separatorUp)

    local descLabel = jj.ui.JJLabel.new({
        fontSize = 22*self.dimens_.scale_,
        color = ccc3(253, 210, 97),
        text = "描述",
    })
    self:addView(descLabel)
    descLabel:setAnchorPoint(ccp(0, 1))
    descLabel:setPosition( self.dimens_:getDimens(viewSize.width*0.05), self.dimens_:getDimens(viewSize.height*0.78) )

    local progressLabel = jj.ui.JJLabel.new({
        fontSize = 22*self.dimens_.scale_,
        color = ccc3(253, 210, 97),
        text = "进度",
    })
    self:addView(progressLabel)
    progressLabel:setAnchorPoint(ccp(1, 1))
    progressLabel:setPosition( self.dimens_:getDimens(viewSize.width*0.95), self.dimens_:getDimens(viewSize.height*0.78) )

    local separatorDown = jj.ui.JJImage.new({
         image = "img/interim/ui/separator.png",
      })
    separatorDown:setPosition( self.dimens_:getDimens(viewSize.width/2), self.dimens_:getDimens( viewSize.height*0.63) )
    separatorDown:setScale(0.6 * self.dimens_.scale_ )
    self:addView(separatorDown)

    local sublabelPos = self.dimens_:getDimens(10)
    local sublabelFontSize = 16*self.dimens_.scale_
    self.rankLabel = jj.ui.JJLabel.new({
        fontSize = sublabelFontSize,
        color = ccc3(255, 255, 255),
        text = "当前排名：1/100",
    })
    self:addView(self.rankLabel)
    self.rankLabel:setPosition(sublabelPos,self.dimens_:getDimens(110))
    self.rankLabel:setVisible(false)

    self.qiukaLabel = jj.ui.JJLabel.new({
        fontSize = sublabelFontSize,
        color = ccc3(255, 255, 255),
        text = "每4局送2秋卡",
    })
    self:addView(self.qiukaLabel)
    self.qiukaLabel:setPosition( self.dimens_:getDimens(viewSize.width*0.05), self.dimens_:getDimens(viewSize.height*0.48) )

    self.qiukaProgLabel = jj.ui.JJLabel.new({
        fontSize = sublabelFontSize,
        color = ccc3(255, 255, 255),
        text = "10/100",
    })
    self:addView(self.qiukaProgLabel)
    self.qiukaProgLabel:setAnchorPoint( ccp(1,0.5) )
    self.qiukaProgLabel:setPosition( self.dimens_:getDimens(viewSize.width*0.95), self.dimens_:getDimens(viewSize.height*0.54) )

    self.emeraldLabel = jj.ui.JJLabel.new({
        fontSize = sublabelFontSize,
        color = ccc3(255, 255, 255),
        text = "每x局送y翡翠粒",
    })
    self:addView(self.emeraldLabel)
    self.emeraldLabel:setPosition( self.dimens_:getDimens(viewSize.width*0.05), self.dimens_:getDimens(viewSize.height*0.35) )

    self.emeraldProgLabel = jj.ui.JJLabel.new({
        fontSize = sublabelFontSize,
        color = ccc3(255, 255, 255),
        text = "10/100",
    })
    self:addView(self.emeraldProgLabel)
    self.emeraldProgLabel:setAnchorPoint( ccp(1,0.5) )
    self.emeraldProgLabel:setPosition( self.dimens_:getDimens(viewSize.width*0.95), self.dimens_:getDimens( viewSize.height*0.41) )

    self.baseLabel = jj.ui.JJLabel.new({
        fontSize = 19*self.dimens_.scale_,
        color = ccc3(255, 255, 255),
        text = "基数",
    })
    self:addView(self.baseLabel)
    self.baseLabel:setAnchorPoint( ccp(0,1) )
    self.baseLabel:setPosition( self.dimens_:getDimens(viewSize.width*0.05), self.dimens_:getDimens( viewSize.height*0.15 ) )

    self:setAnchorPoint(ccp(0, 1))
    self:setTouchEnable(true)
end

function RankDetailView:onTouchBegan(x, y)
    if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
        self:setTouchedIn(true)
        return true
    end
    return false
end

function RankDetailView:show()
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)
 
    local playerInfo = gameData:getMyPlayerInfo()
    if gameData.property.isTourny == true then
        self.titleLabel:setText(gameData.matchName)
        
        local rankText = "排名：" .. gameData.rank .. "/" .. gameData.leavePlayer
       -- JJLog.i("排名信息:" .. rankText)
        self.rankLabel:setText(rankText)

        local baseText = "基数：" 
        if matchData.roundInfo_ ~= nil then
            baseText = baseText .. matchData.roundInfo_.scoreBase_
        else
            baseText = "基数：0" 
        end
        self.baseLabel:setText(baseText)

        local qiuka = "当前阶段："
        local emerald = "当前赛制："
        if matchData.roundInfo_ ~= nil then
            -- qiuka = qiuka .. "赛段" .. matchData.roundInfo_.roundType_
            -- .. "-第" .. matchData.roundInfo_.gameId_ .. "轮第" .. 
            -- matchData.roundInfo_.roundId_ .. "局"
            qiuka = qiuka .. "第" .. matchData.roundInfo_.gameId_ .. "轮第" .. 
            gameData.roundInfo.roundId .. "局"

            emerald = emerald .. matchData.roundInfo_.roundTypeName_
        end

        self.qiukaLabel:setText(qiuka)
        self.emeraldLabel:setText(emerald)
    end
end

return RankDetailView
