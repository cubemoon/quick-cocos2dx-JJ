-- 比赛消息
MatchInfoMsg = {}

require("game.pb.SendMsg")

local function _getMatchInfoReq()
    return { matchinfo_req_msg = {} }
end

--[[获取报名开赛时间信息]]
function MatchInfoMsg:sendGetSignCountReq(tourneyID_)
    local msg = _getMatchInfoReq()
    msg.matchinfo_req_msg.getsigncount_req_msg = {
        tourneyid = tourneyID_
    }
    SendMsg:send(msg)
end

--[[获取比赛的所有散桌信息]]
function MatchInfoMsg:sendGetTableList(tourneyID_, beginID_, Count_)
    local msg = _getMatchInfoReq()
    msg.matchinfo_req_msg.gettablelist_req_msg = {
        tourneyid = tourneyID_,
        begintableid = beginID_,
        tablecount = Count_
    }
    SendMsg:send(msg)
end

--[[获取该桌子的详情]]
function MatchInfoMsg:sendGetTablePlayerInfo(tourneyID_, tableId_)
    local msg = _getMatchInfoReq()
    msg.matchinfo_req_msg.getplayer_req_msg = {
        tourneyid = tourneyID_,
        tableid = tableId_
    }
    SendMsg:send(msg)
end

return MatchInfoMsg