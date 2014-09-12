local InterimRegisterSelectSceneController = class("InterimRegisterSelectSceneController", require("game.ui.controller.RegisterSelectSceneController"))
local TAG = "InterimRegisterSelectSceneController"

function InterimRegisterSelectSceneController:ctor(controllerName, sceneName)
    InterimRegisterSelectSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
            packageId = JJGameDefine.GAME_ID_INTERIM
        })
end

return InterimRegisterSelectSceneController