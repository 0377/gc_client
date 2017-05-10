local SubGameBaseManager = requireForGameLuaFile("SubGameBaseManager");
DzpkGameManager = class("DzpkGameManager",SubGameBaseManager);
import(".DzpkGameDataManager");
--[[
	游戏控制器
]]
DzpkGameManager.CardType = 
{
	
	CT_HIGH_CARD			= 1;								--//单牌类型
	CT_ONE_PAIR				= 2;								--//对子类型
	CT_TWO_PAIRS			= 3;								--//两对类型
	CT_THREE_OF_A_KIND		= 4;								--//三条类型
	
	CT_STRAIGHT				= 5;								--//顺子类型
	CT_FLUSH				= 6;								--//同花类型
	CT_FULL_HOUSE			= 7;								--//葫芦类型
	CT_FOUR_OF_KIND			= 8;								--//四条类型
	CT_STRAIT_FLUSH			= 9;								--//同花顺型
	CT_ROYAL_FLUSH			= 10;								--//皇家同花顺
}





--动作类型
DzpkGameManager.TexasAction = 
{
	ACT_CALL 	= 1,--跟注
	ACT_RAISE 	= 2,--加注
	ACT_CHECK 	= 3,--让牌
	ACT_FOLD 	= 4,--弃牌
	ACT_ALL_IN 	= 5,--全下
	ACT_NORMAL 	= 6,--普通
	ACT_THINK 	= 7,
	ACT_WAITING	= 8--刚进入的玩家
}

--游戏状态
DzpkGameManager.TexasStatus =
{
	STATUS_WAITING			= 1,--等待阶段
	STATUS_PRE_FLOP 		= 2,--第1轮 0张公牌 + 2张底牌
	STATUS_FLOP		 		= 3,--第2轮 3张公牌 + 2张底牌
	STATUS_TURN 			= 4,--第3轮 4张公牌 + 2张底牌
	STATUS_RIVER	 		= 5,--第4轮 5张公牌 + 2张底牌
	STATUS_SHOW_DOWN		= 6--结算
}








DzpkGameManager.MsgName = 
{
	--CS_OxPlayerConnectGame = "CS_OxPlayerConnectGame", --/玩家进入游戏或重连
	SC_TexasTableInfo = "SC_TexasTableInfo",---桌面消息
	SC_TexasSendPublicCards = "SC_TexasSendPublicCards", ---
	SC_TexasSendUserCards = "SC_TexasSendUserCards",---
	SC_TexasUserAction = "SC_TexasUserAction",---
	SC_TexasNewUser = "SC_TexasNewUser", --
 	SC_TexasUserLeave = "SC_TexasUserLeave",--
 	SC_TexasTableEnd = "SC_TexasTableEnd",---
	CS_TexasUserAction = "CS_TexasUserAction", ---
	CS_TexasEnterTable = "CS_TexasEnterTable", ---on_SC_TexasNewUser
	CS_TexasLeaveTable = "CS_TexasLeaveTable", ---
	SC_TexasForceLeave = "SC_TexasForceLeave",
	CS_ChangeTable = "CS_ChangeTable", --切换桌子
	SC_TexasGiveTips = "SC_TexasGiveTips", --打赏
	
	CS_TexasGiveTips = "CS_TexasGiveTips", --打赏请求
	SC_TexasShowCards = "SC_TexasShowCards", --亮牌
	SC_TexasShowCardsPermission = "SC_TexasShowCardsPermission", --允许自己亮牌
	CS_TexasShowCards = "CS_TexasShowCards", --亮牌请求
	

}

function DzpkGameManager:clearLoadedOneGameFiles()
	
    DzpkGameManager.instance = nil;
end

----1准备状态
----2可以下注
DzpkGameManager.instance = nil;
function DzpkGameManager:getInstance()
	if DzpkGameManager.instance == nil then
		DzpkGameManager.instance = DzpkGameManager:create();
	end
	return DzpkGameManager.instance;
end



function DzpkGameManager:ctor()
	
	--local tt = DzpkGameDataManager:create()

	self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
	CustomHelper.addSetterAndGetterMethod(self,"packageRootPath",self.gameDetailInfoTab[HallGameConfig.GamePackageRootPathKey]);--游戏包根目录，在HallGameConfig中配置
	CustomHelper.addSetterAndGetterMethod(self,"dataManager",DzpkGameDataManager:create());--游戏数据管理器
	--注册pb文件
	self:registerPBProtocolToHallMsgManager();
end
--注册协议到协议解析中
function DzpkGameManager:registerPBProtocolToHallMsgManager()
	local pbFileTab = {};
	table.insert(pbFileTab,"common_msg_texas.proto");
	local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager();
	for k,v in pairs(pbFileTab) do
		local filePath =  v; --self.packageRootPath.."res/pb_files/" ..
		local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(filePath);
		hallMsgManager:registerProtoFileToPb(pbFullPath);
	end

	--增加解析key
	for k,v in pairs(DzpkGameManager.MsgName) do
		hallMsgManager:registerMsgNameToMsgPBMananager(v);
	end
end


--增加消息处理监听函数
function DzpkGameManager:registerNotification()
	
end


----打赏请求
function DzpkGameManager:sendGiveTips()
	-- body
	local msgTab = {}
	local msgName = DzpkGameManager.MsgName.CS_TexasGiveTips;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

----亮牌请求
function DzpkGameManager:sendShowCards()
	-- body
	local msgTab = {}
	local msgName = DzpkGameManager.MsgName.CS_TexasShowCards;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end



----开始游戏获取数据
function DzpkGameManager:sendPlayerReconnection()
	
	--self:sendPlayerOperate(1,-1)
	--self:sendPlayerOperate(1,0)
	--self:sendPlayerOperate(1,1)
	--self:sendPlayerOperate(1,2)
	--self:sendPlayerOperate(2,2)
	--self:sendPlayerOperate(2,0)
	
	
	
	-- body
	local msgTab = {}
	local msgName = DzpkGameManager.MsgName.CS_TexasEnterTable;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

----换桌
function DzpkGameManager:sendChangeTable()
	-- body
	local msgTab = {}
	local msgName = DzpkGameManager.MsgName.CS_ChangeTable;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end


----离开
function DzpkGameManager:sendPlayerLeave()
	-- body
	local msgTab = {}
	local msgName = DzpkGameManager.MsgName.CS_TexasLeaveTable;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end


----玩家操作
function DzpkGameManager:sendPlayerOperate(ac,money)

	if money == 0 then
		money = -1
	end
	
	--money = 100
	
	
	-- body
	local msgTab = {action = ac,bet_money = money}
	local msgName = DzpkGameManager.MsgName.CS_TexasUserAction;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end





function DzpkGameManager:on_SC_TexasTableInfo(msgTab)
	-- body
	
	print( "房间信息ttttt")
	--dump(msgTab)
	self.dataManager:OnSC_TexasTableInfo(msgTab)
	
end

function DzpkGameManager:on_SC_TexasSendPublicCards(msgTab)
	-- body
	print( "公共牌-增量")
	--dump(msgTab)
	self.dataManager:on_SC_TexasSendPublicCards(msgTab)
end

function DzpkGameManager:on_SC_TexasSendUserCards(msgTab)
	-- body
	print( "玩家发牌-1s间隔")
	--dump(msgTab)
	self.dataManager:on_SC_TexasSendUserCards(msgTab)
end

function DzpkGameManager:on_SC_TexasUserAction(msgTab)
	-- body
	print( "玩家操作")
	--dump(msgTab)
	self.dataManager:on_SC_TexasUserAction(msgTab)
end


function DzpkGameManager:on_SC_TexasNewUser(msgTab)
	-- body
	print( "进入")
	--dump(msgTab)
	self.dataManager:on_SC_TexasNewUser(msgTab)
end

function DzpkGameManager:on_SC_TexasUserLeave(msgTab)
	-- body
	print( "离开")
	--dump(msgTab)
	self.dataManager:on_SC_TexasUserLeave(msgTab)
end
function DzpkGameManager:on_SC_TexasTableEnd(msgTab)
	-- body
	print( "结算")
	--dump(msgTab)
	self.dataManager:on_SC_TexasTableEnd(msgTab)
end

function DzpkGameManager:on_SC_TexasGiveTips(msgTab)
	-- body
	print( "打赏")
	--dump(msgTab)
	self.dataManager:on_SC_TexasGiveTips(msgTab)
end



function DzpkGameManager:on_SC_TexasShowCards(msgTab)
	-- body
	print( "亮牌")
	--dump(msgTab)
	self.dataManager:on_SC_TexasShowCards(msgTab)
end

function DzpkGameManager:on_SC_TexasShowCardsPermission(msgTab)
	-- body
	print( "允许自己亮牌")
	--dump(msgTab)
	self.dataManager:on_SC_TexasShowCardsPermission(msgTab)
end


return DzpkGameManager