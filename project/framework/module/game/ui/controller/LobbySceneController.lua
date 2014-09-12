local LobbySceneController = class("LobbySceneController", require("sdk.scenestack.SceneController"))

function LobbySceneController:ctor(controllerName, sceneName)
    LobbySceneController.super.ctor(self, controllerName, sceneName)
    JJSDK:removeAllScene()
    self.lc_ = require("game.controller.LoginController")
    if self.lc_ ~= nil then
        self.lc_:init()
    end
end

--[[
    界面加载完成，自动登录
]]
function LobbySceneController:onSceneEnterFinish()
    LobbySceneController.super.onSceneEnterFinish(self)
    if MainController.autoLogin_ and not MainController:isConnected() then
        self:startLogin()
    end
end

-- 开始登录
function LobbySceneController:startLogin()
    JJLog.i(TAG, "startLogin")
    -- 无网络提示
    if Util:getNetworkType() == 0 then
        self.scene_:showSingleMode()
    else
        self.lc_:startLogin()
        self.scene_:showLoading(true, true)
    end
end

-- 消息处理
function LobbySceneController:handleMsg(msg)
    LobbySceneController.super.handleMsg(self, msg)

    -- 连接失败
    if msg.type == SDKMsgDef.TYPE_NET_STATE and msg.state == kJJSocketRequestStateFail then

    -- 连接断开
    elseif msg.type == SDKMsgDef.TYPE_NET_STATE and msg.state == kJJSocketRequestStateDisconnect then
        self:onLoginFailed(99)

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

-- 登录成功
function LobbySceneController:onLoginSuccess()
    JJLog.i(TAG, "onLoginSuccess")
    self.scene_:onLoginSuccess()
end

-- 登录失败
function LobbySceneController:onLoginFailed(param)
    JJLog.i(TAG, "onLoginFailed")
    self.scene_:onLoginFailed(param)
end

return LobbySceneController