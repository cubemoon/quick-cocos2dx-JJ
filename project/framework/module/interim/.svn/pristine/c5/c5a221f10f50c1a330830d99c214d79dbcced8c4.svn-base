
local JJViewGroup = require("sdk.ui.JJViewGroup")
local HelperSignal = class("HelperSignal", JJViewGroup)

local TYPE_WIFI = 0
local TYPE_MOBILE = 1

function HelperSignal:ctor(parent)
    HelperSignal.super.ctor(self, {viewSize = CCSize(36, 22)})
    self.scene_ = parent
    self.dimens_ = parent.dimens_

    self:initView()
    self:registerConnectivity()
end

function HelperSignal:initView()

    local img
    local type = Util:getNetworkType()
    if type == 1 then -- WIFI
        img = "img/interim/ui/infobar_wifi_strength_3.png" --123
    elseif type == 2 then
        img = "img/interim/ui/infobar_gprs_strength_4.png" --1234
    end
    --图标
    self.icon = jj.ui.JJImage.new({
        image = img,
        viewSize = CCSize(26, 13)
    })
    self.icon:setAnchorPoint(ccp(0,0))
    self:addView(self.icon)
end

local function _update(self, state)
    JJLog.i("lilc", "HelperSignal : _update, state=", state)
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

function HelperSignal:registerConnectivity()
    Util:registerConnectivity(handler(self, _update))
end

function HelperSignal:updateView()
    local res
    if self.type == TYPE_WIFI then --[-100,-75),[-75,-50),[-50,0]
        if self.strength < -75 then
            res = "img/interim/ui/infobar_wifi_strength_1.png"
    elseif self.strength >= - 75 and self.strength < -50 then
        res = "img/interim/ui/infobar_wifi_strength_2.png"
    elseif self.strength >= -50 then
        res = "img/interim/ui/infobar_wifi_strength_3.png"
    end
    elseif self.type == TYPE_MOBILE then --[0-8),[8,16),[16,24),[24,31]
        if self.strength < 8 then
            res = "img/interim/ui/infobar_gprs_strength_1.png"
    elseif self.strength >= 8 and self.strength < 16 then
        res = "img/interim/ui/infobar_gprs_strength_2.png"
    elseif self.strength >= 16 and self.strength <= 24 then
        res = "img/interim/ui/infobar_gprs_strength_3.png"
    elseif self.strength >= 24 then
        res = "img/interim/ui/infobar_gprs_strength_4.png"
    end
    end
    self.icon:setImage(res)
end

function HelperSignal:onExit()
    Util:registerConnectivity()
end

return HelperSignal