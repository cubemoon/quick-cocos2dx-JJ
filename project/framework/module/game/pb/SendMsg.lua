--发送消息模块
SendMsg = {}

require("game.pb.PBMsg")

local connectManager = require("sdk.connect.ConnectManager")
function SendMsg:send(msg)

	JJLog.printNetMsg("REQ",msg)
	local buf = PBMsg:encode(msg)
	connectManager.send(buf)
end