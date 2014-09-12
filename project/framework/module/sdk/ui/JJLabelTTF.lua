
--[[
    params 参数描述：
    font: 字体
    fontSize: 字体大小
    color: 字体颜色
    text: 内容
    align: 水平对齐
    valign: 垂直对齐
	dimensions: CCSize type
]]

local JJLabelTTF = class("JJLabelTTF", function (params)
    params.font = params.font or ui.DEFAULT_TTF_FONT
    params.size = params.fontSize or ui.DEFAULT_TTF_FONT_SIZE

    params.color = params.color or display.COLOR_WHITE
    params.text = params.text or ""

    params.align = params.align or ui.TEXT_ALIGN_LEFT
    params.valign = params.valign or ui.TEXT_VALIGN_CENTER
	

	return ui.newTTFLabel(params)
end
)

local TAG = "JJLabelTTF"


function JJLabelTTF:ctor(params)
	self.id_ = 0
end


function JJLabelTTF:setId(id)
	self.id_ = id
end

function JJLabelTTF:getNode()
	return self
end

function JJLabelTTF:removeSelf(bCleanup)
	local cleanup = bCleanup or true
	self:removeFromParentAndCleanup(cleanup)
end

function JJLabelTTF:getViewSize()
	return self:getContentSize()
end

return JJLabelTTF
