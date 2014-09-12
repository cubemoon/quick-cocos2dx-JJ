-- 由于服务器时间和本地时间有差值，使用这个来同步为服务器时间
JJTimeUtil = {}

local offset = 0 -- 和服务器时间的差值

-- 设置服务器时间
function JJTimeUtil:setServerTime(serverTime)
    local curTick = getCurrentMillis()
    offset = curTick - (serverTime * 1000)
end

-- 获取同步后的当前时间
function JJTimeUtil:getCurrentServerTime()
    local curTick = getCurrentMillis()
    return (curTick - offset)
end

--获取同步后当前时间用秒表示
function JJTimeUtil:getCurrentSecond()
    local curSecond = getCurrentSecond()
    if offset ~= 0 then
        curSecond = self:getCurrentServerTime() / 1000
    end
    return curSecond
end

function JJTimeUtil:getTimeString(value)
    local sysdate = os.date("*t", os.time())
    local date = os.date("*t", value)

    local str = ""

    -- if sysdate.year ~= date.year then
    --     str = str .. date.year .. "年"
    -- end

    if string.len(str) == 0 then
        if sysdate.month ~= date.month then
            str = str .. date.month .. "月"
        end
    else
        str = str .. date.month .. "月"
    end

    if string.len(str) == 0 then
        local delta = date.day - sysdate.day
        if delta == 1 then
            str = str .. "明天"
        elseif delta == 2 then
            str = str .. "后天"
        elseif delta == -1 then
            str = str .. "昨天"
        elseif delta == -2 then
            str = str .. "前天"
        elseif delta ~= 0 then
            str = str .. date.day .. "日"
        end
    else
        str = str .. date.day .. "日"
    end

    if string.len(str) > 0 then
        str = str .. " "
    end

    if date.hour < 10 then
        str = str .. "0"
    end

    str = str .. date.hour .. ":"

    if date.min < 10 then
        str = str .. "0"
    end

    str = str .. date.min

    return str
end

--获取年月日的date string，格式XXXX-XX-XX
function JJTimeUtil:formatDateString(sec)
    local date = os.date("*t", sec)

    local str = string.format("%04d-%02d-%02d", date.year, date.month, date.day)

    return str
end

--获取年月日时分秒的date time string，格式XXXX-XX-XX XX:XX:XX
function JJTimeUtil:formatDateTimeString(sec)
    local date = os.date("*t", sec)

    local str = string.format("%04d-%02d-%02d %02d:%02d:%02d", date.year, date.month, date.day, date.hour, date.min, date.sec)

    return str
end

function JJTimeUtil:formatDateTimeStringMillis(ms)
    return self:formatDateTimeString(ms / 1000)
end

-- 获取同步后的当前时间
function JJTimeUtil:getCurrentServerDateString()
    local curSec = self:getCurrentSecond()

    return self:formatDateString(curSec)
end

--[[格式：00:00:00]]
function JJTimeUtil:formatTimeString(Sec)
    local str = ""
    if Sec > 0 then
        --获取时间
        local nHour = math.modf(Sec / 3600)
        local nMin = math.modf((Sec - nHour * 3600) / 60)
        local nSec = Sec - nHour * 3600 - nMin * 60

        --小时
        if nHour < 10 then
            str = str .. "0"
        end
        str = str .. tostring(nHour) .. ":"
        -- 分钟
        if nMin < 10 then
            str = str .. "0"
        end
        str = str .. tostring(nMin) .. ":"


        --秒
        if nSec < 10 then
            str = str .. "0"
        end
        str = str .. tostring(nSec)
    end

    return str
end

--将windows system时间转换为CRT时间 1601.1.1 -> 1970.1.1
function JJTimeUtil:SYSTEMtime2CRTtime(ns)
    local CRTtm = ns/10000000 - (369 * 365 * 24 * 3600) - ((75+15) * 24 * 3600) + (16 * 3600)
    return CRTtm
end