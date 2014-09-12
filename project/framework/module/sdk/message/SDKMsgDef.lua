SDKMsgDef = {}

require("sdk.message.MsgDef")

SDKMsgDef.TYPE_NET_STATE = MsgDef.SDK_MSG_START + 1 -- 网络状态
SDKMsgDef.TYPE_NET_MSG = MsgDef.SDK_MSG_START + 2 -- 网络消息
SDKMsgDef.TYPE_ENTER_BACKGROUND = MsgDef.SDK_MSG_START + 3 -- 切到后台
SDKMsgDef.TYPE_ENTER_FORGROUND = MsgDef.SDK_MSG_START + 4 -- 切到前台
SDKMsgDef.TYPE_NET_LAZY = MsgDef.SDK_MSG_START + 5 -- 网络慢

return SDKMsgDef