-- Scene Controller 的栈
local SceneStack = {}
local TAG = "SceneStack"

local scheduler_ = require(cc.PACKAGE_NAME .. ".scheduler")

local list_ = {} -- 当前的栈
local wait_ = {} -- 等待跳转的栈
local transition_ = false -- 当前是否在 Scene 切换动画中，2dx 有缺陷。A->B 的过程中，执行 B->C 会导致闪一下 C，然后再回到 B

-- 本地函数
local _trace = nil
local _toNextScene = nil
local _checkToNext = nil

--[[
	将一个界面压栈
	@sceneId: 界面定义
	@controllerName: 控制器路径
	@sceneName: 界面路径
	@...
]]
function SceneStack:push(sceneId, controllerName, sceneName, ...)
	JJLog.i(TAG, "push, sceneId=", sceneId, ", controller=", controllerName, ", scene=", sceneName)
	wait_[#wait_ + 1] = {
		sceneId = sceneId,
		controllerName = controllerName,
		sceneName = sceneName,
		params = ...
	}

	JJSDK:pauseNetMsg(TAG, true)
	_checkToNext(self)
end

--[[
	弹出栈顶界面
]]
function SceneStack:pop()
	local count = #list_
	if count > 0 then
		local controller = list_[#list_]
		controller:onPause()
		controller:onInactive()
		controller:onDestory()
		table.remove(list_, #list_)
	end

	local controller = self:getTop()
	if controller ~= nil then
		controller:setTransitionType("slideinl")
		controller:onActive()
		controller:onResume()
	end
end

--[[
	获取栈顶元素
]]
function SceneStack:getTop()
	return list_[#list_]
end

--[[
	移除特定的元素
	@controllerName:
]]
function SceneStack:remove(controllerName)
	JJLog.i(TAG, "remove, controllerName=", controllerName)
	local count = #list_
	local controller = nil
	for i=1, count do
		controller = list_[i]
		if (controller:getTag() == controllerName) then
			controller:onPause()
			controller:onInactive()
			controller:onDestory()
			table.remove(list_, i)
			JJLog.i(TAG, "remove, OK controllerName=", controllerName)
			return
		end
	end
	JJLog.i(TAG, "remove, FAIL controllerName=", controllerName)
end

--[[
	移除所有界面
]]
function SceneStack:removeAll()
	JJLog.i(TAG, "removeAll")
	for i=1,#list_ do
		list_[i] = nil
	end
end

--[[
	根据控制器路径判断是否包含在当前的栈中
	@controllerName:
]]
function SceneStack:contain(controllerName)
	for i=1, #list_ do
		local controller = list_[i]
		if controller:getTag() == controllerName then
			return true
		end
	end
	return false
end

--[[
	根据界面定义判断是否包含在当前的栈中
	@sceneId:
]]
function SceneStack:containSceneId(sceneId)
	for i=1, #list_ do
		local controller = list_[i]
		if controller:getSceneId() == sceneId then
			return true
		end
	end
	return false
end

--[[
	退到某个：移除Top和xxx之间的所有元素，再走pop流程
	@controllerName: 需要退回到那个界面
	@pop: 当前最顶上的界面处理，是弹出（带动画）还是后台销毁
]]
function SceneStack:removeTo(controllerName, pop)
	local count = #list_
	for i=1, count do
		local controller = list_[i]
		if controller:getTag() == controllerName then
			if i ~= count then -- 自己本来就在栈顶，不用做任何变化
				-- 找到了，将它之后的，且不是最后一个都移除掉
				for j=i+1, count-1 do
					local tmp = list_[i + 1]
					tmp:onDestory()
					table.remove(list_, i + 1)
				end

				-- 弹出：将最后一个做弹出操作
				if pop then
					self:pop()
				else -- 不弹出：直接清理掉最后一个
					local tmp = list_[i + 1]
					tmp:onPause()
					tmp:onInactive()
					tmp:onDestory()
					table.remove(list_, i + 1)
				end
			end
			return
		end
	end
end

--[[
	挂起
]]
function SceneStack:pause()
	local top = self:getTop()
	if top then
		top:onPause()
	end
end

--[[
	恢复: 重绘界面
]]
function SceneStack:resume()
	local top = self:getTop()
	if top then
		top:onResume()
	end
end

--[[
	动画切换开始
]]
function SceneStack:transitionStart()
	JJLog.i(TAG, "transitionStart")
	transition_ = true
end

--[[
	动画切换结束
]]
function SceneStack:transitionOver()
	JJLog.i(TAG, "transitionOver")
	transition_ = false
	_checkToNext(self)
end

--[[
	Dump 整个栈
]]
_trace = function()
	JJLog.i(TAG, vardump(SceneStack, "SceneStack"))
end

--[[
	跳转到下一个界面
]]
_toNextScene = function(self)

	JJLog.i(TAG, "_toNextScene, transition_=", transition_)
	if transition_ then
		return
	end

	local param = wait_[1]
	if param ~= nil then
		table.remove(wait_, 1)

		local controllerClass = require(param.controllerName)
	  	local controller = controllerClass.new(param.controllerName, param.sceneName, param.params)
	  	controller:setSceneId(param.sceneId)
		controller:setTransitionType("slideinr")
		controller:onActive()
		if controller:onResume() == true then
			JJLog.i(TAG, "push, OK")
			local top = self:getTop()
			if top then
				top:onPause()
				top:onInactive()
			end
			list_[#list_ + 1] = controller
		end
	end

	if table.maxn(wait_) == 0 then
		JJSDK:pauseNetMsg(TAG, false)
	end
end

--[[
	检查是否能跳转下一个界面。需要等上一个界面的切换动画播完后才行
]]
_checkToNext = function(self)
	JJLog.i(TAG, "_checkToNext")
	if Util:isAppActive() then
		scheduler_.performWithDelayGlobal(handler(self, _toNextScene), 0)
	else
		_toNextScene(self)
	end
end

return SceneStack