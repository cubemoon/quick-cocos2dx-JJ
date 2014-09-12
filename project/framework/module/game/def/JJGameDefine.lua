-- game 这个包的一些通用定义
JJGameDefine = {}

-- GameId
JJGameDefine.GAME_ID_HALL = 1 -- 大厅
JJGameDefine.GAME_ID_LORD_UNION = 2 -- 斗地主合集包
JJGameDefine.GAME_ID_LORD_UNION_HL = 5 -- 欢乐斗地主合集包
JJGameDefine.GAME_ID_LORD = 1001 -- 斗地主
JJGameDefine.GAME_ID_LORD_LZ = 1010 -- 赖斗
JJGameDefine.GAME_ID_LORD_HL = 1019 -- 欢斗
JJGameDefine.GAME_ID_LORD_PK = 1035 -- 二斗
JJGameDefine.GAME_ID_LORD_SINGLE = 600001 -- 单机斗地主
JJGameDefine.GAME_ID_POKER = 1009 -- 德州扑克
JJGameDefine.GAME_ID_MAHJONG = 1002 -- 四麻
JJGameDefine.GAME_ID_MAHJONG_TP = 1017 -- 二麻
JJGameDefine.GAME_ID_THREE_CARD = 1008 -- 赢三张
JJGameDefine.GAME_ID_MAHJONG_BR = 1028 -- 血战麻将
JJGameDefine.GAME_ID_MAHJONG_SC = 1047 -- 四川麻将
JJGameDefine.GAME_ID_NIUNIU = 1032 -- 牛牛
JJGameDefine.GAME_ID_INTERIM = 1023 -- 卡当
JJGameDefine.GAME_ID_RUNFAST = 1031 -- 跑的快
JJGameDefine.GAME_ID_MAHJONGPUBLIC = 1051 -- 大众麻将（是由原来的普通麻将拆出来的）
JJGameDefine.GAME_ID_MAHJONGTDH = 1042	-- 推倒胡麻将(此数值可以查询JJ比赛\TKGC.xml)

-- 分项目的文件夹命名
JJGameDefine.GAME_DIR_TABLE = {}
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_HALL] = "hall"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_LORD_UNION] = "lordunion"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_LORD_UNION_HL] = "lordunion"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_LORD] = "lord"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_LORD_HL] = "lordhl"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_LORD_PK] = "lordpk"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_LORD_LZ] = "lordlz"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_LORD_SINGLE] = "lordsingle"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_POKER] = "poker"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_NIUNIU] = "niuniu"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_MAHJONG_BR] = "mahjongbr"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_MAHJONG_SC] = "mahjongsc"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_MAHJONG] = "mahjong"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_MAHJONG_TP] = "mahjongtp"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_THREE_CARD] = "threecard"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_INTERIM] = "interim"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_RUNFAST] = "runfast"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_MAHJONGPUBLIC] = "mahjongpublic"
JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_MAHJONGTDH] = "mahjongtdh"

function JJGameDefine:getGameDirName(packageid)
    local name = JJGameDefine.GAME_DIR_TABLE[packageid]
    return name or ""
end

-- 各游戏的成就域定义
JJGameDefine.JJ_DOMAIN_COMMON = 1 -- 通用
JJGameDefine.JJ_DOMAIN_LORD = 2
JJGameDefine.JJ_DOMAIN_MAHJONG = 3
JJGameDefine.JJ_DOMAIN_THREECARD = 7
JJGameDefine.JJ_DOMAIN_POKER = 8
JJGameDefine.JJ_DOMAIN_LORD_HL = 16
JJGameDefine.JJ_DOMAIN_LORD_PK = 35
JJGameDefine.JJ_DOMAIN_LORD_LZ = 9
JJGameDefine.JJ_DOMAIN_MAHJONG_TP = 3
JJGameDefine.JJ_DOMAIN_TASK = 1100 -- 任务域
JJGameDefine.JJ_DOMAIN_MAHJONG_BR = 44
JJGameDefine.JJ_DOMAIN_MAHJONG_SC = 51
JJGameDefine.JJ_DOMAIN_NIUNIU = 33
JJGameDefine.JJ_DOMAIN_INTERIM = 19
JJGameDefine.JJ_DOMAIN_RUNFAST = 27
JJGameDefine.JJ_DOMAIN_MAHJONGPUBLIC = 51	-- 由最早的4人麻将拆出来的大众麻将
JJGameDefine.JJ_DOMAIN_MAHJONGTDH = 45	--此数值可以查询此游戏比赛中的tny.ini的[Settings]GrowDomainID

JJGameDefine.DOMAIN_ID_TABLE = {}
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_LORD] = JJGameDefine.JJ_DOMAIN_LORD
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_LORD_HL] = JJGameDefine.JJ_DOMAIN_LORD_HL
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_LORD_PK] = JJGameDefine.JJ_DOMAIN_LORD_PK
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_LORD_LZ] = JJGameDefine.JJ_DOMAIN_LORD_LZ
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_POKER] = JJGameDefine.JJ_DOMAIN_POKER
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_MAHJONG] = JJGameDefine.JJ_DOMAIN_MAHJONG
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_MAHJONG_TP] = JJGameDefine.JJ_DOMAIN_MAHJONG_TP
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_THREE_CARD] = JJGameDefine.JJ_DOMAIN_THREECARD
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_MAHJONG_BR] = JJGameDefine.JJ_DOMAIN_MAHJONG_BR
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_MAHJONG_SC] = JJGameDefine.JJ_DOMAIN_MAHJONG_SC
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_NIUNIU] = JJGameDefine.JJ_DOMAIN_NIUNIU
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_INTERIM] = JJGameDefine.JJ_DOMAIN_INTERIM
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_RUNFAST] = JJGameDefine.JJ_DOMAIN_RUNFAST
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_MAHJONGPUBLIC] = JJGameDefine.JJ_DOMAIN_MAHJONGPUBLIC
JJGameDefine.DOMAIN_ID_TABLE[JJGameDefine.GAME_ID_MAHJONGTDH] = JJGameDefine.JJ_DOMAIN_MAHJONGTDH

function JJGameDefine:getDomainId(package)
    return JJGameDefine.DOMAIN_ID_TABLE[package]
end
