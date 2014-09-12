SMSMsgController = {}
local TAG = "SMSMsgController"

-- 定义消息类型
PURCHASE_CARD_ORDER_ACK = 1
PAY_COMMON_ORDER_ACK = 2
PAY_IOS_ORDER_ACK = 3

local function _handlePurchaseCardOrderAck(msg)
    JJLog.i(TAG, "_handlePurchaseCardOrderAck")
    msg[MSG_TYPE] = PURCHASE_CARD_ORDER_ACK
end

local function _handlePayCommonOrderAck(msg)
    JJLog.i(TAG, "_handlePayCommonOrderAck")
    msg[MSG_TYPE] = PAY_COMMON_ORDER_ACK
end

local function _handleAppleOrderAck(msg)
JJLog.i("_handleAppleOrderAck ")
    msg[MSG_TYPE] = PAY_IOS_ORDER_ACK
    local ack = msg.sms_ack_msg.appleorder_ack_msg
end

function SMSMsgController:handleMsg(msg)
    JJLog.i(TAG, "handleMsg")
    msg[MSG_CATEGORY] = SMS_ACK_MSG
    local sms = msg.sms_ack_msg
    if #sms.purchasecardorder_ack_msg ~= 0 then
        _handlePurchaseCardOrderAck(msg)
    elseif #sms.paycommonorder_ack_msg ~= 0 then
        _handlePayCommonOrderAck(msg)
    elseif #sms.appleorder_ack_msg ~= 0 then
        _handleAppleOrderAck(msg)
    end
end