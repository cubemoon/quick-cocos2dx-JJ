local RegisterSelectSceneController = class("RegisterSelectSceneController", require("game.ui.controller.JJGameSceneController"))

--[[
    参数
    @params:
        @packageId:
]]
function RegisterSelectSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    RegisterSelectSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

--[[
    跳转到普通注册界面
]]
function RegisterSelectSceneController:onClickNormal()
    MainController:pushScene(self.params_.packageId, JJSceneDef.ID_NORMAL_REGISTER)
end

--[[
    跳转到手机注册界面
]]
function RegisterSelectSceneController:onClickMobile()
    MainController:pushScene(self.params_.packageId, JJSceneDef.ID_MOBILE_REGISTER)
end

--[[
    跳转到JJ帐号登录界面
]]
function RegisterSelectSceneController:onJJLogin()
    MainController:changeToScene(self.params_.packageId, JJSceneDef.ID_JJ_LOGIN)
end

--[[
    跳转到JJ帐号登录界面
]]
function RegisterSelectSceneController:onHallJJLogin()
    MainController:changeToScene(JJGameDefine.GAME_ID_HALL, JJSceneDef.ID_LOGIN)
end

return RegisterSelectSceneController