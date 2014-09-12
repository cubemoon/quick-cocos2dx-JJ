-- lobby 数据接口管理文件

LobbyDataController = {}

-- 报名比赛
function LobbyDataController:signupMatch(gameId, tourneyId, matchPoint, signupType, tableId, confirmed)
    if SignupStatusManager:getSignupedItem(tourneyId) ~= nil then
        local dimens = 0
        local top = JJSDK:getTopSceneController()
        if top ~= nil then
            dimens = top.dimens_
        end     
        jj.ui.JJToast:show({
            text = "您已经报名！",
            dimens = dimens,
        })        
        return false
    end
    if SignupStatusManager:getSignupingItem(tourneyId) ~= nil then
        local dimens = 0
        local top = JJSDK:getTopSceneController()
        if top ~= nil then
            dimens = top.dimens_
        end     
        jj.ui.JJToast:show({
            text = "报名中...请稍等...",
            dimens = dimens,
        })        
        return false        
    end

    local signupItem = SignupStatusManager:getNearestTimedItem()
    local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tourneyId)
    if signupItem and tourneyInfo then        
        local curTime = JJTimeUtil:getCurrentSecond()
        local timeOffSignupedMatch = math.modf((signupItem.startTime_ - curTime)/60)
        local timeOffCurMatch = math.modf((tourneyInfo:getStartTimeEx() - curTime)/60)
        if tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.matchType == tostring(MatchDefine.MATCH_TYPE_FIXED) then
            if timeOffCurMatch < 120 and timeOffSignupedMatch < 20 then
                    if timeOffSignupedMatch <= 3 then
                        -- 您报名的%@即将开赛，您不能报名了。
                        local top = JJSDK:getTopSceneController()
                        if top ~= nil and top.scene_ ~= nil and top.scene_.currentView_ ~= nil then
                            top.scene_:removeSignupWaitDialog()
                        end                        

                        local str = string.format("您报名的%s即将开赛，您不能报名了。",signupItem.matchName_)
                        local dimens = 0
                        local top = JJSDK:getTopSceneController()
                        if top ~= nil then
                            dimens = top.dimens_
                        end     
                        jj.ui.JJToast:show({
                            text = str,
                            dimens = dimens,
                        })

                    else
                        local str = string.format("您报名的%s还有%d分钟开赛，是否继续报名？",signupItem.matchName_,timeOffSignupedMatch)
                        local top = JJSDK:getTopSceneController()
                        if top ~= nil and top.scene_ ~= nil and top.scene_.currentView_ ~= nil then
                            top.scene_:removeSignupWaitDialog()
                        end                           
                        if top ~= nil then
                                local param = {
                                str = str,
                                tourneyId = tourneyId,
                                matchPoint = matchPoint,
                                signupType = signupType,
                                gameId = gameId,
                            }
                            top:showSignupConfirmDialog(param)
                        end
                    end
                return false
            end
        else
            if timeOffCurMatch < 120 and timeOffSignupedMatch < 10 then
                    if timeOffSignupedMatch <= 3 then
                        -- 您报名的%@即将开赛，您不能报名了。                        
                        local top = JJSDK:getTopSceneController()
                        if top ~= nil and top.scene_ ~= nil and top.scene_.currentView_ ~= nil then
                            top.scene_:removeSignupWaitDialog()
                        end                        

                        local str = string.format("您报名的%s即将开赛，您不能报名了。",signupItem.matchName_)
                        local dimens = 0
                        local top = JJSDK:getTopSceneController()
                        if top ~= nil then
                            dimens = top.dimens_
                        end     
                        jj.ui.JJToast:show({
                            text = str,
                            dimens = dimens,
                        })

                    else
                        local str = string.format("您报名的%s还有%d分钟开赛，是否继续报名？",signupItem.matchName_,timeOffSignupedMatch)
                        local top = JJSDK:getTopSceneController()
                        if top ~= nil and top.scene_ ~= nil and top.scene_.currentView_ ~= nil then
                            top.scene_:removeSignupWaitDialog()
                        end                        
                        if top ~= nil then
                                local param = {
                                str = str,
                                tourneyId = tourneyId,
                                matchPoint = matchPoint,
                                signupType = signupType,
                                gameId = gameId,
                            }
                            top:showSignupConfirmDialog(param)
                        end                        
                    end
                return false
            end

        end
    end
    if UserInfo.userId_ ~= 0 and tourneyInfo and tourneyInfo.matchconfig_ then   
        SignupStatusManager:addSignupingItem(gameId,tourneyInfo.matchconfig_.productId, tourneyId)
        LobbyMsg:sendTourneySignupExReq(UserInfo.userId_, tourneyId, matchPoint, signupType, gameId)
        return true
    else 
        return false
    end
end

function LobbyDataController:unSignupMatch(tourneyId)
    if UserInfo.userId_ ~= 0 then
        local matchPoint = 0
        local userId = UserInfo.userId_
        local signupItem = SignupStatusManager:getSignupedItem(tourneyId)
        if signupItem == nil then
            local item = MatchPointManager:getLastMatchPoint(tourneyId)
            if item ~= nil and item.matchpoint > 0 then
                matchPoint = item.matchpoint 
            else
                matchPoint = 0
            end
        else
            matchPoint = signupItem.matchPoint_
        end
        LobbyMsg:sendTourneyUnsignupReq(userId, tourneyId, matchPoint)    
        return true
    else 
        return false
    end
end

-- 通过tourenyid 得到tourneyinfo信息
function LobbyDataController:getTourneyInfoByTourneyId(tourneyId)
    return TourneyController:getTourneyInfoByTourneyId(tourneyId)
end

-- 得到某个游戏其中一个赛区的所以tourneyinfo 信息
function LobbyDataController:getTourneyListByZoneId(gameId, zoneId)
    return TourneyController:getTourneyListByZoneId(gameId, zoneId)
end

-- 根据tourneyId 得到gameid
function LobbyDataController:getGameIdByTourneyId(tourneyId)
    return TourneyController:getGameIdByTourneyId(tourneyId)
end

-- 根据matchId 得到gameid
function LobbyDataController:getGameIdByMatchId(matchId)
    return TourneyController:getGameIdByMatchId(matchId)
end

function LobbyDataController:getTourneyInfoListByProductId(productId)
    return TourneyController:getTourneyInfoListByProductId(productId)
end

return LobbyInterfaceController