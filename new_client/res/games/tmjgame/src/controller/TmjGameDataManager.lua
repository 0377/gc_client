-------------------------------------------------------------------------
-- Desc:    二人麻将游戏数据管理器
-- Author:  zengzx
-- Date:    2017.4.10
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjGameDataManager = class("TmjGameDataManager")

local TmjConfig = import("..cfg.TmjConfig")
local TmjHelper = import("..cfg.TmjHelper")
local TmjCardTip = import("..cfg.TmjCardTip")
function TmjGameDataManager:ctor()
	self.logTag = self.__cname..".lua"
	self.isGameOver = false 
end
function TmjGameDataManager:setGameScene(TmjGameScene)
	self.TmjGameScene = TmjGameScene
end
--玩家进入

--message Maajan_Player_Info {
--	repeated Maajan_Tiles pb_ming_pai 	= 1; 	// 明牌
--	repeated int32 pb_shou_pai 	= 2; 			// 手牌
--	repeated int32 pb_hua_pai 	= 3; 			// 花牌
--	repeated int32 pb_desk_pai 	= 4; 			// 桌牌，打出去的牌
--	optional int32 chair_id		= 5; 			// id
--};

--message Maajan_Task_Data {
--	optional int32 task_type = 1;						// 任务类型
--	optional int32 task_tile = 2;						// 牌值
--	optional int32 task_scale = 3;						// 加倍就是 2
--}

--message Maajan_Tiles {
--	repeated int32 tiles = 1;						// 牌列表
--}

--	repeated Maajan_Player_Info pb_players 	= 1; 		// 玩家
--	optional int32 state = 2;							//状态
--  optional int32 zhuang = 3;							//庄家
--  optional int32 self_chair_id = 4;					//id

function TmjGameDataManager:on_SC_Maajan_Desk_Enter(msgTab)
	local TmjGameScene = self.TmjGameScene
	if not TmjHelper.isLuaNodeValid(TmjGameScene) then
		
	end
	self.isGameOver = false 
	--self.seatsInfos = msgTab
	--庄家ID
	self.zhuangId = msgTab.zhuang
	--自己的ID
	self.selfChairId = msgTab.self_chair_id
	--是否是恢复对局
	self.isReconnect =  msgTab.is_reconnect
	--操作时间 打牌步长
	self.playCardTime =  msgTab.act_time_limit
	--碰刚吃胡加倍 思考时间时间
	self.preDesionTime =  msgTab.decision_time_limit
	--进入游戏的状态 恢复对局的时候有用
	self.enterState = msgTab.state 
	--任务数据
	self.taskData = msgTab.pb_task_data
	if self.taskData and self.taskData.task_tile then
		self.taskData.task_tile = TmjConfig.convertToLocalCard(self.taskData.task_tile)
	end
	--断线数据
	--act_left_time  操作剩余时间
	--chu_pai_player_index 最后一次出牌用户索引  或者  当前该谁出牌
	--last_chu_pai 最后一次的出牌
	self.reconnData = msgTab.pb_rec_data
	if self.reconnData and self.reconnData.last_chu_pai then	--转换出牌到本地
		self.reconnData.last_chu_pai = TmjConfig.convertToLocalCard(self.reconnData.last_chu_pai)
	end
		
	TmjHelper.removeAll(self.playerdatas)
	self.playerdatas = {}
	for _,playerinfo in pairs(msgTab.pb_players) do
		--playerinfo.pb_ming_pai
		local playerData = self:parsePlayerCard(playerinfo)
		
		playerData.chair_id = playerinfo.chair_id
		playerData.isTing = playerinfo.is_ting --是否听
		if playerData.chair_id == self.selfChairId then
			playerData.lastInputVal = playerData.handCards[#playerData.handCards].val --最后一个牌是我摸的
		end
		self.playerdatas[playerinfo.chair_id] = playerData
	end
	
	ssdump(msgTab," 玩家进入",10)
	ssdump(self.playerdatas,"解析后的玩家信息",10)
	TmjHelper.removeAll(self.discards)
	TmjHelper.removeAll(self.cardOperations)
	TmjHelper.removeAll(self.doubleActions)
	TmjHelper.removeAll(self.tingState)
	TmjHelper.removeAll(self.trusteeState)
	
	self.discards = {} --开局后打牌数据清空
	self.doubleActions = {} --加倍情况清空
	self.cardOperations = {} -- 吃碰杠胡摸牌的操作队列
	self.tingState = {} -- 玩家听牌的状态
	self.trusteeState = {} -- 玩家托管的状态
	--{path = "TmjMyPlayer",seatid = 1}
	--开局
	
	--TmjGameScene:initPlayer()
	
	
end
--胡
--	optional int32 chair_id		= 1; 			// id
--	optional int32 tile 		= 2;			// 牌值
--	optional int32 ba_gang_hu	= 3;			// 是否是巴杠胡 1 为true
function TmjGameDataManager:on_SC_Maajan_Act_Win(msgTab)
	ssdump(msgTab," 玩家胡返回")
	local cardOperation = {
		type = TmjConfig.cardOperation.Hu,
		chairId = msgTab.chair_id,
		card = {val = TmjConfig.convertToLocalCard(msgTab.tile) } --胡的牌值
		
	}
	table.insert(self.cardOperations,cardOperation)
	ssdump(self.cardOperations,"玩家操作队列")
end
--加倍
--	optional int32 chair_id		= 1; 			// id
function TmjGameDataManager:on_SC_Maajan_Act_Double(msgTab)
	ssdump(msgTab," 玩家加倍返回")
	--chair_id
	if msgTab.chair_id then
		self.doubleActions[msgTab.chair_id] = msgTab.jiabei_val or 0 --玩家加倍
	end
	
end
--打牌
--	optional int32 chair_id		= 1; 			// id
--	optional int32 tile = 2;					// 牌值
function TmjGameDataManager:on_SC_Maajan_Act_Discard(msgTab)
	ssdump(msgTab," 玩家打牌返回")
	--这里把打牌消息按照队列的形式放入table中，游戏中每次去取就行了
	--chair_id
	local cardOperation = {
		type = TmjConfig.cardOperation.Play,
		chairId = msgTab.chair_id,
		card = {val = TmjConfig.convertToLocalCard(msgTab.tile) }
	}
	table.insert(self.cardOperations,cardOperation)
	ssdump(self.cardOperations,"玩家操作队列",10)
	
end
-- 碰
--	optional int32 chair_id		= 1; 			// id
--	optional int32 tile = 2;					// 牌值
function TmjGameDataManager:on_SC_Maajan_Act_Peng(msgTab)
	ssdump(msgTab," 玩家碰返回")
	local cardOperation = {
		type = TmjConfig.cardOperation.Peng,
		chairId = msgTab.chair_id,
		card = {val = TmjConfig.convertToLocalCard(msgTab.tile) }
	}
	table.insert(self.cardOperations,cardOperation)
	ssdump(self.cardOperations,"玩家操作队列",10)
end
-- 杠
--	optional int32 chair_id	 	= 1; 			// id
--	optional int32 tile = 2;					// 牌值
--	optional int32 type = 3;					// 类型，1自己手上四张，暗杠， 2自己手上三张，明杠， 3已经碰了，摸了一张，巴杠
function TmjGameDataManager:on_SC_Maajan_Act_Gang(msgTab)
	ssdump(msgTab," 玩家杠返回")
	--1自己手上四张，暗杠， 2自己手上三张，明杠， 3已经碰了，摸了一张，巴杠
	local gTypes = {
		[1] = TmjConfig.cardOperation.AnGang,
		[2] = TmjConfig.cardOperation.Gang,
		[3] = TmjConfig.cardOperation.BuGang,
	}
	local cardOperation = {
		type = gTypes[msgTab.type],
		chairId = msgTab.chair_id,
		card =  {val = TmjConfig.convertToLocalCard(msgTab.tile) } --杠的牌
	}
	table.insert(self.cardOperations,cardOperation)
	ssdump(self.cardOperations,"玩家操作队列")
end
--吃
--	optional int32 chair_id	 	= 1; 			// id
--	optional int32 tile = 2;					// 牌值，吃进的牌
--	repeated int32 tiles = 3;					// 牌值,三張
function TmjGameDataManager:on_SC_Maajan_Act_Chi(msgTab)
	ssdump(msgTab," 玩家吃返回")
	local handCards = {
	}
	table.walk(msgTab.tiles,function (card,k)
		if card~=msgTab.tile then--手里的牌 不包括要吃的牌
			table.insert(handCards,{val = card,position = display.center })
		end
	end)
	local cardOperation = {
		type = TmjConfig.cardOperation.Chi,
		chairId = msgTab.chair_id,
		card = {
			outCard = {val = TmjConfig.convertToLocalCard(msgTab.tile) }, --吃进的牌
			handCards = handCards,
		}
	}
	table.insert(self.cardOperations,cardOperation)
	ssdump(self.cardOperations,"玩家操作队列")
end
--剩余多少张公牌
--optional int32 tile_left = 1;	
function TmjGameDataManager:on_SC_Maajan_Tile_Letf(msgTab)
	ssdump(msgTab," 玩家剩余公牌数量返回")
	--tile_left
	self.cardLeftCount = tonumber(msgTab.tile_left) --剩余牌的数量
	
end
--该谁出牌
-- optional int32 chair_id	 = 1;
function TmjGameDataManager:on_SC_Maajan_Discard_Round(msgTab)
	ssdump(msgTab," 该谁出牌返回")
	self.showCardChairId = msgTab.chair_id --当前出牌的玩家ID
	
end
--服务器的游戏状态
--optional int32 state = 1;	
function TmjGameDataManager:on_SC_Maajan_Desk_State(msgTab)
	ssdump(msgTab," 服务器游戏状态返回")
end
--返回非自己的座位ID
function TmjGameDataManager:getNotSelfChairId()
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
--摸牌
--repeated int32 tiles = 1;					// 摸到的牌值，含补花	
function TmjGameDataManager:on_SC_Maajan_Draw(msgTab)
	ssdump(msgTab," 玩家摸牌返回")
	if not self.playerdatas then
		sslog(self.logTag,"摸牌的时候，座位信息是空的")
		return 
	end

	local chairId = msgTab.tiles[1] <= TmjConfig.convertToServerCard(TmjConfig.Card.R_Chry) and self.selfChairId or self:getNotSelfChairId()
	
	local cards = {}
	table.walk(msgTab.tiles,function (card,k)
		
		table.insert(cards,{val = TmjConfig.convertToLocalCard(card) })
	end)
	local cardOperation = {
		type = TmjConfig.cardOperation.GetOne,
		chairId = chairId,
		card = cards
	}
	table.insert(self.cardOperations,cardOperation)
	ssdump(self.cardOperations,"玩家操作队列",10)
end
--开始阶段补花
--repeated Maajan_Tiles pb_bu_hu 	= 1; 		// 补花
function TmjGameDataManager:on_SC_Maajan_Bu_Hua(msgTab)
	ssdump(msgTab," 玩家开始阶段补花返回",6)
	if not self.zhuangId then
		sslog(self.logTag,"补花之前庄家还未定下来")
		return
	end
	--msgTab.pb_bu_hu 
	self.startBuHua = {}
	--庄家先补花
	
	local zhuangCards = msgTab.pb_bu_hu[self.zhuangId]
	if zhuangCards and zhuangCards.tiles and next(zhuangCards.tiles) then
		local buhuaCard = {}
		for _,card in pairs(zhuangCards.tiles) do
			table.insert(buhuaCard,{val = TmjConfig.convertToLocalCard(card) })
		end
		local cardOperation = {
			type = TmjConfig.cardOperation.BuHua,
			chairId = self.zhuangId,
			card =  buhuaCard --补花的牌
		}
		table.insert(self.cardOperations,cardOperation)
	end
	--闲家补花
	for chairId,cards in pairs(msgTab.pb_bu_hu) do
		if chairId~=self.zhuangId then
			local buhuaCard = {}
			if cards and cards.tiles and next(cards.tiles) then
				for _,card in pairs(cards.tiles) do
					table.insert(buhuaCard,{val = TmjConfig.convertToLocalCard(card) })
				end
				--self.startBuHua[chairId] = buhuaCard
				local cardOperation = {
					type = TmjConfig.cardOperation.BuHua,
					chairId = chairId,
					card =  buhuaCard --补花的牌
				}
				table.insert(self.cardOperations,cardOperation)
			end
		end

	end
	
end
--报听返回
--optional int32 chair_id	 = 1;	
--optional bool is_ting = 2;				//最終报听狀態 true听 false 非听
function TmjGameDataManager:on_SC_Maajan_Act_BaoTing(msgTab)
	ssdump(msgTab," 报听返回",6)
	self.tingState = self.tingState or {}
	self.tingState[msgTab.chair_id] = self.tingState[msgTab.chair_id] or {}
	self.tingState[msgTab.chair_id].isTing = msgTab.is_ting --玩家的听牌状态
	
end
--托管返回
--	optional int32 chair_id	 = 1;	
--	optional bool is_trustee = 2;				//最終托管狀態 true托管 false 非托管
function TmjGameDataManager:on_SC_Maajan_Act_Trustee(msgTab)
	ssdump(msgTab," 托管返回",6)
	self.trusteeState = self.trusteeState or {}
	self.trusteeState[msgTab.chair_id] = self.trusteeState[msgTab.chair_id] or {}
	self.trusteeState[msgTab.chair_id].isTrustee = msgTab.is_trustee --玩家的听牌状态
end

--结算
--repeated Maajan_Player_Info pb_players 	= 1; 		// 玩家

--message Maajan_Player_Info {
--	repeated Maajan_Tiles pb_ming_pai 	= 1; 	// 明牌
--	repeated int32 shou_pai 	= 2; 			// 手牌
--	repeated int32 hua_pai 		= 3; 			// 花牌
--	repeated int32 desk_pai 	= 4; 			// 桌牌，打出去的牌
--	optional int32 chair_id		= 5; 			// id
	
--	// game end
--	optional bool is_hu 		= 6;			//是否胡了
--	optional int32 hu_fan	 	= 7; 			//番数
--	optional int32 jiabei	 	= 8; 			//加倍次数
--	optional string describe	= 9;			//牌型描述
--	optional int32 win_money 	= 10; 			//赢钱
--	optional int32 taxes 		= 11; 			//税收
--	optional bool finish_task	= 12; 			//完成任务
--};
function TmjGameDataManager:on_SC_Maajan_Game_Finish(msgTab)
	ssdump(msgTab,"结算消息",10)
	TmjHelper.removeAll(self.consultData)
	self.isGameOver = true --结束了
	self.consultData = {}
	self.consultData.players = {}
	self.consultData.winChairId = nil --谁赢了 如果是nil 那么就是流局
	for _,playerinfo in pairs(msgTab.pb_players) do
		if not self.consultData.winChairId then
			self.consultData.winChairId =  playerinfo.is_hu and playerinfo.chair_id or nil
		end
		local playerData = {}
		playerData = CustomHelper.copyTab(playerinfo)
		local playerCardData = self:parsePlayerCard(playerinfo)
		table.merge(playerData,playerCardData)
		self.consultData.players[playerinfo.chair_id] = playerData
	end
	
	
end
--解析玩家牌数据
function TmjGameDataManager:parsePlayerCard(playerinfo)
	local playerData = {}
	if playerinfo.pb_ming_pai then --吃碰杠的牌
		playerData.extraCards = {} --明牌
		for _,cards in pairs(playerinfo.pb_ming_pai) do
			cards = cards.tiles
			--判断牌类型
			local extraData = {}
			if table.nums(cards)==3 then --吃和碰
				extraData.value = {}
				if cards[1]==cards[2] and cards[2] == cards[3] then --碰
					
					extraData.type =  TmjConfig.cardOperation.Peng
					--cardInfo
					extraData.value = {createTag = true, val = TmjConfig.convertToLocalCard(cards[1])  }
				else --吃
					extraData.type = TmjConfig.cardOperation.Chi
					local outCard = {val =TmjConfig.convertToLocalCard(cards[1]) }
					local handCards = {}
					table.insert(handCards,{val =TmjConfig.convertToLocalCard(cards[2]) })
					table.insert(handCards,{val =TmjConfig.convertToLocalCard(cards[3]) })
					extraData.value = { createTag = true,outCard = outCard,handCards = handCards }
		
				end

			elseif table.nums(cards)==5 then --杠 
				extraData.value = {}
				--取最后一位
				--1自己手上四张，暗杠， 2自己手上三张，明杠， 3已经碰了，摸了一张，巴杠
				local gangTypes = {
					[1] = TmjConfig.cardOperation.AnGang,
					[2] = TmjConfig.cardOperation.Gang,
					[3] = TmjConfig.cardOperation.BuGang,
				}
				extraData.type = gangTypes[cards[5]]
				extraData.value = {createTag = true,val = TmjConfig.convertToLocalCard(cards[1]) }

			end
			
			table.insert(playerData.extraCards,extraData)
		end
	end
	if playerinfo.shou_pai then --手上的牌
		playerData.handCards = {} --明牌
		for _,card in pairs(playerinfo.shou_pai) do
			table.insert(playerData.handCards,{val = TmjConfig.convertToLocalCard(card),position = display.center })
		end
	end
	
	if playerinfo.desk_pai then --打出去的牌
		playerData.outCard = {}
		for _,card in pairs(playerinfo.desk_pai) do
			table.insert(playerData.outCard,{val = TmjConfig.convertToLocalCard(card),position = display.center })
		end
	end
	if playerinfo.hua_pai then
		playerData.huaCard = {}
		for _,card in pairs(playerinfo.hua_pai) do
			table.insert(playerData.huaCard,TmjConfig.convertToLocalCard(card))
		end
	end
	return playerData
end


--获取这个牌值的牌 还剩余多少张
function TmjGameDataManager:getRestCardCount(val)
	local totalCount = 4
	if val >=TmjConfig.Card.R_Spring then
		totalCount = 1
	end
	local TmjGameScene = self.TmjGameScene
	if TmjHelper.isLuaNodeValid(TmjGameScene) then
		totalCount  = totalCount - TmjGameScene:getShowCardCount(val)
	end
	
	return totalCount
end

---保存进入游戏
function TmjGameDataManager:OnMsg_EnterRoomAndSitDownInfo(msgTab)
	self._enterRoomAndSitDownInfo = msgTab
	ssdump(self._enterRoomAndSitDownInfo,"进入游戏位置信息")
end
return TmjGameDataManager