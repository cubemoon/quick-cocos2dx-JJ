--[[
定义服务端 ClientSw 的参数，以及提供获取是否打开的方法
]]

require("bit")
require("game.config.GlobalConfigManager")

ClientSwDef = {}

ClientSwDef.CLIENT_SW_REG_TYPE = 0x1; --是否支持手机号注册
ClientSwDef.CLIENT_SW_REALNAME_AUTHENTICATION_TYPE = 0x2; --实名认证

function ClientSwDef:IsThisSwOpen(input, flag)
    local open = false

    if (input and flag) then
        local val = bit.band(input, flag)
        open = val > 0
    end

    return open
end

function ClientSwDef:isClientSwOpen(packageid, flag)
    local open = false

    local clientsw = GlobalConfigManager:getConfigClientSW(packageid)
    --JJLog.i("ClientSwDef:isClientSwOpen",packageid,clientsw)
    if (clientsw) then
        open = self:IsThisSwOpen(clientsw, flag)
    end

    return open
end

return ClientSwDef
