local JJLoginSceneController = class("JJLoginSceneController", require("game.ui.controller.JJGameSceneController"))
local TAG = "JJLoginSceneController"
local WebViewController = require("game.ui.controller.WebViewController")

JJLoginSceneController.loginDialog_ = nil -- 登录等待框
JJLoginSceneController.noNetworkDialog_ = nil -- 无网络提示框

local UIUtil = require("game.ui.UIUtil")

JJLoginSceneController.theme_ = nil -- 界面主题
JJLoginSceneController.dimens_ = nil -- 坐标
JJLoginSceneController.params_ = nil -- 动态参数

function JJLoginSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    JJLoginSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

function JJLoginSceneController:onPause()
    JJLoginSceneController.super.onPause(self)
    self.userName_, self.password_ = self.scene_:getEditorContent()
end

--[[
    消息处理
]]
function JJLoginSceneController:handleMsg(msg)
    JJLoginSceneController.super.handleMsg(self, msg)

    -- 连接失败
    if msg.type == SDKMsgDef.TYPE_NET_STATE and msg.state == kJJSocketRequestStateFail then
        UIUtil.dismissDialog(self.loginDialog_)

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

function JJLoginSceneController:startLogin()
    JJLog.i(TAG, "startLogin")

    if Util:getNetworkType() == 0 then

        local function _dismissCB()
            JJLog.i(TAG, "_dismissCB")
            self.noNetworkDialog_ = nil
        end

        local function _btn1CB()
            JJLog.i(TAG, "_btn1CB")
            Util:callNetworkSetting()
        end

        local function _btn2CB()
            JJLog.i(TAG, "_btn2CB")
        end

        self.noNetworkDialog_ = UIUtil.showNoNetworkDialog(self.scene_, self.theme_, self.dimens_, _dismissCB, _btn1CB, _btn2CB)
    else

        -- 重新登录前先登出
        LoginController:logout()

        self.loginDialog_ = UIUtil.showLoginDialog(self.scene_, self.theme_, self.dimens_, function() self.loginDialog_ = nil end)
        LoginController:startLogin()
    end
end

function JJLoginSceneController:onClickLogin(username, password)
    username = string.lower(username) --添加统一转化为小写处理
    JJLog.i(TAG, "onClickLogin", username, password)

    local namecheck = LoginController:checkUserName(username)
    if (namecheck) then
        jj.ui.JJToast:show({ text = namecheck, dimens = self.dimens_ })
        return
    end

    local passwordcheck = LoginController:checkPassword(password)
    if (passwordcheck) then
        jj.ui.JJToast:show({ text = passwordcheck, dimens = self.dimens_ })
        return
    end


    if LoginController.type_ == LOGIN_TYPE_JJ and LoginController.loginState_ ~= LoginController.STATE_UNLOGIN and LoginController.username_ == username then
        --self:onBackPressed()
        MainController:changeToScene(self.params_.packageId, JJSceneDef.ID_ORIGINAL) --需要跳转回首页
    else
        LoginController:setLoginParam(LOGIN_TYPE_JJ, username, password)
        self:startLogin()
    end
end

--[[
    找回密码
]]
function JJLoginSceneController:onClickRstPwd()
    JJLog.i(TAG, "onClickRstPwd")
    WebViewController:showActivity({
        title = "忘记登录密码/第一步",
        back = true,
        sso = false,
        url = JJWebViewUrlDef.URL_RESET_PWD .. "?appID=" .. WebViewController:getAppID(),
    })
end

--[[
    找回密码
]]
function JJLoginSceneController:onClickRegiste()
    JJLog.i(TAG, "onClickRegiste")

    local id = MainController:getRegisterSceneId(self.params_.packageId)
    MainController:changeToScene(self.params_.packageId, id)
end

--[[
    登录成功
]]
function JJLoginSceneController:onLoginSuccess()
    JJLog.i(TAG, "onLoginSuccess")
    UIUtil.dismissDialog(self.loginDialog_)
    MainController:changeToScene(self.params_.packageId, JJSceneDef.ID_ORIGINAL) --需要跳转回首页
    --self:onBackPressed()
end

--[[
    登录失败
]]
function JJLoginSceneController:onLoginFailed(param)
    JJLog.i(TAG, "onLoginFailed")
    UIUtil.dismissDialog(self.loginDialog_)
    UIUtil.showLoginFailed(param, self.dimens_)
end

return JJLoginSceneController