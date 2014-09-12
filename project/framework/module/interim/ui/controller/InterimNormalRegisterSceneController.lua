local InterimNormalRegisterSceneController = class("InterimNormalRegisterSceneController", require("game.ui.controller.NormalRegisterSceneController"))

function InterimNormalRegisterSceneController:ctor(controllerName, sceneName)
    InterimNormalRegisterSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"))
end

return InterimNormalRegisterSceneController