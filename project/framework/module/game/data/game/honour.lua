--计算荣誉称号
--xinxy
local honour = class("honour")

--[[使用这种格式定义荣誉等级列表
local honourtable = {
    {200, 0, 0, "1级"},
    {700, 0, 0, "2级"},
    {2000, 0, 0,"3级"},
    {5000, 0, 0,"4级"},
    {10000, 0, 0,"5级"},
    {20000, 5, 0,"6级"},
    {35000, 10, 0,"7级"},
    {55000, 20, 0,"8级"},
    {80000, 40, 0,"9级"},
    {110000, 60, 10,"10级"},
    {150000, 100, 30,"11级"},
    {210000, 150, 50,"12级"},
    {290000, 200, 70,"13级"},
    {390000, 300, 90,"14级"},
    {510000, 500, 110,"15级"},
    {650000, 600, 130,"16级"}
}
]]

function honour:ctor(honourtable)
    honourtable_ = honourtable
end

function honour:getnotfirstlinelevel(score, index)
    local level = table.getn(honourtable_)
    for i=1, table.getn(honourtable_)-1 do
        if score>=honourtable_[i][index] and score<honourtable_[i+1][index] then
            level = i
        end
    end
    return level
end

function honour:getfirstlinelevel(score)
    local level = 1
    for i=1, table.getn(honourtable_)-1 do
        if score>=honourtable_[i][1] and score<honourtable_[i+1][1] then
            level = i
        end
    end
    if score >= honourtable_[table.getn(honourtable_)][1] then
        level = table.getn(honourtable_)
    end
    return level
end
--使用这个函数将玩家的数据传入，得到玩家的荣誉称号
function honour:gethonour(...)
    local valuearray = {}
    for i, v in ipairs{...} do
        valuearray[i] = v
    end

    if #valuearray < table.getn(honourtable_[1])-1 then
        local len = #valuearray
        for i=len+1, table.getn(honourtable_[1])-1 do
            valuearray[i] = 0
        end
    end

    for i=1, table.getn(valuearray) do
        valuearray[i] = math.max(valuearray[i], 0)
    end

    if valuearray[1] < honourtable_[1][1] then
        return honourtable_[1][table.getn(honourtable_[1])]
    end
    
    local allbig = true
    for i=1, table.getn(honourtable_[1])-1 do
        if valuearray[i]<honourtable_[table.getn(honourtable_)][i] then
            allbig = false
            break
        end            
    end
    if allbig then
        return honourtable_[table.getn(honourtable_)][table.getn(honourtable_[1])]
    end

    local level = self:getfirstlinelevel(valuearray[1])
    local count = math.min(#valuearray, table.getn(honourtable_[1])-1)
    if count > 1 then
        for i=2, count do
            level = math.min(self:getnotfirstlinelevel(valuearray[i], i), level)
        end
    end

    return honourtable_[level][table.getn(honourtable_[1])]
end

return honour