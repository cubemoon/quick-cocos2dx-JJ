--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/23
-- Time: 14:46
-- To change this template use File | Settings | File Templates.
--
local JJAnalyticsSend = {}
require("game.data.analytics.JJAnalyticsDefine")

function JJAnalyticsSend:getImeiLow8()
    local imei = Util:getIMEI()
    local imei_low8 = imei

    if (string.len(imei) >= 8) then
        imei_low8 = string.sub(imei, 1, 8)
    end

    return imei_low8, imei
end

function JJAnalyticsSend:getSendParams(checkPre, action, isSingle)
    local imei8, imei = self:getImeiLow8()
    local param = {}

    if (isSingle) then --如果是单机，使用完整的imei号
        imei8 = imei
    end
    local str = checkPre .. imei8
    local md5 = crypto.md5(str, false)

    param[JJAnalyticsDefine.TAG_IMEI] = Util:getIMEI()
    param[JJAnalyticsDefine.TAG_ICCID] = Util:getICCID()
    param[JJAnalyticsDefine.TAG_CHECK_VALUE] = md5
    param[JJAnalyticsDefine.TAG_USER_ACTION] = action

    return param
end

function JJAnalyticsSend:SendBehavios(gameId, record)
    local behavios = record[JJAnalyticsDefine.KEY_USER_BEHAVIORS]

    if (behavios and table.nums(behavios) > 0) then
        local param = self:getSendParams(JJAnalyticsDefine.CHECK_PRE_USER_ACTION_UPLOAD, behavios, false)
        HttpMsg:sendUserBehaviorsReq(gameId, param)
    end
end

function JJAnalyticsSend:SendOperaters(gameId, record)
    local operaters = record[JJAnalyticsDefine.KEY_USER_OPERATER]

    if (operaters and table.nums(operaters) > 0) then
        local param = self:getSendParams(JJAnalyticsDefine.CHECK_PRE_USER_ACTION_UPLOAD, operaters, false)
        HttpMsg:sendUserOeratersReq(gameId, param)
    end
end

function JJAnalyticsSend:SendSingleLord(gameId, record)
    local lorddatas = record[JJAnalyticsDefine.KEY_SINGLE_LORD]

    if (lorddatas and table.nums(lorddatas) > 0) then
        local param = self:getSendParams(JJAnalyticsDefine.CHECK_PRE_SINGLE_LORD_UPLOAD, lorddatas, true)
        HttpMsg:sendSingleLordDataReq(gameId, param)
    end
end

function JJAnalyticsSend:SendDayRecord(gameId, record)
    if (gameId == nil or gameId == 0 or record == nil) then
        return
    end

    self:SendBehavios(gameId, record)
    self:SendOperaters(gameId, record)
    self:SendSingleLord(gameId, record)
end

return JJAnalyticsSend