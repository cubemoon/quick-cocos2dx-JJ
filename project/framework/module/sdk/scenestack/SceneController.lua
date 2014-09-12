--[[
	界面控制器基类，和 SceneBase 配合使用
]]
local SceneController = class("SceneController")

local TAG = "SceneController"

SceneController.tag__ = nil
SceneController.sceneName__ = nil
SceneController.sceneId__ = 0
SceneController.transitionType__ = nil
SceneController.resumeRedraw__ = true -- resume 回来的时候是否重绘界面（销毁并重新创建）
SceneController.scene_ = nil


--[[
	@tag: 实例的名称
	@scenename: 界面名称
	@...: 参数，需要子类自己实现
]]
function SceneController:ctor(tag, scenename, ...)
	JJLog.i(TAG, "ctor, tag=", tag, ", scenename=", scenename)
	self.tag__ = tag
	self.sceneName__ = scenename
	JJLog.i(TAG, self.tag__, "ctor, self.tag=", self.tag__, ", self.scenename=", self.sceneName__)
end

function SceneController:getTag()
	JJLog.i(TAG, self.tag__, "getTag")
	return self.tag__
end

function SceneController:setSceneId(sceneId)
	self.sceneId__ = sceneId
end

function SceneController:getSceneId()
	return self.sceneId__
end

--[[
	返回 True，说明界面启动成功
]]
function SceneController:onActive()
	JJLog.i(TAG, self.tag__, "onActive")
end

--[[
	恢复
]]
function SceneController:onResume()
	JJLog.i(TAG, self.tag__, "onResume, self.resumeRedraw__=", self.resumeRedraw__)
	local ret = true
	if self.scene_ ~= nil then
		if self.resumeRedraw__ then
			self.scene_:reinitView()
		end
	else
		self:showScene()
		-- 当在后台收到startgameclient消息时，不会创建scene，而sceneController又需要压栈，所有当gl在后台时，需要返回true
		if self.scene_ ~= nil or not Util:isAppActive() then

		else
			ret = false
		end
	end

	return ret
end

--[[
	暂停
]]
function SceneController:onPause()
	JJLog.i(TAG, self.tag__, "onPause")
	-- [Yangzukang][2014.08.30]保护性，scene 丢失的情况
	if self.scene_ ~= nil and not tolua.isnull(self.scene_) then
		if Util:isFunction(self.scene_.onEnterBackground) then
			self.scene_:onEnterBackground()
		end
	end
end

--[[
	失效，销毁 Scene
]]
function SceneController:onInactive()
	JJLog.i(TAG, self.tag__, "onInactive")
	self:destroyScene()
end

--[[
	销毁Controller
]]
function SceneController:onDestory()
	JJLog.i(TAG, self.tag__, "onDestory")
	CCTextureCache:sharedTextureCache():removeUnusedTextures()
	collectgarbage("collect")
end

--[[
	创建界面
]]
function SceneController:createScene()
	JJLog.i(TAG, self.tag__, "createScene", self.sceneName__,Util:isAppActive())
	--Util:isAppActive()这个判断是针对应用或者gl线程在后台的情况添加的，如果在后台收到startgameclient的消息
	--此时不会创建scene
	if self.sceneName__ and Util:isAppActive() then
		local sceneClass = require(self.sceneName__)
    	return sceneClass.new(self)
    end
    JJLog.i(TAG, self.tag__, "createScene return nil")
    return nil
end

--[[
	销毁界面
]]
function SceneController:destroyScene()
	JJLog.i(TAG, self.tag__, "destroyScene")
	-- [Yangzukang][2014.08.30]保护性，scene 丢失的情况
	if self.scene_ ~= nil and not tolua.isnull(self.scene_) then
		if Util:isFunction(self.scene_.onDestory) then
			self.scene_:onDestory()
		end
		self.scene_ = nil
	end
end

--[[
	显示界面
]]
function SceneController:showScene()
	JJLog.i(TAG, self.tag__, "showScene, self.scene_=", self.scene_)
	if self.scene_ == nil then
		self.scene_ = self:createScene()
	end
	if self.scene_ then
		display.replaceScene(self.scene_, self.transitionType__, 0.3)
	end
end

-- 2dx 中 scene 的生命周期，回调到 controller
function SceneController:onSceneEnter()
	JJLog.i(TAG, self.tag__, "onSceneEnter")
	JJSDK:transitionStart()
end

function SceneController:onSceneExit()
	JJLog.i(TAG, self.tag__, "onSceneExit")
	self.scene_ = nil
end

function SceneController:onSceneEnterFinish()
	JJLog.i(TAG, self.tag__, "onSceneEnterFinish")
	JJSDK:transitionOver()
end

function SceneController:onSceneExitStart()
	JJLog.i(TAG, self.tag__, "onSceneExitStart")
end

function SceneController:onSceneCleanup()
	JJLog.i(TAG, self.tag__, "onSceneCleanup")
end

--[[
	界面尺寸变化
]]
function SceneController:onViewSizeChange()
	JJLog.i(TAG, self.tag__, "onViewSizeChange")
	if self.scene_ ~= nil then
		self.scene_:onViewSizeChange()
	end
end

--[[
	返回键处理
]]
function SceneController:onBackPressed()
	JJLog.i(TAG, self.tag__, "onBackPressed")
	JJSDK:popScene()
end

function SceneController:setTransitionType(type)
	self.transitionType__ = type
end

--[[
	消息处理
]]
function SceneController:handleMsg(msg)
	JJLog.i(TAG, self.tag__, "handleMsg")
end

function SceneController:setResumeRedraw(flag)
	self.resumeRedraw__ = flag
end

--[[
	调用scene_的schedule接口启动timer
	@callback: 回调
	@interval: 计时器间隔
]]
function SceneController:schedule(callback, interval)
    local handler = nil

    if self.scene_ ~= nil then
        handler = self.scene_:schedule(callback, interval)
    end

    return handler
end

--[[
	调用scene_的performWithDelay接口启动一次性timer
	@callback: 回调
	@delay: 延时
]]
function SceneController:performWithDelay(callback, delay)
    local handler = nil

    if self.scene_ ~= nil then
        handler = self.scene_:performWithDelay(callback, delay)
    end

    return handler
end

--[[
	调用scene_的unschedule接口停止timer
	@handler: 计时器句柄
]]
function SceneController:unschedule(handler)
    if self.scene_ ~= nil then
        self.scene_:unschedule(handler)
    end
end

return SceneController
