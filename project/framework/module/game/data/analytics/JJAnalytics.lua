--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/22
-- Time: 14:09
-- To change this template use File | Settings | File Templates.
--

JJAnalytics = {}

local TAG = "JJAnalytics"
local ANALYTICS_FILE_PATH = "data/AnalyticsData.lua"

require("sdk.util.Util")
require("game.util.JJTimeUtil")
require("sdk.debug.JJLog")
require("sdk.file.JJFileUtil")
require("sdk.file.LuaDataFile")

require("game.data.analytics.JJAnalyticsDefine")
local Behaviors = require("game.data.analytics.Behaviors")
local Operaters = require("game.data.analytics.Operaters")
local SgLordInfos = require("game.data.analytics.SgLordInfos")
local JJAnalyticsSend = require("game.data.analytics.JJAnalyticsSend")

--总的数据表，key为date，及记录的年月日
local AllData = {}

AllData.AppLunchTimes = 0 --应用启动次数
AllData.LoginTimes = 0 --应用登陆次数
AllData.SignupTimes = 0 --应用报名次数

local GAMEID = 0

function JJAnalytics:setGameId(gameid)
    GAMEID = gameid
end

local notInit = true
function JJAnalytics:init(gameid)
    if (gameid) then
        self:setGameId(gameid)
    end

    if (notInit) then
        local save = LuaDataFile.get(ANALYTICS_FILE_PATH)
        if (save) then
            AllData = save
        end
        self:addAppLunchTimes()
        notInit = false
    end
    --JJLog.i("fanqt JJAnalytics:init",vardump(AllData))
end

function JJAnalytics:addAppLunchTimes()
    if (AllData) then
        if AllData.AppLunchTimes == nil then
            AllData.AppLunchTimes = 0
        end
        AllData.AppLunchTimes = AllData.AppLunchTimes + 1
    end
end

function JJAnalytics:getAppLunchTimes()
    local ret = 0
    if (AllData) then
        ret = AllData.AppLunchTimes
    end
    return ret
end

function JJAnalytics:addLoginTimes()
    if (AllData) then
        if AllData.LoginTimes == nil then
            AllData.LoginTimes = 0
        end
        AllData.LoginTimes = AllData.LoginTimes + 1
    end
end

function JJAnalytics:getLoginTimes()
    local ret = 0
    if (AllData) then
        ret = AllData.LoginTimes
    end
    return ret
end

function JJAnalytics:addSignupTimes()
    if (AllData) then
        if AllData.SignupTimes == nil then
            AllData.SignupTimes = 0
        end
        AllData.SignupTimes = AllData.SignupTimes + 1
        self:Save2File()
    end
end

function JJAnalytics:getSignupTimes()
    local ret = 0
    if (AllData) then
        ret = AllData.SignupTimes
    end
    return ret
end

function JJAnalytics:Save2File()
    LuaDataFile.save(AllData, ANALYTICS_FILE_PATH)
end

local TODAY = nil --记录现在的日期 由于http和socket连接时还未同步网络时间，因此使用本地时间
function JJAnalytics:getToday()
    if (TODAY == nil) then
        TODAY = JJTimeUtil:getCurrentServerDateString()
    end
    return TODAY
end

--查找获取是否有不是今天的记录，如果有返回所有记录的表
function JJAnalytics:checkAndUpload()
    local ret = {}
    local date = self:getToday()
    local current = nil

    for k, v in pairs(AllData) do
        if (k == date) then
            current = v
        elseif (typen(v) == LUA_TTABLE) then
            ret[#ret + 1] = v
            JJAnalyticsSend:SendDayRecord(GAMEID, v) --发送今天之前每一天的数据
        end
    end

    local temp = AllData
    AllData = {} --删除所有数据
    AllData.AppLunchTimes = temp.AppLunchTimes --应用启动次数
    AllData.LoginTimes = temp.LoginTimes --应用登陆次数
    AllData.SignupTimes = temp.SignupTimes --应用报名次数

    if (current) then
        AllData[date] = current
    end

    --self:Save2File() --发送完之前的数据并删除后，保存
    return ret
end

--local TodayRecord = nil--记录今天的记录

--获取今天的记录，如果有今天的历史记录使用之前的历史记录
--否则创建新的table，并返回
function JJAnalytics:getTodayRecord()
    local date = self:getToday()
    TODAY = date

    local ret = AllData[date]

    if (ret == nil) then
        ret = {}
        AllData[date] = ret
    end

    return ret
end

function JJAnalytics:setServeToday()
    if (TODAY) then
        local date = self:getToday()
        local str = LuaDataFile.table2string(AllData)
        str = "local rpn = " .. str .. " return rpn"

        local tm = string.gsub(TODAY, "%-", "%%-")
        local dt = string.gsub(date, "%-", "%%-")
        --JJLog.i("fanqt setServeToday1",tm,dt)

        local rp = string.gsub(str, tm, dt)
        AllData = assert(loadstring(rp))()
        --JJLog.i("fanqt setServeToday",str,rp,TODAY,date,AllData)
        TODAY = date
        --self:Save2File()
    end
end

--获取当前的行为记录，如果有今天的历史记录使用之前的历史记录
--否则创建新的table，并返回
function JJAnalytics:getCurrentGroup(key, ifNilCreate)
    local todayrecord = self:getTodayRecord()
    local ret = todayrecord[key]

    if (ret == nil and ifNilCreate) then
        ret = {}
        todayrecord[key] = ret
    end

    return ret, todayrecord
end

--用户网路行为
function JJAnalytics:getCurrentBehaviors()
    local key = JJAnalyticsDefine.KEY_USER_BEHAVIORS
    local behaviors, record = self:getCurrentGroup(key)

    if (behaviors == nil) then
        behaviors = Behaviors:getNew(TODAY)
        record[key] = behaviors
    end

    return behaviors
end

--设置当前的网路环境
local LocalIp = ""
local nettype = "unknow"
function JJAnalytics:setNetType()
    nettype = Util:getNetworkName()
    JJLog.i(TAG, "setNetType")
end

function JJAnalytics:getNetType()
    --JJLog.i(TAG, "getNetType")
    return nettype
end

function JJAnalytics:getCurrentNetInfo()
    local type = self:getNetType()

    local behaviors = self:getCurrentBehaviors()
    local netinfo = Behaviors:getNetInfo(behaviors, type)

    return netinfo
end

local hasCheckUploaded = false
function JJAnalytics:setLocalIP(localip)
    LocalIp = localip
    local carrier = Util:getOperator()

    self:dealSavedHttp()
    --self:setServeToday()--重新同步服务器的日期

    local netinfo = self:getCurrentNetInfo()
    NetInfo:setLocalIp(netinfo, localip, carrier)

    if (not hasCheckUploaded) then
        self:checkAndUpload()
        hasCheckUploaded = true
    end
    self:Save2File()
end

function JJAnalytics:addSuc(serverip, cost, notSave)
    self:setNetType()
    local netinfo = self:getCurrentNetInfo()
    local conn = NetInfo:getConnInfo(netinfo, serverip)
    ConnInfo:addSuc(conn, cost)

    if (notSave) then
    else
        self:Save2File()
    end
end

function JJAnalytics:addFail(serverip, cost, notSave)
    self:setNetType()
    local netinfo = self:getCurrentNetInfo()
    local conn = NetInfo:getConnInfo(netinfo, serverip)
    ConnInfo:addFail(conn, cost)

    if (notSave) then
    else
        self:Save2File()
    end
end

function JJAnalytics:addBroken(serverip)
    self:setNetType()
    local netinfo = self:getCurrentNetInfo()
    local conn = NetInfo:getConnInfo(netinfo, serverip)
    ConnInfo:addBroken(conn)
    --self:Save2File()--在处理完在线时长后保存
end

function JJAnalytics:addUpFlow(serverip, size)
    local netinfo = self:getCurrentNetInfo()
    local conn = NetInfo:getConnInfo(netinfo, serverip)
    ConnInfo:addUpFlow(conn, size)
end

function JJAnalytics:addDownFlow(serverip, size)
    local netinfo = self:getCurrentNetInfo()
    local conn = NetInfo:getConnInfo(netinfo, serverip)
    ConnInfo:addDownFlow(conn, size)
end

function JJAnalytics:addOnlineDur(serverip, dur)
    local netinfo = self:getCurrentNetInfo()
    local conn = NetInfo:getConnInfo(netinfo, serverip)
    ConnInfo:addOnlineDur(conn, dur)
    self:Save2File()
end

local httpStartTime = nil
function JJAnalytics:setHttpStartTime(time)
    httpStartTime = time
end

function JJAnalytics:httpConnectComplete(fail)
    print("analiticsHttpConnect", fail)
    if (httpStartTime) then
        local ANALYTICS_HTTP_ADDR = "http"
        local costtime = getCurrentMillis() - httpStartTime
        JJAnalytics:init()

        if (fail) then
            JJAnalytics:addFail(ANALYTICS_HTTP_ADDR, costtime)
        else
            JJAnalytics:addSuc(ANALYTICS_HTTP_ADDR, costtime)
        end
        httpStartTime = nil
    end
end

function JJAnalytics:dealSavedHttp()
    local httpconns = require("game.data.analytics.AnalyticsHttpConns")
    local results = httpconns:getSavedHttpConns()
    if (results == nil) then
        return
    end

    JJLog.i("fanqt dealSavedHttp", vardump(results))
    for k, v in ipairs(results) do
        self:addHttpConnect(v)
    end

    httpconns:removeAndSave()
end

function JJAnalytics:addHttpConnect(connect)
    local ANALYTICS_HTTP_ADDR = "http"

    if (typen(connect) == LUA_TTABLE) then
        local success, costtime = connect.result, connect.time
        if (success) then
            self:addSuc(ANALYTICS_HTTP_ADDR, costtime, true)
        else
            self:addFail(ANALYTICS_HTTP_ADDR, costtime, true)
        end
    end
end

--单机斗地主
function JJAnalytics:getCurrentSingleLord()
    local key = JJAnalyticsDefine.KEY_SINGLE_LORD
    local lordinfos, record = self:getCurrentGroup(key)

    if (lordinfos == nil) then
        lordinfos = SgLordInfos:getNew(TODAY)
        record[key] = lordinfos
    end

    return lordinfos
end

function JJAnalytics:getSingleLordInfo()
    local imei = Util:getIMEI()
    local infos = self:getCurrentSingleLord()
    local info = SgLordInfos:getSgLordInfo(infos, imei)
    return info
end

function JJAnalytics:addSingleLoginCount()
    local info = self:getSingleLordInfo()
    SingleLordInfo:addSingleLoginCount(info)
end

function JJAnalytics:setSingleLordLevel(level)
    local info = self:getSingleLordInfo()
    SingleLordInfo:setSingleLordLevel(info, level)
end

function JJAnalytics:setSingleLordCopper(copper)
    local info = self:getSingleLordInfo()
    SingleLordInfo:setSingleLordCopper(info, copper)
end

local singleLordLoginTime = nil
function JJAnalytics:setSingleLordLoginTime()
    singleLordLoginTime = getCurrentMillis()
    local info = self:getSingleLordInfo()
    SingleLordInfo:setSingleLordLoginTime(info, singleLordLoginTime)
    self:Save2File()
end

function JJAnalytics:setSingleLordLogoutTime()
    if (singleLordLoginTime) then
        local info = self:getSingleLordInfo()
        SingleLordInfo:setSingleLordLogoutTime(info, singleLordLoginTime, getCurrentMillis())
        self:Save2File()
        singleLordLoginTime = nil
    end
end

--用户操作统计
function JJAnalytics:getCurrentOperater()
    local key = JJAnalyticsDefine.KEY_USER_OPERATER
    local operaters, record = self:getCurrentGroup(key)

    if (operaters == nil) then
        operaters = Operaters:getNew(TODAY)
        record[key] = operaters
    end

    return operaters
end

--用户操作统计
function JJAnalytics:getCurrentOperater()
    local key = JJAnalyticsDefine.KEY_USER_OPERATER
    local operaters, record = self:getCurrentGroup(key)

    if (operaters == nil) then
        operaters = Operaters:getNew(TODAY)
        record[key] = operaters
    end

    return operaters
end

function JJAnalytics:addOperater(operater, ip)
    local operaters = self:getCurrentOperater()

    Operaters:addOperater(operaters, operater, ip)
end

return JJAnalytics