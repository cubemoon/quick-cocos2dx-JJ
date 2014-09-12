--[[
    一些游戏的通用接口
]]
local JJGameUtil = class("JJGameUtil")
local TAG = "JJGameUtil"

require("game.def.JJGameDefine")

--[[
    获取游戏版本号
    @gameId：游戏 Id
    return:
        0: 无此游戏
]]
function JJGameUtil:getGameVersion(gameId)
    for k,v in pairs(JJGameDefine.GAME_DIR_TABLE) do
        if k == gameId then
			local config = LuaDataFile.get(string.format("module/%s/config.lua", v))
            if config ~= nil then
                return config.version_
            end
        end
    end

    return 0
end

--[[
    格式化开赛点为可显示字符串
    @matchpoint：游戏开赛点
    return: 格式化后的时间字符串
]]
function JJGameUtil:getMatchStartPointPrompt(matchpoint)
    local prompt = ""
    local now = JJTimeUtil:getCurrentServerTime()
    local time = matchpoint - (math.modf(now/1000))
    if matchpoint > 0 and time > 0 then
        local nMin = math.modf(time/60)
        if nMin > 0 then
            local nHour = math.modf(nMin/60)
            local nDay = math.modf(nHour/24)
            nMin = nMin - nHour * 60
            nHour = nHour - nDay * 24

            prompt = "比赛将在"
            --超过1天
            if nDay > 0 then
                prompt = prompt .. nDay .. "天"
            end
            if nHour > 0 then
                prompt = prompt .. nHour .. "小时"
            end
            if nMin > 0 then
                if math.fmod(time, 60) ~= 0 then
                    nMin = nMin+1
                end
                prompt = prompt .. nMin .. "分钟"
            end
            prompt = prompt .. "后开始！"
        else
            prompt = prompt .. "比赛即将开始！"
        end
    end

    return prompt
end

function JJGameUtil:getGameName(gameId, nojj)
    local name = "JJ游戏"
    if gameId == JJGameDefine.GAME_ID_HALL or gameId == JJGameDefine.GAME_ID_LORD_UNION or gameId == JJGameDefine.GAME_ID_LORD then
        name = "JJ斗地主"
    elseif gameId == JJGameDefine.GAME_ID_LORD_HL or gameId == JJGameDefine.GAME_ID_LORD_UNION_HL then
        name = "JJ欢乐斗地主"
    elseif gameId == JJGameDefine.GAME_ID_LORD_PK then
        name = "JJ血战斗地主"
    elseif gameId == JJGameDefine.GAME_ID_LORD_LZ then
        name = "JJ赖子斗地主"
    elseif gameId == JJGameDefine.GAME_ID_LORD_SINGLE then
        name = "JJ单机斗地主"
    elseif gameId == JJGameDefine.GAME_ID_MAHJONG then
        name = "JJ经典麻将"
    elseif gameId == JJGameDefine.GAME_ID_MAHJONG_TP then
        name = "JJ二人麻将"
    elseif gameId == JJGameDefine.GAME_ID_POKER then
        name = "JJ德州扑克"
    elseif gameId == JJGameDefine.GAME_ID_THREE_CARD then
        name = "JJ赢三张"
    elseif gameId == JJGameDefine.GAME_ID_MAHJONG_BR then
        name = "JJ血流成河"
    elseif gameId == JJGameDefine.GAME_ID_MAHJONG_SC then
        name = "JJ四川麻将"
    elseif gameId == JJGameDefine.GAME_ID_NIUNIU then
        name = "JJ牛牛"
    elseif gameId == JJGameDefine.GAME_ID_INTERIM then
        name = "JJ卡当"
    elseif gameId == JJGameDefine.GAME_ID_RUNFAST then
        name = "JJ跑得快"
    end

    if nojj then name = string.sub(name, 3) end
    return name
end

function JJGameUtil:changeToHall()
    JJLog.i(TAG, "changeToHall")
    local save = CCUserDefault:sharedUserDefault()
    local show = save:getBoolForKey("show_hall", false)
    JJLog.i(TAG, "changeToHall, show=", show)
    if not show then
        save:setBoolForKey("show_hall", true)
        -- 判断如果是单包变大厅，清空game_uptime时间戳
        if ORIGINAL_PACKAGE_ID ~= JJGameDefine.GAME_ID_HALL then
            save:setStringForKey("game_uptime", "0")
        end
        save:flush()
    end
end

-- 检查是否转换为大厅模式
function JJGameUtil:checkChangeToHall()
    JJLog.i(TAG, "checkChangeToHall")
    local ret = false
    local save = CCUserDefault:sharedUserDefault()
    local show = save:getBoolForKey("show_hall", false)
    if not show then
        JJLog.i(TAG, "checkChangeToHall, getMustHall=", GlobalConfigManager:getMustHall(CURRENT_PACKAGE_ID))
        JJLog.i(TAG, "checkChangeToHall, show=", GlobalConfigManager:getShowLuaHall(CURRENT_PACKAGE_ID), ", loginTImes=", JJAnalytics:getLoginTimes(), ", signupTimes=", JJAnalytics:getSignupTimes(), ", maxScore=", UserInfo:getMaxScore())
        if GlobalConfigManager:getMustHall(CURRENT_PACKAGE_ID) then        
            self:changeToHall()
            ret = true

        elseif GlobalConfigManager:getShowLuaHall(CURRENT_PACKAGE_ID) then

            if JJAnalytics:getLoginTimes() >= 200 and JJAnalytics:getSignupTimes() >= 400 and UserInfo:getMaxScore() >= 100000 then
                self:changeToHall()
                ret = true
            end
        end
    end

    return ret
end

function JJGameUtil:exit()
    --退出设置闹钟
    local alarmManager = require("game.alarm.JJAlarmManager")
    alarmManager:setMatchAlarm()
    --退出设置推送消息和内置消息提醒
    local pushManager = require("game.alarm.JJPushManager")
    local pushData = require("game.data.push.PushData")
    pushManager:schedule()

    local notifyManager = require("game.alarm.JJNotificationManager")
    notifyManager:cancelNotification()

    self:checkChangeToHall()
end

--[[xinxy
    格式化数字 支持正负数
    num 是要格式化的数字
    separate 是分隔符
    bitnum是 分隔位数
    例如：local str = formatnum(-12454646123, ':', 4) 返回 -124:5464:6123
]]
function JJGameUtil:formatnum(num, separate, bitnum)
    local negative = false
    if num < 0 then
        negative = true
    end
    num = math.abs(num)
    local isrightparam = true
    if separate==nil or bitnum==nil or bitnum<0 then
        isrightparam = false
    end
    local order = {}
    local count = 0
    while (num > 0) do
        local individual = math.mod(num, 10)
        table.insert(order, individual)
        count = count + 1
        num = math.floor(num / 10)
        if math.mod(count, bitnum)==0 and num>0 and isrightparam==true then
            table.insert(order, separate)
        end
    end

    local neworder = {}
    for i=#order, 1, -1 do
        table.insert(neworder, order[i])
    end

    local str = ""
    if negative then
        str = "-"
    end
    for i=1, #neworder do
        str = str .. neworder[i]
    end

    return str
end

function JJGameUtil:luaGameExist(gameId)
    local pkgId = gameId
    -- TODO 判断所传的gameId是否存在斗地主合集中
    local lordunions = { JJGameDefine.GAME_ID_LORD, JJGameDefine.GAME_ID_LORD_LZ, JJGameDefine.GAME_ID_LORD_HL, JJGameDefine.GAME_ID_LORD_PK, JJGameDefine.GAME_ID_LORD_SINGLE }
    for i=1,#lordunions do
        if gameId == lordunions[i] then
            pkgId = JJGameDefine.GAME_ID_LORD_UNION
        end
    end
    local packageName = tostring(JJGameDefine.GAME_DIR_TABLE[pkgId])
    local fileUtil = require("upgrade.util.UpgradeUtil")
    local exist = fileUtil:exist(packageName .. "/config.lua")
    return exist
end

--[[
    关于界面是否允许外链
    @promoterId: 渠道号
    @return: 是否允许外链
]]
function JJGameUtil:isAboutUrlLink(promoterId)
    local ret = false
    if promoterId == 30000 then
        ret = true
    end

    return ret
end

--[[
    判断是否为 Hao123 渠道
    @promoterId: 渠道号
    @return: 是否 Hao123 渠道
]]
function JJGameUtil:isHao123(promoterId)
    local ret = false
    if promoterId == 35052 or promoterId == 50229 or promoterId == 38299 or promoterId == 38192 or promoterId == 38200 or promoterId == 50538 or promoterId == 38282 or promoterId == 38277 or promoterId == 38154 or promoterId == 50428 or promoterId == 38003 or promoterId == 38208 or promoterId == 35061 or promoterId == 35019 or promoterId == 35041 then
        ret = true
    end

    return ret
end

--[[
    判断设置中是否能显示分享
    @promoterId: 渠道号
    @return: 是否能显示
]]
function JJGameUtil:allowShareInSetting(promoterId)
    local ret = true
    if promoterId == 35019 or (promoterId >= 35030 and promoterId <= 35039) or promoterId == 35134 or promoterId == 35108 or promoterId == 35120 or promoterId == 35109 or promoterId == 35111 or promoterId == 50655 or promoterId == 35160 or promoterId == 50694 or promoterId == 50720 or promoterId == 50721 or promoterId == 50722 then
        ret = false
    end
    return ret
end

return JJGameUtil
