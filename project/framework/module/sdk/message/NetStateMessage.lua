--[[
    网络状态消息
]]
local NetStateMessage = class("NetStateMessage", require("sdk.message.Message"))

NetStateMessage.state = 0

function NetStateMessage:ctor(state)
    NetStateMessage.super.ctor(self, SDKMsgDef.TYPE_NET_STATE)
    self.state = state
end

return NetStateMessage