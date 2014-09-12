local AboutSceneController = class("AboutSceneController", require("game.ui.controller.JJGameSceneController"))

--[[
	参数 
	@params: 
    	@title: 标题图片地址    
]]
function AboutSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    AboutSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

function AboutSceneController:onBackPressed()
    JJLog.i(TAG, "onBackPressed")
    if self.scene_ then
	    if self.scene_.callDialog_ then
	    	self.scene_:onBackPressed()
		else
	    	AboutSceneController.super.onBackPressed(self)
		end
	end
end
return AboutSceneController