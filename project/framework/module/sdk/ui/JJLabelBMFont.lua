local JJView = import(".JJView")
local JJLabelBMFont = class("JJLabelBMFont", JJView)

local TAG = "JJLabelBMFont"

--[[
    params 参数描述：
        text: 内容
        font: 字体
        align: 水平对齐

]]
function JJLabelBMFont:ctor(params)
	JJLabelBMFont.super.ctor(self, params)
	assert(type(params) == "table",
           "JJLabelBMFont:ctor invalid params")

    local text      = tostring(params.text)
    local font      = params.font
    local textAlign = params.align or ui.TEXT_ALIGN_CENTER
    local x, y      = params.x, params.y
    assert(font ~= nil, "ui.newBMFontLabel() - not set font")

    local label = CCLabelBMFont:create(text, font, kCCLabelAutomaticWidth, textAlign)

	assert(label~=nil, "ERROR: bmfont label is nil")
	
	self.text_ = text
	self.font_ = font
	self:getNode():addChild(label)
	label:setAnchorPoint(ccp(0,0))
	label:setPosition(ccp(0,0))
	
	self.label_ = label
	
	self:_refresh()
end


function JJLabelBMFont:setHAlign(align)
	if self.label_ then
		self.label_:setAlignment(align)
	end
end

function JJLabelBMFont:setText(text)
	-- assert(self.label_~=nil "ERROR: label is nil")
	if self.label_ ~= nil then
		self.label_:setString(text)
		self:_refresh()
	end
end

function JJLabelBMFont:getText()
	return self.text_
end
function JJLabelBMFont:_refresh()
	if self.label_ ~= nil then
		self:setViewSize(self.label_:getContentSize().width, self.label_:getContentSize().height)
	end
end

function JJLabelBMFont:getLabel()
	return self.label_
end

return JJLabelBMFont
