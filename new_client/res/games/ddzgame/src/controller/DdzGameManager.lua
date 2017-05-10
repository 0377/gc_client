local SubGameBaseManager = requireForGameLuaFile("SubGameBaseManager");
DdzGameManager = class("DdzGameManager",SubGameBaseManager);
import(".DdzGameDataManager");
--[[
	游戏控制器
]]
DdzGameManager.MsgName = 
{
	SC_LandStart = 'SC_LandStart', --发牌
	SC_LandInfo = 'SC_LandInfo', --地主信息
	CS_LandCallScore = 'CS_LandCallScore', --叫分
	SC_LandCallScore = 'SC_LandCallScore', ---叫分返回
	SC_LandCallFail  = 'SC_LandCallFail',--// 叫分失败
	CS_LandOutCard = 'CS_LandOutCard', -- 用户出牌
	SC_LandOutCard = 'SC_LandOutCard', --- 出牌返回
	CS_LandPassCard = 'CS_LandPassCard',---放弃出牌
	SC_LandPassCard = 'SC_LandPassCard',----
	SC_LandConclude = 'SC_LandConclude', ---游戏结束
	SC_LandPlayerOffline = 'SC_LandPlayerOffline',---玩家掉线
	SC_LandPlayerOnline = 'SC_LandPlayerOnline',----玩家上线
	SC_LandRecoveryPlayerCard = 'SC_LandRecoveryPlayerCard', -- 恢复上线玩家的牌
	CS_ReconnectionPlay = 'CS_ReconnectionPlay', ---断线重连发送消息
	SC_ReplyPlayerInfoComplete = "SC_ReplyPlayerInfoComplete",---
	SC_LandRecoveryPlayerCallScore = "SC_LandRecoveryPlayerCallScore",--叫分掉线 重连
	SC_LandCallScorePlayerOffline = "SC_LandCallScorePlayerOffline", --有玩家掉线 等待时间
	SC_PlayerReconnection = "SC_PlayerReconnection",--断线重连
	SC_LandRecoveryPlayerDouble = "SC_LandRecoveryPlayerDouble",--恢复上线玩家加倍
	SC_ChatTable = "SC_ChatTable",
	CS_ChangeTable = "CS_ChangeTable", --切换桌子
	SC_ChangeTable = "SC_ChangeTable", ---切换桌子
	SC_LandTrusteeship = "SC_LandTrusteeship",
	CS_LandTrusteeship = "CS_LandTrusteeship",---拖管功能
	SC_StandUp = "SC_StandUp",
	SC_NotifyStandUp = "SC_NotifyStandUp", ---通知同桌站起
	SC_NotifySitDown = "SC_NotifySitDown", ---通知同桌坐下
	CS_Trusteeship = "CS_Trusteeship", --游戏里面退出
	CS_LandCallDouble = "CS_LandCallDouble",--加倍
	SC_LandCallDouble = "SC_LandCallDouble",--加倍返回
	SC_LandCallDoubleFinish = "SC_LandCallDoubleFinish", --加倍后出牌玩家
 	SC_ShowTax = "SC_ShowTax",---显示税收
}

function DdzGameManager:clearLoadedOneGameFiles()
	-- body
	local loaded = package.loaded;
    --重新加载frame内文件
    loaded["DdzGameManager"] = nil;
    loaded["DdzGameDataManager"] = nil;
    loaded["DdzGameScene"] = nil;
    loaded["DdzHelper"] = nil;
    loaded["DdzRules"] = nil;
    loaded["DdzSound"] = nil;
    loaded["DdzGameEntry"] = nil;
    loaded["DdzPlayerInfo"] = nil;
    DdzGameManager.instance = nil;
end

DdzGameManager.instance = nil;
function DdzGameManager:getInstance()
	if DdzGameManager.instance == nil then
		--todo
		DdzGameManager.instance = DdzGameManager:create();
	end
	return DdzGameManager.instance;
end
function DdzGameManager:ctor()
	self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
	--dump(self.gameDetailInfoTab, "self.gameDetailInfoTab", nesting)
	--增加属性
	CustomHelper.addSetterAndGetterMethod(self,"packageRootPath",self.gameDetailInfoTab[HallGameConfig.GamePackageRootPathKey]);--游戏包根目录，在HallGameConfig中配置
	CustomHelper.addSetterAndGetterMethod(self,"dataManager",DdzGameDataManager:create());--游戏数据管理器
	--注册pb文件
	self:registerPBProtocolToHallMsgManager();
	DdzGameManager.super.ctor(self)
	self.subGameTipsConfig = requireForGameLuaFile("DdzTipsConfig");
end
--注册协议到协议解析中
function DdzGameManager:registerPBProtocolToHallMsgManager()
	local pbFileTab = {};
	table.insert(pbFileTab,"common_msg_land.proto");
	local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager();
	for k,v in pairs(pbFileTab) do
		local filePath =  v; --self.packageRootPath.."res/pb_files/" ..
		local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(filePath);
		hallMsgManager:registerProtoFileToPb(pbFullPath);
	end

	--增加解析key
	for k,v in pairs(DdzGameManager.MsgName) do
		print(v,"---")
		hallMsgManager:registerMsgNameToMsgPBMananager(v);
	end
	DdzGameManager.super.registerPBProtocolToHallMsgManager(self)
end

--增加消息处理监听函数
function DdzGameManager:registerNotification()
	
end

function DdzGameManager:setGameRoomInfo()
	self:getDataManager():setGameRoomInfo()
end
---发送进入房间并坐下
function DdzGameManager:sendEnterRoomAndSitDownMsg( )
	-- body
	GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterRoomAndSitDown();
	--self:CS_EnterRoom(); 
end

---UI界面准备好进入房间并坐下
function DdzGameManager:on_SC_PlayerReconnection(msgTab)

	---游戏断线重连 设置游戏已经开始
	self:getDataManager()._isPlaying = true
	---保存数据
	self:getDataManager():_onMsg_SetMySitDownInfo(msgTab)
	
end

---恢复上线玩家 加倍数据
function DdzGameManager:on_SC_LandRecoveryPlayerDouble(msgTab)
	dump(msgTab, "--恢复上线玩家加倍")
	self:getDataManager():_onMsgLandRecoveryPlayerDouble(msgTab)
	
end


---站起并离开房间
function DdzGameManager:sendStandUpAndExitRoomMsg()

	GameManager:getInstance():getHallManager():getHallMsgManager():sendStandUpAndExitRoom()
end



function DdzGameManager:on_SC_StandUpAndExitRoom(msgTab)

	self:getDataManager():_onMsg_NotifySitDown(msgTab)
end

---准备
function DdzGameManager:sendGameReady()
	-- body
	GameManager:getInstance():getHallManager():getHallMsgManager():sendGameReady();
end

---准备返回
function DdzGameManager:on_SC_Ready(msgTab)
	dump(msgTab, "准备------");
	self:getDataManager():_onMsg_SetPlayerReadyState(msgTab)
end


--通知其他人进入房间
function DdzGameManager:on_SC_NotifyEnterRoom(msgTab)

end         

---通知其他人离开房间
function DdzGameManager:on_SC_NotifyExitRoom(msgTab)

end

--通知同桌坐下
function DdzGameManager:on_SC_NotifySitDown(msgTab)
	-- body
	---保存玩家数据
	dump(msgTab, "---通知同桌坐下");
	self:getDataManager():_onMsg_SetSitDownPlayers(msgTab)
end
--自己站起
function DdzGameManager:on_SC_StandUp( msgTab )

end

--通知同桌站起
function DdzGameManager:on_SC_NotifyStandUp(msgTab)

	self:getDataManager():_onMsg_NotifySitDown(msgTab)
end


---发牌
function DdzGameManager:on_SC_LandStart(msgTab)
	self:getDataManager():_onMsg_GameStart(msgTab)
	-- body
end

---地主信息
function DdzGameManager:on_SC_LandInfo(msgTab)
	-- body
	self:getDataManager():_onMsg_gameBankerInfo(msgTab)
end

---叫分
function DdzGameManager:sendCS_LandCallScore(score)
	-- body
	local  msgTab = {};
	--叫分数目
	msgTab["call_score"] = score+1;
	local msgName = DdzGameManager.MsgName.CS_LandCallScore;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end
---叫分返回
function DdzGameManager:on_SC_LandCallScore(msgTab)
	self:getDataManager():_onMsg_gameCallScore(msgTab)
end

---叫分失败
function DdzGameManager:on_SC_LandCallFail(msgTab)
 	-- body
 	--dump(msgTab,"叫分失败:");
 end 

---用户出牌
function DdzGameManager:sendCS_LandOutCard(cards)
	-- body
	local _cards = {};
	for k,v in pairs(cards) do
		print("v:",v)
		v = v+1
		table.insert(_cards, v)
	end

	--dump(_cards, "出牌")
	local  msgTab = {};
	msgTab["cards"] = _cards;
	local msgName = DdzGameManager.MsgName.CS_LandOutCard;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end	

---出牌返回
function DdzGameManager:on_SC_LandOutCard(msgTab)
	-- body
	dump(msgTab,"出牌返回:");
	self:getDataManager():_onMsg_gameOutCard(msgTab)
end	  

---放弃出牌
function DdzGameManager:sendCS_LandPassCard()
	local  msgTab = {};
	local msgName = DdzGameManager.MsgName.CS_LandPassCard;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end  

---放弃出牌返回
function DdzGameManager:on_SC_LandPassCard(msgTab)
	--dump(msgTab,"放弃出牌返回:");
	self:getDataManager():_onMsg_gamePassCard(msgTab)
end

----游戏结束
function DdzGameManager:on_SC_LandConclude(msgTab)
	dump(msgTab,"游戏结束")
	self:getDataManager():_onMsg_gameOver(msgTab)

end

function DdzGameManager:sendMsgReady( ... )
	-- body
end

--玩家掉线
function DdzGameManager:on_SC_LandPlayerOffline(msgTab)
 	-- body
 	--dump(msgTab, "玩家掉线")
 	
end 

--玩家上线
function DdzGameManager:on_SC_LandPlayerOnline(msgTab)
 	-- body
 	dump(msgTab, "玩家上线")
 	self:getDataManager():_onMsg_GamePlayerOnline(msgTab)
end 


-- 恢复上线玩家的牌
function DdzGameManager:on_SC_LandRecoveryPlayerCard(msgTab)
	-- body
	--dump(msgTab, "恢复上线玩家的牌")
	self:getDataManager():_onMsg_GameStatusPlay(msgTab)
end


--重新连接Ui准备好后 发送这个消息
function DdzGameManager:sendMsgReconnectionPlay()  
	-- body
	--print("-------发送重连")
	local  msgTab = {};
	local msgName = DdzGameManager.MsgName.CS_ReconnectionPlay;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)

end

---收到游戏内的断线重连通知
function DdzGameManager:on_SC_ReplyPlayerInfoComplete(msgTab)
	-- body
	--dump(msgTab, "收到断线重连通知")
	if msgTab~=nil then
		self:sendMsgReconnectionPlay()
	end

end

function DdzGameManager:on_SC_LandRecoveryPlayerCallScore(msgTab)
	-- body
	--dump(msgTab, "叫分上线")
	self:getDataManager():_onMsg_GameRecoveryPlayerCallScore(msgTab)
end	

--有玩家掉线 等待时间
function DdzGameManager:on_SC_LandCallScorePlayerOffline(msgTab)
	--dump(msgTab,"有玩家掉线 等待时间")
	self:getDataManager():_onMsg_GameShowTimeoutWait(msgTab)
end

-- ----
-- function DdzGameManager:sendMsgExit()
-- 	self:setGameRoomInfo();
-- 	local  msgTab = {};
-- 	local msgName = DdzGameManager.MsgName.CS_Exit;
-- 	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
-- end

function DdzGameManager:sendMsgTrusteeship()

	self:setGameRoomInfo();

	local  msgTab = {};
	msgTab["flag"] = 1
	local msgName = DdzGameManager.MsgName.CS_Trusteeship;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

---游戏开始显示坐下的玩家数据
function DdzGameManager:showPlayerSitDownInfo( )
	self:getDataManager():ShowPlayersInfo()
end

---切换桌子
function DdzGameManager:sendMsgChangeTable()
	local  msgTab = {};
	local msgName = DdzGameManager.MsgName.CS_ChangeTable;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end
---切换桌子成功并坐下
function DdzGameManager:on_SC_ChangeTable(msgTab)
	--dump(msgTab, "切换桌子成功并坐下")
	self:getDataManager():initData()

	self:getDataManager():_onMsg_SetMySitDownInfo(msgTab)
	---显示界面
	--self:getDataManager():ShowPlayersInfo(msgTab)
end

---托管
function DdzGameManager:sendMsgLandTrusteeship()
	local  msgTab = {};
	local msgName = DdzGameManager.MsgName.CS_LandTrusteeship;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

---有玩家托管
function DdzGameManager:on_SC_LandTrusteeship(msgTab)
	-- body
	--dump(msgTab, "有玩家托管")
	self:getDataManager():OnUpdateHosting(msgTab)
end


function DdzGameManager:on_SC_ChatTable( msgTab)
	dump(msgTab, "SC_ChatTable")
end

--加倍
function DdzGameManager:sendMsgLandCallDouble(isDouble)
	local  msgTab = {};
	msgTab["is_double"] = isDouble
	local msgName = DdzGameManager.MsgName.CS_LandCallDouble;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)

end

--加倍返回
function DdzGameManager:on_SC_LandCallDouble(msgTab )
	dump(msgTab," 加倍返回")
	self:getDataManager():_onMsgLandCallDouble(msgTab)
end


 --加倍后第一个出牌玩家
function DdzGameManager:on_SC_LandCallDoubleFinish(msgTab)
	self:getDataManager():_onMsgLandCallDoubleFinish(msgTab)
end
return DdzGameManager