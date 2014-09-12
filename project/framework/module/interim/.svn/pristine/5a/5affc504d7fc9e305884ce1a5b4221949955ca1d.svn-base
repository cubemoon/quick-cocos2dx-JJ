-- local InterimJJLoginSceneController = class("InterimJJLoginSceneController", require("game.ui.controller.JJloginSceneController"))
-- local TAG = "InterimJJLoginSceneController"

-- function InterimJJloginSceneController:ctor(controllerName, sceneName)
--     InterimJJloginSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"))
-- end

-- return InterimJJLoginSceneController

local InterimJJLoginSceneController = class("InterimJJLoginSceneController", require("game.ui.controller.JJLoginSceneController"))

local TAG = "InterimJJLoginSceneController"

function InterimJJLoginSceneController:ctor(controllerName, sceneName,...)
    InterimJJLoginSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
            packageId = JJGameDefine.GAME_ID_INTERIM,
        }, ...)
end


return InterimJJLoginSceneController