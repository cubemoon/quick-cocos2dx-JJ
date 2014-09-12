--[[
    定义网页功能的地址
]]
JJWebViewUrlDef = {}

-- 找回密码
JJWebViewUrlDef.URL_RESET_PWD = "http://mob.my.jj.cn/security_center/reset_pwd.php"
-- 商城
JJWebViewUrlDef.URL_SHOP = "http://mob.my.jj.cn/goods/compose_shop.php" --"http://mob.my.jj.cn/goods/compose_exchange.php"
-- 兑奖中心
JJWebViewUrlDef.URL_EXCHANGE = "http://mob.my.jj.cn/award/exchange_list.php"
-- 修改昵称
JJWebViewUrlDef.URL_MODIFY_NICKNAME = "http://mob.my.jj.cn/account/modify_nickname.php?quick=eyIxMDA0IjoiMjAwMCwxIn0"
-- 修改头像
JJWebViewUrlDef.URL_MODIFY_FIGURE = "http://mob.my.jj.cn/account/modify_head.php?quick=eyIxMDAzIjoiMjAwMCwxIn0"
-- 物品栏
JJWebViewUrlDef.URL_GOODS_LIST = "http://mob.my.jj.cn/goods/goodslist.php"
-- 保险箱
JJWebViewUrlDef.URL_COFFER = "http://mob.my.jj.cn/money/coffer.php"
-- 合成炉
JJWebViewUrlDef.URL_COMPOSE = "http://mob.my.jj.cn/goods/compose.php?act=typelist"
-- 财物领取
JJWebViewUrlDef.URL_GET_LIST = "http://mob.my.jj.cn/goods/getlist.php"
-- 账单查询
JJWebViewUrlDef.URL_MONEY_ACCOUNT = "http://mob.my.jj.cn/money/my_account.php"
-- 安全中心
JJWebViewUrlDef.URL_ACCOUNT = "http://mob.my.jj.cn/account/account.php"
-- 活动
JJWebViewUrlDef.URL_TOPIC = "http://m.jj.cn/cl/cl_luahd.html"
-- 斗地主活动
JJWebViewUrlDef.URL_TOPIC_LORD = "http://m.jj.cn/cl/tklord.html"
-- 欢斗活动
JJWebViewUrlDef.URL_TOPIC_LORD_HL = "http://m.jj.cn/cl/tklordhl.html"
-- 二斗活动
JJWebViewUrlDef.URL_TOPIC_LORD_PK = "http://m.jj.cn/cl/tklordpk.html"
-- 赖斗活动
JJWebViewUrlDef.URL_TOPIC_LORD_LZ = "http://m.jj.cn/cl/tklordlz.html"
-- 麻将活动
JJWebViewUrlDef.URL_TOPIC_MAHJONG = "http://m.jj.cn/cl/tkmahjong.html"
-- 二麻活动
JJWebViewUrlDef.URL_TOPIC_MAHJONG_TP = "http://m.jj.cn/cl/tkmahjong.html"
-- 德州活动
JJWebViewUrlDef.URL_TOPIC_POKER = "http://m.jj.cn/cl/tkpoker.html"
-- 赢三张活动
JJWebViewUrlDef.URL_TOPIC_THREECARD = "http://m.jj.cn/cl/tkthreecard.html"
-- 跑的快活动
JJWebViewUrlDef.URL_TOPIC_RUNFAST = "http://m.jj.cn/cl/tkrunfast.html"
-- 血流活动
JJWebViewUrlDef.URL_TOPIC_MAHJONG_BR = "http://m.jj.cn/cl/tkmahjongbr.html"
-- 川麻活动
JJWebViewUrlDef.URL_TOPIC_MAHJONG_SC = "http://m.jj.cn/cl/tkmahjongsc.html"
-- 牛牛活动
JJWebViewUrlDef.URL_TOPIC_NIUNIU = "http://m.jj.cn/cl/tkdouniu.html"
-- 其他充值
JJWebViewUrlDef.URL_OTHER_CHARGE = "http://pay.jj.cn/mob/app_jjcard.php" --"http://pay.jj.cn/mob/app_index.php" --"http://pay.jj.cn/mob_index.php" -- 
-- 获取头像地址 后面需要添加userid
JJWebViewUrlDef.URL_GET_HEAD_ICON = "http://img.jj.cn/user_upload/head/"
-- 获取系统默认头像地址 后面需要添加userid
JJWebViewUrlDef.URL_GET_TMP_HEAD_ICON = "http://img.jj.cn/images/head/"
-- BBS
JJWebViewUrlDef.URL_BBS = "http://mob.my.jj.cn/bbs/nav_list.php"
-- 公共功能网页加载Cookie域地址
JJWebViewUrlDef.MOB_SSO_URL = "http://mob.my.jj.cn/"
-- 充值用Cookie域地址
JJWebViewUrlDef.CHARGE_SSO_URL = "http://pay.jj.cn/"


JJWebViewUrlDef[JJGameDefine.GAME_ID_LORD] = JJWebViewUrlDef.URL_TOPIC_LORD
JJWebViewUrlDef[JJGameDefine.GAME_ID_LORD_HL] = JJWebViewUrlDef.URL_TOPIC_LORD_HL
JJWebViewUrlDef[JJGameDefine.GAME_ID_LORD_PK] = JJWebViewUrlDef.URL_TOPIC_LORD_PK
JJWebViewUrlDef[JJGameDefine.GAME_ID_LORD_LZ] = JJWebViewUrlDef.URL_TOPIC_LORD_LZ
JJWebViewUrlDef[JJGameDefine.GAME_ID_MAHJONG] = JJWebViewUrlDef.URL_TOPIC_MAHJONG
JJWebViewUrlDef[JJGameDefine.GAME_ID_MAHJONG_TP] = JJWebViewUrlDef.URL_TOPIC_MAHJONG_TP
JJWebViewUrlDef[JJGameDefine.GAME_ID_POKER] = JJWebViewUrlDef.URL_TOPIC_POKER
JJWebViewUrlDef[JJGameDefine.GAME_ID_THREE_CARD] = JJWebViewUrlDef.URL_TOPIC_THREECARD
JJWebViewUrlDef[JJGameDefine.GAME_ID_RUNFAST] = JJWebViewUrlDef.URL_TOPIC_RUNFAST
JJWebViewUrlDef[JJGameDefine.GAME_ID_MAHJONG_BR] = JJWebViewUrlDef.URL_TOPIC_MAHJONG_BR
JJWebViewUrlDef[JJGameDefine.GAME_ID_MAHJONG_SC] = JJWebViewUrlDef.URL_TOPIC_MAHJONG_SC
JJWebViewUrlDef[JJGameDefine.GAME_ID_NIUNIU] = JJWebViewUrlDef.URL_TOPIC_NIUNIU

return JJWebViewUrlDef