local TitleDetailSceneController = class("TitleDetailSceneController", require("game.ui.controller.JJGameSceneController"))

--[[
    参数
    @params:
        @gameId
        @title    标题：各个项目的名称 + "称号",
        @titleDef 各个项目的TitleDefine
]]
function TitleDetailSceneController:ctor(controllerName, sceneName, theme, dimens, params)
    TitleDetailSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, params)
    self:setResumeRedraw(false)
    self.titleDef_ = params.titleDef or require("game.data.lobby.TitleDefine")
    self.expTitle_ = self.titleDef_:getTitle(params.gameId)  
    LobbyMsg:sendGetSingleGrowReq(UserInfo.userId_, GrowWareIdDef:getExpGrowId(params.gameId))  
end

function TitleDetailSceneController:handleMsg(msg)
    if msg.type == SDKMsgDef.TYPE_NET_MSG then --主要处理断线重连 bug 7490
        if msg[MSG_CATEGORY] == LOBBY_ACK_MSG then 
            local type = msg[MSG_TYPE]
            if type == GETUSERALLWARE_ACK then 
                LobbyMsg:sendGetSingleGrowReq(UserInfo.userId_, GrowWareIdDef:getExpGrowId(self.params_.gameId))  
            end

            if  msg[MSG_TYPE] == GETSINGLEGROW_ACK then
                self.scene_:refresh()
            end
        end
    end
    
    TitleDetailSceneController.super.handleMsg(self, msg)
end

return TitleDetailSceneController