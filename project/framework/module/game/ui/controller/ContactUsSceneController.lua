local ContactUsSceneController = class("ContactUsSceneController", require("game.ui.controller.JJGameSceneController"))

--[[
    参数
]]
function ContactUsSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    ContactUsSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

return ContactUsSceneController