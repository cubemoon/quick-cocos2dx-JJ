local InterimTitleDetailSceneController = class("InterimTitleDetailSceneController", require("game.ui.controller.TitleDetailSceneController"))
local TAG = "InterimTitleDetailSceneController"

function InterimTitleDetailSceneController:ctor(controllerName, sceneName, gameId)
    InterimTitleDetailSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
                gameId = gameId,
                 title = require("game.util.JJGameUtil"):getGameName(gameId_, true) .. "称号",
                titleDef = require("interim.data.interimTitleDefine"),
            })

end

return InterimTitleDetailSceneController