local HelpSceneController = class("HelpSceneController", require("game.ui.controller.JJGameSceneController"))

--[[
    参数
]]
function HelpSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    HelpSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

return HelpSceneController