-- match 状态的一些定义
MatchDefine = {}

--  SIGN_STATE
MatchDefine.STATUS_WAITING_DATA = 0 -- 数据等待中
MatchDefine.STATUS_SIGNUPABLE = 1 --可报名
MatchDefine.STATUS_OUT_OF_REQUIREMENT = 2 -- 不符合报名条件
MatchDefine.STATUS_SIGNOUTABLE = 4 -- 已报名
MatchDefine.STATUS_STARTED = 5 -- 已开始
MatchDefine.STATUS_SIGNUPING = 6 -- 报名中
MatchDefine.STATUS_SIGNOUTING = 7 -- 退赛中

-- PRODUCT_TYPE
MatchDefine.TYPE_NORMAL = 0 --普通比赛
MatchDefine.TYPE_RECOM = 1 -- 推荐比赛
MatchDefine.TYPE_FREQ = 2 --常用比赛
MatchDefine.TYPE_FAVOUR = 3 --收藏的比赛

-- signupcost type 
MatchDefine.SIGNUPCOST_TYPE_GOLD = 1 -- 金币报名
MatchDefine.SIGNUPCOST_TYPE_CERT = 2 -- 积分报名
MatchDefine.SIGNUPCOST_TYPE_GROW = 3 -- 成就报名
MatchDefine.SIGNUPCOST_TYPE_WARE = 4 -- 物品报名

-- consoleSW bit
MatchDefine.CSW_CHANGE_TABLE = 1 -- 换桌
MatchDefine.CSW_LOTTERY = 2 -- 抽奖
MatchDefine.CSW_SELECT_TABLE = 4 --选桌

-- match type
MatchDefine.MATCH_TYPE_TIMELY = 0 -- 即时赛
MatchDefine.MATCH_TYPE_FIXED = 1 -- 定时赛
MatchDefine.MATCH_TYPE_ISLAND = 2 --岛屿赛

-- tourney state
MatchDefine.TOURNEYPROPAGANDIZING = 0 -- 宣传中
MatchDefine.TOURNEYSIGNUPING = 1 -- 报名中
MatchDefine.TOURNEYSTARTUPING = 2 -- 启动中
MatchDefine.TOURNEYPROGRESS = 3 -- 进行中
MatchDefine.TOURNEYSTOP = 4 -- 结束
MatchDefine.TOURNEYCANCEL = 5 -- 取消

-- match signup state
MatchDefine.TK_MATCHSIGNUP_SUCCESS = 0
MatchDefine.TK_MATCHSIGNUP_FAILED = 1
MatchDefine.TK_MATCHSIGNUP_MATCHUNEXIST = 2
MatchDefine.TK_MATCHSIGNUP_PHASENOBEGIN = 3
MatchDefine.TK_MATCHSIGNUP_PHASEEND = 4
MatchDefine.TK_MATCHSIGNUP_SIGNUPED = 5
MatchDefine.TK_MATCHSIGNUP_PLAYERIN = 6
MatchDefine.TK_MATCHSIGNUP_TESTOK = 7
MatchDefine.TK_MATCHSIGNUP_GOLDLACK = 8
MatchDefine.TK_MATCHSIGNUP_BONUSLACK = 9
MatchDefine.TK_MATCHSIGNUP_CERTLACK = 10
MatchDefine.TK_MATCHSIGNUP_FULL = 11
MatchDefine.TK_MATCHSIGNUP_MIN_MASTERSCORE = 12
MatchDefine.TK_MATCHSIGNUP_MAX_MASTERSCORE = 13
MatchDefine.TK_MATCHSIGNUP_MIN_MATCHSCORE = 14
MatchDefine.TK_MATCHSIGNUP_MAX_MATCHSCORE = 15
MatchDefine.TK_MATCHSIGNUP_MIN_GAMEMATCHCOUNT = 16
MatchDefine.TK_MATCHSIGNUP_MIN_MATCHCOUNT = 17
MatchDefine.TK_MATCHSIGNUP_MIN_GAMETIME = 18
MatchDefine.TK_MATCHSIGNUP_MIN_TOTALTIME = 19
MatchDefine.TK_MATCHSIGNUP_NOTINPERMITSIGNUPUSERLIST = 20
MatchDefine.TK_MATCHSIGNUP_LCVERSION_LOW = 21
MatchDefine.TK_MATCHSIGNUP_GROWLACK = 22
MatchDefine.TK_MATCHSIGNUP_WARELACK = 23
MatchDefine.TK_MATCHSIGNUP_GROWCONDITIONLACK = 24
MatchDefine.TK_MATCHSIGNUP_WARECONDITIONLACK = 25
MatchDefine.TK_MATCHSIGNUP_MATCHPAUSESIGNUP = 26
MatchDefine.TK_MATCHSIGNUP_TABLEPAUSESIGNUP = 27
MatchDefine.TK_MATCHSIGNUP_TABLEUNEXIST = 28
MatchDefine.TK_MATCHSIGNUP_TABLEROOMFULL = 29
MatchDefine.TK_MATCHSIGNUP_TABLESIGNUPED = 30
MatchDefine.TK_MATCHSIGNUP_TABLEMULTGAMELIMIT = 31

function MatchDefine.toString(signUpParam)
    if signUpParam == MatchDefine.TK_MATCHSIGNUP_SUCCESS then
        return "报名成功"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_FAILED then
        return "报名失败"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_MATCHUNEXIST then
        return "比赛不存在"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_PHASENOBEGIN then
        return "报名没开始"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_PHASEEND then
        return "报名时间结束"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_SIGNUPED then
        return "已经报名"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_PLAYERIN then
        return "用户已经在比赛中"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_TESTOK then
        return "测试报名成功"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_GOLDLACK then
        return "金币数不够"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_BONUSLACK then
        return "奖券数不够"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_CERTLACK then
        return "代金券(门票)不够"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_FULL then
        return "已经报满"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_MIN_MASTERSCORE then
        return "低于最少大师分限制"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_MAX_MASTERSCORE then
        return " 高于最大大师分限制"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_MIN_MATCHSCORE then
        return " 低于最少比赛积分限制"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_MAX_MATCHSCORE then
        return " 高于最大比赛积分限制"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_MIN_GAMEMATCHCOUNT then
        return " 低于游戏次数限制（参加该游戏比赛次数）"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_MIN_MATCHCOUNT then
        return " 低于总参赛次数限制（参加所有游戏的比赛总场数）"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_MIN_GAMETIME then
        return " 低于游戏时长限制（秒）"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_MIN_TOTALTIME then
        return " 低于总时长限制（秒）"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_NOTINPERMITSIGNUPUSERLIST then
        return "不在允许报名的用户列表中"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_LCVERSION_LOW then
        return " 客户端版本低，不能报名 "
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_GROWLACK then
        return "积分不足"
    elseif signUpParam == MatchDefine.TK_MATCHSIGNUP_WARELACK then
        return " 物品不足"
    elseif MatchDefine.TK_MATCHSIGNUP_GROWCONDITIONLACK then
        return "积分不符合报名条件"
    elseif MatchDefine.TK_MATCHSIGNUP_WARECONDITIONLACK then
        return " 物品不符合报名条件"
    elseif MatchDefine.TK_MATCHSIGNUP_MATCHPAUSESIGNUP then
        return "系统即将进行维护，比赛暂停报名"
    elseif MatchDefine.TK_MATCHSIGNUP_TABLEPAUSESIGNUP then
        return "系统即将进行维护，暂停游戏"
    elseif MatchDefine.TK_MATCHSIGNUP_TABLEUNEXIST then
        return "游戏桌不存在"
    elseif MatchDefine.TK_MATCHSIGNUP_TABLEROOMFULL then
        return " 游戏已经满"
    elseif MatchDefine.TK_MATCHSIGNUP_TABLESIGNUPED then
        return "已经在游戏桌上"
    elseif MatchDefine.TK_MATCHSIGNUP_TABLEMULTGAMELIMIT then
        return " 超出最大进入入桌限制"
    else
        return "报名失败"
    end
end
