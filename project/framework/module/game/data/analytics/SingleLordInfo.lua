--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/22
-- Time: 20:37
-- To change this template use File | Settings | File Templates.
--

SingleLordInfo = {}
require("game.data.analytics.JJAnalyticsDefine")
require("game.data.analytics.SingleLordOnlineTime")

--JJAnalyticsDefine.KEY_SINGLE_LORD_IMEI = "imei"; -- 用户ID
--JJAnalyticsDefine.KEY_SINGLE_LORD_INFO = "singlelordinfo"; -- 用户ID
--JJAnalyticsDefine.KEY_SINGLE_LORD_ONLINE = "online"; -- 在线时长
--JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_COUNT = "logincount"; -- 日登陆
--JJAnalyticsDefine.KEY_SINGLE_LORD_LEVEL = "level"; -- 平均等级
--JJAnalyticsDefine.KEY_SINGLE_LORD_COPPER = "copper"; -- 平均铜板数
function SingleLordInfo:getNew(imei)
    local info = {}

    info[JJAnalyticsDefine.KEY_SINGLE_LORD_IMEI] = imei
    info[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_COUNT] = 0
    info[JJAnalyticsDefine.KEY_SINGLE_LORD_LEVEL] = 0
    info[JJAnalyticsDefine.KEY_SINGLE_LORD_COPPER] = 0
    info[JJAnalyticsDefine.KEY_SINGLE_LORD_ONLINE] = {}

    return info
end

function SingleLordInfo:addSingleLoginCount(info)
    info[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_COUNT] = info[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_COUNT] + 1
end

function SingleLordInfo:setSingleLordLevel(info, level)
    info[JJAnalyticsDefine.KEY_SINGLE_LORD_LEVEL] = level
end

function SingleLordInfo:setSingleLordCopper(info, copper)
    info[JJAnalyticsDefine.KEY_SINGLE_LORD_COPPER] = copper
end

function SingleLordInfo:getSgLordOnline(info, loginTime)
    local onlines = info[JJAnalyticsDefine.KEY_SINGLE_LORD_ONLINE]
    local online = nil

    for k, v in pairs(onlines) do
        if (v[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_TIME_VALUE] == loginTime) then
            online = v
            break
        end
    end

    if (online == nil) then
        online = SingleLordOnlineTime:getNew(loginTime)
        table.insert(onlines, online)
    end

    return online
end

function SingleLordInfo:setSingleLordLoginTime(info, loginTime)
    local online = self:getSgLordOnline(info, loginTime)
    SingleLordOnlineTime:setLoginTimeValue(online, loginTime)
end

function SingleLordInfo:setSingleLordLogoutTime(info, loginTime, logoutTime)
    local online = self:getSgLordOnline(info, loginTime)
    SingleLordOnlineTime:setLogoutTimeValue(online, logoutTime)
end

return SingleLordInfo