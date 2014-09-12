--[[
      岛屿赛 加血界面
]]

local AddHpView = class("AddHpView",require("sdk.ui.JJViewGroup"))

AddHpView.TAG_ADD_HP_1 = 1
AddHpView.TAG_ADD_HP_2 = 2
AddHpView.TAG_ADD_HP_3 = 3
AddHpView.TAG_ADD_HP_4 = 4

function AddHpView:ctor(params)
    AddHpView.super.ctor(self)
    self.dimens_ = params.dimens
    self.theme_ = params.theme
    self.width_ = params.width
    self.height_ = params.height
    self.life_ = params.life
    self.bottleList_ = params.bottleList
    self:setViewSize(self.width_,self.height_)

    self:initView()
end

function AddHpView:initView()
    --背景
    self.bg_ = jj.ui.JJImage.new({        
        image = self.theme_:getImage("game/islandwait/island_wait_content_bg.png"),
        scale9 = true,
        viewSize = CCSize(self.width_, self.height_)
    })
    self.bg_:setAnchorPoint(ccp(0.5, 0.5))
    self.bg_:setPosition(self.width_/2, self.height_/2)
    self.bg_:setTouchEnable(true)
    self.bg_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.bg_)

    self.line = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_view_list_div_h.png"),
        scale9 = true,
        viewSize = CCSize(self.width_, 2),
    })
    self.line:setAnchorPoint(CCPoint(0, 0.5))
    self.line:setPosition(0, self.height_-self.dimens_:getDimens(60))
    self:addView(self.line)

    --当前生命
    local label = jj.ui.JJLabel.new({
      text = "生命值：",
      fontSize = self.dimens_:getDimens(20),
      align = ui.TEXT_ALIGN_LEFT,
      valign = ui.TEXT_VALIGN_CENTER,
      color = ccc3(255, 255, 255),
      viewSize = CCSize(self.dimens_:getDimens(100), self.dimens_:getDimens(30)),
    })
    label:setAnchorPoint(CCPoint(0, 1))
    label:setPosition(self.dimens_:getDimens(50), self.height_-self.dimens_:getDimens(20))
    self:addView(label) 

    self.lblLife = jj.ui.JJLabel.new({
      text = self.life_,
      fontSize = self.dimens_:getDimens(20),
      align = ui.TEXT_ALIGN_LEFT,
      valign = ui.TEXT_VALIGN_CENTER,
      color = ccc3(255, 217, 0),
      viewSize = CCSize(self.dimens_:getDimens(110), self.dimens_:getDimens(30)),
    })
    self.lblLife:setAnchorPoint(CCPoint(0, 1))
    self.lblLife:setPosition(self.dimens_:getDimens(130), self.height_-self.dimens_:getDimens(20))
    self:addView(self.lblLife) 

    --当前金币
    local money = jj.ui.JJLabel.new({
      text = "金币：",
      fontSize = self.dimens_:getDimens(20),
      align = ui.TEXT_ALIGN_LEFT,
      valign = ui.TEXT_VALIGN_CENTER,
      color = ccc3(255, 255, 255),
      viewSize = CCSize(self.dimens_:getDimens(100), self.dimens_:getDimens(30)),
    })
    money:setAnchorPoint(CCPoint(0, 1))
    money:setPosition(self.dimens_:getDimens(390), self.height_-self.dimens_:getDimens(20))
    self:addView(money) 

    self.lbmoney = jj.ui.JJLabel.new({
      text = tostring(UserInfo.gold_),
      fontSize = self.dimens_:getDimens(20),
      align = ui.TEXT_ALIGN_LEFT,
      valign = ui.TEXT_VALIGN_CENTER,
      color = ccc3(255, 217, 0),
      viewSize = CCSize(self.dimens_:getDimens(110), self.dimens_:getDimens(30)),
    })
    self.lbmoney:setAnchorPoint(CCPoint(0, 1))
    self.lbmoney:setPosition(self.dimens_:getDimens(448), self.height_-self.dimens_:getDimens(20))
    self:addView(self.lbmoney) 

    local count = (self.bottleList_ and #self.bottleList_) or 0
    if count > 4 then count = 4 end

    local startX, marginX, startY = self.dimens_:getDimens(20), self.dimens_:getDimens(150),self.height_-self.dimens_:getDimens(70)
    if count == 1 then 
        startX, marginX = self.dimens_:getDimens(245), self.dimens_:getDimens(215)
    elseif count == 2 then 
        startX, marginX = self.dimens_:getDimens(150), self.dimens_:getDimens(190)
    elseif count == 3 then 
        startX, marginX = self.dimens_:getDimens(100), self.dimens_:getDimens(150)
    end

    --加血1
    if count > 0 then 
      self.btnAdd_1 = jj.ui.JJButton.new({
        images = {
          normal = self.theme_:getImage("game/islandwait/addhp_bottle_1_n.png"),
          highlight = self.theme_:getImage("game/islandwait/addhp_bottle_1_d.png"),
        },
      })
      self.btnAdd_1:setId(AddHpView.TAG_ADD_HP_1)
      self.btnAdd_1:setScale(self.dimens_.scale_)
      self.btnAdd_1:setAnchorPoint(ccp(0, 1))
      self.btnAdd_1:setPosition(startX, startY)
      self.btnAdd_1:setOnClickListener(handler(self, self.onClick))    
      self:addView(self.btnAdd_1) 
    end

    --加血2
    if count > 1 then 
      self.btnAdd_2 = jj.ui.JJButton.new({
        images = {
          normal = self.theme_:getImage("game/islandwait/addhp_bottle_2_n.png"),
          highlight = self.theme_:getImage("game/islandwait/addhp_bottle_2_d.png"),
        },
      })
      self.btnAdd_2:setId(AddHpView.TAG_ADD_HP_2)
      self.btnAdd_2:setScale(self.dimens_.scale_)
      self.btnAdd_2:setAnchorPoint(ccp(0, 1))
      self.btnAdd_2:setPosition(startX+marginX, startY)
      self.btnAdd_2:setOnClickListener(handler(self, self.onClick))    
      self:addView(self.btnAdd_2) 
    end

    --加血3
    if count > 2 then 
      self.btnAdd_3 = jj.ui.JJButton.new({
        images = {
          normal = self.theme_:getImage("game/islandwait/addhp_bottle_3_n.png"),
          highlight = self.theme_:getImage("game/islandwait/addhp_bottle_3_d.png"),
        },
      })
      self.btnAdd_3:setId(AddHpView.TAG_ADD_HP_3)
      self.btnAdd_3:setScale(self.dimens_.scale_)
      self.btnAdd_3:setAnchorPoint(ccp(0, 1))
      self.btnAdd_3:setPosition(startX+marginX*2, startY)
      self.btnAdd_3:setOnClickListener(handler(self, self.onClick))    
      self:addView(self.btnAdd_3) 
    end

    --加血4
    if count > 3 then 
      self.btnAdd_4 = jj.ui.JJButton.new({
        images = {
          normal = self.theme_:getImage("game/islandwait/addhp_bottle_4_n.png"),
          highlight = self.theme_:getImage("game/islandwait/addhp_bottle_4_d.png"),
        },
      })
      self.btnAdd_4:setId(AddHpView.TAG_ADD_HP_4)
      self.btnAdd_4:setScale(self.dimens_.scale_)
      self.btnAdd_4:setAnchorPoint(ccp(0, 1))
      self.btnAdd_4:setPosition(startX+marginX*3, startY)
      self.btnAdd_4:setOnClickListener(handler(self, self.onClick))    
      self:addView(self.btnAdd_4) 
    end

    self.btnClose = jj.ui.JJButton.new({
      images = {
        normal = self.theme_:getImage("common/common_dialog_close_btn_n.png"),
        highlight = self.theme_:getImage("common/common_dialog_close_btn_d.png"),
      },
    })
    self.btnClose:setScale(self.dimens_.scale_ * 0.8)
    self.btnClose:setAnchorPoint(ccp(0, 1))
    self.btnClose:setPosition(self.width_ - self.dimens_:getDimens(40),self.height_ + self.dimens_:getDimens(20))
    self.btnClose:setOnClickListener(handler(self, self.onClick))    
    self:addView(self.btnClose) 

    local offset = startX+self.dimens_:getDimens(20)
    for i=1, count do
      local hpLife = jj.ui.JJLabel.new({
        text = self.bottleList_[i][1] .. "生命",
        fontSize = self.dimens_:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_CENTER,
        color = ccc3(255, 217, 0),
        viewSize = CCSize(self.dimens_:getDimens(140), self.dimens_:getDimens(30)),
      })
      hpLife:setAnchorPoint(CCPoint(0, 1))
      hpLife:setPosition(offset+(i-1)*marginX, self.height_-self.dimens_:getDimens(210))
      self:addView(hpLife) 

      local price = jj.ui.JJLabel.new({
        text = "售价:"..self.bottleList_[i][2].."金币",
        fontSize = self.dimens_:getDimens(15),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_CENTER,
        color = ccc3(150, 234, 253),
        viewSize = CCSize(self.dimens_:getDimens(140), self.dimens_:getDimens(20)),
      })
      price:setAnchorPoint(CCPoint(0, 1))
      price:setPosition(offset+(i-1)*marginX, self.height_-self.dimens_:getDimens(240))
      self:addView(price) 
    end
end

function AddHpView:setLife(life_)
	self.lblLife:setText(life_)
end

function AddHpView:refreshMoney(money)  
  money = money or UserInfo.gold_
  --JJLog.i("linxh", "AddHpView:refreshMoney = " .. money)
  self.lbmoney:setText(money)
end

function AddHpView:onClick(target)

  if target == self.btnClose then 
       self.parent_:showAllUiInfo(true)
       self:removeSelf(true)
  else
     self.parent_:addHpViewOnClick(target)
  end
  
end

return AddHpView
