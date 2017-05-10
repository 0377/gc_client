local SubGameBaseManager = requireForGameLuaFile("SubGameBaseManager");
BrnnGameManager = class("BrnnGameManager",SubGameBaseManager);
import(".BrnnGameDataManager");
--[[
	游戏控制器
]]
BrnnGameManager.CardType = 
{
	OX_CARD_TYPE_ERROR						= 0,
	OX_CARD_TYPE_OX_NONE                    = 100,  --无牛
	OX_CARD_TYPE_OX_ONE                     = 101, --1牛
	OX_CARD_TYPE_OX_TWO 					= 102,  --牛牛
	OX_CARD_TYPE_FOUR_KING					= 103,  --4花牛
	OX_CARD_TYPE_FIVE_KING					= 104,  --5花牛
	OX_CARD_TYPE_FOUR_SAMES					= 105,  --4炸
	OX_CARD_TYPE_FIVE_SAMLL					= 106,  --5小牛
}

BrnnGameManager.MsgName = 
{
	CS_OxPlayerConnectGame = "CS_OxPlayerConnectGame", --/玩家进入游戏或重连
	SC_OxPlayerConnection = "SC_OxPlayerConnection",
	SC_OxTableInfo = "SC_OxTableInfo", ---桌面消息
	CS_OxAddScore = "CS_OxAddScore",---用户下注
	SC_OxAddScore = "SC_OxAddScore",---用户下注返回
	SC_OxPlayerList = "SC_OxPlayerList", --推送到计时
 	SC_OxSatusAndDownTime = "SC_OxSatusAndDownTime",--推送状态以及倒计时间
 	SC_OxEveryArea = "SC_OxEveryArea",---显示每个区域的总下注
	SC_OxDealCard = "SC_OxDealCard", ---显示卡牌
	SC_CardResult = "SC_CardResult",---牌型结果
	SC_OxResult = "SC_OxResult", -- 游戏结算
	CS_OxApplyForBanker = "CS_OxApplyForBanker", ----用户上庄
	SC_OxForBankerFlag = "SC_OxForBankerFlag",---上庄返回
	SC_OxBankerList = "SC_OxBankerList",---申请上庄列表
	SC_OxBankerInfo = "SC_OxBankerInfo",---当前庄家信息
	CS_OxLeaveForBanker = "CS_OxLeaveForBanker", ---申请下庄
	SC_OxForBankerFlag = "SC_OxForBankerFlag",--上庄返回
	SC_OxBankerLeaveFlag = "SC_OxBankerLeaveFlag",---取消上庄返回
	CS_OxCurBankerLeave = "CS_OxCurBankerLeave",  -- --正在当庄用户未达到指定次数主动下庄
	CS_OxRecord = "CS_OxRecord",---计分板
	SC_OxRecord = "SC_OxRecord", ---计分板返回
	CS_OxLeaveGame = "CS_OxLeaveGame",
	SC_OxBetCoin = "SC_OxBetCoin",
	SC_Ox_config_info = "SC_Ox_config_info",
	SC_CardCompareResult = "SC_CardCompareResult",
	CS_StandUpAndExitRoom = "CS_StandUpAndExitRoom", --站起并退出房间
	SC_ReplyPlayerInfoComplete = "SC_ReplyPlayerInfoComplete",---
	CS_Exit = "CS_Exit",--游戏里面退出
	CS_ChangeTable = "CS_ChangeTable", --切换桌子
	SC_StandUp = "SC_StandUp",
	SC_NotifyStandUp = "SC_NotifyStandUp",
	SC_NotifySitDown = "SC_NotifySitDown",
	SC_ChangeTable = "SC_ChangeTable", ---切换桌子

}

function BrnnGameManager:clearLoadedOneGameFiles()
	-- body
	local loaded = package.loaded;
    --重新加载frame内文件
    loaded["BrnnGameDataManager"] = nil;
    loaded["BrnnGameManager"] = nil;
    loaded["BrnnGameEnd"] = nil;
    loaded["BrnnConfig"] = nil;
    loaded["BrnnDefine"] = nil;
    loaded["BrnnGameTips"] = nil;
    loaded["NNPoker"] = nil;
    loaded["BrnnGameEntry"] = nil;
    BrnnGameManager.instance = nil;
end

----1准备状态
----2可以下注
BrnnGameManager.instance = nil;
function BrnnGameManager:getInstance()
	if BrnnGameManager.instance == nil then
		BrnnGameManager.instance = BrnnGameManager:create();
	end
	return BrnnGameManager.instance;
end



function BrnnGameManager:ctor()
	BrnnGameManager.super.ctor(self)
	self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
	CustomHelper.addSetterAndGetterMethod(self,"packageRootPath",self.gameDetailInfoTab[HallGameConfig.GamePackageRootPathKey]);--游戏包根目录，在HallGameConfig中配置
	CustomHelper.addSetterAndGetterMethod(self,"dataManager",BrnnGameDataManager:create());--游戏数据管理器
	self.subGameTipsConfig = requireForGameLuaFile("BrnnnTipsConfig");
	--注册pb文件
	self:registerPBProtocolToHallMsgManager();
	
	dump(gameDetailInfoTab)
	--gameDetailInfoTab[beishu] = 2
end
--注册协议到协议解析中
function BrnnGameManager:registerPBProtocolToHallMsgManager()
	local pbFileTab = {};
	table.insert(pbFileTab,"common_msg_ox.proto");
	local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager();
	for k,v in pairs(pbFileTab) do
		local filePath =  v; --self.packageRootPath.."res/pb_files/" ..
		local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(filePath);
		hallMsgManager:registerProtoFileToPb(pbFullPath);
	end

	--增加解析key
	for k,v in pairs(BrnnGameManager.MsgName) do
		hallMsgManager:registerMsgNameToMsgPBMananager(v);
	end
	BrnnGameManager.super.registerPBProtocolToHallMsgManager(self)
end


--增加消息处理监听函数
function BrnnGameManager:registerNotification()
	
end

----开始游戏获取数据
function BrnnGameManager:sendPlayerReconnection()
	-- body
	local msgTab = {}
	local msgName = BrnnGameManager.MsgName.CS_OxPlayerConnectGame;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

function BrnnGameManager:on_SC_OxPlayerConnection(msgTab)
	-- body
	print( "开始游戏返回数据")
	self.dataManager:OnMsg_OxPlayerConnection(msgTab)
end

function BrnnGameManager:on_SC_OxTableInfo(msgTab)
	-- body
	--dump(msgTab, "桌面数据")
	self.dataManager:OnMsg_SC_OxTableInfo(msgTab)
end

function BrnnGameManager:on_SC_OxCountDownTime(msgTab)
	-- body
end

---续投
function BrnnGameManager:sendXuTou()
	-- body
	dump(self.dataManager:getMySreaCoins(), "续投下注记录")
	for k,v in pairs(self.dataManager:getMySreaCoins()) do
		print(k,v)
		self:sendOxAddScore(k,v)
	end
	-- for k,v in pairs(self.dataManager:getMyAreaBetRecord()) do
	-- 	for _k,_v in pairs(v) do
	-- 		self:sendOxAddScore(k,_v)
	-- 	end
	-- end
	-- self.dataManager:deleteMyAreaBetRecord()
	-- dump(self.dataManager:getMyAreaBetRecord(),"续投下注记录")
end
--用户下注
function BrnnGameManager:sendOxAddScore(areaId, coin)
	print(areaId,"areaId:",coin,"coin")
	if self._gameStatus ~= self.GAME_JETTON then
        return
    end
    local msgTab = {}
    msgTab["score_area"] = areaId          --筹码区域
    msgTab["score"] = coin            --加注数目
    local msgName = BrnnGameManager.MsgName.CS_OxAddScore;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
	local time2 = os.clock()  
end

---用户下注返回
function BrnnGameManager:on_SC_OxAddScore(msgTab)

	--dump(msgTab,"用户下注返回")
	local time3 = os.clock()  
	self.dataManager:OnMsg_SC_OxAddScore(msgTab)
	local time2 = os.clock()  
end

--  "add_score_chair_id"         = 160
-- [LUA-print] -     "money"                      = 99999900
-- [LUA-print] -     "msgID"                      = 18007
-- [LUA-print] -     "msgName"                    = "SC_OxAddScore"
-- [LUA-print] -     "player_bet_this_area_money" = 100
-- [LUA-print] -     "score"                      = 100
-- [LUA-print] -     "score_area"                 = 1

---每个区域总的钱
function BrnnGameManager:on_SC_OxEveryArea( msgTab )

 	--dump(msgTab,"每个区域总的钱")
 	self.dataManager:OnMsg_SC_OxEveryArea(msgTab)
 end 

--显示最高排名的8位游戏玩家
function BrnnGameManager:on_SC_OxPlayerList(msgTab)
	self.dataManager:OnMsg_SC_OxPlayerList(msgTab)
	--dump(msgTab,"显示最高排名的8位游戏玩家")
end

--玩家下注错误代码
function BrnnGameManager:on_SC_OxBetCoin(msgTab)
	dump(msgTab,"玩家下注错误代码")
end


---游戏状态
function BrnnGameManager:on_SC_OxSatusAndDownTime(msgTab)
	--dump(msgTab,"游戏状态")
	self.dataManager:OnMsg_SC_OxSatusAndDownTime(msgTab)
end

---显示卡牌
function BrnnGameManager:on_SC_OxDealCard(msgTab)
	-- bod
	--dump(msgTab,"卡牌列表")
	self.dataManager:OnMsg_SC_OxDealCard(msgTab) 
end

---牌型结果
function BrnnGameManager:on_SC_CardResult(msgTab)
	--dump(msgTab,"结果")
	self.dataManager:OnMsg_SC_CardResult(msgTab)
end

---游戏结算
function BrnnGameManager:on_SC_OxResult(msgTab)
	--dump(msgTab, "游戏结算")
	self.dataManager:OnMsg_SC_GameEnd(msgTab)
end

----用户上庄
function BrnnGameManager:sendApplyForBanker()
	local msg = {}
	local userInfo = self.dataManager:getMyUserInfo()
	if userInfo == nil then
		return
	end
	msg["guid"] = userInfo["guid"]
	msg["nickname"] = userInfo["nickname"]
	msg["money"] =  self.dataManager:getMyMoney();
	local msgName = BrnnGameManager.MsgName.CS_OxApplyForBanker;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msg)
end

---用户上庄返回
function BrnnGameManager:on_SC_OxForBankerFlag(msgTab)
	-- body
	--dump(msgTab, "上庄返回")
end

---返回上庄列表
function BrnnGameManager:on_SC_OxBankerList(msgTab)
	-- body
	self.dataManager:OnMsg_BankerList(msgTab)
end


---返回庄家信息
function BrnnGameManager:on_SC_OxBankerInfo(msgTab)
	-- body
	---dump(msgTab,"庄家信息")
	self.dataManager:OnMsg_BankerInfo(msgTab)
end


---申请下庄
function BrnnGameManager:sendOxLeaveForBanker() 
	local msgTab = {}
	local msgName = BrnnGameManager.MsgName.CS_OxLeaveForBanker;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)

end
function BrnnGameManager:on_SC_OxBankerLeaveFlag(msgt)

end


 ----正在当庄用户未达到指定次数主动下庄
function BrnnGameManager:sendOxCurBankerLeave() 
	local msg = {}
	local msgName = BrnnGameManager.MsgName.CS_OxCurBankerLeave;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msg)
end


---计分板
function BrnnGameManager:sendOxRecord()
	local msg = {}
	local msgName = BrnnGameManager.MsgName.CS_OxRecord;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msg)
end

---计分板返回
function BrnnGameManager:on_SC_OxRecord(msgTab)
	--dump(msgTab, "计分板返回")
	self.dataManager:OnMsg_RecordInfo(msgTab)
end

--离开房间
function BrnnGameManager:sendOxLeaveGame(  )
	-- body
	local msg = {}
	local msgName = BrnnGameManager.MsgName.CS_OxLeaveGame;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msg)
end


---站起并离开房间
function BrnnGameManager:sendStandUpAndExitRoomMsg()

	GameManager:getInstance():getHallManager():getHallMsgManager():sendStandUpAndExitRoom()
end

-----
function BrnnGameManager:on_SC_Ox_config_info(msgTab)
	dump(msgTab,"msgTab")
	self.dataManager:OnMsg_GameConfigInfo(msgTab)
end

function BrnnGameManager:on_SC_CardCompareResult(msgTab)
	dump(msgTab, "比较结果")
	self.dataManager:OnMsg_CompareResult(msgTab)
end

----游戏停服消息
function BrnnGameManager:on_SC_GameServerStop(msgTab)
	self.dataManager:OnMsg_GameServerStop(msgTab)
end
















function BrnnGameManager:on_SC_StandUpAndExitRoom(msgTab)
 	--dump(msgTab,"msgTab")

end


--通知其他人进入房间
function BrnnGameManager:on_SC_NotifyEnterRoom(msgTab)
	-- body
	--dump(msgTab, "通知其他人进入房间");
	--self:getDataManager():on_SetSitDownPlayers(msgTab)
end         

---通知其他人离开房间
function BrnnGameManager:on_SC_NotifyExitRoom(msgTab)

	--dump(msgTab, "---通知其他人离开房间");
end

--通知同桌坐下
function BrnnGameManager:on_SC_NotifySitDown(msgTab)
	-- body
	---保存玩家数据
	--dump(msgTab, "---通知同桌坐下");
	---self:getDataManager():_onMsg_SetSitDownPlayers(msgTab)
end
--自己站起
function BrnnGameManager:on_SC_StandUp( msgTab )
	-- body
	--dump(msgTab,"自己站起")
	--self:getDataManager():_onMsg_NotifySitDown(msgTab)
end

--通知同桌站起
function BrnnGameManager:on_SC_NotifyStandUp(msgTab)

	--dump(msgTab, "---通知同桌站起");
	--self:getDataManager():_onMsg_NotifySitDown(msgTab)
end




return BrnnGameManager