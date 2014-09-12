local JJViewGroup = import("sdk.ui.JJViewGroup")
local ZonesView = class("ZonesView", JJViewGroup)
local TAG = "ZonesView"

ZonesView.ZONE_ID1 = 1
ZonesView.ZONE_ID2 = 2
ZonesView.ZONE_ID3 = 3
ZonesView.ZONE_ID4 = 4

function ZonesView:ctor(scene, theme, dimens, controller,customParam)
    ZonesView.super.ctor(self)
    local maxZone = customParam.maxZone
    self.theme_ = theme
    self.scene_ = scene
    local left = 0
    local width = 854/maxZone
    local height = 0
    -- 两个赛区等比例不协调，特殊处理下
    if maxZone == 2 then
        for i = 1, maxZone do
            local zoneView = string.format("zoneView%d_",i)
            local normalImage = string.format("matchselect/lobby_zone_%d_n.png",i)
            local selectImage = string.format("matchselect/lobby_zone_%d_d.png",i)
            zoneView = jj.ui.JJButton.new({
                images = {
                    normal = self.theme_:getImage(normalImage),
                    highlight = self.theme_:getImage(selectImage),
                },
                })
            if i == 1 then
                left = width/2+40
            else
                left = width*3/2-40
            end
            local size = zoneView:getViewSize()
            height = size.height
            zoneView:setAnchorPoint(ccp(0.5, 1))
            zoneView:setPosition(ccp(left, height))
            zoneView:setId(i)
            zoneView:setOnClickListener(handler(self, self.onClick))
            self:addView(zoneView)
        end        
    else
        for i = 1, maxZone do
            local zoneView = string.format("zoneView%d_",i)
            local normalImage = string.format("matchselect/lobby_zone_%d_n.png",i)
            local selectImage = string.format("matchselect/lobby_zone_%d_d.png",i)
            zoneView = jj.ui.JJButton.new({
                images = {
                    normal = self.theme_:getImage(normalImage),
                    highlight = self.theme_:getImage(selectImage),
                },
                })
            left = width*(i-1/2)
            local size = zoneView:getViewSize()
            height = size.height
            zoneView:setAnchorPoint(ccp(0.5, 1))
            zoneView:setPosition(ccp(left, height))
            zoneView:setId(i)
            zoneView:setOnClickListener(handler(self, self.onClick))
            self:addView(zoneView)
        end
    end
    self:setViewSize(854, height)    
end

function ZonesView:onClick(view)
    JJLog.i(TAG, "onClick")

    if MainController:isLogin() then
        local zoneId = view:getId()
        self.scene_:showMatchListView(zoneId, true)
        self:setEnable(false)
    else
        LoginController:reInitLastRecord()
        self.scene_.controller_:startLogin()
    end
end

return ZonesView