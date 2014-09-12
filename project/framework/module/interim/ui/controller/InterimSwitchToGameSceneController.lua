local InterimSwitchToGameSceneController = class("InterimSwitchToGameSceneController", require("game.ui.controller.SwitchToGameSceneController"))

function InterimSwitchToGameSceneController:ctor(controllerName, sceneName, gameId)
    local theme = require("interim.ui.InterimTheme")
    local dimens = require("interim.ui.InterimDimens")
    dimens:init()
    registerSizeChangeListener("Interim", handler(dimens, dimens.init))
    InterimSwitchToGameSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), dimens, {
            packageId = JJGameDefine.GAME_ID_INTERIM,
            gameId = gameId,
            anims = {
                theme:getImage("switchtogame/loading1.png"),
                theme:getImage("switchtogame/loading2.png"),
                theme:getImage("switchtogame/loading3.png"),
                theme:getImage("switchtogame/loading4.png"),
                theme:getImage("switchtogame/loading5.png"),
                theme:getImage("switchtogame/loading6.png"),
                theme:getImage("switchtogame/loading7.png"),
                theme:getImage("switchtogame/loading8.png"),
                theme:getImage("switchtogame/loading9.png"),
                theme:getImage("switchtogame/loading10.png"),
            },
        })

    JJLog.i("**********controllerName******" .. controllerName .. sceneName)
end

return InterimSwitchToGameSceneController
