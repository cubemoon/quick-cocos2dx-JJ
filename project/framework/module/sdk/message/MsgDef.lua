--[[
	消息都是单独的 Table
	公用属性：type，用于消息分类
	其它都是自定义属性
]]
MsgDef = {}

MsgDef.SDK_MSG_START = 0 -- SDK 的消息
MsgDef.GAME_MSG_START = 10000 -- 上层消息