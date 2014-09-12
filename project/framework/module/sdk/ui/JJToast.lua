local JJToast = class("JJToast")
local TAG = "JJToast"

local rootView_ = nil
local toast_ = nil
-- 将需要显示的内容保存起来
local toastQueue_ = {}
-- 目前是否在显示toast状态
local toastIsShowing_ = false
-- 当前用于展示的参数
local toastParam_ = nil

--[[
    初始化
]]
local function _init()
    if rootView_ == nil then
        rootView_ = jj.ui.JJRootView.new({
            displayType = "director",
            display = CCDirector:sharedDirector()
        })
    end
end

-- toast 显示完后回调
local function _animComplete(self)
    JJLog.i(TAG, "_animComplete")
    
    rootView_:removeView(toast_, true)
    toastIsShowing_ = false
    if toastQueue_ ~= nil and #toastQueue_ > 0 then
        local params = table.remove(toastQueue_, 1)
        self:show(params)
    end
end

-- 动画
local function _startAnim(self, target)
    JJLog.i(TAG, "_startAnim")

    local fadeIn = CCFadeOut:create(0.5)
    local delay = CCDelayTime:create(0.5)
    local fadeOut = fadeIn:reverse()
    local callback = CCCallFunc:create(handler(self, _animComplete))

    local array = CCArray:create()
    array:addObject(fadeIn)
    array:addObject(delay)
    array:addObject(fadeOut)
    array:addObject(callback)

    local actions = CCSequence:create(array)
    target:runAction(actions)
end

--[[
    显示
    @text: 展示的内容
    @dimens: 坐标属性
]]
function JJToast:show(params)
    _init()

    JJLog.i(TAG, "show() IN, toastIsShowing_=", toastIsShowing_)

    if not toastIsShowing_ then
        toastIsShowing_ = true
        toastParam_ = params

        local scale = 1
        if params.dimens ~= nil then
            scale = params.dimens.scale_
        end

        local maxWidth = 600
        -- 如果是竖屏，窄一些
        if params.dimens ~= nil then
            if params.dimens.width < params.dimens.height then
                maxWidth = 400
            end
        end

        toast_ = jj.ui.JJLabel.new({
            singleLine = false,
            fontSize = 22 * scale,
            color = ccc3(255, 255, 255),
            text = params.text,
			layout = {
                paddingLeft = 30 * scale,
                paddingRight = 30 * scale,
                paddingTop = 15 * scale,
                paddingBottom = 15 * scale,
			},
            background = {
                scale9 = true,
                image = "img/ui/toast_frame.png"
            },
            maxSize = CCSize(maxWidth * scale, 0)
        })

        local director = CCDirector:sharedDirector()
        local glview = director:getOpenGLView()
        local size = glview:getFrameSize()
        local top = size.height / 2 + 50 * scale

        toast_:setPosition(size.width / 2, top)
        toast_:setAnchorPoint(ccp(0.5, 0.5))
        rootView_:addView(toast_)
        _startAnim(self, toast_)
    else
        table.insert(toastQueue_, params)
    end
end

--[[
    界面尺寸变化
]]
function JJToast:onSizeChange()
    JJLog.i(TAG, "onSizeChange")

    if toastIsShowing_ then
        rootView_:removeView(toast_, true)
        toastIsShowing_ = false
        self:show(toastParam_)
    end
end

return JJToast
