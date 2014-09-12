--[[
    界面基类: 主要是生命周期管理
]]
local SceneBase = class("SceneBase", function()
    return display.newScene("SceneBase")
end)

local TAG = "SceneBase"
local KEY_LAYER = 100

SceneBase.controller_ = nil -- 用的地方太多，先不改为两个下划线了
SceneBase.controller__ = nil -- 和上一个同值
SceneBase.initview__ = false -- 是否初始化过
SceneBase.rootView__ = nil
SceneBase.backKeyListener__ = {}
-- 支持的屏幕方向，默认竖版
SceneBase.orientation__ = JJSDK.ORIENTATION_PORTRAIT

-- 本地函数
local _unregisterBackKey = nil
local _registerBackKey = nil

--[[
    创建界面
    @controller
]]
function SceneBase:ctor(controller)
    self.controller_ = controller
    self.controller__ = controller
    if (JJSDK:isOrientation(self.orientation__)) then
        self:initView()
    else
        JJLog.i(TAG, self.controller__.sceneName__, "ctor, no support orientation")
    end
end

--[[
    初始化界面
]]
function SceneBase:initView()
    JJLog.i(TAG, self.controller__.sceneName__, "initView")
    local rootView = jj.ui.JJRootView.new({displayType="scene", display=self})
    self.rootView__ = jj.ui.JJViewGroup.new()
    rootView:addView(self.rootView__)
    self.backKeyListener__ = {}
    self.initview__ = true
end

--[[
    重新初始化界面
]]
function SceneBase:reinitView()
    JJLog.i(TAG, self.controller__.sceneName__, "reinitView")
    if (JJSDK:isOrientation(self.orientation__)) then
        local layer = self:getChildByTag(KEY_LAYER) -- 保存是否已经注册过监听
        self:onDestory()
        self:removeAllChildrenWithCleanup(true)
        self:initView()
        if layer ~= nil then -- 注册过的话，恢复注册
            _registerBackKey(self)
        end
    else
        self.initview__ = false
        JJLog.i(TAG, self.controller__.sceneName__, "reinitView, no support orientation")
    end
end

--[[
    清除掉lua数据，避免C++数据被清除而lua还保留句柄的情况
]]
function SceneBase:onDestory()
    JJLog.i(TAG, self.controller__.sceneName__, "onDestory")
end

--[[
    添加子控件
    @view
    @zorder: 显示顺序
]]
function SceneBase:addView(view, zorder)
    JJLog.i(TAG, self.controller__.sceneName__, "addView")
    if self.rootView__ ~= nil then
        self.rootView__:addView(view, zorder)
    end
end

--[[
    移除子控件
    @view
]]
function SceneBase:removeView(view)
    JJLog.i(TAG, self.controller__.sceneName__, "removeView")
    if self.rootView__ ~= nil then
        self.rootView__:removeView(view)
    end
end

--[[
    获取子控件句柄
    @id: 子控件 id
]]
function SceneBase:getViewById(id)
    if self.rootView__ ~= nil then
        return self.rootView__:getViewById(id)
    end
    return nil
end

--[[
    注册相应返回键的控件，无优先级，按顺序
    @view: 哪个控件需要注册
    @cb: 回调，无参数
]]
function SceneBase:regBackKey(view, cb)
    if view ~= nil and cb ~= nil then
        local item = {view = view, cb = cb}
        table.insert(self.backKeyListener__, 1, item)
    end
end

--[[
    注销返回键的响应
    @view:
]]
function SceneBase:unregBackKey(view)
    if view ~= nil then
        for i,v in ipairs(self.backKeyListener__) do
            if v.view == view then
                table.remove(self.backKeyListener__, i)
            end
        end
    end
end

--[[
    返回键处理
]]
function SceneBase:handleBackKey()
    if self.backKeyListener__[1] ~= nil then
        self.backKeyListener__[1].cb()
    else
        self.controller__:onBackPressed()
    end
end

--------------- 由 2DX 调用的 Scene 的生命周期 ---------------
-- 由于需要通知到 Controller，所以默认都是回调 Controller，由 Controller 再通知 Scene
function SceneBase:onEnter()
    JJLog.i(TAG, self.controller__.sceneName__, "onEnter")
    self.controller__:onSceneEnter()
end

function SceneBase:onExit()
    JJLog.i(TAG, self.controller__.sceneName__, "onExit")
    self.controller__:onSceneExit()
    if self.rootView__ ~= nil then
        self.rootView__:removeAllView()
        self.rootView__:removeSelf()
        self.rootView__ = nil
    end
end

function SceneBase:onEnterTransitionFinish()
    JJLog.i(TAG, self.controller__.sceneName__, "onEnterTransitionFinish")
    self.controller__:onSceneEnterFinish()
    _registerBackKey(self)
end

function SceneBase:onExitTransitionStart()
    JJLog.i(TAG, self.controller__.sceneName__, "onExitTransitionStart")
    self.controller__:onSceneExitStart()
    _unregisterBackKey(self)
end

function SceneBase:onCleanup()
    JJLog.i(TAG, self.controller__.sceneName__, "onCleanup")
    self.controller__:onSceneCleanup()
end

function SceneBase:onEnterBackground()
	JJLog.i(TAG, self.controller__.sceneName__, "onEnterBackground")
end

--------------- 由 2DX 调用的 Scene 的生命周期 ---------------

--[[
    界面大小变化的回调
]]
function SceneBase:onViewSizeChange()
    JJLog.i(TAG, self.controller__.sceneName__, "onViewSizeChange, self.initview__=", self.initview__)
    if self.initview__ == false and (JJSDK:isOrientation(self.orientation__)) then
        self:reinitView()
    else
        JJLog.i(TAG, self.controller__.sceneName__, "onViewSizeChange, already init or no support orientation")
    end
end

--[[
    取消定时器
    @handler: 定时器句柄
]]
function SceneBase:unschedule(handler)
    assert(not tolua.isnull(self), "unschedule, ERROR: scene should not be nil!")
    self:stopAction(handler)
end

--[[
    设置改界面支持的屏幕方向
    @orientation
]]
function SceneBase:setOrientation(orientation)
    self.orientation__ = orientation
end

--[[
    获取改界面支持的屏幕方向
]]
function SceneBase:getOrientation()
    return self.orientation__
end

--[[
    判断该界面是否支持此屏幕方向
    @orientation
]]
function SceneBase:isSupportOrientation(orientation)
    return self.orientation__ == orientation
end

--[[
    注销按键响应
]]
_unregisterBackKey = function(self)
    JJLog.i(TAG, self.controller__.sceneName__, "_unregisterBackKey, self=", vardump(self))
    local layer = self:getChildByTag(KEY_LAYER)
    if layer ~= nil then
        JJLog.i(TAG, self.controller__.sceneName__, "_unregisterBackKey, removechild, self=", vardump(self))
        self:removeChild(layer, true)
    end
end

--[[
    注册按键响应
]]
_registerBackKey = function(self)
    _unregisterBackKey(self)
    JJLog.i(TAG, self.controller__.sceneName__, "_registerBackKey, self=", vardump(self))
    local layer = display.newLayer()
    layer:addKeypadEventListener(function(event)
        if event == "back" then self:handleBackKey() end
    end)
    layer:setTag(KEY_LAYER)
    self:addChild(layer)
    layer:setKeypadEnabled(true)
end

--[[
    横竖屏切换
]]
function SceneBase:chagneScreen()
    JJLog.i(TAG, self.controller__.sceneName__, "chagneScreen")
end

return SceneBase
