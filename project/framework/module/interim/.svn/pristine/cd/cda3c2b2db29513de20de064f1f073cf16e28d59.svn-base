
local PortraitView = class("PortraitView", jj.ui.JJImage)

function PortraitView:ctor(params)
	PortraitView.super.ctor(self, params)
	
	self.parentView = nil
	self:setTouchEnable(true)
end

function PortraitView:onTouchBegan(x, y)
	if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
		self:setTouchedIn(true)
		JJLog.i("点击头像")
		if self.parentView then
			self.parentView:onPortraitClicked(self)
		end
		return true
	end

	return false
end

return PortraitView
