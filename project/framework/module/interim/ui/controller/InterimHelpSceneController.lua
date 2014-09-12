local InterimHelpSceneController = class("HelpSceneController", require("game.ui.controller.HelpSceneController"))
local TAG = "InterimHelpSceneController"

function InterimHelpSceneController:ctor(controllerName, sceneName)
    InterimHelpSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"))
end

return InterimHelpSceneController