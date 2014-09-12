--[[
系统时间
]]

local JJGameSysTime = class("JJGameSysTime",require("sdk.ui.JJViewGroup"))
local TAG = "JJGameSysTime"
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

function JJGameSysTime:ctor(parent)
    JJGameSysTime.super.ctor(self, {viewSize = CCSize(110, 24)})
    self.scene_ = parent
    self.dimens_ = parent.dimens_
    self.theme_ = parent.theme_

    self.lastMin = -1
    self:initView()
    self:updateTime()
end

function JJGameSysTime:unSchedule()
    if self.scheduleHandler_ then
        scheduler.unscheduleGlobal(self.scheduleHandler_)
        self.scheduleHandler_ = nil
    end
end

function JJGameSysTime:onEnter()
    self.scheduleHandler_ = scheduler.scheduleGlobal(function() self:updateTime() end, 1)
end

function JJGameSysTime:onExit()

    self.hour1 = nil
    self.hour2 = nil
    self.colon = nil
    self.min1 = nil
    self.min2 = nil
    
    self:unSchedule()
end

function JJGameSysTime:initView()

--    local numWidth, numHeight = self.dimens_:getDimens(14), self.dimens_:getDimens(19)
    local numWidth, numHeight = 14, 19

    --小时
    self.hour1 = jj.ui.JJImage.new({
        viewSize = CCSize(numWidth, numHeight),
    })
    self.hour1:setAnchorPoint(CCPoint(0, 0))
    self.hour1:setPosition(0, 0)
    self:addView(self.hour1)

    self.hour2 = jj.ui.JJImage.new({
        viewSize = CCSize(numWidth, numHeight),
    })
    self.hour2:setAnchorPoint(CCPoint(0, 0))
    self.hour2:setPosition(numWidth, 0)
    self:addView(self.hour2)

    --冒号
    self.colon = jj.ui.JJImage.new({
        viewSize = CCSize(numWidth, numHeight),
    })
    self.colon:setAnchorPoint(CCPoint(0, 0))
    self.colon:setPosition(2 * numWidth, 0)
    self:addView(self.colon)

    --分钟
    self.min1 = jj.ui.JJImage.new({
        viewSize = CCSize(numWidth, numHeight),
    })
    self.min1:setAnchorPoint(CCPoint(0, 0))
    self.min1:setPosition(3 * numWidth, 0)
    self:addView(self.min1)

    self.min2 = jj.ui.JJImage.new({
        viewSize = CCSize(numWidth, numHeight),
    })
    self.min2:setAnchorPoint(CCPoint(0, 0))
    self.min2:setPosition(4 * numWidth, 0)
    self:addView(self.min2)
end


function JJGameSysTime:updateTime()

    local date = os.date("*t",  JJTimeUtil:getCurrentSecond())
    local hour, min = date.hour, date.min

    if min ~= self.lastMin then
        self.lastMin = min
        local nHour1, nHour2 = math.modf(date.hour / 10), date.hour % 10
        if self.hour1 then self.hour1:setImage(self.theme_:getImage("time/time_" .. nHour1 .. ".png")) end
        if self.hour2 then self.hour2:setImage(self.theme_:getImage("time/time_" .. nHour2 .. ".png")) end

        if self.colon then self.colon:setImage(self.theme_:getImage("time/time_colon.png")) end

        local nMin1, nMin2 = math.modf(date.min / 10), date.min % 10
        if self.min1 then self.min1:setImage(self.theme_:getImage("time/time_" .. nMin1 .. ".png")) end
        if self.min2 then self.min2:setImage(self.theme_:getImage("time/time_" .. nMin2 .. ".png")) end
    end
end

return JJGameSysTime
