-- 登录结果消息
local LoginResultMsg = class("LoginResultMsg", require("sdk.message.Message"))

LoginResultMsg.result_ = false

function LoginResultMsg:ctor(result)
    self.super.ctor(self, GameMsgDef.ID_LOGIN_RESULT)
    self.result_ = result
end

return LoginResultMsg