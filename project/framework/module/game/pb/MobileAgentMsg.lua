-- MobileAgent 消息
MobileAgentMsg = {}

require("game.pb.SendMsg")

local function _getTKMobileReq()
    local msg = {}
	return msg
end

local function _getMobileAgentReq()
	local msg = _getTKMobileReq()
	msg.mobileagent_req_msg = {}
	return msg
end

function MobileAgentMsg:sendPhoneInfoReq(gameId)
    local platform_ = device.platform
    if platform_ == "mac" or platform_ == "windows" then
        platform_ = "android"
    end
    
    local msg = _getMobileAgentReq()
    msg.mobileagent_req_msg.phoneinfo_req_msg = {
        imei = Util:getIMEI(),
        promoter = PROMOTER_ID,
        appver = Util:getVersionName(),
        sysver = CCNative:getSysVersion(),
        model = device.model,
        gameid = gameId,
        platform = platform_,
        carrier = Util:getOperator(),
        nettype = Util:getNetworkName(),
        imsi = Util:getIMSI(),
    }
    SendMsg:send(msg)
end

return MobileAgentMSg