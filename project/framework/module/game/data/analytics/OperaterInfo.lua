--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/22
-- Time: 19:19
-- To change this template use File | Settings | File Templates.
--

OperaterInfo = {}
require("game.data.analytics.JJAnalyticsDefine")

--JJAnalyticsDefine.KEY_OPERATER = "operater"; -- 用户动作
function OperaterInfo:getNew(operater, local_ip)
    local info = {}

    info[JJAnalyticsDefine.KEY_OPERATER] = operater
    info[JJAnalyticsDefine.KEY_LOCAL_IP] = local_ip
    info[JJAnalyticsDefine.KEY_TOTAL_COUNT] = 0

    return info
end

return OperaterInfo