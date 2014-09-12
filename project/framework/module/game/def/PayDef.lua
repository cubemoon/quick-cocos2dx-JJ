PayDef = {}
local TAG = "PayDef"

-- 这段是客户端定义的
PayDef.CHARGE_TYPE_NONE = 0x00
-- PayDef.CHARGE_TYPE_SMS = 0x01
PayDef.CHARGE_TYPE_SZF = 0x02 -- 2 第二位 神州付移动卡
PayDef.CHARGE_TYPE_ALIPAY = 0x04 -- 4 第三位 支付宝
PayDef.CHARGE_TYPE_EGAME = 0x08 -- 8 第四位 电信EGAME
PayDef.CHARGE_TYPE_G10086_SMS_API = 0x10 -- 16 第五位 移动游戏基地短信
PayDef.CHARGE_TYPE_WOVAC_SMS = 0x20 -- 32 第六位 联通沃商店短信
PayDef.CHARGE_TYPE_SZF_CMCC = 0x40 -- 64 第7位 神州付移动卡
PayDef.CHARGE_TYPE_SZF_UNICOM = 0x80 -- 128 第8位 神州付联通卡
PayDef.CHARGE_TYPE_EGAME_SMS = 0x0100 -- 256 第9位 电信EGAME短信
PayDef.CHARGE_TYPE_EGAME_NORMAL = 0x0200 -- 512 第10位电信EGAME
PayDef.CHARGE_TYPE_UMPAY_SMS = 0x0400 -- 1024 第11位 联动优势短代
PayDef.CHARGE_TYPE_UMPAY_EBANK = 0x0800 -- 2048 第12位联动优势网银
PayDef.CHARGE_TYPE_TELECOM_SMS = 0x1000 -- 4096第13位电信SP空间畅想短代
PayDef.CHARGE_TYPE_OTHER = 0x2000 -- 8192 14位 其他
PayDef.CHARGE_TYPE_G10086_SMS= 0x4000 -- 16384第15位移动游戏基地短信(SDK方式)
PayDef.CHARGE_TYPE_IOS= 0x8000 -- IOS 平台充值

-- 这段是服务器定义的
-- 预置用户 ID
PayDef.PW_AGENT_MALIPAY = 1025 -- 支付宝
PayDef.PW_AGENT_CMCC_GAME = 1027 -- 移动
PayDef.PW_AGENT_EGAME = 1028 -- 电信
PayDef.PW_AGENT_WOVAC = 1032 -- 联通
PayDef.PW_AGENT_LIANDONGYOUSHI = 1005 -- 联通优势
PayDef.PW_AGENT_KONGJIANCHANGXIANG = 1034 -- 空间畅想

-- 充值类型
PayDef.PW_TYPE_NET_BANK = 1001 -- 网银
PayDef.PW_TYPE_WEB_ACCOUNT = 1002 -- 外部网站账户
PayDef.PW_TYPE_SMS = 1003 -- 短信代收费
PayDef.PW_TYPE_MOBILE_RECHARGE_CARD = 1004 -- 手机充值卡
PayDef.PW_TYPE_GAME_CARD = 1005 -- 游戏点卡
PayDef.PW_TYPE_PHONE = 1006 -- 声讯充值
PayDef.PW_TYPE_PHONE_BANK = 1007 -- 电话银行
PayDef.PW_TYPE_ISP = 1008 -- 网络供应商代收
PayDef.PW_TYPE_MIN = PW_TYPE_NET_BANK
PayDef.PW_TYPE_MAX = PW_TYPE_ISP

-- 充值区域
PayDef.PW_ZONE_JJ = 1001 -- JJ主充值区
PayDef.PW_ZONE_JJ_WEBGAME = 2001 -- JJ网页游戏充值区
PayDef.PW_ZONE_JJ_MOBILEGAME = 2002 -- JJ手机游戏充值区
PayDef.PW_ZONE_JJ_BAIDU = 3001 -- JJ-百度联运充值区
PayDef.PW_ZONE_JJ_UMPAY = 3002 -- JJ-联动优势联运充值区
PayDef.PW_ZONE_JJ_KUAIWAN = 3003 -- JJ-快玩联运充值区
PayDef.PW_ZONE_JJ_RENREN = 3004 -- JJ-人人游戏联运
PayDef.PW_ZONE_JJ_HAOLIANLUO = 3005 -- JJ-数字天域联运

-- 充值子类型
PayDef.PW_BANK_ICBC = 1101 -- 工商银行
PayDef.PW_BANK_ABC = 1102 -- 农业银行
PayDef.PW_BANK_BOC = 1103 -- 中国银行
PayDef.PW_BANK_CCB = 1104 -- 建设银行
PayDef.PW_BANK_BOCO = 1105 -- 交通银行
PayDef.PW_BANK_CMBCHINA = 1111 -- 招商银行
PayDef.PW_BANK_CMBC = 1112 -- 民生银行
PayDef.PW_BANK_SPDB = 1213 -- 浦发银行
PayDef.PW_BANK_CIB = 1214 -- 兴业银行
PayDef.PW_BANK_HXB = 1215 -- 华夏银行
PayDef.PW_BANK_ECITIC = 1216 -- 中信银行
PayDef.PW_BANK_CEB = 1217 -- 光大银行
PayDef.PW_BANK_SDB = 1218 -- 深圳发展银行
PayDef.PW_BANK_BCCB = 1219 -- 北京银行
PayDef.PW_BANK_ALIPAY = 1301 -- 支付宝
PayDef.PW_BANK_BAIDU = 1302 -- 百度
PayDef.PW_BANK_KUAIWAN = 1303 -- 快玩
PayDef.PW_BANK_RENREN = 1304 -- 人人
PayDef.PW_BANK_CMCC = 1401 -- 中国移动
PayDef.PW_BANK_UNICOM = 1402 -- 中国联通
PayDef.PW_BANK_CT = 1403 -- 中国电信
PayDef.PW_BANK_JUNNET = 1501 -- 骏网
PayDef.PW_BANK_QQ = 1502 -- 腾讯
PayDef.PW_BANK_SHENGDA = 1503 -- 盛大
PayDef.PW_BANK_ZHENGTU = 1504 -- 征途
PayDef.PW_BANK_VNETONE = 1601 -- 网盈一卡通
PayDef.PW_BANK_JJ = 1505 -- 竞技世界
PayDef.PW_BANK_BANK = 1100 -- 银行
PayDef.PW_BANK_WOVAC = 1402 -- wovac
PayDef.PW_BANK_HUAFUBAO = 1314 -- 联动优势话付宝
PayDef.PW_BANK_UMPAY = 1315 -- 联动优势网银
PayDef.PW_BANK_KONGJIANCHANGXIANG = 1316 -- 电信SP空间畅想


PayDef.ALIPAY_VERSION = "version"
PayDef.ALIPAY_PARTNER = "partner"
PayDef.ALIPAY_ACTION = "action"
PayDef.ALIPAY_UPDATE = "update"
PayDef.ALIPAY_DATA = "data"
PayDef.ALIPAY_PLATFORM = "platform"

PayDef.ALIPAY_DOWNLOAD_URL = "https://msp.alipay.com/x.htm"

PayDef.G10086_LOGIN_STATE_NONE = -1
PayDef.G10086_LOGIN_STATE_WAIT = 0
PayDef.G10086_LOGIN_STATE_FALLED = 1
PayDef.G10086_LOGIN_STATE_SUCCESS = 2

--[[
    根据当前 GameId 获取需要发送的充值游戏类型
    - 大厅使用斗地主的
    - 斗地主合集包使用斗地主的
    - 二斗使用斗地主的
    - 赖斗使用斗地主的
    - 欢斗使用斗地主的
]]
function PayDef:getPayGameId()

    local gameId = MainController:getCurPackageId()
    if gameId == JJGameDefine.GAME_ID_LORD_UNION or gameId == JJGameDefine.GAME_ID_HALL  then
        gameId = JJGameDefine.GAME_ID_LORD
    elseif gameId == JJGameDefine.GAME_ID_LORD_UNION_HL then
        gameId = JJGameDefine.GAME_ID_LORD_HL
    end
    return gameId
end

--[[
    下单失败的提示
    10000 10001 11002 11003 -11003 11006 11007 -10001
        系统繁忙,请稍后再试。（错误码）
    11004 11005 -10004 -1
        亲，订单获取失败，绿色游戏，健康生活，过会儿再来试试吧。（错误码）
]]
function PayDef:payCommonOrderFailPrompt(param, dimens)
    JJLog.i(TAG, "payCommonOrderFailPrompt, param=", param)
    local str = "系统繁忙,请稍后再试。（" .. param .. "）"
    if param == 4294967295 then
        param = -1
    elseif param == 54532 then
        param = -11004
    end
    if param == 11004 or param == 11005 or param == -11004 or param == -1 then --因为目前参数为uint，所以特殊处理下-1和-11004
        str = "亲，订单获取失败，绿色游戏，健康生活，过会儿再来试试吧。（" .. param .. "）"
    end

    jj.ui.JJToast:show({
        text = str,
        dimens = dimens,
    })
end

--[[
    检查支付宝是否存在
]]
function PayDef:checkAlipayExist()
    local result, exist = false, false
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "gameExist"
        args = {"com.alipay.android.app"}
        sig = "(Ljava/lang/String;)Z"
        result, exist = luaj.callStaticMethod(className, methodName, args, sig)
    end
    return exist
end

--[[
    支付宝下载和安装
]]
function PayDef:downloadAlipay()
    JJLog.i(TAG, "downloadAlipay")
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "downloadAlipay"
        args = {}
        sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    end
end

--[[
    调用支付宝充值接口
]]
function PayDef:callAlipay(param)
    JJLog.i(TAG, "callAlipay, param=", param)
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "payAlipay"
        args = {param}
        sig = "(Ljava/lang/String;)V"
        result, version = luaj.callStaticMethod(className, methodName, args, sig)
    end
end

--[[
    调用话付宝接口
]]
function PayDef:callUMPayEBank(param)
    JJLog.i(TAG, "callUMPayEBank, param=", param)
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "payUMPayEBank"
        args = {param}
        sig = "(Ljava/lang/String;)V"
        result, version = luaj.callStaticMethod(className, methodName, args, sig)
    end
end

--[[
    调用联动优势短代接口
]]
function PayDef:callUMPaySms(param)
    -- body
    JJLog.i(TAG, "callUMPaySms param = ",param)
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "payUMPaySms"
        args = {param}
        sig = "(Ljava/lang/String;)V"
        result, model = luaj.callStaticMethod(className, methodName, args, sig)
    JJLog.i(TAG, "result = ",result,"model = ",model)       
    elseif not device.platform == "windows" then
        
    end
end 

function PayDef:callWoVacSms(param,syncurl,orderid,userid)
    -- body
    JJLog.i(TAG, "callWoVacSms userid =",userid," param = ",param," syncurl = ",syncurl,"orderid = ",orderid)
    local JJGameUtil = require("game.util.JJGameUtil")
        name = JJGameUtil:getGameName(self:getPayGameId())
        JJLog.i(TAG,name)
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "payWoVacSms"
        args = {param,syncurl,orderid,JJGameUtil:getGameName(self:getPayGameId()),userid}
        sig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
        result, model = luaj.callStaticMethod(className, methodName, args, sig)
    JJLog.i(TAG, "result = ",result,"model = ",model)       
    elseif not device.platform == "windows" then
        
    end
end

function PayDef:callTelecomSms(param,rmb,amount)
    -- body
    JJLog.i(TAG, "callTelecomSms param = ",param," rmb = ",rmb," amount =",amount)
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "payTelecomSms"
        args = {param,rmb,amount}
        sig = "(Ljava/lang/String;II)V"
        result, model = luaj.callStaticMethod(className, methodName, args, sig)
    JJLog.i(TAG, "result = ",result,"model = ",model)       
    elseif not device.platform == "windows" then
        
    end
end

function PayDef:initG10086Sdk()
    if device.platform == "android" then
        --none状态才初始化,java层控制
        JJLog.i(TAG, "initG10086Sdk")
        className = "cn/jj/base/JJUtil"
        methodName = "initG10086Sdk"
        local function callback(status)
            JJLog.i(TAG, "sdkStatusChangeListener status =",status)
            local msg = G10086SDKInitResultMsg.new()
            msg.status_ = tonumber(status)
            JJSDK:pushMsgToSceneController(msg)
        end
        args = {callback}
        sig = "(I)V"
        result, state = luaj.callStaticMethod(className, methodName, args, sig)
        JJLog.i(TAG, "result = ",result,"state=",state)    
    elseif not device.platform == "windows" then
        
    end   
end    

function PayDef:getG10086LoginState()
 if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "get10086SdkStatus"
        args = {}
        sig = "()I"
        result, state = luaj.callStaticMethod(className, methodName, args, sig)
    JJLog.i(TAG, "getG10086LoginState result = ",result,"state = ",state)       
    elseif not device.platform == "windows" then
        
    end 

    if result then
        return state
    end  
    return nil
end 

function PayDef:getG10086IsMusicEnabled()
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "get10086IsMusicEnabled"
        args = {}
        sig = "()Z"
        result, enable = luaj.callStaticMethod(className, methodName, args, sig)
        JJLog.i(TAG, "getG10086IsMusicEnabled result = ",result,"enable = ",enable)       
    elseif not device.platform == "windows" then
        
    end 
 
    if result then
        return enable
    end  
    return true --默认打开声音
end  

function PayDef:callG10086Sms(param)
    JJLog.i(TAG, "callG10086Sms param = ",param)
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "callG10086Sms"
        args = {param}
        sig = "(Ljava/lang/String;)V"
        result, state = luaj.callStaticMethod(className, methodName, args, sig)
    JJLog.i(TAG, "result = ",result,"state = ",state)       
    elseif not device.platform == "windows" then
        
    end 

    if result then
        return status
    end  
    return nil    
end

function PayDef:callEgame(param, payType, amount)
    JJLog.i(TAG, "callEgame param = ", param)
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "callEgame"
        args = {param, payType, amount}
        sig = "(Ljava/lang/String;II)V"
        result, state = luaj.callStaticMethod(className, methodName, args, sig)
        JJLog.i(TAG,"result = ",result, "state = ",state)
    elseif not device.platform == "windows" then

    end
end


function PayDef:chargeBtnHandler(param)
    local pkId = MainController:getCurPackageId()
    if device.platform == "ios" or device.platform == "mac" then
        MainController:pushScene(pkId, JJSceneDef.ID_CHARGE_DETAIL, {
            packageId = pkId,
            type = PayDef.CHARGE_TYPE_IOS,
        })
    elseif param ~= nil and #param == 1 then
         MainController:pushScene(pkId, JJSceneDef.ID_CHARGE_DETAIL, {
            packageId = pkId,
            type = param[1],
        })           
    else
        MainController:pushScene(pkId, JJSceneDef.ID_CHARGE_SELECT)
    end
end

return PayDef