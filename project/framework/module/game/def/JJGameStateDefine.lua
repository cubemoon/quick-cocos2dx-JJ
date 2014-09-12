-- 游戏状态定义
JJGameStateDefine = {}

--比赛状态，不要在自己的controller中修改
JJGameStateDefine.PLAY_STATE_WAIT = 1  --处于等待状态
JJGameStateDefine.PLAY_STATE_PLAY = 2   --处于玩游戏状态

--等待状态
JJGameStateDefine.WAIT_STATE_ROUND = 1
JJGameStateDefine.WAIT_STATE_PROMOTION = 2
JJGameStateDefine.WAIT_STATE_ISLAND = 3
JJGameStateDefine.WAIT_STATE_RELIVE = 4
JJGameStateDefine.WAIT_STATE_REGISTER = 5
JJGameStateDefine.WAIT_STATE_REGISTER_SUCCESS = 6
JJGameStateDefine.WAIT_STATE_AWARD = 7
JJGameStateDefine.WAIT_STATE_THREE_PK = 8
JJGameStateDefine.WAIT_STATE_HISTORY = 9
JJGameStateDefine.WAIT_STATE_ADDON_SELECT = 10
JJGameStateDefine.WAIT_STATE_FIRST_ROUND = 11

--游戏单用
JJGameStateDefine.STATE_FIRST_WAIT = 1  --初始等待状态
JJGameStateDefine.STATE_CALL_SCORE = 2  --叫分未完成，底牌未初始化
JJGameStateDefine.STATE_CALL_SCORE_WAIT_ACK = 3  --用户选择了叫分，消息还未回馈
JJGameStateDefine.STATE_PLAY = 4   --叫分已完成，底牌初始化结束，后续打牌阶段
JJGameStateDefine.STATE_PLAY_WAIT_ACK = 5  --玩家出牌了，还未有回馈
JJGameStateDefine.STATE_END_HAND = 6       --游戏结算，结算阶段
JJGameStateDefine.STATE_ROUND_WAIT = 7     --局间等待阶段：组桌、晋级、岛屿、复活、注册、奖状、3人PK
JJGameStateDefine.STATE_INIT_TABLE = 8     --初始桌面
JJGameStateDefine.STATE_START_GAME = 9     --进入游戏(用于 HL斗地主)

--欢乐斗地主
JJGameStateDefine.STATE_DISPATCHING_1 = 11     --发牌阶段1
JJGameStateDefine.STATE_DISPATCHING_2 = 12     --发牌阶段2
JJGameStateDefine.STATE_DISPATCHING_3 = 13     --发牌阶段3
JJGameStateDefine.STATE_DISPATCHING_4 = 14     --发牌阶段4
JJGameStateDefine.STATE_DISPATCH_FINISH = 15     --发牌阶段完成
JJGameStateDefine.STATE_START_CALL_LORD = 16     --开始叫地主
JJGameStateDefine.STATE_CALL_LORD = 17     --叫地主
JJGameStateDefine.STATE_START_ROB_LORD = 18     --开始抢地主
JJGameStateDefine.STATE_ROB_LORD = 19     --抢地主
JJGameStateDefine.STATE_DECLARE_LORD = 20     --确定地主
JJGameStateDefine.STATE_START_DOUBLE = 21     --开始加倍
JJGameStateDefine.STATE_DOUBLE = 22     --加倍
JJGameStateDefine.STATE_WAIT_LORD_SHOW_CARD = 23     --等待地主明牌
JJGameStateDefine.STATE_HLLORD_PLAY = 24     --打牌
JJGameStateDefine.STATE_HLEND_HAND = 25 -- 结算

----------------------- 二人斗地主游戏状态定义 开始 -----------------------
JJGameStateDefine[JJGameDefine.GAME_ID_LORD_PK] = {}
PKLordGameState = JJGameStateDefine[JJGameDefine.GAME_ID_LORD_PK]
BASE_STATE = 1035

PKLordGameState.STATE_START_GAME              = 1 + BASE_STATE
PKLordGameState.STATE_DISPATCHING             = 2 + BASE_STATE
PKLordGameState.STATE_DISPATCHING_COMPLATE    = 3 + BASE_STATE
PKLordGameState.STATE_CALLING_LORD            = 4 + BASE_STATE
PKLordGameState.STATE_ROBBING_LORD            = 5 + BASE_STATE
PKLordGameState.STATE_DECLARING_LORD          = 6 + BASE_STATE
PKLordGameState.STATE_GIVE_UP_LEAD            = 7 + BASE_STATE
PKLordGameState.STATE_PLAY                    = 8 + BASE_STATE
PKLordGameState.STATE_PLAY_WAIT_ACK           = 9 + BASE_STATE
PKLordGameState.STATE_END_HAND                = 10+ BASE_STATE
----------------------- 二人斗地主游戏状态定义 结束 -----------------------

----------------------- 麻将游戏状态定义 开始 -----------------------

JJGameStateDefine.MAHJONG_STATE_FIRST_WAIT       = 1  --初始等待状态(STATE_FIRST_WAIT)
JJGameStateDefine.MAHJONG_STATE_PLAY             = 4  --play界面
JJGameStateDefine.MAHJONG_STATE_PLAY_WAIT_ACK = 5  --玩家出牌了，还未有回馈
JJGameStateDefine.MAHJONG_STATE_END_HAND = 6       --游戏结算，结算阶段
JJGameStateDefine.MAHJONG_STATE_ROUND_WAIT = 7     --局间等待阶段：组桌、晋级、岛屿、复活、注册、奖状
JJGameStateDefine.MAHJONG_STATE_INIT_TABLE = 8     --初始桌面
----------------------- 麻将游戏状态定义 结束 -----------------------

return JJGameStateDefine