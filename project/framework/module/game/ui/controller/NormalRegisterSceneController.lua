local NormalRegisterSceneController = class("NormalRegisterSceneController", require("game.ui.controller.JJGameSceneController"))
local TAG = "NormalRegisterSceneController"

require("game.controller.RegisterController")

NormalRegisterSceneController.loginDialog_ = nil -- 登录等待框
local UIUtil = require("game.ui.UIUtil")

-- 内部函数
local _handleGetVerifyCodeAck
local _handleRegisterAck
local _handleNoRegBindDefaultAccAck
local _handleVerifyLoginNameAck
local _showSuccessDialog

local _setCodeImage
-- 内部函数

--local self.timefound_ = nil -- 验证码的时间
--local self.username_ = nil
--local self.password_ = nil
--local self.regSuccessDialogShow = false

--[[
    参数
    @params:
        @packageId
]]
function NormalRegisterSceneController:ctor(controllerName, sceneName, theme, dimens, params)
    NormalRegisterSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, params)
    self:setResumeRedraw(false)

    self.timefound_ = nil
    self.username_ = nil
    self.password_ = nil
    self.regSuccessDialogShow = false
end

function NormalRegisterSceneController:handleMsg(msg)
    NormalRegisterSceneController.super.handleMsg(self, msg)
    if msg.type == SDKMsgDef.TYPE_NET_STATE and msg.state == kJJSocketRequestStateConnected then
        if self.codeData_ == nil then
            LobbyMsg:sendAnonymouseBrowseReq()
            self:onClickVerifyCode()
        end

    elseif msg[MSG_CATEGORY] == LOBBY_ACK_MSG then
        -- 验证码消息
        JJLog.i(TAG, "NormalRegisterSceneControllerhandleMsg", msg[MSG_TYPE])

        if msg[MSG_TYPE] == GET_VERIFY_CODE_ACK then
            JJLog.i(TAG, "GET_VERIFY_CODE_ACK")
            _handleGetVerifyCodeAck(self, msg)

        elseif msg[MSG_TYPE] == REGISTER_ACK then
            JJLog.i(TAG, "REGISTER_ACK")
            _handleRegisterAck(self, msg)

        elseif msg[MSG_TYPE] == NOREGBIND_DEFAULTACC_ACK then
            JJLog.i(TAG, "NOREGBIND_DEFAULTACC_ACK")
            _handleNoRegBindDefaultAccAck(self, msg)

        elseif msg[MSG_TYPE] == VERIFY_LOGINNAME_ACK then
            JJLog.i(TAG, "VERIFY_LOGINNAME_ACK")
            _handleVerifyLoginNameAck(self, msg)

        elseif msg[MSG_TYPE] == GENERAL_LOGIN_ACK then
            if msg.param == 0 then
                self:onLoginSuccess()
            else
                self:onLoginFailed(msg.param)
            end
        end
    end
end

function NormalRegisterSceneController:onBackPressed()
    if self.successDialog_ then
        --UIUtil.dismissDialog(self.successDialog_)
        --self.successDialog_ = nil
    else
        NormalRegisterSceneController.super.onBackPressed(self)
    end
end

function NormalRegisterSceneController:showSuccessDialog()
--_showSuccessDialog = function(self)
    self.regSuccessDialogShow = true
    JJLog.i(TAG, "showSuccessDialog12")
    local function _dismissCB()
        JJLog.i(TAG, "_dismissCB")
        self.successDialog_ = nil
    end

    local function _btn1CB()
        JJLog.i(TAG, "_btn1CB")
        self.regSuccessDialogShow = false
        self.loginDialog_ = UIUtil.showLoginDialog(self.scene_, self.theme_, self.dimens_, function() self.loginDialog_ = nil end)

        LoginController:setLoginParam(LOGIN_TYPE_JJ, self.username_, self.password_)
        LoginController:startLogin()
    end

    local dialog = require("game.ui.view.AlertDialog").new({
        title = "注册成功",
        prompt = "您的帐号是：" .. self.username_ .. "\r\n" .. "密码是：" .. self.password_ .. "\r\n请牢记您的帐号和密码，通过JJ帐号登录就可以畅玩JJ比赛所有游戏哦。",
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

_handleGetVerifyCodeAck = function(self, msg)
    JJLog.i(TAG, "_handleGetVerifyCodeAck")
    local ack = msg.lobby_ack_msg.getverifycode_ack_msg
    self.timefound_ = ack.timefound
    JJFileUtil:writeFile("cache/code.bmp", ack.verifycode)
    local path = JJFileUtil:getFullPath("cache/code.bmp")
    _setCodeImage(self, path)
end

function NormalRegisterSceneController:showToast(txt)
    jj.ui.JJToast:show({ text = txt, dimens = self.dimens_ })
end

function NormalRegisterSceneController:getFailPrompt(code)
    local promptStr = {}
    promptStr[10] = "用户名已存在"
    promptStr[11] = "昵称已存在"
    promptStr[12] = "登录名错误"
    promptStr[13] = "昵称错误"
    promptStr[14] = "密码错误"
    promptStr[15] = "验证码错误"
    promptStr[16] = "昵称非法"
    promptStr[17] = "免注册账户已经注册"
    promptStr[18] = "验证码失效"
    promptStr[200] = "客户端签名错误"
    promptStr[201] = "合作方认证失败"

    local prompt = promptStr[code]
    return prompt
end

_handleNoRegBindDefaultAccAck = function(self, msg)
    JJLog.i(TAG, "_handleNoRegBindDefaultAccAck", msg.param)
    local ack = msg.lobby_ack_msg.noregbinddefaultacc_ack_msg

    if msg.param == 0 then
        --self:showToast("您的账户金币和所有物品会继续保留，登录时选择您的JJ手机帐号即可。")

        RegisterController:SaveAccountAfterSuccess(self.username_, self.password_)
        self.scene_:clearBeforeInput()
        --        绑定成功，这个手机可以生成一个新的免登陆帐号了，所以清除掉之前的数据
        Settings:setNoRegGoldPrompt(false)
        Settings:setNoRegLoginCount(0)

        self:showSuccessDialog()
    else
        local prompt = self:getFailPrompt(msg.param)
        if prompt == nil then
            prompt = "绑定失败（" .. msg.param .. "），请稍后重试！"
        end
        self:showToast(prompt)
    end
end

_handleVerifyLoginNameAck = function(self, msg)
    JJLog.i(TAG, "_handleVerifyLoginNameAck")
    local ack = msg.lobby_ack_msg.verifyloginname_ack_msg

    self.scene_:verifyLoginname(ack.loginname, msg.param)
end

_handleRegisterAck = function(self, msg)
    JJLog.i(TAG, "_handleRegisterAck12 = ",msg.param)
    local ack = msg.lobby_ack_msg.register_ack_msg

    if msg.param == 0 then
        --暂时删除 lifeng
        --self:showToast("注册成功，昵称：" .. ack.nickname)

        RegisterController:SaveAccountAfterSuccess(self.username_, self.password_)
        self.scene_:clearBeforeInput()
        self:showSuccessDialog()

        --JJSDK:changeToScene("hall.ui.controller.LoginSceneController", "hall.ui..scene.LoginScene")
    else
        local prompt = self:getFailPrompt(msg.param)
        if prompt == nil then
            prompt = "注册失败（" .. msg.param .. "）"
        end
        self:showToast(prompt)
    end
end

_setCodeImage = function(self, path)
    if (self.scene_) then
        self.scene_:refreshCodeImage(path)
    end
end

function NormalRegisterSceneController:checkUserName(text)
    local prompt = LoginController:checkRegisterUserName(text)
    if (prompt) then
    elseif (RegisterController:isLetter_Number(text)) then
    else
        prompt = "帐号包含非法字符"
    end

    return prompt
end

function NormalRegisterSceneController:onClickRegister(username, password, confirm, code)
    JJLog.i(TAG, "onClickRegister")

    local function checkCode(code)
        JJLog.i(TAG, "checkCode")
        local ret = true
        local len = string.len(code)
        if len ~= 4 then
            ret = false
            JJLog.i(TAG, "checkCode, ERR: username is nil")
            self:showToast("请输入正确的验证码")
        end
        return ret
    end

    local namecheck = self:checkUserName(username)
    if (namecheck) then
        self:showToast(namecheck)
        return
    end

    local valid, prompt = RegisterController:checkOnePassword(password, true)
    if (not valid) then
        self:showToast(prompt)
        return
    end

    if confirm == "" then
        self:showToast("确认密码不能为空！")
        return
    end

    if password ~= confirm then
        JJLog.i(TAG, "checkPassword, ERR: password not equal")
        self:showToast("两次密码不同！")
        return
    end

    if checkCode(code) then
        self.username_ = username
        self.password_ = password

        if LoginController.type_ == LOGIN_TYPE_NOREG then
            LobbyMsg:SendNoRegBindDefaultAccReq(username, nil, password, code, LoginController.specCode_, self.timefound_)
        else
            LobbyMsg:sendRegisterReq(username, nil, password, code, self.timefound_)
        end
    end
end

-- 点击验证码，请求重新获取
function NormalRegisterSceneController:onClickVerifyCode()
    JJLog.i(TAG, "onClickVerifyCode")

    self.timefound_ = nil
    _setCodeImage(self, nil)
    if MainController:isConnected() then
        LobbyMsg:sendGetVerifyCodeReq()
    else
        MainController:startConnect(false)
    end
end

--[[
    登录成功
]]
function NormalRegisterSceneController:onLoginSuccess()
    JJLog.i(TAG, "onLoginSuccess", JJSceneDef.ID_ORIGINAL)
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
function NormalRegisterSceneController:onLoginFailed(param)
    JJLog.i(TAG, "onLoginFailed")
    UIUtil.dismissDialog(self.loginDialog_)
    UIUtil.showLoginFailed(param, self.dimens_)
end

function NormalRegisterSceneController:resumeDisplay()
    JJLog.i(TAG, "resumeDisplay", self.regSuccessDialogShow)
    if self.regSuccessDialogShow then
        self:showSuccessDialog()
    else
        self:onClickVerifyCode() --进入此界面时，更新验证码
    end
end

function NormalRegisterSceneController:onPause()     
    NormalRegisterSceneController.super.onPause(self)
    --UIUtil.dismissDialog(self.loginDialog_)
end

--onResume
function NormalRegisterSceneController:onResume()
    local ret = NormalRegisterSceneController.super.onResume(self)
    if self.username_ and self.password_ then
        LoginController:setLoginParam(LOGIN_TYPE_JJ, self.username_, self.password_)
        LoginController:startLogin()
    end
    return ret
end

return NormalRegisterSceneController