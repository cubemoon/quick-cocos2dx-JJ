JJSDK = {}
local TAG = "JJSDK"

require("sdk.init")

-- 屏幕方向
JJSDK.ORIENTATION_PORTRAIT = 0x01
JJSDK.ORIENTATION_LANDSCAPE = 0x02

local Util = require("sdk.util.Util")
local stack = require("sdk.scenestack.SceneStack")
local msgListener_ = nil
local timerLister_ = nil
local screenOrientation_ = JJSDK.ORIENTATION_PORTRAIT -- 当前屏幕方向，默认竖屏

-------------------- 消息处理 --------------------------
-- 注册消息回调
function JJSDK:registerMsgListener(listener)
	msgListener_ = listener
end

-- 分发消息给上层
function JJSDK:dispatchMsg(msg)
	if msgListener_ ~= nil then
		msgListener_(msg)
	end
end

-------------------- timer处理 --------------------------
function JJSDK:registerTimerListener(listener)
	timerLister_ = listener
end

-- 分发消息给上层
function JJSDK:dispatchTimer(dt)
	if timerLister_ ~= nil then
		timerLister_(dt)
	end
end

-- 透传消息给界面控制器
function JJSDK:pushMsgToSceneController(msg)
	if Util:isAppActive() then
		local controller = stack:getTop()
		if controller and controller.scene_ ~= nil then
			return controller:handleMsg(msg)
		end
	end
end

local netMsgFlag_ = {}
--[[
	暂停处理消息
	key: 字符串
	flag: true/flase
]]
function JJSDK:pauseNetMsg(key, flag)
	JJLog.i(TAG, "pauseNetMsg, key=", key, ", flag=", flag)
	if key == nil or typen(key) ~= LUA_TSTRING then
		return
	end

	if flag == true then
		netMsgFlag_[key] = true
	elseif netMsgFlag_[key] ~= nil then
		netMsgFlag_[key] = nil
	end

	dump(netMsgFlag_)
	for k,v in pairs(netMsgFlag_) do
		require("sdk.connect.ConnectManager")
		ConnectManager:pause(true)
		return
	end

	ConnectManager:pause(false)
end

require("sdk.connect.ConnectManager")
ConnectManager:registerListener(function(msg)
	JJSDK:dispatchMsg(msg)
end)
ConnectManager:registerTimerListener(function(dt)
	JJSDK:dispatchTimer(dt)
end)
-------------------- 消息处理 --------------------------

-------------------- 界面处理 --------------------------
-- 注册界面变化的回调
registerViewChangeListener(function()
	JJLog.i(TAG, "ViewChange CB")

    local size = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
    JJLog.i(TAG, "ViewChange CB, size w=", size.width, ", h=", size.height)
    if size.width > size.height then
        screenOrientation_ = JJSDK.ORIENTATION_LANDSCAPE
    else
        screenOrientation_ = JJSDK.ORIENTATION_PORTRAIT
    end

	local top = stack:getTop()
	if top ~= nil then
		top:onViewSizeChange()
	end
end)
-----
local onEnterBackGroundListener_ = {}
function JJSDK:registerOnEnterBackGroundListener(l)
	JJLog.i("JJSDK", "registerOnEnterBackGroundListener() IN")
	local bFound = false
	for __, v in ipairs(onEnterBackGroundListener_) do
		if v == l then
			bFound = true
			break
		end
	end
	if bFound ~= true then
		JJLog.i("JJSDK", "OK register listener")
		onEnterBackGroundListener_[#onEnterBackGroundListener_+1] = l
	end
end

function JJSDK:unregisterOnEnterBackGroundListener(l)
	JJLog.i("JJSDK", "unregisterOnEnterBackGroundListener()")
	for k, v in ipairs(onEnterBackGroundListener_) do
		if v == l then
			table.remove(onEnterBackGroundListener_, k)
		end
	end
end

local function onEnterBackGroundNotify()
	JJLog.i("JJSDK", "onEnterBackGroundNotify()")
	for __, v in ipairs(onEnterBackGroundListener_) do
		if v ~= nil then
			JJLog.i("JJSDK", "onEnterBackGroundNotify v()")
			v()
		end
	end
end


----
-- 注册进入前后台的回调
local notificationCenter = CCNotificationCenter:sharedNotificationCenter()
notificationCenter:registerScriptObserver(nil, function()
	Util.appEnterBackGround()
	onEnterBackGroundNotify()
	stack:pause()
	JJSDK:dispatchMsg(require("sdk.message.EnterBackgroundMessage").new())
end, "APP_ENTER_BACKGROUND")
notificationCenter:registerScriptObserver(nil, function()
	Util.appEnterForeGround()
	stack:resume()
	JJSDK:dispatchMsg(require("sdk.message.EnterForgroundMessage").new())
end, "APP_ENTER_FOREGROUND")

-- 推入一个界面
function JJSDK:pushScene(sceneId, controllerName, sceneName, ...)
	stack:push(sceneId, controllerName, sceneName, ...)
end

-- 弹出一个界面
function JJSDK:popScene()
	stack:pop()
end

-- 跳转到某一界面，如果界面在栈中，将它之上的所有界面弹出，如果不在栈中，新建
function JJSDK:changeToScene(sceneId, controllerName, sceneName, ...)
	if stack:contain(controllerName) then
		stack:removeTo(controllerName, true)
	else
		self:pushScene(sceneId, controllerName, sceneName, ...)
	end
end

-- 移除一个界面
function JJSDK:removeScene(controllerName)
	stack:remove(controllerName)
end

-- 移除所有界面
function JJSDK:removeAllScene()
	stack:removeAll()
end

-- 移除到某一界面之上的所有界面，但是不显示这个界面
function JJSDK:removeToScene(controllerName)
	stack:removeTo(controllerName, false)
end

-- 获取顶层界面
function JJSDK:getTopSceneController()
	return stack:getTop()
end

-- 是否包含
function JJSDK:containSceneId(sceneId)
	return stack:containSceneId(sceneId)
end

function JJSDK:transitionStart()
	stack:transitionStart()
end

function JJSDK:transitionOver()
	stack:transitionOver()
end
-------------------- 界面处理 --------------------------

--[[
    当前屏幕是否此方向
    @orientation
]]
function JJSDK:isOrientation(orientation)
    JJLog.i(TAG, "isOrientation, screenOrientation_=", screenOrientation_, ", orientation=", orientation)
    -- 模拟器不能动态切换横竖屏，都需要支持
    if device.platform == "windows" or device.platform == "mac" then
        return true
    else
        return (screenOrientation_ == orientation)
    end
end

return JJSDK
