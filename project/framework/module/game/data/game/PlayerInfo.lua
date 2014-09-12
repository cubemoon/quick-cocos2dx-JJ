local PlayerInfo = class("PlayerInfo")

function PlayerInfo:ctor()
	self.seat_ = -1  --座位编号
	self.userId_ = 0  --用户帐号对应的唯一数字编号ID
	self.nickName_ = "" --用户昵称
	self.figureId_ = nil  --用户头像ID,默认值不能为0，因为服务器有0的id
	self.matchExcp_ = 0 --经验值
	self.score_ = 0     --赛中积分
	self.arrived_ = false --是否客户端已经连接到服务器
	self.netStatus_ = 0   --网络状态：0正常连接，1断线
	self.trust_ = false   --是否托管
	self.rank_ = -1       --职业排行榜名次
	self.rankScore_ = 0    --职业排行榜积分
	self.totalHand_ = -1   --玩家玩过的总局数
	self.winHand_ = 0      --玩家玩赢得的总局数
    self.headImgSrc = "img/figure/jj_figure_default.png"
end

function PlayerInfo:getHeadImg()
    local userid = self.userId_
    local figureid = self.figureId_

    if (userid and userid ~= 0 and figureid) then--增加处理，如果没有获取和设置figureId_，则取默认的头像
        local head = HeadImgManager:getImg(userid, figureid)
        JJLog.i("PlayerInfo getHeadImg", figureid, userid, head)
        if (head) then
            self.headImgSrc = head
        end
    end

    return self.headImgSrc
end

return PlayerInfo