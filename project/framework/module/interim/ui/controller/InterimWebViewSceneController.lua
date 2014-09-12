local InterimWebViewSceneController = class("InterimWebViewSceneController", require("game.ui.controller.WebViewSceneController"))

local TAG = "InterimWebViewSceneController"

function InterimWebViewSceneController:ctor(controllerName, sceneName, params)
    InterimWebViewSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), params)
end

return InterimWebViewSceneController