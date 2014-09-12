-- 推荐比赛Manager
MatchRecommendManager = {}

local config_ = require("game.settings.Settings")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
require("game.def.JJSceneDef")

local TAG = "MatchRecommendManager"

local promptedTourneyMap = {} --<tourneyId, startTime>
local m_strRecomSignupEntryFee = nil
local m_nRecomSignupType = 0
local m_nRecomTourneyId = 0
local m_RecomMatchComtent = nil
local CHECK_TICK = 60

function MatchRecommendManager:startCheckRecomMatchPrompt()
	JJLog.i(TAG,"startCheckRecomMatchPrompt")
	scheduler.performWithDelayGlobal(function()
	            self:checkRecomMatchPrompt()
        	end, 10)
	self.scheduleHandler_ = scheduler.scheduleGlobal(function() self:checkRecomMatchPrompt() end, CHECK_TICK)
end

function MatchRecommendManager:checkRecomMatchPrompt()
	JJLog.i(TAG,"checkRecomMatchPrompt")
    if not self:isPlayScene() then
        self:promptRecomMatch()
    end
end

function MatchRecommendManager:isPlayScene()
	local isPlaySceneTop = false
	local top = JJSDK:getTopSceneController()
	local sceneId = top and top:getSceneId()
    if sceneId == JJSceneDef.ID_PLAY
    	or sceneId == JJSceneDef.ID_LORD_PLAY
    	or sceneId == JJSceneDef.ID_SINGLE_LORD_PLAY
    	or sceneId == JJSceneDef.ID_LZ_LORD_PLAY
    	or sceneId == JJSceneDef.ID_HL_LORD_PLAY
    	or sceneId == JJSceneDef.ID_PK_LORD_PLAY then
        isPlaySceneTop = true
    end
    return isPlaySceneTop
end

function MatchRecommendManager:promptRecomMatch()
	JJLog.i(TAG,"promptRecomMatch IN")
	if not config_:getRecomMatchPrompt() then
		return
	end

	local info = self:getMatchPromptProductInfo()
	if info then
		local tourneyId = info.tourneyId_

		--已经提示过的tourney且是同一个开赛点的比赛不再提示
		--JJLog.i(TAG,"promptRecomMatch, promptedTourneyMap = ",vardump(promptedTourneyMap))
		for k, promptedItem in pairs(promptedTourneyMap) do
			if tourneyId == promptedItem.promptedTourneyId and promptedItem.startTime == info:getSignupTime() then
				return
			end
		end
		local item = {}
		item.promptedTourneyId = tourneyId
		item.startTime = info:getSignupTime()
		table.insert(promptedTourneyMap,item)

		local champion = ""
		local strEntryFee = ""
		local awardList = nil
		if info.matchconfig_ then
			awardList = info.matchconfig_.awards
		end
		if awardList and #awardList > 0 then
			local awardItem = awardList[1]
        	champion = awardItem.desc
		end

		local entryFeeList = info:getEntryFee()
		if entryFeeList then
			for index, item in pairs(entryFeeList) do
				if string.find(item.note_, "来宾玩家免费") or string.find(item.note_, "免费") then
					strEntryFee = "免费报名"
					m_strRecomSignupEntryFee = nil
					m_nRecomSignupType = 0
					break;
				elseif item.useable_ then
					if not item.note_ then
						local strFee = ""
						if string.find(item.note_, "扣除") then
							strFee = string.sub(item.note_, string.len("扣除") + 1)
						else
							strFee = item.note_
						end
						strEntryFee = "报名费：" + strFee
					end
					m_strRecomSignupEntryFee = item.note_
					m_nRecomSignupType = item.type_
					break
				end
			end
		end

		m_nRecomTourneyId = tourneyId;
		if info.matchconfig_ then
			m_RecomMatchComtent = info.matchconfig_.productName.."即将开赛了，冠军"..champion..",是否去狂欢？"..strEntryFee
		end
		self:showRecomMatchDialog(true)
	end
end

function MatchRecommendManager:showRecomMatchDialog(flag)
	JJLog.i(TAG,"showRecomMatchDialog IN")

	local top = JJSDK:getTopSceneController()
    if top ~= nil then
    	-- JJLog.i(TAG,"showRecomMatchDialog,top = ",vardump(top))
    	if flag then

            JJCloseIMEKeyboard()
    		scheduler.performWithDelayGlobal(function()
	            if self.recomMatchDlg_ and self.recomMatchDlg_:isShowing() then
	            	self:showRecomMatchDialog(false)
	            end
        	end, 15)

	       self.recomMatchDlg_ = require("game.ui.view.AlertDialog").new({
	           title = "推荐比赛",
	           prompt = m_RecomMatchComtent,
	           onDismissListener = function() self.recomMatchDlg_ = nil end,
	           dimens = top.dimens_,
	           theme = top.theme_,
	           backKey = true,
               backKeyClose = true,
	       })

	       self.recomMatchDlg_:setButton1("报名", function (view)
	       						-- if m_strRecomSignupEntryFee == nil then --不需要报名费，直接报名
	       							self:onSignup()
	       						-- else --需要报名费，提示二次确认
	       							-- 	askDestroyDialog(DIALOG_ID_RECOM_MATCH_PROMPT);
										-- 	askCreateDialog(DIALOG_ID_COMFIRM_SIGNUP);
	       						-- end
								 end)
	       --self.exitGameDlg_:setButton2("取消")
	       self.recomMatchDlg_:setCloseButton(function () end)
	       self.recomMatchDlg_:setCancelable(true)
	       self.recomMatchDlg_:show(top.scene_)
	   elseif self.recomMatchDlg_ then
	       self.recomMatchDlg_:dismiss()
	       self.recomMatchDlg_ = nil
	   end
    end

	
end

function MatchRecommendManager:onSignup()
	JJLog.i(TAG,"onSignup IN")
	local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(m_nRecomTourneyId)
	if tourneyInfo then
	    local gameId = tourneyInfo.matchconfig_ and tonumber(tourneyInfo.matchconfig_.gameId)
		local matchPoint = tourneyInfo:getSignupTime()
		local matchType = tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.matchType_              
		LobbyDataController:signupMatch(gameId, m_nRecomTourneyId, matchPoint, m_nRecomSignupType, 0, 0)
	end
end

function MatchRecommendManager:getMatchPromptProductInfo()
    JJLog.i("TAG","MatchRecommendManager:getMatchPromptProductInfo IN")
    local curTime = JJTimeUtil:getCurrentSecond()
    --推荐比赛开赛前X分钟内可以提示
    local beforeRemindTime = GlobalConfigManager:getBeforeRemindTime(MainController.curPackageId_) * 60
    --在已有报名比赛开赛前Y分钟内，则不提示
    local signupedProtect = GlobalConfigManager:getAfterRemindTime(MainController.curPackageId_) * 60
    local recomIdList = GlobalConfigManager:getRecomMatchInLobby(MainController.curPackageId_)
    if recomIdList == nil then
        return nil
    end
    local tableRecomIdList = string.split(recomIdList, ",")
    local recomMatch = TourneyController:getTourneyInfoListByProductIdList(tableRecomIdList)

    -- JJLog.i("TAG","MatchRecommendManager:getMatchPromptProductInfo, curTime = ",curTime,",beforeRemindTime = ",beforeRemindTime,
    --     ",signupedProtect, = ",signupedProtect,",recomIdList = ",recomIdList)
    -- JJLog.i("TAG","MatchRecommendManager:getMatchPromptProductInfo,recomIdList1 = ",vardump(tableRecomIdList))

    --比赛按开赛时间由早到晚排序
    table.sort(recomMatch, function(a,b)
        if a:getSignupTime() ~= nil then
            return a:getSignupTime() < b:getSignupTime()
        end
    end)

    local nearestStartTime = 0
    local name = ""
    local nearItem = SignupStatusManager:getNearestTimedItem()
    if nearItem then
        nearestStartTime = nearItem.startTime_
        name = nearItem.matchName_
    end

    -- JJLog.i("TAG","MatchRecommendManager:getMatchPromptProductInfo, nearestStartTime = ",nearestStartTime,",name = ",name,",MainController.curGameId_ = ",MainController.curGameId_)
    local curGameId = MainController.curGameId_
    if curGameId == JJGameDefine.GAME_ID_LORD_UNION or curGameId == JJGameDefine.GAME_ID_LORD_UNION_HL then
        curGameId = JJGameDefine.GAME_ID_LORD
    end
    if recomMatch and #recomMatch > 0 then
        for k, tourneyInfo in pairs(recomMatch) do
            local matchStartTime = tourneyInfo:getSignupTime()
            -- JJLog.i("TAG","MatchRecommendManager:getMatchPromptProductInfo,tourneyId=",tourneyInfo.tourneyId_,",matchStartTime=",matchStartTime,",status_=",tourneyInfo.status_,",gameId=",tourneyInfo.matchconfig_.gameId)
            if matchStartTime > curTime 
                and matchStartTime - beforeRemindTime < curTime 
                and (nearestStartTime == 0 or nearestStartTime < matchStartTime - signupedProtect or nearestStartTime > matchStartTime + signupedProtect)
                and tourneyInfo.matchconfig_ and tonumber(tourneyInfo.matchconfig_.gameId) == curGameId then

                    TourneyController:checkSignupReqirement(tourneyInfo)
                    if tourneyInfo.status_ == MatchDefine.STATUS_SIGNUPABLE then
                        -- JJLog.i("TAG","MatchRecommendManager:getMatchPromptProductInfo, return  tourneyInfo= ",vardump(tourneyInfo))
                        return tourneyInfo
                    end
            end
        end
    end

    return nil
end

return MatchRecommendManager
