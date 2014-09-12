local JJViewGroup = import(".JJViewGroup")

local JJSeekBar = class("JJSeekBar", JJViewGroup)

JJSeekBar.BACKGROUND_ZORDER = -10
JJSeekBar.PROGRESS_ZORDER = 0
JJSeekBar.THUMB_ZORDER = 10
local TAG = "JJSeekBar"
--[[
params: table type
   background: table type, see JJView background parameter
       image: string type, image name
       scale9: bool type
   images: table type
       progress: string type, progress image name
       thumb: string type, thumb image name
       
   minimum: the minimu of the seekbar
   maxmum: the maxmum of the seekbar
   value: current value of the seekbar
--]]
function JJSeekBar:ctor(params)
--   JJLog.i(TAG, "ctor()")
   JJSeekBar.super.ctor(self, params)
   self.progressSprite_ = nil
   self.thumbSprite_ = nil
   self.value_ = params.value or 0
   self.minimumValue_ = params.minimum or 0
   self.maximumValue_ = params.maxmum or 1
   self.minimumAllowedValue_ = params.minimum or 0
   self.maximumAllowedValue_ = params.maxmum or 1
   self.changedListener_ = nil
   
   self:setAnchorPoint(CCPoint(0,1))
      
   self:setProgressImage(params.images["progress"])
   self:setThumbImage(params.images["thumb"])
   
   local maxRect   = CCControlUtils:CCRectUnion(self.bg_:boundingBox(), self.thumbSprite_:boundingBox());
   if params.viewSize == nil then
	  local w = self.bg_:getContentSize().width + self.thumbSprite_:getContentSize().width	  
	  self:setViewSize(w, maxRect.size.height);
   end

   local left = self:getViewSize().width/2
   local top = self:getViewSize().height/2

   self.bg_:setAnchorPoint(CCPoint(0.5, 0.5))   
   self.bg_:setPosition(ccp(left, top))
   
   self.progressSprite_:setAnchorPoint(CCPoint(0, 0.5))
   self.progressSprite_:setPosition(ccp(self.thumbSprite_:getContentSize().width/2, top))

   self.thumbSprite_:setPosition(ccp(0, top))

   self:setValue(self.minimumValue_)
end


function JJSeekBar:setProgressImage(image)
   JJLog.i(TAG, "JJSeekBar:setProgressImage() image="..image)
   if not image then
	  JJLog.i(TAG, "ERROR: image == nil")
   end

   if self.progressSprite_ then
	  self.progressSprite_:removeFromParent()
	  self.progressSprite_ = nil
   end

   self.progressSprite_ = display.newSprite(image)
   self:getNode():addChild(self.progressSprite_, self.PROGRESS_ZORDER)
   --self:relayout()
end

function JJSeekBar:setThumbImage(image)
   JJLog.i(TAG, "JJSeekBar:setThumbImage() image="..image)
   if not image then
	  JJLog.i(TAG, "ERROR: image == nil")
   end

   if self.thumbSprite_ then
	  self.thumbSprite_:removeFromParent()
	  self.thumbSprite_ = nil
   end

   self.thumbSprite_ = display.newSprite(image)
   self.thumbSprite_:setAnchorPoint(ccp(0, 0.5))
   self:getNode():addChild(self.thumbSprite_, self.THUMB_ZORDER)
   --self:relayout()
end

function JJSeekBar:getThumbImage()
   return self.thumbSprite_
end

function JJSeekBar:setMinimumValue(value)
   JJLog.i(TAG, "setMinimumValue() value="..value)
   self.minimumAllowedValue = value
   self.minimumValue_ = value
   self:relayout()
end

function JJSeekBar:setMaximumValue(value)
   JJLog.i(TAG, "setMaximumValue() value="..value)
   self.maximumValue_ = value
   self.maximumAllowedValue_ = value
   self:relayout()
end

function JJSeekBar:isTouchInside(x, y)
   if self.thumbSprite_ then
	  return self.thumbSprite_:getCascadeBoundingBox():containsPoint(CCPoint(x, y))
   else
	  JJLog.i(TAG, "ERROR: thumbSprite_ == nil")
   end

end

function JJSeekBar:locationFromTouch(x, y)

   local location = self:convertToNodeSpace(CCPoint(x, y))
   if location.x < 0 then
	  location.x = 0
   elseif location.x > self.bg_:getContentSize().width then
	  location.x = self.bg_:getContentSize().width
   end

   return location
end

function JJSeekBar:relayout()
   JJLog.i(TAG, "JJSeekBar:relayout()")
   if not self.bg_ or not self.progressSprite_ or not self.thumbSprite_ then
	  JJLog.i(TAG, "ERROR: relayout sprite == nil")
	  return
   end

   local bgSize = self.bg_:getContentSize()
   local left = self:getWidth()/2
   local top = self:getHeight()/2
   
   JJLog.i(TAG, "top="..top)
   self.bg_:setPosition(ccp(left, top))
   
  
   percent = (self.value_ - self.minimumValue_)/(self.maximumValue_ - self.minimumValue_)
   local x, y  = self.thumbSprite_:getPosition()
   --JJLog.i(TAG, "thumbSpritePos.x="..x..", thumbSpritePos.y="..y)  
   x = percent * self.bg_:getContentSize().width
   JJLog.i(TAG, "thumbSpritePos.x="..x..", thumbSpritePos.y="..y)  

   self.thumbSprite_:setPosition(CCPoint(x,y))
   
   local textureRect = self.progressSprite_:getTextureRect()
   textureRect = CCRectMake(textureRect.origin.x, textureRect.origin.y, x, textureRect.size.height)

   self.progressSprite_:setTextureRect(textureRect, self.progressSprite_:isTextureRectRotated(), textureRect.size)
end


function JJSeekBar:valueForLocation(location)
   JJLog.i(TAG, "JJSeekBar:valueForLocation() x="..location.x..", y="..location.y)
   local percent = location.x / self.bg_:getContentSize().width
   JJLog.i(TAG, "percent="..percent)
   local value =  math.max(math.min(self.minimumValue_ + percent * (self.maximumValue_ - self.minimumValue_), self.maximumAllowedValue_), self.minimumAllowedValue_)
   JJLog.i(TAG, "value="..value)
   return value
end

function JJSeekBar:onTouch(event, x, y)
   JJLog.i(TAG, "JJSeekBar:onTouch() event="..event)
   if event == "began" then
	  if self:isTouchInside(x, y) then
		 self:setTouchedIn(true)
		 --local location = self:locationFromTouch(x, y)
		 --self:sliderBegan(location)
		 return true
	  end
   elseif event == "moved" then
	  if self:isTouchedIn() then
		 local location = self:locationFromTouch(x, y)
		 self:sliderMoved(location)
	  end
   elseif event == "ended" then
	  if self:isTouchedIn() then
		 self:sliderEnded(CCPoint(0,0))
		 self:setTouchedIn(false)
		 end
   elseif event == "cancelled" then
	  JJLog.i(TAG, "event cancelled")
	  self:setTouchedIn(false)
   end

   return false
end

function JJSeekBar:sliderBegan(location)
   self:setFocus(true)
   self:getThumbImage():setColor(ccc3(166, 166, 166))--(ccGRAY);
   self:setValue(self:valueForLocation(location))
end

function JJSeekBar:sliderMoved(location)
   self:setValue(self:valueForLocation(location))
end

function JJSeekBar:sliderEnded(location)
   if self:isFocus() then
	  self:setValue(self:valueForLocation(self.thumbSprite_:getPositionInCCPoint()))
   end
   self:getThumbImage():setColor(ccc3(255, 255, 255))
   self:setFocus(false)
end

function JJSeekBar:getValue()
   return self.value_
end

function JJSeekBar:setValue(value)
   if value < self.minimumValue_ then
	  value = self.minimumValue_
   end

   if value > self.maximumValue_ then
	  value = self.maximumValue_
   end

   self.value_ = value
   self:relayout()

   if self.changedListener_ then
	  self.changedListener_(self)
   end
end

function JJSeekBar:setOnSeekBarChangeListener(listener)
   self.changedListener_ = listener
end

function JJSeekBar:shouldHandDownInterIntercept()
	return true
end

return JJSeekBar
