--[[
    到后台的消息
]]
local EnterBackgroundMessage = class("EnterBackgroundMessage", require("sdk.message.Message"))

function EnterBackgroundMessage:ctor()
    EnterBackgroundMessage.super.ctor(self, SDKMsgDef.TYPE_ENTER_BACKGROUND)
end

return EnterBackgroundMessage