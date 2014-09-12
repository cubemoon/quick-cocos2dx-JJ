
local JJViewGroup = require("sdk.ui.JJViewGroup")
local HelperBattery = class("HelperBattery", JJViewGroup)

function HelperBattery:ctor(parent)
    HelperBattery.super.ctor(self, {viewSize = CCSize(30, 15)})
    self.scene_ = parent
    self.dimens_ = parent.dimens_
    
    self:initView()
    self:registerBatteryReceiver()
end

function HelperBattery:initView()

    --图标
    self.icon = jj.ui.JJImage.new({
        image = "img/interim/ui/infobar_battery_bg.png",
        viewSize = CCSize(26, 13)
    })
    self.icon:setAnchorPoint(ccp(0,0))
    self:addView(self.icon)
    
    -- 电量
    self.percent = jj.ui.JJImage.new({
        image = "img/interim/ui/infobar_battery_progress.png",
        scale9 = true,
        viewSize = CCSize(19, 11)
    })
    self.percent:setAnchorPoint(ccp(0, 0))
    self.percent:setPosition(2, 1)
    self:addView(self.percent)
end

local function _update(self, state)
    if state ~= nil then
        local jsonTable = json.decode(state)
        if jsonTable ~= nil then
            if jsonTable.batterypercent then
                JJLog.i("lilc", "Battery : _update, jsonTable.batterypercent =", jsonTable.batterypercent)
                self.percent:setScaleX(self.dimens_.scale_ * (jsonTable.batterypercent / 100))
            end
            if jsonTable.batterystate then
            
            end
        end
    end
end

function HelperBattery:registerBatteryReceiver()
    Util:registerBatteryReceiver(handler(self, _update))
end

function HelperBattery:onExit()
    Util:unRegisterBatteryReceiver()
end

return HelperBattery