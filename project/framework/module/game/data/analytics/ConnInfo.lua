--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/22
-- Time: 10:04
-- To change this template use File | Settings | File Templates.
--
ConnInfo = {}
require("game.data.analytics.JJAnalyticsDefine")

--JJAnalyticsDefine.KEY_SERV_IP = "serv_ip"; -- 服务器IP
--JJAnalyticsDefine.KEY_TOTAL_COUNT = "total"; -- 访问总次数
--JJAnalyticsDefine.KEY_FAIL_COUNT = "fail"; -- 失败次数
--JJAnalyticsDefine.KEY_TOTAL_TIME = "total_time"; -- 消耗总时长
--JJAnalyticsDefine.KEY_FAIL_TIME = "fail_time"; -- 失败总时长
--JJAnalyticsDefine.KEY_BROKEN = "broken"; -- 断线总次数
--JJAnalyticsDefine.KEY_UP_FLOW = "up_flow"; -- 上行流量
--JJAnalyticsDefine.KEY_DOWN_FLOW = "down_flow"; -- 下行流量
--JJAnalyticsDefine.KEY_ONLINE_DUR = "online_dur"; -- 在线时长
function ConnInfo:getNew(serverip)
    local conn = {}

    conn[JJAnalyticsDefine.KEY_BROKEN] = 0
    conn[JJAnalyticsDefine.KEY_TOTAL_TIME] = 0
    conn[JJAnalyticsDefine.KEY_TOTAL_COUNT] = 0
    conn[JJAnalyticsDefine.KEY_SERV_IP] = serverip
    conn[JJAnalyticsDefine.KEY_FAIL_TIME] = 0
    conn[JJAnalyticsDefine.KEY_FAIL_COUNT] = 0
    conn[JJAnalyticsDefine.KEY_UP_FLOW] = 0
    conn[JJAnalyticsDefine.KEY_DOWN_FLOW] = 0
    conn[JJAnalyticsDefine.KEY_ONLINE_DUR] = 0

    return conn
end

function ConnInfo:addSuc(conn, cost)
    if (conn) then
        conn[JJAnalyticsDefine.KEY_TOTAL_COUNT] = conn[JJAnalyticsDefine.KEY_TOTAL_COUNT] + 1
        conn[JJAnalyticsDefine.KEY_TOTAL_TIME] = conn[JJAnalyticsDefine.KEY_TOTAL_TIME] + cost
    end
end

function ConnInfo:addFail(conn, cost)
    if (conn) then
        conn[JJAnalyticsDefine.KEY_FAIL_COUNT] = conn[JJAnalyticsDefine.KEY_FAIL_COUNT] + 1
        conn[JJAnalyticsDefine.KEY_FAIL_TIME] = conn[JJAnalyticsDefine.KEY_FAIL_TIME] + cost

        conn[JJAnalyticsDefine.KEY_TOTAL_COUNT] = conn[JJAnalyticsDefine.KEY_TOTAL_COUNT] + 1
        conn[JJAnalyticsDefine.KEY_TOTAL_TIME] = conn[JJAnalyticsDefine.KEY_TOTAL_TIME] + cost
    end
end

function ConnInfo:addBroken(conn)
    if (conn) then
        conn[JJAnalyticsDefine.KEY_BROKEN] = conn[JJAnalyticsDefine.KEY_BROKEN] + 1
    end
end

function ConnInfo:addUpFlow(conn, size)
    if (conn) then
        conn[JJAnalyticsDefine.KEY_UP_FLOW] = conn[JJAnalyticsDefine.KEY_UP_FLOW] + size
    end
end

function ConnInfo:addDownFlow(conn, size)
    if (conn) then
        conn[JJAnalyticsDefine.KEY_DOWN_FLOW] = conn[JJAnalyticsDefine.KEY_DOWN_FLOW] + size
    end
end

function ConnInfo:addOnlineDur(conn, dur)
    if (conn) then
        conn[JJAnalyticsDefine.KEY_ONLINE_DUR] = conn[JJAnalyticsDefine.KEY_ONLINE_DUR] + dur
    end
end

return ConnInfo