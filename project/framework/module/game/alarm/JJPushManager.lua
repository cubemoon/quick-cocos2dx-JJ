-- 设置通知栏提醒Manager
local PushManager = {}
local TAG = "JJNotificationManager"
local PushData = require("game.data.push.PushData")

function PushManager:schedule()
    self:cancelNotification()
    PushData:checkInvalid()
    local ticklist = PushData:getAllDatasTable()
    local time = math.floor(JJTimeUtil:getCurrentServerTime() / 1000)    

    if ticklist ~= nil and #ticklist > 0  then
        JJLog.i(TAG, "PushManager#ticklist33 = ", #ticklist)
        for i,tick in ipairs(ticklist) do
            if tick ~= 0 and tick > time then
                local type,data = PushData:getPushItem(tick)
                JJLog.i(TAG, "PushManager#timeLine = ", data.timeLine)                
               
                local timeline = 0
                if type == PushData.TYPE_AD then
                    timeline = math.floor(data.timeLine - time) * 1000
                else
                    timeline = data.timeLine * 1000
                end
                JJLog.i("PushManager5555555--------------------",timeline,time,tick,type,data.title,data.content,data.timeLine)       
                self:setNotification(data,timeline)
            end
        end       
    end
end

function PushManager:setNotification(table,timeline) 
    local JJGameUtil = require("game.util.JJGameUtil")
    local gameName = JJGameUtil:getGameName(MainController:getCurGameId())
    local alarmIndex = 1
    local curServerTime = JJTimeUtil:getCurrentServerTime()
    local lastLunchTime = 0    
    local alarmManager = require("game.alarm.JJAlarmManager")
    alarmManager:setPushAlarm(table.title,table.content,timeline)
end

function PushManager:cancelNotification()
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "cancelNotification"
        local args = {}
        local sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
end

return PushManager
