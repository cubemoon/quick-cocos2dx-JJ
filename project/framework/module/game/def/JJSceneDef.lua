--[[
    定义界面的标识
]]
JJSceneDef = {}

-- 游戏界面
JJSceneDef.ID_WELCOME = 1 -- Logo 界面
-- JJSceneDef.ID_SPLASH = 2 -- 进入主界面前的宣传界面 [yangzukang][2014.05.27]需求去掉
JJSceneDef.ID_MAIN = 3 -- 主界面
JJSceneDef.ID_SWITCH_TO_GAME = 4 -- 从大厅切换到游戏的等待界面
JJSceneDef.ID_MATCH_SELECT = 5 -- 比赛选择界面
JJSceneDef.ID_MORE_GAME = 6 -- 更多游戏
JJSceneDef.ID_JJ_LOGIN = 7 -- JJ 登录
JJSceneDef.ID_PERSONAL_CENTER = 8 -- 个人中心
JJSceneDef.ID_REGISTER_SELECT = 9 -- 注册方式选择
JJSceneDef.ID_NORMAL_REGISTER = 10 -- 普通注册
JJSceneDef.ID_MOBILE_REGISTER = 11 -- 手机注册
JJSceneDef.ID_SETTINGS = 12 -- 设置
JJSceneDef.ID_ABOUT = 13 -- 关于
JJSceneDef.ID_PERSONAL_CENTER_HELP = 14 -- 个人帮助
JJSceneDef.ID_GAME_HELP = 15 -- 游戏帮助
JJSceneDef.ID_WEB_VIEW = 16 -- 原生 Web 界面
JJSceneDef.ID_TITLE_DETAIL = 17 -- 称号界面
-- JJSceneDef.ID_SINGLE_MATCH_SELECT = 18 -- 单机游戏比赛选择界面
JJSceneDef.ID_CHARGE_SELECT = 19 -- 充值界面
JJSceneDef.ID_CONTACT_US = 20 -- 充值界面的联系我们
JJSceneDef.ID_CHARGE_DETAIL = 21 -- 充值详情界面
JJSceneDef.ID_CHARGE_SZF = 22 -- 充值卡界面
JJSceneDef.ID_PERSONAL_CENTER_SINGLE = 23 -- 单机个人中心
JJSceneDef.ID_ACHIEVEMENT_SINGLE = 24 -- 单机成就
JJSceneDef.ID_FEEDBACK = 25 -- 问题反馈
JJSceneDef.ID_TABLE_SELECT = 26
JJSceneDef.ID_PERSONALINFO_CENTER = 27 -- 个人信息
JJSceneDef.ID_CMCC_DIANSHU = 28 -- 移动基地游戏点数说明

JJSceneDef.ID_ORIGINAL = JJSceneDef.ID_MATCH_SELECT --设置登录成功后跳转的初始界面，各游戏可以设定自己指定的ID值

-- 游戏
JJSceneDef.ID_GAME = 99
JJSceneDef.ID_PLAY = 100
JJSceneDef.ID_LORD_PLAY = 101
JJSceneDef.ID_SINGLE_LORD_PLAY = 102
JJSceneDef.ID_LZ_LORD_PLAY = 103
JJSceneDef.ID_HL_LORD_PLAY = 104
JJSceneDef.ID_PK_LORD_PLAY = 105

-- 大厅独有的
JJSceneDef.ID_LOBBY = 10000 -- 大厅主界面
JJSceneDef.ID_CHANGE_ACCOUNT = 10001 -- 切换帐号
JJSceneDef.ID_GAME_MANAGER = 10002 -- 游戏管理
JJSceneDef.ID_LOGIN = 10003 -- 登录
JJSceneDef.ID_PERSONAL_INFO = 10004 -- 个人信息
--JJSceneDef.ID_FEEDBACK = 10005 -- 问题反馈
JJSceneDef.ID_NOTE_MSG = 10006 -- 消息
JJSceneDef.ID_NOTE_MSG_DETAIL = 10007 -- 消息详情
JJSceneDef.ID_FORUM = 10008 -- 论坛

-- 对应的 Controller 和 Scene
JJSceneDef.param_ = {}
JJSceneDef.param_[JJSceneDef.ID_WELCOME] = { "WelcomeSceneController", "WelcomeScene" }
-- JJSceneDef.param_[JJSceneDef.ID_SPLASH] = { "SplashSceneController", "SplashScene" }
JJSceneDef.param_[JJSceneDef.ID_MAIN] = { "MainSceneController", "MainScene" }
JJSceneDef.param_[JJSceneDef.ID_SWITCH_TO_GAME] = { "SwitchToGameSceneController", "SwitchToGameScene" }
JJSceneDef.param_[JJSceneDef.ID_MATCH_SELECT] = { "MatchSelectSceneController", "MatchSelectScene" }
JJSceneDef.param_[JJSceneDef.ID_MORE_GAME] = { "MoreGameSceneController", "MoreGameScene" }
JJSceneDef.param_[JJSceneDef.ID_JJ_LOGIN] = { "JJLoginSceneController", "JJLoginScene" }
JJSceneDef.param_[JJSceneDef.ID_PERSONAL_CENTER] = { "PersonalCenterSceneController", "PersonalCenterScene" }
JJSceneDef.param_[JJSceneDef.ID_REGISTER_SELECT] = { "RegisterSelectSceneController", "RegisterSelectScene" }
JJSceneDef.param_[JJSceneDef.ID_NORMAL_REGISTER] = { "NormalRegisterSceneController", "NormalRegisterScene" }
JJSceneDef.param_[JJSceneDef.ID_MOBILE_REGISTER] = { "MobileRegisterSceneController", "MobileRegisterScene" }
JJSceneDef.param_[JJSceneDef.ID_SETTINGS] = { "SettingsSceneController", "SettingsScene" }
JJSceneDef.param_[JJSceneDef.ID_ABOUT] = { "AboutSceneController", "AboutScene" }
JJSceneDef.param_[JJSceneDef.ID_PERSONAL_CENTER_HELP] = { "PersonalCenterHelpSceneController", "PersonalCenterHelpScene" }
JJSceneDef.param_[JJSceneDef.ID_GAME_HELP] = { "HelpSceneController", "HelpScene" }
JJSceneDef.param_[JJSceneDef.ID_WEB_VIEW] = { "WebViewSceneController", "WebViewScene" }
JJSceneDef.param_[JJSceneDef.ID_TITLE_DETAIL] = { "TitleDetailSceneController", "TitleDetailScene" }
JJSceneDef.param_[JJSceneDef.ID_CHARGE_SELECT] = { "ChargeSelectSceneController", "ChargeSelectScene" }
JJSceneDef.param_[JJSceneDef.ID_CHARGE_DETAIL] = { "ChargeDetailSceneController", "ChargeDetailScene" }
JJSceneDef.param_[JJSceneDef.ID_CONTACT_US] = { "ContactUsSceneController", "ContactUsScene" }
JJSceneDef.param_[JJSceneDef.ID_CHARGE_SZF] = { "ChargeSZFSceneController", "ChargeSZFScene" }
JJSceneDef.param_[JJSceneDef.ID_FEEDBACK] = { "FeedbackSceneController", "FeedbackScene" }
JJSceneDef.param_[JJSceneDef.ID_TABLE_SELECT] = { "TableSelectSceneController", "TableSelectScene" }
JJSceneDef.param_[JJSceneDef.ID_PERSONALINFO_CENTER] = { "PersonalInfoCenterSceneController", "PersonalInfoCenterScene" }
JJSceneDef.param_[JJSceneDef.ID_CMCC_DIANSHU] = { "DianShuSceneController", "DianShuScene" }


JJSceneDef.param_[JJSceneDef.ID_GAME] = { "GameSceneController", "GameScene" }
JJSceneDef.param_[JJSceneDef.ID_PLAY] = { "PlaySceneController", "PlayScene" }
JJSceneDef.param_[JJSceneDef.ID_LORD_PLAY] = { "LordPlaySceneController", "PlayScene" }
JJSceneDef.param_[JJSceneDef.ID_SINGLE_LORD_PLAY] = { "SingleLordPlaySceneController", "PlayScene" }
JJSceneDef.param_[JJSceneDef.ID_LZ_LORD_PLAY] = { "LZLordPlaySceneController", "PlayScene" }
JJSceneDef.param_[JJSceneDef.ID_HL_LORD_PLAY] = { "HLLordPlaySceneController", "PlayScene" }
JJSceneDef.param_[JJSceneDef.ID_PK_LORD_PLAY] = { "PKLordPlaySceneController", "PlayScene" }

JJSceneDef.param_[JJSceneDef.ID_LOBBY] = { "LobbySceneController", "LobbyScene" }
JJSceneDef.param_[JJSceneDef.ID_CHANGE_ACCOUNT] = { "ChangeAccountSceneController", "ChangeAccountScene" }
JJSceneDef.param_[JJSceneDef.ID_GAME_MANAGER] = { "GameManagerSceneController", "GameManagerScene" }
JJSceneDef.param_[JJSceneDef.ID_LOGIN] = { "LoginSceneController", "LoginScene" }
JJSceneDef.param_[JJSceneDef.ID_PERSONAL_INFO] = { "PersonalInfoSceneController", "PersonalInfoScene" }
JJSceneDef.param_[JJSceneDef.ID_NOTE_MSG] = {"NoteMsgController", "NoteMsgScene"}
JJSceneDef.param_[JJSceneDef.ID_NOTE_MSG_DETAIL] = {"NoteMsgDetailController", "NoteMsgDetailScene"}
JJSceneDef.param_[JJSceneDef.ID_FORUM] = {"ForumSceneController", "ForumScene"}




-- 游戏使用的公用界面前缀
JJSceneDef.PRE_ = {}
JJSceneDef.PRE_[JJGameDefine.GAME_ID_HALL] = { "hall.ui.", "Hall" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_LORD_UNION] = { "lordunion.ui.", "LordUnion" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_LORD_UNION_HL] = { "lordunion.ui.", "LordUnion" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_NIUNIU] = { "niuniu.ui.", "NiuNiu" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_MAHJONG] = { "mahjong.ui.", "Mahjong" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_MAHJONG_TP] = { "mahjongtp.ui.", "MahjongTP" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_MAHJONG_BR] = { "mahjongbr.ui.", "MahjongBR" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_MAHJONG_SC] = { "mahjongsc.ui.", "MahjongSC" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_POKER] = { "poker.ui.", "Poker" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_INTERIM] = { "interim.ui.", "Interim" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_RUNFAST] = { "runfast.ui.", "RunFast" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_THREE_CARD] = { "threecard.ui.", "ThreeCard" }
JJSceneDef.PRE_[JJGameDefine.GAME_ID_MAHJONGPUBLIC] = {"mahjongpublic.ui.", "MahjongPublic"}
JJSceneDef.PRE_[JJGameDefine.GAME_ID_MAHJONGTDH] = {"mahjongtdh.ui.", "MahjongTDH"}

--比赛中各view id
JJSceneDef.MATCH_VIEW_ROUND_WAIT = 1  --局间等待
JJSceneDef.MATCH_VIEW_ISLAND_WAIT = 2 --岛屿赛休息
JJSceneDef.MATCH_VIEW_HISTORY_WAIT = 3 --断线重连
JJSceneDef.MATCH_VIEW_DIPLOMA = 4  --奖状
JJSceneDef.MATCH_VIEW_PROMOTION_WAIT = 5 --晋级等待
JJSceneDef.MATCH_VIEW_REVIVE_WAIT = 6  --复活
JJSceneDef.MATCH_VIEW_DIALOG_CONFIRM_WAIT = 7 --
JJSceneDef.MATCH_VIEW_FIRST_ROUND_WAIT = 8 --比赛开赛第一次局间等待

JJSceneDef.MATCH_VIEW_PLAY = 15