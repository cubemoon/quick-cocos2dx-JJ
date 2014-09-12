--[[
	登录界面
]]
local LoginSceneController = class("LoginSceneController", require("sdk.scenestack.SceneController"))
local TAG = "LoginSceneController"
local WebViewController = require("game.ui.controller.WebViewController")

function LoginSceneController:ctor(controllerName, sceneName)
    LoginSceneController.super.ctor(self, controllerName, sceneName)
    self.lc_ = require("game.controller.LoginController")
	if self.lc_ ~= nil then
		self.lc_:init()
	end
end

function LoginSceneController:onBackPressed()	 
	if self.scene_ and self.scene_:onBackPressed() then
		return true
	else
		LoginSceneController.super.onBackPressed()
	end
end

-- 消息处理
function LoginSceneController:handleMsg(msg)
	LoginSceneController.super.handleMsg(self, msg)

	-- 连接失败
	if msg.type == SDKMsgDef.TYPE_NET_STATE and msg.state == kJJSocketRequestStateFail then
		self.scene_:showLoginDialog(false)

	elseif msg.type == SDKMsgDef.TYPE_NET_MSG then
		if msg[MSG_CATEGORY] == LOBBY_ACK_MSG then
			-- 登录消息
			if msg[MSG_TYPE] == NOREG_LOGIN_ACK or msg[MSG_TYPE] == GENERAL_LOGIN_ACK then
				if msg.param == 0 then
					self:onLoginSuccess()
				else
					self:onLoginFailed(msg.param)
				end
			end
		end
	end
end

-- 登录完成，进入下一个界面
function LoginSceneController:toNextScene()
	JJLog.i(TAG, "toNextScene, No Implement")
end

-- 开始登录
function LoginSceneController:startLogin()
	JJLog.i(TAG, "startLogin")
	-- 无网络提示
	if Util:getNetworkType() == 0 then
		self.scene_:showNoNetworkDialog(true)
	else
		self.scene_:showLoginDialog(true)
		self.lc_:startLogin()
	end
end

-- 登录成功
function LoginSceneController:onLoginSuccess()
	JJLog.i(TAG, "onLoginSuccess")
	self.scene_:showLoginDialog(false)
	self:toNextScene()
end

-- 登录失败
function LoginSceneController:onLoginFailed(param)
	JJLog.i(TAG, "onLoginFailed")
    self.scene_:showLoginFailed(param, self.dimens_)
end

-- 点击 Spin 按钮
function LoginSceneController:onClickSpin()
	JJLog.i(TAG, "onClickSpin")
	self.scene_:showLoginHistoryList(true)
end

-- 点击忘记密码
function LoginSceneController:onClickForgetPassword()
	JJLog.i(TAG, "onClickForgetPassword")
	local urlDef = require("game.def.JJWebViewUrlDef")
    -- MainController:pushScene(MainController.packageId_, JJSceneDef.ID_WEB_VIEW, {
    --     title = "找回密码",
    --     back = true,
    --     sso = true,
    --     url = urlDef.URL_RESET_PWD,
    -- })
    WebViewController:showActivity({
        title = "忘记登录密码/第一步",
        back = true,
        sso = false,
        url = JJWebViewUrlDef.URL_RESET_PWD .. "?appID=" ..  WebViewController:getAppID(),
    })
end

-- 点击登录
function LoginSceneController:onClickLogin(username, password)
	JJLog.i(TAG, "onClickLogin")

	local namecheck = LoginController:checkUserName(username)
	if(namecheck) then
        jj.ui.JJToast:show({ text = namecheck, dimens = self.dimens_ })
		return
	end

	local passwordcheck = LoginController:checkPassword(password)
    if(passwordcheck) then
        jj.ui.JJToast:show({ text = passwordcheck, dimens = self.dimens_ })
		return
	end


	if self.lc_.type_ == LOGIN_TYPE_JJ and self.lc_.loginState_ ~= self.lc_.STATE_UNLOGIN and self.lc_.username_ == username then
		self:onBackPressed()
	else
		self.lc_:setLoginParam(LOGIN_TYPE_JJ, username, password)
		self:startLogin()
	end

end

-- 点击免注册登录
function LoginSceneController:onClickNoRegLogin()
	JJLog.i(TAG, "onClickNoRegLogin, type_=", self.lc_.type_, ", loginState_=", self.lc_.loginState_)
	if self.lc_.type_ == LOGIN_TYPE_NOREG and self.lc_.loginState_ ~= self.lc_.STATE_UNLOGIN then
		self:onBackPressed()
	else
		self.lc_:setLoginParam(LOGIN_TYPE_NOREG)
		self:startLogin()
	end
end

-- 点击注册
function LoginSceneController:onClickRegister()
	JJLog.i(TAG, "onClickRegister")
	local id = MainController:getRegisterSceneId(MainController.packageId_)
	MainController:pushScene(MainController.packageId_, id)
end

-- 点击网络设置
function LoginSceneController:onClickNetworkSetting()
	JJLog.i(TAG, "onClickNetworkSetting")
	Util:callNetworkSetting()
end

return LoginSceneController