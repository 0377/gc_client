JdnnGameDataManager = class("JdnnGameDataManager");
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

JdnnGameDataManager.instance = nil

function JdnnGameDataManager:getInstance()
	if JdnnGameDataManager.instance == nil then
		JdnnGameDataManager.instance = JdnnGameDataManager:create();
	end
	return JdnnGameDataManager.instance;
end

JdnnGameDataManager.BankerInfo = 
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


function JdnnGameDataManager:ctor()

	print("JdnnGameDataManager:ctor")
	-- body
	self._userList = {}   --用于存储所有玩家的信息
	self._tableinfo = {}
	
	self.isMatch = true --是否在匹配


end
---保存进入游戏
function JdnnGameDataManager:OnMsg_EnterRoomAndSitDownInfo(msgTab)
	self._enterRoomAndSitDownInfo = msgTab
end
function JdnnGameDataManager:getRoomInfo()
	return 	self._enterRoomAndSitDownInfo
end

function JdnnGameDataManager:OnSC_BankerTableMatching(msgTab)
	print( "//匹配")
	self.isMatch = true
	
end

function JdnnGameDataManager:on_SC_BankerSendCards(msgTab)
	
	print( "//发牌")
	
	self.isMatch = false
	
	self._tableinfo = msgTab.pb_table
	self._userList = msgTab.pb_player
	
	local my = self:getMyInfo()
	if my ~= nil then
		my.cards = msgTab.cards
	end
	
	
	for k,v in ipairs(self._userList) do
		if v.cards == nil then
			v.cards = 	{
							[1] = -1,
							[2] = -1,
							[3] = -1,
							[4] = -1,
							[5] = -1
						}
		end
	end
	
	
	
end

--[[

--游戏状态
JdnnGameManager.TexasStatus =
{
	STATUS_SEND_CARDS		= 1;	--//发牌阶段
	STATUS_CONTEND_BANKER	= 2;	--//抢庄阶段
	STATUS_DICISION_BANKER	= 3;	--//定庄阶段
	STATUS_BET				= 4;	--//下注阶段
	STATUS_SHOW_CARD		= 5;	--//摊牌阶段
	STATUS_SHOW_DOWN		= 6;	--//结算
}

--]]
function JdnnGameDataManager:on_SC_BankerBeginToContend(msgTab)
	print( "//开始抢庄")
	
	self._tableinfo.countdown = msgTab.countdown
	self._tableinfo.total_time = msgTab.total_time
	self._tableinfo.state = JdnnGameManager.TexasStatus.STATUS_CONTEND_BANKER
end


function JdnnGameDataManager:on_SC_BankerPlayerContend(msgTab)
	
	print( "//其它玩家的抢庄倍数")
	local player = self:getUserInfoByChair(msgTab.chair)
	if player ~= nil then
		player.ratio = msgTab.ratio
	end
end


function JdnnGameDataManager:on_SC_BankerChoosingBanker(msgTab)
	
	print( "//定庄")
	self._tableinfo.state = JdnnGameManager.TexasStatus.STATUS_DICISION_BANKER
	
	self._tableinfo.ManyChoosingPlayerChairs = msgTab.chairs
	self._tableinfo.banker_chair = msgTab.banker_chair
	
	
	local t = {1,5,6,4,9}
	
	
	--排序
	
	--排序的算法
	function comps(a,b)
		return a < b
	end

	--应用
	--[[
	table.sort(self._tableinfo.ManyChoosingPlayerChairs,comps);
	table.sort(t,comps);
	for k,v in ipairs(t) do
		if v == 6 then
			table.remove(t,k)
			--t[k] = nil
		end
	end
	table.insert(t,6)
	--]]
	for k,v in ipairs(self._tableinfo.ManyChoosingPlayerChairs) do
		if v == msgTab.banker_chair then
			table.remove(self._tableinfo.ManyChoosingPlayerChairs,k)
			break;
			--self._tableinfo.ManyChoosingPlayerChairs[k] = nil
		end
	end
	table.insert(self._tableinfo.ManyChoosingPlayerChairs,msgTab.banker_chair)
	
	local player = self:getUserInfoByChair(msgTab.banker_chair)
	if player ~= nil then
		player.position = 1
		--player.ratio = ratio
	end
	
	
end

function JdnnGameDataManager:on_SC_BankerPlayerBeginToBet(msgTab)
	-- body
	print( "//闲家开始下注")
	self._tableinfo.countdown = msgTab.countdown
	self._tableinfo.total_time = msgTab.total_time
	self._tableinfo.state = JdnnGameManager.TexasStatus.STATUS_BET
	
end

function JdnnGameDataManager:on_SC_BankerPlayerBet(msgTab)
	-- body
	print( "//闲家下注")
	local player = self:getUserInfoByChair(msgTab.chair)
	if player ~= nil then
		player.bet_money = msgTab.bet_money
	end
end

function JdnnGameDataManager:on_SC_BankerShowOwnCards(msgTab)
	-- body
	print( "//玩家看到自己的牌")
	self._tableinfo.state = JdnnGameManager.TexasStatus.STATUS_SHOW_CARD
	self._tableinfo.countdown = msgTab.countdown
	self._tableinfo.total_time = msgTab.total_time
	
	local my = self:getMyInfo()
	if my ~= nil then
		my.cards = msgTab.cards
		my.pre_cards_type = msgTab.cards_type --预测牌型
	end
end


function JdnnGameDataManager:on_SC_BankerShowCards(msgTab)
	-- body
	print( "//展示牌桌各玩家牌	消息个数=玩家人数")
	local player = self:getUserInfoByChair(msgTab.chair)
	if player ~= nil then
		player.cards = msgTab.cards
		player.cards_type = msgTab.cards_type
		player.flag = msgTab.flag --//3-2展示	1展示; 2不展示
	end
end

function JdnnGameDataManager:on_SC_BankerGameEnd(msgTab)
	print( "//结算")
	
	for k,v in ipairs(msgTab.pb_player) do
		local player = self:getUserInfoByChair(v.chair)
		if player ~= nil then
			player.money = v.money
			player.tax = v.tax
			player.victory = v.victory
			player.increment_money = v.increment_money
		end
	end
	self._tableinfo.state = JdnnGameManager.TexasStatus.STATUS_SHOW_DOWN
end

function JdnnGameDataManager:on_SC_BankerForceToLeave(msgTab)
	print( "//强制离开")
end
function JdnnGameDataManager:on_SC_BankerReconnectInfo(msgTab)
	print( "//断线重入 房间汇总信息/等待信息")
	
	dump(msgTab)
	
	self.isMatch = false
	
	self._tableinfo = msgTab.pb_table
	self._userList = msgTab.pb_player
	self._tableinfo.countdown = msgTab.countdown
	self._tableinfo.total_time = msgTab.total_time
	
	
	--填充牌数据
	for k,v in ipairs(self._userList) do
		if v.cards == nil then
			v.cards = 	{
							[1] = -1,
							[2] = -1,
							[3] = -1,
							[4] = -1,
							[5] = -1
						}
		end
	end
	
	--
	
end



function JdnnGameDataManager:getTableInfo()
	
	return self._tableinfo
	
end
function JdnnGameDataManager:getUserInfoList()
	
	return self._userList
	
end

function JdnnGameDataManager:getUserInfoByChair(chair)

	for k, v in pairs(self._userList) do
		if v.chair == chair then
			return v
		end
		
	end
	
	return nil
	
end


--
--获取自己信息
function JdnnGameDataManager:getMyInfo()
	local my = self:getUserInfoByChair(self._tableinfo.chair)
	return my
	
end


--获取庄家信息
function JdnnGameDataManager:getZhuangJiaInfo()
	
	for k, v in pairs(self._userList) do
		if v.position == 1 then
			return v
		end
		
	end
	
	return nil
	
end

--获取庄家信息
function JdnnGameDataManager:getMaxRatio()
	local maxRatio = -1
	for k, v in pairs(self._userList) do
		
		if v.ratio ~= nil and v.ratio > maxRatio then
			maxRatio = v.ratio
		end
		
	end
	
	return maxRatio
	
end



return JdnnGameDataManager

