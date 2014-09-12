--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/22
-- Time: 14:31
-- To change this template use File | Settings | File Templates.
--
local Behaviors = {}
require("game.data.analytics.JJAnalyticsDefine")
require("game.data.analytics.NetInfo")

--JJAnalyticsDefine.KEY_NET_TYPE = "net_type"; -- 网络制式
--JJAnalyticsDefine.KEY_NET_CARRIER = "net_carrier"; -- 运营商
--JJAnalyticsDefine.KEY_LOCAL_IP = "local_ip"; -- 本地IP
--JJAnalyticsDefine.KEY_CONN_INFO = "conn"; -- 访问信息
function Behaviors:getNew(date)
    local behaviors = {}

    behaviors[JJAnalyticsDefine.KEY_DATE] = date
    behaviors[JJAnalyticsDefine.KEY_USER_BEHAVIORS] = {}

    return behaviors
end

function Behaviors:getNetInfo(behaviors, type)
    local datas = behaviors[JJAnalyticsDefine.KEY_USER_BEHAVIORS]
    local data = nil

    for k, v in pairs(datas) do
        if (v[JJAnalyticsDefine.KEY_NET_TYPE] == type) then
            data = v
            break --相同的记录只会有一条，找到即可结束
        end
    end

    if (data == nil) then
        data = NetInfo:getNew(type)
        table.insert(datas, data)
    end

    return data
end

return Behaviors