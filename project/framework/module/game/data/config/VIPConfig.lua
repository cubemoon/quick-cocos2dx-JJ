--[[
    VIP配置， linxh
]]
local VIPConfig = {}

function  VIPConfig:getVersion()    
    local cfg = LuaDataFile.get("game/res/config/vipconfig.lua")
    local ver = (cfg and cfg.version) or 0

    return ver
end

function  VIPConfig:getTitle()    
    local title = nil
    local cfg = LuaDataFile.get("game/res/config/vipconfig.lua")
    if cfg and cfg.data then 
       local growId = cfg.growid or 0
       local growCount = UserInfo:getGrowCount(growId)
       for _, vip in ipairs(cfg.data) do
               if growCount >= vip.value then 
                   title = vip.name
               end
       end
    end

    return title
end

function  VIPConfig:getVipGrowsInfo()  
	local growId = 0
	local growCount = 0  
    local cfg = LuaDataFile.get("game/res/config/vipconfig.lua")
    if cfg and cfg.data then 
       growId = cfg.growid or 0
       growCount = UserInfo:getGrowCount(growId)       
    end
    return growId, growCount
end

--require("game.config.vipconfig")

function  VIPConfig:getUserLevelName()    
    local levelName = nil
    
    if vipconfig and vipconfig.data then 
       local growId = vipconfig.growid or 0
       local growCount = UserInfo:getGrowCount(growId)
       for _, vip in ipairs(vipconfig.data) do
               if growCount >= vip.value then 
                   levelName = vip.name
               end
       end
    end

    return levelName
end

return VIPConfig