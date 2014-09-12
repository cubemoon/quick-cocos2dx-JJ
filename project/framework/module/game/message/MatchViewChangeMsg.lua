-- 登录结果消息
local MatchViewChangeMsg = class("MatchViewChangeMsg", require("sdk.message.Message"))

MatchViewChangeMsg.tag = 0

function MatchViewChangeMsg:ctor(tag)
    self.super.ctor(self, GameMsgDef.ID_MATCH_VIEW_CHANGE)
    self.tag = tag
end

return MatchViewChangeMsg