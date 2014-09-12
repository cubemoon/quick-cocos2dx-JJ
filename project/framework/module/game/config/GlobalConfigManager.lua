--[[
如果要从全局配置文件取某个字段值，最好在该文件里面封装一个接口，避免字段不存在时引起错误
]]
GlobalConfigManager = {}
local TAG = "GlobalConfigManager"

local data_ = {}

function GlobalConfigManager:getConfig(packageId)
    if data_[packageId] == nil then
        data_[packageId] = LuaDataFile.get(GlobalConfigManager:getFilePath(packageId))
    end
    return data_[packageId]
end

-- 获取全局配置文件地址，不带 .lua
function GlobalConfigManager:getFilePath(packageId)
    return JJGameDefine.GAME_DIR_TABLE[packageId] .. "/res/config/".. packageId .. "_globalconfig.json"
end

-- 重新初始化
function GlobalConfigManager:reinit(packageId)
    data_[packageId] = nil
end

-- 时间戳
function GlobalConfigManager:getLastUpdateTime(packageId)
    local config = self:getConfig(packageId)
    print(GlobalConfigManager:getFilePath(packageId))
    dump(config)
    return (config and config.lastUpdate) or 0
end

-- before remind time
function GlobalConfigManager:getBeforeRemindTime(packageId)
    local config = self:getConfig(packageId)
    local ret = 0
    if config then
        ret = config.beforeRemindTime or 0
    end
    return tonumber(ret) or 0
end

function GlobalConfigManager:getAfterRemindTime(packageId)
    local config = self:getConfig(packageId)
    local ret = 0
    if config then
        ret = config.afterRemindTime or 0
    end
    return tonumber(ret) or 0 
end

function GlobalConfigManager:getRecomMatchInLobby(packageId)
    local config = self:getConfig(packageId)
    return (config and config.recomMatchInLobby) or ""
end

-- 是否改为大厅模式
function GlobalConfigManager:getShowLuaHall(packageId)
    local config = self:getConfig(packageId)
    local ret = false
    if config ~= nil then
        ret = (tonumber(config.showLuaHall) == 1)
    end
    return ret
end

-- 更新回调
local function _updateCB(event, packageId)
    JJLog.i(TAG, "_updateCB, packageId=", packageId)
    if event == nil then
        JJLog.e(TAG, "_updateCB, Err, event is nil")
        return
    end

    if event.name == "completed" then
        local req = event.request
        if req == nil or req:getResponseStatusCode() ~= 200 then
            JJLog.e(TAG, "_updateCB, Err, req error")
            return
        end

        local responseTable = json.decode(req:getResponseString()) or {}
        if responseTable["LuaGlobalConf"] then
            local ret, content = pcall(loadstring(string.format("do local _=%s return _ end", string.sub(responseTable["LuaGlobalConf"], string.len("GlobalConfig = ")))))
            if ret then
                LuaDataFile.save(content, "update/module/" .. GlobalConfigManager:getFilePath(packageId))
                GlobalConfigManager:reinit(packageId)
            end
        end
    end
end

-- 更新
function GlobalConfigManager:update(packageId)
    JJLog.i(TAG, "update, packageId=", packageId)
    local platform = device.platform
    if platform == "mac" or platform == "windows" then
        platform = "android"
    end
    local url = string.format(ServerConfigManager:getCheckUpdateUrl() .. "?gameid=%d&gclu=%d&platform=%s&model=%s&promoter=%d&lua=1", packageId, self:getLastUpdateTime(packageId), "android", device.model, PROMOTER_ID )
    JJLog.i(TAG, "update, url=", url)
    local request = network.createHTTPRequest(function(event) 
        _updateCB(event, packageId)
    end, url, "GET")
    request:setTimeout(15)
    local util = require("sdk.util.Util")
    if util:isWap() then
        util:setWapProxy(request)
    end
    request:start()
end

-- 闹钟时间
function GlobalConfigManager:getClockTime(packageId)
    local config = self:getConfig(packageId)
    local ctime = 10 --默认值为10分钟
    if config ~= nil then
        if config.clockTime then
            ctime = config.clockTime
        end
    end
    return ctime
end

--查看是否为语音版本
function GlobalConfigManager:getConfigRoarGroupApp(packageId)
    local ret = 0
    if packageId~=nil then
        data_[packageId] = nil
        local config = self:getConfig(packageId)
        if config  then
            ret = config.roarGroupApp
        end
    end
    JJLog.i(TAG, "getConfigRoarGroupApp, packageId=", packageId,",ret=",ret)
    return ret
end

--
function GlobalConfigManager:getConfigRoarPostInterval(packageId)
    local ret = 10
    if packageId~=nil then
        local config = self:getConfig(packageId)
        if config  then
            ret = config.postInterval
        end
    end
    JJLog.i(TAG, "getConfigRoarPostInterval, packageId=", packageId,",ret=",ret)
    return ret
end

--clientSW
function GlobalConfigManager:getConfigClientSW(packageId)
    local ret = 0
    if packageId~=nil then
        local config = self:getConfig(packageId)
        dump(config)
        if config  then
            ret = config.clientSW
        end
    end
    JJLog.i(TAG, "getConfigClientSW, packageId=", packageId,",ret=",ret)
    return ret
end

--排行榜相关设置
function GlobalConfigManager:getConfigTopDetail(packageId)
    local ret = 0
    if packageId~=nil then
        local config = self:getConfig(packageId)
        if config then
            ret = config.topDetail
        end
    end
    JJLog.i(TAG, "getConfigTopDetail, packageId=", packageId,",ret=",ret)
    return ret
end

-- 无条件转化为大厅
function GlobalConfigManager:getMustHall(packageId)
    local ret = false
    if packageId ~= nil then
        local config = self:getConfig(packageId)
        if config then
            ret = (tonumber(config.mustHall) == 1)
        end
    end
    JJLog.i(TAG, "getMustHall, packageId=", packageId, ", ret=", ret)
    return ret
end

return GlobalConfigManager