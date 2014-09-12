
local JJViewGroup = require("sdk.ui.JJViewGroup")
local Battery = class("Battery", JJViewGroup)

local function _update(self, state)
    --JJLog.i("linxh", "Battery : _update, state=", state)
    if Util:isAppActive() and state then
        local jsonTable = json.decode(state)
        if jsonTable and jsonTable.batterypercent then
            if jsonTable.batterypercent < 10 then
                if self.icon then
                    self.icon:setImage(self.theme_:getImage("battery/battery_bg_low.png"))
                end
                if self.percent then
                    self.percent:setVisible(false)
                end
            else
                if self.icon then
                    self.icon:setImage(self.theme_:getImage("battery/battery_bg.png"))
                end
                if self.percent then
                    self.percent:setVisible(true)
                    self.percent:setScaleX(jsonTable.batterypercent / 100)
                end
            end
        end
    end
end

function Battery:ctor(parent)
    Battery.super.ctor(self, {viewSize = CCSize(30, 15)})
    self.scene_ = parent
    self.dimens_ = parent.dimens_
    self.theme_ = parent.theme_
    
    self:initView()
    Util:registerBatteryReceiver(handler(self, _update))
end

function Battery:onExit()
    self.icon = nil
    self.percent = nil
    Util:unRegisterBatteryReceiver()
end


function Battery:initView()

    --图标
    self.icon = jj.ui.JJImage.new({
        image = self.theme_:getImage("battery/battery_bg.png"),
        viewSize = CCSize(26, 13)
    })
    self.icon:setAnchorPoint(ccp(0,0))
    self:addView(self.icon)
    
    -- 电量
    self.percent = jj.ui.JJImage.new({
        image = self.theme_:getImage("battery/battery_progress.png"),
        scale9 = true,
        viewSize = CCSize(19, 11)
    })
    self.percent:setAnchorPoint(ccp(0, 0))
    self.percent:setPosition(2, 1)
    self:addView(self.percent)
end

return Battery