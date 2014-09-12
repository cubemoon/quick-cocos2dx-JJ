--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/22
-- Time: 19:53
-- To change this template use File | Settings | File Templates.
--
local Operaters = {}
require("game.data.analytics.JJAnalyticsDefine")
require("game.data.analytics.OperaterInfo")

function Operaters:getNew(date)
    local operaters = {}

    operaters[JJAnalyticsDefine.KEY_DATE] = date
    operaters[JJAnalyticsDefine.KEY_USER_OPERATER] = {}

    return operaters
end

function Operaters:getOperaters(operaters)
    local datas = operaters[JJAnalyticsDefine.KEY_USER_OPERATER]
    return datas
end

function Operaters:addOperater(operaters, operater, ip)
    local operaters = self:getOperaters(operaters)
    local opt = nil

    for k, v in pairs(operaters) do
        if (v[JJAnalyticsDefine.KEY_OPERATER] == operater and v[JJAnalyticsDefine.KEY_LOCAL_IP] == ip) then
            opt = v
            break
        end
    end

    if (opt == nil) then
        opt = OperaterInfo:getNew(operater, ip)
        table.insert(operaters, opt)
    end

    opt[JJAnalyticsDefine.KEY_TOTAL_COUNT] = opt[JJAnalyticsDefine.KEY_TOTAL_COUNT] + 1
end

return Operaters