--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/29
-- Time: 19:34
-- To change this template use File | Settings | File Templates.
--

local AnalyticsHttpConns = {}
require("sdk.file.LuaDataFile")
local HTTP_CONNS_PATH = "update/module/game/data/AnalyticsConfig.json"

function AnalyticsHttpConns:getSavedHttpConns()
    local analyticsData = LuaDataFile.get(HTTP_CONNS_PATH)
    return analyticsData
end

function AnalyticsHttpConns:removeAndSave()
    local analyticsData = {}

    LuaDataFile.save(analyticsData, HTTP_CONNS_PATH)
end

return AnalyticsHttpConns