--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/22
-- Time: 20:38
-- To change this template use File | Settings | File Templates.
--

SingleLordOnlineTime = {}
require("game.data.analytics.JJAnalyticsDefine")

--JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_TIME = "logintime"; -- 登入时间
--JJAnalyticsDefine.KEY_SINGLE_LORD_LOGOUT_TIME = "logouttime"; -- 登出时间
--JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_TIME_VALUE = "logintimevalue"; -- 登入时间
--JJAnalyticsDefine.KEY_SINGLE_LORD_LOGOUT_TIME_VALUE = "logouttimevalue"; -- 登出时间
--JJAnalyticsDefine.KEY_SINGLE_LORD_TOTAL_TIME = "totaltime"; -- 在线时间
function SingleLordOnlineTime:getNew(logintime)
    local online = {}

    online[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_TIME] = ""
    online[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGOUT_TIME] = ""
    online[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_TIME_VALUE] = 0
    online[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGOUT_TIME_VALUE] = 0
    online[JJAnalyticsDefine.KEY_SINGLE_LORD_TOTAL_TIME] = 0

    self:setLoginTimeValue(online, logintime)

    return online
end

function SingleLordOnlineTime:setLoginTimeValue(online, logintime)
    online[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_TIME_VALUE] = logintime
    online[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_TIME] = JJTimeUtil:formatDateTimeStringMillis(logintime)
end

function SingleLordOnlineTime:setLogoutTimeValue(online, logouttime)
    online[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGOUT_TIME_VALUE] = logouttime
    online[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGOUT_TIME] = JJTimeUtil:formatDateTimeStringMillis(logouttime)

    online[JJAnalyticsDefine.KEY_SINGLE_LORD_TOTAL_TIME] = logouttime - online[JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_TIME_VALUE]
end

return SingleLordOnlineTime