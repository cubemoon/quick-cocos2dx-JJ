local PayConfigManager = {}
local TAG = "PayConfigManager"

require("bit")
require("game.def.PayDef")

local payconfig_ = {} -- 充值配置
local DATA_PATH = "data/PayConfig.lua"
local displayParam_ = {} -- 过滤后的显示内容


local function _save()
    LuaDataFile.save(payconfig_, DATA_PATH)
end

local function _isSmsType(type)
    return type == PayDef.CHARGE_TYPE_TELECOM_SMS or type == PayDef.CHARGE_TYPE_EGAME_SMS or type == PayDef.CHARGE_TYPE_UMPAY_SMS 
        or type == PayDef.CHARGE_TYPE_G10086_SMS or type == PayDef.CHARGE_TYPE_WOVAC_SMS
end

local function _insort(type)
    return (bit.band(payconfig_.insort, type) ~= 0)
end 

local function _display(self, type)
    return self:support(type) and not _insort(type)
end

local function _initDisplayParam(self)
    JJLog.i(TAG, "_initDisplayParam")
    displayParam_ = {}
    local smsPayType = self:getSmsPayType()

    if payconfig_.paysort ~= nil and type(payconfig_.paysort) == "table" then
        for _, k in ipairs(payconfig_.paysort) do     
            if self:support(k) then
                if not _isSmsType(k) or k == smsPayType then
                    displayParam_[#displayParam_ + 1] = k
                end
            end 
        end
    end
    -- 先判断短代
    if not _insort(smsPayType) and smsPayType ~= PayDef.CHARGE_TYPE_NONE then
        displayParam_[#displayParam_ + 1] = smsPayType
    end

    -- 支付宝
    if _display(self, PayDef.CHARGE_TYPE_ALIPAY) then
        displayParam_[#displayParam_ + 1] = PayDef.CHARGE_TYPE_ALIPAY
    end

    -- 银联
    if _display(self, PayDef.CHARGE_TYPE_UMPAY_EBANK) then
        displayParam_[#displayParam_ + 1] = PayDef.CHARGE_TYPE_UMPAY_EBANK
    end

    -- 其他充值
    if _display(self, PayDef.CHARGE_TYPE_OTHER) then
        displayParam_[#displayParam_ + 1] = PayDef.CHARGE_TYPE_OTHER
    end

    -- 神州行充值卡
    if _display(self, PayDef.CHARGE_TYPE_SZF_CMCC) then
        displayParam_[#displayParam_ + 1] = PayDef.CHARGE_TYPE_SZF_CMCC
    end

    -- 联通充值卡
    if _display(self, PayDef.CHARGE_TYPE_SZF_UNICOM) then
        displayParam_[#displayParam_ + 1] = PayDef.CHARGE_TYPE_SZF_UNICOM
    end

    dump(displayParam_)
end

function PayConfigManager:init()
    -- 读出配置文件
    payconfig_ = LuaDataFile.get(DATA_PATH)
    if payconfig_ == nil then
        payconfig_ = {}
        payconfig_.paysort = {}
        payconfig_.items = {}
        payconfig_.insort = 0
        payconfig_.timestamp = 0
        payconfig_.paytype = 0
        _save()
    end

    if payconfig_.paysort == nil then
        payconfig_.paysort = {}
        payconfig_.insort = 0
    end

    --检测本地数据是否正确，通过paytype检测
    if payconfig_.paytype ~= nil and payconfig_.paytype > 0 then
        if payconfig_.items == nil or #payconfig_.items < 3 then
            payconfig_.timestamp = 0
            payconfig_.items = {}
        end
    end 

    _initDisplayParam(self)
end

function PayConfigManager:getTimeStamp()
    return payconfig_.timestamp
end

-- 是否支持这种类型的充值
function PayConfigManager:support(type)
    if payconfig_.paytype ~= nil then
        return (bit.band(payconfig_.paytype, type) ~= 0)
    end
    return false
end
  
--将优先排序的方式存储起来
local function _decodPaysort(sort)
    local insort = 0 
    for _,k in ipairs(sort) do
        insort = bit.bor(insort,k)
    end
    return insort
end 

function PayConfigManager:updateData(data)
    -- body
    JJLog.i(TAG, "updateData")
    for _,src in ipairs(data) do
        local isExist = false
        if payconfig_.items ~= nil then
            for i,tar in ipairs(payconfig_.items) do
                if src.payid == tar.payid then
                    payconfig_.items[i] = src
                    isExist = true
                    break
                end
            end
        end

        if not isExist then
            table.insert(payconfig_.items,src)
        end
    end 
end     

-- 保存从网络上同步下来的充值配置
function PayConfigManager:save(time, paytype, paysort, data)
    JJLog.i(TAG, "save")
    payconfig_.timestamp = time
    payconfig_.paytype = paytype

    if paysort ~= nil and type(paysort) == "table" then
        payconfig_.paysort =  paysort
        payconfig_.insort = _decodPaysort(paysort)
    end

    if data ~= nil and #data > 0 then
        JJLog.i(TAG, "save data",vardump(data))
        --增量更新
        self:updateData(data)
    end       

    _save()
    _initDisplayParam(self)
end

function PayConfigManager:saveIOSConfig(data)
    if data ~= nil and #data > 0 then
        local fileData = {}
        local retData = {}
        for k, value in pairs(data) do
            value["dwECASchemeID"] = value.product_id
            value["dwEndMID"] = 1
            value["cost"] = tonumber(value.cost)/1000
            table.insert(retData, value)
        end        
        table.sort(retData, function(a, b)
            if a.sort ~= nil then
            return tonumber(a.sort) < tonumber(b.sort)
            end
            end)
        fileData["money"] = retData
        LuaDataFile.save(fileData, DATA_PATH)
    end
end

function PayConfigManager:getIOSPayConfig()
    return LuaDataFile.get(DATA_PATH)
end

-- 获取充值显示的配置
function PayConfigManager:getDisplayParam()
    return displayParam_
end

-- 是否支持充值
function PayConfigManager:canCharge()
    return (#displayParam_ > 0)
end

-- 获取该充值类型的充值配置
function PayConfigManager:getPayConfig(type)
    if payconfig_.items == nil then
        return nil
    end

    for k,v in pairs(payconfig_.items) do
        if v.payid == type then
            return v
        end
    end

    return nil
end

function PayConfigManager:getPayConfigByCost(type,cost)
    JJLog.i(TAG,"getPayConfigByCost type = ",type," cost = ",cost)
    local config = self:getPayConfig(type)
    JJLog.i(TAG,"getPayConfigByCost config = ",config)
    if config ~= nil then
        for i,v in ipairs(config.money) do
            JJLog.i(TAG,"getPayConfigByCost cost = ",v.cost)            
            if tonumber(cost) == tonumber(v.cost) then
                return v
            end
        end
    end
    return nil
end

function PayConfigManager:getMoneyByCost(type,cost)
    local money = self:getPayConfigByCost(type,cost)
    if money ~= nil and money.money ~= nil then
        return money.money
    else
        return 0        
    end
end 

function PayConfigManager:getSmsPayType()
    local type = PayDef.CHARGE_TYPE_NONE
        if Util:isCTSim() then
            if self:support(PayDef.CHARGE_TYPE_TELECOM_SMS) then
                type = PayDef.CHARGE_TYPE_TELECOM_SMS
            elseif self:support(PayDef.CHARGE_TYPE_EGAME_SMS) and Util:isEgame() then
                type = PayDef.CHARGE_TYPE_EGAME_SMS
            end
        elseif Util:isCMSim() then
            if self:support(PayDef.CHARGE_TYPE_UMPAY_SMS) then
                type = PayDef.CHARGE_TYPE_UMPAY_SMS
            elseif self:support(PayDef.CHARGE_TYPE_G10086_SMS) and Util:isG10086() then
                type = PayDef.CHARGE_TYPE_G10086_SMS
            end
        elseif Util:isCUSim() then
            if self:support(PayDef.CHARGE_TYPE_WOVAC_SMS) then
                type = PayDef.CHARGE_TYPE_WOVAC_SMS
            end
        end
    JJLog.i(TAG,"getSmsPayType type = "..type)
    return type
end

function PayConfigManager:getCount()
    JJLog.i(TAG,"count = ",#displayParam_)
    return #displayParam_
end

function PayConfigManager:getParam()
    return displayParam_
end    

return PayConfigManager