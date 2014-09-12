
Õ
TKConfig.protocn.jj.service.msg.protocol"™
ConfigReqMsgM
configgetmc_req_msg (20.cn.jj.service.msg.protocol.ConfigGetMatchCfgReqK
configgetnote_req_msg (2,.cn.jj.service.msg.protocol.ConfigGetNoteReq"™
ConfigAckMsgM
configgetmc_ack_msg (20.cn.jj.service.msg.protocol.ConfigGetMatchCfgAckK
configgetnote_ack_msg (2,.cn.jj.service.msg.protocol.ConfigGetNoteAck"r
ConfigGetMatchCfgReq
	timestamp (
gameid (
	productid (

promoterid (
pagingid ("4
ConfigGetMatchCfgAck
ret (
content (	"i
ConfigGetNoteReq
userid (
	timestamp (
gameid (
typeid (

promoterid ("0
ConfigGetNoteAck
ret (
content (	
„
TKDouniu.protocn.jj.service.msg.protocol"‹
DouniuReqMsg
matchid (
time (
seat (a
 ChangeBankerAnteComplete_req_msg (27.cn.jj.service.msg.protocol.ChangeBankerAnteCompleteReq=
ChipIn_req_msg (2%.cn.jj.service.msg.protocol.ChipInReq_
ChipInAnimationComplete_req_msg (26.cn.jj.service.msg.protocol.ChipInAnimationCompleteReqM
FreePlayerShow_req_msg (2-.cn.jj.service.msg.protocol.FreePlayerShowReqc
!FreePlayerShowAniComplete_req_msg (28.cn.jj.service.msg.protocol.FreePlayerShowAniCompleteReqG
LeaveBanker_req_msg	 (2*.cn.jj.service.msg.protocol.LeaveBankerReqK
NeverBeBanker_req_msg
 (2,.cn.jj.service.msg.protocol.NeverBeBankerReqR
UpdJackpotlist_req_msg (22.cn.jj.service.msg.protocol.DNUpdateJackpotListReq"0
ChangeBankerAnteCompleteReq
	nullvalue ("
	ChipInReq
chips ("/
ChipInAnimationCompleteReq
	nullvalue (",
Card
	cardclass (
	cardpoint ("8
Cards/
cards (2 .cn.jj.service.msg.protocol.Card"J
FreePlayerShowReq5

ordercards (2!.cn.jj.service.msg.protocol.Cards"1
FreePlayerShowAniCompleteReq
	nullvalue ("
LeaveBankerReq
setup ("!
NeverBeBankerReq
leave ("+
DNUpdateJackpotListReq
	nullvalue ("Ü
DouniuAckMsg
matchid (
time (
seat (G
DNStartGame_ack_msg (2*.cn.jj.service.msg.protocol.DNStartGameAckI
OnlineState_ack_msg (2,.cn.jj.service.msg.protocol.DNOnlineStateAckQ
ChangeBankerAnte_ack_msg (2/.cn.jj.service.msg.protocol.ChangeBankerAnteAckG
StartChipIn_ack_msg (2*.cn.jj.service.msg.protocol.StartChipInAck=
ChipIn_ack_msg (2%.cn.jj.service.msg.protocol.ChipInAckC
DealCards_ack_msg	 (2(.cn.jj.service.msg.protocol.DealCardsAckK
ALLPlayerShow_ack_msg
 (2,.cn.jj.service.msg.protocol.ALLPlayerShowAckA
GameOver_ack_msg (2'.cn.jj.service.msg.protocol.GameOverAckK
NeverBeBanker_ack_msg (2,.cn.jj.service.msg.protocol.NeverBeBankerAck=
Sorted_ack_msg (2%.cn.jj.service.msg.protocol.SortedAckM
FreePlayerShow_ack_msg (2-.cn.jj.service.msg.protocol.FreePlayerShowAckS
UpdateJackpotnum_ack_msg (21.cn.jj.service.msg.protocol.DNUpdateJackpotNumAckU
UpdageJackpotList_ack_msg (22.cn.jj.service.msg.protocol.DNUpdateJackpotListAck"&
	PlayerNum
seat (
num ("q
DNStartGameAck

gameconfig (	8
	handchips (2%.cn.jj.service.msg.protocol.PlayerNum
	basescore (""
DNOnlineStateAck
online ("ô
ChangeBankerAnteAck

bankerseat (9

payJackpot (2%.cn.jj.service.msg.protocol.PlayerNum>
payTableJackpot (2%.cn.jj.service.msg.protocol.PlayerNum9

payAnteTax (2%.cn.jj.service.msg.protocol.PlayerNum8
	handChips (2%.cn.jj.service.msg.protocol.PlayerNum"J
StartChipInAck8
	maxChipIn (2%.cn.jj.service.msg.protocol.PlayerNum"
	ChipInAck
chips ("P
	SeatCards
seat (5

ordercards (2!.cn.jj.service.msg.protocol.Cards"J
DealCardsAck:
playercards (2%.cn.jj.service.msg.protocol.SeatCards"^
JackpotWinRecord
userName (	
taketime (

takebytype (

takeAmount ("˝
ALLPlayerShowAck:
playercards (2%.cn.jj.service.msg.protocol.SeatCards8
	PlayerWin (2%.cn.jj.service.msg.protocol.PlayerNum;
tablejackWin (2%.cn.jj.service.msg.protocol.PlayerNum6
jackWin (2%.cn.jj.service.msg.protocol.PlayerNum" 
GameOverAck
	nullvalue ("!
NeverBeBankerAck
leave ("
	SortedAck

sortedseat ("J
FreePlayerShowAck5

ordercards (2!.cn.jj.service.msg.protocol.Cards"(
DNUpdateJackpotNumAck
jackpot ("Y
DNUpdateJackpotListAck?
	winRecord (2,.cn.jj.service.msg.protocol.JackpotWinRecord
´"
TKECAService.protocn.jj.service.msg.protocol"á
ECAServiceReqMsgE
ecacompose_req_msg (2).cn.jj.service.msg.protocol.ECAComposeReqA
ssologin_req_msg (2'.cn.jj.service.msg.protocol.SSOLoginReqG
getfsmstate_req_msg (2*.cn.jj.service.msg.protocol.GetFSMStateReqE
getfsmsign_req_msg (2).cn.jj.service.msg.protocol.GetFSMSignReqG
getobjstate_req_msg (2*.cn.jj.service.msg.protocol.GetObjStateReqE
rulefinish_req_msg (2).cn.jj.service.msg.protocol.RuleFinishReqI
pushprogress_ack_msg (2+.cn.jj.service.msg.protocol.PushProgressAck"á
ECAServiceAckMsgE
ecacompose_ack_msg (2).cn.jj.service.msg.protocol.ECAComposeAckA
ssologin_ack_msg (2'.cn.jj.service.msg.protocol.SSOLoginAckG
getfsmstate_ack_msg (2*.cn.jj.service.msg.protocol.GetFSMStateAckE
getfsmsign_ack_msg (2).cn.jj.service.msg.protocol.GetFSMSignAckG
getobjstate_ack_msg (2*.cn.jj.service.msg.protocol.GetObjStateAckE
rulefinish_ack_msg (2).cn.jj.service.msg.protocol.RuleFinishAckI
pushprogress_req_msg (2+.cn.jj.service.msg.protocol.PushProgressReq"C
ECAComposeReq
userid (
schemeid (
multiple ("3
ECAComposeAck
retvalue (
resultid ("8
SSOLoginReq
userid (
time (
mac (	"
SSOLoginAck
param ("C
GetFSMStateReq
userid (
fsmclass (
fsmarea ("Ê
FSMProgressState
pid (
fsmonlysign (	
fsmid (
fsmcurstateid (
fsmexetimes (
fsmtotalexetimes (
fsmnextlevelfinishcount (
btime (
etime	 (
mtime
 (
ctime ("÷
FSMProgressComplete
pid (
fsmonlysign (	
fsmid (
fsmcompstate (
fsmexetimes (
fsmtotalexetimes (
fsmnextlevelfinishcount (
completetime (

deletetime	 ("±
GetFSMStateAck
fsmarea (C
progressstate (2,.cn.jj.service.msg.protocol.FSMProgressStateI
progresscomplete (2/.cn.jj.service.msg.protocol.FSMProgressComplete"B
GetFSMSignReq
userid (
fsmclass (
fsmarea ("?
FSMProgressSign
pid (
fsmid (
signtime ("c
GetFSMSignAck
fsmarea (A
progresssign (2+.cn.jj.service.msg.protocol.FSMProgressSign"ô
RelProgress

id (
pid (
fsmonlysign (	
fsmid (
pobjonlysign (	
pobjid (
objonlysign (	
fsmcurobjid (
curobjjumpxfg	 (
curobjjumpyfg
 (
curobjdelfg (
btime (
etime (
mtime (
ctime ("Ê
RelComplete
pid (
pathid (
beffsmonlysign (	
beffsmid (
befpobjonlysign (	
	befpobjid (
befobjonlysign (	
befobjid (
aftobjid	 (
completetime
 (

deletetime ("∞
ObjProgressState
pid (
fsmonlysign (	
fsmid (
pobjonlysign (	
pobjid (
objonlysign (	
objid (
objcurstateid (
objexetimes	 (
objtotalexetimes
 (
objnextlevelfinishcount (
btime (
etime (
mtime (
ctime ("†
ObjProgressComplete
pid (
fsmonlysign (	
fsmid (
pobjonlysign (	
pobjid (
objonlysign (	
objid (
objcompstate (
objexetimes	 (
objtotalexetimes
 (
objnextlevelfinishcount (
completetime (

deletetime ("/
GetObjStateReq
userid (
fsmid ("±
GetObjStateAck
fsmid (<
relprogress (2'.cn.jj.service.msg.protocol.RelProgress<
relcomplete (2'.cn.jj.service.msg.protocol.RelCompleteF
objprogressstate (2,.cn.jj.service.msg.protocol.ObjProgressStateL
objprogresscomplete (2/.cn.jj.service.msg.protocol.ObjProgressComplete"’
RuleFinishReq
userid (
jumpmode (
fsmonlysign (	
fsmid (
pobjonlysign (	
pobjid (
objonlysign (	
objid (

jumppathid	 (
	ishaveeca
 (
ecaid ("
RuleFinishAck
param ("¢
PushProgressReq
fsmid (D
fsmprogresssign (2+.cn.jj.service.msg.protocol.FSMProgressSignB
fsmstateitem (2,.cn.jj.service.msg.protocol.FSMProgressStateD
fsmcomplete (2/.cn.jj.service.msg.protocol.FSMProgressComplete
relcount (
relcomcount (
objprocount (
objcomcount (
relprogress	 (	
relcomplete
 (	
objprogressstate (	
objprogresscomplete (	"
PushProgressAck
´
TKHbase.protocn.jj.service.msg.protocol"V
HbaseReqMsgG
hbasecommon_req_msg (2*.cn.jj.service.msg.protocol.HbaseCommonReq"V
HbaseAckMsgG
hbasecommon_ack_msg (2*.cn.jj.service.msg.protocol.HbaseCommonAck"&
HbaseCommonReq
commonreqmsg (	"&
HbaseCommonAck
commonackmsg (	
∂*
TKHLLord.protocn.jj.service.msg.protocol"Â
HLLordReqMsg
matchid (
time (Q
dispatchcomplete_req_msg (2/.cn.jj.service.msg.protocol.DispatchCompleteReqC
showcards_req_msg (2(.cn.jj.service.msg.protocol.ShowCardsReqA
calllord_req_msg (2'.cn.jj.service.msg.protocol.CallLordReq?
roblord_req_msg (2&.cn.jj.service.msg.protocol.RobLordReqW
declarelordcomplete_req_msg (22.cn.jj.service.msg.protocol.DeclareLordCompleteReq=
double_req_msg (2%.cn.jj.service.msg.protocol.DoubleReqA
putcards_req_msg	 (2'.cn.jj.service.msg.protocol.PutCardsReq?
trustin_req_msg
 (2&.cn.jj.service.msg.protocol.TrustInReq"›
HLLordAckMsg
matchid (
time (C
startgame_ack_msg (2(.cn.jj.service.msg.protocol.StartGameAck;
honor_ack_msg (2$.cn.jj.service.msg.protocol.HonorAckC
basemulti_ack_msg (2(.cn.jj.service.msg.protocol.BaseMultiAckO
updatethinktime_ack_msg (2..cn.jj.service.msg.protocol.UpdateThinkTimeAckJ
dispatchcard_ack_msg (2,.cn.jj.service.msg.protocol.DispatchCardsAck[
dispatchstagefinished_ack_msg (24.cn.jj.service.msg.protocol.DispatchStageFinishedAckC
showcards_ack_msg	 (2(.cn.jj.service.msg.protocol.ShowCardsAckC
handcards_ack_msg
 (2(.cn.jj.service.msg.protocol.HandCardsAckK
startcalllord_ack_msg (2,.cn.jj.service.msg.protocol.StartCallLordAckA
calllord_ack_msg (2'.cn.jj.service.msg.protocol.CallLordAckG
waitroblord_ack_msg (2*.cn.jj.service.msg.protocol.WaitRobLordAck?
roblord_ack_msg (2&.cn.jj.service.msg.protocol.RobLordAckG
declarelord_ack_msg (2*.cn.jj.service.msg.protocol.DeclareLordAckQ
waitlordshowcard_ack_msg (2/.cn.jj.service.msg.protocol.WaitLordShowCardAckG
startdouble_ack_msg (2*.cn.jj.service.msg.protocol.StartDoubleAck=
double_ack_msg (2%.cn.jj.service.msg.protocol.DoubleAckC
startplay_ack_msg (2(.cn.jj.service.msg.protocol.StartPlayAckA
putcards_ack_msg (2'.cn.jj.service.msg.protocol.PutCardsAckE
finishgame_ack_msg (2).cn.jj.service.msg.protocol.FinishGameAckC
maxdouble_ack_msg (2(.cn.jj.service.msg.protocol.MaxDoubleAck?
trustin_ack_msg (2&.cn.jj.service.msg.protocol.TrustInAckG
onlinestate_ack_msg (2*.cn.jj.service.msg.protocol.OnlineStateAck;
abort_ack_msg (2$.cn.jj.service.msg.protocol.AbortAckG
updatemulti_ack_msg (2*.cn.jj.service.msg.protocol.UpdateMultiAckC
quitonown_ack_msg (2(.cn.jj.service.msg.protocol.QuitOnOwnAckE
lordhltask_ack_msg (2).cn.jj.service.msg.protocol.LordHLTaskAckU
lordhltaskfinished_ack_msg (21.cn.jj.service.msg.protocol.LordHLTaskFinishedAckO
lordhltimelimit_ack_msg (2..cn.jj.service.msg.protocol.LordHLTimeLimitAckM
eachplayerinfo_ack_msg (2-.cn.jj.service.msg.protocol.EachPlayerInfoAck"(
DispatchCompleteReq
	nullvalue ("
ShowCardsReq
show ("
CallLordReq
call ("

RobLordReq
rob ("+
DeclareLordCompleteReq
	nullvalue ("
	DoubleReq
double (".
HLCard
	cardclass (
	cardpoint (">
UnitInfo
unittype (
	cardcount (
point ("Ñ
PutCardsReq
seat (3
hlcards (2".cn.jj.service.msg.protocol.HLCard2
unit (2$.cn.jj.service.msg.protocol.UnitInfo"

TrustInReq
trustin (""
StartGameAck

gameconfig (	"*
LordHLScore
seat (
score (",
LordHLMaster
seat (
master ("à
HonorAck<
lordhlscore (2'.cn.jj.service.msg.protocol.LordHLScore>
lordhlmaster (2(.cn.jj.service.msg.protocol.LordHLMaster"!
BaseMultiAck
	basemulti (",
	ThinkTime
seat (
	timevalue ("N
UpdateThinkTimeAck8
	thinktime (2%.cn.jj.service.msg.protocol.ThinkTime"m
DispatchCardsAck3
hlcards (2".cn.jj.service.msg.protocol.HLCard
multi (
allowshowcard ("-
DispatchStageFinishedAck
	nullvalue ("9
ShowCardsAck
seat (
show (
multi ("Q
HandCardsAck
seat (3
hlcards (2".cn.jj.service.msg.protocol.HLCard"%
StartCallLordAck
	beginseat (")
CallLordAck
seat (
call ("
WaitRobLordAck
seat ("'

RobLordAck
seat (
rob ("U
DeclareLordAck
seat (5
	fundcards (2".cn.jj.service.msg.protocol.HLCard"(
WaitLordShowCardAck
	nullvalue ("#
StartDoubleAck
	nullvalue (")
	DoubleAck
seat (
double ("!
StartPlayAck
	nullvalue ("Ñ
PutCardsAck
seat (3
hlcards (2".cn.jj.service.msg.protocol.HLCard2
unit (2$.cn.jj.service.msg.protocol.UnitInfo"ü

PlayerInfo
double (
score (7
remiancards (2".cn.jj.service.msg.protocol.HLCard9
dispatchcards (2".cn.jj.service.msg.protocol.HLCard"»
FinishGameAck
winseat (
showcardsmulti (
roblordmulti (
	bombmulti (
springmulti (
fundcardsmulti (8
playinfo (2&.cn.jj.service.msg.protocol.PlayerInfo"!
MaxDoubleAck
	nullvalue ("+

TrustInAck
seat (
trustin (".
OnlineStateAck
seat (
online ("
AbortAck
	nullvalue ("
UpdateMultiAck
multi ("_
QuitOnOwnAck
exittime (	
curtime (	
seat (	
playerid (	
nick (	"$
LordHLTaskAck
taskcontent (	"E
LordHLTaskFinishedAck
seat (
taskid (
bounus ("@
LordHLTimeLimitAck
	timelimit (
minputcardstime ("7
EachPlayerInfoAck
figureid (
nickname (	
ß2
TKHttp.protocn.jj.service.msg.protocol"˝

HttpReqMsgK
paoxiaosubmit_req_msg (2,.cn.jj.service.msg.protocol.PaoxiaoSubmitReqE
paoxiaoget_req_msg (2).cn.jj.service.msg.protocol.PaoxiaoGetReqM
paoxiaosupport_req_msg (2-.cn.jj.service.msg.protocol.PaoxiaoSupportReqA
wareinfo_req_msg (2'.cn.jj.service.msg.protocol.WareinfoReqG
composeinfo_req_msg (2*.cn.jj.service.msg.protocol.ComposeInfoReqU
paoxiaogetuserinfo_req_msg (21.cn.jj.service.msg.protocol.PaoxiaoGetUserInfoReqM
deviceinfopush_req_msg (2-.cn.jj.service.msg.protocol.DeviceInfoPushReqQ
userlocationpush_req_msg	 (2/.cn.jj.service.msg.protocol.UserLocationPushReqO
userlocationget_req_msg
 (2..cn.jj.service.msg.protocol.UserLocationGetReqE
getsmscode_req_msg (2).cn.jj.service.msg.protocol.GetSMSCodeReqU
convertawardsubmit_req_msg (21.cn.jj.service.msg.protocol.ConvertAwardSubmitReqW
getaccountstatement_req_msg (22.cn.jj.service.msg.protocol.GetAccountStatementReqE
commonhttp_req_msg (2).cn.jj.service.msg.protocol.CommonHttpReq_
wareexchangegoldinquiry_req_msg (26.cn.jj.service.msg.protocol.WareExchangeGoldInquiryReq]
wareexchangegoldaction_req_msg (25.cn.jj.service.msg.protocol.WareExchangeGoldActionReqU
getexchangeaccount_req_msg (21.cn.jj.service.msg.protocol.GetExchangeAccountReqW
inquirycandrawmoney_req_msg (22.cn.jj.service.msg.protocol.InquiryCanDrawMoneyReqC
drawmoney_req_msg (2(.cn.jj.service.msg.protocol.DrawMoneyReqC
commonweb_req_msg (2(.cn.jj.service.msg.protocol.CommonWebReq"§

HttpAckMsgE
paoxiao_ack_msg (2,.cn.jj.service.msg.protocol.PaoxiaoCommonAckE
paoxiaoget_ack_msg (2).cn.jj.service.msg.protocol.PaoxiaoGetAckA
wareinfo_ack_msg (2'.cn.jj.service.msg.protocol.WareinfoAckG
composeinfo_ack_msg (2*.cn.jj.service.msg.protocol.ComposeInfoAckU
paoxiaogetuserinfo_ack_msg (21.cn.jj.service.msg.protocol.PaoxiaoGetUserInfoAckI
deviceinfo_ack_msg (2-.cn.jj.service.msg.protocol.DeviceInfoPushAckQ
userlocationpush_ack_msg (2/.cn.jj.service.msg.protocol.UserLocationPushAckO
userlocationget_ack_msg	 (2..cn.jj.service.msg.protocol.UserLocationGetAckE
getsmscode_ack_msg
 (2).cn.jj.service.msg.protocol.GetSMSCodeAckU
convertawardsubmit_ack_msg (21.cn.jj.service.msg.protocol.ConvertAwardSubmitAckW
getaccountstatement_ack_msg (22.cn.jj.service.msg.protocol.GetAccountStatementAckE
commonhttp_ack_msg (2).cn.jj.service.msg.protocol.CommonHttpAck_
wareexchangegoldinquiry_ack_msg (26.cn.jj.service.msg.protocol.WareExchangeGoldInquiryAck]
wareexchangegoldaction_ack_msg (25.cn.jj.service.msg.protocol.WareExchangeGoldActionAckU
getexchangeaccount_ack_msg (21.cn.jj.service.msg.protocol.GetExchangeAccountAckW
inquirycandrawmoney_ack_msg (22.cn.jj.service.msg.protocol.InquiryCanDrawMoneyAckC
drawmoney_ack_msg (2(.cn.jj.service.msg.protocol.DrawMoneyAckC
commonweb_ack_msg (2(.cn.jj.service.msg.protocol.CommonWebAck"â
PaoxiaoSubmitReq
userid (
nickname (	
content (	
parentpostid (
type (
rank (
location (	"/
PaoxiaoCommonAck
ret (
xmlmsg (	"Ö

PaoxiaoMsg
postid (
userid (
nickname (	
content (	
agree (
disagree (
ctime (
mtime (
point	 (
flag
 (
parentpostid (

replycount (
floor (
stime (
location (	"‘
PaoxiaoGetReq
userid (
typeid (
pageid (
destuid (
minid (
maxid (
optid (
count (
nickname	 (	
postid
 (
repposterid (
topicid ("§
PaoxiaoSupportReq
userid (
postid (
agree (
posterid (
poster (	
ctime (
content (	
type (
location	 (	"”
PaoxiaoGetAck
ret (
userid (
typeid (
pageid (
	pagecount (4
msgs (2&.cn.jj.service.msg.protocol.PaoxiaoMsg
xmlmsg (	
postid (
minid	 (
maxid
 ("Z
WareinfoReq

updatetime (
wareid (
waretype (
receivedmaxid ("’
Wareinfo
wareid (

updatetime (
warename (	
wareexplain (	
	wareintro (	
	meritinfo (	

cancompose (
status (
type	 (

rewardtype
 (

rewarddesc (	"
WareinfoAck
waretype (
wareid (7
	wareinfos (2$.cn.jj.service.msg.protocol.Wareinfo
receivedmaxid ("$
ComposeInfoReq

updatetime ("2
ComposeInfoAck
ret (
composeinfo (	"r
DeviceInfoPushReq
mac (	
gameid (
appver (	
token (	

devicename (	
osver (	" 
DeviceInfoPushAck
ret ("6
PaoxiaoGetUserInfoReq
userid (
srcid ("6
PaoxiaoGetUserInfoAck
ret (
userinfo (	"'
UserLocationPushReq
location (	""
UserLocationPushAck
ret ("$
UserLocationGetReq
userid (	"3
UserLocationGetAck
ret (
location (	"4
GetSMSCodeReq
userid (
phonenumber (	" 
GetSMSCodeAck
smscode (	"ò
ConvertAwardSubmitReq
convertawardtype (
userid (
convertawardcount (
wareid (
phonenumber (	
	firstcode (	

secondcode (	
orderid (	
receivername	 (	
receiveraddress
 (	
postcode (	
remarks (	
identitycardnumber (	
bankaccountname (	
bankcardnumber (	
bankofdeposit (	
qqnumber (	
renrenaccount (	"'
ConvertAwardSubmitAck
result (	"\
GetAccountStatementReq
userid (
accountdate (	
pageno (
count ("(
GetAccountStatementAck
result (	"q
CommonHttpReq
type (	
argv (	
gameid (
reqtype (
isZip (
isSupportZip ("?
CommonHttpAck
result (	
len (
	zipresult (",
WareExchangeGoldInquiryReq
wareid ("=
WareExchangeGoldActionReq
wareid (
quantity (",
WareExchangeGoldInquiryAck
result (	"+
WareExchangeGoldActionAck
result (	"F
GetExchangeAccountReq
userid (
pageno (
count ("'
GetExchangeAccountAck
result (	"(
InquiryCanDrawMoneyReq
userid ("(
InquiryCanDrawMoneyAck
result (	"
DrawMoneyReq
userid ("
DrawMoneyAck
result (	"+
CommonWebReq
type (
param (	",
CommonWebAck
type (
result (	
∂
TKInterim.protocn.jj.service.msg.protocol"ñ
InterimReqMsg
matchid (9
Coin_req_msg (2#.cn.jj.service.msg.protocol.CoinReq9
Gamb_req_msg (2#.cn.jj.service.msg.protocol.GambReq"ì
InterimAckMsg
matchid (A
InitCard_ack_msg (2'.cn.jj.service.msg.protocol.InitCardAck9
Coin_ack_msg (2#.cn.jj.service.msg.protocol.CoinAck9
Over_ack_msg (2#.cn.jj.service.msg.protocol.OverAckI
CurPrizePool_ack_msg (2+.cn.jj.service.msg.protocol.CurPrizePoolAck?
ConGamb_ack_msg (2&.cn.jj.service.msg.protocol.ConGambAck?
GambEnd_ack_msg (2&.cn.jj.service.msg.protocol.GambEndAckQ
CurPrizePoolNote_ack_msg (2/.cn.jj.service.msg.protocol.CurPrizePoolNoteAckG
ChangeScore_ack_msg	 (2*.cn.jj.service.msg.protocol.ChangeScoreAckO
DivideTableCoin_ack_msg
 (2..cn.jj.service.msg.protocol.DivideTableCoinAck"%
CoinReq
coin (
seat ("&
GambReq
click (
seat ("
InitCardAck
bankSeat (
	firstSeat (
	cardCount (
playerCount (
anBottomCoin (
anTax (

anNewBlind (
anBalanceTax (

nBaseScore	 (
	tableCoin
 (
enProba (
cards ("“
CoinAck
enResult (
coin (
coinWin (
seat (
nextSeat (
abyCard (
drawCard (

enProbaPre (

enProbaCur	 (
coinWinPrize
 (
wallCardCount ("	
OverAck"'
CurPrizePoolAck
curPrizePool ("

ConGambAck
seat (
card (
winCoin (
everyWin (
enResult (
	cardCount (
click ("í

GambEndAck
seat (
card (
winCoin (
everyWin (
enResult (
nextSeat (

enProbaCur (
click ("#
CurPrizePoolNoteAck
note (	"-
ChangeScoreAck
score (
seat ("#
DivideTableCoinAck
score (
ﬂ
TKLine.protocn.jj.service.msg.protocol"∑

LineReqMsg
matchid (
time (9
Roll_req_msg (2#.cn.jj.service.msg.protocol.RollReqA
QuitGame_req_msg (2'.cn.jj.service.msg.protocol.QuitGameReqC
LineAddHP_req_msg (2(.cn.jj.service.msg.protocol.LineAddHPReqG
Linenettest_req_msg (2*.cn.jj.service.msg.protocol.LinenettestReq"
RollReq
note (B" 
QuitGameReq
	nullvalue ("!
LineAddHPReq
	nullvalue ("!
LinenettestReq
nettest (	"†

LineAckMsg
matchid (
time (G
ServerReady_ack_msg (2*.cn.jj.service.msg.protocol.ServerReadyAckC
RollBegin_ack_msg (2(.cn.jj.service.msg.protocol.RollBeginAckE
RollResult_ack_msg (2).cn.jj.service.msg.protocol.RollResultAck?
Jackpot_ack_msg (2&.cn.jj.service.msg.protocol.JackpotAck?
Wininfo_ack_msg (2&.cn.jj.service.msg.protocol.WininfoAckA
Announce_ack_msg (2'.cn.jj.service.msg.protocol.AnnounceAck=
String_ack_msg	 (2%.cn.jj.service.msg.protocol.StringAckQ
Linebroadcastwin_ack_msg
 (2/.cn.jj.service.msg.protocol.LineBroadcastWinAckG
Linenettest_ack_msg (2*.cn.jj.service.msg.protocol.LinenettestAck"?
ServerReadyAck
config (	
clientVersionRequired (	" 
RollBeginAck
handChip ("#
SMatrixWidth
element (B"F
SMatrix;
	matrixWid (2(.cn.jj.service.msg.protocol.SMatrixWidth"˙
RollResultAck3
Matrix (2#.cn.jj.service.msg.protocol.SMatrix
LineWin (
SpecialLineWin (B
AllWin (
ParticularWin (
WinPot (
WinPotMoney (
WinMoney (
SpecialAccumulation1	 (
SpecialAccumulation2
 (
GameType (
AccumulatePot1 (
AccumulatePot2 (

WinAccPot1 (

WinAccPot2 (
WinAccumulatePotNum1 (
WinAccumulatePotNum2 (
bAllGame (
bALlFortune (
	userMoney (
multi ("

JackpotAck
pool ("`
	Winstruct
time (	
nickname (	

winalltype (	
winmoney (
notes ("G

WininfoAck9

WinInfoVec (2%.cn.jj.service.msg.protocol.Winstruct"
AnnounceAck
AnnVec (	",
	StringAck

StringType (
str (	"M
LineBroadcastWinAck6
WinInfo (2%.cn.jj.service.msg.protocol.Winstruct"!
LinenettestAck
nettest (	
—ê
TKLobby.protocn.jj.service.msg.protocol"°
LobbyReqMsg;
login_req_msg (2$.cn.jj.service.msg.protocol.LoginReq=
logout_req_msg (2%.cn.jj.service.msg.protocol.LogoutReqI
anonymous_req_msg (2..cn.jj.service.msg.protocol.AnonymousBrowseReqM
getuserallgrow_req_msg (2-.cn.jj.service.msg.protocol.GetUserAllGrowReqM
getuserallware_req_msg (2-.cn.jj.service.msg.protocol.GetUserAllWareReqM
getaccnummoney_req_msg (2-.cn.jj.service.msg.protocol.GetAccNumMoneyReqO
tourneysignupex_req_msg (2..cn.jj.service.msg.protocol.TourneySignupExReqO
tourneyunsignup_req_msg (2..cn.jj.service.msg.protocol.TourneyUnsignupReqG
getsysmsgex_req_msg	 (2*.cn.jj.service.msg.protocol.GetSysMsgExReqM
quickstartgame_req_msg
 (2-.cn.jj.service.msg.protocol.QuickStartGameReqe
"getuserinterfixtourneylist_req_msg (29.cn.jj.service.msg.protocol.GetUserInterfixTourneyListReqO
gettickettempex_req_msg (2..cn.jj.service.msg.protocol.GetTicketTempExReqM
modifynickname_req_msg (2-.cn.jj.service.msg.protocol.ModifyNickNameReqM
verifynickname_req_msg (2-.cn.jj.service.msg.protocol.VerifyNickNameReqO
verifyloginname_req_msg (2..cn.jj.service.msg.protocol.VerifyLoginNameReqK
getverifycode_req_msg (2,.cn.jj.service.msg.protocol.GetVerifyCodeReqA
register_req_msg (2'.cn.jj.service.msg.protocol.RegisterReqK
getsinglegrow_req_msg (2,.cn.jj.service.msg.protocol.GetSingleGrowReqS
urssendregsmscode_req_msg (20.cn.jj.service.msg.protocol.URSSendRegSMSCodeReqM
mobileregister_req_msg (2-.cn.jj.service.msg.protocol.MobileRegisterReqG
mobilelogin_req_msg (2*.cn.jj.service.msg.protocol.MobileLoginReqI
generallogin_req_msg (2+.cn.jj.service.msg.protocol.GeneralLoginReqE
noreglogin_req_msg (2).cn.jj.service.msg.protocol.NoRegLoginReqW
noregbinddefaultacc_req_msg  (22.cn.jj.service.msg.protocol.NoRegBindDefaultAccReqS
noregbindemailacc_req_msg! (20.cn.jj.service.msg.protocol.NoRegBindEmailAccReqU
noregbindmobileacc_req_msg" (21.cn.jj.service.msg.protocol.NoRegBindMobileAccReqO
unicomaccountup_req_msg# (2..cn.jj.service.msg.protocol.UnicomAccountUpReq=
loginex_req_msg$ (2$.cn.jj.service.msg.protocol.LoginReqK
generalloginex_req_msg% (2+.cn.jj.service.msg.protocol.GeneralLoginReqO
getsmsrandompwd_req_msg& (2..cn.jj.service.msg.protocol.GetSMSRandomPwdReqM
randompwdlogin_req_msg' (2-.cn.jj.service.msg.protocol.RandomPwdLoginReqM
getaccesstoken_req_msg( (2-.cn.jj.service.msg.protocol.GetAccessTokenReqQ
openpartnerlogin_req_msg) (2/.cn.jj.service.msg.protocol.OpenPartnerLoginReqE
tokenlogin_req_msg* (2).cn.jj.service.msg.protocol.TokenLoginReqI
modifyfigure_req_msg+ (2+.cn.jj.service.msg.protocol.ModifyFigureReqS
getuserdomaingrow_req_msg, (20.cn.jj.service.msg.protocol.GetUserDomainGrowReqC
registerex_req_msg- (2'.cn.jj.service.msg.protocol.RegisterReqO
mobileregisterex_req_msg. (2-.cn.jj.service.msg.protocol.MobileRegisterReqQ
getrealregstatus_req_msg/ (2/.cn.jj.service.msg.protocol.GetRealRegStatusReqc
!commercegetallpartnerinfo_req_msg0 (28.cn.jj.service.msg.protocol.CommerceGetAllPartnerInfoReqS
commerceuserlogin_req_msg1 (20.cn.jj.service.msg.protocol.CommerceUserLoginReqQ
getpngverifycode_req_msg2 (2/.cn.jj.service.msg.protocol.GetpngVerifyCodeReqY
verifyloginnameexist_req_msg3 (23.cn.jj.service.msg.protocol.VerifyLoginNameExistReqE
modifygrow_req_msg4 (2).cn.jj.service.msg.protocol.ModifyGrowReq"ﬁ
LobbyAckMsg;
login_ack_msg (2$.cn.jj.service.msg.protocol.LoginAck=
logout_ack_msg (2%.cn.jj.service.msg.protocol.LogoutAckI
anonymous_ack_msg (2..cn.jj.service.msg.protocol.AnonymousBrowseAckM
getuserallgrow_ack_msg (2-.cn.jj.service.msg.protocol.GetUserAllGrowAckM
getuserallware_ack_msg (2-.cn.jj.service.msg.protocol.GetUserAllWareAckM
getaccnummoney_ack_msg (2-.cn.jj.service.msg.protocol.GetAccNumMoneyAckO
tourneysignupex_ack_msg (2..cn.jj.service.msg.protocol.TourneySignupExAckO
tourneyunsignup_ack_msg (2..cn.jj.service.msg.protocol.TourneyUnsignupAckG
getsysmsgex_ack_msg	 (2*.cn.jj.service.msg.protocol.GetSysMsgExAckM
quickstartgame_ack_msg
 (2-.cn.jj.service.msg.protocol.QuickStartGameAcke
"getuserinterfixtourneylist_ack_msg (29.cn.jj.service.msg.protocol.GetUserInterfixTourneyListAckK
startclientex_ack_msg (2,.cn.jj.service.msg.protocol.StartClientExAckI
pushuserware_ack_msg (2+.cn.jj.service.msg.protocol.PushUserWareAckI
pushusergrow_ack_msg (2+.cn.jj.service.msg.protocol.PushUserGrowAckO
pushaccnummoney_ack_msg (2..cn.jj.service.msg.protocol.PushAccNumMoneyAckK
pushuserscore_ack_msg (2,.cn.jj.service.msg.protocol.PushUserScoreAckK
pushusermoney_ack_msg (2,.cn.jj.service.msg.protocol.PushUserMoneyAcku
*getusermatchpointsignuptourneylist_ack_msg (2A.cn.jj.service.msg.protocol.GetUserMatchPointSignupTourneyListAckQ
pushalowsysboard_ack_msg (2/.cn.jj.service.msg.protocol.PushAlowSysBoardAckO
gettickettempex_ack_msg (2..cn.jj.service.msg.protocol.GetTicketTempExAckM
modifynickname_ack_msg (2-.cn.jj.service.msg.protocol.ModifyNickNameAckO
terminatenotify_ack_msg (2..cn.jj.service.msg.protocol.TerminateNotifyAckM
verifynickname_ack_msg (2-.cn.jj.service.msg.protocol.VerifyNickNameAckO
verifyloginname_ack_msg (2..cn.jj.service.msg.protocol.VerifyLoginNameAckK
getverifycode_ack_msg (2,.cn.jj.service.msg.protocol.GetVerifyCodeAckA
register_ack_msg (2'.cn.jj.service.msg.protocol.RegisterAckK
getsinglegrow_ack_msg (2,.cn.jj.service.msg.protocol.GetSingleGrowAckS
urssendregsmscode_ack_msg (20.cn.jj.service.msg.protocol.URSSendRegSMSCodeAckM
mobileregister_ack_msg (2-.cn.jj.service.msg.protocol.MobileRegisterAckG
mobilelogin_ack_msg (2*.cn.jj.service.msg.protocol.MobileLoginAckE
lspushinfo_ack_msg (2).cn.jj.service.msg.protocol.LsPushInfoAckI
generallogin_ack_msg  (2+.cn.jj.service.msg.protocol.GeneralLoginAckE
noreglogin_ack_msg! (2).cn.jj.service.msg.protocol.NoRegLoginAckW
noregbinddefaultacc_ack_msg" (22.cn.jj.service.msg.protocol.NoRegBindDefaultAccAckS
noregbindemailacc_ack_msg# (20.cn.jj.service.msg.protocol.NoRegBindEmailAccAckU
noregbindmobileacc_ack_msg$ (21.cn.jj.service.msg.protocol.NoRegBindMobileAccAckO
getsmsrandompwd_ack_msg% (2..cn.jj.service.msg.protocol.GetSMSRandomPwdAckM
randompwdlogin_ack_msg& (2-.cn.jj.service.msg.protocol.RandomPwdLoginAckM
getaccesstoken_ack_msg' (2-.cn.jj.service.msg.protocol.GetAccessTokenAckQ
openpartnerlogin_ack_msg( (2/.cn.jj.service.msg.protocol.OpenPartnerLoginAckE
tokenlogin_ack_msg) (2).cn.jj.service.msg.protocol.TokenLoginAckI
modifyfigure_ack_msg* (2+.cn.jj.service.msg.protocol.ModifyFigureAckS
getuserdomaingrow_ack_msg+ (20.cn.jj.service.msg.protocol.GetUserDomainGrowAckQ
getrealregstatus_ack_msg, (2/.cn.jj.service.msg.protocol.GetRealRegStatusAckc
!commercegetallpartnerinfo_ack_msg- (28.cn.jj.service.msg.protocol.CommerceGetAllPartnerInfoAckS
commerceuserlogin_ack_msg. (20.cn.jj.service.msg.protocol.CommerceUserLoginAckQ
getpngverifycode_ack_msg/ (2/.cn.jj.service.msg.protocol.GetpngVerifyCodeAckY
verifyloginnameexist_ack_msg0 (23.cn.jj.service.msg.protocol.VerifyLoginNameExistAckE
modifygrow_ack_msg1 (2).cn.jj.service.msg.protocol.ModifyGrowAck"D

LsAddrInfo

ip (
port (
szip (	
szhost (	"∆
LcUserInfoEx
userid (
nickname (	
figureid (
coin (
bonus (
gold (
cert (
score (
masterscore	 (

matchcount
 (
	matchtime ("Õ
LoginReq
	loginname (	
nickname (	
password (	
gameid (
version (

ip (
time (
mac (	
psdsns	 (
param2
 (
param3 (

cryptotype ("∆
LoginAck
anonymousid (8
addrinfo (2&.cn.jj.service.msg.protocol.LsAddrInfo
showsns (
param2 (
param3 (:
userinfo (2(.cn.jj.service.msg.protocol.LcUserInfoEx"-
	LogoutReq
userid (
nickname (	" 
	LogoutAck
anonymousid ("3
AnonymousBrowseReq
time (
version ("µ
AnonymousBrowseAck
anonymousid (
	lstimever (

servertime (
channeltimever (
lsdyncinterfacever (
lslevel2masterscorever (
lslevel2bonusver (
lslevel2goldver (
lsproducttype2awardver	 (
lsgrowtypever
 (
lswaretypever (
userip (	"+

LcTranGrow
growid (
value ("#
GetUserAllGrowReq
userid ("]
GetUserAllGrowAck
userid (8
growlist (2&.cn.jj.service.msg.protocol.LcTranGrow"Z
TranWareBaseInfo
wareclassid (

waretypeid (
wareid (
count ("#
GetUserAllWareReq
userid ("S
GetUserAllWareAck>
warelist (2,.cn.jj.service.msg.protocol.TranWareBaseInfo"D
GetAccNumMoneyReq
userid (
accnum (
acctype ("}
GetAccNumMoneyAck
userid (
accnum (
acctype (
coin (
bonus (
gold (
cert ("≥
TourneySignupExReq
userid (
nickname (	
	tourneyid (

signuptype (
matchver (
param (
gamever (

matchpoint (
gameid	 ("J
TourneySignupExAck
	tourneyid (
param (

matchpoint ("l
TourneyUnsignupReq
userid (
nickname (	
	tourneyid (
param (

matchpoint ("J
TourneyUnsignupAck
	tourneyid (
param (

matchpoint ("æ
MessageIC2LsItem
msgid (
msgtype (
sendtime (
offline (
showpos (
cltproperty (
	showlevel (
sender (	
title	 (	
content
 (	"
GetSysMsgExReq
maxid ("O
GetSysMsgExAck=
msglist (2,.cn.jj.service.msg.protocol.MessageIC2LsItem"Ç
QuickStartGameReq
	clientver (

ip (
time (
mac (	
anonymousid (
param1 (
param2 ("e
QuickStartGameAck
vistorid (
vistornickname (	
vistorfigureid (
param1 ("H
UserInterfixTourney
	tourneyid (
userid (
signup ("/
GetUserInterfixTourneyListReq
userid ("e
GetUserInterfixTourneyListAckD
tourneylist (2/.cn.jj.service.msg.protocol.UserInterfixTourney"§
StartClientExAck
userid (
	tourneyid (
matchid (
stageid (
gameid (
	productid (

ip (	
port (
ticket	 ("a
PushUserWareAck
userid (>
warelist (2,.cn.jj.service.msg.protocol.TranWareBaseInfo"[
PushUserGrowAck
userid (8
growlist (2&.cn.jj.service.msg.protocol.LcTranGrow"~
PushAccNumMoneyAck
userid (
accnum (
acctype (
coin (
bonus (
gold (
cert ("ù
PushUserScoreAck
userid (
gameid (
	matchtime (

matchcount (
param1 (
param2 (
score (
masterscore ("[
PushUserMoneyAck
userid (
coin (
bonus (
gold (
cert ("W
UserMatchPoint
	tourneyid (

matchpoint (
userid (
signup ("~
%GetUserMatchPointSignupTourneyListAck
	tourneyid (B
matchpointlist (2*.cn.jj.service.msg.protocol.UserMatchPoint"B
PushAlowSysBoardAck
type (
caption (	
text (	"2
GetTicketTempExReq
userid (
type ("Y
GetTicketTempExAck
userid (
type (
ticketcrttime (
ticket (	"8
ModifyNickNameReq
userid (
nicknamenew (	" 
ModifyNickNameAck
ret ("'
TerminateNotifyAck
	nullvalue ("4
VerifyNickNameReq
nickname (	
param ("4
VerifyNickNameAck
nickname (	
param ("6
VerifyLoginNameReq
	loginname (	
param ("6
VerifyLoginNameAck
	loginname (	
param ("!
GetVerifyCodeReq
param ("$
GetpngVerifyCodeReq
param ("L
VerifyLoginNameExistReq
	loginname (	
param (
acctype ("U
GetVerifyCodeAck
	timefound (
param (
len (

verifycode ("X
GetpngVerifyCodeAck
	timefound (
param (
len (

verifycode ("L
VerifyLoginNameExistAck
	loginname (	
param (
acctype ("¬
RegisterReq
	loginname (	
nickname (	
password (	
figureid (

verifycode (	
	timefound (
param (
email (	
agent	 (
extendid
 (
extendnickname (	
newplayercard (	
param1 (
param2 (
macaddr (	
customid (

cryptotype (">
RegisterAck
param (
userid (
nickname (	"2
GetSingleGrowReq
userid (
growid ("7
GetSingleGrowAck
growid (
growbalance ("O
URSSendRegSMSCodeReq
userid (
phonenumber (	

smschannel (":
URSSendRegSMSCodeAck
phonenumber (	
param ("ﬂ
MobileRegisterReq
phonenumber (	
smslongcode (	
nickname (	
password (	
figureid (

verifycode (	
	timefound (
param (
email	 (	
agent
 (
extendid (
extendnickname (	
newplayercard (	
param1 (
param2 (
macaddr (	
customid (

cryptotype ("D
MobileRegisterAck
param (
userid (
nickname (	"Ø
MobileLoginReq
phonenumber (	
nickname (	
password (	
gameid (
macaddr (	
psdsns (
comitschemeid (
param (
devid	 (	"œ
MobileLoginAck
anonymousid (:

lsaddrinfo (2&.cn.jj.service.msg.protocol.LsAddrInfo
showsns (
proxynip (
param (:
userinfo (2(.cn.jj.service.msg.protocol.LcUserInfoEx">
	DSMsgItem
msgid (
ctrxml (	

displayxml (	"G
LsPushInfoAck6
msgitem (2%.cn.jj.service.msg.protocol.DSMsgItem"…
GeneralLoginReq
generalloginname (	
nickname (	
password (	
gameid (
macaddr (	
psdsns (
comitschemeid (
param (
devid	 (	

cryptotype
 ("–
GeneralLoginAck
anonymousid (:

lsaddrinfo (2&.cn.jj.service.msg.protocol.LsAddrInfo
showsns (
proxynip (
param (:
userinfo (2(.cn.jj.service.msg.protocol.LcUserInfoEx"°
NoRegLoginReq
specialcode (	
agentid (
	agentmark (	
macaddr (	
snspwd (
comitschemeid (
devid (	
customid ("ø
NoRegLoginAck
anonymousid (:

lsaddrinfo (2&.cn.jj.service.msg.protocol.LsAddrInfo
showsns (
proxynip (:
userinfo (2(.cn.jj.service.msg.protocol.LcUserInfoEx"ù
NoRegBindDefaultAccReq
specialcode (	
	loginname (	
password (	
nickname (	
figureid (

verifycode (	
	timefound ("(
NoRegBindDefaultAccAck
userid ("ó
NoRegBindEmailAccReq
specialcode (	
email (	
password (	
nickname (	
figureid (

verifycode (	
	timefound ("&
NoRegBindEmailAccAck
userid ("É
NoRegBindMobileAccReq
specialcode (	
mobile (	
password (	
nickname (	
figureid (
smscode (	"'
NoRegBindMobileAccAck
userid ("+
UnicomAccountUpReq
unicomaccount (	"4
GetSMSRandomPwdReq
	loginname (	
mac (	"'
GetSMSRandomPwdAck
	nullvalue ("†
RandomPwdLoginReq
	loginname (	
	randompwd (	
agentid (
	agentmark (	
mac (	
psdsns (
comitschemeid (
devid (	"Ó
RandomPwdLoginAck
anonymousid (:

lsaddrinfo (2&.cn.jj.service.msg.protocol.LsAddrInfo
showsns (
proxynip (:
userinfo (2(.cn.jj.service.msg.protocol.LcUserInfoEx
refreshtoken (	
accesstoken (	"≠
GetAccessTokenReq
	granttype (	
reqtoken (	
appkey (	
	appsecret (	
redirecturi (	
scope (	
protocol (
time (	
sign	 (	"™
GetAccessTokenAck
result (
accesstoken (	
refreshtoken (	

sessionkey (	
sessionsecret (	
expires (
param1 (	
param2 (	"‰
OpenPartnerLoginReq
partneruserid (	
	partnerid (
macaddr (	
accesstoken (	
refreshtoken (	
	loginname (	
password (	
param1 (
param2	 (
szparam1
 (	
szparam2 (	"h
OpenPartnerLoginAck
acktype (
partneruserid (	
accesstoken (	
refreshtoken (	"ß
TokenLoginReq
	loginname (	
refreshtoken (	
acctoken (	
macaddr (	
psdsns (
comitschemeid (
reserveparam (
devid (	"Á
TokenLoginAck
anonymousid (:

lsaddrinfo (2&.cn.jj.service.msg.protocol.LsAddrInfo
showsns (
proxynip (:
userinfo (2(.cn.jj.service.msg.protocol.LcUserInfoEx
refreshtoken (	
acctoken (	"6
ModifyFigureReq
userid (
newfigureid ("$
ModifyFigureAck
	nullvalue ("W
GetUserDomainGrowReq
userid (
domainid (
gameid (
param ("+

DomainGrow
growid (
value ("ë
GetUserDomainGrowAck
userid (
domainid (
gameid (
param (8
growlist (2&.cn.jj.service.msg.protocol.DomainGrow"%
GetRealRegStatusReq
userid ("%
GetRealRegStatusAck
status ("Ñ
CommerceGetAllPartnerInfoReq
partneruserid (	
apikey (	
	sessionid (	
	timestamp (	
sign (	
	partnerid (
mac (	
uparam1 (
uparam2	 (
szparam1
 (	
szparam2 (	
customid (
	productid ("T
PartnerInfo
userid (
figureid (
nickname (	
	loginname (	"9
PartnerCertLoginResult
errcode (	
errmsg (	"ﬂ
CommerceGetAllPartnerInfoAck
acktype (
partneruserid (	
partneruseral (<
partnerinfo (2'.cn.jj.service.msg.protocol.PartnerInfoB
result (22.cn.jj.service.msg.protocol.PartnerCertLoginResult"∑
CommerceUserLoginReq
partneruserid (	
	sessionid (	
	timestamp (	
sign (	
	partnerid (
mac (	
	loginname (	
password (	
uparam1	 (
uparam2
 (
szparam1 (	
szparam2 (	
reserve (
	productid (
gameid (
comitschemeid (">
CommerceUserLoginAck
acktype (
partneruserid (	"e
ModifyGrowReq
userid (
growid (
	growvalue (

outeraccid (
param ("2
ModifyGrowAck
growid (
	growvalue (
Ù
TKLord.protocn.jj.service.msg.protocol"§

LordReqMsg
matchid (K
lordcallscore_req_msg (2,.cn.jj.service.msg.protocol.LordCallScoreReqO
lordtakeoutcard_req_msg (2..cn.jj.service.msg.protocol.LordTakeoutCardReqC
lordtrust_req_msg (2(.cn.jj.service.msg.protocol.LordTrustReqO
lordcancelround_req_msg (2..cn.jj.service.msg.protocol.LordCancelRoundReqQ
lordchecktimeout_req_msg (2/.cn.jj.service.msg.protocol.LordCheckTimeOutReq"Ï

LordAckMsg
matchid (K
lordcallscore_ack_msg (2,.cn.jj.service.msg.protocol.LordCallScoreAckO
lordtakeoutcard_ack_msg (2..cn.jj.service.msg.protocol.LordTakeoutCardAckC
lordtrust_ack_msg (2(.cn.jj.service.msg.protocol.LordTrustAckI
lordinitcard_ack_msg (2+.cn.jj.service.msg.protocol.LordInitCardAckU
lordinitbottomcard_ack_msg (21.cn.jj.service.msg.protocol.LordInitBottomCardAckE
lordresult_ack_msg (2).cn.jj.service.msg.protocol.LordResultAckE
lordtipmsg_ack_msg	 (2).cn.jj.service.msg.protocol.LordTipMsgAckC
lordempty_ack_msg
 (2(.cn.jj.service.msg.protocol.LordEmptyAck[
lordchangetakeouttime_ack_msg (24.cn.jj.service.msg.protocol.LordChangeTakeoutTimeAckM
lordchangeinfo_ack_msg (2-.cn.jj.service.msg.protocol.LordChangeInfoAckI
lordnickname_ack_msg (2+.cn.jj.service.msg.protocol.LordNickNameAck"f
LordCallScoreReq
nextcallseat (
curcallseat (
curscore (
validatescore ("f
LordCallScoreAck
nextcallseat (
curcallseat (
curscore (
validatescore ("{
LordTakeoutCardReq
seat (

nextplayer (

passplayer (
multiple (
isover (
cards ("{
LordTakeoutCardAck
seat (

nextplayer (

passplayer (
multiple (
isover (
cards (";
LordTrustReq
seat (
trust (
userid (";
LordTrustAck
seat (
trust (
userid ("'
LordCancelRoundReq
	nullvalue ("N
LordInitCardAck
firstcallseat (
firstinitcard (
cards ("f
LordInitBottomCardAck
lordseat (
firstfarmerseat (
bottomscore (
cards ("i
LordResultAck
score (B
winseat (
	cardcount (B
spring (
cards ("
LordTipMsgAck
tip (	""
LordEmptyAck
scores (B"=
LordChangeTakeoutTimeAck
seat (
takeouttime ("U
LordChangeInfoAck
score0 (
score1 (
score2 (
gamehand (" 
LordNickNameAck
nicks (	"(
LordCheckTimeOutReq
	nullvalue (
µ
TKLZLord.protocn.jj.service.msg.protocol"ƒ
LZLordReqMsg
matchid (
time (I
lz_call_score_req_msg (2*.cn.jj.service.msg.protocol.LZCallScoreReqD
lz_present_req_msg (2(.cn.jj.service.msg.protocol.LZPresentReq>
lz_pass_req_msg (2%.cn.jj.service.msg.protocol.LZPassReqD
lz_trustin_req_msg (2(.cn.jj.service.msg.protocol.LZTrustInReq"›
LZLordAckMsg
matchid (
time (I
lz_start_game_ack_msg (2*.cn.jj.service.msg.protocol.LZStartGameAckK
lz_send_config_ack_msg (2+.cn.jj.service.msg.protocol.LZSendConfigAckU
lz_update_thinktime_ack_msg (20.cn.jj.service.msg.protocol.LZUpdateThinkTimeAckI
lz_call_score_ack_msg (2*.cn.jj.service.msg.protocol.LZCallScoreAck[
lz_dispatch_sessionkey_ack_msg (23.cn.jj.service.msg.protocol.LZDispatchSessionKeyAckQ
lz_dispatch_cards_ack_msg (2..cn.jj.service.msg.protocol.LZDispatchCardsAckM
lz_declare_lord_ack_msg	 (2,.cn.jj.service.msg.protocol.LZDeclareLordAckU
lz_declare_wildcard_ack_msg
 (20.cn.jj.service.msg.protocol.LZDeclareWildCardAckY
lz_declare_matchscore_ack_msg (22.cn.jj.service.msg.protocol.LZDeclareMatchScoreAckj
&lz_declare_firstcallscore_seat_ack_msg (2:.cn.jj.service.msg.protocol.LZDeclareFirstCallScoreSeatAckf
$lz_declare_firstpresent_seat_ack_msg (28.cn.jj.service.msg.protocol.LZDeclareFirstPresentSeatAckD
lz_present_ack_msg (2(.cn.jj.service.msg.protocol.LZPresentAck>
lz_pass_ack_msg (2%.cn.jj.service.msg.protocol.LZPassAckD
lz_trustin_ack_msg (2(.cn.jj.service.msg.protocol.LZTrustInAckY
lz_onlinestate_change_ack_msg (22.cn.jj.service.msg.protocol.LZOnlineStateChangeAckJ
lz_quit_on_own_ack_msg (2*.cn.jj.service.msg.protocol.LZQuitOnOwnAckK
lz_finish_game_ack_msg (2+.cn.jj.service.msg.protocol.LZFinishGameAckG
lz_cast_dice_ack_msg (2).cn.jj.service.msg.protocol.LZCastDiceAckf
"lz_send_undercard_wildcard_ack_msg (2:.cn.jj.service.msg.protocol.LZSendUnderCardsAndWildCardAck"-
LZCallScoreReq
seat (
score ("
	LZPassReq
seat ("9
LZPresentReq
seat (
type (
cards ("-
LZTrustInReq
seat (
trustin ("
LZStartGameAck
seat ("I
LZSendConfigAck
seat (
hide_player_mode (
config (	"8
LZUpdateThinkTimeAck
seat (

think_time ("1
LZDispatchCardsAck
seat (
cards (";
LZDispatchSessionKeyAck
seat (

sessionkey (".
LZDeclareFirstCallScoreSeatAck
seat ("-
LZCallScoreAck
seat (
score ("Z
LZDeclareLordAck
	lord_seat (
score (
init_multiple (
cards ("3
LZDeclareWildCardAck
seat (
cards ("5
LZDeclareMatchScoreAck
seat (
score ("-
LZCastDiceAck
seat (
number (",
LZDeclareFirstPresentSeatAck
seat ("9
LZPresentAck
seat (
type (
cards ("
	LZPassAck
seat ("-
LZTrustInAck
seat (
trustin ("6
LZOnlineStateChangeAck
seat (
online ("]
LZFinishGameAck
seat (
remain_cards (
bot_instead (
	nick_name (	"W
LZSendUnderCardsAndWildCardAck
seat (

whild_card (
under_cards ("
LZQuitOnOwnAck
seat (
ô<
TKMahJong.protocn.jj.service.msg.protocol"≥
MahJongReqMsg
matchid (W
mahjongopendoorover_req_msg (22.cn.jj.service.msg.protocol.MahJongOpenDoorOverReqL
mahjongrequst_req_msg (2-.cn.jj.service.msg.protocol.MahJongRequestReqW
mahjongchangeflower_req_msg (22.cn.jj.service.msg.protocol.MahJongChangeFlowerReqU
mahjongdiscardtile_req_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileReqG
mahjongcall_req_msg (2*.cn.jj.service.msg.protocol.MahJongCallReqE
mahjongchi_req_msg (2).cn.jj.service.msg.protocol.MahJongChiReqG
mahjongpeng_req_msg (2*.cn.jj.service.msg.protocol.MahJongPengReqG
mahjonggang_req_msg	 (2*.cn.jj.service.msg.protocol.MahJongGangReqE
mahjongwin_req_msg
 (2).cn.jj.service.msg.protocol.MahJongWinReqQ
mahjongtrustplay_req_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayReq"é
MahJongAckMsg
matchid (Q
mahjonggamebegin_ack_msg (2/.cn.jj.service.msg.protocol.MahJongGameBeginAckO
mahjongruleinfo_ack_msg (2..cn.jj.service.msg.protocol.MahJongRuleInfoAckI
mahjongplace_ack_msg (2+.cn.jj.service.msg.protocol.MahJongPlaceAckQ
mahjongwindplace_ack_msg (2/.cn.jj.service.msg.protocol.MahJongWindPlaceAckK
mahjongresult_ack_msg (2,.cn.jj.service.msg.protocol.MahJongResultAckM
mahjongshuffle_ack_msg (2-.cn.jj.service.msg.protocol.MahJongShuffleAckO
mahjongcastdice_ack_msg (2..cn.jj.service.msg.protocol.MahJongCastDiceAckO
mahjongopendoor_ack_msg	 (2..cn.jj.service.msg.protocol.MahJongOpenDoorAckE
mahjonghun_ack_msg
 (2).cn.jj.service.msg.protocol.MahJongHunAckK
mahjongaction_ack_msg (2,.cn.jj.service.msg.protocol.MahJongActionAckM
mahjongrequest_ack_msg (2-.cn.jj.service.msg.protocol.MahJongRequestAckW
mahjongchangeflower_ack_msg (22.cn.jj.service.msg.protocol.MahJongChangeFlowerAckU
mahjongdiscardtile_ack_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileAckO
mahjongdrawtile_ack_msg (2..cn.jj.service.msg.protocol.MahJongDrawTileAckG
mahjongcall_ack_msg (2*.cn.jj.service.msg.protocol.MahJongCallAckE
mahjongchi_ack_msg (2).cn.jj.service.msg.protocol.MahJongChiAckG
mahjongpeng_ack_msg (2*.cn.jj.service.msg.protocol.MahJongPengAckG
mahjonggang_ack_msg (2*.cn.jj.service.msg.protocol.MahJongGangAckE
mahjongwin_ack_msg (2).cn.jj.service.msg.protocol.MahJongWinAckQ
mahjongwindetail_ack_msg (2/.cn.jj.service.msg.protocol.MahJongWinDetailAckU
mahjongwindetailex_ack_msg (21.cn.jj.service.msg.protocol.MahJongWinDetailExAckK
mahjongnotify_ack_msg (2,.cn.jj.service.msg.protocol.MahJongNotifyAckQ
mahjongtrustplay_ack_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayAckU
mahjongscorechange_ack_msg (21.cn.jj.service.msg.protocol.MahJongScoreChangeAck"(
MahJongGameBeginAck
	nullvalue ("u
MahJongRuleInfoAck
rule (
winselfonly (
discardtime (
waittime (
winneedminfan ("F
MahJongPlaceAck
gameseat (B
banker (
rules ("(
MahJongWindPlaceAck
	roundwind ("É
PlayerResult
win (
pao (
gang (
score (

totalscore (
handtilecount (
	handtiles ("Æ
MahJongResultAck
wininfo (?
playerresults (2(.cn.jj.service.msg.protocol.PlayerResult
time (:
	windetail (2'.cn.jj.service.msg.protocol.WinDetailEx"S
MahJongShuffleAck
	tilecount (
	magicitem (
frustaofseat (B"^
MahJongCastDiceAck
seat (
castdicetype (
	dicecount (
	dicevalue ("q
MahJongOpenDoorAck
seat (
opendoorseat (
opendoorfrusta (
handtile (
tiles ("&
MahJongOpenDoorOverReq
seat ("v
MahJongHunAck
fromwallheader (

tileoffset (
tileid (
huntilecount (
hunttileids ("\
MahJongActionAck
seat (
	requestid (
requesttype (

waitsecond ("O
MahJongRequestReq
seat (
	requestid (
giveuprequesttype ("O
MahJongRequestAck
seat (
	requestid (
giveuprequesttype ("I
MahJongChangeFlowerReq
seat (
	requestid (
tileid ("I
MahJongChangeFlowerAck
seat (
	requestid (
tileid ("V
MahJongDiscardTileReq
seat (
	requestid (
tileid (
hide ("V
MahJongDiscardTileAck
seat (
	requestid (
tileid (
hide ("t
MahJongDrawTileAck
seat (
drawtiletype (
fromwallheader (

tileoffset (
tileid ("Ñ
MahJongCallReq
seat (
	requestid (
tileid (
winself (
autogang (
calltype (
hide ("Ñ
MahJongCallAck
seat (
	requestid (
tileid (
winself (
autogang (
calltype (
hide ("S
MahJongChiReq
seat (
	requestid (
tileid (
	chitileid ("S
MahJongChiAck
seat (
	requestid (
tileid (
	chitileid ("U
MahJongPengReq
seat (
	requestid (
tileid (

pengtileid ("U
MahJongPengAck
seat (
	requestid (
tileid (

pengtileid ("g
MahJongGangReq
seat (
	requestid (
tileid (
gangtype (

gangtileid ("g
MahJongGangAck
seat (
	requestid (
tileid (
gangtype (

gangtileid ("/
ScoreDetail
score (
	leftscore ("1
ScoreDetailEx
score (
	leftscore ("0
Stone

id (
color (
what ("R

StoneGroup0
stone (2!.cn.jj.service.msg.protocol.Stone

groupstyle ("Ù
MahJongWinReq
seat (
	requestid (
paoseat (
tileid (
	resultant (
groups (

showgroups (5
group (2&.cn.jj.service.msg.protocol.StoneGroup3
handtile	 (2!.cn.jj.service.msg.protocol.Stone"|
MahJongWinAck
winseats (
winseatcount (
paoseat (
	wintileid (
winmode (
winfan ("ı
WinInfo
maxfans (
fans (
	resultant (6
groups (2&.cn.jj.service.msg.protocol.StoneGroup4
	handstone (2!.cn.jj.service.msg.protocol.Stone

groupcount (
	wintileid (2
flowers (2!.cn.jj.service.msg.protocol.Stone
flowercount	 (
quanwind
 (
menwind (

showgroups (
winmode (

scoreoffan (""
Fan
type (
count ("õ
	WinInfoEx
maxfans (0
fanlist (2.cn.jj.service.msg.protocol.Fan
	resultant (6
groups (2&.cn.jj.service.msg.protocol.StoneGroup4
	handstone (2!.cn.jj.service.msg.protocol.Stone

groupcount (
	wintileid (2
flowers (2!.cn.jj.service.msg.protocol.Stone
flowercount	 (
quanwind
 (
menwind (

showgroups (
winmode (

scoreoffan ("ÿ
WinDetailEx
winseat (
paoseat (
wintile (4
wininfo (2#.cn.jj.service.msg.protocol.WinInfo
	basescore (?
scoredetails (2).cn.jj.service.msg.protocol.ScoreDetailEx
time ("ﬁ
MahJongWinDetailAck
winseat (
paoseat (
wintile (4
wininfo (2#.cn.jj.service.msg.protocol.WinInfo
	basescore (=
scoredetails (2'.cn.jj.service.msg.protocol.ScoreDetail
time ("‰
MahJongWinDetailExAck
winseat (
paoseat (
wintile (6
wininfo (2%.cn.jj.service.msg.protocol.WinInfoEx
	basescore (?
scoredetails (2).cn.jj.service.msg.protocol.ScoreDetailEx
time ("I
MahJongNotifyAck
notify (
	notifystr (	

notifytype ("3
MahJongTrustPlayReq
userid (
type ("3
MahJongTrustPlayAck
userid (
type (",
MahJongScoreChangeAck
incremental (
±)
TKMahJongBR.protocn.jj.service.msg.protocolTKMahJong.proto"õ	
MahJongBRReqMsg
matchid (W
mahjongopendoorover_req_msg (22.cn.jj.service.msg.protocol.MahJongOpenDoorOverReqL
mahjongrequst_req_msg (2-.cn.jj.service.msg.protocol.MahJongRequestReqW
mahjongchangeflower_req_msg (22.cn.jj.service.msg.protocol.MahJongChangeFlowerReqU
mahjongdiscardtile_req_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileReqG
mahjongcall_req_msg (2*.cn.jj.service.msg.protocol.MahJongCallReqE
mahjongchi_req_msg (2).cn.jj.service.msg.protocol.MahJongChiReqG
mahjongpeng_req_msg (2*.cn.jj.service.msg.protocol.MahJongPengReqG
mahjonggang_req_msg	 (2*.cn.jj.service.msg.protocol.MahJongGangReqE
mahjongwin_req_msg
 (2).cn.jj.service.msg.protocol.MahJongWinReqQ
mahjongtrustplay_req_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayReq_
mahjongbrexchangeselect_req_msg (26.cn.jj.service.msg.protocol.MahJongBRExchangeSelectReq[
mahjongbrgiveupselect_req_msg (24.cn.jj.service.msg.protocol.MahJongBRGiveupSelectReqR
majongbrcastdice_req_msg (20.cn.jj.service.msg.protocol.MahjongBRCastDiceReqR
majongbrexchange_req_msg (20.cn.jj.service.msg.protocol.MahjongBRExchangeReq"Ö
MahJongBRAckMsg
matchid (Q
mahjonggamebegin_ack_msg (2/.cn.jj.service.msg.protocol.MahJongGameBeginAckO
mahjongruleinfo_ack_msg (2..cn.jj.service.msg.protocol.MahJongRuleInfoAckI
mahjongplace_ack_msg (2+.cn.jj.service.msg.protocol.MahJongPlaceAckQ
mahjongwindplace_ack_msg (2/.cn.jj.service.msg.protocol.MahJongWindPlaceAckK
mahjongresult_ack_msg (2,.cn.jj.service.msg.protocol.MahJongResultAckM
mahjongshuffle_ack_msg (2-.cn.jj.service.msg.protocol.MahJongShuffleAckO
mahjongcastdice_ack_msg (2..cn.jj.service.msg.protocol.MahJongCastDiceAckO
mahjongopendoor_ack_msg	 (2..cn.jj.service.msg.protocol.MahJongOpenDoorAckE
mahjonghun_ack_msg
 (2).cn.jj.service.msg.protocol.MahJongHunAckK
mahjongaction_ack_msg (2,.cn.jj.service.msg.protocol.MahJongActionAckM
mahjongrequest_ack_msg (2-.cn.jj.service.msg.protocol.MahJongRequestAckW
mahjongchangeflower_ack_msg (22.cn.jj.service.msg.protocol.MahJongChangeFlowerAckU
mahjongdiscardtile_ack_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileAckO
mahjongdrawtile_ack_msg (2..cn.jj.service.msg.protocol.MahJongDrawTileAckG
mahjongcall_ack_msg (2*.cn.jj.service.msg.protocol.MahJongCallAckE
mahjongchi_ack_msg (2).cn.jj.service.msg.protocol.MahJongChiAckG
mahjongpeng_ack_msg (2*.cn.jj.service.msg.protocol.MahJongPengAckG
mahjonggang_ack_msg (2*.cn.jj.service.msg.protocol.MahJongGangAckG
mahjongwin_ack_msg (2+.cn.jj.service.msg.protocol.MahJongBRWinAckQ
mahjongwindetail_ack_msg (2/.cn.jj.service.msg.protocol.MahJongWinDetailAckU
mahjongwindetailex_ack_msg (21.cn.jj.service.msg.protocol.MahJongWinDetailExAckK
mahjongnotify_ack_msg (2,.cn.jj.service.msg.protocol.MahJongNotifyAckQ
mahjongtrustplay_ack_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayAckU
mahjongscorechange_ack_msg (21.cn.jj.service.msg.protocol.MahJongScoreChangeAckO
mahjongbrresult_ack_msg (2..cn.jj.service.msg.protocol.MahJongBRResultAckS
mahjongbrwindrain_ack_msg (20.cn.jj.service.msg.protocol.MahJongBRWindRainAck_
mahjongbrexchangeselect_ack_msg (26.cn.jj.service.msg.protocol.MahJongBRExchangeSelectAckg
#mahjongbrexchangeselectover_ack_msg (2:.cn.jj.service.msg.protocol.MahJongBRExchangeSelectOverAckS
mahjongbrexchange_ack_msg (20.cn.jj.service.msg.protocol.MahJongBRExchangeAck[
mahjongbrgiveupselect_ack_msg (24.cn.jj.service.msg.protocol.MahJongBRGiveupSelectAckO
mahjongbrgiveup_ack_msg  (2..cn.jj.service.msg.protocol.MahJongBRGiveupAck"≥
MahJongBRWinAck
winseats (
winseatcount (
paoseat (
	wintileid (
winmode (
winfan (
	anFanType (
	anGangFan (
anFan	 ("u
BRPlayerWinInfo
winseat (
paoseat (
fanType (
fan (
	anGangFan (
anScore ("N
BRPlayerCheckCallInfo
checkCallType (
anFan (
anScore ("™
BRPlayerResult
cnWin (>
	anWinInfo (2+.cn.jj.service.msg.protocol.BRPlayerWinInfo
score (

totalScore (

cnHandTile (

anHandTile ("¥
MahJongBRResultAck@
playerResult (2*.cn.jj.service.msg.protocol.BRPlayerResultN
playerCheckCallInfo (21.cn.jj.service.msg.protocol.BRPlayerCheckCallInfo
time ("2
MahJongBRWindRainAck
mode (
seat ("V
MahJongBRExchangeSelectReq
seat (
	tileCount (
apnExchangeTile ("Z
MahJongBRExchangeSelectOverAck
seat (
	tileCount (
apnExchangeTile ("K
MahJongBRExchangeSelectAck
seat (
time (
	tileCount ("$
MahjongBRExchangeReq
seat ("z
MahJongBRExchangeAck
seat (
exchangeType (
	tileCount (
apnExchangeTile (

apnOldTile ("R
MahJongBRGiveupSelectReq
seat (
	tileCount (
apnGiveupTile ("I
MahJongBRGiveupSelectAck
seat (
time (
	tileCount ("L
MahJongBRGiveupAck
seat (
	tileCount (
apnGiveupTile ("$
MahjongBRCastDiceReq
seat (
ã
TKMahJongDZ.protocn.jj.service.msg.protocolTKMahJong.proto"µ
MahJongDZReqMsg
matchid (W
mahjongopendoorover_req_msg (22.cn.jj.service.msg.protocol.MahJongOpenDoorOverReqL
mahjongrequst_req_msg (2-.cn.jj.service.msg.protocol.MahJongRequestReqW
mahjongchangeflower_req_msg (22.cn.jj.service.msg.protocol.MahJongChangeFlowerReqU
mahjongdiscardtile_req_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileReqG
mahjongcall_req_msg (2*.cn.jj.service.msg.protocol.MahJongCallReqE
mahjongchi_req_msg (2).cn.jj.service.msg.protocol.MahJongChiReqG
mahjongpeng_req_msg (2*.cn.jj.service.msg.protocol.MahJongPengReqG
mahjonggang_req_msg	 (2*.cn.jj.service.msg.protocol.MahJongGangReqE
mahjongwin_req_msg
 (2).cn.jj.service.msg.protocol.MahJongWinReqQ
mahjongtrustplay_req_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayReq"ê
MahJongDZAckMsg
matchid (Q
mahjonggamebegin_ack_msg (2/.cn.jj.service.msg.protocol.MahJongGameBeginAckO
mahjongruleinfo_ack_msg (2..cn.jj.service.msg.protocol.MahJongRuleInfoAckI
mahjongplace_ack_msg (2+.cn.jj.service.msg.protocol.MahJongPlaceAckQ
mahjongwindplace_ack_msg (2/.cn.jj.service.msg.protocol.MahJongWindPlaceAckK
mahjongresult_ack_msg (2,.cn.jj.service.msg.protocol.MahJongResultAckM
mahjongshuffle_ack_msg (2-.cn.jj.service.msg.protocol.MahJongShuffleAckO
mahjongcastdice_ack_msg (2..cn.jj.service.msg.protocol.MahJongCastDiceAckO
mahjongopendoor_ack_msg	 (2..cn.jj.service.msg.protocol.MahJongOpenDoorAckE
mahjonghun_ack_msg
 (2).cn.jj.service.msg.protocol.MahJongHunAckK
mahjongaction_ack_msg (2,.cn.jj.service.msg.protocol.MahJongActionAckM
mahjongrequest_ack_msg (2-.cn.jj.service.msg.protocol.MahJongRequestAckW
mahjongchangeflower_ack_msg (22.cn.jj.service.msg.protocol.MahJongChangeFlowerAckU
mahjongdiscardtile_ack_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileAckO
mahjongdrawtile_ack_msg (2..cn.jj.service.msg.protocol.MahJongDrawTileAckG
mahjongcall_ack_msg (2*.cn.jj.service.msg.protocol.MahJongCallAckE
mahjongchi_ack_msg (2).cn.jj.service.msg.protocol.MahJongChiAckG
mahjongpeng_ack_msg (2*.cn.jj.service.msg.protocol.MahJongPengAckG
mahjonggang_ack_msg (2*.cn.jj.service.msg.protocol.MahJongGangAckE
mahjongwin_ack_msg (2).cn.jj.service.msg.protocol.MahJongWinAckQ
mahjongwindetail_ack_msg (2/.cn.jj.service.msg.protocol.MahJongWinDetailAckU
mahjongwindetailex_ack_msg (21.cn.jj.service.msg.protocol.MahJongWinDetailExAckK
mahjongnotify_ack_msg (2,.cn.jj.service.msg.protocol.MahJongNotifyAckQ
mahjongtrustplay_ack_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayAckU
mahjongscorechange_ack_msg (21.cn.jj.service.msg.protocol.MahJongScoreChangeAck
ï&
TKMahJongSCN.protocn.jj.service.msg.protocolTKMahJong.proto"Ñ	
MahJongSCNReqMsg
matchid (
time (W
mahjongopendoorover_req_msg (22.cn.jj.service.msg.protocol.MahJongOpenDoorOverReqL
mahjongrequst_req_msg (2-.cn.jj.service.msg.protocol.MahJongRequestReqU
mahjongdiscardtile_req_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileReqG
mahjongcall_req_msg (2*.cn.jj.service.msg.protocol.MahJongCallReqG
mahjongpeng_req_msg (2*.cn.jj.service.msg.protocol.MahJongPengReqJ
mahjonggang_req_msg	 (2-.cn.jj.service.msg.protocol.MahJongSCNGangReqE
mahjongwin_req_msg
 (2).cn.jj.service.msg.protocol.MahJongWinReqQ
mahjongtrustplay_req_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayReqa
 mahjongscnexchangeselect_req_msg (27.cn.jj.service.msg.protocol.MahJongSCNExchangeSelectReq[
mahjongscnexchangeend_req_msg (24.cn.jj.service.msg.protocol.MahJongSCNExchangeEndReq_
mahjongscnackfixmissing_req_msg (26.cn.jj.service.msg.protocol.MahJongSCNAckFixMissingReq[
mahjongscncastdiceend_req_msg (24.cn.jj.service.msg.protocol.MahJongSCNCastDiceEndReq]
mahjongscnanimationend_req_msg (25.cn.jj.service.msg.protocol.MahJongSCNAnimationEndReq"¥
MahJongSCNAckMsg
matchid (
time (T
mahjonggamebegin_ack_msg (22.cn.jj.service.msg.protocol.MahJongSCNGameBeginAckO
mahjongruleinfo_ack_msg (2..cn.jj.service.msg.protocol.MahJongRuleInfoAckI
mahjongplace_ack_msg (2+.cn.jj.service.msg.protocol.MahJongPlaceAckQ
mahjongwindplace_ack_msg (2/.cn.jj.service.msg.protocol.MahJongWindPlaceAckK
mahjongresult_ack_msg (2,.cn.jj.service.msg.protocol.MahJongResultAckM
mahjongshuffle_ack_msg (2-.cn.jj.service.msg.protocol.MahJongShuffleAckO
mahjongcastdice_ack_msg	 (2..cn.jj.service.msg.protocol.MahJongCastDiceAckO
mahjongopendoor_ack_msg
 (2..cn.jj.service.msg.protocol.MahJongOpenDoorAckK
mahjongaction_ack_msg (2,.cn.jj.service.msg.protocol.MahJongActionAckM
mahjongrequest_ack_msg (2-.cn.jj.service.msg.protocol.MahJongRequestAckU
mahjongdiscardtile_ack_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileAckO
mahjongdrawtile_ack_msg (2..cn.jj.service.msg.protocol.MahJongDrawTileAckG
mahjongcall_ack_msg (2*.cn.jj.service.msg.protocol.MahJongCallAckG
mahjongpeng_ack_msg (2*.cn.jj.service.msg.protocol.MahJongPengAckJ
mahjonggang_ack_msg (2-.cn.jj.service.msg.protocol.MahJongSCNGangAckH
mahjongwin_ack_msg (2,.cn.jj.service.msg.protocol.MahJongSCNWinAckU
mahjongwindetailex_ack_msg (21.cn.jj.service.msg.protocol.MahJongWinDetailExAckK
mahjongnotify_ack_msg (2,.cn.jj.service.msg.protocol.MahJongNotifyAckQ
mahjongtrustplay_ack_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayAckU
mahjongscorechange_ack_msg (21.cn.jj.service.msg.protocol.MahJongScoreChangeAckP
mahjongbrresult_ack_msg (2/.cn.jj.service.msg.protocol.MahJongSCNResultAckT
mahjongbrwindrain_ack_msg (21.cn.jj.service.msg.protocol.MahJongSCNWindRainAckR
mahjongexchange_ack_msg (21.cn.jj.service.msg.protocol.MahJongSCNExchangeAck[
mahjongscnexchangeend_ack_msg (24.cn.jj.service.msg.protocol.MahJongSCNExchangeEndAckk
%mahjongscnackfixmissingresult_ack_msg (2<.cn.jj.service.msg.protocol.MahJongSCNAckFixMissingResultAck"y
MahJongSCNGangReq
seat (
	requestid (
tileid (
gangtype (
bugen (

gangtileid ("+
MahJongSCNGameBeginAck
	scoreBase ("y
MahJongSCNGangAck
seat (
	requestid (
tileid (
gangtype (
bugen (

gangtileid ("å
MahJongSCNWinAck
winseats (
winseatcount (
paoseat (
	wintileid (
winmode (
	anFanType (
anRoot (
	anWRScore (
anScoreChange	 (

anCallturn
 (:
	windetail (2'.cn.jj.service.msg.protocol.WinDetailEx"=
SCNCheckResult
seat (
type (
anScore ("ñ
MahJongSCNResultAck
	cnWinInfo (@
asPlayerResult (2(.cn.jj.service.msg.protocol.PlayerResult
time (
anRank (
anCheckTileID (
	anhuScore (
anWindRainScore (D
anCheckCallScore (2*.cn.jj.service.msg.protocol.SCNCheckResult
	anWinMode	 (
	anFanType
 (
anRoot (
	anService (:
	windetail (2'.cn.jj.service.msg.protocol.WinDetailEx"3
MahJongSCNWindRainAck
mode (
seat ("T
MahJongSCNExchangeSelectReq
seat (
	requestID (
exchangeTile ("L
MahJongSCNExchangeAck
seat (
exchangeTile (
oldTile ("(
MahJongSCNExchangeEndReq
seat ("
MahJongSCNExchangeEndAck"L
MahJongSCNAckFixMissingReq
seat (
color (
	requestID ("1
 MahJongSCNAckFixMissingResultAck
color ("(
MahJongSCNCastDiceEndReq
seat ("@
MahJongSCNAnimationEndReq
seat (
animationType (
ë'
TKMahJongTDH.protocn.jj.service.msg.protocolTKMahJong.proto"∂
MahJongTDHReqMsg
matchid (W
mahjongopendoorover_req_msg (22.cn.jj.service.msg.protocol.MahJongOpenDoorOverReqL
mahjongrequst_req_msg (2-.cn.jj.service.msg.protocol.MahJongRequestReqW
mahjongchangeflower_req_msg (22.cn.jj.service.msg.protocol.MahJongChangeFlowerReqU
mahjongdiscardtile_req_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileReqG
mahjongcall_req_msg (2*.cn.jj.service.msg.protocol.MahJongCallReqE
mahjongchi_req_msg (2).cn.jj.service.msg.protocol.MahJongChiReqG
mahjongpeng_req_msg (2*.cn.jj.service.msg.protocol.MahJongPengReqG
mahjonggang_req_msg	 (2*.cn.jj.service.msg.protocol.MahJongGangReqE
mahjongwin_req_msg
 (2).cn.jj.service.msg.protocol.MahJongWinReqQ
mahjongtrustplay_req_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayReq"Ó
MahJongTDHAckMsg
matchid (Q
mahjonggamebegin_ack_msg (2/.cn.jj.service.msg.protocol.MahJongGameBeginAckO
mahjongruleinfo_ack_msg (2..cn.jj.service.msg.protocol.MahJongRuleInfoAckI
mahjongplace_ack_msg (2+.cn.jj.service.msg.protocol.MahJongPlaceAckQ
mahjongwindplace_ack_msg (2/.cn.jj.service.msg.protocol.MahJongWindPlaceAckN
mahjongresult_ack_msg (2/.cn.jj.service.msg.protocol.MahJongTDHResultAckM
mahjongshuffle_ack_msg (2-.cn.jj.service.msg.protocol.MahJongShuffleAckO
mahjongcastdice_ack_msg (2..cn.jj.service.msg.protocol.MahJongCastDiceAckO
mahjongopendoor_ack_msg	 (2..cn.jj.service.msg.protocol.MahJongOpenDoorAckE
mahjonghun_ack_msg
 (2).cn.jj.service.msg.protocol.MahJongHunAckN
mahjongaction_ack_msg (2/.cn.jj.service.msg.protocol.MahJongTDHActionAckM
mahjongrequest_ack_msg (2-.cn.jj.service.msg.protocol.MahJongRequestAckW
mahjongchangeflower_ack_msg (22.cn.jj.service.msg.protocol.MahJongChangeFlowerAckU
mahjongdiscardtile_ack_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileAckO
mahjongdrawtile_ack_msg (2..cn.jj.service.msg.protocol.MahJongDrawTileAckG
mahjongcall_ack_msg (2*.cn.jj.service.msg.protocol.MahJongCallAckE
mahjongchi_ack_msg (2).cn.jj.service.msg.protocol.MahJongChiAckG
mahjongpeng_ack_msg (2*.cn.jj.service.msg.protocol.MahJongPengAckG
mahjonggang_ack_msg (2*.cn.jj.service.msg.protocol.MahJongGangAckE
mahjongwin_ack_msg (2).cn.jj.service.msg.protocol.MahJongWinAckT
mahjongwindetail_ack_msg (22.cn.jj.service.msg.protocol.MahJongTDHWinDetailAckX
mahjongwindetailex_ack_msg (24.cn.jj.service.msg.protocol.MahJongTDHWinDetailExAckK
mahjongnotify_ack_msg (2,.cn.jj.service.msg.protocol.MahJongNotifyAckQ
mahjongtrustplay_ack_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayAckU
mahjongscorechange_ack_msg (21.cn.jj.service.msg.protocol.MahJongScoreChangeAckO
mahjongtdhmaima_ack_msg (2..cn.jj.service.msg.protocol.MahJongTDHMaiMaAck"â

WinInfoTDH
maxfans (
fans (
	resultant (6
groups (2&.cn.jj.service.msg.protocol.StoneGroup4
	handstone (2!.cn.jj.service.msg.protocol.Stone

groupcount (
	wintileid (2
flowers (2!.cn.jj.service.msg.protocol.Stone
flowercount	 (
quanwind
 (
menwind (

showgroups (
winmode (

scoreoffan (
zhongma ("Ø
WinInfoTDHEx
maxfans (0
fanlist (2.cn.jj.service.msg.protocol.Fan
	resultant (6
groups (2&.cn.jj.service.msg.protocol.StoneGroup4
	handstone (2!.cn.jj.service.msg.protocol.Stone

groupcount (
	wintileid (2
flowers (2!.cn.jj.service.msg.protocol.Stone
flowercount	 (
quanwind
 (
menwind (

showgroups (
winmode (

scoreoffan (
zhongma ("ﬁ
WinDetailTDHEx
winseat (
paoseat (
wintile (7
wininfo (2&.cn.jj.service.msg.protocol.WinInfoTDH
	basescore (?
scoredetails (2).cn.jj.service.msg.protocol.ScoreDetailEx
time ("¥
MahJongTDHResultAck
wininfo (?
playerresults (2(.cn.jj.service.msg.protocol.PlayerResult
time (=
	windetail (2*.cn.jj.service.msg.protocol.WinDetailTDHEx"‰
MahJongTDHWinDetailAck
winseat (
paoseat (
wintile (7
wininfo (2&.cn.jj.service.msg.protocol.WinInfoTDH
	basescore (=
scoredetails (2'.cn.jj.service.msg.protocol.ScoreDetail
time ("Í
MahJongTDHWinDetailExAck
winseat (
paoseat (
wintile (9
wininfo (2(.cn.jj.service.msg.protocol.WinInfoTDHEx
	basescore (?
scoredetails (2).cn.jj.service.msg.protocol.ScoreDetailEx
time ("

PlayerTile
tile ("È
MahJongTDHMaiMaAck
seat (
	maimatile (
fromwallheader (

tileoffset (
	maimatype (
zhongma (

showmatype (
	tilecount (;
playertiles	 (2&.cn.jj.service.msg.protocol.PlayerTile"r
MahJongTDHActionAck
seat (
	requestid (
requesttype (

waitsecond (
	qianggang (
Æ#
TKMahJongTP.protocn.jj.service.msg.protocolTKMahJong.proto"Ñ
MahJongTPReqMsg
matchid (W
mahjongopendoorover_req_msg (22.cn.jj.service.msg.protocol.MahJongOpenDoorOverReqL
mahjongrequst_req_msg (2-.cn.jj.service.msg.protocol.MahJongRequestReqW
mahjongchangeflower_req_msg (22.cn.jj.service.msg.protocol.MahJongChangeFlowerReqU
mahjongdiscardtile_req_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileReqG
mahjongcall_req_msg (2*.cn.jj.service.msg.protocol.MahJongCallReqE
mahjongchi_req_msg (2).cn.jj.service.msg.protocol.MahJongChiReqG
mahjongpeng_req_msg (2*.cn.jj.service.msg.protocol.MahJongPengReqG
mahjonggang_req_msg	 (2*.cn.jj.service.msg.protocol.MahJongGangReqE
mahjongwin_req_msg
 (2).cn.jj.service.msg.protocol.MahJongWinReqQ
mahjongtrustplay_req_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayReqM
mahjongdouble_req_msg (2..cn.jj.service.msg.protocol.MahJongDoubleTPReq"ü
MahJongTPAckMsg
matchid (Q
mahjonggamebegin_ack_msg (2/.cn.jj.service.msg.protocol.MahJongGameBeginAckO
mahjongruleinfo_ack_msg (2..cn.jj.service.msg.protocol.MahJongRuleInfoAckI
mahjongplace_ack_msg (2+.cn.jj.service.msg.protocol.MahJongPlaceAckQ
mahjongwindplace_ack_msg (2/.cn.jj.service.msg.protocol.MahJongWindPlaceAckM
mahjongresult_ack_msg (2..cn.jj.service.msg.protocol.MahJongResultTPAckM
mahjongshuffle_ack_msg (2-.cn.jj.service.msg.protocol.MahJongShuffleAckO
mahjongcastdice_ack_msg (2..cn.jj.service.msg.protocol.MahJongCastDiceAckO
mahjongopendoor_ack_msg	 (2..cn.jj.service.msg.protocol.MahJongOpenDoorAckE
mahjonghun_ack_msg
 (2).cn.jj.service.msg.protocol.MahJongHunAckK
mahjongaction_ack_msg (2,.cn.jj.service.msg.protocol.MahJongActionAckM
mahjongrequest_ack_msg (2-.cn.jj.service.msg.protocol.MahJongRequestAckW
mahjongchangeflower_ack_msg (22.cn.jj.service.msg.protocol.MahJongChangeFlowerAckU
mahjongdiscardtile_ack_msg (21.cn.jj.service.msg.protocol.MahJongDiscardTileAckO
mahjongdrawtile_ack_msg (2..cn.jj.service.msg.protocol.MahJongDrawTileAckG
mahjongcall_ack_msg (2*.cn.jj.service.msg.protocol.MahJongCallAckE
mahjongchi_ack_msg (2).cn.jj.service.msg.protocol.MahJongChiAckG
mahjongpeng_ack_msg (2*.cn.jj.service.msg.protocol.MahJongPengAckG
mahjonggang_ack_msg (2*.cn.jj.service.msg.protocol.MahJongGangAckG
mahjongwin_ack_msg (2+.cn.jj.service.msg.protocol.MahJongWinTPAckQ
mahjongwindetail_ack_msg (2/.cn.jj.service.msg.protocol.MahJongWinDetailAckW
mahjongwindetailex_ack_msg (23.cn.jj.service.msg.protocol.MahJongWinDetailExTPAckK
mahjongnotify_ack_msg (2,.cn.jj.service.msg.protocol.MahJongNotifyAckQ
mahjongtrustplay_ack_msg (2/.cn.jj.service.msg.protocol.MahJongTrustPlayAckU
mahjongscorechange_ack_msg (21.cn.jj.service.msg.protocol.MahJongScoreChangeAckW
mahjongplayertiles_ack_msg (23.cn.jj.service.msg.protocol.MahJongPlayerTilesTPAckM
mahjongdouble_ack_msg (2..cn.jj.service.msg.protocol.MahJongDoubleTPAck_
mahjongplayershowtiles_ack_msg (27.cn.jj.service.msg.protocol.MahJongPlayerShowTilesTPAck"ò
PlayerResultTP
win (
pao (
gang (
score (
	windouble (

totalscore (
handtilecount (
	handtiles ("Ì
WinDetailExTP
winseat (
	windouble (
paoseat (
wintile (4
wininfo (2#.cn.jj.service.msg.protocol.WinInfo
	basescore (?
scoredetails (2).cn.jj.service.msg.protocol.ScoreDetailEx
time ("¥
MahJongResultTPAck
wininfo (A
playerresults (2*.cn.jj.service.msg.protocol.PlayerResultTP
time (<
	windetail (2).cn.jj.service.msg.protocol.WinDetailExTP"Q
MahJongPlayerTilesTPAck
seat (
handtilecount (
	handtiles ("ô
MahJongDoubleTPReq
seat (
	requestid (
isdouble (

doubletype (<
	doublemsg (2).cn.jj.service.msg.protocol.MahJongWinReq"A
MahJongDoubleTPAck
seat (
count (
tileid ("Å
MahJongWinTPAck
winseats (
winseatcount (
paoseat (
	wintileid (
winmode (
	windouble ("˜
MahJongWinDetailExTPAck
winseat (
paoseat (
wintile (4
wininfo (2#.cn.jj.service.msg.protocol.WinInfo
	basescore (?
scoredetails (2).cn.jj.service.msg.protocol.ScoreDetailEx
time (
	windouble ("Q
MahJongPlayerShowTilesTPAck
seat (
	showcount (
	showtiles (
Ÿ\
TKMatch.protocn.jj.service.msg.protocol"Á
MatchReqMsg
matchid (E
entermatch_req_msg (2).cn.jj.service.msg.protocol.EnterMatchReqE
enterround_req_msg (2).cn.jj.service.msg.protocol.EnterRoundReqA
exitgame_req_msg (2'.cn.jj.service.msg.protocol.ExitGameReqe
"pushuserplaceorderposition_req_msg (29.cn.jj.service.msg.protocol.PushUserPlaceOrderPositionReqW
getstageplayerorder_req_msg (22.cn.jj.service.msg.protocol.GetStagePlayerOrderReqA
continue_req_msg (2'.cn.jj.service.msg.protocol.ContinueReq;
leave_req_msg	 (2$.cn.jj.service.msg.protocol.LeaveReqC
hematinic_req_msg
 (2(.cn.jj.service.msg.protocol.HematinicReqI
playerrelive_req_msg (2+.cn.jj.service.msg.protocol.PlayerReliveReqI
registerauto_req_msg (2+.cn.jj.service.msg.protocol.RegisterAutoReqK
playersitdown_req_msg (2,.cn.jj.service.msg.protocol.PlayerSitDownReq;
addhp_req_msg (2$.cn.jj.service.msg.protocol.AddHPReqM
markplayeridle_req_msg (2-.cn.jj.service.msg.protocol.MarkPlayerIdleReqK
markautoaddhp_req_msg (2,.cn.jj.service.msg.protocol.MarkAutoAddHPReq[
startableacceptinvite_req_msg (24.cn.jj.service.msg.protocol.StartableAcceptInviteReqC
exitmatch_req_msg (2(.cn.jj.service.msg.protocol.ExitMatchReqO
stageboutresult_req_msg (2..cn.jj.service.msg.protocol.StageBoutResultReqQ
gamesimpleaction_req_msg (2/.cn.jj.service.msg.protocol.GameSimpleActionReqW
getroundplayerorder_req_msg (22.cn.jj.service.msg.protocol.GetRoundPlayerOrderReqA
lockdown_req_msg (2'.cn.jj.service.msg.protocol.LockDownReqS
playerchangetable_req_msg (20.cn.jj.service.msg.protocol.PlayerChangeTableReq"Ó 
MatchAckMsg
matchid (E
entermatch_ack_msg (2).cn.jj.service.msg.protocol.EnterMatchAckE
enterround_ack_msg (2).cn.jj.service.msg.protocol.EnterRoundAckA
exitgame_ack_msg (2'.cn.jj.service.msg.protocol.ExitGameAcke
"pushuserplaceorderposition_ack_msg (29.cn.jj.service.msg.protocol.PushUserPlaceOrderPositionAckA
continue_ack_msg (2'.cn.jj.service.msg.protocol.ContinueAck;
leave_ack_msg	 (2$.cn.jj.service.msg.protocol.LeaveAckC
hematinic_ack_msg
 (2(.cn.jj.service.msg.protocol.HematinicAckI
playerrelive_ack_msg (2+.cn.jj.service.msg.protocol.PlayerReliveAckI
registerauto_ack_msg (2+.cn.jj.service.msg.protocol.RegisterAutoAckK
playersitdown_ack_msg (2,.cn.jj.service.msg.protocol.PlayerSitDownAck;
addhp_ack_msg (2$.cn.jj.service.msg.protocol.AddHPAckM
markplayeridle_ack_msg (2-.cn.jj.service.msg.protocol.MarkPlayerIdleAckK
markautoaddhp_ack_msg (2,.cn.jj.service.msg.protocol.MarkAutoAddHPAck[
startableacceptinvite_ack_msg (24.cn.jj.service.msg.protocol.StartableAcceptInviteAck=
tipmsg_ack_msg (2%.cn.jj.service.msg.protocol.TipMsgAck]
pushmatchstageposition_ack_msg (25.cn.jj.service.msg.protocol.PushMatchStagePositionAckQ
stageplayerorder_ack_msg (2/.cn.jj.service.msg.protocol.StagePlayerOrderAckQ
roundplayerorder_ack_msg (2/.cn.jj.service.msg.protocol.RoundPlayerOrderAckW
pushmatchplayerinfo_ack_msg (22.cn.jj.service.msg.protocol.PushMatchPlayerInfoAckS
addgameplayerinfo_ack_msg (20.cn.jj.service.msg.protocol.AddGamePlayerInfoAckU
pushroundrulerinfo_ack_msg (21.cn.jj.service.msg.protocol.PushRoundRulerInfoAckC
beginhand_ack_msg (2(.cn.jj.service.msg.protocol.BeginHandAckC
rulerinfo_ack_msg (2(.cn.jj.service.msg.protocol.RulerInfoAck_
stageplayerorderchanged_ack_msg (26.cn.jj.service.msg.protocol.StagePlayerOrderChangedAckO
noqueryexitgame_ack_msg (2..cn.jj.service.msg.protocol.NoQueryExitGameAckM
pushmatchaward_ack_msg (2-.cn.jj.service.msg.protocol.PushMatchAwardAckM
scorebaseraise_ack_msg (2-.cn.jj.service.msg.protocol.ScoreBaseRaiseAckW
changegamerulernote_ack_msg (22.cn.jj.service.msg.protocol.ChangeGameRulerNoteAck9
rest_ack_msg  (2#.cn.jj.service.msg.protocol.RestAckE
relivecost_ack_msg" (2).cn.jj.service.msg.protocol.ReliveCostAck]
pushgamecountawardinfo_ack_msg# (25.cn.jj.service.msg.protocol.PushGameCountAwardInfoAckU
pushplayergamedata_ack_msg$ (21.cn.jj.service.msg.protocol.PushPlayerGameDataAckW
notifyguestregister_ack_msg% (22.cn.jj.service.msg.protocol.NotifyGuestRegisterAckA
netbreak_ack_msg& (2'.cn.jj.service.msg.protocol.NetBreakAckC
netresume_ack_msg' (2(.cn.jj.service.msg.protocol.NetResumeAckO
historymsgbegin_ack_msg( (2..cn.jj.service.msg.protocol.HistoryMsgBeginAckK
historymsgend_ack_msg) (2,.cn.jj.service.msg.protocol.HistoryMsgEndAckA
handover_ack_msg* (2'.cn.jj.service.msg.protocol.HandOverAckA
overgame_ack_msg+ (2'.cn.jj.service.msg.protocol.OverGameAckK
initgametable_ack_msg, (2,.cn.jj.service.msg.protocol.InitGameTableAck?
vipmode_ack_msg- (2&.cn.jj.service.msg.protocol.VIPModeAckO
stageboutresult_ack_msg. (2..cn.jj.service.msg.protocol.StageBoutResultAckQ
gamesimpleaction_ack_msg/ (2/.cn.jj.service.msg.protocol.GameSimpleActionAckO
gamecvawardinfo_ack_msg0 (2..cn.jj.service.msg.protocol.GameCVAwardInfoAckG
gamecvaward_ack_msg1 (2*.cn.jj.service.msg.protocol.GameCVAwardAckA
lockdown_ack_msg2 (2'.cn.jj.service.msg.protocol.LockDownAckI
marklockdown_ack_msg3 (2+.cn.jj.service.msg.protocol.MarkLockDownAckG
rulerinfoex_ack_msg4 (2*.cn.jj.service.msg.protocol.RulerInfoExAckG
gamejackpot_ack_msg5 (2*.cn.jj.service.msg.protocol.GameJackPotAckQ
gamejackpotcount_ack_msg6 (2/.cn.jj.service.msg.protocol.GameJackPotCountAckS
gamejackpotwinner_ack_msg7 (20.cn.jj.service.msg.protocol.GameJackPotWinnerAckS
gameplayerarrived_ack_msg8 (20.cn.jj.service.msg.protocol.GamePlayerArrivedAckM
exchangeisland_ack_msg9 (2-.cn.jj.service.msg.protocol.ExchangeislandAckG
matchoption_ack_msg: (2*.cn.jj.service.msg.protocol.MatchOptionAck"^
EnterMatchReq
matchclientver (
ticket (
gameclientver (
gameid ("Î
EnterMatchAck
	tourneyid (
matchid (
	matchname (	
userid (
nickname (	
figureid (
	matchrank (
totalmatchplayer (
matchstarttime	 (
matchelapsesec
 (

titlestyle ("@
EnterRoundReq
version (
ticket (
gameid ("D
EnterRoundAck
userid (
	seatorder (
usertype (" 
ExitGameReq
	nullvalue (" 
ExitGameAck
	nullvalue ("2
PushUserPlaceOrderPositionReq
	nullvalue ("V
PushUserPlaceOrderPositionAck
playercurplaceorder (
totalplayercount ("+
GetStagePlayerOrderReq
	nullvalue ("(
GetRoundPlayerOrderReq
userid ("
ContinueReq
userid ("
ContinueAck
userid ("
LeaveReq
userid ("
LeaveAck
userid ("1
HematinicReq
userid (
	hematinic ("1
HematinicAck
userid (
	hematinic ("1
PlayerReliveReq
userid (
relive ("!
PlayerReliveAck
userid ("°
RegisterAutoReq
	partnerid (
agent (
	agentmark (	
	bregister (
nickname (	
username (	
password (	
figureid ("|
RegisterAutoAck
userid (
nickname (	
username (	
password (	
figureid (
	bankaccid ("S
SeatPlayerInfo
userid (
nickname (	
figureid (
ready (" 
PlayerSitDownReq
seat ("`
PlayerSitDownAck>

playerinfo (2*.cn.jj.service.msg.protocol.SeatPlayerInfo
seat ("
AddHPReq

hp ("9
AddHPAck
userid (
hpadded (
cost ("!
MarkPlayerIdleReq
idle ("!
MarkPlayerIdleAck
idle ("%
MarkAutoAddHPReq
	autoaddhp ("%
MarkAutoAddHPAck
	autoaddhp (",
StartableAcceptInviteReq
accepted (",
StartableAcceptInviteAck
accepted ("I
	TipMsgAck
type (
second (
nextoper (
text (	"x
PushMatchStagePositionAck
stageid (
boutid (
stageboutname (	
	stagename (	
boutname (	"q
GamePlayerOrderInfo
userid (
nickname (	
score (

placeorder (
outroundstate ("£
StagePlayerOrderAck
serial (
flags (
	scoretype (
minwinnerorder (B
	orderlist (2/.cn.jj.service.msg.protocol.GamePlayerOrderInfo"x
RoundPlayerOrderAck
serial (
flags (B
	orderlist (2/.cn.jj.service.msg.protocol.GamePlayerOrderInfo",
PushMatchPlayerInfoAck

playerinfo (	"ù
GamePlayerInfo
	seatorder (
userid (
nickname (	
figureid (
	matchrank (
score (
arrived (
	netstatus ("V
AddGamePlayerInfoAck>

playerinfo (2*.cn.jj.service.msg.protocol.GamePlayerInfo"*
PushRoundRulerInfoAck
	rulerinfo (	">
BeginHandAck
gamehand (
round (
table ("◊
RulerInfoAck
gametotalplayer (
tablenumber (
	scoretype (
	scorebase (
roundrulername (	
reserve (
property (	
	titlename (	
	rulernote	 (	

roundruler
 ("Q
StagePlayerOrderChangedAck
serial (
flags (
updatesecond ("-
NoQueryExitGameAck
noqueryexitgame ("&
PushMatchAwardAck
	awardtext (	")
ScoreBaseRaiseAck
newscorebase ("+
ChangeGameRulerNoteAck
	rulernote (	"(
	Hematinic
blood (
cost ("™
RestAck
resttime (
hematiniccount (<
hematiniclist (2%.cn.jj.service.msg.protocol.Hematinic
life (
coin (

gamescount (
multi (
nextlevelgames (
nextlevelmulti	 (
exchangerate
 (
awardtimespan (
nextawardleftsecond ("Q
ExchangeislandAck<
hematiniclist (2%.cn.jj.service.msg.protocol.Hematinic"k
WareReliveAck
wareid (
	warecount (
score (
liveplayercount (
timeout ("z
ReliveCostAck
costtype (
costid (
amount (
score (
liveplayercount (
timeout (")
PushGameCountAwardInfoAck
text (	"¢
PushPlayerGameDataAck
userid (
exchangerate (
leftchip (
curgamehand (
totalfinishedgamecount (
curfinishedgamecount ("=
NotifyGuestRegisterAck
order (
autoregister ("0
NetBreakAck
userid (
	seatorder ("1
NetResumeAck
userid (
	seatorder ("'
HistoryMsgBeginAck
	nullvalue ("%
HistoryMsgEndAck
	nullvalue (" 
HandOverAck
	nullvalue (" 
OverGameAck
	nullvalue ("ø
InitGameTableAckB
playerinfolist (2*.cn.jj.service.msg.protocol.SeatPlayerInfo
	chatsvrip (
chatsvrport (
chatchannelid (

maxaddtohp (

minaddtohp (
exchangerate (
hpmode (
chatchannelsubid	 (
chatchanneltype
 (
chatusertype (
	tabledata ("

VIPModeAck
vipmode ("]
ExitMatchReq
matchclientver (
ticket (
gameclientver (
gameid ("7
StageBoutResultReq
	nullvalue (
userid ("*
	OrderInfo
userid (
order ("\
StageBoutResultAck
text (	8
	orderinfo (2%.cn.jj.service.msg.protocol.OrderInfo"Ç
GameSimpleActionReq

useridfrom (
useridto (
	emotionid (
textid (
reserve1 (
reserve2 ("Ç
GameSimpleActionAck

useridfrom (
useridto (
	emotionid (
textid (
reserve1 (
reserve2 ("+
LockDownReq
seat (
unlock ("
LockDownAck
allow ("'
GameCVAwardInfoAck
	awardinfo (	"
GameCVAwardAck
win ("$
MarkLockDownAck
	nullvalue ("$
RulerInfoExAck

propertyex (	";
GameJackPotAck
jackpotcount (
jackpotinfo (	"+
GameJackPotCountAck
jackpotcount ("9
GameJackPotWinnerAck
winnercount (
desc (	"9
GamePlayerArrivedAck
userid (
	seatorder ("
MatchOptionAck
flags ("
PlayerChangeTableReq
∂

TKMatchInfo.protocn.jj.service.msg.protocol"Ò
MatchInfoReqMsgI
gettablelist_req_msg (2+.cn.jj.service.msg.protocol.GetTableListReqH
getplayer_req_msg (2-.cn.jj.service.msg.protocol.GetTablePlayerReqI
getsigncount_req_msg (2+.cn.jj.service.msg.protocol.GetSignCountReq"Ò
MatchInfoAckMsgI
gettablelist_ack_msg (2+.cn.jj.service.msg.protocol.GetTableListAckH
getplayer_ack_msg (2-.cn.jj.service.msg.protocol.GetTablePlayerAckI
getsigncount_ack_msg (2+.cn.jj.service.msg.protocol.GetSignCountAck"´
	TableData
tableid (
matchid (
signupamount (
	maxamount (
state (
type (
	tablename (	
	tablenote (	
joingold	 ("B
TablePlayerData
userid (
nickname (	
score ("N
GetTableListReq
	tourneyid (
begintableid (

tablecount ("u
GetTableListAck
	tourneyid (
alltablecount (8
	tabledata (2%.cn.jj.service.msg.protocol.TableData"7
GetTablePlayerReq
	tourneyid (
tableid ("}
GetTablePlayerAck
	tourneyid (
tableid (D
tableplayerdata (2+.cn.jj.service.msg.protocol.TablePlayerData"$
GetSignCountReq
	tourneyid ("Ö
GetSignCountAck
	tourneyid (

matchpoint (
signupplayer (
matchcreateinterval (
matchplayercount (
Ó
TKMatchView.protocn.jj.service.msg.protocol""
MatchViewReqMsg
matchid ("∆
MatchViewAckMsg
matchid (O
matchupdateview_ack_msg (2..cn.jj.service.msg.protocol.MatchUpdateViewAckQ
matchservicetime_ack_msg (2/.cn.jj.service.msg.protocol.MatchServiceTimeAck"A
	Attribute
attrtype (
	attrvalue (
attrstr (	"a
MatchUpdateViewAck
infotype (9

attributes (2%.cn.jj.service.msg.protocol.Attribute"*
MatchServiceTimeAck
servicetime (
é!
TKMobile.protocn.jj.service.msg.protocolTKLobby.protoTKMatch.protoTKLord.protoTKTourney.protoTKMobileAgent.protoTKSMS.protoTKPoker.protoTKHttp.protoTKConfig.protoTKMatchInfo.protoTKMahJong.protoTKMahJongTP.protoTKECAService.protoTKHLLord.protoTKMatchView.protoTKPKLord.protoTKHbase.protoTKThreeCard.protoTKLZLord.protoTKLine.protoTKMahJongTDH.protoTKDouniu.protoTKMahJongBR.protoTKMahJongSCN.protoTKInterim.protoTKRunFast.protoTKMahJongDZ.proto"…
TKMobileReqMsg
param (>
lobby_req_msg (2'.cn.jj.service.msg.protocol.LobbyReqMsg>
match_req_msg (2'.cn.jj.service.msg.protocol.MatchReqMsg<
lord_req_msg (2&.cn.jj.service.msg.protocol.LordReqMsg>
poker_req_msg (2'.cn.jj.service.msg.protocol.PokerReqMsgB
tourney_req_msg (2).cn.jj.service.msg.protocol.TourneyReqMsgJ
mobileagent_req_msg (2-.cn.jj.service.msg.protocol.MobileAgentReqMsg:
sms_req_msg (2%.cn.jj.service.msg.protocol.SMSReqMsg<
http_req_msg	 (2&.cn.jj.service.msg.protocol.HttpReqMsg@
config_req_msg
 (2(.cn.jj.service.msg.protocol.ConfigReqMsgF
matchinfo_req_msg (2+.cn.jj.service.msg.protocol.MatchInfoReqMsgB
mahjong_req_msg (2).cn.jj.service.msg.protocol.MahJongReqMsgF
mahjongtp_req_msg (2+.cn.jj.service.msg.protocol.MahJongTPReqMsgH
ecaservice_req_msg (2,.cn.jj.service.msg.protocol.ECAServiceReqMsg@
hllord_req_msg (2(.cn.jj.service.msg.protocol.HLLordReqMsgF
matchview_req_msg (2+.cn.jj.service.msg.protocol.MatchViewReqMsg@
pklord_req_msg (2(.cn.jj.service.msg.protocol.PKLordReqMsg>
hbase_req_msg (2'.cn.jj.service.msg.protocol.HbaseReqMsgF
threecard_req_msg (2+.cn.jj.service.msg.protocol.ThreeCardReqMsg@
lzlord_req_msg (2(.cn.jj.service.msg.protocol.LZLordReqMsg<
line_req_msg (2&.cn.jj.service.msg.protocol.LineReqMsgH
mahjongtdh_req_msg (2,.cn.jj.service.msg.protocol.MahJongTDHReqMsg@
douniu_req_msg (2(.cn.jj.service.msg.protocol.DouniuReqMsgF
mahjongbr_req_msg (2+.cn.jj.service.msg.protocol.MahJongBRReqMsgH
mahjongscn_req_msg (2,.cn.jj.service.msg.protocol.MahJongSCNReqMsgB
interim_req_msg (2).cn.jj.service.msg.protocol.InterimReqMsgB
runfast_req_msg (2).cn.jj.service.msg.protocol.RunFastReqMsgF
mahjongdz_req_msg (2+.cn.jj.service.msg.protocol.MahJongDZReqMsg"…
TKMobileAckMsg
param (>
lobby_ack_msg (2'.cn.jj.service.msg.protocol.LobbyAckMsg>
match_ack_msg (2'.cn.jj.service.msg.protocol.MatchAckMsg<
lord_ack_msg (2&.cn.jj.service.msg.protocol.LordAckMsg>
poker_ack_msg (2'.cn.jj.service.msg.protocol.PokerAckMsgB
tourney_ack_msg (2).cn.jj.service.msg.protocol.TourneyAckMsgJ
mobileagent_ack_msg (2-.cn.jj.service.msg.protocol.MobileAgentAckMsg:
sms_ack_msg (2%.cn.jj.service.msg.protocol.SMSAckMsg<
http_ack_msg	 (2&.cn.jj.service.msg.protocol.HttpAckMsg@
config_ack_msg
 (2(.cn.jj.service.msg.protocol.ConfigAckMsgF
matchinfo_ack_msg (2+.cn.jj.service.msg.protocol.MatchInfoAckMsgB
mahjong_ack_msg (2).cn.jj.service.msg.protocol.MahJongAckMsgF
mahjongtp_ack_msg (2+.cn.jj.service.msg.protocol.MahJongTPAckMsgH
ecaservice_ack_msg (2,.cn.jj.service.msg.protocol.ECAServiceAckMsg@
hllord_ack_msg (2(.cn.jj.service.msg.protocol.HLLordAckMsgF
matchview_ack_msg (2+.cn.jj.service.msg.protocol.MatchViewAckMsg@
pklord_ack_msg (2(.cn.jj.service.msg.protocol.PKLordAckMsg>
hbase_ack_msg (2'.cn.jj.service.msg.protocol.HbaseAckMsgF
threecard_ack_msg (2+.cn.jj.service.msg.protocol.ThreeCardAckMsg@
lzlord_ack_msg (2(.cn.jj.service.msg.protocol.LZLordAckMsg<
line_ack_msg (2&.cn.jj.service.msg.protocol.LineAckMsgH
mahjongtdh_ack_msg (2,.cn.jj.service.msg.protocol.MahJongTDHAckMsg@
douniu_ack_msg (2(.cn.jj.service.msg.protocol.DouniuAckMsgF
mahjongbr_ack_msg (2+.cn.jj.service.msg.protocol.MahJongBRAckMsgH
mahjongscn_ack_msg (2,.cn.jj.service.msg.protocol.MahJongSCNAckMsgB
interim_ack_msg (2).cn.jj.service.msg.protocol.InterimAckMsgB
runfast_ack_msg (2).cn.jj.service.msg.protocol.RunFastAckMsgF
mahjongdz_ack_msg (2+.cn.jj.service.msg.protocol.MahJongDZAckMsg
Û
TKMobileAgent.protocn.jj.service.msg.protocol"X
MobileAgentReqMsgC
phoneinfo_req_msg (2(.cn.jj.service.msg.protocol.PhoneInfoReq"&
MobileAgentAckMsg
	nullvalue ("Ω
PhoneInfoReq
imei (	
promoter (	
appver (	
sysver (	
model (	
gameid (	
platform (	
type (	
carrier	 (	
nettype
 (	
imsi (	
ù'
TKPKLord.protocn.jj.service.msg.protocol"ù
PKLordReqMsg
matchid (
time (W
pkldispatchcomplete_req_msg (22.cn.jj.service.msg.protocol.PKLDispatchCompleteReqG
pklcalllord_req_msg (2*.cn.jj.service.msg.protocol.PKLCallLordReqE
pklroblord_req_msg (2).cn.jj.service.msg.protocol.PKLRobLordReq]
pkldeclarelordcomplete_req_msg (25.cn.jj.service.msg.protocol.PKLDeclareLordCompleteReqQ
pklgiveupleadput_req_msg (2/.cn.jj.service.msg.protocol.PKLGiveUpLeadPutReqG
pklputcards_req_msg (2*.cn.jj.service.msg.protocol.PKLPutCardsReqC
pklgiveup_req_msg	 (2(.cn.jj.service.msg.protocol.PKLGiveUpReqE
pkltrustin_req_msg
 (2).cn.jj.service.msg.protocol.PKLTrustInReq"±
PKLordAckMsg
matchid (
time (I
pklstartgame_ack_msg (2+.cn.jj.service.msg.protocol.PKLStartGameAckU
pklupdatethinktime_ack_msg (21.cn.jj.service.msg.protocol.PKLUpdateThinkTimeAckP
pkldispatchcard_ack_msg (2/.cn.jj.service.msg.protocol.PKLDispatchCardsAcka
 pkldispatchstagefinished_ack_msg (27.cn.jj.service.msg.protocol.PKLDispatchStageFinishedAckI
pklhandcards_ack_msg (2+.cn.jj.service.msg.protocol.PKLHandCardsAckQ
pklstartcalllord_ack_msg (2/.cn.jj.service.msg.protocol.PKLStartCallLordAckG
pklcalllord_ack_msg	 (2*.cn.jj.service.msg.protocol.PKLCallLordAckM
pklwaitroblord_ack_msg
 (2-.cn.jj.service.msg.protocol.PKLWaitRobLordAckE
pklroblord_ack_msg (2).cn.jj.service.msg.protocol.PKLRobLordAckM
pkldeclarelord_ack_msg (2-.cn.jj.service.msg.protocol.PKLDeclareLordAck[
pklstartgiveupleadput_ack_msg (24.cn.jj.service.msg.protocol.PKLStartGiveUpLeadPutAckQ
pklgiveupleadput_ack_msg (2/.cn.jj.service.msg.protocol.PKLGiveUpLeadPutAckI
pklstartplay_ack_msg (2+.cn.jj.service.msg.protocol.PKLStartPlayAckG
pklputcards_ack_msg (2*.cn.jj.service.msg.protocol.PKLPutCardsAckK
pklfinishgame_ack_msg (2,.cn.jj.service.msg.protocol.PKLFinishGameAckA
pklabort_ack_msg (2'.cn.jj.service.msg.protocol.PKLAbortAckE
pkltrustin_ack_msg (2).cn.jj.service.msg.protocol.PKLTrustInAckM
pklonlinestate_ack_msg (2-.cn.jj.service.msg.protocol.PKLOnlineStateAckM
pklupdatemulti_ack_msg (2-.cn.jj.service.msg.protocol.PKLUpdateMultiAckI
pklquitonown_ack_msg (2+.cn.jj.service.msg.protocol.PKLQuitOnOwnAck?
pkltask_ack_msg (2&.cn.jj.service.msg.protocol.PKLTaskAckO
pkltaskfinished_ack_msg (2..cn.jj.service.msg.protocol.PKLTaskFinishedAckI
pkltimelimit_ack_msg (2+.cn.jj.service.msg.protocol.PKLTimeLimitAck"+
PKLDispatchCompleteReq
	nullvalue ("
PKLCallLordReq
call ("
PKLRobLordReq
rob (".
PKLDeclareLordCompleteReq
	nullvalue ("%
PKLGiveUpLeadPutReq
giveup ("/
PKLCard
	cardclass (
	cardpoint ("A
PKLUnitInfo
unittype (
	cardcount (
point ("â
PKLPutCardsReq
seat (2
cards (2#.cn.jj.service.msg.protocol.PKLCard5
unit (2'.cn.jj.service.msg.protocol.PKLUnitInfo"!
PKLGiveUpReq
	nullvalue (" 
PKLTrustInReq
trustin ("%
PKLStartGameAck

gameconfig (	"/
PKLThinkTime
seat (
	timevalue ("T
PKLUpdateThinkTimeAck;
	thinktime (2(.cn.jj.service.msg.protocol.PKLThinkTime"ç
PKLDispatchCardsAck2
cards (2#.cn.jj.service.msg.protocol.PKLCard5
lordcard (2#.cn.jj.service.msg.protocol.PKLCard
pos ("0
PKLDispatchStageFinishedAck
	nullvalue ("S
PKLHandCardsAck
seat (2
cards (2#.cn.jj.service.msg.protocol.PKLCard"(
PKLStartCallLordAck
	beginseat (",
PKLCallLordAck
seat (
call ("!
PKLWaitRobLordAck
seat (":
PKLRobLordAck
seat (
multi (
kept ("Y
PKLDeclareLordAck
seat (6
	fundcards (2#.cn.jj.service.msg.protocol.PKLCard"(
PKLStartGiveUpLeadPutAck
seat ("F
PKLGiveUpLeadPutAck
seat (
giveup (
	keptcards ("0
PKLStartPlayAck
seat (
kepttip ("â
PKLPutCardsAck
seat (2
cards (2#.cn.jj.service.msg.protocol.PKLCard5
unit (2'.cn.jj.service.msg.protocol.PKLUnitInfo"¥
PKLPlayerInfo
double (
score (8
remiancards (2#.cn.jj.service.msg.protocol.PKLCard:
dispatchcards (2#.cn.jj.service.msg.protocol.PKLCard
giveup ("¢
PKLFinishGameAck
winseat (
	gamemulti (
roblordmulti (
	bombmulti (
springmulti (
giveupleadputmulti (
fundcardsmulti (;
extractedcards (2#.cn.jj.service.msg.protocol.PKLCard;
playinfo	 (2).cn.jj.service.msg.protocol.PKLPlayerInfo" 
PKLAbortAck
	nullvalue (".
PKLTrustInAck
seat (
trustin ("1
PKLOnlineStateAck
seat (
online (""
PKLUpdateMultiAck
multi ("b
PKLQuitOnOwnAck
exittime (	
curtime (	
seat (	
playerid (	
nick (	"!

PKLTaskAck
taskcontent (	"B
PKLTaskFinishedAck
seat (
taskid (
bounus ("=
PKLTimeLimitAck
	timelimit (
minputcardstime (
Ÿ
TKPoker.protocn.jj.service.msg.protocol"·
PokerReqMsg
matchid (A
pokerbet_req_msg (2'.cn.jj.service.msg.protocol.PokerBetReqW
pokerplayershowcard_req_msg (22.cn.jj.service.msg.protocol.PokerPlayerShowCardReqR
pokereliveselect_req_msg (20.cn.jj.service.msg.protocol.PokerReliveSelectReqQ
pokeraddonselect_req_msg (2/.cn.jj.service.msg.protocol.PokerAddonSelectReq"≈
PokerAckMsg
matchid (A
pokerbet_ack_msg (2'.cn.jj.service.msg.protocol.PokerBetAckW
pokerplayershowcard_ack_msg (22.cn.jj.service.msg.protocol.PokerPlayerShowCardAckU
pokersavechipparam_ack_msg (21.cn.jj.service.msg.protocol.PokerSaveChipParamAckM
pokermiscparam_ack_msg (2-.cn.jj.service.msg.protocol.PokerMiscParamAckM
pokerdealcards_ack_msg (2-.cn.jj.service.msg.protocol.PokerDealCardsAckM
pokerpotresult_ack_msg (2-.cn.jj.service.msg.protocol.PokerPotResultAckK
pokeronaction_ack_msg	 (2,.cn.jj.service.msg.protocol.PokerOnActionAckO
pokergameresult_ack_msg
 (2..cn.jj.service.msg.protocol.PokerGameResultAckU
pokerqueryshowcard_ack_msg (21.cn.jj.service.msg.protocol.PokerQueryShowCardAckW
pokerreliveselectex_ack_msg (22.cn.jj.service.msg.protocol.PokerReliveSelectExAckU
pokeraddonselectex_ack_msg (21.cn.jj.service.msg.protocol.PokerAddonSelectExAckK
pokercanrebuy_ack_msg (2,.cn.jj.service.msg.protocol.PokerCanRebuyAckS
pokerreliveselect_ack_msg (20.cn.jj.service.msg.protocol.PokerReliveSelectAck"
PokerBetReq
chip ("~
PokerBetAck
seat (
chipbet (
chipleft (
roundbet (
fold (
blind (
thisbet ("&
PokerPlayerShowCardReq
show (">
PokerReliveSelectReq

secondused (

relivecase ("(
PokerAddonSelectReq
	addoncase ("5
PokerPlayerShowCardAck
seat (
cards (",
PokerSaveChipParamAck
savetos (B"@
PokerMiscParamAck

forceallin (
timeoutautoplay ("≠
PokerDealCardsAck
type (
cards (
seat (

dealerseat (

sb (

bb (
chipbet (
chipleft (
roundbet	 (
fold
 ("%
PokerPotResultAck
pots (B"z
PokerOnActionAck
seat (
mincall (

minraiseto (

actiontime (
	extratime (
frbl ("`
PokerResultRec
seat (
potidx (
cardtype (
cards (
chipwon ("M
PokerGameResultAck7
rec (2*.cn.jj.service.msg.protocol.PokerResultRec"*
PokerQueryShowCardAck
	nullvalue ("H
PokerReliveSelectAck

liveplayer (
timeout (
xml (	"±
PokerReliveSelectExAck
jackpot (

liveplayer (
averagechip (
	scorebase (
relivelimittime (
elapsedtime (
timeout (
xml (	"û
PokerAddonSelectExAck
timeout (
jackpot (

liveplayer (
averagechip (
	scorebase (
scorebasearray (B
xml (	"[
PokerCanRebuyAck
jackpot (
gold (
chip (
nNoJackpotAddHPBtn (
ó
TKRunFast.protocn.jj.service.msg.protocol"‘
RunFastReqMsg
matchid (
time (E
Gamebegin_req_msg (2*.cn.jj.service.msg.protocol.RFGameBeginReqQ
DispatchCardend_req_msg (20.cn.jj.service.msg.protocol.RFDispatchCardendReqC
Putcards_req_msg (2).cn.jj.service.msg.protocol.RFPutcardsReqE
TrustGame_req_msg (2*.cn.jj.service.msg.protocol.RFTrustGameReq"ü
RunFastAckMsg
matchid (
time (E
Gamebegin_ack_msg (2*.cn.jj.service.msg.protocol.RFGameBeginAckL
DispatchCard_ack_msg (2..cn.jj.service.msg.protocol.RFDispatchCardsAckK
Beginputcard_ack_msg (2-.cn.jj.service.msg.protocol.RFBeginPutCardAckC
Putcards_ack_msg (2).cn.jj.service.msg.protocol.RFPutcardsAckG
FinishGame_ack_msg (2+.cn.jj.service.msg.protocol.RFFinishGameAckE
TrustGame_ack_msg (2*.cn.jj.service.msg.protocol.RFTrustGameAckK
OnLineStatus_ack_msg	 (2-.cn.jj.service.msg.protocol.RFOnLineStatusAckE
ThinkTime_ack_msg
 (2*.cn.jj.service.msg.protocol.RFThinkTimeAckU
UpdatePlayerScore_ack_msg (22.cn.jj.service.msg.protocol.RFUpdatePlayerScoreAckM
EachPlaryInfo_ack_msg (2..cn.jj.service.msg.protocol.RFEachPlaryInfoAck"%
RFCard
point (
type ("a
RFGameBeginReq
seat (
index (

first_show (
show_one_after_another ("a
RFGameBeginAck
seat (
index (

first_show (
show_one_after_another ("c
RFDispatchCardsAck
seat (
size (1
cards (2".cn.jj.service.msg.protocol.RFCard")
RFDispatchCardendReq
	nullvalue ("4
RFBeginPutCardAck
seat (
	thinktime (":
RFBaseResult
point (
type (
count ("™
RFPutcardsReq
seat (8
result (2(.cn.jj.service.msg.protocol.RFBaseResult
bombseat (
size (1
cards (2".cn.jj.service.msg.protocol.RFCard"€
RFPutcardsAck
seat (8
result (2(.cn.jj.service.msg.protocol.RFBaseResult
	bombscore (
bombseat (
next_seat_think_time (
size (1
cards (2".cn.jj.service.msg.protocol.RFCard"w
RFFinishInfo1
lefts (2".cn.jj.service.msg.protocol.RFCard4
dispatch (2".cn.jj.service.msg.protocol.RFCard"≠
RFFinishGameAck
let_go_seat (
winner_seat (
abort (
single_card_score (
scores (6
info (2(.cn.jj.service.msg.protocol.RFFinishInfo"-
RFTrustGameReq
seat (
trust ("-
RFTrustGameAck
seat (
trust ("0
RFOnLineStatusAck
seat (
state (",
RFThinkTimeAck
seat (
time ("5
RFUpdatePlayerScoreAck
seat (
score ("W
RFEachPlaryInfoAck
show (
	figuer_id (
	nick_name (	
seats (
Ø
TKSMS.protocn.jj.service.msg.protocol"À
	SMSReqMsgA
smsorder_req_msg (2'.cn.jj.service.msg.protocol.SMSOrderReqC
jjcardpay_req_msg (2(.cn.jj.service.msg.protocol.JJCardPayReqM
paycommonorder_req_msg (2-.cn.jj.service.msg.protocol.PayCommonOrderReqE
appleorder_req_msg (2).cn.jj.service.msg.protocol.AppleOrderReqS
purchasecardorder_req_msg (20.cn.jj.service.msg.protocol.PurchaseCardOrderReqK
applepreorder_req_msg (2,.cn.jj.service.msg.protocol.ApplePreOrderReq"À
	SMSAckMsgA
smsorder_ack_msg (2'.cn.jj.service.msg.protocol.SMSOrderAckC
jjcardpay_ack_msg (2(.cn.jj.service.msg.protocol.JJCardPayAckM
paycommonorder_ack_msg (2-.cn.jj.service.msg.protocol.PayCommonOrderAckE
appleorder_ack_msg (2).cn.jj.service.msg.protocol.AppleOrderAckS
purchasecardorder_ack_msg (20.cn.jj.service.msg.protocol.PurchaseCardOrderAckK
applepreorder_ack_msg (2,.cn.jj.service.msg.protocol.ApplePreOrderAck"ü
SMSOrderReq
pid (
mobileno (	
rmbcent (

vmoneytype (
vmoneyamount (
vtmoneyamount (
note (	
	ordersite ("K
SMSOrderAck
longcode (	
listenlongcode (	

verifycode (	"∂
JJCardPayReq
userid (
cardnum (	
cardpassword (	
parvalue (

vmoneytype (
vmoneyamount (
vtmoneyamount (
userip (	
note	 (	"
JJCardPayAck
bankid (
parvalue (

vmoneytype (
vmoneyamount (
vtmoneyamount (
note (	"¸
PayCommonOrderReq
userid (
rmb (
coin (
endmid (
agentid (
zoneid (
	paytypeid (
paytypesubid (
	packageid	 (

ip
 (	
ecaschemeid (
note (	
mobileno (	
gameid ("ä
PayCommonOrderAck
userid (
rmb (
	paytypeid (
paytypesubid (
orderid (	
syncurl (	
param (	"Ö
AppleOrderReq
userid (
	productid (	
transactionid (	
receiptdata (
purchasedata (
orderid (	"D
AppleOrderAck
ret (
orderid (	
transactionid (	"í
PurchaseCardOrderReq
userid (
mobileno (	
packid (
cardtype (

cardamount (
	payamount (
coin (
cardserialno (	
cardpassword	 (	
endmid
 (
reserve1 (
reserve2 (
ecaschemeid (
note (	"g
PurchaseCardOrderAck
userid (
	ordertime (	
ordeID (	
result (
note (	"5
ApplePreOrderReq
userid (
	productid (	"0
ApplePreOrderAck
ret (
orderid (	
⁄
TKSNS.protocn.jj.service.msg.protocol"ï
	SNSReqMsgE
loginbegin_req_msg (2).cn.jj.service.msg.protocol.LoginBeginReqA
loginend_req_msg (2'.cn.jj.service.msg.protocol.LoginEndReq"ï
	SNSAckMsgE
loginbegin_ack_msg (2).cn.jj.service.msg.protocol.LoginBeginAckA
loginend_ack_msg (2'.cn.jj.service.msg.protocol.LoginEndAck"Ê
LoginBeginReq
userid (
nickname (	
	snscltver (
snsclthandle (
	cltselfip (
macaddr (	
notloginsamecity (
reserve2 (
	ticketlen	 (
tickettimestamp
 (
ticket (	"@
AddrInfo
nip (
port (
sip (	
host (	"T
SnsTimeStamp
wSnsCID (
wSnsTID (
dwPID (
dwTimeStamp ("ê
LoginBeginAck
userid (
snsclthandle (
snscount (
snstypediclistts (
snsloadsrvlistts (
reserve1 (
reserve2 (6
addrinfo (2$.cn.jj.service.msg.protocol.AddrInfo7
snsts	 (2(.cn.jj.service.msg.protocol.SnsTimeStamp"F
LoginEndReq
userid (
	snscltver (
snsctlhandle ("#
LoginEndAck
snsctlhandle (
‡
TKThreeCard.protocn.jj.service.msg.protocol"û
ThreeCardReqMsg
matchid (K
threecardante_req_msg (2,.cn.jj.service.msg.protocol.ThreeCardAnteReqI
threecardbet_req_msg (2+.cn.jj.service.msg.protocol.ThreeCardBetReqK
threecardlook_req_msg (2,.cn.jj.service.msg.protocol.ThreeCardLookReqQ
threecardabandon_req_msg (2/.cn.jj.service.msg.protocol.ThreeCardAbandonReqQ
threecardcompare_req_msg (2/.cn.jj.service.msg.protocol.ThreeCardCompareReqM
threecardallin_req_msg (2-.cn.jj.service.msg.protocol.ThreeCardAllinReqI
threecarddoa_req_msg (2+.cn.jj.service.msg.protocol.ThreeCardDOAReqU
threecardtrustplay_req_msg	 (21.cn.jj.service.msg.protocol.ThreeCardTrustPlayReq"î	
ThreeCardAckMsg
matchid (U
threecardstartgame_ack_msg (21.cn.jj.service.msg.protocol.ThreeCardStartGameAckK
threecardante_ack_msg (2,.cn.jj.service.msg.protocol.ThreeCardAnteAckS
threecardinitcard_ack_msg (20.cn.jj.service.msg.protocol.ThreeCardInitCardAckQ
threecardrequest_ack_msg (2/.cn.jj.service.msg.protocol.ThreeCardRequestAckI
threecardbet_ack_msg (2+.cn.jj.service.msg.protocol.ThreeCardBetAckK
threecardlook_ack_msg (2,.cn.jj.service.msg.protocol.ThreeCardLookAckQ
threecardabandon_ack_msg (2/.cn.jj.service.msg.protocol.ThreeCardAbandonAckQ
threecardcompare_ack_msg	 (2/.cn.jj.service.msg.protocol.ThreeCardCompareAckO
threecardresult_ack_msg
 (2..cn.jj.service.msg.protocol.ThreeCardResultAckM
threecardallin_ack_msg (2-.cn.jj.service.msg.protocol.ThreeCardAllinAckQ
threecardhimoney_ack_msg (2/.cn.jj.service.msg.protocol.ThreeCardHiMoneyAckI
threecarddoa_ack_msg (2+.cn.jj.service.msg.protocol.ThreeCardDOAAckQ
threecardjackpot_ack_msg (2/.cn.jj.service.msg.protocol.ThreeCardJackpotAckU
threecardtrustplay_ack_msg (21.cn.jj.service.msg.protocol.ThreeCardTrustPlayAck"z
ThreeCardStartGameAck
ante (
blinds (
	maxblinds (
maxhands (
pkhand (
banker ("5
ThreeCardAnteReq
cnplayer (
adwseat ("5
ThreeCardAnteAck
cnplayer (
adwseat ("9
ThreeCardInitCardAck
cnplayer (
adwseat ("¶
ThreeCardRequestAck
seat (
	requestid (
requesttype (

waitsecond (
round (
blinds (
	maxblinds (
allinlimits ("A
ThreeCardBetReq
seat (
	requestid (
chips (".
ThreeCardBetAck
seat (
chips ("3
ThreeCardLookReq
	requestid (
seat ("1
ThreeCardLookAck
seat (
adwcard ("6
ThreeCardAbandonReq
	requestid (
seat ("6
ThreeCardAbandonAck
	requestid (
seat ("J
ThreeCardCompareReq
seat (
	requestid (

targetseat ("e
ThreeCardCompareAck
seat (

targetseat (
winseat (
chips (
card ("ñ
ThreeCardResultAck
winseat (
pot (
anincome (
anchips (
cnvisibleseat (
visibleseat (
visiblecard ("4
ThreeCardAllinReq
seat (
	requestid ("E
ThreeCardAllinAck
reqseat (
callseat (
chips ("\
ThreeCardHiMoneyAck
seat (
	adwcardid (
himoneytype (
anchips ("2
ThreeCardDOAReq
seat (
	requestid ("p
ThreeCardDOAAck
reqseat (
adwtargetseat (
cntargetseat (
wincount (
chips ("#
ThreeCardJackpotAck
info (	"5
ThreeCardTrustPlayReq
userid (
type ("5
ThreeCardTrustPlayAck
userid (
type (
 
TKTourney.protocn.jj.service.msg.protocol"ô
TourneyReqMsg
gameid (M
gettourneylist_req_msg (2-.cn.jj.service.msg.protocol.GetTourneyListReqE
gettourney_req_mag (2).cn.jj.service.msg.protocol.GetTourneyReqa
 gettourneyplayeramountex_req_msg (27.cn.jj.service.msg.protocol.GetTourneyPlayerAmountExReqK
getmatchpoint_req_msg (2,.cn.jj.service.msg.protocol.GetMatchPointReqS
getsignupdatalist_req_msg (20.cn.jj.service.msg.protocol.GetSignupDataListReq]
getspecifictourneyinfo_req_msg (25.cn.jj.service.msg.protocol.GetSpecificTourneyInfoReq"∫
TourneyAckMsg
gameid (M
gettourneylist_ack_msg (2-.cn.jj.service.msg.protocol.GetTourneyListAckE
gettourney_ack_mag (2).cn.jj.service.msg.protocol.GetTourneyAcka
 gettourneyplayeramountex_ack_msg (27.cn.jj.service.msg.protocol.GetTourneyPlayerAmountExAckK
getmatchpoint_ack_msg (2,.cn.jj.service.msg.protocol.GetMatchPointAckS
getsignupdatalist_ack_msg (20.cn.jj.service.msg.protocol.GetSignupDataListAck"È
TourneyData
	tourneyid (
	productid (
matchstarttime (
tourneystat (
gameid (
startmatchtype (
boutno (
reserve (
misip	 (
misport
 (
risip (
risport ("&
GetTourneyListReq
	nullvalue ("Q
GetTourneyListAck<
tourneylist (2'.cn.jj.service.msg.protocol.TourneyData""
GetTourneyReq
	tourneyid ("M
GetTourneyAck<
tourneydata (2'.cn.jj.service.msg.protocol.TourneyData"j
TourneyPlayerAmountEx
	tourneyid (
signupamount (
playingamount (
	runamount ("0
GetTourneyPlayerAmountExReq
	nullvalue ("d
GetTourneyPlayerAmountExAckE

amountlist (21.cn.jj.service.msg.protocol.TourneyPlayerAmountEx"è

MatchPoint

matchpoint (
matchid (
signupamount (
playingamount (
	runamount (
state (
param ("f
TourneyMatchPoint
	tourneyid (>
matchpointlist (2&.cn.jj.service.msg.protocol.MatchPoint")
GetMatchPointReq
	tourneyid (B"`
GetMatchPointAckL
tourneymatchpointlist (2-.cn.jj.service.msg.protocol.TourneyMatchPoint"B
GrowCondItem
growid (
maxvalue (
minvalue ("F
WareCondItem

waretypeid (
maxvalue (
minvalue ("8
MatchSignupGrowItem
growid (
	growcount ("<
MatchSignupWareItem

waretypeid (
	warecount ("¯
MatchSignupItem

signuptype (

signupnote (	
coin (
bonus (
gold (
cert (A
growlist (2/.cn.jj.service.msg.protocol.MatchSignupGrowItemA
warelist (2/.cn.jj.service.msg.protocol.MatchSignupWareItem"-
GetSignupDataListReq
	tourneyid (B"î
TourneySignupDataList
param (
	tourneyid (
signupnotecondition (	:
growlist (2(.cn.jj.service.msg.protocol.GrowCondItem:
warelist (2(.cn.jj.service.msg.protocol.WareCondItemD
matchsignuplist (2+.cn.jj.service.msg.protocol.MatchSignupItem"h
GetSignupDataListAckP
tourneysignupdatalist (21.cn.jj.service.msg.protocol.TourneySignupDataList".
GetSpecificTourneyInfoReq
	productid (