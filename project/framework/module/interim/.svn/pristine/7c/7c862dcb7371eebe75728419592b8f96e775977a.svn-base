local InterimPersonalCenterHelpSceneController = class("InterimPersonalCenterHelpSceneController", require("game.ui.controller.PersonalCenterHelpSceneController"))

function InterimPersonalCenterHelpSceneController:ctor(controllerName, sceneName)
    InterimPersonalCenterHelpSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
            packageId = JJGameDefine.GAME_ID_INTERIM,
            games = {
                {
                    gameId = JJGameDefine.GAME_ID_INTERIM,
                    name = "点击查看卡当称号等级说明",
                },
            },
            titleDef = require("interim.data.interimTitleDefine"),
        })
end

return InterimPersonalCenterHelpSceneController