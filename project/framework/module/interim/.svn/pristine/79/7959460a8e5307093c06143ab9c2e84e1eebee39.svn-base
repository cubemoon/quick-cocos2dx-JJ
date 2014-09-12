local JJViewGroup = require("sdk.ui.JJViewGroup")
local AlertView = class("AlertView", JJViewGroup)
local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND
function AlertView:ctor(parentView)
	AlertView.super.ctor(self, parentView)
	self.parentView = parentView
    self.positionConfig = parentView.positionConfig
	self.dimens_ = parentView.dimens_
	self:initView()
end

function AlertView:initView()

    function onButtonClicked(sender)
       self.parentView:hideAlertView()
    end

	local background = jj.ui.JJImage.new({
		 image = "img/interim/ui/emote_bg.png",
      })
    background:setAnchorPoint(ccp(0.5, 0.5))
    background:setPosition(0, 0)
    background:setScale(self.dimens_.scale_)
    self:addView(background)
   
    self:setAnchorPoint(ccp(0.5, 0.5))

    self.bgSize = CCSizeMake(background:getViewSize().width*self.dimens_.scale_,
    background:getViewSize().height*self.dimens_.scale_)
    
    self.titleLabel = jj.ui.JJLabel.new({
    	fontSize = 30*self.dimens_.scale_,
        color = ccc3(252, 217, 97),
        text = "提 示",
    })
    self.titleLabel:setAnchorPoint(ccp(0.5,0.5))
    self.titleLabel:setPosition(self.dimens_:getDimens(-5), self.dimens_:getDimens(117))
    self:addView(self.titleLabel)

    self:setTouchEnable(true)

     self.contentLabel = jj.ui.JJLabel.new({
        fontSize = 25*self.dimens_.scale_,
        color = ccc3(252, 217, 97),
        text = "您的金币过低，请补充后继续",
        singleLine=false,
    })
    self.contentLabel:setAnchorPoint(ccp(0.5,0.5))
    self.contentLabel:setPosition(self.dimens_:getDimens(-10), self.dimens_:getDimens(0))
    self:addView(self.contentLabel)
    self.contentLabel:setViewSize(self.dimens_:getDimens(400), self.dimens_:getDimens(300))

end

function AlertView:show(title, message)
    self:setVisible(true)
    self.titleLabel:setText(title)
    self.contentLabel:setText(message)
end

function AlertView:onTouchBegan(x, y)
    if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
        self:setTouchedIn(true)
        local pos = self:convertToNodeSpace(ccp(x, y))
        -- JJLog.i("x y " .. pos.x .. " " .. pos.y)
        if pos.x > 184*self.dimens_.scale_
         and pos.y > 104*self.dimens_.scale_ then
           self.parentView:hideAlertView()
           SoundManager:playEffect(INTERIM_SOUND.BUTTON)
        
        end
        return true
    end
    return false
end

return AlertView
