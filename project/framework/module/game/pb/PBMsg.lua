PBMsg = {}

local TAG = "[PBMsg]"
local connectManager = require("sdk.connect.ConnectManager")
local pb = require("sdk.pb.protobuf")
local nSize = 1
local bytebuffer, nSize = CCFileUtils:sharedFileUtils():getFileData("pb/TKMobile.pb", "rb", nSize)
if (bytebuffer ~= nil) then
    echoInfo("PBMsg, bytebuffer ~= nil, nSize=" .. nSize)
    bytebuffer = string.sub(bytebuffer, 1, nSize)
    pb.register(bytebuffer)
    JJLog.i("PBMsg, after register, err=" .. pb.lasterror())
else
    JJLog.i("PBMsg, bytebuffer == nil")
end

function PBMsg:encode(msg)
	JJLog.i(TAG, vardump(msg, "msg"))
	return pb.encode("cn.jj.service.msg.protocol.TKMobileReqMsg", msg)
end

function PBMsg:decode(buf, len)
	local msg, err = pb.decode("cn.jj.service.msg.protocol.TKMobileAckMsg", buf, len)
	if (msg == false) then
		JJLog.i(TAG, "decode, err=" .. err)
		msg = nil
	end
	return msg
end


MSG_CATEGORY = 1
MSG_TYPE = 2
--消息定义
UNKNOWN_ACK_MSG = 0 	--未知类型
LOBBY_ACK_MSG = 1      	-- 大厅消息 
MATCH_ACK_MSG = 2      	--比赛消息
LORD_ACK_MSG = 3   		--斗地主消息
POKER_ACK_MSG = 4 		--德州消息
TOURNEY_ACK_MSG = 5 	--tourney 消息  
MOBILEAGENT_ACK_MSG = 6 --手机自身服务器消息
SMS_ACK_MSG = 7  		--充值消息
HTTP_ACK_MSG = 8  		--http消息
CONFIG_ACK_MSG = 9  	--配置消息
MATCHINFO_ACK_MSG = 10 	  --matchinfo 消息
MAHJONG_ACK_MSG = 11 	  --四人麻将消息
MAHJONGTP_ACK_MSG = 12    --二人麻将消息
ECASERVICE_ACK_MSG = 13   --合成炉消息
HLLORD_ACK_MSG = 14       --欢乐斗地主	
MATCHVIEW_ACK_MSG = 15    --比赛消息
PKLORD_ACK_MSG = 16  	  --二斗消息
HBASE_ACK_MSG = 17   	  --hbase库消息
THREECARD_ACK_MSG = 18    --赢三张消息
LZLORD_ACK_MSG = 19
NIUNIU_ACK_MSG = 20
MAHJONGBR_ACK_MSG = 21
MAHJONGSC_ACK_MSG = 22
MAHJONGPUBLIC_ACK_MSG = 23
INTERIM_ACK_MSG = 24	--卡当消息
RUNFAST_ACK_MSG = 25	--跑得快消息
MAHJONGTDH_ACK_MSG = 26	--推倒胡麻将消息
