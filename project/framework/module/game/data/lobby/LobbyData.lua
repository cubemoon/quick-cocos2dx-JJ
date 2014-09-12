LobbyData = {}

LobbyData.inLobby = true

local anoneymousId = 0
local recvAnonymousBrowser = false -- 是否已经收到过：由于有大厅跳转，可能收到两条

function LobbyData:setAnoneymousId(id)
	self.anoneymousId = id
end

function LobbyData:getAnoneymousId()
	return self.anoneymousId
end

function LobbyData:setRecvAnonymousBrowser(flag)
	recvAnonymousBrowser = flag
end

function LobbyData:isRecvAnonymousBrowser()
	return recvAnonymousBrowser
end

return LobbyData