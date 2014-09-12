local PersonalCenterHelpSceneController = class("PersonalCenterHelpSceneController", require("game.ui.controller.JJGameSceneController"))

--[[
    参数
    @params:
        @packageId
        @games:
            @gameId
            @name
]]
function PersonalCenterHelpSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    PersonalCenterHelpSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

function PersonalCenterHelpSceneController:toTitleScene(gameId)
    if self.params_ and self.params_.titleDef and self.params_.titleDef:hasTitle(gameId) then
        MainController:pushScene(self.params_.packageId, JJSceneDef.ID_TITLE_DETAIL, gameId)
    end
end

return PersonalCenterHelpSceneController