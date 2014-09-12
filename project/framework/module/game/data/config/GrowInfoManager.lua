-- growinfo 管理文件
GrowInfoManager = {
}

function GrowInfoManager:getGrowName(growId)
    if growId == nil then
        return nil
    end    
    local path = string.format("config/grows/%d_grow.lua",growId)
    local growItem = LuaDataFile.get(path)
    return (growItem and growItem.name) or "未知物品"
end

function GrowInfoManager:getGrowItem(growId)
    if growId == nil then
        return nil
    end
    local path = string.format("config/grows/%d_grow.lua",growId)
    return LuaDataFile.get(path)
end



return GrowInfoManager