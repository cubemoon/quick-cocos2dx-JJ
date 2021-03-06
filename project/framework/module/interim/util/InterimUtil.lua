require("bit")
InterimUtil = {}

--显示成科学计数法“10,000”
function InterimUtil:getStandBetChipsDisp(bets)
    JJLog.i("InterimUtil", "getStandBetChipsDisp bets=",bets);

    local retValue=""
    --string.format("%s%d%s%d%s"
    if bets<=1000 then
        --不动
        retValue =  string.format("%d",bets)
    elseif bets>1000 and bets<100000000 then
        --不带K
        while bets>1000 do
            local low = bets-(math.modf(bets/1000)* 1000)
            if low == 0 then
                retValue=string.format("%s%s%s",",","000",retValue)
            elseif low<10 then
                retValue=string.format("%s%s%d%s",",","00",low,retValue)
            elseif low<100 then
                retValue=string.format("%s%s%d%s",",","0",low,retValue)
            else
                retValue=string.format("%s%d%s",",",low,retValue)
            end
            bets = math.modf(bets/1000)
            if bets<1000 then
                retValue=string.format("%d%s",bets,retValue)
            end
        end

    elseif bets>=100000000 and bets< 100000000000 then
        --带k
        bets = math.modf(bets/1000)
        while bets>1000 do
            local low = bets-(math.modf(bets/1000)* 1000)
            if low == 0 then
                retValue=string.format("%s%s%s",",","000",retValue)
            elseif low<10 then
                retValue=string.format("%s%s%d%s",",","00",low,retValue)
            elseif low<100 then
                retValue=string.format("%s%s%d%s",",","0",low,retValue)
            else
                retValue=string.format("%s%d%s",",",low,retValue)
            end
            bets = math.modf(bets/1000)
            if bets<1000 then
                retValue=string.format("%d%s",bets,retValue)
            end
        end
        retValue=string.format("%s%s",retValue,"k")

    elseif bets>=100000000000 then
        --带m
        bets = math.modf(bets/1000000)
        while bets>1000 do
            local low = bets-(math.modf(bets/1000)* 1000)
            if low == 0 then
                retValue=string.format("%s%s%s",",","000",retValue)
            elseif low<10 then
                retValue=string.format("%s%s%d%s",",","00",low,retValue)
            elseif low<100 then
                retValue=string.format("%s%s%d%s",",","0",low,retValue)
            else
                retValue=string.format("%s%d%s",",",low,retValue)
            end
            bets = math.modf(bets/1000)
            if bets<1000 then
                retValue=string.format("%d%s",bets,retValue)
            end
        end
        retValue=string.format("%s%s",retValue,"m")
    end
    JJLog.i("InterimUtil", "getStandBetChipsDisp retValue=",retValue);
    return retValue
end

--显示成科学计数法“10,000”
--少位数算法
function InterimUtil:getStandBetChipsDispShort(bets)
    JJLog.i("InterimUtil", "getStandBetChipsDisp bets=",bets);

    local retValue=""
    --string.format("%s%d%s%d%s"
    if bets<=1000 then
        --不动
        retValue =  string.format("%d",bets)
    elseif bets>1000 and bets<10000 then
        --不带K
        while bets>1000 do
            local low = bets-(math.modf(bets/1000)* 1000)
            if low == 0 then
                retValue=string.format("%s%s%s",",","000",retValue)
            elseif low<10 then
                retValue=string.format("%s%s%d%s",",","00",low,retValue)
            elseif low<100 then
                retValue=string.format("%s%s%d%s",",","0",low,retValue)
            else
                retValue=string.format("%s%d%s",",",low,retValue)
            end
            bets = math.modf(bets/1000)
            if bets<1000 then
                retValue=string.format("%d%s",bets,retValue)
            end
        end

    elseif bets>=10000 and bets< 1000000 then
        --带k
        bets = math.modf(bets/1000)
        if bets<1000 then
            retValue=string.format("%d%s",bets,retValue)
        end
        while bets>1000 do
            local low = bets-(math.modf(bets/1000)* 1000)
            if low == 0 then
                retValue=string.format("%s%s%s",",","000",retValue)
            elseif low<10 then
                retValue=string.format("%s%s%d%s",",","00",low,retValue)
            elseif low<100 then
                retValue=string.format("%s%s%d%s",",","0",low,retValue)
            else
                retValue=string.format("%s%d%s",",",low,retValue)
            end
            bets = math.modf(bets/1000)
            if bets<1000 then
                retValue=string.format("%d%s",bets,retValue)
            end
        end
        retValue=string.format("%s%s",retValue,"k")

    elseif bets>=1000000 then
        --带m
        bets = math.modf(bets/1000000)
        while bets>1000 do
            local low = bets-(math.modf(bets/1000)* 1000)
            if low == 0 then
                retValue=string.format("%s%s%s",",","000",retValue)
            elseif low<10 then
                retValue=string.format("%s%s%d%s",",","00",low,retValue)
            elseif low<100 then
                retValue=string.format("%s%s%d%s",",","0",low,retValue)
            else
                retValue=string.format("%s%d%s",",",low,retValue)
            end
            bets = math.modf(bets/1000)
            if bets<1000 then
                retValue=string.format("%d%s",bets,retValue)
            end
        end
        retValue=string.format("%s%s",retValue,"m")
    end
    JJLog.i("InterimUtil", "getStandBetChipsDisp retValue=",retValue);
    return retValue
end

return InterimUtil