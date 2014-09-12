
local JJViewGroup = import("sdk.ui.JJViewGroup")
local NoteMsgView = class("NoteMsgView", JJViewGroup)
local MsgListAdapter = class("MsgListAdapter", import("sdk.ui.JJBaseAdapter"))
local MsgListCell = class("MsgListCell", import("sdk.ui.JJListCell"))


local TAG = "NoteMsgView"
local nmCanClick_ = true
local function getSignupTourneyInfo(matchId, expirTime)
    local tInfo = nil
    local now = JJTimeUtil:getCurrentSecond()
    if now <= expirTime then
        local tList = LobbyDataController:getTourneyInfoListByProductId(matchId)
        local points, tm
        local function _sortTourneyList(a, b)
                return (a:getSignupTime(0) < b:getSignupTime(0))
       end
        table.sort(tList, _sortTourneyList)
        for i, info in pairs(tList) do
            if SignupStatusManager:getSignupedItem(info.tourneyId_) ~= nil then
                return tInfo
            end
            if info:getSignupTime() > now and SignupStatusManager:getSignupedItem(info.tourneyId_) == nil then
                tInfo = info
                break
            end
        end
    end
    return tInfo
end

local function getSignupStatus(matchId, expirTime)    
    local now = JJTimeUtil:getCurrentSecond()
    if now <= expirTime then
        local tList = LobbyDataController:getTourneyInfoListByProductId(matchId)
        for i, info in pairs(tList) do
            if SignupStatusManager:getSignupedItem(info.tourneyId_) ~= nil then
                return true
            end           
        end
    end
    return false
end

function MsgListCell:ctor(params)
    nmCanClick_ = false
    MsgListCell.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.width_ = params.width
    self.height_ = self.dimens_:getDimens(56)
    self.open_ = params.open
    self.item_ = params.item
    self.index_ = params.index

    local left, top = 0, 0
    -- title
    self.titleLayer_ = jj.ui.JJViewGroup.new()
    self.titleLayer_:setViewSize(self.width_, self.height_)
    self.titleLayer_:setAnchorPoint(ccp(0, 0))

    self.readIcon_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("notemsg/unread_note.png"),
    })
    self.readIcon_:setAnchorPoint(ccp(0, 0))
    self.readIcon_:setPosition(self.dimens_:getDimens(30), self.dimens_:getDimens(13))
    self.readIcon_:setScale(self.dimens_.scale_)
    self.titleLayer_:addView(self.readIcon_)

    self.title_ = jj.ui.JJLabel.new({
        text = self.item_.title,
        color = ccc3(107, 65, 23),
        fontSize = self.dimens_:getDimens(20),
        valign = ui.TEXT_VALIGN_CENTER,
        viewSize = CCSize(self.dimens_:getDimens(420), self.dimens_:getDimens(25)),
    })
    self.title_:setAnchorPoint(ccp(0, 0))   
    self.title_:setPosition(self.dimens_:getDimens(70), self.dimens_:getDimens(13))
    self.titleLayer_:addView(self.title_)

    self.proIcon_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("notemsg/notenmsg_img_open.png"),
        })
    self.proIcon_:setAnchorPoint(ccp(1, 0))
    self.proIcon_:setPosition(self.width_ - self.dimens_:getDimens(40), self.dimens_:getDimens(20))
    self.proIcon_:setScale(self.dimens_.scale_)
    self.titleLayer_:addView(self.proIcon_)

    -- 时间
    local left = self.width_ - self.dimens_:getDimens(80)
    local top = self.dimens_:getDimens(20)
    local date = string.sub(self.item_.add_time, 1, 10)
    self.date_ = jj.ui.JJLabel.new({
        text = date,
        color = display.COLOR_BLACK,
        fontSize = self.dimens_:getDimens(15),
        })
    self.date_:setAnchorPoint(ccp(1, 0))
    self.date_:setPosition(left, top)
    self.titleLayer_:addView(self.date_)

    if self.open_ then
        if self.item_.readFlag == 0 then
            self.item_.readFlag = 1
            if self.item_.noteFlag == 1 then
                NoteManager:refreshItem(MainController:getCurPackageId(),self.item_.key, self.item_, true, true)
            else
                NoteManager:refreshItem(UserInfo.userId_, self.item_.key,self.item_, false, true)
            end
        end
        self.proIcon_:setImage(self.theme_:getImage("notemsg/notenmsg_img_close.png"),false)

        -- 按钮
        left = self.width_ - self.dimens_:getDimens(40)
        top = self.dimens_:getDimens(10)
        -- 容错，后台填0的时候，这个值是 false
        if type(self.item_.match_expire) ~= "number" then
            self.item_.match_expire = 0
        end
        JJLog.i("notenmsg_signup_n12 = ",self.item_.match_id,getSignupTourneyInfo(self.item_.match_id, self.item_.match_expire)
                                        ,getSignupStatus(self.item_.match_id, self.item_.match_expire))
        if self.item_.noteFlag == 1 and JJTimeUtil:getCurrentSecond() < self.item_.match_expire then
            if string.len(self.item_.match_id) > 0 and getSignupTourneyInfo(self.item_.match_id, self.item_.match_expire) then
                self.btn_ = jj.ui.JJButton.new({
                    images = {
                        normal = self.theme_:getImage("notemsg/notenmsg_signup_n.png"),
                        highlight = self.theme_:getImage("notemsg/notenmsg_signup_d.png"),
                        disable = self.theme_:getImage("notemsg/notenmsg_signup_d.png"),
                    },
                    fontSize = 22,
                    color = display.COLOR_WHITE,
                    text = "报 名",
                })
                self.btn_:setAnchorPoint(ccp(1, 0))
                self.btn_:setPosition(left, top)
                self.btn_:setScale(self.dimens_.scale_)
                self.btn_:setOnClickListener(handler(self, self.onClick))
                self:addView(self.btn_)
--[[
                local btnText = jj.ui.JJLabel.new({
                        text = "报 名",      
                        color = display.COLOR_WHITE,      
                        fontSize = self.dimens_:getDimens(22),
                   })
                btnText:setAnchorPoint(ccp(0.5, 0.5))
                btnText:setPosition(left - self.btn_:getBoundingBoxWidth() * self.dimens_.scale_ / 2,
                                    top + self.btn_:getBoundingBoxHeight() * self.dimens_.scale_ / 2)
                self:addView(btnText)
]]
            elseif string.len(self.item_.match_id) > 0 and getSignupStatus(self.item_.match_id, self.item_.match_expire) then
                self.btn_ = jj.ui.JJButton.new({
                    images = {
                        normal = self.theme_:getImage("notemsg/notenmsg_signuped.png"),
                        highlight = self.theme_:getImage("notemsg/notenmsg_signuped.png"),
                        disable = self.theme_:getImage("notemsg/notenmsg_signuped.png"),
                    },
                    fontSize = 22,
                    color = display.COLOR_WHITE,
                    text = "",
                })
                self.btn_:setAnchorPoint(ccp(1, 0))
                self.btn_:setPosition(left, top)
                self.btn_:setScale(self.dimens_.scale_)
                --self.btn_:setOnClickListener(handler(self, self.onClick))
                self:addView(self.btn_)
            end
        elseif self.item_.noteFlag == 0 then
            self.btn_ = jj.ui.JJButton.new({
                images = {
                    normal = self.theme_:getImage("notemsg/notenmsg_delete_n.png"),
                    highlight = self.theme_:getImage("notemsg/notenmsg_delete_d.png"),
                },
                fontSize = 22,
                color = display.COLOR_WHITE,
                text = "删 除",
            })
            self.btn_:setAnchorPoint(ccp(1, 0))
            self.btn_:setPosition(left, top)
            self.btn_:setScale(self.dimens_.scale_)
            self.btn_:setOnClickListener(handler(self, self.onClick))
            self:addView(self.btn_)
--[[
             local btnText = jj.ui.JJLabel.new({
                        text = "删 除",      
                        color = display.COLOR_WHITE,      
                        fontSize = self.dimens_:getDimens(22),
                   })
            btnText:setAnchorPoint(ccp(0.5, 0.5))
            btnText:setPosition(left - self.btn_:getBoundingBoxWidth() * self.dimens_.scale_ / 2,
                                top + self.btn_:getBoundingBoxHeight() * self.dimens_.scale_ / 2)
            self:addView(btnText)
            ]]
        end



        top = self.dimens_:getDimens(10)

        local contentWidth = (self.btn_ ~= nil and self.btn_:isVisible()) and self.width_-self.dimens_:getDimens(120 + 80) or self.width_-self.dimens_:getDimens(120)
        local strContent = string.gsub(self.item_.content, "<br>", "\r\n")
        top = top + self.dimens_:getDimens(25)
        self.content_ = jj.ui.JJLabel.new({
            text = strContent,
            color = ccc3(169, 128, 89),
            fontSize = self.dimens_:getDimens(18),
			      singleLine=true,
            viewSize = CCSize(contentWidth, 0),
            })
        self.content_:setAnchorPoint(ccp(0, 0))
        self.content_:setPosition(self.dimens_:getDimens(60), top)
        if self.item_.url ~= nil and string.len(self.item_.url) > 0 then
            self.content_:setTouchEnable(true)
            self.content_:setColor(ccc3(28, 156, 34))                
            self.content_:setOnClickListener(handler(self, self.onClick))
        end
        self:addView(self.content_)

        top = top + self.content_:getViewSize().height + self.dimens_:getDimens(10)
        self.titleLayer_:setPosition(0, top)
        self:addView(self.titleLayer_)
        local height = top + self.dimens_:getDimens(56)
        self:setViewSize(self.width_, height)

        if self.btn_ then
            if(self.content_:getViewSize().height > self.dimens_:getDimens(90)) then
                self.btn_:setPositionY(top - self.dimens_:getDimens(90 - 10))
            end
        end
    else
        self.proIcon_:setImage(self.theme_:getImage("notemsg/notenmsg_img_open.png"),false)
        self.titleLayer_:setPosition(0, 0)
        self:addView(self.titleLayer_)
        self:setViewSize(self.width_, self.height_)
    end

    -- 分割线
    local divImg = jj.ui.JJImage.new({
        image = self.theme_:getImage("matchselect/match_item_split_h.png"),
        scale9 = true,
        viewSize = CCSize(self.width_ - self.dimens_:getDimens(80), self.dimens_:getDimens(2))
        })
    divImg:setAnchorPoint(ccp(0.5, 0.5))
    divImg:setPosition(self.width_ / 2, self.height_)
    self.titleLayer_:addView(divImg)

    if self.item_.noteFlag == 1 and self.item_.readFlag == 0 then
        self.readIcon_:setImage(self.theme_:getImage("notemsg/unread_note.png"),false)
    elseif self.item_.noteFlag == 1 and self.item_.readFlag == 1 then
        self.readIcon_:setImage(self.theme_:getImage("notemsg/read_note.png"),false)
    elseif self.item_.noteFlag == 0 and self.item_.readFlag == 1 then
        self.readIcon_:setImage(self.theme_:getImage("notemsg/read_msg.png"),false)
    elseif self.item_.noteFlag == 0 and self.item_.readFlag == 0 then
        self.readIcon_:setImage(self.theme_:getImage("notemsg/unread_msg.png"),false)
    end
    nmCanClick_ = true
end

function MsgListCell:getNoteKey()
	return self.item_.key
end

function MsgListCell:onClick(target)
    if target == self.btn_ then
        if self.item_.noteFlag == 1 then
            local tourneyInfo = getSignupTourneyInfo(self.item_.match_id, self.item_.match_expire)
            if tourneyInfo ~= nil then
                local gameId = tonumber(tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.gameId)
                local tourneyId = tourneyInfo.tourneyId_
                local matchPoint = tourneyInfo:getSignupTime()
                local matchType = tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.matchType_
                LobbyDataController:signupMatch(gameId, tourneyId, matchPoint, 0, 0, 0)
                --self:getParentView():refreshListView()
            end
        else
			self:getParentView():getAdapter():removeItem(self)
            self:getParentView():refreshListView()
        end
    elseif target == self.content_ then
        local url = self.item_.url
        Util:openSystemBrowser(url)
    end
end

function MsgListAdapter:ctor(params)
    MsgListAdapter.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.width_ = params.width
    self.items_ = NoteManager:getItems(MainController:getCurPackageId(), UserInfo.userId_)--MainController.packageId_
    self.open_ = {}
    if self.items_ ~= nil then
        for i = 1, #self.items_ do
            self.open_[i] = false
        end
        for i = 1, #self.items_ do
            if self.items_[i].readFlag == 0 then
                self.open_[i] = true
                break
            end
        end
    end
end

function MsgListAdapter:removeItem(view)
	NoteManager:removeItem(UserInfo.userId_, view:getNoteKey())
	table.remove(self.open_, view:getIdx())
	self:setData()
end

function MsgListAdapter:setData()
    self.items_ = NoteManager:getItems(MainController:getCurPackageId(), UserInfo.userId_)  --MainController.packageId_
end

function MsgListAdapter:getCount()
    if self.items_ == nil then
        return 0
    end
    return #self.items_
end

function MsgListAdapter:getItem(position)
    return self.open_
    -- [position]
end

function MsgListAdapter:getView(position)
    return MsgListCell.new({
        theme = self.theme_,
        dimens = self.dimens_,
        item = self.items_[position],
        width = self.width_,
        index = position,
        open = self.open_[position],
    })
end

function NoteMsgView:ctor(params)
    NoteMsgView.super.ctor(self)
    nmCanClick_ = true
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.scene_ = params.scene
    self.width_ = params.width
    self.height_ = params.height
    self.items_ = NoteManager:getItems(MainController:getCurPackageId(), UserInfo.userId_)--MainController.packageId_
    self:setViewSize(params.width, params.height)

    self.tableView_ = jj.ui.JJListView.new({
        viewSize = CCSize(self.width_, self.height_),
        adapter = MsgListAdapter.new({
            theme = self.theme_,
            dimens = self.dimens_,
            width = self.width_,
            height = self.height_,
            items = self.items_
        }),
    })
    self.tableView_:setAnchorPoint(ccp(0, 0))
    self.tableView_:setPosition(0, 0)
    self.tableView_:setOnItemSelectedListener(handler(self, self.onItemSelected))
    self:addView(self.tableView_)
end

function NoteMsgView:onItemSelected(list, child, childIndex, childId)
    if nmCanClick_ then
        list:getAdapter():getItem(childIndex)[childIndex] = not(list:getAdapter():getItem(childIndex)[childIndex])
        list:refreshListView()
    end
end

function NoteMsgView:refresh()
    if self.tableView_ ~= nil then
        self.tableView_:refreshListView()
    end
end

return NoteMsgView
