--[[
赛制 定义
]]
MatchRulerDefine = {}

MatchRulerDefine.MATCH_RULE_NULL = 0;
MatchRulerDefine.MATCH_RULE_KICKOUT = 1 -- 淘汰赛制（N取1：取每桌的第一名晋级，参数人数必须是PlayersPerTable的n次幂。淘汰到底）
MatchRulerDefine.MATCH_RULE_CHAOS = 2 -- 混战赛制的Stage
MatchRulerDefine.MATCH_RULE_KICKOUT3 = 3 -- 淘汰赛制（3取1：取每桌的第一名晋级，参数人数必须是3的n次幂。淘汰到底或非淘汰到底）
MatchRulerDefine.MATCH_RULE_KICKOUT3X2N = 4 -- 淘汰赛制（3取1.5：取每桌的第一名和排名考前的第二名晋级，即每轮淘汰一半，参数人数必须是3x(2的n次幂)。淘汰到底或非淘汰到底）
MatchRulerDefine.MATCH_RULE_ISLAND = 5 -- 岛屿循环赛
MatchRulerDefine.MATCH_RULE_SWISS = 6 -- 瑞士移位
MatchRulerDefine.MATCH_RULE_KICKOUT4 = 7 -- 淘汰赛制（4取1：取每桌的第一名，参数人数必须是4的n次幂或4取2：取每桌的前两名晋级，参数人数必须是4*(2的n次幂)。淘汰到底）
MatchRulerDefine.MATCH_RULE_TABLE = 8 -- 自由桌赛制
MatchRulerDefine.MATCH_RULE_GAMBLECHAOS = 9 -- 赌博游戏用的混战赛制
MatchRulerDefine.MATCH_RULE_GAMBLEKICKOUT = 10 -- 赌博游戏用的淘汰赛制
MatchRulerDefine.MATCH_RULE_PK = 11 -- 2人PK赛(象棋围棋等)
MatchRulerDefine.MATCH_RULE_BROADCAST = 12 -- 转播Stage，由控制客户端控制组桌
MatchRulerDefine.MATCH_RULE_RANKISLAND = 13 -- 根据等级分匹配的岛子
MatchRulerDefine.MATCH_RULE_DYNAMICKICKOUT = 14 -- 全淘汰(动态调节淘汰人数的淘汰制)
MatchRulerDefine.MATCH_RULE_CHESSSWISS = 15 -- 积分编排(棋类比赛用的swiss)
MatchRulerDefine.MATCH_RULE_PAIRPK = 16 -- 2pair PK赛(象棋围棋等)
MatchRulerDefine.MATCH_RULE_CHALLENGE = 17 -- 擂台赛制
MatchRulerDefine.MATCH_RULE_LOOPCHAOS = 18 -- 循环赛制(象棋家族的循环赛)
MatchRulerDefine.MATCH_RULE_ROOM = 19 -- 自由房间
MatchRulerDefine.MATCH_RULE_CHANGEPLACE = 20 -- 移位积分赛制
MatchRulerDefine.MATCH_RULE_SEEDKICKOUT = 21 -- 种子单淘汰
MatchRulerDefine.MATCH_RULE_DOUBLEELIM = 22 -- 双败淘汰
MatchRulerDefine.MATCH_RULE_NOutOf2NMinus1 = 23 -- 2N-1局N胜淘汰赛制
MatchRulerDefine.MATCH_RULE_SECTIONSWISS = 24 -- 节分瑞士移位
MatchRulerDefine.MATCH_RULE_PERIODCHAOS = 25 -- 长程赛的混战赛制(象棋，四国等)
MatchRulerDefine.MATCH_RULE_GAMBLEBOUNTYCHAOS = 26 -- 赌博游戏用的混战猎人赛制
MatchRulerDefine.MATCH_RULE_FIXISLAND = 27 -- 不散桌的岛屿循环赛
MatchRulerDefine.MATCH_RULE_DYNISLAND = 28 -- 中途可离开的岛屿循环赛
MatchRulerDefine.MATCH_RULE_POKERISLAND = 29 -- 德州版岛屿循环赛

return MatchRulerDefine
