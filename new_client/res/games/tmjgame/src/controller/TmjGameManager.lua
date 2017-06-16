-------------------------------------------------------------------------
-- Desc:    二人麻将游戏控制器
-- Author:  zengzx
-- Date:    2017.4.10
-- Last: 
-- Content:  
--		1.发送消息
--    	2.注册消息接收
--		3.通知游戏数据管理器
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
TmjGameManager = class("TmjGameManager",requireForGameLuaFile("SubGameBaseManager"))
local TmjGameDataManager = import(".TmjGameDataManager")
local HallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager()
local TmjConfig = import("..cfg.TmjConfig")
local TmjOperationFactory = requireForGameLuaFile("TmjOperationFactory")
function TmjGameManager:ctor()
	TmjGameManager.super.ctor(self)
	self.logTag = self.__cname..".lua"
	--游戏详情
	self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
	CustomHelper.addSetterAndGetterMethod(self,"dataManager",TmjGameDataManager:create())--游戏数据管理器
	--注册pb文件
	self:registerPBProtocolToHallMsgManager()
	
	--sslog(self.logTag,Tmji18nUtils:get('str_cardtip','playOne'))
end

function TmjGameManager:registerPBProtocolToHallMsgManager()
	local pbFileTab = {}
	table.insert(pbFileTab,"common_msg_maajan.proto")
	
	for k,v in pairs(pbFileTab) do
		local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(v)
		HallMsgManager:registerProtoFileToPb(pbFullPath)
	end
	--增加解析key
	if TmjConfig and TmjConfig.MsgName and type(TmjConfig.MsgName)=="table" then
		for k,v in pairs(TmjConfig.MsgName) do
			HallMsgManager:registerMsgNameToMsgPBMananager(v)
			
		end
	end
end

function TmjGameManager:clearLoadedOneGameFiles()
	-- body
	local loaded = package.loaded
    --重新加载frame内文件
    loaded["TmjGameManager"] = nil
    loaded["TmjGameDataManager"] = nil
    loaded["TmjGameScene"] = nil
    loaded["TmjCardTip"] = nil
    loaded["TmjConfig"] = nil
    loaded["TmjHelper"] = nil
    loaded["TmjFanCalculator"] = nil
    loaded["languageString"] = nil
    loaded["Tmji18nUtils"] = nil
    loaded["TmjOperationFactory"] = nil
	
	
	if TmjGameManager then
		TmjGameManager.instance = nil
	end
	if Tmji18nUtils then
		Tmji18nUtils.instance = nil
	end
	if TmjOperationFactory then
		TmjOperationFactory.instance = nil
	end
	
	
end
function TmjGameManager:sendEnterRoomAndSitDownMsg()
	sslog(self.logTag,"发送进入并坐下消息")
	local infoTab = {}
	HallMsgManager:sendMsg(TmjConfig.MsgName.CS_EnterRoomAndSitDown,infoTab)
end

--发送重连消息
function TmjGameManager:sendReconnectMsg()
	sslog(self.logTag,"发送断线重连消息")
	--print("-------发送重连")
	local  msgTab = {};
	local msgName = TmjConfig.MsgName.CS_ReconnectionPlay
	HallMsgManager:sendMsg(msgName,msgTab)
end

--胡请求
function TmjGameManager:requestHu()
	sslog(self.logTag,"发送胡请求")
	HallMsgManager:sendMsg(TmjConfig.MsgName.CS_Maajan_Act_Win,{})
end
--加倍请求
function TmjGameManager:requestDouble()
	sslog(self.logTag,"发送加倍请求")
	HallMsgManager:sendMsg(TmjConfig.MsgName.CS_Maajan_Act_Double,{})
end
--打牌请求
--@param localVal 牌值
function TmjGameManager:requestPlayCard(localVal)
	sslog(self.logTag,"发送打牌请求"..localVal)
	local msgTab = {}
	msgTab.tile = TmjConfig.convertToServerCard(localVal)
	HallMsgManager:sendMsg(TmjConfig.MsgName.CS_Maajan_Act_Discard,msgTab)
end
--碰请求
function TmjGameManager:requestPeng()
	sslog(self.logTag,"发送碰请求")
	HallMsgManager:sendMsg(TmjConfig.MsgName.CS_Maajan_Act_Peng,{})
end
--杠请求
--@param localVal 牌值
function TmjGameManager:requestGang(localVal)
	sslog(self.logTag,"发送杠请求")
	local msgTab = {}
	msgTab.tile = TmjConfig.convertToServerCard(localVal)
	HallMsgManager:sendMsg(TmjConfig.MsgName.CS_Maajan_Act_Gang,msgTab)
end
--过请求 在其他玩家出牌的时候，我有吃 碰 杠 胡 的操作，但不操作的时候，可以发送过告诉服务器 以减少等待时间
function TmjGameManager:requestPass()
	sslog(self.logTag,"发送过请求")
	HallMsgManager:sendMsg(TmjConfig.MsgName.CS_Maajan_Act_Pass,{})
end
--吃
--@param localVals 牌值
function TmjGameManager:requestChi(localVals)
	ssdump(localVals,"发送吃请求")
	local msgTab = {}
	for _,localVal in ipairs(localVals) do
		msgTab.tiles = msgTab.tiles or {}
		table.insert(msgTab.tiles,TmjConfig.convertToServerCard(localVal))
	end
	HallMsgManager:sendMsg(TmjConfig.MsgName.CS_Maajan_Act_Chi,msgTab)
end
--托管请求
function TmjGameManager:requestTrustee()
	ssdump(localVals,"发送托管请求")
	HallMsgManager:sendMsg(TmjConfig.MsgName.CS_Maajan_Act_Trustee,{})
end
--托管请求
function TmjGameManager:requestTing()
	ssdump(localVals,"发送听牌")
	HallMsgManager:sendMsg(TmjConfig.MsgName.CS_Maajan_Act_BaoTing,{})
end
--检测并发送托管请求，如果没有托管那么请求托管 自己
function TmjGameManager:checkToRequestTrustee()
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		return
	end
	
end
function TmjGameManager:sendGameReady()
	TmjGameManager.super.sendGameReady(self)
	local TmjGameDataManager = self:getDataManager()
	TmjGameDataManager:changeGameState(TmjConfig.GameCtrState.Matching)
end


--玩家进入
--	repeated Maajan_Player_Info pb_players 	= 1; 		// 玩家
--	optional int32 state = 2;							//状态
--  optional int32 zhuang = 3;							//庄家
--  optional int32 self_chair_id = 4;					//id

--message Maajan_Player_Info {
--	repeated Maajan_Tiles pb_ming_pai 	= 1; 	// 明牌
--	repeated int32 pb_shou_pai 	= 2; 			// 手牌
--	repeated int32 pb_hua_pai 	= 3; 			// 花牌
--	repeated int32 pb_desk_pai 	= 4; 			// 桌牌，打出去的牌
--	optional int32 chair_id		= 5; 			// id
--	// game end
--	optional bool is_hu 		= 6;			//是否胡了
--	optional int32 hu_fan	 	= 7; 			//番数
--	optional int32 jiabei	 	= 8; 			//加倍次数
--	optional string describe	= 9;			//牌型描述
--	optional int32 win_money 	= 10; 			//赢钱
--	optional int32 taxes 		= 11; 			//税收
--	optional bool finish_task	= 12; 			//完成任务
--	//reconnect
--	optional bool is_ting 		= 13;			//是否听
	
--	//
--	optional string nick 					= 14;
--	optional int32 icon 					= 15;
--	optional int32 gold 					= 16;
--	optional int32 guid		            	= 17; 	// guid
--};

--message Maajan_Tiles {
--	repeated int32 tiles = 1;						// 牌列表
--}
function TmjGameManager:on_SC_Maajan_Desk_Enter(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	TmjGameDataManager:on_SC_Maajan_Desk_Enter(msgTab)
end
	
--胡
--	optional int32 chair_id		= 1; 			// id
--	optional int32 tile 		= 2;			// 牌值
--	optional int32 ba_gang_hu	= 3;			// 是否是巴杠胡 1 为true
function TmjGameManager:on_SC_Maajan_Act_Win(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	TmjGameDataManager:on_SC_Maajan_Act_Win(msgTab)
end
--加倍
--	optional int32 chair_id		= 1; 			// id
function TmjGameManager:on_SC_Maajan_Act_Double(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	TmjGameDataManager:on_SC_Maajan_Act_Double(msgTab)
end
--打牌
--	optional int32 chair_id		= 1; 			// id
--	optional int32 tile = 2;					// 牌值
function TmjGameManager:on_SC_Maajan_Act_Discard(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end	
	TmjGameDataManager:on_SC_Maajan_Act_Discard(msgTab)
end
-- 碰
--	optional int32 chair_id		= 1; 			// id
--	optional int32 tile = 2;					// 牌值
function TmjGameManager:on_SC_Maajan_Act_Peng(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	TmjGameDataManager:on_SC_Maajan_Act_Peng(msgTab)
end
-- 杠
--	optional int32 chair_id	 	= 1; 			// id
--	optional int32 tile = 2;					// 牌值
--	optional int32 type = 3;					// 类型，1自己手上四张，暗杠， 2自己手上三张，明杠， 3已经碰了，摸了一张，巴杠
function TmjGameManager:on_SC_Maajan_Act_Gang(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end	
	TmjGameDataManager:on_SC_Maajan_Act_Gang(msgTab)
end
--吃
--	optional int32 chair_id	 	= 1; 			// id
--	optional int32 tile = 2;					// 牌值，吃进的牌
--	repeated int32 tiles = 3;					// 牌值,三張
function TmjGameManager:on_SC_Maajan_Act_Chi(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end	
	TmjGameDataManager:on_SC_Maajan_Act_Chi(msgTab)
end
--剩余多少张公牌
--optional int32 tile_left = 1;	
function TmjGameManager:on_SC_Maajan_Tile_Letf(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	TmjGameDataManager:on_SC_Maajan_Tile_Letf(msgTab)
end
--该谁出牌
-- optional int32 chair_id	 = 1;
function TmjGameManager:on_SC_Maajan_Discard_Round(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	TmjGameDataManager:on_SC_Maajan_Discard_Round(msgTab)
end
--服务器的游戏状态
--optional int32 state = 1;	
function TmjGameManager:on_SC_Maajan_Desk_State(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end	
	TmjGameDataManager:on_SC_Maajan_Desk_State(msgTab)
end
--摸牌
--repeated int32 tiles = 1;					// 摸到的牌值，含补花	
function TmjGameManager:on_SC_Maajan_Draw(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end	
	TmjGameDataManager:on_SC_Maajan_Draw(msgTab)
end
--开始阶段补花
--repeated Maajan_Tiles pb_bu_hu 	= 1; 		// 补花
function TmjGameManager:on_SC_Maajan_Bu_Hua(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end	
	TmjGameDataManager:on_SC_Maajan_Bu_Hua(msgTab)
end
--报听返回
--optional int32 chair_id	 = 1;	
--optional bool is_ting = 2;				//最終报听狀態 true听 false 非听
function TmjGameManager:on_SC_Maajan_Act_BaoTing(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end	
	TmjGameDataManager:on_SC_Maajan_Act_BaoTing(msgTab)
end
--托管返回
--	optional int32 chair_id	 = 1;	
--	optional bool is_trustee = 2;				//最終托管狀態 true托管 false 非托管
function TmjGameManager:on_SC_Maajan_Act_Trustee(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end	
	TmjGameDataManager:on_SC_Maajan_Act_Trustee(msgTab)
	
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
function TmjGameManager:on_SC_Maajan_Game_Finish(msgTab)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end	
	TmjGameDataManager:on_SC_Maajan_Game_Finish(msgTab)
end
--获取牌的剩余数量
function TmjGameManager:getRestCardCount(val)
	local TmjGameDataManager = self:getDataManager()
	if not TmjGameDataManager then
		sslog(self.logTag,"二人麻将数据管理器已经销毁")
		return 0
	end	
	return TmjGameDataManager:getRestCardCount(val)
end

function TmjGameManager:onExit()
	
	TmjGameManager.super.onExit(self)
	self:clearLoadedOneGameFiles()
	
	
end
TmjGameManager.instance = nil
function TmjGameManager:getInstance()
	if TmjGameManager.instance == nil then
		TmjGameManager.instance = TmjGameManager:create();
	end
	return TmjGameManager.instance;
end

return TmjGameManager