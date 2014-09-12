
local JJViewGroup = require("sdk.ui.JJViewGroup")
local SignalStrength = class("SignalStrength", JJViewGroup)

local TYPE_WIFI = 0
local TYPE_MOBILE = 1

local function _update(self, state)
    --JJLog.i("lilc", "SignalStrength : _update, state=", state)
    if state ~= nil then
        local jsonTable = json.decode(state)
        if jsonTable ~= nil then
            if jsonTable.connecttype then
                self.type = jsonTable.connecttype
            end
            if jsonTable.WIFIstrength then
                self.strength = jsonTable.WIFIstrength
            end
            if jsonTable.gsmstrength then
                self.strength = jsonTable.gsmstrength
            end
            self:updateView()
        end
    end
end

function SignalStrength:ctor(parent)
    SignalStrength.super.ctor(self, {viewSize = CCSize(36, 22)})
    self.scene_ = parent
    self.dimens_ = parent.dimens_
    self.theme_ = parent.theme_

    self:initView()
    Util:registerConnectivity(handler(self, _update))
end

function SignalStrength:onExit()
    self.icon = nil
    Util:unRegisterConnectivity()
end

function SignalStrength:initView()

    local img = self.theme_:getImage("signal/signal_connectivity_none.png")
    local type = Util:getNetworkType()
    if type == 1 then -- WIFI
        img = self.theme_:getImage("signal/signal_wifi_strength_3.png") --123
    elseif type == 2 then
        img = self.theme_:getImage("signal/signal_gprs_strength_4.png") --1234
    end
    --图标
    self.icon = jj.ui.JJImage.new({
        image = img,
        viewSize = CCSize(26, 13)
    })
    self.icon:setAnchorPoint(ccp(0,0))
    self:addView(self.icon)
end

function SignalStrength:updateView()
    if Util:isAppActive() then
        local res = self.theme_:getImage("signal/signal_connectivity_none.png")
        if self.type == TYPE_WIFI then --[-100,-75),[-75,-50),[-50,0]
            if self.strength < -75 then
                res = self.theme_:getImage("signal/signal_wifi_strength_1.png")
            elseif self.strength >= - 75 and self.strength < -50 then
                res = self.theme_:getImage("signal/signal_wifi_strength_2.png")
            elseif self.strength >= -50 then
                res = self.theme_:getImage("signal/signal_wifi_strength_3.png")
            end
        elseif self.type == TYPE_MOBILE then --[0-8),[8,16),[16,24),[24,31]
            if self.strength < 8 then
                res = self.theme_:getImage("signal/signal_gprs_strength_1.png")
            elseif self.strength >= 8 and self.strength < 16 then
                res = self.theme_:getImage("signal/signal_gprs_strength_2.png")
            elseif self.strength >= 16 and self.strength <= 24 then
                res = self.theme_:getImage("signal/signal_gprs_strength_3.png")
            elseif self.strength >= 24 then
                res = self.theme_:getImage("signal/signal_gprs_strength_4.png")
            end
        end
        if self.icon then
            self.icon:setImage(res)
        end
    end
end

return SignalStrength