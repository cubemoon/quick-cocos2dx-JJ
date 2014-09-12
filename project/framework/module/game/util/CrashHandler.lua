CrashHandler = {}
local TAG = "CrashHandler"
local lastSec_ = 0 -- 最后一次上传的时间点
local lastLog_ = nil -- 最后一次上传的 Lua Error 内容

-- 示例：
--  LUA ERROR: [string "/Users/Milk/Work/Quick/SVN/quick-cocos2d-x/pr..."]:156: invalid 'self' in function 'setString'
-- stack traceback:
--     [C]: in function 'setString'
--     [string "/Users/Milk/Work/Quick/SVN/quick-cocos2d-x/pr..."]:156: in function 'setText'
--     [string "/Users/Milk/Work/Quick/SVN/quick-cocos2d-x/pr..."]:75: in function <[string "/Users/Milk/Work/Quick/SVN/quick-cocos2d-x/pr..."]:51>

local function _findKey(log)
    local i, j = string.find(log, ":%d+:.+stack")
    if i ~= nil and i > 0 and j ~= nil and j > i then
        return string.sub(log, i, j-6)
    end
end

local function _upload(log)
    local request = network.createHTTPRequest(function(event)
        print(vardump(event, "upload, event"))
        end, "http://update.m.jj.cn/mobile/android/error_log.php", "POST")
    local compiletimeInt, compiletimeStr = Util:getApkBuildTime()
    request:addPOSTValue("imei", Util:getIMEI())
    request:addPOSTValue("model", Util:getDeviceModel())
    request:addPOSTValue("sys_ver", Util:getSysVersion())
    request:addPOSTValue("platform", device.platform)
    request:addPOSTValue("gameid", CURRENT_PACKAGE_ID)
    request:addPOSTValue("app_ver", Util:getClientVersion())
    request:addPOSTValue("script_ver", Util:getScriptVersion())
    request:addPOSTValue("nickname", UserInfo.nickname_)
    request:addPOSTValue("compiletime", compiletimeStr)
    request:addPOSTValue("log", log)

    local util = require("sdk.util.Util")
    if util:isWap() then
        util:setWapProxy(request)
    end
    request:start()
end

-- 供 C++ 调用的全局函数，传进来的是需要上传的日志内容。
function CrashHandler:sendLog(log)
    local curSec = getCurrentSecond()
    if curSec - lastSec_ > 10 then
        local _log = string.gsub(log, "%(", "")
        _log = string.gsub(_log, "%)", " ")
        local i = nil
        if lastLog_ ~= nil then
            i = string.find(_log, lastLog_)
        end
        if i == nil then
            lastLog_ = _findKey(_log)
            lastSec_ = curSec
            _upload(log)
        end
    end
end

return CrashHandler