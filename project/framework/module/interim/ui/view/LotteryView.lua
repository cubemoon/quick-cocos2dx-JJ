local JJViewGroup = require("sdk.ui.JJViewGroup")
local LotteryView = class("LotteryView", JJViewGroup)
local AnimationFactory = require("interim.util.AnimationFactory")

local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND

function LotteryView:ctor(parentView)
	LotteryView.super.ctor(self, parentView)
	self.parentView = parentView
	self.dimens_ = parentView.dimens_
	self:initView()
end

function LotteryView:initView()
	local background = jj.ui.JJImage.new({
         image = "img/interim/ui/dealer_machine.png",
      })
    background:setAnchorPoint(ccp(0, 0))
    background:setPosition(0, 0)
    --background:setScale(self.dimens_.scale_)
    self:addView(background)

    self.viewSize = background:getViewSize()
    self:setViewSize(self.viewSize.width, self.viewSize.height)
    self:setAnchorPoint(ccp(0.5,1))

    self.numberLabel = jj.ui.JJLabel.new({
        fontSize = 16*self.dimens_.scale_,
        color = ccc3(255, 255, 255),
        textAlign = ui.TEXT_ALIGN_LEFT
    })
    self.numberLabel:setScale(1)
    self.numberLabel:setAnchorPoint(ccp(0.5,0.5))
    self:addView(self.numberLabel)
    self.numberLabel:setPosition(self.viewSize.width/2, 77)

    -- self.numberLabel = jj.ui.JJLabelBMFont.new({
    --      text="",
    --      font="img/interim/ui/lottary_num.fnt",
    -- })
    -- self.numberLabel:setScale(1)
    -- self.numberLabel:setAnchorPoint(ccp(0.5,0.5))
    -- self:addView(self.numberLabel)
    -- self.numberLabel:setPosition(self.viewSize.width/2, 70)
  
    self:setTouchEnable(true)

    --self:lightBlink()
end

function LotteryView:lightBlink()
    
    self.ligtht = display.newSprite("#ligtht_2.png")
    self.ligtht:setAnchorPoint(ccp(0.5,1))
    self.ligtht:setPosition(self.viewSize.width/2+2, self.viewSize.height)
    self:getNode():addChild(self.ligtht)
    self.ligtht:setVisible(true)
    
    local array = CCArray:create()
    local blink = CCBlink:create(30, 60)
    array:addObject(blink)

    local callFunc = CCCallFunc:create(handler(self, self.lightBlinkEnd))
    array:addObject(callFunc)
    local sequence = CCSequence:create(array)
    self.ligtht:runAction(sequence)
end

function LotteryView:lightBlinkEnd()
  self.ligtht:setVisible(false)
  local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
  gameData.recieveNewWiner = false
end

function LotteryView:setNumber(lottery)
  if lottery ~= nil then
       local scoreString = InterimUtil:getStandBetChipsDisp(lottery)
       self.numberLabel:setText(scoreString)
    end
  --self.numberLabel:setText(tostring(lottery))
end

function LotteryView:onTouchBegan(x, y)
  if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
    self:setTouchedIn(true)
    self.parentView:showLotteryDetail()
    audio.playSound(INTERIM_SOUND.BUTTON)

    return true
  end
  return false
end

return LotteryView
