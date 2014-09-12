local InterimPersonalCenterSceneController = class("InterimPersonalCenterSceneController", require("game.ui.controller.PersonalCenterSceneController"))

require("game.def.GrowWareIdDef")

function InterimPersonalCenterSceneController:ctor(controllerName, sceneName)
    InterimPersonalCenterSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
    		packageId = JJGameDefine.GAME_ID_INTERIM,
    		games = {
    			{
    				gameId = JJGameDefine.GAME_ID_INTERIM,
    				name = "经典场",
    				growId = GrowWareIdDef.INTERIM_GROW_EXPERIENCE_ID,
				},
    		},
    	})
end

return InterimPersonalCenterSceneController