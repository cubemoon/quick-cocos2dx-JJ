local InterimWelcomeSceneController = class("InterimWelcomeSceneController", require("game.ui.controller.WelcomeSceneController"))
local InterimJJLoginSceneController = require("interim.ui.controller.InterimJJLoginSceneController")

local TAG = "InterimWelcomeSceneController"

function InterimWelcomeSceneController:ctor(controllerName, sceneName)
    InterimWelcomeSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
            sceneId = JJSceneDef.ID_MATCH_SELECT,
            gameId = JJGameDefine.GAME_ID_INTERIM,
        })
end

return InterimWelcomeSceneController