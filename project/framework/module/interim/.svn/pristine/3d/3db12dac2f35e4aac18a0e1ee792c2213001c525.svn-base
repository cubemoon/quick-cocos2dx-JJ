require("game.def.JJGameDefine")
require("game.def.GrowWareIdDef")

local interimTitleDefine = class("interimTitleDefine", require("game.data.lobby.TitleDefine"))


local interimTitle = {
    {experience=0, masterScore=0, feat=0, cert=0, title="新手"},
    {experience=100, masterScore=0, feat=0, cert=0, title="1级(一级选手)"},
    {experience=200, masterScore=0, feat=0, cert=0, title="2级(二级选手)"},
    {experience=400, masterScore=0, feat=0, cert=0, title="3级(三级选手)"},
    {experience=700, masterScore=0, feat=0, cert=0, title="4级(四级选手)"},
    {experience=1100, masterScore=0, feat=0, cert=0, title="5级(五级选手)"},

    {experience=1600, masterScore=0, feat=0, cert=0, title="6级(六级选手)"},
    {experience=2200, masterScore=0, feat=0, cert=0, title="7级(七级选手)"},
    {experience=2900, masterScore=0, feat=0, cert=0, title="8级(八级选手)"},
    {experience=3700, masterScore=0, feat=0, cert=0, title="9级(九级选手)"},
    {experience=4600, masterScore=0, feat=0, cert=0, title="10级(十级选手)"},

    {experience=10000, masterScore=1, feat=0, cert=0, title="11级(一级高手)"},
    {experience=15000, masterScore=2, feat=0, cert=0, title="12级(二级高手)"},
    {experience=25000, masterScore=3, feat=0, cert=0, title="13级(三级高手)"},
    {experience=40000, masterScore=4, feat=0, cert=0, title="14级(四级高手)"},
    {experience=60000, masterScore=5, feat=0, cert=0, title="15级(五级高手)"},

    {experience=85000, masterScore=10, feat=0, cert=0, title="16级(六级高手)"},
    {experience=115000, masterScore=15, feat=0, cert=0, title="17级(七级高手)"},
    {experience=150000, masterScore=20, feat=0, cert=0, title="18级(八级高手)"},
    {experience=190000, masterScore=25, feat=0, cert=0, title="19级(九级高手)"},
    {experience=235000, masterScore=30, feat=0, cert=0, title="20级(十级高手)"},

    {experience=500000, masterScore=50, feat=0, cert=0, title="21级(一级专家)"},
    {experience=600000, masterScore=60, feat=0, cert=0, title="22级(二级专家)"},
    {experience=800000, masterScore=80, feat=0, cert=0, title="23级(三级专家)"},
    {experience=1100000, masterScore=100, feat=0, cert=0, title="24级(四级专家)"},
    {experience=1500000, masterScore=120, feat=0, cert=0, title="25级(五级专家)"},

    {experience=2000000, masterScore=150, feat=0, cert=0, title="26级(六级专家)"},
    {experience=2600000, masterScore=200, feat=0, cert=0, title="27级(七级专家)"},
    {experience=3300000, masterScore=300, feat=0, cert=0, title="28级(八级专家)"},
    {experience=4100000, masterScore=400, feat=0, cert=0, title="29级(九级专家)"},
    {experience=5000000, masterScore=500, feat=0, cert=0, title="30级(十级专家)"},

    {experience=10000000, masterScore=1000, feat=0, cert=0, title="31级(一星大师)"},
    {experience=1500000, masterScore=2000, feat=0, cert=0, title="32级(二星大师)"},
    {experience=2000000, masterScore=3000, feat=0, cert=0, title="33级(三星大师)"},
    {experience=3000000, masterScore=4000, feat=0, cert=0, title="34级(四星大师)"},
    {experience=4000000, masterScore=5000, feat=0, cert=0, title="35级(五星大师)"},
    {experience=5000000, masterScore=6000, feat=0, cert=0, title="36级(六星大师)"},
    {experience=6000000, masterScore=8000, feat=0, cert=0, title="37级(七星大师)"},
    {experience=7000000, masterScore=10000, feat=0, cert=0, title="38级(八星大师)"},
    {experience=8000000, masterScore=12000, feat=0, cert=0, title="39级(九星大师)"},
    {experience=10000000, masterScore=15000, feat=0, cert=0, title="40级(卡当至尊)"},
 }



function interimTitleDefine:hasTitle(gameId)
    if gameId == JJGameDefine.GAME_ID_INTERIM then
        return true
    end
end    

function interimTitleDefine:getTitleData(gameId)
    local data = nil
    if gameId == JJGameDefine.GAME_ID_INTERIM then
        data = interimTitle   
    else
        data = {}
    end
    return data
end    

function interimTitleDefine:getTitle(gameId)
    JJLog.i(gameId)
    local title = nil
    
    if gameId == JJGameDefine.GAME_ID_INTERIM then
        JJLog.i(#interimTitle)
        title = interimTitle[1].title

        local exp = UserInfo:getGrowCount(GrowWareIdDef.INTERIM_GROW_EXPERIENCE_ID)
        local masterScore = UserInfo:getGrowCount(GrowWareIdDef.INTERIM_GROW_MASTER_SCORE_ID)

        for _, record in ipairs(interimTitle) do
            if exp >= record.experience and masterScore >= record.masterScore then
                title = record.title
            else
                break --不满足条件，结束不需要再比较，就是上一个值了
            end
        end   
    end

    return title
end    

return interimTitleDefine