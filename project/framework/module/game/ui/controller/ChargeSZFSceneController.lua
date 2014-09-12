local ChargeSZFSceneController = class("ChargeSZFSceneController", require("game.ui.controller.JJGameSceneController"))

local TAG = "ChargeSZFSceneController"
local pcm = require("game.data.config.PayConfigManager")
--[[
    参数    
    @params:
        @packageId
        @type:       充值类型
        @amount:     充值卡面额    
        @gold:       获得金币数
]]
function ChargeSZFSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    ChargeSZFSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

function ChargeSZFSceneController:onClickCharge(num, pw)
    JJLog.i(TAG, "onClickCharge, num=", num, ", pw=", pw)
    if num == nil or string.len(num) < 10 or string.find(num,"%D") ~= nil then
        jj.ui.JJToast:show({ text = "请输入正确的充值卡号", dimens = self.dimens_ })
        return
    end

    if pw == nil or string.len(pw) < 8 or string.find(pw,"%D") ~= nil then
        jj.ui.JJToast:show({ text = "请输入正确的充值卡密码", dimens = self.dimens_ })
        return
    end

    local cardtype = 0
    if self.params_.type == PayDef.CHARGE_TYPE_SZF_CMCC then
        cardtype = 1
    end

    JJLog.i(TAG, "onClickCharge, type=", self.params_.type, ", cardtype=", cardtype)    

    require("game.pb.SMSMsg")
    SMSMsg:sendPurchaseCardOrderReq(UserInfo.userId_, cardtype, self.params_.gold/100, self.params_.amount, num, pw, self.item_.dwECASchemeID, 0)
end

function ChargeSZFSceneController:handleMsg(msg)
    ChargeSZFSceneController.super.handleMsg(self, msg)

    if msg.type == SDKMsgDef.TYPE_NET_MSG then
        if msg[MSG_CATEGORY] == SMS_ACK_MSG then
            if msg[MSG_TYPE] == PURCHASE_CARD_ORDER_ACK then
                JJLog.i(TAG, "handleMsg, result=", msg.sms_ack_msg.purchasecardorder_ack_msg.result, ", note=", msg.sms_ack_msg.purchasecardorder_ack_msg.note)
                if msg.sms_ack_msg.purchasecardorder_ack_msg.result == 0 then
                    jj.ui.JJToast:show({ text = "充值订单提交成功，请稍候查收！", dimens = self.dimens_ })
                    
                    if self.scene_ then
                        self.scene_:clearBeforeInput()
                    end

                    self:onBackPressed()
                else
                    jj.ui.JJToast:show({ text = msg.sms_ack_msg.purchasecardorder_ack_msg.note, dimens = self.dimens_ })
                end
            end
        end
    end
end

return ChargeSZFSceneController