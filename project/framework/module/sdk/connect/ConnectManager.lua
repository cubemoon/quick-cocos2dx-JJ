-- 连接管理
ConnectManager = {}
local TAG = "ConnectManager"

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local STATE_IDLE = 0 		-- 未连接
local STATE_CONNECTED = 1 	-- 已连接
local state_ = STATE_IDLE

local socket_ -- JJSocketRequest 句柄
local scheduleHandler_ -- 帧回调句柄
local msgCallback_ -- 回调到处理消息的函数
local timerCallback_
local pause_ = false -- 是否暂停处理消息

local lastSendTick_ = 0 -- 最后一次发送消息的时间
local lastHeartBeatTick_ = 0 -- 最后一次心跳消息时间
local lastHeartBeatCheckTick_ = 0 -- 最后一条心跳消息的超时时间，超过这个时间还未收到就是网慢了
local heartSerial_ = 0 -- 心跳计数
local heart_ = {}
local NET_LAZY_TICK = 2 -- 心跳消息超过多长时间收到算网络慢
local HEART_BEAT_INTERVAL = 15 -- 心跳间隔
local GENERAL_ALIVE_INTERVAL = 5 -- 保持连接
local lastRecvTick_ = 0 -- 最后一次收到消息的时间
local TIME_OUT_INTERVAL = 90 -- 超时间隔，超过这么长时间还未收到消息，说明断线

-- 本地函数
local _init
local _sendHeartBeat
local _handleHeartBeat
local _sendGeneralAlive
local _update
local _dispatchMsg
local _sendHeader

--网络连接数据分析
local HEADER_LENGTH = 24 + 44 --增加TCP包头长度
local lastConnectedAddr = nil
local startConnectTime = 0
local connectedTime = 0

function ConnectManager:analyticUpflow(len)
    if (lastConnectedAddr) then
        JJAnalytics:addUpFlow(lastConnectedAddr, len + HEADER_LENGTH)
    end
end

function ConnectManager:analyticDisconnect(isbroken)
    if (lastConnectedAddr and connectedTime ~= 0) then
        if (isbroken) then
            JJAnalytics:addBroken(lastConnectedAddr)
        end

        JJAnalytics:addOnlineDur(lastConnectedAddr, getCurrentMillis() - connectedTime)
        connectedTime = 0
        lastConnectedAddr = nil
    end
end

function ConnectManager:registerListener(listener)
    msgCallback_ = listener
end

function ConnectManager:registerTimerListener(listener)
    timerCallback_ = listener
end

-- 是否连接
function ConnectManager:isConnect()
	local ret = (state_ == STATE_CONNECTED)
	if ret then
		JJLog.i(TAG, "isConnect, ret is true")
	else
		JJLog.i(TAG, "isConnect, ret is false")
	end
	return ret
end

-- 断开连接
function ConnectManager:disconnect()
	JJLog.i(TAG, "disconnect")
	if socket_ then
		JJSocketRequest:stopLua(socket_)
		socket_ = nil
	end

	if scheduleHandler_ then
		scheduler.unscheduleGlobal(scheduleHandler_)
		scheduleHandler_ = nil
	end

    state_ = STATE_IDLE
    self:analyticDisconnect(false) --处理在线时长分析
end

-- 请求连接
function ConnectManager:connect(addrs)
	JJLog.i(TAG, "connect")
	_init(addrs)
	if socket_ then
		JJSocketRequest:startLua(socket_)
		scheduleHandler_ = scheduler.scheduleUpdateGlobal(function(dt) _update(dt) end)
	end
end

-- 发送消息
function ConnectManager.send(buf)
	JJLog.i(TAG, "send")
	if socket_ then
		lastSendTick_ = getCurrentSecond()
		local len = string.len(buf)
		_sendHeader(len)
		JJSocketRequest:sendLua(socket_, buf, len)

        ConnectManager:analyticUpflow(len)
	end
end

-- 暂停处理消息
function ConnectManager:pause(flag)
	JJLog.i(TAG, "pause, flag=", flag)
    if Util:isAppActive() or not flag then
	   pause_ = flag
    end
end

-- 建立 JJSocketRequest 并初始化
function _init(addrs)
	lastRecvTick_ = 0
    lastHeartBeatTick_ = 0
	socket_ = JJSocketRequest:createLua()
	if socket_ then
		JJLog.i(TAG, "_init, create OK")

        -- 超时设置
        JJSocketRequest:setTimeoutLua(socket_, 30, 90000)

		for i, server in ipairs(addrs) do
			JJSocketRequest:addAddrLua(socket_, server.ip, server.port)
		end

		-- JJSocketRequest:addAddrLua(socket_, "lobby.m.jj.cn", 30300) -- 域名
		-- JJSocketRequest:addAddrLua(socket_, "115.182.2.49", 30300) -- 线上
		-- JJSocketRequest:addAddrLua(socket_, "118.186.69.35", 30300) -- 线上
		-- JJSocketRequest:addAddrLua(socket_, "192.168.20.192", 30800) -- 梁浩
	end
end

function ConnectManager:dealState2Analytic(msg)
    local function addDownloadFlow(len)
        if (lastConnectedAddr) then
            JJAnalytics:addDownFlow(lastConnectedAddr, len + HEADER_LENGTH)
        end
    end

    if msg.eType == MSG_TYPE_STATE then
        if msg.eState == kJJSocketRequestStateStartAddr then -- 开始连接
            startConnectTime = msg.time
            connectedTime = 0
            JJLog.i(TAG, "kJJSocketRequestStateStartAddr", startConnectTime)
        elseif msg.eState == kJJSocketRequestStateSuccessAddr then
            lastConnectedAddr = getStringFromChar(msg.buf)
            connectedTime = msg.time
            JJLog.i(TAG, "kJJSocketRequestStateSuccessAddr", lastConnectedAddr, connectedTime)
            JJAnalytics:addLoginTimes()
            JJAnalytics:addSuc(lastConnectedAddr, connectedTime - startConnectTime)
        elseif msg.eState == kJJSocketRequestStateFailAddr then
            local faiaddr = getStringFromChar(msg.buf)
            local failtime = msg.time
            lastConnectedAddr = nil
            JJLog.i(TAG, "kJJSocketRequestStateFailAddr", faiaddr, failtime)
            JJAnalytics:addFail(faiaddr, failtime - startConnectTime)
        elseif msg.eState == kJJSocketRequestStateDisconnect then
            self:analyticDisconnect(true)
        elseif msg.eState == kJJSocketRequestHeart then
            --JJLog.i(TAG, "dealState2Analytic kJJSocketRequestHeart")
            addDownloadFlow(8)
        end
    else
        addDownloadFlow(msg.len)
    end
end

-- 读取消息
function _update(dt)
    local curTick = getCurrentMillis()
	local curSec = getCurrentSecond()
	_dispatchTimer(curSec)
    
	if socket_ then

        if lastRecvTick_ ~= 0 and curSec - lastRecvTick_ > TIME_OUT_INTERVAL then
            JJLog.i(TAG, "timeout")
            _dispatchMsg(require("sdk.message.NetStateMessage").new(kJJSocketRequestStateDisconnect))
            ConnectManager:disconnect()
            state_ = STATE_IDLE
            return
        end

		repeat
			local msg = nil
			if pause_ == false then
                msg = JJSocketRequest:getMsgLua(socket_)
			end
      		if (msg ~= nil) then
				-- 本地消息：连接状态消息
                ConnectManager:dealState2Analytic(msg) --网络连接分析

				if msg.eType == MSG_TYPE_STATE then
					local  message = require("sdk.message.NetStateMessage").new(msg.eState)
					if msg.eState == kJJSocketRequestStateConnected then -- 连接成功
						state_ = STATE_CONNECTED
                        _dispatchMsg(message)
					elseif msg.eState == 100 or msg.eState == kJJSocketRequestHeart then
						lastRecvTick_ = curSec
                        _handleHeartBeat(msg.time)
                    elseif msg.eState == kJJSocketRequestStateDisconnect or msg.eState == kJJSocketRequestStateFail then
						state_ = STATE_IDLE
                        _dispatchMsg(message)
                    end
				else
					lastRecvTick_ = curSec
					local message = require("sdk.message.NetPBMessage").new(msg.nGameId, msg.buf, msg.len)
					_dispatchMsg(message)
				end

                JJSocketRequest:deleteMsgLua(socket_, true)

                if getCurrentMillis() - curTick > 30 then
                    JJLog.e(TAG, "_update, out for long time!!!");
                    break
                end
      		end
		until (msg == nil)

        -- 检查心跳是否超时
        if lastHeartBeatCheckTick_ ~= 0 and curSec > lastHeartBeatCheckTick_ then
            _dispatchMsg(require("sdk.message.NetLazyMessage").new())
            lastHeartBeatCheckTick_ = 0
        end

		-- 检查是否需要发送心跳消息
		if curSec - lastHeartBeatTick_ > HEART_BEAT_INTERVAL then
			_sendHeartBeat()
		end

        -- 检查是否需要发送存活消息
        if curSec - lastSendTick_ > GENERAL_ALIVE_INTERVAL then
            _sendGeneralAlive()
        end
	end
end

if device.platform == "android" then
    --连接上之后，启动主线程消息过滤函数
    className = "cn/jj/base/JJApplication"
    methodName = "setLuaFunctionId"
    sig = "(I)V"
    args = {_update}
    luaj.callStaticMethod(className, methodName, args, sig)
end

-- 转发消息
function _dispatchMsg(msg)
	if msgCallback_ then
    	msgCallback_(msg)
  	end
end

function _dispatchTimer(dt)
	if timerCallback_ then
    	timerCallback_(dt)
  	end
end

-- 发送消息头
function _sendHeader(len)
	if socket_ then
		JJSocketRequest:sendHeaderLua(socket_, 0x14801, 3700, 0, len)
	end
end

-- 发送心跳包
function _sendHeartBeat()
	if state_ == STATE_CONNECTED and socket_ then
		JJLog.i(TAG, "_sendHeartBeat")
		lastSendTick_ = getCurrentSecond()
        lastHeartBeatTick_ = lastSendTick_
        heartSerial_ = heartSerial_ + 1
        heart_[heartSerial_] = lastSendTick_
		JJSocketRequest:sendHeaderLua(socket_, 0x01, 3700, heartSerial_, 8)
		-- TODO:这种用法是有问题的，但是现在心跳消息不管内容，所以可以先用着
		local buf = "               "
		JJSocketRequest:sendLua(socket_, buf, 8)
        ConnectManager:analyticUpflow(8)

        lastHeartBeatCheckTick_ = lastSendTick_ + NET_LAZY_TICK
	end
end

-- 处理心跳消息
function _handleHeartBeat(serial)
    local tick = heart_[serial]
    JJLog.i(TAG, "_handleHeartBeat, serial=", serial, ", tick=", tick)
    if tick ~= nil and getCurrentSecond() - tick > NET_LAZY_TICK then
        _dispatchMsg(require("sdk.message.NetLazyMessage").new())
    end
    heart_[serial] = nil
    lastHeartBeatCheckTick_ = 0
end

-- 发送存活消息
function _sendGeneralAlive()
    if state_ == STATE_CONNECTED and socket_ then
        JJLog.i(TAG, "_sendGeneralAlive")
        lastSendTick_ = getCurrentSecond()
        JJSocketRequest:sendHeaderLua(socket_, 0x00, 3700, 0, 0)
        ConnectManager:analyticUpflow(0)
    end
end

return ConnectManager