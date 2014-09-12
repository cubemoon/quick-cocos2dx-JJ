-- 散桌信息管理
MatchTableData = {}

local TAG = "MatchTableData"

local TourneyId = 0 --当前的tourneyid
local AllTableCount = 0 --对应的总桌数
local TableDatas = {} --所有的桌子信息

function MatchTableData:preparTables()
    --将type为1的明星桌放置在最后
    local normals, starts = {}, {}
    for _, v in ipairs(TableDatas) do
        if (v.type == 1) then
            table.insert(starts, v)
        else
            table.insert(normals, v)
        end
    end

    for _, v in ipairs(starts) do
        table.insert(normals, v)
    end

    TableDatas = normals
end

function MatchTableData:GetTableListAckHandler(ack)
    TourneyId = ack.tourneyid
    AllTableCount = ack.alltablecount
    TableDatas = ack.tabledata

    self:preparTables()
    --    JJLog.i(TAG,"GetTableListAckHandler",vardump(TableDatas))
end

function MatchTableData:getCurrentTourneyid()
    return TourneyId
end

function MatchTableData:getTableDatas(tourneyid)
    local tablelist = {}

    if (TourneyId == tourneyid) then
        tablelist = TableDatas
    end

    return tablelist
end

function MatchTableData:findTable(tourneyid, tableid)
    local tableinfo = nil

    if (TourneyId == tourneyid) then
        for i, v in ipairs(TableDatas) do
            if (v.tableid == tableid) then
                tableinfo = v
                break
            end
        end
    end

    return tableinfo
end

function MatchTableData:getPlayersDisplay(tourneyid, tableid)
    local ret = nil
    local pre = {}
    pre.nickname = "昵称"
    pre.score = "积分"

    local tableinfo = self:findTable(tourneyid, tableid)
    if (tableinfo and tableinfo.Players) then
        ret = clone(tableinfo.Players)
        table.insert(ret, 1, pre)
    else
        ret = pre
    end

    return ret
end

function MatchTableData:convertTablePlayers(players)
    local rets = {}
    for i, v in ipairs(players) do
        local player = {}
        player.userid = v.userid
        player.nickname = v.nickname
        player.score = v.score

        rets[i] = player
    end

    return rets
end

function MatchTableData:GetTablePlayerAckHandler(ack)
    local tableinfo = self:findTable(ack.tourneyid, ack.tableid)

    if (tableinfo) then
        tableinfo.Players = self:convertTablePlayers(ack.tableplayerdata)
    end

    --    JJLog.i(TAG,"GetTablePlayerAckHandler",vardump(TableDatas))
end

return MatchTableData