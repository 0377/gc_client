local SubGameBaseManager = requireForGameLuaFile("SubGameBaseManager");
QznnGameManager = class("QznnGameManager",SubGameBaseManager);
import(".QznnGameDataManager");
--[[
	游戏控制器
]]
QznnGameManager.CardType = 
{
	
	BANKER_CARD_TYPE_NONE           = 100;  --//无牛
	BANKER_CARD_TYPE_ONE            = 101;  --//牛1
	BANKER_CARD_TYPE_TWO            = 102;  --//牛2
	BANKER_CARD_TYPE_THREE 			= 103;  --//牛3
	BANKER_CARD_TYPE_FOUR 			= 104;  --//牛4
	BANKER_CARD_TYPE_FIVE 			= 105;  --//牛5
	BANKER_CARD_TYPE_SIX 			= 106;  --//牛6
	BANKER_CARD_TYPE_SEVEN 			= 107;  --//牛7
	BANKER_CARD_TYPE_EIGHT 			= 108;  --//牛8
	BANKER_CARD_TYPE_NINE 			= 109;  --//牛9
	BANKER_CARD_TYPE_TEN			= 110;  --//牛10	牛牛
	BANKER_CARD_TYPE_FOUR_KING		= 201;  --//4花牛 银牛
	BANKER_CARD_TYPE_FIVE_KING		= 202;  --//5花牛 金牛
	BANKER_CARD_TYPE_FOUR_SAMES		= 203;  --//4炸
	BANKER_CARD_TYPE_FIVE_SAMLL		= 204;  --//5小牛
	BANKER_CARD_TYPE_ERROR			= 1;
}




--游戏状态
QznnGameManager.TexasStatus =
{
	STATUS_SEND_CARDS		= 1;	--//发牌阶段
	STATUS_CONTEND_BANKER	= 2;	--//抢庄阶段
	STATUS_DICISION_BANKER	= 3;	--//定庄阶段
	STATUS_BET				= 4;	--//下注阶段
	STATUS_SHOW_CARD		= 5;	--//摊牌阶段
	STATUS_SHOW_DOWN		= 6;	--//结算
}








QznnGameManager.MsgName = 
{
	--CS_OxPlayerConnectGame = "CS_OxPlayerConnectGame", --/玩家进入游戏或重连
	SC_BankerTableMatching = "SC_BankerTableMatching",---//匹配
	SC_BankerSendCards = "SC_BankerSendCards", ---//发牌
	SC_BankerBeginToContend = "SC_BankerBeginToContend",---//开始抢庄
	SC_BankerPlayerContend = "SC_BankerPlayerContend",---//其它玩家的抢庄倍数
	SC_BankerChoosingBanker = "SC_BankerChoosingBanker", --//定庄

 	SC_BankerPlayerBeginToBet = "SC_BankerPlayerBeginToBet",--//闲家开始下注
 	SC_BankerPlayerBet = "SC_BankerPlayerBet",---//闲家下注
	SC_BankerShowOwnCards = "SC_BankerShowOwnCards", ---//玩家看到自己的牌
	SC_BankerShowCards = "SC_BankerShowCards", ---//展示牌桌各玩家牌	消息个数=玩家人数
	SC_BankerGameEnd = "SC_BankerGameEnd", ---//结算
	
	SC_BankerForceToLeave = "SC_BankerForceToLeave",--//强制离开
	SC_BankerReconnectInfo = "SC_BankerReconnectInfo", --//断线重入 房间汇总信息/等待信息
	--SC_TexasGiveTips = "SC_TexasGiveTips", --打赏
	
	CS_BankerEnter = "CS_BankerEnter", --//玩家进入游戏
	CS_BankerLeave = "CS_BankerLeave", --//玩家离开游戏
	CS_BankerContend = "CS_BankerContend", --//抢庄
	CS_BankerPlayerBet = "CS_BankerPlayerBet", --//闲家下注
	CS_BankerPlayerGuessCards = "CS_BankerPlayerGuessCards", --//猜牌
	CS_BankerNextGame = "CS_BankerNextGame", --//下一局
	

}

function QznnGameManager:clearLoadedOneGameFiles()
	
    QznnGameManager.instance = nil;
end

----1准备状态
----2可以下注
QznnGameManager.instance = nil;
function QznnGameManager:getInstance()
	if QznnGameManager.instance == nil then
		QznnGameManager.instance = QznnGameManager:create();
	end
	return QznnGameManager.instance;
end



function QznnGameManager:ctor()
	
	--local tt = QznnGameDataManager:create()

	self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
	CustomHelper.addSetterAndGetterMethod(self,"packageRootPath",self.gameDetailInfoTab[HallGameConfig.GamePackageRootPathKey]);--游戏包根目录，在HallGameConfig中配置
	CustomHelper.addSetterAndGetterMethod(self,"dataManager",QznnGameDataManager:create());--游戏数据管理器
	--注册pb文件
	self:registerPBProtocolToHallMsgManager();
end
--注册协议到协议解析中
function QznnGameManager:registerPBProtocolToHallMsgManager()
	local pbFileTab = {};
	table.insert(pbFileTab,"common_msg_banker.proto");
	local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager();
	for k,v in pairs(pbFileTab) do
		local filePath =  v; --self.packageRootPath.."res/pb_files/" ..
		local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(filePath);
		hallMsgManager:registerProtoFileToPb(pbFullPath);
	end

	--增加解析key
	for k,v in pairs(QznnGameManager.MsgName) do
		hallMsgManager:registerMsgNameToMsgPBMananager(v);
	end
end


--增加消息处理监听函数
function QznnGameManager:registerNotification()
	
end


----//抢庄
function QznnGameManager:sendBankerContend(rt)
	-- body
	local msgTab = {ratio = rt}
	local msgName = QznnGameManager.MsgName.CS_BankerContend;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

----//闲家下注
function QznnGameManager:sendBankerPlayerBet(money)
	-- body
	local msgTab = {bet_money = money}
	local msgName = QznnGameManager.MsgName.CS_BankerPlayerBet;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end



----开始游戏获取数据
function QznnGameManager:sendPlayerReconnection()
	
	-- body
	local msgTab = {}
	local msgName = QznnGameManager.MsgName.CS_BankerEnter;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

----//猜牌
function QznnGameManager:sendBankerPlayerGuessCards()
	-- body
	local msgTab = {}
	local msgName = QznnGameManager.MsgName.CS_BankerPlayerGuessCards;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end


----离开
function QznnGameManager:sendPlayerLeave()
	-- body
	local msgTab = {}
	local msgName = QznnGameManager.MsgName.CS_BankerLeave;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end


----//下一局
function QznnGameManager:sendPlayerOperate()

	
	
	-- body
	local msgTab = {}
	local msgName = QznnGameManager.MsgName.CS_BankerNextGame;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end





function QznnGameManager:on_SC_BankerTableMatching(msgTab)
	-- body
	
	print( "//匹配")
	--dump(msgTab)
	self.dataManager:OnSC_BankerTableMatching(msgTab)
	
end

function QznnGameManager:on_SC_BankerSendCards(msgTab)
	-- body
	print( "//发牌")
	--dump(msgTab)
	self.dataManager:on_SC_BankerSendCards(msgTab)
end

function QznnGameManager:on_SC_BankerBeginToContend(msgTab)
	-- body
	print( "//开始抢庄")
	--dump(msgTab)
	self.dataManager:on_SC_BankerBeginToContend(msgTab)
end

function QznnGameManager:on_SC_BankerPlayerContend(msgTab)
	-- body
	print( "//其它玩家的抢庄倍数")
	--dump(msgTab)
	self.dataManager:on_SC_BankerPlayerContend(msgTab)
end


function QznnGameManager:on_SC_BankerChoosingBanker(msgTab)
	-- body
	print( "//定庄")
	--dump(msgTab)
	self.dataManager:on_SC_BankerChoosingBanker(msgTab)
end

function QznnGameManager:on_SC_BankerPlayerBeginToBet(msgTab)
	-- body
	print( "//闲家开始下注")
	--dump(msgTab)
	self.dataManager:on_SC_BankerPlayerBeginToBet(msgTab)
end
function QznnGameManager:on_SC_BankerPlayerBet(msgTab)
	-- body
	print( "//闲家下注")
	--dump(msgTab)
	self.dataManager:on_SC_BankerPlayerBet(msgTab)
end

function QznnGameManager:on_SC_BankerShowOwnCards(msgTab)
	-- body
	print( "//玩家看到自己的牌")
	--dump(msgTab)
	self.dataManager:on_SC_BankerShowOwnCards(msgTab)
end



function QznnGameManager:on_SC_BankerShowCards(msgTab)
	-- body
	print( "//展示牌桌各玩家牌	消息个数=玩家人数")
	--dump(msgTab)
	self.dataManager:on_SC_BankerShowCards(msgTab)
end

function QznnGameManager:on_SC_BankerGameEnd(msgTab)
	-- body
	print( "//结算")
	--dump(msgTab)
	self.dataManager:on_SC_BankerGameEnd(msgTab)
end

function QznnGameManager:on_SC_BankerForceToLeave(msgTab)
	-- body
	print( "//强制离开")
	--dump(msgTab)
	self.dataManager:on_SC_BankerForceToLeave(msgTab)
end

function QznnGameManager:on_SC_BankerReconnectInfo(msgTab)
	-- body
	print( "////断线重入 房间汇总信息/等待信息")
	--dump(msgTab)
	self.dataManager:on_SC_BankerReconnectInfo(msgTab)
end


return QznnGameManager