local InterimFeedbackSceneController = class("InterimFeedbackSceneController", require("game.ui.controller.FeedbackSceneController"))
local TAG = "InterimFeedbackSceneController"

function InterimFeedbackSceneController:ctor(controllerName, sceneName, ...)
    InterimFeedbackSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), 
    	require("interim.ui.InterimDimens"), {
            title = "main/title.png",packageId = JJGameDefine.GAME_ID_INTERIM,
        }, ...)  
end

return InterimFeedbackSceneController