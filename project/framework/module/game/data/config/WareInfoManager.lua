-- wareinfo 管理文件
WareInfoManager = {}

local timeStamp_ = 0 -- wareinfo的时间戳

-- 初始化时间戳
local function _initTimeStamp()
    local path = string.format("config/wares/timestamp.lua")
    timeStamp_ = LuaDataFile.get(path)
    if timeStamp_ == nil then
        timeStamp_ = 0
    end
end

-- 保存时间戳
local function _saveTimeStamp(lup)
    if (timeStamp_ == 0 or (tonumber(timeStamp_) < lup)) then
        timeStamp_ = lup
        local path = string.format("update/module/game/res/config/wares/timestamp.lua")
        LuaDataFile.save(lup, path)
    end
end

--获取该游戏的比赛配置时间戳
function WareInfoManager:getTimeStamp()
    if timeStamp_ == 0 then
        _initTimeStamp()
    end
    return timeStamp_
end

function WareInfoManager:getWareItem(wareId)
    if wareId == nil then
        return nil
    end
    local path = string.format("config/wares/%d_mc.lua",wareId)
    return LuaDataFile.get(path)
end

function WareInfoManager:getWareName(wareId)
    if wareId == nil then
        return nil
    end    
    local path = string.format("config/wares/%d_mc.lua",wareId)
    local wareItem = LuaDataFile.get(path)
    return (wareItem and wareItem.ware_name) or "未知物品"
end


--获取比赛配置
function WareInfoManager:saveWareMsg(wareItem)
    local keyId = tonumber(wareItem.ware_id)
    local lup = tonumber(wareItem.last_update)
    local path = string.format("update/module/game/res/config/wares/%d_mc.lua",keyId)
    _saveTimeStamp(lup)
    if wareItem.status ~= 1 then        
        LuaDataFile.save(wareItem, path)
    end
end

return WareInfoManager