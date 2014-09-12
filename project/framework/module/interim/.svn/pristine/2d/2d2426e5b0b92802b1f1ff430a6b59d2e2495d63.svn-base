local InterimMatchSelectSceneController = class("InterimMatchSelectSceneController", require("game.ui.controller.MatchSelectSceneController"))
local TAG = "InterimMatchSelectSceneController"

function InterimMatchSelectSceneController:ctor(controllerName, sceneName, gameId)
    local theme = require("interim.ui.InterimTheme")
    MainController:removeScene(JJGameDefine.GAME_ID_INTERIM, JJSceneDef.ID_SWITCH_TO_GAME)
    local params = {
        packageId = JJGameDefine.GAME_ID_INTERIM,
        gameId = gameId,
    }
    params.title = theme:getImage("matchselect/lobby_title_lord.png")
    params.zone = "matchselect/lobby_match_list_title_lord_%d.png"
    InterimMatchSelectSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), params)
end

return InterimMatchSelectSceneController