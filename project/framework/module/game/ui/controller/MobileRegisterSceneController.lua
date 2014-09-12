local MobileRegisterSecenController = class("MobileRegisterSecenController", require("game.ui.controller.JJGameSceneController"))
local TAG = "MobileRegisterSecenController"

require("game.controller.RegisterController")

MobileRegisterSecenController.loginDialog_ = nil -- 登录等待框
local UIUtil = require("game.ui.UIUtil")

-- 内部函数
local _handleURSSendRegSMSCodeAck
local _handleMobileRegisterAck
local _handleNoRegBindMobileAccAck
local _handleVerifyLoginNameExistAck
--local _showSuccessDialog

-- 内部变量
--local self.mobilenumber_ = nil
--local self.password_ = nil
--local self.regSuccessDialogShow = false

--[[
    参数
    @params:
        @packageId
]]
function MobileRegisterSecenController:ctor(controllerName, sceneName, theme, dimens, params)
    MobileRegisterSecenController.super.ctor(self, controllerName, sceneName, theme, dimens, params)
    self:setResumeRedraw(false)

    if not MainController:isConnected() then
        MainController:startConnect(false)
    end

    self.mobilenumber_ = nil
    self.password_ = nil
    self.regSuccessDialogShow = false
end

function MobileRegisterSecenController:handleMsg(msg)
    MobileRegisterSecenController.super.handleMsg(self, msg)
    if msg.type == SDKMsgDef.TYPE_NET_STATE and msg.state == kJJSocketRequestStateConnected then
        if self.codeData_ == nil then
            LobbyMsg:sendAnonymouseBrowseReq()
        end

    elseif msg[MSG_CATEGORY] == LOBBY_ACK_MSG then

        -- 短信验证码消息
        if msg[MSG_TYPE] == SEND_REGSMSCODE_ACK then
            JJLog.i(TAG, "SEND_REGSMSCODE_ACK")
            _handleURSSendRegSMSCodeAck(self, msg)

        elseif msg[MSG_TYPE] == MOBILE_REGISTER_ACK then
            JJLog.i(TAG, "MOBILE_REGISTER_ACK")
            _handleMobileRegisterAck(self, msg)

        elseif msg[MSG_TYPE] == NOREGBIND_MOBILEACC_ACK then
            JJLog.i(TAG, "NOREGBIND_MOBILEACC_ACK")
            _handleNoRegBindMobileAccAck(self, msg)
        
        elseif msg[MSG_TYPE] == VERIFY_LOGINNAMEEXIST_ACK then
            JJLog.i(TAG, "VERIFY_LOGINNAMEEXIST_ACK")
            _handleVerifyLoginNameExistAck(self, msg)

        elseif msg[MSG_TYPE] == GENERAL_LOGIN_ACK then
            if msg.param == 0 then
                self:onLoginSuccess()
            else
                self:onLoginFailed(msg.param)
            end
        end
    end
end

function MobileRegisterSecenController:showSuccessDialog()
--_showSuccessDialog = function(self)
    self.regSuccessDialogShow = true
    local function _dismissCB()
        JJLog.i(TAG, "_dismissCB")
        self.successDialog_ = nil
        self.regSuccessDialogShow = false
    end

    local function _btn1CB()
        JJLog.i(TAG, "_btn1CB")

        self.loginDialog_ = UIUtil.showLoginDialog(self.scene_, self.theme_, self.dimens_, function() self.loginDialog_ = nil end)

        LoginController:setLoginParam(LOGIN_TYPE_JJ, self.mobilenumber_, self.password_)
        LoginController:startLogin()
    end

    local dialog = require("game.ui.view.AlertDialog").new({
        title = "注册成功",
        prompt = "您的帐号是：" .. self.mobilenumber_ .. "\r\n" .. "密码是：" .. self.password_ .. "\r\n请牢记您的帐号和密码，通过JJ帐号登录就可以畅玩JJ比赛所有游戏哦。",
        onDismissListener = _dismissCB,
        theme = self.theme_,
        dimens = self.dimens_,
        promptFontSize = 20,
    })

    dialog:setButton1("现在登录", _btn1CB)
    dialog:setCanceledOnTouchOutside(false)

    self.successDialog_ = dialog
    JJCloseIMEKeyboard()
    dialog:show(self.scene_)

    return dialog
end

function MobileRegisterSecenController:showToast(txt)
    jj.ui.JJToast:show({ text = txt, dimens = self.dimens_ })
end

_handleURSSendRegSMSCodeAck = function(self, msg)
    JJLog.i(TAG, "_handleURSSendRegSMSCodeAck", msg.param)

    local promotStr = RegisterController:getMobileSMSPrompt(msg.param)

    if (msg.param ~= 0) then --获取失败恢复获取按钮
        self.scene_:StopTimerAndEnable()
    end

    self:showToast(promotStr)
end

_handleMobileRegisterAck = function(self, msg)
    JJLog.i(TAG, "_handleMobileRegisterAck", msg.param)
    local ack = msg.lobby_ack_msg.mobileregister_ack_msg

    if msg.param == 0 then
        --self:showToast("注册成功，昵称：" .. ack.nickname)

        RegisterController:SaveAccountAfterSuccess(self.mobilenumber_, self.password_)
        self.scene_:clearBeforeInput()
        self:showSuccessDialog()
    else

        local promptStr = {}
        promptStr[10] = "手机号已存在"
        promptStr[11] = "昵称已存在"
        promptStr[12] = "手机号非法"
        promptStr[13] = "昵称错误"
        promptStr[14] = "密码错误"
        promptStr[15] = "验证码错误"
        promptStr[16] = "昵称非法"
        promptStr[17] = "免注册账户已经注册"
        promptStr[18] = "验证码失效"
        promptStr[200] = "客户端签名错误"
        promptStr[201] = "合作方认证失败"

        local prompt = promptStr[msg.param]
        if prompt == nil then
            prompt = "注册失败（" .. msg.param .. "）"
        end
        self:showToast(prompt)
    end
end

_handleNoRegBindMobileAccAck = function(self, msg)
    JJLog.i(TAG, "_handleNoRegBindMobileAccAck")
    --local ack = msg.lobby_ack_msg.noregbindmobileacc_req_msg

    if msg.param == 0 then
        --self:showToast("您的账户金币和所有物品会继续保留，\r\n登录时选择您的JJ手机帐号即可。")

        RegisterController:SaveAccountAfterSuccess(self.mobilenumber_, self.password_)
        self.scene_:clearBeforeInput()

        --        绑定成功，这个手机可以生成一个新的免登陆帐号了，所以清除掉之前的数据
        Settings:setNoRegGoldPrompt(false)
        Settings:setNoRegLoginCount(0)
        self:showSuccessDialog()

    else
        self:showToast("绑定失败，请稍后重试！")
    end
end

_handleVerifyLoginNameExistAck = function(self, msg)
    JJLog.i(TAG, "_handleVerifyLoginNameAck")
    local ack = msg.lobby_ack_msg.verifyloginnameexist_ack_msg  
    JJLog.i(TAG, "_handleVerifyLoginNameAck",ack.loginname, ack.param, ack.acctype)  
    self.scene_:verifyLoginnameExist(ack.loginname, ack.param, ack.acctype)
end

function MobileRegisterSecenController:onClickMobileRegister(mobile, password, code)
    JJLog.i(TAG, "onClickMobileRegister")

    local function checkCode(code)
        JJLog.i(TAG, "checkCode")
        local ret = false
        local len = string.len(code)
        local num = tonumber(code)

        if len == 4 and num then
            ret = true
        else
            JJLog.i(TAG, "checkCode, ERR")
            self:showToast("请输入正确的验证码")
        end

        return ret
    end

    if mobile == "" then
        self:showToast("手机号不能为空")
        return
    end

    if (not RegisterController:isMobileNumber(mobile)) then
        self:showToast("请输入正确的手机号")
        return
    end

    local valid, prompt = RegisterController:checkOnePassword(password, true)
    if (not valid) then
        self:showToast(prompt)
        return
    end
 

    if checkCode(code) then
        self.mobilenumber_ = mobile
        self.password_ = password

        if LoginController.type_ == LOGIN_TYPE_NOREG then
            LobbyMsg:SendNoRegBindMobileAccReq(mobile, nil, password, code, LoginController.specCode_)
        else

            LobbyMsg:sendMobileRegisterReq(mobile, nil, password, code)
        end
    end
end

-- 点击验证码，请求重新获取
function MobileRegisterSecenController:onClickGetSmsCode(mobile)
    JJLog.i(TAG, "onClickGetSmsCode")

    local send = RegisterController:isMobileNumber(mobile)
    if (send) then
        LobbyMsg:sendURSSendRegSMSCodeReq(0, mobile, 2)
    else
        self:showToast("请输入正确的手机号")
    end

    return send
end

-- 点击验证码帮助提示
function MobileRegisterSecenController:onClickGetSmsPrompt()
    JJLog.i(TAG, "onClickGetSmsCode")
    self:showToast(" 短信可能会有延迟，请耐心等待，\r\n如果您长时间没有收到短信，请点击“重新获取确认码”。\r\n智能手机可能会拦截该短信，请在您手机的拦截记录里查找")
end

--[[
    登录成功
]]
function MobileRegisterSecenController:onLoginSuccess()
    JJLog.i(TAG, "onLoginSuccess")
    UIUtil.dismissDialog(self.loginDialog_)
    
    if CURRENT_PACKAGE_ID == JJGameDefine.GAME_ID_HALL then
        MainController:changeToScene(CURRENT_PACKAGE_ID, JJSceneDef.ID_LOBBY)
    else
        MainController:changeToScene(self.params_.packageId, JJSceneDef.ID_ORIGINAL)
    end
end

--[[
    登录失败
]]
function MobileRegisterSecenController:onLoginFailed(param)
    JJLog.i(TAG, "onLoginFailed")
    UIUtil.dismissDialog(self.loginDialog_)
    UIUtil.showLoginFailed(param, self.dimens_)
end

function MobileRegisterSecenController:resumeDisplay()
    JJLog.i(TAG, "resumeDisplay")
    if (self.regSuccessDialogShow) then
        self:showSuccessDialog()
    end
end

return MobileRegisterSecenController