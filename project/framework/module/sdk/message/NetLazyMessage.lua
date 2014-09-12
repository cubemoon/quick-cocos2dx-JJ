--[[
    网络卡消息
]]
local NetLazyMessage = class("NetLazyMessage", require("sdk.message.Message"))

function NetLazyMessage:ctor()
    NetLazyMessage.super.ctor(self, SDKMsgDef.TYPE_NET_LAZY)
end

return NetLazyMessage