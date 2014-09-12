-- 奖状界面
local JJViewGroup = require("sdk.ui.JJViewGroup")
local Diploma = class("Diploma", JJViewGroup)
local WebViewController = require("game.ui.controller.WebViewController")

function Diploma:ctor(viewController)
    self.viewController_ = viewController
    self.dimens_ = viewController.dimens_
    self.theme_ = viewController.theme_

    Diploma.super.ctor(self, {viewSize = CCSize(self.dimens_:getDimens(650), self.dimens_:getDimens(384))})

    local width, top = self:getWidth(), self:getHeight()
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("diploma/diploma_bg.png"),
        })
    bg:setAnchorPoint(CCPoint(0.5, 0.5))    
    bg:setPosition(self.dimens_:getDimens(325), self.dimens_:getDimens(192))
    bg:setScaleX(self.dimens_.wScale_)
    bg:setScaleY(self.dimens_.hScale_)
    self:addView(bg)

    self.desciption = jj.ui.JJLabel.new({
        text = "悲剧了，你已出局，回去好好修炼吧",
        font = "Arial",
        fontSize = self.dimens_:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(109, 47, 14), --6d2f0e
        viewSize = CCSize(self.dimens_:getDimens(530), 0)
        })
    self.desciption:setAnchorPoint(CCPoint(0, 1))
    self.desciption:setPosition(self.dimens_:getDimens(60), top-self.dimens_:getDimens(120))
    self:addView(self.desciption)

    --[[self:setRank(1)
    self:setDiplomaDesc("恭喜你在本次比赛中获得冠军，成为本周的小明星，抓紧联系客服领取千元大奖吧")
    local awards = {
    {ID=1,type="金币",amount="10",},
    {ID=2,type="话费",amount="20",merit="可以给手机充值"},
    {ID=3,type="PK卷",amount="30",merit=""},
    {ID=4,type="神农顶",amount="1",merit="斗地主等级象征"},
    {ID=5,type="电影票",amount="1",merit="免费去任何一家影院观看"},
    {ID=6,type="CJ参观券",amount="1",merit="CJ看美女"},
    {ID=7,type="电视机",amount="1",merit="3D宽屏超清"},
}
    self:setAwardGlod(awards)]]
end

function Diploma:setRank(rank)
    local medal = nil
    if rank == 1 then
        medal = self.theme_:getImage("diploma/diploma_view_first.png")
    elseif rank == 2 then
        medal = self.theme_:getImage("diploma/diploma_view_second.png")
    elseif rank == 3 then
        medal = self.theme_:getImage("diploma/diploma_view_third.png")
    end

    if medal then
        local medalImg = jj.ui.JJImage.new({
            image = medal
            })
        medalImg:setAnchorPoint(CCPoint(1, 0))
        medalImg:setPosition(self:getWidth()-self.dimens_:getDimens(36), self.dimens_:getDimens(10))
        medalImg:setScale(self.dimens_.scale_)
        --medalImg:setPosition(20, self:getHeight() - 34)
        self:addView(medalImg)
    end
end

function Diploma:setDiplomaDesc(desc)
    if self.desciption and desc then
        self.desciption:setText(desc)
    end
end

--[[
奖品列表，首先调用setDiplomaDesc，这样可以确定列表位置
]]
function Diploma:setAwardGlod(awardItems)
    if awardItems and #awardItems > 0 then
        local x, y = self.desciption:getPositionX(), 
                     self.desciption:getPositionY()- self.desciption:getHeight() - self.dimens_:getDimens(25)

        local scrollGrp = jj.ui.JJScrollView.new({direction = jj.ui.JJScrollView.DIRECTION_VERTICAL,
                                                  viewSize = CCSize(self.dimens_:getDimens(650), 
                                                                    y - self.dimens_:getDimens(30))})
        --scrollGrp:setScale(self.dimens_.scale_)
        scrollGrp:setAnchorPoint(ccp(0, 1))
        scrollGrp:setPosition(x, y)
        self:addView(scrollGrp)

        local height = (#awardItems + 1)*self.dimens_:getDimens(30)
        local grp = jj.ui.JJViewGroup.new({viewSize=CCSize(self.dimens_:getDimens(650), height)})
        --grp:setScale(self.dimens_.scale_)

        x, y = self.dimens_:getDimens(10), height
        local awardMargin = self.dimens_:getDimens(20)
        local ware, lbl
        for i, item in ipairs(awardItems) do
            lbl = jj.ui.JJLabel.new({
                        fontSize = self.dimens_:getDimens(17),
                        align = ui.TEXT_ALIGN_LEFT,
                        color = ccc3(109, 47, 14),
                    })
            lbl:setAnchorPoint(CCPoint(0, 1))
            lbl:setPosition(x + awardMargin, y)
            grp:addView(lbl)

            ware = WareInfoManager:getWareItem(item.wareId)
            --if not ware then
            if ware and ware.reward > 0 then --可兑奖
                local desc = "★" .. item.amount .. "  " .. item.type
                lbl:setText(desc)
                lbl:setTouchEnable(true)
                lbl:setOnClickListener(function()
                    WebViewController:showActivity({title = "兑奖中心", back = true, sso = true,
                                                                        url = JJWebViewUrlDef.URL_EXCHANGE
                                                                         })
                    end)

                 local lbl2 = jj.ui.JJLabel.new({
                        fontSize = self.dimens_:getDimens(17),
                        align = ui.TEXT_ALIGN_LEFT,
                        color = ccc3(247, 14, 14),
                        text =  "（点击可直接兑奖）"
                    })
                lbl2:setAnchorPoint(CCPoint(0, 1))
                lbl2:setPosition(lbl:getPositionX() + lbl:getWidth(), y)
                grp:addView(lbl2)

                lbl2:setTouchEnable(true)
                lbl2:setOnClickListener(function()
                    WebViewController:showActivity({title = "兑奖中心", back = true, sso = true,
                                                                        url = JJWebViewUrlDef.URL_EXCHANGE
                                                                         })
                    end)

            else
                local desc = "★" .. item.amount .. "  " .. item.type
                lbl:setText(desc)
                --是否有说明
                if item.merit and string.len(item.merit) > 0 then
                    lbl:setId(item)
                    lbl:setTouchEnable(true)
                    lbl:setOnClickListener(handler(self, self.onClickAwardItem))
                end
            end

            y = y - self.dimens_:getDimens(25)
        end
        self.firstAward = "★" .. awardItems[1].amount .. awardItems[1].type
        scrollGrp:setContentView(grp)
    end
end

function Diploma:getFirstAward()
    return self.firstAward or ""
end

function Diploma:onClickAwardItem(target)
    local item = target and target:getId()
    if item then
        self.awardDlg = require("game.ui.view.AlertDialog").new({
            title = item.type,
            prompt = item.merit,
            onDismissListener = function() self.awardDlg = nil end,
            dimens = self.dimens_,
            theme = self.theme_
        })

        self.awardDlg:setButton1("确定")
        self.awardDlg:show(self.viewController_.scene_)
    end
end

function Diploma:snapImage()
    JJLog.i("linxh", "Diploma:snapImage")

    --local file =  device.writablePath .. "data/dp.png" --path .. "/dp.png"
    if self.viewController_.dpShareFile_ == nil then --只截取一次
        local dt = math.modf(JJTimeUtil:getCurrentSecond())
        self.viewController_.dpShareFile_ = Util:getDcimPath() .. "/jjdp_" .. dt .. ".jpg"
        local w = self.dimens_:getXDimens(650)
        local h = self.dimens_:getYDimens(384)
        local texture = CCRenderTexture:create(w, h, kCCTexture2DPixelFormat_RGBA8888)
        local x, y = self:getPosition()
        local ap = self:getAnchorPoint()
        if texture then
            self:setAnchorPoint(ccp(0.5,0.5))
            self:setPosition(self.dimens_:getXDimens(325), self.dimens_:getYDimens(192))
            
            --微信分享透明色会转换为黑底，修改为填充为白色的底款
            --texture:begin()
            texture:beginWithClear(255,255,255,255)
            self.node_:visit()
            texture:endToLua()
            texture:saveToFile(self.viewController_.dpShareFile_)
            self:setAnchorPoint(ap)
            self:setPosition(x, y)
        end
        Util:updateDcimFile(self.viewController_.dpShareFile_)
    end
    return self.viewController_.dpShareFile_
end

return Diploma
