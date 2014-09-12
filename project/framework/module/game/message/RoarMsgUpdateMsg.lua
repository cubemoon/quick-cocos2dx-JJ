-- 咆哮未读消息
local RoarMsgUpdateMsg = class("RoarMsgUpdateMsg", require("sdk.message.Message"))

RoarMsgUpdateMsg.result_ = false

function RoarMsgUpdateMsg:ctor(result)
    self.super.ctor(self, GameMsgDef.ID_ROAR_MSG_UPDATE_CHANGE)
    self.result_ = result
end

return RoarMsgUpdateMsg