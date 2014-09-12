local BottomView = require("game.ui.view.BottomView")
local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")

local BottomStyle = {}

BottomStyle.BOTTOM_MENU_CHAGRGE      = 1  --充值
BottomStyle.BOTTOM_MENU_PCENTER      = 2  --个人中心
BottomStyle.BOTTOM_MENU_EXCHANGE     = 3  --兑奖
BottomStyle.BOTTOM_MENU_WARE         = 4  --物品箱
BottomStyle.BOTTOM_MENU_FORUM        = 5  --论坛
BottomStyle.BOTTOM_MENU_RANK         = 6  --排行榜
BottomStyle.BOTTOM_MENU_TOPIC        = 7  --活动
BottomStyle.BOTTOM_MENU_SETTING      = 8  --设置

BottomStyle.BOTTOM_MENU_SINGLE_PCENTER           = 9  --设置
BottomStyle.BOTTOM_MENU_SINGLE_ACHIEVEMENT       = 10  --个人成就
BottomStyle.BOTTOM_MENU_SINGLE_ROAR              = 11  --咆哮
BottomStyle.BOTTOM_MENU_SINGLE_ROAR_NEW          = 12  --头条看点
BottomStyle.BOTTOM_MENU_SINGLE_ROAR_TW           = 13  --提问区

BottomStyle.lordImageArray = {
	"bottomview/charge_btn_n.png",
  "bottomview/pcenter_btn_n.png",
  "bottomview/exchange_btn_n.png",
  "bottomview/inventory_btn_n.png",
	"bottomview/roar_btn_n.png",
	"bottomview/ranking_btn_n.png",
	"bottomview/topic_btn_n.png",
	"bottomview/settings_btn_n.png",
}

BottomStyle.lordTextArray = {
	"充值",
	"个人中心",
  "兑奖中心",
	"物品箱",
	"咆哮",
  "排行榜",
  "活动",
  "设置",
}

BottomStyle.lordVisibleArray = {
	DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_CHARGE),
	true,
  DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_EXCHANGE_PRIZE),
	DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_WARE),
  DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR),
  DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_RANK),
  DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_TOPIC),
  true,
}

BottomStyle.singleLordImageArray = {
	"bottomview/pcenter_btn_n.png",
	"lordsinglelobby/singlelobby_achievement_btn_n.png",
	"bottomview/roar_btn_n.png",
	"lordsinglelobby/singlelobby_news_btn_n.png",
	"lordsinglelobby/singlelobby_question_btn_n.png",
}

BottomStyle.singleLordTextArray = {
	"个人中心",
	"个人成就",
	"咆哮",
	"头条看点",
	"提问区",
}

BottomStyle.singleLordVisibleArray = {
  true,
  true,
  DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR),
  DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR),
  DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR),
}

BottomStyle.singleLordUserIcon = "lordsinglelobby/singlelobby_default_header.png"
BottomStyle.singleLordGoldIcon = "lordsinglelobby/singlelobby_user_coin.png"
BottomStyle.singleLordLevelIcon = "lordsinglelobby/singlelobby_user_level.png"
BottomStyle.singleLordUserName = "JJ单机玩家"

BottomStyle.fontColor = ccc3(255, 255, 255)
BottomStyle.fontSize = 18

BottomStyle.lordOnClickListenerArray = {
	BottomView.chargeBtnOnClick,
	BottomView.personalCenterBtnOnClick,
	BottomView.exchangeBtnOnClick,
	BottomView.inventoryBtnOnClick,
	BottomView.roarBtnOnClick,
  BottomView.rankingBtnOnClick,
  BottomView.topicBtnOnClick,
  BottomView.settingsBtnOnClick,
}

BottomStyle.singleLordOnClickListenerArray = {
	BottomView.singleLordPcenterBtnOnClick,
	BottomView.singleLordAchievementBtnOnClick,
	BottomView.singleLordRoarBtnOnClick,
	BottomView.singleLordNewsBtnOnClick,
	BottomView.singleLordQuestionBtnOnClick,
}

BottomStyle.isSingleLordNewMsgArray = {
  false,
  false,
  roarRemindMsgFlag_,
  false,
  false,
}

BottomStyle.isNewMsgArray = {
  false,
  (NoteManager:getUnreadCount(MainController:getCurPackageId(), UserInfo.userId_) > 0),
  false,
  false,
  roarRemindMsgFlag_,
  false,
  false,
  false,
}

BottomStyle.mergedParams = {
  {
      id = BottomStyle.BOTTOM_MENU_CHAGRGE,
      iconNormal =BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_CHAGRGE],
      iconPress = BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_CHAGRGE],
      text = BottomStyle.lordTextArray[BottomStyle.BOTTOM_MENU_CHAGRGE],
      OnClickListener = BottomStyle.lordOnClickListenerArray[BottomStyle.BOTTOM_MENU_CHAGRGE],
      visible = BottomStyle.lordVisibleArray[BottomStyle.BOTTOM_MENU_CHAGRGE],
      isNewMsg = BottomStyle.isNewMsgArray[BottomStyle.BOTTOM_MENU_CHAGRGE],
    },
    {
      id = BottomStyle.BOTTOM_MENU_PCENTER,
      iconNormal =BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_PCENTER],
      iconPress = BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_PCENTER],
      text = BottomStyle.lordTextArray[BottomStyle.BOTTOM_MENU_PCENTER],
      OnClickListener = BottomStyle.lordOnClickListenerArray[BottomStyle.BOTTOM_MENU_PCENTER],
      visible = BottomStyle.lordVisibleArray[BottomStyle.BOTTOM_MENU_PCENTER],
      isNewMsg = BottomStyle.isNewMsgArray[BottomStyle.BOTTOM_MENU_PCENTER],
    },
    {
      id = BottomStyle.BOTTOM_MENU_EXCHANGE,
      iconNormal =BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_EXCHANGE],
      iconPress = BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_EXCHANGE],
      text = BottomStyle.lordTextArray[BottomStyle.BOTTOM_MENU_EXCHANGE],
      OnClickListener = BottomStyle.lordOnClickListenerArray[BottomStyle.BOTTOM_MENU_EXCHANGE],
      visible = BottomStyle.lordVisibleArray[BottomStyle.BOTTOM_MENU_EXCHANGE],
      isNewMsg = BottomStyle.isNewMsgArray[BottomStyle.BOTTOM_MENU_EXCHANGE],
    },
    {
      id = BottomStyle.BOTTOM_MENU_WARE,
      iconNormal =BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_WARE],
      iconPress = BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_WARE],
      text = BottomStyle.lordTextArray[BottomStyle.BOTTOM_MENU_WARE],
      OnClickListener = BottomStyle.lordOnClickListenerArray[BottomStyle.BOTTOM_MENU_WARE],
      visible = BottomStyle.lordVisibleArray[BottomStyle.BOTTOM_MENU_WARE],
      isNewMsg = BottomStyle.isNewMsgArray[BottomStyle.BOTTOM_MENU_WARE],
    },
    {
      id = BottomStyle.BOTTOM_MENU_FORUM,
      iconNormal =BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_FORUM],
      iconPress = BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_FORUM],
      text = BottomStyle.lordTextArray[BottomStyle.BOTTOM_MENU_FORUM],
      OnClickListener = BottomStyle.lordOnClickListenerArray[BottomStyle.BOTTOM_MENU_FORUM],
      visible = BottomStyle.lordVisibleArray[BottomStyle.BOTTOM_MENU_FORUM],
      isNewMsg = BottomStyle.isNewMsgArray[BottomStyle.BOTTOM_MENU_FORUM],
    },
    {
      id = BottomStyle.BOTTOM_MENU_RANK,
      iconNormal =BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_RANK],
      iconPress = BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_RANK],
      text = BottomStyle.lordTextArray[BottomStyle.BOTTOM_MENU_RANK],
      OnClickListener = BottomStyle.lordOnClickListenerArray[BottomStyle.BOTTOM_MENU_RANK],
      visible = BottomStyle.lordVisibleArray[BottomStyle.BOTTOM_MENU_RANK],
      isNewMsg = BottomStyle.isNewMsgArray[BottomStyle.BOTTOM_MENU_RANK],
    },
    {
      id = BottomStyle.BOTTOM_MENU_TOPIC,
      iconNormal =BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_TOPIC],
      iconPress = BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_TOPIC],
      text = BottomStyle.lordTextArray[BottomStyle.BOTTOM_MENU_TOPIC],
      OnClickListener = BottomStyle.lordOnClickListenerArray[BottomStyle.BOTTOM_MENU_TOPIC],
      visible = BottomStyle.lordVisibleArray[BottomStyle.BOTTOM_MENU_TOPIC],
      isNewMsg = BottomStyle.isNewMsgArray[BottomStyle.BOTTOM_MENU_TOPIC],
    },
    {
      id = BottomStyle.BOTTOM_MENU_SETTING,
      iconNormal =BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_SETTING],
      iconPress = BottomStyle.lordImageArray[BottomStyle.BOTTOM_MENU_SETTING],
      text = BottomStyle.lordTextArray[BottomStyle.BOTTOM_MENU_SETTING],
      OnClickListener = BottomStyle.lordOnClickListenerArray[BottomStyle.BOTTOM_MENU_SETTING],
      visible = BottomStyle.lordVisibleArray[BottomStyle.BOTTOM_MENU_SETTING],
      isNewMsg = BottomStyle.isNewMsgArray[BottomStyle.BOTTOM_MENU_SETTING],
    },
}

BottomStyle.mergedSingleLordParams = {
  {
      id = BottomStyle.BOTTOM_MENU_SINGLE_PCENTER,
      iconNormal =BottomStyle.singleLordImageArray[1],
      iconPress = BottomStyle.singleLordImageArray[1],
      text = BottomStyle.singleLordTextArray[1],
      OnClickListener = BottomStyle.singleLordOnClickListenerArray[1],
      visible = BottomStyle.singleLordVisibleArray[1],
      isNewMsg = BottomStyle.isSingleLordNewMsgArray[1],
    },
    {
      id = BottomStyle.BOTTOM_MENU_SINGLE_ACHIEVEMENT,
      iconNormal =BottomStyle.singleLordImageArray[2],
      iconPress = BottomStyle.singleLordImageArray[2],
      text = BottomStyle.singleLordTextArray[2],
      OnClickListener = BottomStyle.singleLordOnClickListenerArray[2],
      visible = BottomStyle.singleLordVisibleArray[2],
      isNewMsg = BottomStyle.isSingleLordNewMsgArray[2],
    },
    {
      id = BottomStyle.BOTTOM_MENU_SINGLE_ROAR,
      iconNormal =BottomStyle.singleLordImageArray[3],
      iconPress = BottomStyle.singleLordImageArray[3],
      text = BottomStyle.singleLordTextArray[3],
      OnClickListener = BottomStyle.singleLordOnClickListenerArray[3],
      visible = BottomStyle.singleLordVisibleArray[3],
      isNewMsg = BottomStyle.isSingleLordNewMsgArray[3],
    },
    {
      id = BottomStyle.BOTTOM_MENU_SINGLE_ROAR_NEW,
      iconNormal =BottomStyle.singleLordImageArray[4],
      iconPress = BottomStyle.singleLordImageArray[4],
      text = BottomStyle.singleLordTextArray[4],
      OnClickListener = BottomStyle.singleLordOnClickListenerArray[4],
      visible = BottomStyle.singleLordVisibleArray[4],
      isNewMsg = BottomStyle.isSingleLordNewMsgArray[4],
    },
    {
      id = BottomStyle.BOTTOM_MENU_SINGLE_ROAR_TW,
      iconNormal =BottomStyle.singleLordImageArray[5],
      iconPress = BottomStyle.singleLordImageArray[5],
      text = BottomStyle.singleLordTextArray[5],
      OnClickListener = BottomStyle.singleLordOnClickListenerArray[5],
      visible = BottomStyle.singleLordVisibleArray[5],
      isNewMsg = BottomStyle.isSingleLordNewMsgArray[5],
    },
}


return BottomStyle




