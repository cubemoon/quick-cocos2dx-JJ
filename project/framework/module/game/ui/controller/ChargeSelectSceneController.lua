local ChargeSelectSceneController = class("ChargeSelectSceneController", require("game.ui.controller.JJGameSceneController"))
local WebViewController = require("game.ui.controller.WebViewController")

local TAG = "ChargeSelectSceneController"


--[[
    参数
    @params:
        @packageId
]]
function ChargeSelectSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    ChargeSelectSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

-- 点击联系我们
function ChargeSelectSceneController:onClickContactUs()
    MainController:pushScene(self.params_.packageId, JJSceneDef.ID_FEEDBACK,
        {
            title = "联系我们",            
        })

end

-- 选择某个充值方式
function ChargeSelectSceneController:onSelectPayType(type)
    JJLog.i(TAG, "onSelectPayType, type=", type)
    if type == PayDef.CHARGE_TYPE_OTHER then
        WebViewController:showActivity({
            title = "JJ卡密",
            back = true,
            sso = true,
            url = JJWebViewUrlDef.URL_OTHER_CHARGE,
            scale = self.dimens_.scale_
        })
    else
        MainController:pushScene(self.params_.packageId, JJSceneDef.ID_CHARGE_DETAIL, {
            packageId = self.params_.packageId,
            type = type,
        })
    end
end

-- function ChargeSelectSceneController:onSceneEnterFinish()
--      JJLog.i(TAG, "onSceneEnterFinish IN Settings:getNoRegChargePrompt()=", Settings:getNoRegChargePrompt())
--      JJLog.i(TAG, "onSceneEnterFinish IN Settings:LoginController.type=", LoginController.type_)
--      if (Settings:getNoRegChargePrompt() == false) and (LoginController.type_ == LOGIN_TYPE_NOREG) then
--         Settings:setNoRegChargePrompt(true)
--         self.scene_:showGuideToBindNoRegDialog(true)
--      end
--     return ChargeSelectSceneController.super.onSceneEnterFinish(self)
-- end

--[[
    点击注册
]]
function ChargeSelectSceneController:onClickRegister()
    JJLog.i(TAG, "onClickRegister")

    local id = MainController:getRegisterSceneId(self.params_.packageId)
    MainController:pushScene(self.params_.packageId, id)
end

function ChargeSelectSceneController:onBackPressed()
    if self.scene_ and self.scene_:onBackPressed() then
        return true
    else
        ChargeSelectSceneController.super.onBackPressed(self)
    end
end

return ChargeSelectSceneController