--[[
    游戏中用到界面基类
]]
local JJGameSceneController = class("JJGameSceneController", require("sdk.scenestack.SceneController"))
local TAG = "JJGameSceneController"

JJGameSceneController.theme_ = nil -- 界面主题
JJGameSceneController.dimens_ = nil -- 坐标
JJGameSceneController.params_ = nil -- 动态参数

JJGameSceneController.resumeDialog_ = false

function JJGameSceneController:ctor(controllerName, sceneName, theme, dimens, params, ...)
    JJGameSceneController.super.ctor(self, controllerName, sceneName, ...)
    self.theme_ = theme
    self.dimens_ = dimens
    self.params_ = params
end

function JJGameSceneController:onResume()
    local ret = JJGameSceneController.super.onResume(self)
    if self.scene_ ~= nil then
        self.scene_:chagneScreen()
    end
    return ret
end

function JJGameSceneController:handleMsg(msg)
    JJGameSceneController.super.handleMsg(self, msg)

    if msg.type == SDKMsgDef.TYPE_NET_STATE then

        if msg.state == kJJSocketRequestStateDisconnect then
            if self.scene_ ~= nil then

                JJLog.i(TAG, "handleMsg, MainController.breakReconnect_=", MainController.breakReconnect_)
                if MainController.breakReconnect_ then
                    self.scene_:doBreakReconnect()
                end 
            end

        elseif msg.state == kJJSocketRequestStateFail then

            if self.scene_ ~= nil and self.scene_.reconnectDialog_ ~= nil then

            else
                local UIUtil = require("game.ui.UIUtil")
                UIUtil.showLoginFailed(99, self.dimens_)
            end
        end

    elseif msg.type == GameMsgDef.ID_LOGIN_RESULT then

        MainController.breakReconnect_ = false
        if self.scene_ ~= nil and self.scene_.reconnectDialog_ ~= nil then
            JJLog.i(TAG, "handleMsg, reconnectDialog_ ~= nil")
            local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
            scheduler.unscheduleGlobal(self.scene_.reconnectHandler_)
            if self.scene_ then
                self.scene_.reconnectHandler_ = nil
                self.scene_.reconnectDialog_:dismiss()
                self.scene_.reconnectDialog_ = nil
            end

            -- if msg.result_ == false then
            --     local UIUtil = require("game.ui.UIUtil")
            --     UIUtil.showLoginFailed(99, self.dimens_)
            -- end
        end
    end
end

--[[
    处理后台计时
    @dt: 当前时间
]]
function JJGameSceneController:handleBackgroundTimer(dt)
    JJLog.i(TAG, "handleBackgroundTimer dt=", dt)
    self:updateNewMatchExitTimer(dt)
end

function JJGameSceneController:showNewMatchStart(param)
    JJLog.i(TAG, "showNewMatchStart In")
    if self.scene_ ~= nil and param ~= nil then
        self.scene_:doNewMatchStart(param)
    end
end

function JJGameSceneController:exitNewMatchWithParam(param)
    JJLog.i(TAG, "exitNewMatchWithParam In")
    MatchMsg:sendExitMatchReq(param.matchId_, param.ticket_, param.gameId_)
end

function JJGameSceneController:updateNewMatchExitTimer(dt)
    JJLog.i(TAG, "updateNewMatchExitTimer dt=", dt)
    if StartedMatchManager.newMatchParam_ and (dt - StartedMatchManager.newMatchStartTimeStamp_) >= 10 then
        self:exitNewMatchWithParam(StartedMatchManager.newMatchParam_)
        StartedMatchManager.newMatchParam_ = nil
    end
end

--收到新比赛开赛消息，弹出提示框时，又收到一条新比赛开赛消息，此时应该退出上一个比赛，提示最新收到的比赛
function JJGameSceneController:exitNewMatchAndAlertAnotherOne()
    JJLog.i(TAG, "exitNewMatchAndAlertAnotherOne In")
    if StartedMatchManager.newMatchParam_ then
        self.scene_:closeNewMatchDailog(StartedMatchManager.newMatchParam_)
    end
    if StartedMatchManager.newMatchParam_ ~= nil then
        self:exitNewMatchWithParam(StartedMatchManager.newMatchParam_)
        StartedMatchManager.newMatchParam_ = nil
    end
end

function JJGameSceneController:showSignupConfirmDialog(param)
    if self.scene_ ~= nil and param ~= nil then
        self.scene_:showSignupConfirmDialog(param)
    end
end

return JJGameSceneController