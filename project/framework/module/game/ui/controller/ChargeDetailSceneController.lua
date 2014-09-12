
local ChargeDetailSceneController = class("ChargeDetailSceneController", require("game.ui.controller.JJGameSceneController"))

local TAG = "ChargeDetailSceneController"

require("game.pb.SMSMsg")
local UIUtil = require("game.ui.UIUtil")
local pcm = require("game.data.config.PayConfigManager")
local paramG10086 = {}

ChargeDetailSceneController.checkAlipayDialog_ = nil -- 检查是否存在支付宝插件
ChargeDetailSceneController.downloadAlipayDialog_ = nil -- 下载支付宝插件 
ChargeDetailSceneController.waitDialog_ = nil --下单等待对话框
ChargeDetailSceneController.cmccLoginDialog_ = nil --10086 sdk初始化等待对话框
ChargeDetailSceneController.payFailDialog_ = nil

local function _showcmccLoginDialog(self,flag)
    if flag then
        self.cmccLoginDialog_ = self.cmccLoginDialog_ or require("game.ui.view.ProgressDialog").new(self.theme_, self.dimens_,
            {
                text = "正在验证充值通道...",
                mask = false,
                onDismissListener = function() self.cmccLoginDialog_ = nil end
            })
        self.cmccLoginDialog_:setCanceledOnTouchOutside(false)
        self.cmccLoginDialog_:show(self.scene_)        
    elseif self.cmccLoginDialog_ then
        self.cmccLoginDialog_:dismiss()
        self.cmccLoginDialog_ = nil
    end   
end

local function _showWaitDialog(self,flag)
    if flag then
        self.waitDialog_ = self.waitDialog_ or require("game.ui.view.ProgressDialog").new(self.theme_, self.dimens_,
            {
                text = "正在生成订单，请稍候...",
                mask = false,
                onDismissListener = function() self.waitDialog_ = nil end
            })
        self.waitDialog_:setCanceledOnTouchOutside(false)
        self.waitDialog_:show(self.scene_)        
    elseif self.waitDialog_ then
        self.waitDialog_:dismiss()
        self.waitDialog_ = nil
    end   
end

local function _showIOSPayFailDialog(self)
    if self.payFailDialog_ == nil then
        self.payFailDialog_ = require("game.ui.view.AlertDialog").new({
            title = "提示",
            prompt = "订单失败，请重新购买，谢谢！",
            onDismissListener = function() self.payFailDialog_ = nil end,
            theme = self.theme_,
            dimens = self.dimens_,
        })

        self.payFailDialog_:setButton1("确定", function() self.payFailDialog_ = nil end)
        self.payFailDialog_:setCloseButton(function () end)
        self.payFailDialog_:setCanceledOnTouchOutside(false)
        self.payFailDialog_:show(self.scene_)
        return false
    end

    return true
end

local function _showDownloadAlipayDialog(self,flag)
    JJLog.i(TAG,"_showDownloadAlipayDialog",flag,self.downloadAlipayDialog_)
    if flag then
        self.downloadAlipayDialog_ = self.downloadAlipayDialog_ or require("game.ui.view.ProgressDialog").new(self.theme_, self.dimens_,
            {
                text = "正在下载，请稍候...",
                mask = false,
                onDismissListener = function() self.downloadAlipayDialog_ = nil end
            })
        self.downloadAlipayDialog_:setCanceledOnTouchOutside(false)
        self.downloadAlipayDialog_:show(self.scene_)        
    elseif self.downloadAlipayDialog_ then
        self.downloadAlipayDialog_:dismiss()
        self.downloadAlipayDialog_ = nil
    end   
end

--[[
    参数
    @params:
        @packageId: 
        @type:      充值类型  
        @amount:    充值数额
]]
function ChargeDetailSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    ChargeDetailSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

local function _downloadAlipay(self)
    _showDownloadAlipayDialog(self,true)
    PayDef:downloadAlipay()
end

-- 检查支付宝插件是否存在，并提示
local function _checkAlipay(self)
    if not PayDef:checkAlipayExist() and self.checkAlipayDialog_ == nil then
        self.checkAlipayDialog_ = require("game.ui.view.AlertDialog").new({
            title = "提示",
            prompt = "支付宝插件不存在，需要安装后才能进行支付，是否下载？",
            onDismissListener = function() self.checkAlipayDialog_ = nil end,
            theme = self.theme_,
            dimens = self.dimens_,
            backKey = true,
            backKeyClose = true,
        })

        self.checkAlipayDialog_:setButton1("下载", handler(self, _downloadAlipay))
        self.checkAlipayDialog_:setCloseButton(function () end)
        self.checkAlipayDialog_:setCanceledOnTouchOutside(false)
        self.checkAlipayDialog_:show(self.scene_)
        return false
    end

    return true
end

function ChargeDetailSceneController:onResume()
    JJLog.i(TAG,"onResume")
    local ret = ChargeDetailSceneController.super.onResume(self)
    if self.params_.type == PayDef.CHARGE_TYPE_ALIPAY then
        _checkAlipay(self)
    end
    return ret
end   

function ChargeDetailSceneController:onPause()
    JJLog.i(TAG,"onPause")
    ChargeDetailSceneController.super.onPause(self)
    _showDownloadAlipayDialog(self,false)
    _showcmccLoginDialog(self,false)
end 

function ChargeDetailSceneController:onDestory()
    _showWaitDialog(self,false);
    _showDownloadAlipayDialog(self,false);
    _showcmccLoginDialog(self,false)
    checkAlipayDialog_ = nil;
    payFailDialog_ = nil
end 

local function _doPay(self, msg)
    local ack = msg.sms_ack_msg.paycommonorder_ack_msg
    if self.params_.type == PayDef.CHARGE_TYPE_ALIPAY then
        PayDef:callAlipay(ack.param)
    elseif self.params_.type == PayDef.CHARGE_TYPE_UMPAY_EBANK then
        PayDef:callUMPayEBank(ack.param)
    elseif self.params_.type == PayDef.CHARGE_TYPE_UMPAY_SMS then
        PayDef:callUMPaySms(ack.param)
    elseif self.params_.type == PayDef.CHARGE_TYPE_WOVAC_SMS then
        PayDef:callWoVacSms(ack.param,ack.syncurl,ack.orderid,UserInfo.userId_)
    elseif self.params_.type == PayDef.CHARGE_TYPE_TELECOM_SMS then  
        PayDef:callTelecomSms(ack.param,ack.rmb/100,pcm:getMoneyByCost(self.params_.type,ack.rmb/100))
    elseif self.params_.type == PayDef.CHARGE_TYPE_G10086_SMS then
        if string.len(ack.param) == 0 then
            jj.ui.JJToast:show({
                text = "下单失败，请您稍后重试！",
                dimens = dimens,
            })
        else
            PayDef:callG10086Sms(ack.param)
        end
    elseif self.params_.type == PayDef.CHARGE_TYPE_EGAME_SMS or self.params_.type == PayDef.CHARGE_TYPE_EGAME_NORMAL then
        PayDef:callEgame(ack.param, ack.paytypeid, ack.rmb)
    end
end

-- 消息处理
function ChargeDetailSceneController:handleMsg(msg)
    ChargeDetailSceneController.super.handleMsg(self, msg)

    if msg.type == SDKMsgDef.TYPE_NET_MSG then
        if msg[MSG_CATEGORY] == SMS_ACK_MSG then
            if msg[MSG_TYPE] == PAY_COMMON_ORDER_ACK then
                JJLog.i(TAG, "PAY_COMMON_ORDER_ACK, param=", msg.param)
                _showWaitDialog(self,false)
                if msg.param == 0 then -- 下单成功，调用接口进行支付
                    _doPay(self, msg)
                else
                    PayDef:payCommonOrderFailPrompt(msg.param, self.dimens_)
                end
            elseif msg[MSG_TYPE] == PAY_IOS_ORDER_ACK then
                local ack = msg.sms_ack_msg.appleorder_ack_msg
                _showWaitDialog(self,false)
                if ack.ret and ack.ret == 0 then 
                    local className = "InAppRageIAPHelper"
                    local methodName = "postTransactionDataToServer"
                    local args = {orderid = ack.orderid, transactionid = ack.transactionid}
                    result = luaoc.callStaticMethod(className,methodName,args)                    
                else
                    _showIOSPayFailDialog(self)
                end
            end
        end
    elseif msg.type == GameMsgDef.ID_G10086_SDK_STATE_CHANGE then
        JJLog.i(TAG, "ID_G10086_SDK_STATUS_CHANGE", msg.status_)
        _showcmccLoginDialog(self,false)       
        if msg.status_ == PayDef.G10086_LOGIN_STATE_SUCCESS or msg.status_ == PayDef.G10086_LOGIN_STATE_FALLED then
            _showWaitDialog(self,true) 
            _payG10086Sms(self,paramG10086.amount,paramG10086.gold,paramG10086.schemeId,paramG10086.endMid)
        elseif msg.status_ == PayDef.G10086_LOGIN_STATE_WAIT then
            _showcmccLoginDialog(self,true) 
        else
            jj.ui.JJToast:show({
                text = "SDK初始化失败，请稍候再试。",
                dimens = dimens,
            })
        end
    end
end

-- 神州付移动卡
local function _paySZFCMCC(self, amount, gold, schemeId, endMid)
    JJLog.i(TAG, "_paySZFCMCC")
    MainController:pushScene(self.params_.packageId, JJSceneDef.ID_CHARGE_SZF, {
        packageId = self.params_.packageId,
        type = PayDef.CHARGE_TYPE_SZF_CMCC,
        amount = amount,
        gold = gold,
    })
end

-- 神州付联通卡
local function _paySZFUNICOM(self, amount, gold, schemeId, endMid)
    JJLog.i(TAG, "_paySZFUNICOM")
    MainController:pushScene(self.params_.packageId, JJSceneDef.ID_CHARGE_SZF, {
        packageId = self.params_.packageId,
        type = PayDef.CHARGE_TYPE_SZF_UNICOM,
        amount = amount,
        gold = gold,
    })
end

-- 支付宝
local function _payAlipay(self, amount, gold, schemeId, endMid)
    JJLog.i(TAG, "_payAlipay schemeId=",schemeId,"gold=",gold)
    if _checkAlipay(self) then
        _showWaitDialog(self,true) 
        SMSMsg:sendPayCommonOrderReq(UserInfo.userId_, gold/100, amount*100, PayDef.PW_AGENT_MALIPAY, PayDef.PW_ZONE_JJ_MOBILEGAME, PayDef.PW_TYPE_WEB_ACCOUNT, PayDef.PW_BANK_ALIPAY, "", PROMOTER_ID, PayDef:getPayGameId(), schemeId, endMid)
    end
end

-- 联动优势网银, 话付宝
local function _payUMPayEBank(self, amount, gold, schemeId, endMid)
    JJLog.i(TAG, "_payUMPayEBank")
    SMSMsg:sendPayCommonOrderReq(UserInfo.userId_, gold/100, amount*100, PayDef.PW_AGENT_LIANDONGYOUSHI, PayDef.PW_ZONE_JJ_MOBILEGAME, PayDef.PW_TYPE_NET_BANK, PayDef.PW_BANK_UMPAY, "", PROMOTER_ID, PayDef:getPayGameId(), schemeId, endMid)
end

--联动优势短代,话付宝
local function _payUMPaySms(self, amount, gold, schemeId, endMid)
    JJLog.i(TAG, "_payUMPaySms")
    SMSMsg:sendPayCommonOrderReq(UserInfo.userId_, gold/100, amount*100, PayDef.PW_AGENT_LIANDONGYOUSHI, PayDef.PW_ZONE_JJ_MOBILEGAME,PayDef.PW_TYPE_SMS, PayDef.PW_BANK_HUAFUBAO, "", PROMOTER_ID, PayDef:getPayGameId(), schemeId, endMid)
end

--联通沃商店短信
local function _payWoVacSms(self, amount, gold, schemeId, endMid)
    JJLog.i(TAG,"_payWoVacSms")
    SMSMsg:sendPayCommonOrderReq(UserInfo.userId_, gold/100, amount*100, PayDef.PW_AGENT_WOVAC, PayDef.PW_ZONE_JJ_MOBILEGAME,PayDef.PW_TYPE_WEB_ACCOUNT, PayDef.PW_BANK_WOVAC, "", PROMOTER_ID, PayDef:getPayGameId(), schemeId, endMid)
end

--电信SP空间畅想短代
local function _payTelecomSms(self, amount, gold, schemeId, endMid)
    JJLog.i(TAG,"_payTelecomSms")
    SMSMsg:sendPayCommonOrderReq(UserInfo.userId_, gold/100, amount*100, PayDef.PW_AGENT_KONGJIANCHANGXIANG, PayDef.PW_ZONE_JJ_MOBILEGAME,PayDef.PW_TYPE_SMS, PayDef.PW_BANK_KONGJIANCHANGXIANG, "", PROMOTER_ID, PayDef:getPayGameId(), schemeId, endMid)
end

--电信爱游戏短代
local function _payEgameSMS(self, amount, gold, schemeId, endMid)
    JJLog.i(TAG,"_payEgameSMS")
    SMSMsg:sendPayCommonOrderReq(UserInfo.userId_, gold/100, amount*100, PayDef.PW_AGENT_EGAME, PayDef.PW_ZONE_JJ_MOBILEGAME,PayDef.PW_TYPE_SMS, PayDef.PW_BANK_CT, "", PROMOTER_ID, PayDef:getPayGameId(), schemeId, endMid)
end

--电信爱游戏充值卡
local function _payEgameNormal(self, amount, gold, schemeId, endMid)
    JJLog.i(TAG,"_payEgameNormal")
    SMSMsg:sendPayCommonOrderReq(UserInfo.userId_, gold/100, amount*100, PayDef.PW_AGENT_EGAME, PayDef.PW_ZONE_JJ_MOBILEGAME,PayDef.PW_TYPE_WEB_ACCOUNT, PayDef.PW_BANK_CT, "", PROMOTER_ID, PayDef:getPayGameId(), schemeId, endMid)
end

--移动游戏基地短信(SDK方式)
local function _payG10086Sms(self,amount,gold,schemeId,endMid)
    JJLog.i(TAG,"_payG10086Sms")
    local status = PayDef:getG10086LoginState()
    --sdk登陆失败时，请求充值会走充值策略5,仍需先下订单
    if status == PayDef.G10086_LOGIN_STATE_SUCCESS or status == PayDef.G10086_LOGIN_STATE_FALLED then
        _showWaitDialog(self,true)         
        SMSMsg:sendPayCommonOrderReq(UserInfo.userId_, gold/100, amount*100, PayDef.PW_AGENT_CMCC_GAME*10, PayDef.PW_ZONE_JJ_MOBILEGAME,PayDef.PW_TYPE_SMS, PayDef.PW_BANK_CMCC, "", PROMOTER_ID, PayDef:getPayGameId(), schemeId, endMid)
    else   
        paramG10086.amount = amount
        paramG10086.gold = gold
        paramG10086.schemeId = schemeId
        paramG10086.endMid = endMid 
        if status == PayDef.G10086_LOGIN_STATE_NONE then  
            PayDef.initG10086Sdk()
        else
            --wait
            _showcmccLoginDialog(self,true)
        end
    end
end

-- ios 充值
local function _payIOS(self, amount, gold, schemeId, endMid)
    local className = "InAppRageIAPHelper"
    local methodName = "buyProductIdentifier"
    local args = {product = schemeId, userid = UserInfo.userId_,}
    result = luaoc.callStaticMethod(className,methodName,args)    
    methodName = "registerScriptTransactionHandler"
    local function callbackTransaction(result)
        _showWaitDialog(self,false)
        if result.state == 2 then
            local dialog = require("game.ui.view.AlertDialog").new({
                title = "Error",
                prompt = result.errorString,
                -- onDismissListener = dismissCB,
                theme = self.theme_,
                dimens = self.dimens_,
            })
            dialog:setCanceledOnTouchOutside(true)
            dialog:show(self.scene_)                  
        end
    end
    local args = {
            TransactionListener = callbackTransaction,
        }
    local ok, ret = luaoc.callStaticMethod(className,methodName,args)

    local methodName = "registerScriptSendMsgHandler"
    local function callbackSendMsg(result)
        _showWaitDialog(self,false);
        if result ~= nil then    
            SMSMsg:sendAppleOrderReq(result.productid, result.transactionid, result.receiptdata, result.purchasedata, tostring(UserInfo.userId_))
        end
    end
    local args = {
            sendListener = callbackSendMsg,
        }
    local ok, ret = luaoc.callStaticMethod(className,methodName,args)

    local className = "InAppRageIAPHelper"
    local methodName = "registerScriptSaveDataHandler"
    local function callbacksaveData(data)
        _showWaitDialog(self,false)
        if data then
            local tempPath = string.format("data.charge.%s",tostring(data.transactionid))
            package.loaded[tempPath] = nil                    
        end
        local path = string.format("data/charge/%s.lua", tostring(data.transactionid))
        data.userid = tostring(UserInfo.userId_)                
        LuaDataFile.save(data, path)    
        return true
    end
    local args = {
            saveDataListener = callbacksaveData,
        }
    local ok, ret = luaoc.callStaticMethod(className,methodName,args)

    methodName = "registerScriptGetDataHandler"
    local function callbackgetata(result)
        _showWaitDialog(self,false)
        if result and result.path then
            local path = string.format("data/charge/%s.lua", tostring(result.path))
            local data = LuaDataFile.get(path)
            if data then
                local className = "InAppRageIAPHelper"
                local methodName = "getDataFromLua"
                local args = data
                result = luaoc.callStaticMethod(className,methodName,args)    

            else
                local className = "InAppRageIAPHelper"
                local methodName = "getDataFromLua"
                local args = {}
                result = luaoc.callStaticMethod(className,methodName,args)
            end
        end
    end
    local args = {
            getDataListener = callbackgetata,
        }
    local ok, ret = luaoc.callStaticMethod(className,methodName,args)  
end

-- 充值方式对应的处理函数
local FUNCTION_ = {}
FUNCTION_[PayDef.CHARGE_TYPE_SZF_CMCC] = _paySZFCMCC
FUNCTION_[PayDef.CHARGE_TYPE_SZF_UNICOM] = _paySZFUNICOM
FUNCTION_[PayDef.CHARGE_TYPE_ALIPAY] = _payAlipay
FUNCTION_[PayDef.CHARGE_TYPE_UMPAY_EBANK] = _payUMPayEBank
FUNCTION_[PayDef.CHARGE_TYPE_UMPAY_SMS] = _payUMPaySms
FUNCTION_[PayDef.CHARGE_TYPE_WOVAC_SMS] = _payWoVacSms
FUNCTION_[PayDef.CHARGE_TYPE_TELECOM_SMS] = _payTelecomSms
FUNCTION_[PayDef.CHARGE_TYPE_IOS] = _payIOS
FUNCTION_[PayDef.CHARGE_TYPE_G10086_SMS] = _payG10086Sms
FUNCTION_[PayDef.CHARGE_TYPE_EGAME_SMS] = _payEgameSMS
FUNCTION_[PayDef.CHARGE_TYPE_EGAME_NORMAL] = _payEgameNormal
    
local function _waitDialogEnable(type)
    return type ~= PayDef.CHARGE_TYPE_SZF_CMCC and type ~= PayDef.CHARGE_TYPE_SZF_UNICOM 
            and type ~= PayDef.CHARGE_TYPE_ALIPAY and type ~= PayDef.CHARGE_TYPE_G10086_SMS
end    

-- 选择充值多少钱
function ChargeDetailSceneController:onSelectPay(amount, gold, schemeId, endMid)
    print(TAG, "onSelectPay, amount=", amount, ", gold=", gold, ", schemeId=", schemeId, ", endMid=", endMid, ", type=",self.params_.type)
    local func = FUNCTION_[self.params_.type]
    if func then    
        if _waitDialogEnable(self.params_.type) then
            _showWaitDialog(self,true) 
        end
        func(self, amount, gold, schemeId, endMid)
    end
end
--是否显示资费说明
function ChargeDetailSceneController:displayAlertPay()
    --资费说明界面设计UI修改，产品决定先不添加
    return false       
end    

function ChargeDetailSceneController:onClickAlertPay() 
    MainController:pushScene(self.params_.packageId, JJSceneDef.ID_CMCC_DIANSHU)
end

return ChargeDetailSceneController