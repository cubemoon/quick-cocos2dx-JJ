local TableSelectSceneController = class("TableSelectSceneController", require("game.ui.controller.JJGameSceneController"))
local TAG = "TableSelectSceneController"

--[[
    参数 
]]
function TableSelectSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    TableSelectSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

function TableSelectSceneController:onPause()
    TableSelectSceneController.super.onPause(self)
end

--消息处理
function TableSelectSceneController:handleMsg(msg)
    TableSelectSceneController.super.handleMsg(self, msg)
    JJLog.i(TAG, "fanqitao TableSelectSceneController:handleMsg")
    if msg[MSG_CATEGORY] == MATCHINFO_ACK_MSG and msg[MSG_TYPE] == MATCH_TABLE_PLAYER_CHANGE_ACK then
        local ack = msg.matchinfo_ack_msg.getplayer_ack_msg
        self.scene_:showTableInfo(ack)
    end
end

return TableSelectSceneController