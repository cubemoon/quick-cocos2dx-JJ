InterimMsg = {}

function InterimMsg:getTKMobileReq()
    local msg = {}
    return msg
end

function InterimMsg:getInterimReq(matchId)
    local msg = self:getTKMobileReq()
    msg.interim_req_msg = {matchid = matchId}
    return msg
end

function InterimMsg:sendCoinReqMsg(matchId, coin, seat)
    local msg = self:getInterimReq(matchId)
    msg.interim_req_msg.Coin_req_msg = {}
    msg.interim_req_msg.Coin_req_msg.coin = coin
    msg.interim_req_msg.Coin_req_msg.seat = seat - 1
    SendMsg:send(msg)
end

function InterimMsg:sendGambReqMsg(matchId, click, seat)
    local msg = self:getInterimReq(matchId)
    msg.interim_req_msg.Gamb_req_msg = {}
    msg.interim_req_msg.Gamb_req_msg.click = click
    msg.interim_req_msg.Gamb_req_msg.seat = seat - 1
    SendMsg:send(msg)
end

return InterimMsg

