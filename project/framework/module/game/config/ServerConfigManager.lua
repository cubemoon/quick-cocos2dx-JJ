ServerConfigManager = {}
local TAG = "ServerConfigManager"

local config_ = nil
local FILE_PATH = "config/ServerConfig.json"

-- 初始化
function ServerConfigManager:init()
    config_ = LuaDataFile.get(FILE_PATH)
end

-- 更新回调
local function _updateCB(self, event)
    JJLog.i(TAG, "_updateCB")
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
        if responseTable["LuaServerConf"] then
            local ret, content = pcall(loadstring(string.format("do local _=%s return _ end", string.sub(responseTable["LuaServerConf"], string.len("ServerConfig = ")))))
            if ret then
                LuaDataFile.save(content, "update/module/game/res/config/ServerConfig.json")
                self:init()
            end
        end
    end
end

-- 时间戳
local function _getLastUpdate()
    local last = 0
    if config_ and config_.last_update ~= nil then
        last = config_.last_update
    end
    return last
end

-- 更新
function ServerConfigManager:update()
    local url = string.format(self:getCheckUpdateUrl() .. "?sclu=%d", _getLastUpdate())
    JJLog.i(TAG, "update, url=", url)
    local request = network.createHTTPRequest(handler(self, _updateCB), url, "GET")
    request:setTimeout(15)
    local util = require("sdk.util.Util")
    if util:isWap() then
        util:setWapProxy(request)
    end
    request:start()
end

-- default_domain
function ServerConfigManager:getDefaultDomain()
    if config_ then
        return config_.default_domain
    end
end

-- default_server
function ServerConfigManager:getDefaultServer()
    if config_ then
        return config_.default_server
    end
end

-- server_list
function ServerConfigManager:getServerList()
    if config_ then
        return config_.server_list
    end
end

-- server_filter
function ServerConfigManager:getServerFilter()
    if config_ then
        return config_.server_filter
    end
end

-- http_domain
function ServerConfigManager:getHttpDomain()
    if config_ then
        return config_.http_domain
    end
end

-- 更新地址
function ServerConfigManager:getCheckUpdateUrl()
    local url = "http://update.m.jj.cn/mobile/lua/update.php"
    if config_ and config_.check_update_url ~= nil then
        url = config_.check_update_url
    end
    return url
end

-- 图片地址
function ServerConfigManager:getImgHost()
    local url = "http://image.m.jj.cn"
    if config_ and config_.img_host ~= nil then
        url = config_.img_host
    end
    return url
end

-- 节点地址
function ServerConfigManager:getGameNodeUrl()
    local url = "http://update.m.jj.cn/mobile/hall/get_lua_update.php"
    if config_ and config_.game_node_url ~= nil then
        url = config_.game_node_url
    end
    return url
end

return ServerConfigManager