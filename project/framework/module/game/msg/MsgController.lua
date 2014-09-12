-- 消息处理
-- define global module
MsgController = {}
local TAG = "[MsgController]"

import(".LobbyMsgController")
import(".MatchMsgController")
import(".TourneyMsgController")
import(".MobileAgentMsgController")
import(".SMSMsgController")
import(".HttpMsgController")
import(".ConfigMsgController")
import(".MatchInfoMsgController")
import(".ECAServiceMsgController")
import(".MatchViewMsgController")
import(".HBaseMsgController")
import(".MatchInfoMsgController")

import("game.pb.LobbyMsg")
import("game.pb.MatchMsg")
import("game.pb.MobileAgentMsg")
import("game.pb.TourneyMsg")
import("game.pb.HttpMsg")
import("game.pb.MatchInfoMsg")

-- 游戏是否存在
local pokerExist_ = false
local lordExist_ = false
local lzlordExist_ = false
local pklordExist_ = false
local niuniuExist_ = false
local mahjongBR_ = false
local mahjongSC_ = false
local hllordExist_ = false
local mahjongTP_ = false
local mahjong_ = false
local interimExist_ = false
local runfastExist_ = false
local threeCardExist_ = false
local mahjongpublicExist_ = false
local mahjongtdhExist_ = false

-- 消息处理接口：分发消息
function MsgController.handleMsg(msg)

    local ack = PBMsg:decode(msg.buf, msg.len)

    if ack == nil then
        JJLog.e("MsgController.handleMsg msg is null")
        return nil
    end

    if (ack ~= nil and ack ~= false) then
        ack.type = SDKMsgDef.TYPE_NET_MSG
        ack[MSG_CATEGORY] = UNKNOWN_ACK_MSG
        ack[MSG_TYPE] = UNKNOWN_ACK_MSG
        if #ack.lobby_ack_msg ~= 0 then
            LobbyMsgController:handleMsg(ack)

        elseif #ack.tourney_ack_msg ~= 0 then
            TourneyMsgController:handleMsg(ack)

        elseif #ack.match_ack_msg ~= 0 then
            MatchMsgController:handleMsg(ack, msg.gameId)

        elseif #ack.config_ack_msg ~= 0 then
            ConfigMsgController:handleMsg(ack)

        elseif #ack.hbase_ack_msg ~= 0 then
            HBaseMsgController:handleMsg(ack)

        elseif #ack.http_ack_msg ~= 0 then
            HttpMsgController:handleMsg(ack)

        elseif #ack.matchinfo_ack_msg ~= 0 then
            MatchInfoMsgController:handleMsg(ack,msg.gameId)

        elseif #ack.matchview_ack_msg ~= 0 then
            MatchViewMsgController:handleMsg(ack)

        elseif #ack.mobileagent_ack_msg ~= 0 then
            MobileAgentMsgController:handleMsg(ack)

        elseif #ack.sms_ack_msg ~= 0 then
            SMSMsgController:handleMsg(ack)

        elseif #ack.ecaservice_ack_msg ~= 0 then
            ECAServiceMsgController:handleMsg(ack)

        -- 德州
        elseif #ack.poker_ack_msg ~= 0 then

            if not pokerExist_ and JJFileUtil:exist("poker/msg/PokerMsgController.lua") then
                require("poker.msg.PokerMsgController")
                pokerExist_ = true
            end
            if pokerExist_ then
                PokerMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has poker msg, not has poker files !!")
            end

        -- 斗地主
        elseif #ack.lord_ack_msg ~= 0 then

            if not lordExist_ and JJFileUtil:exist("lordunion/msg/LordMsgController.lua") then
                require("lordunion.msg.LordMsgController")
                lordExist_ = true
            end
            if lordExist_ then
                LordMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has lord msg, not has lord files !!")
            end

        -- 赖斗
        elseif #ack.lzlord_ack_msg ~= 0 then

            if not lzlordExist_ and JJFileUtil:exist("lordunion/msg/LZLordMsgController.lua") then
                require("lordunion.msg.LZLordMsgController")
                lzlordExist_ = true
            end
            if lzlordExist_ then                
                LZLordMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has lzlord msg, not has lzlord files !!")
            end

        -- 二斗
        elseif #ack.pklord_ack_msg ~= 0 then

            if not pklordExist_ and JJFileUtil:exist("lordunion/msg/PKLordMsgController.lua") then
                require("lordunion.msg.PKLordMsgController")
                pklordExist_ = true
            end
            if pklordExist_ then
                PKLordMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has pklord msg, not has pklord files !!")
            end

        -- 欢斗
        elseif #ack.hllord_ack_msg ~= 0 then
            if not hllordExist_ and JJFileUtil:exist("lordunion/msg/HLLordMsgController.lua") then
                require("lordunion.msg.HLLordMsgController")
                hllordExist_ = true
            end
            if hllordExist_ then
                HLLordMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has hllord msg, not has hllord files !!")
            end
            
            -- 二麻
        elseif #ack.mahjongtp_ack_msg ~= 0 then
            if not mahjongTP_ and JJFileUtil:exist("mahjongtp/msg/MahjongTPMsgController.lua") then
                require("mahjongtp.msg.MahjongTPMsgController")
                mahjongTP_ = true
            end
            if mahjongTP_ then
                MahjongTPMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has mahjongTP msg, not has mahjongTP files !!")
            end
            
                -- 四麻
        elseif #ack.mahjong_ack_msg ~= 0 then
            if not mahjong_ and JJFileUtil:exist("mahjong/msg/MahjongMsgController.lua") then
                require("mahjong.msg.MahjongMsgController")
                mahjong_ = true
            end
            if mahjong_ then
                MahjongMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has mahjong msg, not has mahjong files !!")
            end

        -- 斗牛
        elseif #ack.douniu_ack_msg ~= 0 then
            if not niuniuExist_ and JJFileUtil:exist("niuniu/msg/NiuNiuMsgController.lua") then
                require("niuniu.msg.NiuNiuMsgController")
                niuniuExist_ = true
            end
            if niuniuExist_ then
                NiuNiuMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has NiuNiu msg, not has NiuNiu files !!")
            end

        -- 血麻
        elseif #ack.mahjongbr_ack_msg ~= 0 then
            if not mahjongBR_ and JJFileUtil:exist("mahjongbr/msg/MahjongBRMsgController.lua") then
                require("mahjongbr.msg.MahjongBRMsgController")
                mahjongBR_ = true
            end
            if mahjongBR_ then
                MahjongBRMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has mahjongBR msg, not has mahjongBR files !!")
            end

        -- 川麻
        elseif #ack.mahjongscn_ack_msg ~= 0 then
            if not mahjongSC_ and JJFileUtil:exist("mahjongsc/msg/MahjongSCMsgController.lua") then
                require("mahjongsc.msg.MahjongSCMsgController")
                mahjongSC_ = true
            end
            if mahjongSC_ then
                MahjongSCMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has mahjongSC msg, not has mahjongSC files !!")
            end
        elseif #ack.interim_ack_msg ~= 0 then
            if not interimExist_ and JJFileUtil:exist("interim/msg/InterimMsgController.lua") then
                require("interim.msg.InterimMsgController")
                interimExist_ = true
            end
            if interimExist_ then
                InterimMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has interim msg, not has interimExist_ files !!")
            end
        elseif #ack.runfast_ack_msg ~= 0 then
            if not runfastExist_ and JJFileUtil:exist("runfast/msg/RunFastMsgController.lua") then
                require("runfast.msg.RunFastMsgController")
                runfastExist_ = true
            end
            if runfastExist_ then
                RunFastMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has runfast msg, not has runfastExist_ files !!")
            end
            -- 赢三张
        elseif #ack.threecard_ack_msg ~= 0 then
            if not threeCardExist_ and JJFileUtil:exist("threecard/msg/ThreeCardMsgController.lua") then
                require("threecard.msg.ThreeCardMsgController")
                threeCardExist_ = true
            end
            if threeCardExist_ then
                ThreeCardMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has threeCard msg, not has threeCard files !!")
            end
        --大众麻将
        elseif #ack.mahjongdz_ack_msg ~= 0 then
            if not mahjongpublicExist_ and JJFileUtil:exist("mahjongpublic/msg/MahjongpublicMsgController.lua") then
                require("mahjongpublic.msg.MahjongpublicMsgController")
                mahjongpublicExist_ = true
            end
            if mahjongpublicExist_ then
                MahjongpublicMsgController:handleMsg(ack)
            else
               JJLog.i(TAG, "has mahjongpublic msg, not has mahjongpublic files !!") 
            end
        --推倒胡麻将 --ack.mahjongtdh_ack_msg的定义参见http://192.168.10.51/svn/04_quick/projects/protoc/TKMobile.proto
        elseif #ack.mahjongtdh_ack_msg ~= 0 then
            if not mahjongtdhExist_ and JJFileUtil:exist("mahjongtdh/msg/MahjongtdhMsgController.lua") then
                require("mahjongtdh.msg.MahjongtdhMsgController")
                mahjongtdhExist_ = true
            end
            if mahjongtdhExist_ then
                MahjongtdhMsgController:handleMsg(ack)
            else
                JJLog.i(TAG, "has mahjongtdh msg, not has mahjongtdh files !!")
            end
        end
        JJSDK:pushMsgToSceneController(ack)
    else
        JJLog.i(TAG, "handleMsg, ack == nil")
    end

    return ack
end
