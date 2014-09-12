local InterimSettingsSceneController = class("InterimSettingsSceneController", require("game.ui.controller.SettingsSceneController"))

function InterimSettingsSceneController:ctor(controllerName, sceneName)
    InterimSettingsSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
            packageId = JJGameDefine.GAME_ID_INTERIM
        })
end

return InterimSettingsSceneController