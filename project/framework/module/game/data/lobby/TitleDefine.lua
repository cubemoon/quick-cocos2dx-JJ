--[[
    各游戏中称号定义
]]

local TitleDefine = class("TitleDefine")

function TitleDefine:hasTitle(gameId)
    return false
end    

function TitleDefine:getTitleData(gameId)
    return {}
end    

function TitleDefine:getTitle(gameId)
    return ""
end    

function TitleDefine:getCertName(gameId, cert)
    return ""
end    

return TitleDefine