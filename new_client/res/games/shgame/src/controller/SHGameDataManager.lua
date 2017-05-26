-------------------------------------------------------------------------
-- Desc:    二人梭哈游戏数据管理器
-- Author:  zengzx
-- Date:    2017.5.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHGameDataManager = class("SHGameDataManager")

local SHConfig = import("..cfg.SHConfig")
local SHHelper = import("..cfg.SHHelper")
function SHGameDataManager:ctor()
	self.logTag = self.__cname..".lua"
	self.isInGame = false
	self.valideStart = false -- 是否正常开局
	self.cardOperations = {} --玩家操作队列
	self.playerInfos = {} -- 玩家基本信息 根据座位号来
	self.roundBet = 0 --这一轮的下注额度
end
function SHGameDataManager:setGameScene(SHGameScene)
	self.SHGameScene = SHGameScene
end
---保存进入游戏
--	optional int32 room_id = 1;
--	optional int32 table_id = 2;
--	optional int32 chair_id = 3;
--	optional int32 result = 4;						// GAME_SERVER_RESULT
--	repeated PlayerVisualInfo pb_visual_info = 5;	// 同桌玩家	
--	optional int32 game_id = 6;
--	optional int32 first_game_type = 7;				// 一级菜单
--	optional int32 second_game_type = 8;			// 二级菜单
--	optional string ip_area = 9;


--// 其他玩家可见信息
--message PlayerVisualInfo {
--	optional int32 chair_id = 1;					// 座位
--	optional int32 guid = 2;						// 玩家的guid
--	optional string account = 3;					// 账号
--	optional string nickname = 4;					// 昵称
--	optional int32 level = 5[default = 1];			// 玩家等级
--	optional int64 money = 6[default = 0]; 			// 有多少钱
--	optional int32 header_icon = 7[default = -1]; 	// 头像	
--	optional string ip_area = 8;					// 客户端ip地区
--}

function SHGameDataManager:OnMsg_EnterRoomAndSitDownInfo(msgTab)
	self._enterRoomAndSitDownInfo = msgTab
	ssdump(self._enterRoomAndSitDownInfo,"进入游戏位置信息")
	
	--保存玩家基本信息
	if msgTab.pb_visual_info then
		for i,pbinfo in pairs(msgTab.pb_visual_info) do
			self.playerInfos[pbinfo.chair_id] = pbinfo
		end
	end
	
end
----
function SHGameDataManager:setGameRoomInfo()
    -- body
    local pb_gmMessage = {}
    pb_gmMessage["chair_id"] = self._enterRoomAndSitDownInfo["chair_id"]
    pb_gmMessage["room_id"] = self._enterRoomAndSitDownInfo["room_id"]
    pb_gmMessage["table_id"] = self._enterRoomAndSitDownInfo["table_id"]
    pb_gmMessage["first_game_type"] = self._enterRoomAndSitDownInfo["first_game_type"]
    pb_gmMessage["second_game_type"] = self._enterRoomAndSitDownInfo["second_game_type"]
    GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(pb_gmMessage)
end
--开局信息
--message SC_ShowHand_Desk_Enter {
--	enum MsgID { ID = 17100; }
--	repeated ShowHand_Player_Info pb_players 	= 1; 		// 玩家
--	optional int32 state = 2;							//状态
--  optional int32 zhuang = 3;							//庄家
--  optional int32 self_chair_id = 4;					//id
--	optional int32 act_time_limit = 5;					// 操作时间
--	optional bool is_reconnect = 6;						//reconnect
--	optional int32 base_score = 7;
--	optional int32 max_call = 8;
--	optional ShowHand_Reconnect_Data pb_rec_data = 7;		//断线数据
--}
--message ShowHand_Reconnect_Data {
--	optional int32 act_left_time = 1;						// 操作剩余时间
--}
--message ShowHand_Player_Info {
--	repeated int32 tiles                    = 1;	// 牌列表
--	optional int32 chair_id		            = 2; 	// id
--  optional int32 add_total	            = 3; 	// 累计下注
--  optional int32 cur_round_add            = 4;    // 当前轮下注
--	optional string nick 					= 5;
--	optional int32 icon 					= 6;
--	optional int32 gold 					= 7;
--	optional int32 guid		            	= 8; 	// guid
--	// game end
--	optional bool is_win 		= 9;			//是否赢了
--	optional int32 win_money 	= 10; 			//赢钱
--	optional int32 taxes 		= 11; 			//税收
--	//reconnect
--};
function SHGameDataManager:on_SC_ShowHand_Desk_Enter(msgTab)
	ssdump(msgTab," 玩家进入",10)

	local playerNumInValid = (not msgTab.pb_players or table.nums(msgTab.pb_players)<2)
	if playerNumInValid  then --这个时候其实没有开局，忽略消息
		sslog(self.logTag,"进入消息只是表示进来的，没有开局，发送开局消息")
		self.valideStart = false
		return
	end
	self.valideStart = true
	self.isInGame = true
	self:setGameRoomInfo()
	--庄家ID
	self.zhuangId = msgTab.zhuang
	--自己的ID
	self.selfChairId = msgTab.self_chair_id
	--是否是恢复对局
	self.isReconnect =  msgTab.is_reconnect
	--底注
	self.baseScore =  msgTab.base_score
	--限注
	self.maxCall =  msgTab.max_call
	--操作时间 等待时间
	self.chooseTime =  msgTab.act_time_limit
	--进入游戏的状态 恢复对局的时候有用
	self.enterState = msgTab.state 
	--断线数据
	--act_left_time  操作剩余时间
	self.reconnData = msgTab.pb_rec_data
	
	SHHelper.removeAll(self.playerdatas)
	SHHelper.removeAll(self.cardOperations)
	self.roundBet = 0
	self.cardOperations = {}
	--SHHelper.removeAll(self.handCards)
	--self.handCards = {}
	self.playerdatas = {}
	for _,playerinfo in pairs(msgTab.pb_players) do
		
		--	repeated int32 tiles                    = 1;	// 牌列表
		--	optional int32 chair_id		            = 2; 	// id
		--  optional int32 add_total	            = 3; 	// 累计下注
		--  optional int32 cur_round_add            = 4;    // 当前轮下注
		--	optional string nick 					= 5;
		--	optional int32 icon 					= 6;
		--	optional int32 gold 					= 7;
		--	// game end
		--	optional bool is_win 		= 5;			//是否赢了
		--	optional int32 win_money 	= 6; 			//赢钱
		--	optional int32 taxes 		= 7; 			//税收
		local playerData = {}
		playerData.handCards = {}
		--self.handCards[playerinfo.chair_id]= {}
		for _,tile in pairs(playerinfo.tiles) do
			local card = SHConfig.convertToLocalCard(tile)
			table.insert(playerData.handCards,card)
			--table.insert(self.handCards[playerinfo.chair_id],card)
			--把每一张牌消息牌添加到队列中
			local tempCard = CustomHelper.copyTab(card)
			tempCard.createTag = self.isReconnect
			local cardOperation = {
				type = SHConfig.CardOperation.GetCard,
				chairId = playerinfo.chair_id,
				card = tempCard,
			}
			table.insert(self.cardOperations,cardOperation)
		
		end
		
		playerData.chair_id = playerinfo.chair_id
		playerData.add_total = playerinfo.add_total --累计下注
		playerData.cur_round_add = playerinfo.cur_round_add --当前轮下注
		--当前有人下注，把最大的设置成当前游戏下注额度
		if playerData.cur_round_add and self.roundBet < playerData.cur_round_add then
			self.roundBet = playerData.cur_round_add
		end
		playerData.money = playerinfo.gold --金币
		playerData.headId = playerinfo.icon or 1 --头像id
		playerData.nickname = playerinfo.nick --昵称
		playerData.guid = playerinfo.guid --昵称
		
		self.playerdatas[playerinfo.chair_id] = playerData
		

		
	end
	
	ssdump(self.playerdatas,"解析后的玩家信息",10)
	
	
	SHHelper.removeAll(self.gameOverDatas) --结算消息
	
end
--服务器的游戏状态
--message SC_ShowHand_Desk_State{
--	enum MsgID { ID = 17101; }
--	optional int32 state = 1;				
--}
function SHGameDataManager:on_SC_ShowHand_Desk_State(msgTab)

end
--结算
--message SC_ShowHand_Game_Finish {
--	enum MsgID { ID = 17102; }
--	repeated ShowHand_Player_Info pb_players 	= 1; 		// 玩家
--}

function SHGameDataManager:on_SC_ShowHand_Game_Finish(msgTab)
	ssdump(msgTab," 游戏结算",10)
	SHHelper.removeAll(self.gameOverDatas)
	self.isInGame = false
	self.valideStart = false
	GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(nil)
	self.gameOverDatas = {}
	for _,playerinfo in pairs(msgTab.pb_players) do
		
		--	repeated int32 tiles                    = 1;	// 牌列表
		--	optional int32 chair_id		            = 2; 	// id
		--  optional int32 add_total	            = 3; 	// 累计下注
		--  optional int32 cur_round_add            = 4;    // 当前轮下注
		--	optional string nick 					= 5;
		--	optional int32 icon 					= 6;
		--	optional int32 gold 					= 7;
		--	// game end
		--	optional bool is_win 		= 5;			//是否赢了
		--	optional int32 win_money 	= 6; 			//赢钱
		--	optional int32 taxes 		= 7; 			//税收
		--  optional bool is_give_up	= 12; 			//弃牌
		local playerData = {}
		playerData.handCards = {}
		for _,tile in pairs(playerinfo.tiles) do
			table.insert(playerData.handCards,SHConfig.convertToLocalCard(tile))
		end
		
		playerData.chair_id = playerinfo.chair_id
		playerData.add_total = playerinfo.add_total --累计下注
		playerData.cur_round_add = playerinfo.cur_round_add --当前轮下注
		playerData.is_win = playerinfo.is_win --是否赢了
		playerData.win_money = playerinfo.win_money --赢了多少
		playerData.taxes = playerinfo.taxes --税收
		
		playerData.money = playerinfo.gold --金币
		playerData.headId = playerinfo.icon or 1 --头像id
		playerData.nickname = playerinfo.nick --昵称
		playerData.is_give_up = playerinfo.is_give_up --是否弃牌
		self.gameOverDatas[playerinfo.chair_id] = playerData
	end
	--GameOver
	local cardOperation = {
		type = SHConfig.CardOperation.GameOver,
	}
	self.cardOperations = self.cardOperations or {}
	table.insert(self.cardOperations,cardOperation)
	--ssdump(self.cardOperations,"玩家操作队列",10)
end
--翻牌  下一回合
--message SC_ShowHand_Next_Round {
--	enum MsgID { ID = 17103; }
--	repeated ShowHand_Player_Info pb_players 	= 1; 		// 玩家
--}
function SHGameDataManager:on_SC_ShowHand_Next_Round(msgTab)
	--这里处理 得到一张牌
	ssdump(msgTab," 玩家发牌返回",6)
	--self.handCards = self.handCards or {}--玩家手里的牌
	--两个玩家都有
	self.cardOperations = self.cardOperations or {}
	for _,playerinfo in pairs(msgTab.pb_players) do
		
		--	repeated int32 tiles                    = 1;	// 牌列表
		--	optional int32 chair_id		            = 2; 	// id
		--  optional int32 add_total	            = 3; 	// 累计下注
		--  optional int32 cur_round_add            = 4;    // 当前轮下注
		--	
		--	// game end
		--	optional bool is_win 		= 5;			//是否赢了
		--	optional int32 win_money 	= 6; 			//赢钱
		--	optional int32 taxes 		= 7; 			//税收
		local playerCards = {}
		
		for _,tile in pairs(playerinfo.tiles) do
			table.insert(playerCards,SHConfig.convertToLocalCard(tile))
		end
		--最后一张牌放进去
		if self.playerdatas[playerinfo.chair_id] and self.playerdatas[playerinfo.chair_id].handCards then
			table.insert(self.playerdatas[playerinfo.chair_id].handCards,playerCards[#playerCards])
		end
		--取最后一张牌作为发的牌
		local cardOperation = {
			type = SHConfig.CardOperation.GetCard,
			chairId = playerinfo.chair_id,
			card = playerCards[#playerCards]
		}
		
		table.insert(self.cardOperations,cardOperation)
	end	

	--ssdump(self.cardOperations,"玩家操作队列",10)
	
end
--加注=倍数*底注，allin = -1，跟注 = 0
--message SC_ShowHandAddScore {
--	enum MsgID { ID = 17104; }
--  optional int32 target       = 1;  //目标值
--  optional int32 chair_id	    = 2; 	// id
--}
function SHGameDataManager:on_SC_ShowHandAddScore(msgTab)
	ssdump(msgTab," 玩家下注")
	local opType = nil	
	
	if msgTab.target == -2 then --跟注
		opType = SHConfig.CardOperation.Call
	elseif msgTab.target == -1 then --showhand
		opType = SHConfig.CardOperation.ShowHand
	else
		opType = SHConfig.CardOperation.Raise
		--self.roundBet = msgTab.target --当前这一轮的最大下注数
	end
	local cardOperation = {
		type = opType,
		chairId = msgTab.chair_id,
		card = msgTab.target --目标注
	}
	self.cardOperations = self.cardOperations or {}
	table.insert(self.cardOperations,cardOperation)
	--ssdump(self.cardOperations,"玩家操作队列",10)
end
--弃牌
--message SC_ShowHandGiveUp {
--	enum MsgID { ID = 17105; }
--    optional int32 chair_id	    = 1; 	// id
--}
function SHGameDataManager:on_SC_ShowHandGiveUp(msgTab)
	ssdump(msgTab," 玩家下注")
	local cardOperation = {
		type = SHConfig.CardOperation.Fall,
		chairId = msgTab.chair_id,
		
	}
	self.cardOperations = self.cardOperations or {}
	table.insert(self.cardOperations,cardOperation)
	--ssdump(self.cardOperations,"玩家操作队列",10)
end
--让牌
--message SC_ShowHandPass {
--	enum MsgID { ID = 17005; }
--  optional int32 chair_id	    = 1; 	// id
--}
function SHGameDataManager:on_SC_ShowHandPass(msgTab)
	ssdump(msgTab," 玩家让牌")
	local cardOperation = {
		type = SHConfig.CardOperation.Pass,
		chairId = msgTab.chair_id,
		
	}
	self.cardOperations = self.cardOperations or {}
	table.insert(self.cardOperations,cardOperation)
	--ssdump(self.cardOperations,"玩家操作队列",10)
end
--更新发言者
--message SC_ShowHand_NextTurn {
--	enum MsgID { ID = 17107; }
--    optional int32 chair_id	    = 1; 	// 当前玩家表态
--	optional int32 type = 2; 			// 当前玩家表态类型
--	optional int32 max_add = 2; 			// 当前玩家最大allin额度
--	
--	//1 --加注
--	//2 --allin
--	//4 --跟注
--	//8 --让牌
--	//16 --弃牌
--}
function SHGameDataManager:on_SC_ShowHand_NextTurn(msgTab)
	ssdump(msgTab," 玩家发言")
	
	local typeWight = {
		[1] = SHConfig.CardOperation.Raise,--3 加注
		[2] = SHConfig.CardOperation.ShowHand,--4 梭哈
		[3] = SHConfig.CardOperation.Call,--2 跟注
		[4] = SHConfig.CardOperation.Pass,--5 过牌
		[5] = SHConfig.CardOperation.Fall,--1 弃牌
	}
	self.maxAdd = msgTab.max_add --最大下注的数目/all in
	--根据类型值 返回类型组合
	local function getTypes(types)
		local avaliableTypes = {}
		local curVal = types
		local curIndex = 5
		while curVal>=0 do
			curVal = curVal - math.pow(2,curIndex-1)
			if curVal>=0 then --curIndex 位置有数值
				table.insert(avaliableTypes,typeWight[curIndex])
				curIndex = curIndex -1
				if curIndex<=0 then
					break
				end
			else
				curVal = curVal + math.pow(2,curIndex-1) --还原回去
				curIndex = curIndex -1
				if curIndex<=0 then
					break
				end
			end
		end
		return avaliableTypes
	end
	
	local cardOperation = {
		type = SHConfig.CardOperation.ShowDecision,
		chairId = msgTab.chair_id,
		card = {
			types = getTypes(msgTab.type),
			max_add = msgTab.max_add
		}
	}
	self.cardOperations = self.cardOperations or {}
	table.insert(self.cardOperations,cardOperation)
	--ssdump(self.cardOperations,"玩家操作队列",10)	
	
end

--玩家聊天返回
--	optional string chat_content = 1;				// 聊天内容
--	optional int32 chat_guid = 2;					// 说话人
--	optional string chat_name = 3; 					// 说话人名字
function SHGameDataManager:on_SC_ChatTable(msgTab)
	ssdump(msgTab,"玩家聊天内容")

	
end

--返回非自己的座位ID
function SHGameDataManager:getNotSelfChairId()
	local otherChairId = nil
	if self.playerdatas then
		for chairId,v in pairs(self.playerdatas) do
			if chairId ~=self.selfChairId then
				otherChairId = chairId
				break
			end
		end
	end
	return otherChairId
end
--根据用户ID获取座位ID
function SHGameDataManager:getChairIdById(guid)
	local ret = nil
	for chairId,pinfo in ipairs(self.playerInfos) do
		if pinfo.guid == guid then
			ret = chairId
			break
		end
	end
	return ret
end

return SHGameDataManager