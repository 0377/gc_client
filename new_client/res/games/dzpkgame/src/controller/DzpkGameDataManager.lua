DzpkGameDataManager = class("DzpkGameDataManager");
--import("..views.DdzHelper")
--import("..views.DdzMsgId")
--[[

local userInfoZeroTemplate = {
	
	optional int64 money = 5;		//携带的钱
	optional int64 bet_money = 6;	//本轮下注的钱
	optional int32 action = 7;		//本轮正在进行的动作	
	optional int32 position = 8;	//玩家位置			[enum TexasUserPosition]
	optional int32 hole_cards = 9[default = 0];	//是否有底牌 1-有, 0-无
	optional int32 countdown = 10;	//倒计时/s
	--repeated int32 cards = 11;		//底牌
	optional int32 cards_type = 12;	//牌型[enum TexasCardsType]
	optional int64 tax = 13;		//税收
	optional int32 victory = 14[default = 0];	//输赢状态	1-赢； 0-输；3-普通
	optional int32 biggest_winner = 15;	//最大牌	1-是； 0-否
	optional int64 win_money = 16;	//赢的钱
	optional int32 main_pot_money = 17; //赢取主池的钱
	repeated int32 side_pot_money = 18;	//赢取第几个边池	[330,0,5560]
	
}

--]]

-- require "cocos.cocos2d.functions"


-- --test

function merge1( tDest, tSrc )
	if tDest == nil then
		return clone(tSrc)
	end
	
    for k, v in pairs( tSrc ) do
		if type(v) == "table"  then
			tDest[k] = merge1( tDest[k], v )
		else
			tDest[k] = v
		end
    end
	
	return tDest
end

-- local t1 = {1,3,5,ta = "fds",tp = 67,pp = { 1,4,a = 6}}
-- local t2 = {3,5,6,ta = "ttt"}
-- local t3 = {tp = "ttt",pp = {2,2}}
-- local t4 = {tp1 = "ttt1",pp = {a = 3,b = 4}}

-- local t5 = {pp1 = {a = 7,b = 8}}

-- table.merge( t1, t2 )
-- table.merge( t1, t3 )
-- table.merge( t1, t4 )
-- table.merge( t1, t5 )



local scheduler = cc.Director:getInstance():getScheduler() 

DzpkGameDataManager.instance = nil

function DzpkGameDataManager:getInstance()
	if DzpkGameDataManager.instance == nil then
		DzpkGameDataManager.instance = DzpkGameDataManager:create();
	end
	return DzpkGameDataManager.instance;
end

DzpkGameDataManager.BankerInfo = 
{
    guid = 0,
    nickname = 0,   --昵称
    money = 0,      ---当前金币数
    bankertimes= 0, ---连庄次数
    max_score = 0,  ---最大下注
    banker_score = 0, ---成绩
    left_score = 0,  ---剩余还可下注金币数
    header_icon = 1    --- 头像
}


function DzpkGameDataManager:ctor()

	print("DzpkGameDataManager:ctor")
	-- body
	self._userList = {}   --用于存储所有玩家的信息
	self._tableinfo = {}


end
---保存进入游戏
function DzpkGameDataManager:OnMsg_EnterRoomAndSitDownInfo(msgTab)
	self._enterRoomAndSitDownInfo = msgTab
end
function DzpkGameDataManager:getRoomInfo()
	return 	self._enterRoomAndSitDownInfo
end

function DzpkGameDataManager:OnSC_TexasTableInfo(msgTab)
	
	self._userList = {}
	for k, v in pairs(msgTab.pb_user) do
		self._userList[v.chair] = v
		
	end
	
	--self._userList = msgTab.userpb_table
	self._tableinfo = msgTab.pb_table
	
end

function DzpkGameDataManager:on_SC_TexasSendPublicCards(msgTab)
	merge1(self._tableinfo,msgTab.pb_table)
	
	for k,v in ipairs(msgTab.pb_user) do
		if self._userList[v.chair] == nil then
			self._userList[v.chair] = v
		end
		
		merge1(self._userList[v.chair],v)
	end
	
end

function DzpkGameDataManager:on_SC_TexasSendUserCards(msgTab)
	-- body
	print( "玩家发牌-1s间隔")

	for k,v in ipairs(msgTab.pb_user) do
		if self._userList[v.chair] == nil then
			self._userList[v.chair] = v
		else
			merge1(self._userList[v.chair],v)
		end
		
	end
	merge1(self._tableinfo,msgTab.pb_table)
end


function DzpkGameDataManager:on_SC_TexasUserAction(msgTab)
	-- body
	print( "玩家操作")
	
	merge1(self._tableinfo,msgTab.pb_table)
	
	local v = msgTab.pb_action
	if self._userList[v.chair] == nil then
		self._userList[v.chair] = v
	else
		merge1(self._userList[v.chair],v)
	end
	
end


function DzpkGameDataManager:on_SC_TexasNewUser(msgTab)
	-- body
	print( "进入")
	
	local v = msgTab.pb_user
	
	self._userList[v.chair] = v
		
	
	
end

function DzpkGameDataManager:on_SC_TexasUserLeave(msgTab)
	-- body
	print( "离开")
	local v = msgTab.pb_user
	
	self._userList[v.chair] = nil
end

function DzpkGameDataManager:on_SC_TexasTableEnd(msgTab)
	-- body
	print( "结算")
	
	merge1(self._tableinfo,msgTab.pb_table)
	
	for k,v in ipairs(msgTab.pb_user) do
		if self._userList[v.chair] == nil then
			self._userList[v.chair] = v
		else
			merge1(self._userList[v.chair],v)
		end
		
	end
	
	local a = 0
end

function DzpkGameDataManager:on_SC_TexasGiveTips(msgTab)
	-- body
	print( "打赏")
	--dump(msgTab)
	local v = msgTab
	if self._userList[msgTab.chair] ~= nil then
		self._userList[msgTab.chair].money = msgTab.money
	end
end


function DzpkGameDataManager:on_SC_TexasShowCards(msgTab)
	-- body
	print( "亮牌")
	--dump(msgTab)
	if self._userList[msgTab.chair] ~= nil then
		self._userList[msgTab.chair].hole_cards = 1
		self._userList[msgTab.chair].cards = msgTab.user_cards
		self._userList[msgTab.chair].cards_type = msgTab.cards_type
	end
	
end

function DzpkGameDataManager:on_SC_TexasShowCardsPermission(msgTab)
	-- body
	print( "允许自己亮牌")
	--dump(msgTab)
end





function DzpkGameDataManager:getTableInfo()
	
	return self._tableinfo
	
end
function DzpkGameDataManager:getUserInfoList()
	
	return self._userList
	
end

function DzpkGameDataManager:getUserInfoByChair(chair)

	for k, v in pairs(self._userList) do
		if v.chair == chair then
			return v
		end
		
	end
	
	return nil
	
end


function DzpkGameDataManager:getUserInfoByGuid(guid)

	for k, v in pairs(self._userList) do
		if v.guid == guid then
			return v
		end
		
	end
	
	return nil
	
end


--获取剩余有效思考时间
function DzpkGameDataManager:getThinkTime()
	local max = 0
	for k, v in pairs(self._userList) do
		if v.countdown > 0 then
			return v.countdown
		end
	end
	
	return max
	
end



--获取当轮桌面最大下注
function DzpkGameDataManager:getUserMaxBet_money()
	local max = 0
	for k, v in pairs(self._userList) do
		if v.bet_money >= max then
			max = v.bet_money
		end
	end
	
	return max
	
end


--获取当轮自己下注
function DzpkGameDataManager:getMyBet_money()
	local max = 0
	
	local my = self:getUserInfoByChair(self._tableinfo.own_chair)
	if my == nil then
		return max
	else
		return my.bet_money
	end
	
	return max
	
end

--
--获取自己信息
function DzpkGameDataManager:getMyInfo()
	local my = self:getUserInfoByChair(self._tableinfo.own_chair)
	return my
	
end



return DzpkGameDataManager

