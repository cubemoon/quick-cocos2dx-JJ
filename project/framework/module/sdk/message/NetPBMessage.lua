--[[
    网络消息
]]
local NetPBMessage = class("NetPBMessage", require("sdk.message.Message"))

NetPBMessage.gameId = 0
NetPBMessage.buf = nil
NetPBMessage.len = 0

function NetPBMessage:ctor(gameId, buf, len)
    NetPBMessage.super.ctor(self, SDKMsgDef.TYPE_NET_MSG)
    self.gameId = gameId
    self.buf = buf
    self.len = len
end

return NetPBMessage