local JJDimens = class("JJDimens")

local TAG = "JJDimens"

--[[
    横竖屏或者界面高宽变化了，重新初始化坐标参数
    @flag: 是否允许横竖屏切换，默认为 True 了
]]
function JJDimens:init(w, h, flag)
    JJLog.i(TAG, "init, w=", w, ", h=", h, ", flag=", flag)

    -- 不需要拉伸到全屏宽或者全屏高的元素，使用 scale_
    -- 需要拉伸到全屏宽或者全屏高的元素，使用对应的缩放比，高是 hScale_，宽是 wScale_
    local size = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
    JJLog.i(TAG, "init, size w=", size.width, ", h=", size.height)
    if flag == nil then
        flag = true
    end
    if flag == true then
        if size.width > size.height then
            self.wScale_ = size.width / w
            self.hScale_ = size.height / h
        else
            self.wScale_ = size.width / h
            self.hScale_ = size.height / w
        end
    else
        self.wScale_ = size.width / w
        self.hScale_ = size.height / h
    end
    if (self.wScale_ > self.hScale_) then
        self.scale_ = self.hScale_
    else
        self.scale_ = self.wScale_
    end
    JJLog.i(TAG, "init, self.scale_=", self.scale_, ", self.wScale_=", self.wScale_, ", self.hScale_=", self.hScale_)
    self.sizeInPixels = {width = size.width, height = size.height}

    local winSize = CCDirector:sharedDirector():getWinSize()
    JJLog.i(TAG, "init, winSize w=", winSize.width, ", h=", winSize.height)

    self.contentScaleFactor = self.scale_
    self.size               = {width = winSize.width, height = winSize.height}
    self.width              = self.size.width
    self.height             = self.size.height
    self.cx                 = self.width / 2
    self.cy                 = self.height / 2
    self.c_left             = -self.width / 2
    self.c_right            = self.width / 2
    self.c_top              = self.height / 2
    self.c_bottom           = -self.height / 2
    self.left               = 0
    self.right              = self.width
    self.top                = self.height
    self.bottom             = 0
    self.widthInPixels      = self.sizeInPixels.width
    self.heightInPixels     = self.sizeInPixels.height

    JJLog.i(TAG, "init, ", vardump(self))
end

function JJDimens:getDimens(px)
  return px * self.scale_
end

function JJDimens:getXDimens(px)
  return px * self.wScale_
end

function JJDimens:getYDimens(px)
  return px * self.hScale_
end

return JJDimens