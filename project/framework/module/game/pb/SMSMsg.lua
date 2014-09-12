-- SMS 消息
SMSMsg = {}

require("game.pb.SendMsg")

local function _getTKMobileReq()
    local msg = {}
    return msg
end

local function _getSMSReq()
    local msg = _getTKMobileReq()
    msg.sms_req_msg = {}
    return msg
end

--[[
    参数
    @userId
    @cardtype: 1移动，0联通
    @amount: 元
    @cardnum
    @cardpw
    @schemeid
    @endmid
]]
function SMSMsg:sendPurchaseCardOrderReq(userid, cardtype, gold, amount, cardnum, cardpw, schemeid, endmid)
    local msg = _getSMSReq()
    msg.sms_req_msg.purchasecardorder_req_msg = {
        userid = userid,
        mobileno = "",
        packid = PROMOTER_ID,
        cardtype = cardtype,
        cardamount = amount * 100,
        payamount = amount * 100,
        coin = gold,
        cardserialno = cardnum,
        cardpassword = cardpw,
        endmid = endmid,
        ecaschemeid = schemeid,
    }
    SendMsg:send(msg)
end

--[[
    参数
    @userId
    @coin
    @amount
    @preId
    @zoneId
    @payType
    @payTypeSubId,
    @mobileNo
    @promoterId
    @gameId
    @schemeId
    @endMid
]]
function SMSMsg:sendPayCommonOrderReq(userid, coin, amount, preId, zoneId, payType, payTypeSubId, mobileNo, promoterId, gameId, schemeid, endmid)
    local msg = _getSMSReq()
    msg.sms_req_msg.paycommonorder_req_msg = {
        userid = userid,
        coin = coin,
        rmb = amount,
        endmid = endmid,
        agentid = preId,
        zoneid = zoneId,
        paytypeid = payType,
        paytypesubid = payTypeSubId,
        packageid = promoterId,
        ecaschemeid = schemeid,
        mobileno = mobileNo,
        gameid = gameId,
    }
    SendMsg:send(msg)
end

function SMSMsg:sendAppleOrderReq(productId, trasactionId, receiptData, purchaseData, userId)
    local msg = _getSMSReq()
    msg.sms_req_msg.appleorder_req_msg = {
        userid = userId,
        productid = productId,
        transactionid = trasactionId,
        receiptdata = receiptData,
        purchasedata = purchaseData,
    }
    SendMsg:send(msg)
end

return SMSMSg