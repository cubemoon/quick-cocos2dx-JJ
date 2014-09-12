local InterimSplashSceneController = class("InterimSplashSceneController", require("game.ui.controller.SplashSceneController"))
local TAG = "InterimSplashSceneController"

function InterimSplashSceneController:ctor(controllerName, sceneName, ...)
    InterimSplashSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
            packageId = JJGameDefine.GAME_ID_INTERIM,
            next = JJSceneDef.ID_MAIN,
        })
end

return InterimSplashSceneController