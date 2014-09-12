local JJViewGroup = require("sdk.ui.JJViewGroup")
local PoolView = class("PoolView", JJViewGroup)

function PoolView:ctor(parentView)
	PoolView.super.ctor(self, parentView)
	self.parentView = parentView
	self.dimens_ = parentView.dimens_
	self:initView()
end

function PoolView:initView()
    local background = jj.ui.JJImage.new({
         image = "img/interim/ui/pool_bg.png",
      })
    background:setAnchorPoint(ccp(0.5, 0.5))
    background:setPosition(0, 0)
    background:setScale(self.dimens_.scale_)
    self:addView(background)

    local chip = jj.ui.JJImage.new({
         image = "img/interim/ui/chip_pile.png",
      })
    chip:setAnchorPoint(ccp(0.5, 0.5))
    chip:setPosition(0, self.dimens_:getDimens(50))
    chip:setScale(self.dimens_.scale_)
    self:addView(chip)

    self.numberLabel = jj.ui.JJLabel.new({
        fontSize = 18*self.dimens_.scale_,
        color = ccc3(255, 252, 157),
        textAlign = ui.TEXT_ALIGN_LEFT
    })
    self.numberLabel:setAnchorPoint(ccp(0.5,0.5))
    self:addView(self.numberLabel)
    self.numberLabel:setScale(self.dimens_.scale_)

    -- self.numberLabel = jj.ui.JJLabelBMFont.new({
    --      text="000",
    --      font="img/interim/ui/pool_num.fnt",
    -- })
    -- self.numberLabel:setAnchorPoint(ccp(0.5,0.5))
    -- self:addView(self.numberLabel)
    -- self.numberLabel:setScale(self.dimens_.scale_)

end

function PoolView:setCoin(coin)

   if coin ~= nil then
       local scoreString = InterimUtil:getStandBetChipsDisp(coin)
       self.numberLabel:setText(scoreString)
    end
    --self.numberLabel:setText(tostring(coin))
end

return PoolView
