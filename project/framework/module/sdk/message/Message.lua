
local Message = class("Message")

Message.type = 0 -- 消息类型，定义在 MsgDef.lua 中

function Message:ctor(msgType)
    self.type = msgType
end

return Message