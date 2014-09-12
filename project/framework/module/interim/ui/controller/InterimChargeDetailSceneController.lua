local InterimChargeDetailSceneController = class("InterimChargeDetailSceneController", require("game.ui.controller.ChargeDetailSceneController"))

function InterimChargeDetailSceneController:ctor(controllerName, sceneName, params)
    InterimChargeDetailSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
            packageId = params.packageId,
            type = params.type,
            amount = params.amount,
        })
end

return InterimChargeDetailSceneController