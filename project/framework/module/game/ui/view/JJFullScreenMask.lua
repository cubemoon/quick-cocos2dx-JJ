--[[
    全屏遮罩，屏蔽触屏事件
]]
local JJFullScreenMask = class("JJFullScreenMask", require("sdk.ui.JJImage"))

local TAG = "JJFullScreenMask"

function JJFullScreenMask:ctor(params)
    local director = CCDirector:sharedDirector()
    local glview = director:getOpenGLView()
    local size = glview:getFrameSize()
    JJFullScreenMask.super.ctor(self, {
        image = "img/ui/bg_mask.png",
        -- TODO: scale9 的图片不能设置透明色
        -- scale9 = true,
        -- viewSize = CCSizeMake(size.width, size.height)
    })

    self:setScaleX(size.width)
    self:setScaleY(size.height)
    self:setOpacity(100)
    self:setAnchorPoint(ccp(0.5, 0.5))
    self:setPosition(size.width / 2, size.height / 2)
    self:setTouchEnable(true)
end

return JJFullScreenMask
