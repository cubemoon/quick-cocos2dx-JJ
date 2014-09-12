-- 设置闹钟Manager
local alarmManager = {}

local TAG = "JJAlarmManager"

local DISTINCTION_TIME_VALUE_LONG = 1
local DISTINCTION_TIME_VALUE_NEAR = 2
local DISTINCTION_TIME_VALUE_PUSH = 3 --推送消息提醒

function alarmManager:setMatchAlarm()
    JJLog.i(TAG, "alarmManager:setMatchAlarm : ")
    local info = UserInfo
    local signupedMatchList = SignupStatusManager.signupedMatch_
    local sortedMatchList = {}
    if table.nums(signupedMatchList) > 0 then
        for k,v in pairs(signupedMatchList) do
            -- JJLog.i(TAG, " alarmManager:setMatchAlarm111 : ",k,vardump(v))
            table.insert(sortedMatchList,v)
        end
    end
    
    table.sort(sortedMatchList, function(a,b)
        if a.startTime_ ~= nil then
            return a.startTime_ > b.startTime_
        end
    end)
    local JJGameUtil = require("game.util.JJGameUtil")
    local gameName = JJGameUtil:getGameName(MainController:getCurGameId())
    local alarmIndex = self:getAlarmIndex()
    local curServerTime = JJTimeUtil:getCurrentServerTime()
    local lastLunchTime = 0
    for k,match in ipairs(sortedMatchList) do
        -- JJLog.i(TAG, " alarmManager:setMatchAlarm222 : ",k,vardump(match),curServerTime)
        local offsetTime = match.startTime_ * 1000 - curServerTime
        local configTime = GlobalConfigManager:getClockTime(MainController.packageId_)
        local timeBeforeStart = configTime * 60 * 1000
        local lunchAppTime = offsetTime - timeBeforeStart--+getCurrentMillis()
        JJLog.i(TAG, " offsetTime : ",offsetTime," configTime : ",configTime," timeBeforeStart : ",timeBeforeStart," lunchAppTime : ",lunchAppTime)
        if offsetTime > (timeBeforeStart + 5 * 60 * 1000) then
            if ((lastLunchTime == 0) or (lastLunchTime - lunchAppTime) > timeBeforeStart) then --curServerTime < lunchAppTime and
                lastLunchTime = lunchAppTime
                self:connectAlarm(gameName, match.matchName_, DISTINCTION_TIME_VALUE_LONG, configTime, lunchAppTime, alarmIndex)
            end
        else
            local lunchAppTimeTwo = offsetTime - 2*60*1000 --curTick +
            if offsetTime > 2 * 60 * 1000 and --and curServerTime < lunchAppTimeTwo
                    ((lastLunchTime == 0) or (lastLunchTime - lunchAppTime) > timeBeforeStart) then
                lastLunchTime = lunchAppTimeTwo
                self:connectAlarm(gameName, match.matchName_, DISTINCTION_TIME_VALUE_NEAR, 2, lunchAppTimeTwo, alarmIndex)
            end
        end
    end
end

function alarmManager:setPushAlarm(title,content,lunchAppTime)
     local alarmIndex = self:getAlarmIndex()
     self:connectAlarm(title,content,DISTINCTION_TIME_VALUE_PUSH,3,lunchAppTime,alarmIndex)
end

--[[
gameName:游戏名字   标题
matchName：比赛名字 内容
type：消息类型      3
configTime：提醒时间单位（type=1、2）分钟 type=3天   ""
lunchAppTime：闹钟提醒时间 单位毫秒                 time
alarmIndex：游戏标识                      index
]]
function alarmManager:connectAlarm(gameName, matchName, type, configTime, lunchAppTime, alarmIndex)
    JJLog.i(TAG, "alarmManager:connectAlarm.in.. ",gameName,matchName, type, configTime,lunchAppTime, alarmIndex,device.platform)
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "setAlarmClock"
        local args = { gameName, matchName, type, configTime, lunchAppTime, alarmIndex}
        local sig = "(Ljava/lang/String;Ljava/lang/String;IIII)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
end

function alarmManager:cancelMatchAlarm()
    JJLog.i(TAG, "alarmManager:cancelMatchAlarm ")
    
end

function alarmManager:getAlarmIndex()
    local index = 100
    local gameId = MainController:getCurGameId()
    if gameId == JJGameDefine.GAME_ID_HALL or gameId == JJGameDefine.GAME_ID_LORD_UNION or gameId == JJGameDefine.GAME_ID_LORD_UNION_HL or gameId == JJGameDefine.GAME_ID_LORD then
        index = 100
    elseif gameId == JJGameDefine.GAME_ID_POKER then
        index = 200
    elseif gameId == JJGameDefine.GAME_ID_MAHJONG then
        index = 300
    --elseif gameId == JJGameDefine.GAME_ID_LORD_HL then
    --    index = 400
    elseif gameId == JJGameDefine.GAME_ID_MAHJONG_TP then
        index = 500
    --elseif gameId == JJGameDefine.GAME_ID_LORD_PK then
    --    index = 600
    elseif gameId == JJGameDefine.GAME_ID_THREE_CARD then
        index = 700
    --elseif gameId == JJGameDefine.GAME_ID_LORD_LZ then
    --    index = 800
    end
    
    return index
end

return alarmManager
