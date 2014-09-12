-- 设置通知栏提醒Manager
local notifyManager = {}

local TAG = "JJNotificationManager"

notifyManager.NOTIFICATION_TYPE_START_CLIENT = 1
notifyManager.NOTIFICATION_TYPE_BEGIN_HANDLE = 2
notifyManager.NOTIFICATION_TYPE_YOUR_TURN = 3
notifyManager.NOTIFICATION_TYPE_SHOW_WHEN_HOME_KEY = 4
notifyManager.NOTIFICATION_TYPE_GAME_OVER = 5
notifyManager.NOTIFICATION_TYPE_PUSH = 6 --推送消息
notifyManager.NOTIFICATION_TYPE_TWO_MINUTE_REMIND = 7 --比赛前2分钟通知栏提醒

function notifyManager:setNotification(type)
    JJLog.i(TAG, "notifyManager:notification.in.. ", type)
    local tickerText,strContent
    
    if type == notifyManager.NOTIFICATION_TYPE_SHOW_WHEN_HOME_KEY then
        tickerText = JJGameUtil:getGameName(MainController:getCurGameId())
        strContent = ""
    elseif type == notifyManager.NOTIFICATION_TYPE_YOUR_TURN then
        strContent = "轮到您了，请赶快进入，精彩继续..."
    elseif type == notifyManager.NOTIFICATION_TYPE_GAME_OVER then
        strContent = "比赛已经结束..."
    elseif type == notifyManager.NOTIFICATION_TYPE_START_CLIENT then
        strContent = "比赛已经开始..."
    end
    
    self:setNotificationByContent(type, tickerText, strContent)
end

function notifyManager:setNotificationByContent(type, title, content)
    JJLog.i(TAG, "notifyManager:setNotificationByContent.in.. ",type,title, content)
    title = title or "JJ比赛提示"
    content = content or "比赛开始了，请赶快进入，精彩马上开始..."
    
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "setNotification"
        local args = { type, title, content}
        local sig = "(ILjava/lang/String;Ljava/lang/String;)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
end

function notifyManager:cancelNotification()
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "cancelNotification"
        local args = {}
        local sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
end

return notifyManager
