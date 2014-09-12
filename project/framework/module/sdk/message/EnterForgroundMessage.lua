--[[
    到后台的消息
]]
local EnterForgroundMessage = class("EnterForgroundMessage", require("sdk.message.Message"))

function EnterForgroundMessage:ctor()
    EnterForgroundMessage.super.ctor(self, SDKMsgDef.TYPE_ENTER_FORGROUND)
end

return EnterForgroundMessage