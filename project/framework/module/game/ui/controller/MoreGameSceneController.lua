local MoreGameSceneController = class("MoreGameSceneController", require("game.ui.controller.JJGameSceneController"))
local TAG = "MoreGameSceneController"

require("game.data.config.MoreGameManager")

--[[
    参数
    @params:
        @packageId
]]
function MoreGameSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    MoreGameSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

--[[
    消息处理
]]
function MoreGameSceneController:handleMsg(msg)
    MoreGameSceneController.super.handleMsg(self, msg)

    if msg.type == GameMsgDef.ID_MOREGAME_DOWNLOADED_IMG then
        self.scene_:refreshGameList()
    end
end

function MoreGameSceneController:onGameItemClick(isLua, item)
    if (item == nil or item.boot_param == nil or item.jump_url == nil) then
        JJLog.i(TAG, "onGameItemClick param is nil")
        return
    end

    local controller = require("upgrade.controller.GameItemController")
    local strs = string.split(item.boot_param, "#")
    local packageName = strs[1]
    local exist = controller:gameExist(isLua, packageName)
    JJLog.i(TAG, "onGameItemClick", isLua, exist, packageName, item.jump_url)

    if (exist) then
        if isLua == nil or isLua == 0 then
            local className, methodName, args, sig
            if device.platform == "android" then
                className = "cn/jj/base/JJUtil"
                methodName = "enterGame"
                args = { packageName }
                sig = "(Ljava/lang/String;)V"
                local result = luaj.callStaticMethod(className, methodName, args, sig)
            end
        else
            JJLog.i(TAG, "onGameItemClick TODO lua")
        end
    else
        Util:openSystemBrowser(item.jump_url)
        --        MainController:pushScene(self.params_.packageId, JJSceneDef.ID_WEB_VIEW, {
        --            title = item.jump_name,
        --            back = true,
        --            sso = false,
        --            url = item.jump_url,
        --        })
    end
end

return MoreGameSceneController