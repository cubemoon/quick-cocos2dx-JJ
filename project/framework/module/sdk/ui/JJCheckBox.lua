local JJView  = import(".JJView")

local JJCheckBox = class("JJCheckBox", JJView)

JJCheckBox.ON = "on"
JJCheckBox.ON_PRESSED = "on_pressed"
JJCheckBox.ON_DISABLED = "on_disabled"
JJCheckBox.OFF = "off"
JJCheckBox.OFF_PRESSED = "off_pressed"
JJCheckBox.OFF_DISABLED = "off_disabled"

local TAG = "JJCheckBox"
--[[
   params: table type
       images: table type
           on: string type, on state image file name
           off: string type, off state image file name
           on_disable: string type, on disable image name
           off_disable: string type, off disable image name
           scale9: 是否是2dx 9宫格格式的图片
	       size: the size of the images
       label: table type, checkbox caption
           font: 字体
           fontSize: 字体大小
           color: 字体颜色
           text: 内容
       
       sound：on click时播放的声音

       state: 初始状态 "on" or "off"
--]]
function JJCheckBox:ctor(params)
   JJCheckBox.super.ctor(self, params)
   self:setTouchEnable(true)
   self.bSelected = false
   self.checkedChangeListener_ = nil
   self.sprite_ = nil
   self.label_ = nil
   self.labels_ = {}
   self.images_ = {}
   self.state_ = (params and params.state) or "off"
   self.scale9_ = params and params.scale9
   self.scale9Size = nil
   self.imageSize_ = (params and params.images and params.images.size) or nil
   self.labelOffset_ = {0,0}
  
   self.currentImage_ = nil
   self.sound_ = params and params.sound
      if self.sound_ then
	  JJLog.i(TAG,"self.sound_="..self.sound_)
   else
	  JJLog.i(TAG,"self.sound_ == nil")
   end

   self:setImage("on", params.images["on"])
   self:setImage("off", params.images["off"])

   if params.label ~= nil then
	  self:setLabel(params.label)
   end
   self:relayout()
end

function JJCheckBox:setLabelOffset(x, y)
   self.labelOffset_[1] = x
   self.labelOffset_[2] = y
   self:relayout()
end

function JJCheckBox:setImage(state, image)

   if not image then 
	  JJLog(TAG, "ERROR image == nil")
	  return 
   end

   self.images_[state] = image
  
   self:relayout()
   return self
end

function JJCheckBox:updateButtonImage_()
   if not self.images_ then
    return
   end

   local state = self:getState()
   local image = self.images_[state]
  
   if not image then
	  echoError("JJCheckBox:updateButtonImage_() not image for state")
	  return
   end

   if self.currentImage_ ~= image then
	  if self.sprite_ then
		 self.sprite_:removeFromParentAndCleanup(true)
		 self.sprite_ = nil
	  end
	  
	  self.currentImage_ = image
	  if self.scale9_ then
		 self.sprite_ = display.newScale9Sprite(image)
		 if not self.scale9Size_ then
			local size = self.sprite_:getContentSize()
			self.scale9Size_ = {size.width, size.height}
		 else
			self.sprite_:setContentSize(CCSize(self.scale9Size[1], self.scale9Size[2]))
		 end
	  else
		 self.sprite_ = display.newSprite(image)
		 if self.imageSize_ ~= nil then
			 local cntSize = self.sprite_:getContentSize()
			 local scaleX = self.imageSize_.width/cntSize.width
			 local scaleY = self.imageSize_.height/cntSize.height
			 self.sprite_:setScaleX(scaleX)
			 self.sprite_:setScaleY(scaleY)
		 end
	  end
	  self:getNode():addChild(self.sprite_, -1)
   else
   end
   -- local cntSize = self.sprite_:getContentSize()
  -- self:setViewSize(cntSize.width, cntSize.height)
   self.sprite_:setAnchorPoint(ccp(0,0))
   self.sprite_:setPosition(0,0)
   
end

--[[
   lablel: table type
       font: 字体
       fontSize: 字体大小
       color: 字体颜色
       text: 内容
--]]
function JJCheckBox:setLabel(label)
 
   assert(label ~= nil, "invalid label")
   
   if self.label_ ~= nil then
	  self.label_:removeFromParent()
   end
   self.label_ = ui.newTTFLabel({
								   font=label.font,
								   size=label.fontSize,
								   color=label.color,
								   text=label.text
   })
   self:getNode():addChild(self.label_, 0)
   
   self:relayout()
  return self
end


function JJCheckBox:updateButtonLabel_()
   if self.label_ == nil then
	  return
   end

   local ox, oy = self.labelOffset_[1], self.labelOffset_[2]
   if self.sprite_ then
	  local ap = self:getAnchorPoint()
	  local spriteSize = self.sprite_:getContentSize()
	  
	  if self.imageSize_ ~= nil then
		  JJLog.i(TAG, "self.imageSize_=(", self.imageSize_.width, self.imageSize_.height, ")")
		  spriteSize = self.imageSize_
	  end
	  ox = ox + spriteSize.width 

	  local w = self.label_:getContentSize().width + self.labelOffset_[1] + spriteSize.width
	  local h = spriteSize.height
	  if w < spriteSize.width then
		  w = spriteSize.width
	  end
	  self:setViewSize(w, h)
	  
	  self.label_:setAnchorPoint(ccp(0,0.5))
	  self.label_:setPosition(ccp(ox, spriteSize.height/2))
   end

end


function JJCheckBox:setEnable(flag)
   if flag ~= self:isEnable() then
	  if flag == false then
		  if self.sprite_ ~= nil then
			  self.sprite_:setOpacity(170)
		  end
		  
		  if self.label_ ~= nil then
			  self.label_:setOpacity(45)
		  end
	  else
		  if self.sprite_ ~= nil then
			  self.sprite_:setOpacity(255)
		  end
		  if self.label_ ~= nil then
			  self.label_:setOpacity(255)
		  end
	  end
   end
   JJCheckBox.super.setEnable(self, flag)
end
function JJCheckBox:setOnCheckedChangeListener(listener)
   self.checkedChangeListener_= listener
end

function JJCheckBox:isSelected()
   return self.bSelected
end

function JJCheckBox:setChecked(flag)
  self:setSelected(flag, false)  
end

function JJCheckBox:setSelected(flag, bnotify)
   JJLog.i(TAG, "setSelected("..tostring(flag)..")")
   if self.bSelected ~= flag then
	  self.bSelected = flag
	  if flag == true then
		 self:setState(self.ON)
	  else
		 self:setState(self.OFF)
	  end
	  
	  if self.checkedChangeListener_ ~= nil and bnotify then
		  local sound = jj.ui.getOnClickSound()
		  if sound ~= nil then
			  JJLog.i(TAG, "sound=", sound)
			  audio.playSound(sound)
		  end

		 self.checkedChangeListener_(self)
	  end

	  self:relayout()
   end
end

function JJCheckBox:relayout()
   self:updateButtonImage_()
   self:updateButtonLabel_()
end

function JJCheckBox:onTouchBegan(x, y)
	JJCheckBox.super.onTouchBegan(self, x, y)

	JJLog.i(TAG,"OK is touch inside")
	self:setTouchedIn(true)
	return true
end

function JJCheckBox:onTouchEnded(x, y)
	
	if self:isTouchedIn() then
		self:setSelected(not self.bSelected, true)
	end

	JJCheckBox.super.onTouchEnded(self, x, y)
end

return JJCheckBox
