local JJView = import(".JJView")
local JJViewGroup = import(".JJViewGroup")
local JJEditBox = class("JJEditBox", JJViewGroup)
JJInputMethodManager = require("sdk.ui.JJInputMethodManager")

local TAG = "JJEditBox"
--[[
	params: 参数说明
	1. normal: normal background image
	2. highlight: pressed state bg image
	3. disable: disable state 
	4. viewSize: view size
	5. align: 水平对齐
	6. valign:竖直对齐
	7. singleLine: 是否单行， 默认为单行
	8. selectAllOnFocus: 编辑控件获得焦点时编辑内容是否全部选中, 缺省不全部选中
--]]
function JJEditBox:ctor(params)
	JJEditBox.super.ctor(self, params)
	
	local normal = params.normal
	local highlight = params.highlight
	local disable = params.disable
	self.bSelectAllOnFocus_ = params.selectAllOnFocus or false
	self.listener_ = params.listener
	self.font_ = "arial"
	self.fontSize_ = 12
	local bSingle = true
	if params.singleLine ~= nil then
		bSingle = params.singleLine
	else
		JJLog.i(TAG, "params.singleLine == nil")
		bSingle = true
	end
	self.bSingleLine_ = bSingle
	--   self.impl_ = JJEditBoxImpl:create(params.viewSize)
	if JJFunctionManager:instance():supportFunction("JJEditBoxImpl::create(size,bSingleLine)") == true then
		self.impl_ = JJEditBoxImpl:new(params.viewSize, bSingle)
	else
		self.impl_ = JJEditBoxImpl:new(params.viewSize)
	end
	
	if self.impl_ ~= nil then
		self.impl_:registerScriptEditBoxHandler(handler(self, self._EditorEventListener))
	end

	self:setViewSize(params.viewSize.width, params.viewSize.height) 

	JJLog.i(TAG, "self.bSingleLine_=", self.bSingleLine_)
	local btn = jj.ui.JJButton.new({
									   images={
										   normal=normal,
										   highlight=highlight,
										   disable=disable,
										   scale9 = true,
									   },
									   viewSize = CCSize(self.viewSize_.width, self.viewSize_.height),
	})
	
	btn:setAnchorPoint(ccp(0, 1))
	local left = 0;
	local top = params.viewSize.height
	
	btn:setPosition(ccp(left, top))
	btn:setOnClickListener(function (view) 
							   print("edit btn onClick open editbox")
							   if self.impl_ ~= nil then

								   -- self.impl_:openKeyboard();
								   self:openKeyboard()
							   end
	end)
	self:addView(btn)

	self.listener_ = params.listener

	if params.x and params.y then
		self:setPosition(ccp(0,1))
		JJLog.i(TAG, "pos=("..params.x..", "..params.y..")")
		self:setPosition(ccp(params.x, params.y))
		self.impl_:setPosition(ccp(params.x, params.y+params.viewSize.height))
	end
	
	local size = CCSize(self:getWidth()-self:getPaddingLeft()-self:getPaddingRight(), self:getHeight()-self:getPaddingTop()-self:getPaddingBottom())

	local align = params.align or ui.TEXT_ALIGN_LEFT
	local valign = params.valign or ui.TEXT_VALIGN_CENTER
	if align == ui.TEXT_ALIGN_LEFT then
		JJLog.i(TAG, "align == ui.TEXT_ALIGN_LEFT")
	end

	if valign == ui.TEXT_VALIGN_TOP then
		JJLog.i(TAG, "valign == ui.TEXT_VALIGN_TOP")
	end

	JJLog.i(TAG, "align=", align, ", valign=", valign)
	JJLog.i(TAG, "size.w=", size.width, ", size.h=", size.height)
	local label_ = jj.ui.JJLabel.new({
										 text=" ",
										 fontSize=self.viewSize_.height*2/3,
										 color = ccc3(255,255,255),
										 viewSize=size,
										 align=align,
										 valign=valign,
										 dimensions=size,
										 maxSize=size,
										 singleLine = bSingle,
	})
	
	self:addView(label_)
	label_:setVisible(false)
	local placeholderLabel_ = jj.ui.JJLabel.new({
													text=" ",
													fontSize=self.viewSize_.height*2/3,
													color = ccc3(150,150,150), --ccGRAY
													viewSize=size,
													align=align,
													valign=valign,
													dimensions=size,
													maxSize=size
													
	})
	self:addView(placeholderLabel_)

	left = 0 + self:getPaddingLeft()
	top = self.viewSize_.height - self:getPaddingTop()
	
	label_:setAnchorPoint(ccp(0, 1))
	placeholderLabel_:setAnchorPoint(ccp(0, 1))
	label_:setPosition(ccp(left, top))
	placeholderLabel_:setPosition(ccp(left, top))
	self.label_ = label_
	self.placeholderLabel_ = placeholderLabel_

	self:setPadding(self:getPadding())
end

function JJEditBox:_EditorEventListener(event, edit)
	local bTextVisible = false
	local text = edit:getText()
	local len = string.len(text) 
		
	JJLog.i("JJEditBox", "event=", event, "text=", text)

	if event == "ended" then

		if len  > 0 then
			bTextVisible = true
			local temp = text
			local label = self.label_
			
			if self.inputFlag_ ~= kEditBoxInputFlagPassword then
			else
				temp = string.rep("*", len)
			end
				
			if self.label_ ~= nil then
				self.label_:setText(temp)
				if self.fontColor_ ~= nil then
					self.label_:setColor(self.fontColor_)
				end
				self.label_:setVisible(true)
			end
			if self.placeholderLabel_ ~= nil then
				self.placeholderLabel_:setVisible(false)
			if self.placeHolderFontColor_ ~= nil then
				self.placeholderLabel_:setColor(self.placeHolderFontColor_)
			end
			end
		else
			if event == "ended" then
				bTextVisible = false
			else
				bTextVisible = true
			end
			if self.label_ ~= nil then
				self.label_:setText("")
				self.label_:setVisible(bTextVisible)
			end

			if self.placeholderLabel_ ~= nil then
				self.placeholderLabel_:setVisible(not bTextVisible)
			end
		end

	elseif event == "changed" then

		if self.label_ ~= nil then
			self.label_:setVisible(false)
		end

		if self.placeholderLabel_ ~= nil then
			self.placeholderLabel_:setVisible(false)
		end
		
		local temp = text

		if self.inputFlag_ ~= kEditBoxInputFlagPassword then
			temp = string.rep("*", len)
		end
		
		if self.label_ ~= nil then
			self.label_:setText(temp)
		end
		
	end

	if self.listener_ ~= nil then
		self.listener_(event, edit)
	end
end
function JJEditBox:openKeyboard()
	JJLog.i(TAG, "openKeyboard() IN")
	
	if JJInputMethodManager.canShowSoftKeyboard() ~= true then
		JJLog.i(TAG, "ERROR: can not open softkey board")
		return
	end

	if self.impl_ ~= nil then

		local function onEnterBackground()
			JJLog.i("JJEditBox", "onEnterBackground() IN")
			if self.label_ == nil then
				-- JJLog.i("JJEditBox", "ERROR self.label_ == nil just return")
				return
			end

			local text = self.label_:getText()
			if string.len(text) == 0 then
				self.label_:setVisible(false)
				self.placeholderLabel_:setVisible(true)
			else
				self.label_:setVisible(true)
				self.placeholderLabel_:setVisible(false)
			end
			JJLog.i("JJEditBox", "before self:closeKeyboard()")
			self:closeKeyboard()
			JJLog.i("JJEditBox", "after self:closeKeyboard()")
			JJLog.i("JJEditBox", "onEnterBackground() OUT")
		end
		self.backgroundHandler_ = onEnterBackground
		JJSDK:registerOnEnterBackGroundListener(onEnterBackground)
		self.placeholderLabel_:setVisible(false)
		self.label_:setVisible(false)
		self.placeholderLabel_:setVisible(false)
		self.label_:setVisible(false)
		-- JJLog.i(TAG, "old pos.x=", self:getPositionX(), ", pos.y=", self:getPositionY())
		local pos = self:getNode():getParent():convertToWorldSpace(self:getPositionInPoint())
		-- JJLog.i(TAG, "pos.x=", pos.x, ", pos.y=", pos.y)
		self.impl_:setPosition(pos)
		self:setViewSize(self:getWidth(), self:getHeight())
		local scaleX = self:getCascadeBoundingBoxWidth()/self:getWidth()
		local scaleY = self:getCascadeBoundingBoxHeight()/self:getHeight()
		local scale = scaleX
		if scale > scaleY then
			scale = scaleY 
		end

		local left = self:getPaddingLeft()*scale
		local top = self:getPaddingTop()*scale
		local right = self:getPaddingRight()*scale
		local bottom = self:getPaddingBottom()*scale
		self.impl_:setPadding(left, top, right, bottom)
		
		self.impl_:setFont(" ", self.fontSize_*scale)
		
		JJLog.i(TAG, "before call impl openKeyboard bSingleLine=", self.bSingleLine_, "bSelectAllOnFocus", self.bSelectAllOnFocus_)
		self.impl_:openKeyboard(self.bSingleLine_, self.bSelectAllOnFocus_);
		JJLog.i(TAG, "after call impl openKeyboard bSingleLine=", self.bSingleLine_)
	else
		JJLog.i(TAG, "ERROR: impl_ == nil")
	end
end

function JJEditBox:closeKeyboard()
	JJLog.i(TAG, "closeKeyboard()")
	if self.impl_ ~= nil then
		-- JJSDK:unregisterOnEnterBackGroundListener(self.backgroundHandler_)
		self.impl_:closeKeyboard()
	else
		JJLog.i(TAG, "ERROR: imp_ == nil")
	end
end


function JJEditBox:onEnter()
	JJLog.i(TAG, "onEnter() IN")

end

function JJEditBox:onExit()
	JJLog.i(TAG, "onExit() IN")
	self.label_ = nil
	self.placeholderLabel_ = nil
	if self.backgroundHandler_ ~= nil then
		JJSDK:unregisterOnEnterBackGroundListener(self.backgroundHandler_)
		self:closeKeyboard()
	end
end

function JJEditBox:setFont(font, fontSize)
	JJLog.i(TAG, "setFont() font=", font, ", fontSize=", fontSize)
	self.font_ = font
	self.fontSize_ = fontSize
	if self.label_ ~= nil then
		self.label_:setFontName(font)
		self.label_:setFontSize(fontSize)
	end

	if self.impl_ ~= nil then
		self.impl_:setFont(font, fontSize)
	end
end

function JJEditBox:setFontColor(color)
	JJLog.i(TAG, "setFontColor()")
	self.fontColor_ = color
	if self.label_ ~= nil then
		self.label_:setColor(color)
	else
		JJLog.i(TAG, "ERROR: the label_ is nil")
	end

	if self.impl_ ~= nil then
		self.impl_:setFontColor(color)
	end
end

function JJEditBox:setPlaceHolderFont(font, fontSize)
	if self.placeholderLabel_ ~= nil then
		self.placeholderLabel_:setFontName(font)
		self.placeholderLabel_:setFontSize(fontSize)
	end
	
	if self.impl_ ~= nil then
		self.impl_:setPlaceholderFont(font, fontSize)
	end
end

function JJEditBox:setPlaceHolderFontColor(color)
	self.placeHolderFontColor_ = color
	if self.placeholderLabel_ ~= nil then
		self.placeholderLabel_:setColor(color)
	end

	if self.impl_ ~= nil then
		self.impl_:setPlaceholderFontColor(color)
	end
end

function JJEditBox:setInputMode(mode)
	self.inputMode_ = mode
	if self.impl_ ~= nil then
		self.impl_:setInputMode(mode)
	end
end

function JJEditBox:setInputFlag(flag)
	self.inputFlag_ = flag
	if self.impl_ ~= nil then
		self.impl_:setInputFlag(flag)
	end
end

function JJEditBox:setMaxLength(len)
	JJLog.i(TAG, "setMaxLength() len=", len)
	self.maxLen_ = len
	if self.impl_ ~= nil then
		JJLog.i(TAG, "OK befor invoke imp_:setMaxLength()")
		self.impl_:setMaxLength(len)
	end
end

function JJEditBox:setReturnType(type)
	self.returnType_ = type
	if self.impl_ ~= nil then
		self.impl_:setReturnType(type)
	end
end

function JJEditBox:getReturnType()
	if self.impl_ ~= nil then
		return self.imp_:getReturnType()
	end
end

function JJEditBox:setPlaceHolder(text)

	if self.placeholderLabel_ ~= nil then
		self.placeholderLabel_:setText(text)
	end
	if self.impl_ ~= nil then
		self.impl_:setPlaceHolder(text)
	end
end

function JJEditBox:setText(text)
	
	if self.label_ ~= nil then
		local len = string.len(text)
		if len > 0 then
			if self.inputFlag_ ~= kEditBoxInputFlagPassword then
				self.label_:setText(text)
			else
				local temp = string.rep("*", len)
				self.label_:setText(temp)
			end

			self.placeholderLabel_:setVisible(false)
			self.label_:setVisible(true)
		else
			self.label_:setText(" ")
			self.placeholderLabel_:setVisible(true)
			self.label_:setVisible(false)
		end
	end
	if self.impl_ ~= nil then
		self.impl_:setText(text)
	end
end

function JJEditBox:getText()
	if self.impl_ ~= nil then
		return self.impl_:getText()
	end
end

function JJEditBox:setAnchorPoint(anchorPoint)
	-- JJLog.i(TAG, "setAnchorPoint() IN ap.x=", anchorPoint.x, ", ap.y=", anchorPoint.y)
	JJEditBox.super.setAnchorPoint(self, anchorPoint)

	if self.impl_ ~= nil then
		-- JJLog.i(TAG, "befor self.imp_:setAnchorPoint()")
		self.impl_:setAnchorPoint(anchorPoint)
		-- JJLog.i(TAG, "after self.imp_:setAnchorPoint()")
	end
end

function JJEditBox:setPosition(...)
	JJEditBox.super.setPosition(self, ...);
	local arg = {...}

	local x, y

	if #arg == 1 then
		assert(tolua.type(arg[1])=="CCPoint", "error invalid params")
		local pos = arg[1]
		JJLog.i(TAG, "x="..pos.x..", y="..pos.y)
		x = math.floor(pos.x+0.5)
		y = math.floor(pos.y+0.5)
	elseif  #arg == 2 then
		x = math.floor(arg[1]+0.5)
		y = math.floor(arg[2]+0.5)
		JJLog.i(TAG, "x="..x..", y="..y)
	else
		assert(0, "error invalid params!")
	end
	JJLog.i(TAG, "3 x="..x..", y="..y)
	if self.impl_ ~= nil then
		self.impl_:setPosition(ccp(x, y))
	end
end

function JJEditBox:setViewSize(w, h)
	JJEditBox.super.setViewSize(self, w, h)
	JJLog.i(TAG, "setViewSize() IN w=",w, ", h=", h)
	if self.impl_ ~= nil then
		-- local width = self:getBoundingBoxWidth()
		-- local height = self:getBoundingBoxHeight()
		local size = self:getBoundingBox(true).size
		local width = size.width
		local height = size.height

		JJLog.i(TAG, "width", width, ", height=", height)
		self.impl_:setContentSize(CCSizeMake(width,height))
	end
end


function JJEditBox:setPaddingLeft(value)
	JJEditBox.super.setPaddingLeft(self, value)
	
	if self.impl_ ~= nil then
		self.impl_:setPaddingLeft(value)
	end
end

function JJEditBox:setPaddingRight(value)
	JJEditBox.super.setPaddingRight(self, value)
	
	if self.impl_ ~= nil then
		self.impl_:setPaddingRight(value)
	end
end

function JJEditBox:setPaddingTop(value)
	JJEditBox.super.setPaddingTop(self, value)
	
	if self.impl_ ~= nil then
		self.impl_:setPaddingTop(value)
	end
end

function JJEditBox:setPadding(left, top, right, bottom)
	JJEditBox.super.setPadding(self, left, top, right, bottom)
	JJLog.i(TAG, "setPadding(", left, top, right, bottom, ") IN");
	if self.impl_ ~= nil then
		self.impl_:setPadding(left, top, right, bottom)
	end
end

return JJEditBox
