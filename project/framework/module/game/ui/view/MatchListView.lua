
local JJViewGroup = import("sdk.ui.JJViewGroup")
local MatchListView = class("MatchListView", JJViewGroup)
local JJBaseAdapter = import("sdk.ui.JJBaseAdapter")
local MatchListAdapter = class("MatchListAdapter", JJBaseAdapter)
local JJListCell = import("sdk.ui.JJListCell")
local MatchListCell = class("MatchListCell", JJListCell)
local MatchView = import(".MatchView")

local TAG = "MatchListView"

function MatchListCell:ctor(params, customParam)
    MatchListCell.super.ctor(self)    
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.scene_ = params.scene
    self.width_ = self.dimens_.width
    self.height_ = self.dimens_:getDimens(329)
    self.cellHeight_ = self.dimens_:getDimens(103)
    self:setViewSize(self.dimens_.width, self.height_)
    if params.gameId == JJGameDefine.GAME_ID_LORD_SINGLE then
        self.singleGameManager_ = params.singleGameManager
    end
    local item1, item2, item3, item4, item5, item6 =nil,nil,nil,nil, nil , nil

    local getNewMatchViewParam = function (pos, item)
        if params.gameId == JJGameDefine.GAME_ID_LORD_SINGLE then
            return {theme = self.theme_, dimens = self.dimens_, scene = self.scene_, position = pos, gameId = params.gameId, singleMatchData = item, singleGameManager = self.singleGameManager_}
        else
            return {theme = self.theme_, dimens = self.dimens_, scene = self.scene_, position = pos, gameId = params.gameId, tourneyInfo = item}
        end
    end
    if params.item1 ~= nil then
        item1 = MatchView.new(getNewMatchViewParam(1, params.item1),customParam)
    end

    if params.item2 ~= nil then
        item2 = MatchView.new(getNewMatchViewParam(2, params.item2),customParam)
    end

    if params.item3 ~= nil then
        item3 = MatchView.new(getNewMatchViewParam(3, params.item3),customParam)
    end

    if params.item4 ~= nil then
        item4 = MatchView.new(getNewMatchViewParam(4, params.item4),customParam)
    end

    if params.item5 ~= nil then
        item5 = MatchView.new(getNewMatchViewParam(5, params.item5),customParam)
    end

    if params.item6 ~= nil then
        item6 = MatchView.new(getNewMatchViewParam(6, params.item6),customParam)
    end

    local left,top = 0,0

    if item1 ~= nil then
        item1:setAnchorPoint(ccp(0, 1))
        left = self.dimens_.width/2 - (337+7)*self.dimens_.scale_
        top = self.height_
        item1:setPosition(ccp(left, top))
        self:addView(item1)
    end

    if item3 ~= nil then
        item3:setAnchorPoint(ccp(0, 1))
        top = top - self.cellHeight_ - self.dimens_:getDimens(5)
        item3:setPosition(ccp(left, top))
        self:addView(item3)
    end

    if item5 ~= nil then
        item5:setAnchorPoint(ccp(0, 1))
        top = top - self.cellHeight_ - self.dimens_:getDimens(5)
        item5:setPosition(ccp(left, top))
        self:addView(item5)
    end

    if item2 ~= nil then
        item2:setAnchorPoint(ccp(0, 1))
        left = self.dimens_.width/2 + self.dimens_:getDimens(7)
        top = self.height_
        item2:setPosition(left, top)
        self:addView(item2)
    end

    if item4 ~= nil then
        item4:setAnchorPoint(ccp(0, 1))
        top = top - self.cellHeight_ - self.dimens_:getDimens(5)
        item4:setPosition(ccp(left, top))
        self:addView(item4)
    end

    if item6 ~= nil then
        item6:setAnchorPoint(ccp(0, 1))
        top = top - self.cellHeight_ - self.dimens_:getDimens(5)
        item6:setPosition(ccp(left, top))
        self:addView(item6)
    end
end

function MatchListCell:getHeight()
    return self.height_
end

function MatchListCell:getWidth()
    return self.width_
end

function MatchListCell:getSize()
    return CCSizeMake(self.width_, self.height_)
end

function MatchListAdapter:ctor(params,customParam)
    MatchListAdapter.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.scene_ = params.scene
    self.gameId_ = params.gameId
    self.zoneId_ = params.zoneId
    self.items_ = params.items    
    self.isLordSingle_ = params.gameId == JJGameDefine.GAME_ID_LORD_SINGLE
    self.customParam_ = customParam
    if self.isLordSingle_ then
        self.singleMatchList_ = params.lordSingleMatchDatas
        self.singleGameManager_ = params.singleGameManager
        JJLog.i(TAG, "singleMatchList_ size is ", #self.singleMatchList_)
    else
        self.tourneylist_ = self.items_
    end
end

function MatchListAdapter:getCount()
    JJLog.i(TAG, "getCount() ")
    local itemList = nil

    if self.isLordSingle_ then
        itemList = self.singleMatchList_
    else
        itemList = self.tourneylist_
    end
    if itemList ~= nil then
        return math.ceil(#itemList/6)
    else
        print(" err has no tourneylist ")
        return 0
    end
end

function MatchListAdapter:getView(position)
    local itemList = nil
    if self.isLordSingle_ then
        itemList = self.singleMatchList_
    else
        itemList = LobbyDataController:getTourneyListByZoneId(self.gameId_, self.zoneId_)
    end
    
    local listCellParam = {
        theme = self.theme_,
        dimens = self.dimens_,
        scene = self.scene_,
        position = position,
        gameId = self.gameId_,
        singleGameManager = self.singleGameManager_,
        item1 = itemList[(position-1)*6+1],
        item2 = itemList[(position-1)*6+2],
        item3 = itemList[(position-1)*6+3],
        item4 = itemList[(position-1)*6+4],
        item5 = itemList[(position-1)*6+5],
        item6 = itemList[(position-1)*6+6],        
    }
    
    return MatchListCell.new(listCellParam,self.customParam_)
end

function MatchListAdapter:getItemId(position)
    return position
end

function MatchListView:ctor(params,customParam)
    MatchListView.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.scene_ = params.scene
    self.zoneId_ = params.zoneId
    self.gameId_ = params.gameId
    self.urlColor_ = params.urlColor
    self.customParam_ = customParam
    self:setViewSize(self.dimens_.width, self.dimens_.height)
    self.isLordSingle_ = params.gameId == JJGameDefine.GAME_ID_LORD_SINGLE
    if self.isLordSingle_ then
        self.items_ = params.lordSingleMatchDatas
        self.singleGameManager_ = params.singleGameManager
    else
        self.items_ = LobbyDataController:getTourneyListByZoneId(self.gameId_, params.zoneId)        
    end

    -- url font color
    if self.urlColor_ == nil then
        self.urlColor_ = ccc3(0x11, 0x44, 0x77)
    end

    self.identityImage_ = {}

    local left, top = 0, 0

    local adapterParams = {
        theme = self.theme_,
        dimens = self.dimens_,
        zoneId = params.zoneId,
        scene = params.scene,
        gameId = params.gameId,
        items = self.items_,
    }
    if self.isLordSingle_ then
        adapterParams.lordSingleMatchDatas = self.items_
        adapterParams.singleGameManager = self.singleGameManager_
    end

    self.galleryView_ = jj.ui.JJGalleryView.new({
        viewSize = CCSize(self.dimens_.width, self.dimens_:getDimens(103*3+20)),
        adapter = MatchListAdapter.new(adapterParams,self.customParam_)
    })
    self.galleryView_:setAnchorPoint(ccp(0, 0))
    top = self.dimens_.cy - self.dimens_:getDimens(54*3+10)
    self.galleryView_:setPosition(0, top)
    self.galleryView_:setOnItemSelectedListener(handler(self, self.onItemSelected))
    self:addView(self.galleryView_)

    top = self.dimens_.cy - self.dimens_:getDimens(54*3)-self.dimens_:getDimens(27)
    if self.items_ then
        local count = math.ceil(#self.items_/6)
        local width = count*(self.dimens_:getDimens(12))+(count-1)*(self.dimens_:getDimens(10))
        local viewGroup = jj.ui.JJViewGroup.new({
            viewSize = CCSize(width, self.dimens_:getDimens(14))
        })
        viewGroup:setAnchorPoint(ccp(0.5,0))
        viewGroup:setPosition(self.dimens_.cx, top)
        for i = 1, count do
            left = (i-1)*self.dimens_:getDimens(10+12)
            self.identityImage_[i] = jj.ui.JJImage.new({
                image = self.theme_:getImage("matchselect/identity_icon_unfocus.png"),
            })
            self.identityImage_[i]:setAnchorPoint(ccp(0, 0))
            self.identityImage_[i]:setPosition(left, 0)
            self.identityImage_[i]:setScale(self.dimens_.scale_)
            viewGroup:addView(self.identityImage_[i])
        end
        self:setIdentity(1)
        if count > 1 then
            self:addView(viewGroup)
        end
    end
    
    local url = jj.ui.JJLabel.new({
            text = "www.jj.cn",
            fontSize = self.dimens_:getDimens(22),
            color = self.urlColor_,
        })
    url:setAnchorPoint(ccp(1, 0))
    url:setPosition(ccp(self.dimens_.width - self.dimens_:getDimens(20), self.dimens_:getDimens(40)))
    self:addView(url)

end

function MatchListView:onItemSelected(list, child, childIndex, childId)
    self:setIdentity(childIndex)
end


function MatchListView:setIdentity(index)
    local count = math.ceil(#self.items_/6)
    if count > 1 then
        if self.identityImage_[index] then
            for i = 1 , count do
                if index == i then
                    self.identityImage_[index]:setImage(self.theme_:getImage("matchselect/identity_icon_focus.png"), false)
                else
                    self.identityImage_[i]:setImage(self.theme_:getImage("matchselect/identity_icon_unfocus.png"), false)
                end
            end
        end
    end
end

function MatchListView:refresh()    
    self.galleryView_:refreshGalleryView()
end

return MatchListView
