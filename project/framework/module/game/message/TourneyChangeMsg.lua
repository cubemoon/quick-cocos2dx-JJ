-- tourneyinfo change event
local TourneyChangeMsg = class("TourneyChangeMsg", require("sdk.message.Message"))

-- tourney change event type
local TYPE_MODIFY = 1  
local TYPE_ADD = 2
local TYPE_DEL = 3

function TourneyChangeMsg:ctor()
    self.super.ctor(self, GameMsgDef.ID_CUSTOM_TOURNEY_CHANGE)
    self.type_ = TYPE_MODIFY
    self.tourneyIdList_ = {}
end

return TourneyChangeMsg