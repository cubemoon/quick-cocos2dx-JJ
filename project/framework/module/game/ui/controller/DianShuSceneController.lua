local DianShuSceneController = class("DianShuSceneController", require("game.ui.controller.JJGameSceneController"))

--[[
    参数 
]]
function DianShuSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    DianShuSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

return DianShuSceneController