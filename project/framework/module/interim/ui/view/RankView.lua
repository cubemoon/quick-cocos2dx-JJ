local JJViewGroup = require("sdk.ui.JJViewGroup")
local RankView = class("RankView", JJViewGroup)
local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND

function RankView:ctor(parentView)
	RankView.super.ctor(self, parentView)
	self.parentView = parentView
	self.dimens_ = parentView.dimens_
	self:initView()
end

function RankView:initView()

    local background = jj.ui.JJImage.new({
         image = "img/interim/ui/rank_panel.png",
      })
    background:setAnchorPoint(ccp(0, 0))
    background:setPosition(0, 0)
    self:addView(background)
    background:setScale(self.dimens_.scale_)

    local viewSize = background:getViewSize()
    self:setViewSize(viewSize.width*self.dimens_.scale_, viewSize.height*self.dimens_.scale_)
    self:setAnchorPoint(ccp(0, 0))
  
    self.titleLabel = jj.ui.JJLabel.new({
      fontSize = 20*self.dimens_.scale_,
      color = ccc3(175, 252, 182),
      text = "房间名称",
    })
    self.titleLabel:setAnchorPoint(ccp(0.5,0.5))
    self:addView(self.titleLabel)
    self.titleLabel:setPosition(viewSize.width/2*self.dimens_.scale_, self.dimens_:getDimens(45))

    self.rankLabel = jj.ui.JJLabel.new({
      fontSize = 20*self.dimens_.scale_,
      color = ccc3(175, 252, 182),
      text = "奖励进度：",
    })
    self.rankLabel:setAnchorPoint(ccp(0.5,0.5))
    self:addView(self.rankLabel)
    self.rankLabel:setPosition(viewSize.width/2*self.dimens_.scale_, self.dimens_:getDimens(17))

    self.baseLabel = jj.ui.JJLabel.new({
      fontSize = 16*self.dimens_.scale_,
      color = ccc3(175, 252, 182),
      text = "基数: ",
    })
    self.baseLabel:setAnchorPoint(ccp(0,0.5))
    self:addView(self.baseLabel)
    self.baseLabel:setPosition(self.dimens_:getDimens(13), self.dimens_:getDimens(15))

    self.raiseLabel = jj.ui.JJLabel.new({
      fontSize = 16*self.dimens_.scale_,
      color = ccc3(175, 252, 182),
      text = "涨盲 00:00:00",
    })
    self.raiseLabel:setAnchorPoint(ccp(1,0.5))
    self:addView(self.raiseLabel)
    self.raiseLabel:setPosition((viewSize.width-13)*self.dimens_.scale_, self.dimens_:getDimens(15))
  

    self:setTouchEnable(true)
end

function RankView:setBaseVisible(visible)
  self.baseLabel:setVisible(visible)
end

function RankView:setBase(text)
  self.baseLabel:setText(text)
end

function RankView:setRaise( text )
  self.raiseLabel:setText(text)
end

function RankView:setRaiseVisible(visible)
  self.raiseLabel:setVisible(visible)
end

function RankView:setRankVisible(visible)
  self.rankLabel:setVisible(visible)
end

function RankView:setRank(rankString)
  self.rankLabel:setText(rankString)
end

function RankView:setRoomTitle(title)
  self.titleLabel:setText(title)
end

function RankView:onTouchBegan(x, y)
    if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
    self:setTouchedIn(true)
    self.parentView:rankViewTouched()
   -- audio.playSound(INTERIM_SOUND.BUTTON)
    SoundManager:playEffect(INTERIM_SOUND.BUTTON)
  
    return true
  end
  return false
end

return RankView
