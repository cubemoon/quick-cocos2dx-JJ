--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/17
-- Time: 14:46
-- To change this template use File | Settings | File Templates.
--

JJAnalyticsDefine = {}

JJAnalyticsDefine.FILE_PATH = "analytics/";

JJAnalyticsDefine.TAG_IMEI = "imei";
JJAnalyticsDefine.TAG_ICCID = "iccid";
JJAnalyticsDefine.TAG_CHECK_VALUE = "checkValue";
JJAnalyticsDefine.TAG_USER_ACTION = "userAction";

JJAnalyticsDefine.CHECK_PRE_USER_ACTION_UPLOAD = "JJ_USER_ACTION_UPLOAD"
JJAnalyticsDefine.CHECK_PRE_SINGLE_LORD_UPLOAD = "JJ_SINGLE_LORD_UPLOAD"

JJAnalyticsDefine.KEY_DATE = "date";
JJAnalyticsDefine.KEY_USER_BEHAVIORS = "data"; -- 对应 UserBehaviors
JJAnalyticsDefine.KEY_USER_OPERATER = "user_operater"; -- UserOperater
JJAnalyticsDefine.KEY_SINGLE_LORD = "singlelord"; -- 单机斗地主

JJAnalyticsDefine.KEY_NET_TYPE = "net_type"; -- 网络制式
JJAnalyticsDefine.KEY_NET_CARRIER = "net_carrier"; -- 运营商
JJAnalyticsDefine.KEY_LOCAL_IP = "local_ip"; -- 本地IP
JJAnalyticsDefine.KEY_CONN_INFO = "conn"; -- 访问信息
JJAnalyticsDefine.KEY_SERV_IP = "serv_ip"; -- 服务器IP
JJAnalyticsDefine.KEY_TOTAL_COUNT = "total"; -- 访问总次数
JJAnalyticsDefine.KEY_FAIL_COUNT = "fail"; -- 失败次数
JJAnalyticsDefine.KEY_TOTAL_TIME = "total_time"; -- 消耗总时长
JJAnalyticsDefine.KEY_FAIL_TIME = "fail_time"; -- 失败总时长
JJAnalyticsDefine.KEY_BROKEN = "broken"; -- 断线总次数
JJAnalyticsDefine.KEY_UP_FLOW = "up_flow"; -- 上行流量
JJAnalyticsDefine.KEY_DOWN_FLOW = "down_flow"; -- 下行流量
JJAnalyticsDefine.KEY_ONLINE_DUR = "online_dur"; -- 在线时长

JJAnalyticsDefine.KEY_OPERATER = "operater"; -- 用户动作
JJAnalyticsDefine.KEY_CLICK_NEW_GUIDE = "new_guide"; -- 新手引导
JJAnalyticsDefine.KEY_CLICK_GUIDE = "guide"; -- 攻略
JJAnalyticsDefine.KEY_CLICK_MORE_GAME = "more_game"; -- 更多游戏
JJAnalyticsDefine.KEY_CLICK_LOBBY_LOTTERY = "lobby_lottery"; -- 大厅抽奖
JJAnalyticsDefine.KEY_CLICK_SIGNIN_MATCH = "signin_match"; -- 签到赛
JJAnalyticsDefine.KEY_CLICK_GAME_LOTTERY = "game_lottery"; -- 游戏结算时抽奖

JJAnalyticsDefine.KEY_SINGLE_LORD_IMEI = "imei"; -- 用户ID
JJAnalyticsDefine.KEY_SINGLE_LORD_INFO = "singlelordinfo"; -- 用户ID
JJAnalyticsDefine.KEY_SINGLE_LORD_ONLINE = "online"; -- 在线时长
JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_COUNT = "logincount"; -- 日登陆
JJAnalyticsDefine.KEY_SINGLE_LORD_LEVEL = "level"; -- 平均等级
JJAnalyticsDefine.KEY_SINGLE_LORD_COPPER = "copper"; -- 平均铜板数
JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_TIME = "logintime"; -- 登入时间
JJAnalyticsDefine.KEY_SINGLE_LORD_LOGOUT_TIME = "logouttime"; -- 登出时间
JJAnalyticsDefine.KEY_SINGLE_LORD_LOGIN_TIME_VALUE = "logintimevalue"; -- 登入时间
JJAnalyticsDefine.KEY_SINGLE_LORD_LOGOUT_TIME_VALUE = "logouttimevalue"; -- 登出时间
JJAnalyticsDefine.KEY_SINGLE_LORD_TOTAL_TIME = "totaltime"; -- 在线时间

-- BOOL
JJAnalyticsDefine.TRUE = "true";
JJAnalyticsDefine.FALSE = "false";

-- Action
JJAnalyticsDefine.ACTION_CONN = "conn";
JJAnalyticsDefine.ACTION_DISCONN = "disconn";
JJAnalyticsDefine.ACTION_BREAK = "break";
JJAnalyticsDefine.ACTION_GET_CONFIG_COST = "configcost"; -- 获取升级信息耗时
JJAnalyticsDefine.ACTION_LOGIN = "login";
JJAnalyticsDefine.ACTION_LOGOUT = "logout";
JJAnalyticsDefine.ACTION_CLICK = "click"; -- 点击某个按钮

-- Param
JJAnalyticsDefine.PARAM_IP = "ip";
JJAnalyticsDefine.PARAM_IP_LIST = "iplist";
JJAnalyticsDefine.PARAM_COST = "cost";
JJAnalyticsDefine.PARAM_NICKNAME = "nickname";
JJAnalyticsDefine.PARAM_USER_ID = "userid";

return JJAnalyticsDefine