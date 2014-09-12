--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/22
-- Time: 21:36
-- To change this template use File | Settings | File Templates.
--

local SgLordInfos = {}
require("game.data.analytics.JJAnalyticsDefine")
require("game.data.analytics.SingleLordInfo")

function SgLordInfos:getNew(date)
    local lordinfos = {}

    lordinfos[JJAnalyticsDefine.KEY_DATE] = date
    lordinfos[JJAnalyticsDefine.KEY_SINGLE_LORD] = {}

    return lordinfos
end

function SgLordInfos:getSgLordInfos(lordinfos)
    local datas = lordinfos[JJAnalyticsDefine.KEY_SINGLE_LORD]
    return datas
end

function SgLordInfos:getSgLordInfo(lordinfos, imei)
    local infos = self:getSgLordInfos(lordinfos)
    local info = nil

    for k, v in pairs(infos) do
        if (v[JJAnalyticsDefine.KEY_SINGLE_LORD_IMEI] == imei) then
            info = v
            break
        end
    end

    if (info == nil) then
        info = SingleLordInfo:getNew(imei)
        table.insert(infos, info)
    end

    return info
end

return SgLordInfos