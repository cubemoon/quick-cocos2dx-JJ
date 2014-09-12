--
-- Author: guanglong
-- Date: 2014-07-31 17:51:41
--
local InterimPersonalInfoCenterSceneController = class("InterimPersonalInfoCenterSceneController", require("game.ui.controller.PersonalInfoCenterSceneController"))

require("game.def.GrowWareIdDef")

--[[
param table中
packageId为必填
gameNum为必填
--]]

function InterimPersonalInfoCenterSceneController:ctor(controllerName, sceneName)    
    InterimPersonalInfoCenterSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
    		packageId = JJGameDefine.GAME_ID_INTERIM,
    		games = {
    		
    			{
    				gameId = JJGameDefine.GAME_ID_INTERIM,
    				name = "卡当",
    				growId = GrowWareIdDef.INTERIM_GROW_EXPERIENCE_ID,
    			}
    		},
            gameNum = 1,
            rowHeight = 100,
            titleDef = require("interim.data.interimTitleDefine"),
    	})
end

return InterimPersonalInfoCenterSceneController