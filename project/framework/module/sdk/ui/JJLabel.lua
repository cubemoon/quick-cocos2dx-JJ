local JJView = import(".JJView")
local JJLabel = class("JJLabel", JJView)

local TAG = "JJLabel"

--[[
    params 参数描述：
    singleLine: 单行
    font: 字体
    fontSize: 字体大小
    color: 字体颜色
    text: 内容
    align: 水平对齐
    valign: 垂直对齐
]]
function JJLabel:ctor(params)
    JJLabel.super.ctor(self, params)
    assert(type(params) == "table", "JJLabel.ctor invalid params")
    self:setEnableScissor(true)
    self.bSingleLine_ = params.singleLine
    self.font_ = params.font or ui.DEFAULT_TTF_FONT
    self.fontSize_ = params.fontSize or ui.DEFAULT_TTF_FONT_SIZE
    params.size = self.fontSize_ -- 为了和 CCLableTTF 一致
    self.color_ = params.color or display.COLOR_WHITE
    self.text_ = params.text or ""
    params.text = self.text_
    self.hAlign_ = params.align or ui.TEXT_ALIGN_LEFT
    self.vAlign_ = params.valign or ui.TEXT_VALIGN_CENTER

	if params.maxSize ~= nil then
		local maxSize = params.maxSize
		local realSize = nil

		if maxSize.width > 0 then
			realSize = Util:getStringSize(self.text_,self.font_,self.fontSize_,maxSize)
		end
		if realSize ~= nil then
			if realSize.width > 0 then
				self.viewSize_.width = realSize.width
			end
			if realSize.height > 0 then
				self.viewSize_.height = realSize.height
			end
		end
	end

    if params.align == nil then
        params.align = ui.TEXT_ALIGN_LEFT
    end

    if params.valign == nil then
        params.valign = ui.TEXT_VALIGN_CENTER
    end

    self.bHeightContentWrap_ = false
    self.bWidthContentWrap_ = false
    -- 创建的时候未设置文字尺寸，认为是自适应宽度的
    if self:getWidth() == 0 then
        self.bWidthContentWrap_ = true
    else
        self.bWidthContentWrap_ = false
    end

    if self:getHeight() == 0 and self:getWidth() > 0 then
        self.bHeightContentWrap_ = true
        self.bSingleLine_ = false
    end

    -- 默认单行模式
    if self.bSingleLine_ == nil then
        self.bSingleLine_ = true
    end


	local h = self:getHeight()

	if self.bSingleLine_ == true then
		if self.bWidthContentWrap_ == true then 
		    params.dimensions = CCSizeMake(0,0)
		else
			params.dimensions = CCSizeMake(self:getWidth(), h)
		end
	else
		if self.bHeightContentWrap_ == true then
			params.dimensions = CCSizeMake(self:getWidth(), 0)
		else
			params.dimensions = CCSizeMake(self:getWidth(), h)
		end
	end

	if self.bSingleLine_ == true then
		if self.bWidthContentWrap_ ~= true then
			local w = self:getWidth() - self:getPaddingLeft() - self:getPaddingRight()
			local text = getStringWithEllipsis(self.text_, w, self.font_, self.fontSize_)
			params.text = text
		end	
	end

    self.label_ = ui.newTTFLabel(params)
    self.label_:setNeedAlign(true)
    self:getNode():setNeedAlign(true)
    self:getNode():addChild(self.label_, 100)

	if self:getWidth() == 0 or self:getHeight() == 0 then
		local size = self.label_:getContentSize()
		if size.width > 0 and size.height > 0 then
			local w = size.width + self:getPaddingLeft() + self:getPaddingRight()
			local h = size.height + self:getPaddingTop() + self:getPaddingBottom()
			JJLabel.super.setViewSize(self, w, h)
		end 
	end
    self.label_:setAnchorPoint(ccp(0,0))
    self.label_:setPosition(CCPoint(self:getPaddingLeft(), self:getPaddingBottom()))

    -- self:_refresh()
end

function JJLabel:setViewSize(w, h)
    JJLabel.super.setViewSize(self, w, h)
    -- JJLog.i(TAG, "setViewSize(",w, ", ", h, ")")
    if self.label_ ~= nil then
        local width = w - self:getPaddingLeft() - self:getPaddingRight()
        local height = h - self:getPaddingTop() - self:getPaddingBottom()
        if width < 0 then width = 0 end
        if height < 0 then height = 0 end
		if width ~= self:getWidth() or height ~= self:getHeight() then
			if self.bSingleLine_ == true then
				if self.bWidthContentWrap_ == true then 
					self.label_:setDimensions(CCSizeMake(0, 0))
				else
					self.label_:setDimensions(CCSizeMake(width, height))
				end
			else
				if self.bHeightContentWrap_ == true then
					self.label_:setDimensions(CCSizeMake(width, 0))
				else
					self.label_:setDimensions(CCSizeMake(width, height))
				end
			end
		end
        
    end
end

function JJLabel:setHeightWrapContent(flag)
    if self.bHeightContentWrap_ ~= flag then
        self.bHeightContentWrap_ = flag
        self:_refresh()
    end
end

function JJLabel:setWidthWrapContent(flag)
    self.bWidthContentWrap_ = flag
    self:_refresh()
end

function JJLabel:setHAlign(align)
    if self.label_ then
        self.label_:setHorizontalAlignment(align)
    end
end

function JJLabel:setVAlign(valign)
    if self.label_ then
        self.label_:setVerticalAlignment(valign)
    end
end

function JJLabel:setSingleLine(single)
    --JJLog.i(TAG, "setSingleLine()")
    self.bSingleLine_ = single
    self:_refresh()
end

function JJLabel:isSingleLine()
    --JJLog.i(TAG, "isSingleLine()")
    return self.bSingleLine_
end

function JJLabel:setColor(color)
    self.fntColor_ = color
    self.label_:setColor(color)
end

function JJLabel:getColor()
    return self.fntColor_
end

function JJLabel:setText(text)
    -- JJLog.i(TAG, "setText("..text..")")

	if self.text_ ~= text then
		self.text_ = text
		-- self.label_:setString(text)
		-- self:_refresh()

		local temp = text
		local w = self:getWidth() - self:getPaddingLeft() - self:getPaddingRight()
		local h = self:getHeight() - self:getPaddingTop() - self:getPaddingBottom()
		local dimensions = CCSizeMake(w, h)
		if self.bSingleLine_ == true then
			if self.bWidthContentWrap_ ~= true then
				temp = getStringWithEllipsis(text, w, self.font_, self.fontSize_)	
			else
				dimensions = CCSizeMake(0, 0)
			end
		else
			if self.bHeightContentWrap_ == true then
				dimensions = CCSizeMake(w, 0)
			end
		end

		-- self.label_:initWithString(temp, self.font_, self.fontSize_, dimensions, self.hAlign_, self.vAlign_)
		-- self.label_:setColor(self.color_)
		self.label_:setString(temp)
		
		self.label_:setAnchorPoint(ccp(0,0))
		self.label_:setPosition(CCPoint(self:getPaddingLeft(), self:getPaddingBottom()))
		-- if dim.width == 0 or dim.height == 0 then
			local size = self.label_:getContentSize()
			if size.width > 0 and size.height > 0 then
				local w = size.width + self:getPaddingLeft() + self:getPaddingRight()
				local h = size.height + self:getPaddingTop() + self:getPaddingBottom()
				-- JJLog.i(TAG, "w=",w, "h=",h)
				JJLabel.super.setViewSize(self, w, h)
			end 
		-- end
	else
		JJLog.i(TAG, "WARNNING: text not change, do nothing!")
	end
end

function JJLabel:getText()
    return self.text_
end

function JJLabel:setOpacity(opacity)
    if self.label_ ~= nil then
		self.label_:setOpacity(opacity)
	end
end

function JJLabel:getFontSize()
    return self.label_:getFontSize()
end

function JJLabel:setFontSize(size)
    if self.label_:getFontSize() ~= size then
        self.fontSize_ = size
        self.label_:setFontSize(size)
        self:_refresh()
    end
end

function JJLabel:getFontName()
    return self.label_:getFontName()
end

function JJLabel:setFontName(font)
    self.label_:setFontName(font)
end

function JJLabel:_adjustSingleLine()
    -- JJLog.i(TAG, "_adjustSingleLine()")
    if self.bWidthContentWrap_ ~= true then
        local w = self:getWidth() - self:getPaddingLeft() - self:getPaddingRight()
		local h = self:getHeight() - self:getPaddingTop() - self:getPaddingBottom()
		-- JJLog.i(TAG, "w=", w)
        local tempText = getStringWithEllipsis(self.text_, w, self.font_, self.fontSize_)
        -- JJLog.i(TAG, "tempText=", tempText)
		self.newText_ = self.label_:getString()
        if self.newText_ ~= tempText then
            self.newText_ = tempText
            -- JJLog.i(TAG, "self.newText_=", self.newText_)
            self.label_:setString(self.newText_)
			self.label_:setDimensions(CCSizeMake(w, h))
        end
    else
        -- JJLog.i(TAG, "bWidthContentWrap_ == true, text=", self.text_)
        self.label_:setDimensions(CCSizeMake(0, 0))
    end
end

function JJLabel:_adjustMutiLine()
    -- JJLog.i(TAG, "_adjustMutiLine")
    if self.bHeightContentWrap_ == true then
        self.label_:setString(self.text_)
        self.label_:setDimensions(CCSizeMake(self.label_:getDimensions().width, 0))
    end

end

function JJLabel:_refresh()
    -- JJLog.i(TAG, "_refresh() IN")
    if self.bSingleLine_ == true then
        self:_adjustSingleLine()
    else
        self:_adjustMutiLine()
    end
    local size = self.label_:getContentSize()
    if size.width > 0 and size.height > 0 then
        -- JJLog.i(TAG, "label content size.w=", size.width, ", h=", size.height)
		local w = size.width + self:getPaddingLeft() + self:getPaddingRight()
		local h = size.height + self:getPaddingTop() + self:getPaddingBottom()
		-- JJLog.i(TAG, "w=",w, "h=",h)
		self:setViewSize(w, h)
    end 
end

function JJLabel:relayout()
    --JJLog.i(TAG, "relayout")
    JJLabel.super.relayout(self)
    self:_refresh()
end

function JJLabel:getLabel()
    return self.label_
end

return JJLabel
