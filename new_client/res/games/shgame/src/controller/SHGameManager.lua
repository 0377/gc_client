-------------------------------------------------------------------------
-- Desc:    二人梭哈游戏控制器
-- Author:  zengzx
-- Date:    2017.5.11
-- Last: 
-- Content:  
--		1.发送消息
--    	2.注册消息接收
--		3.通知游戏数据管理器
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
SHGameManager = class("SHGameManager",requireForGameLuaFile("SubGameBaseManager"))
local SHGameDataManager = import(".SHGameDataManager")
local HallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager()
local SHConfig = import("..cfg.SHConfig")
function SHGameManager:ctor()
	SHGameManager.super.ctor(self)
	self.logTag = self.__cname..".lua"
	--游戏详情
	self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
	CustomHelper.addSetterAndGetterMethod(self,"dataManager",SHGameDataManager:create())--游戏数据管理器
	--注册pb文件
	self:registerPBProtocolToHallMsgManager()
end

function SHGameManager:registerPBProtocolToHallMsgManager()
	local pbFileTab = {}
	table.insert(pbFileTab,"common_msg_showhand.proto")
	
	for k,v in pairs(pbFileTab) do
		local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(v)
		HallMsgManager:registerProtoFileToPb(pbFullPath)
	end
	--增加解析key
	if SHConfig and SHConfig.MsgName and type(SHConfig.MsgName)=="table" then
		for k,v in pairs(SHConfig.MsgName) do
			HallMsgManager:registerMsgNameToMsgPBMananager(v)
			
		end
	end
end
function SHGameManager:sendEnterRoomAndSitDownMsg()
	sslog(self.logTag,"发送进入并坐下消息")
	local infoTab = {}
	HallMsgManager:sendMsg(SHConfig.MsgName.CS_EnterRoomAndSitDown,infoTab)
end

--发送重连消息
function SHGameManager:sendReconnectMsg()
	sslog(self.logTag,"发送断线重连消息")
	--print("-------发送重连")
	local  msgTab = {};
	local msgName = SHConfig.MsgName.CS_ReconnectionPlay
	HallMsgManager:sendMsg(msgName,msgTab)
end


--发送弃牌请求
function SHGameManager:sendFallMsg()
	sslog(self.logTag,"发送弃牌请求")
	local infoTab = {}
	HallMsgManager:sendMsg(SHConfig.MsgName.CS_ShowHandGiveUp,infoTab)
end
--发送跟牌请求
function SHGameManager:sendCallMsg()
	sslog(self.logTag,"发送跟牌请求")
	local infoTab = {}
	infoTab.target = -2
	HallMsgManager:sendMsg(SHConfig.MsgName.CS_ShowHandAddScore,infoTab)
end
--发送过牌请求
function SHGameManager:sendPassMsg()
	sslog(self.logTag,"发送过牌请求")
	local infoTab = {}
	HallMsgManager:sendMsg(SHConfig.MsgName.CS_ShowHandPass,infoTab)
end
--发送加注请求
function SHGameManager:sendRaiseMsg(gold)
	sslog(self.logTag,"发送加注请求")
	local infoTab = {}
	infoTab.target = gold
	HallMsgManager:sendMsg(SHConfig.MsgName.CS_ShowHandAddScore,infoTab)	
end
--发送梭哈请求
function SHGameManager:sendShowHandMsg()
	sslog(self.logTag,"发送梭哈请求")
	local infoTab = {}
	infoTab.target = -1
	HallMsgManager:sendMsg(SHConfig.MsgName.CS_ShowHandAddScore,infoTab)	
end
--发送聊天
function SHGameManager:sendChatMsg(data)
	sslog(self.logTag,"发送聊天请求")
	local infoTab = {}
	infoTab.chat_content = data or ""
	HallMsgManager:sendMsg(SHConfig.MsgName.CS_ChatTable,infoTab)	
end

--开局信息
--message SC_ShowHand_Desk_Enter {
--	enum MsgID { ID = 17100; }
--	repeated ShowHand_Player_Info pb_players 	= 1; 		// 玩家
--	optional int32 state = 2;							//状态
--  optional int32 zhuang = 3;							//庄家
--  optional int32 self_chair_id = 4;					//id
--	optional int32 act_time_limit = 5;					// 操作时间
--  optional int32 cur_turn = 6;                        //当前该谁说话
--	optional bool is_reconnect = 7;						//reconnect
--	optional ShowHand_Reconnect_Data pb_rec_data = 8;		//断线数据
--}
--message ShowHand_Reconnect_Data {
--	optional int32 act_left_time = 1;						// 操作剩余时间
--}
--message ShowHand_Player_Info {
--	repeated int32 tiles                    = 1;	// 牌列表
--	optional int32 chair_id		            = 2; 	// id
--  optional int32 add_total	            = 3; 	// 累计下注
--  optional int32 cur_round_add            = 4;    // 当前轮下注
--	
--	// game end
--	optional bool is_win 		= 5;			//是否赢了
--	optional int32 win_money 	= 6; 			//赢钱
--	optional int32 taxes 		= 7; 			//税收
--	//reconnect
--};
function SHGameManager:on_SC_ShowHand_Desk_Enter(msgTab)
	local SHGameDataManager = self:getDataManager()
	if not SHGameDataManager then
		sslog(self.logTag,"二人梭哈数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	SHGameDataManager:on_SC_ShowHand_Desk_Enter(msgTab)
end
--服务器的游戏状态
--message SC_ShowHand_Desk_State{
--	enum MsgID { ID = 17101; }
--	optional int32 state = 1;				
--}
function SHGameManager:on_SC_ShowHand_Desk_State(msgTab)
	local SHGameDataManager = self:getDataManager()
	if not SHGameDataManager then
		sslog(self.logTag,"二人梭哈数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	SHGameDataManager:on_SC_ShowHand_Desk_State(msgTab)
end
--结算
--message SC_ShowHand_Game_Finish {
--	enum MsgID { ID = 17102; }
--	repeated ShowHand_Player_Info pb_players 	= 1; 		// 玩家
--}

function SHGameManager:on_SC_ShowHand_Game_Finish(msgTab)
	local SHGameDataManager = self:getDataManager()
	if not SHGameDataManager then
		sslog(self.logTag,"二人梭哈数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	SHGameDataManager:on_SC_ShowHand_Game_Finish(msgTab)
end
--翻牌  下一回合
--message SC_ShowHand_Next_Round {
--	enum MsgID { ID = 17103; }
--	repeated ShowHand_Player_Info pb_players 	= 1; 		// 玩家
--}
function SHGameManager:on_SC_ShowHand_Next_Round(msgTab)
	local SHGameDataManager = self:getDataManager()
	if not SHGameDataManager then
		sslog(self.logTag,"二人梭哈数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	SHGameDataManager:on_SC_ShowHand_Next_Round(msgTab)
end
--加注=倍数*底注，allin = -1，跟注 = 0
--message SC_ShowHandAddScore {
--	enum MsgID { ID = 17104; }
--  optional int32 target       = 1;  //目标值
--  optional int32 chair_id	    = 2; 	// id
--}
function SHGameManager:on_SC_ShowHandAddScore(msgTab)
	local SHGameDataManager = self:getDataManager()
	if not SHGameDataManager then
		sslog(self.logTag,"二人梭哈数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	SHGameDataManager:on_SC_ShowHandAddScore(msgTab)
end
--弃牌
--message SC_ShowHandGiveUp {
--	enum MsgID { ID = 17105; }
--    optional int32 chair_id	    = 1; 	// id
--}
function SHGameManager:on_SC_ShowHandGiveUp(msgTab)
	local SHGameDataManager = self:getDataManager()
	if not SHGameDataManager then
		sslog(self.logTag,"二人梭哈数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	SHGameDataManager:on_SC_ShowHandGiveUp(msgTab)
end
--让牌
--message SC_ShowHandPass {
--	enum MsgID { ID = 17005; }
--  optional int32 chair_id	    = 1; 	// id
--}
function SHGameManager:on_SC_ShowHandPass(msgTab)
	local SHGameDataManager = self:getDataManager()
	if not SHGameDataManager then
		sslog(self.logTag,"二人梭哈数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	SHGameDataManager:on_SC_ShowHandPass(msgTab)
end

--更新发言者
--message SC_ShowHand_NextTurn {
--	enum MsgID { ID = 17107; }
--    optional int32 chair_id	    = 1; 	// 当前玩家表态
--	optional int32 type = 2; 			// 当前玩家表态类型
--	
--	//1 --加注
--	//2 --allin
--	//4 --跟注
--	//8 --让牌
--	//16 --弃牌
--}
function SHGameManager:on_SC_ShowHand_NextTurn(msgTab)
	local SHGameDataManager = self:getDataManager()
	if not SHGameDataManager then
		sslog(self.logTag,"二人梭哈数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	SHGameDataManager:on_SC_ShowHand_NextTurn(msgTab)
end
--玩家聊天返回
--	optional string chat_content = 1;				// 聊天内容
--	optional int32 chat_guid = 2;					// 说话人
--	optional string chat_name = 3; 					// 说话人名字
function SHGameManager:on_SC_ChatTable(msgTab)
	local SHGameDataManager = self:getDataManager()
	if not SHGameDataManager then
		sslog(self.logTag,"二人梭哈数据管理器已经销毁")
		ssdump(msgTab,"收到的消息内容")
		return
	end
	SHGameDataManager:on_SC_ChatTable(msgTab)
end

function SHGameManager:clearLoadedOneGameFiles()
	-- body
	local loaded = package.loaded
    --重新加载frame内文件
    loaded["SHGameManager"] = nil
    loaded["SHGameDataManager"] = nil
    loaded["SHGameScene"] = nil
    loaded["SHCardTip"] = nil
    loaded["SHConfig"] = nil
    loaded["SHHelper"] = nil
    loaded["languageString"] = nil
	
    loaded["SHi18nUtils"] = nil
	
	SHGameManager.instance = nil
	SHi18nUtils.instance = nil
	
end

function SHGameManager:onExit()
	
	SHGameManager.super.onExit(self)
	self:clearLoadedOneGameFiles()
	
	
end
SHGameManager.instance = nil
function SHGameManager:getInstance()
	if SHGameManager.instance == nil then
		SHGameManager.instance = SHGameManager:create();
	end
	return SHGameManager.instance;
end

return SHGameManager