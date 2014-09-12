--[[
	单包游戏的主界面
]]
local InterimMainSceneController = class("InterimMainSceneController", require("game.ui.controller.MainSceneController"))
local TAG = "InterimMainSceneController"

function InterimMainSceneController:ctor(controllerName, sceneName, ...)
    local theme = require("interim.ui.InterimTheme")
    InterimMainSceneController.super.ctor(self, controllerName, sceneName, require("interim.ui.InterimTheme"), require("interim.ui.InterimDimens"), {
            packageId = JJGameDefine.GAME_ID_INTERIM,
            games = {
                {
                    gameId = JJGameDefine.GAME_ID_INTERIM,
                    images = {
                        normal = theme:getImage("main/interim_btn_n.png"),
                        highlight = theme:getImage("main/interim_btn_d.png"),
                    },
                },
            },
        }, ...)
end

return InterimMainSceneController 