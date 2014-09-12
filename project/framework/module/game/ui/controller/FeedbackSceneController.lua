local FeedbackSceneController = class("FeedbackSceneController", require("game.ui.controller.JJGameSceneController"))
local roarInterface = require("game.thirds.RoarInterface")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

--[[
    参数
    @params:
        @packageId
        @title: 标题图片地址
        @fontColor: 官方微信 客服电话 的字体颜色
]]
function FeedbackSceneController:ctor(controllerName, sceneName, theme, dimens, params)
    FeedbackSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, params)
end

function FeedbackSceneController:handleMsg(msg)
    FeedbackSceneController.super.handleMsg(self, msg)

    if msg[MSG_CATEGORY] == HTTP_ACK_MSG then
        if msg[MSG_TYPE] == COMMON_HTTP_GET_POST_ROAR_ACK then
            self:returnFeedbackDialog(msg)
        end
    end
end

function FeedbackSceneController:onPause()
    FeedbackSceneController.super.onPause(self)
end

function FeedbackSceneController:showToast(txt)
    jj.ui.JJToast:show({ text = txt, dimens = self.dimens_ })
end

--意见反馈提交后返回的Pop框
function FeedbackSceneController:returnFeedbackDialog(msg)
    JJLog.i("returnFeedbackDialog12 ----------------",msg)
    if msg then
        local str = ""
        local state = false
        JJLog.i("returnFeedbackDialog34 ----------------",msg.success)
        if msg.success then
            str = "提交成功"
            state = true
            self.scene_:clearBeforeInput()
        else
            if msg.code == 301 then
                str = msg.msg
            else
                str = "提交失败"
            end
        end

        self:showToast(str)
        if state then
            if self.scheduleHandler_ == nil then
                self.scheduleHandler_ = scheduler.scheduleGlobal(function() self:doTick() end, 0.5)
            end
        end
    end
end

function FeedbackSceneController:doTick()
    self:destroy()
    self:onBackPressed()
end

function FeedbackSceneController:destroy()
    if self.scheduleHandler_ then
        scheduler.unscheduleGlobal(self.scheduleHandler_)
        self.scheduleHandler_ = nil
    end
end

function FeedbackSceneController:onExit()
    self:destroy()
end

--[[
    参数
    @packageId
]]

-- 提交
function FeedbackSceneController:onClickSubmit(str)   
    if str ~= "" then
        roarInterface:postRoarReq(str,201)
    else
        self:showToast("请输入您的反馈意见")
    end
end

--查看我的提问
function FeedbackSceneController:onClickMyquestion()
    if MainController:isLogin() then
        roarInterface:enteRoar(9)
    else
       if Util:getNetworkType() == 0 then
           self:showToast("网络连接不上，请检查您的网络设置！")
       end
    end
end

function FeedbackSceneController:onBackPressed()
    JJLog.i(TAG, "onBackPressed")
    if self.scene_ then
        if self.scene_.callDialog_ then
            self.scene_:onBackPressed()
        else
            FeedbackSceneController.super.onBackPressed(self)
        end
    end
end
return FeedbackSceneController