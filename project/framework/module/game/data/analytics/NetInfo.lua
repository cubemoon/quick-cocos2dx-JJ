--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/22
-- Time: 10:25
-- To change this template use File | Settings | File Templates.
--
NetInfo = {}
require("game.data.analytics.JJAnalyticsDefine")
require("game.data.analytics.ConnInfo")

--JJAnalyticsDefine.KEY_NET_TYPE = "net_type"; -- 网络制式
--JJAnalyticsDefine.KEY_NET_CARRIER = "net_carrier"; -- 运营商
--JJAnalyticsDefine.KEY_LOCAL_IP = "local_ip"; -- 本地IP
--JJAnalyticsDefine.KEY_CONN_INFO = "conn"; -- 访问信息
function NetInfo:getNew(type)
    local net = {}

    net[JJAnalyticsDefine.KEY_NET_TYPE] = type
    net[JJAnalyticsDefine.KEY_LOCAL_IP] = ""
    net[JJAnalyticsDefine.KEY_NET_CARRIER] = ""
    net[JJAnalyticsDefine.KEY_CONN_INFO] = {}

    return net
end

function NetInfo:setLocalIp(net, localip, carrier)
    if (net) then
        net[JJAnalyticsDefine.KEY_LOCAL_IP] = localip
        net[JJAnalyticsDefine.KEY_NET_CARRIER] = carrier
    end
end

function NetInfo:getConnInfo(net, server)
    local conns = net[JJAnalyticsDefine.KEY_CONN_INFO]
    local conn = nil

    for k, v in pairs(conns) do
        if (v[JJAnalyticsDefine.KEY_SERV_IP] == server) then
            conn = v
            break --相同的记录只会有一条，找到即可结束
        end
    end

    if (conn == nil) then
        conn = ConnInfo:getNew(server)
        table.insert(conns, conn)
    end

    return conn
end

return NetInfo

