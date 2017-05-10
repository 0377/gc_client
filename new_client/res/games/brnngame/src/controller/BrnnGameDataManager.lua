BrnnGameDataManager = class("BrnnGameDataManager");
--import("..views.DdzHelper")
--import("..views.DdzMsgId")
local scheduler = cc.Director:getInstance():getScheduler() 

BrnnGameDataManager.instance = nil

function BrnnGameDataManager:getInstance()
	if BrnnGameDataManager.instance == nil then
		BrnnGameDataManager.instance = BrnnGameDataManager:create();
	end
	return BrnnGameDataManager.instance;
end

BrnnGameDataManager.BankerInfo = 
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


function BrnnGameDataManager:ctor()

	print("BrnnGameDataManager:ctor")
	-- body
	self._userInfo = nil   --用于存储自己的ID 和 coin
	self._userList = nil   --用于存储所有玩家的信息
	self._bankerInfo = nil --庄家的信息
	self._gamenEndBankerInfo = nil ---游戏结束庄家的信息 只用于界面显示


	self._everyAreaInfo = nil
	self._applyBankerList = nil --申请上庄列表(用charid做KEY)
	self._reallyApplyBankerList = nil --真正的申请上庄列表(数组存储)
	self._userIdApplyBankerList = nil --申请上庄列表(用userID做KEY)
	

	self.GAME_FREE =   0
	self.GAME_JETTON   =   1
	self.GAMEOVER  =   2



	self._states = 1; ---1准备状态 2下注状态 3结束
	self._myMoney =  0; ---自己的钱
	self._scoreAreaMoney = {}; ----每个区域压注的钱
	self._currentAreaMoeny = {}; ---当前区域压注的钱
	self._scoreAreaTotalMoney = {}; ---每个区域押注总的钱
	self._maxBetScore = 0; ---最大下注总额
	self._leftMoneyBet = 0 --- 还可下注金额
	self._totalAllAreaBetMoney = 0; ---所有区域下注金币总计
	self._cards = {} ---卡牌
	self._cardResult = nil ---牌型结果
	self._gameEndData = nil
	self._areaCoins = {}    --每个区域的下注总额
    self._areaMeCoins = {}  --每个区域自己的下注总额
    self._tempAreaCoins = {};
    self._myAreaBetRecord_1 = {} ---每个区域下注记录
    self._myAreaBetRecord_2 = {}
    self._myAreaBetRecord_3 = {}
    self._myAreaBetRecord_4 = {}
    self._bankerLists = {}
    self._recordData = {}; ---记录板数据
    self._aNewBoard = false; ---true 新的一轮 
    self._isMyBet = false;---是否下注
    self._gameChipInfo = {}; --游戏筹码
    self._gameBanker_limit = 0; ---上庄条件
    self._compareResult = nil; ---庄家和区域比较结果
    self._enterRoomAndSitDownInfo = nil;---进入游戏保存游戏信息
    self._gameSeverStop = nil;

end



function BrnnGameDataManager:getMyUserInfo()
	-- body
	return self._userInfo
end

function BrnnGameDataManager:getGameDownTime( )
	return self._count_down_time
end

---玩家列表
function BrnnGameDataManager:getUserList()
	return self._userList
end

---游戏状态
function BrnnGameDataManager:getGameStates()
	return self._states
end

----自己的钱
function BrnnGameDataManager:getMyMoney( )
	return self._myMoney
end

----最大下注总额
function BrnnGameDataManager:getMaxBetScore()
	return self._maxBetScore
end

----还可下注金额
function BrnnGameDataManager:getLeftMoenyBet()
	return self._leftMoneyBet
end

---所有区域下注金币总计
function BrnnGameDataManager:getTotalAllAreaBetMoeny()
	return self._totalAllAreaBetMoney
end

----获取自己在每个区域下注的钱
function BrnnGameDataManager:getScoreAreaTotalMoney()
	return self._scoreAreaMoney;
end

---获取是否自己下注
function BrnnGameDataManager:getMyMoenyBet()
	-- body
	return self._isMyBet
end

---获取自己本次下注
function BrnnGameDataManager:getAreaMeCoins( )
	-- body
	return self._areaMeCoins;
end

---获取当前下注的消息
function BrnnGameDataManager:getCurrentAreaMoeny( )
	-- body
	return self._currentAreaMoeny
end

---获取每个区域总的下注钱
function BrnnGameDataManager:getEachTranslateTotalMoeny()
	return self._scoreAreaTotalMoney;
end

---获取扑克
function BrnnGameDataManager:getCards()
	-- body
	return self._cards;
end

---获取牌型
function BrnnGameDataManager:getCardsTypeResult()
	
	return self._cardResult;
end

---获取游戏结算数据
function BrnnGameDataManager:getGameEndData()
	-- body
	return self._gameEndData;
end

function BrnnGameDataManager:getBankerLists()
	-- body
	return self._bankerLists;
end

-----获取庄家的信息
function BrnnGameDataManager:getBankerInfo( )
	-- body
	return self._bankerInfo
end

function BrnnGameDataManager:getGameEndBankerInfo()
	return self._gamenEndBankerInfo
end

-----获取记录信息
function BrnnGameDataManager:getRecordData( )
	-- body
	return self._recordData
end

----获取自己的下注信息
function BrnnGameDataManager:getMySreaCoins()
	-- body
	--dump(self._areaCoins, "self._areaCoins")
	return self._areaCoins
end

----获取所有下注记录
function BrnnGameDataManager:getMyAreaBetRecord( )
	---如果本轮没有下注就不记录 
	local chipNum = 0
	for k,v in pairs(self._tempAreaCoins) do
		chipNum = chipNum+v
	end
	if chipNum > 0 then
		self._areaCoins = self._tempAreaCoins
	end 
end


----清空所有下注记录
function BrnnGameDataManager:deleteMyAreaBetRecord()

end


----获取游戏筹码
function BrnnGameDataManager:getGameChipInfo()
	-- body
	return self._gameChipInfo;
end

----获取上庄金币
function BrnnGameDataManager:getBankerLimit()
	return self._gameBanker_limit
end

---- 庄家和区域比较结果( ... )
function BrnnGameDataManager:getCompareResult()
	return self._compareResult
end

function BrnnGameDataManager:getRoomInfo()
	return 	self._enterRoomAndSitDownInfo
end

----自己是否有下注记录

---玩家消息
function BrnnGameDataManager:OnMsg_OxPlayerConnection(msgTab)
	
	for i,v in ipairs(msgTab["pb_player_info"]) do
		self._userInfo = v
		break;
	end
	self._myMoney = self._userInfo["money"]
end


---桌面数据
function BrnnGameDataManager:OnMsg_SC_OxTableInfo(msgTab)

	--当前状态
	self._states = msgTab["status"];
	if self._states == 3 then
			---扑克结果
		self:OnMsg_SC_CardResult(msgTab)

		--当前扑克列表
		self:OnMsg_SC_OxDealCard(msgTab)

		self._gameEndData = msgTab["pb_conclude"]
	end
	----每个区域下的总的钱
	self:OnMsg_SC_OxEveryArea(msgTab)


	--当前状态对应倒计时
	self._count_down_time = msgTab["count_down_time"];

	--当前庄家信息
	self._bankerInfo = msgTab["pb_curBanker"];
	
	self:saveBankerInfo()


	self._leftMoneyBet = self._bankerInfo["left_score"] or 0

	self._totalAllAreaBetMoney = 0

	--当前最高金币数前8位游戏玩家
	self._userList = msgTab["pb_player_info_list"];
	--当前庄家列表
	if msgTab["pb_banker_list"]~=nil then
		self:OnMsg_BankerList(msgTab)
	end
	--self._bankerLists = msgTab["BankerList"];
	--self._applyBankerList = msgTab["BankerList"];
	--当前区域下注信息
	self._everyAreaInfo = msgTab["EveryAreaInfo"]
	--当前玩家在每个区域下注
	self._playerBetInfo = msgTab["Player_bet_info"]
	
	--self._cards = msgTab["Cards"]
	--玩家结果
	self._playerConclude = msgTab["OxPlayerConclude"]


	if msgTab["pb_player_area_bet_info"] ~= nil then
		--todo
		self._isMyBet = true
		for k,v in pairs(msgTab["pb_player_area_bet_info"]) do
			self._areaMeCoins[v["which_area"]] = v["bet_money"]
		end
	end
	--dump(self._areaMeCoins,"self._areaMeCoins")

end

---用户列表
function BrnnGameDataManager:OnMsg_SC_OxPlayerList(msgTab)

	 self._userList = msgTab["pb_player_info_list"];
end

---游戏状态
function BrnnGameDataManager:OnMsg_SC_OxSatusAndDownTime(msgTab)

	self._states = msgTab["status"]
	if self._states == 1 or self._states == 2  then
		--todo
		self._aNewBoard = true;
		self._tempAreaCoins = {}
		self._areaMeCoins = {}
	end

	self._count_down_time = msgTab["count_down_time"]
end

----自己下注信息
function BrnnGameDataManager:OnMsg_SC_OxAddScore(msgTab)

	self._isMyBet = false

	self._currentAreaMoeny = {}
	----总的下了多少
	self._scoreAreaMoney[msgTab["score_area"]] = msgTab["player_bet_this_area_money"]

	self._currentAreaMoeny[msgTab["score_area"]] = msgTab["score"];
	----下注ID
	if self._userInfo~=nil and (self._userInfo["guid"] ==  msgTab["add_score_chair_id"])  then
		
		self._isMyBet = true

		---新一轮 有下注才会清除之前的下注记录
		if self._aNewBoard == true then

			--self._areaCoins = {}
			
			self._aNewBoard = false;
		end

		local area = msgTab["score_area"]
		---在这个区域总下注
        --self._areaCoins[area] = msgTab["player_bet_this_area_money"]
        self._tempAreaCoins[area] = msgTab["player_bet_this_area_money"]
       
        ---在这个区域这次下注多少
        local chip = self._areaMeCoins[area] or 0
        local score = msgTab["score"]
        local total = score + chip
        ---总的钱
    	self._areaMeCoins[area] = total
		---剩余钱
		self._myMoney = msgTab["money"]

		if area == 1 then
        	table.insert(self._myAreaBetRecord_1, chip)
        elseif area == 2 then
        	table.insert(self._myAreaBetRecord_2, chip)
        elseif area == 3 then
        	table.insert(self._myAreaBetRecord_3, chip)
        elseif area == 4 then
        	table.insert(self._myAreaBetRecord_4, chip)
        end
    end
end


----每个区域下注总的钱
function BrnnGameDataManager:OnMsg_SC_OxEveryArea(msgTab)
	local pb_AreaInfo = msgTab["pb_AreaInfo"]
	if pb_AreaInfo == nil then
		--todo
		return;
	end
	self._scoreAreaTotalMoney[1] = pb_AreaInfo["bet_tian_total"] or 0
	self._scoreAreaTotalMoney[2] = pb_AreaInfo["bet_di_total"] or 0
	self._scoreAreaTotalMoney[3] = pb_AreaInfo["bet_xuan_total"] or 0
	self._scoreAreaTotalMoney[4] = pb_AreaInfo["bet_huang_total"] or 0
	self._totalAllAreaBetMoney = pb_AreaInfo["total_all_area_bet_money"]
	self._maxBetScore = pb_AreaInfo["max_bet_score"] or 0; ---最大下注总额
	self._leftMoneyBet = pb_AreaInfo["left_money_bet"] or 0--- 还可下注金额
end
                                                                                                                                                                                                                                                                


---显示卡牌
function BrnnGameDataManager:OnMsg_SC_OxDealCard(msgTab)
	-- body
	local pb_cards = msgTab["pb_cards"]
	for k,v in pairs(pb_cards) do
		self._cards[k] = v["card"];
	end
end


----保存结果
function BrnnGameDataManager:OnMsg_SC_CardResult(msgTab)

	self._cardResult = msgTab["pb_result"];
end

----游戏结算数据
function BrnnGameDataManager:OnMsg_SC_GameEnd(msgTab)
	
	self._gamenEndBankerInfo = self._bankerInfo
	self._gameEndData = msgTab["pb_player_result"]
	local  earn_score = self._gameEndData["earn_score"] or 0
	

	if self:isMyBanker() == true then
		 
	else
		if self._gameEndData["money"] ~= nil then
			if self._userInfo["moeny"] == nil then
				self._userInfo["moeny"] = {}
			end
			self._userInfo["moeny"] = self._gameEndData["money"]
			self._myMoney = self._gameEndData["money"]
			print("self._myMoney:",self._myMoney)
		end
	end
end

---申请上庄的列表
function BrnnGameDataManager:OnMsg_BankerList(msgTab)
	-- body
	self._bankerLists = msgTab["pb_banker_list"];
end

---当前当庄的信息
function BrnnGameDataManager:OnMsg_BankerInfo(msgTab)
	-- body
	self._bankerInfo = msgTab["pb_banker_info"]
	self._leftMoneyBet = self._bankerInfo["left_score"]
	self:saveBankerInfo()
	self._totalAllAreaBetMoney = 0
	if self:isMyBanker() == true then
		self._userInfo["moeny"] = self._bankerInfo["money"]
		self._myMoney = self._bankerInfo["money"]
	end
end

function BrnnGameDataManager:saveBankerInfo()

	BrnnGameDataManager.BankerInfo.guid = self._bankerInfo["guid"];
    BrnnGameDataManager.BankerInfo.nickname = self._bankerInfo["nickname"] or 0;   --昵称
    BrnnGameDataManager.BankerInfo.money = self._bankerInfo["money"] or 0;      ---当前金币数
    BrnnGameDataManager.BankerInfo.bankertimes = self._bankerInfo["bankertimes"] or 0; ---连庄次数
    BrnnGameDataManager.BankerInfo.max_score = self._bankerInfo["max_score"] or 0;  ---最大下注
    BrnnGameDataManager.BankerInfo.banker_score = self._bankerInfo["banker_score"] or 0; ---成绩
    BrnnGameDataManager.BankerInfo.left_score = self._bankerInfo["left_score"] or 0;  ---剩余还可下注金币数
    BrnnGameDataManager.BankerInfo.header_icon = self._bankerInfo["header_icon"] or 0;    --- 头像

    print("BrnnGameDataManager.BankerInfo.money:",BrnnGameDataManager.BankerInfo.money)
end

----记录输赢信息
function BrnnGameDataManager:OnMsg_RecordInfo(msgTab)
	
	local recordInfo = msgTab["pb_recordresult"]
	if recordInfo then
		--todo
		if #recordInfo > 1 then
		self._recordData = recordInfo
		elseif #recordInfo == 1 then
			if #self._recordData == 10 then
				table.remove(self._recordData,1)
			end
			table.insert(self._recordData,recordInfo[1])
		end
	end

	--table.insert(self._recordData,oneRecord[1])
	--self._recordData = msgTab["pb_recordresult"]
end

---自己是不是庄家
function BrnnGameDataManager:isMyBanker()
	-- body
	if self._userInfo == nil then
		return false
	end
	local myGuid = self._userInfo["guid"] or 1
	local bankerGuid = BrnnGameDataManager.BankerInfo.guid or 2
	if myGuid ~= bankerGuid then
		return false
	end
	return true
end

function BrnnGameDataManager:OnMsg_GameConfigInfo(msgTab)

	self._gameBanker_limit = msgTab["banker_limit"] 

	for i,v in ipairs(msgTab["pb_info_chip"]) do
		table.insert(self._gameChipInfo,v["chip_money"])
	end
end

function BrnnGameDataManager:OnMsg_CompareResult(msgTab)
	self._compareResult = msgTab["pb_CompareResult"]
end


----游戏停服消息
function BrnnGameDataManager:OnMsg_GameServerStop(msgTab)
	self._gameSeverStop = msgTab
end

---保存进入游戏
function BrnnGameDataManager:OnMsg_EnterRoomAndSitDownInfo(msgTab)
	self._enterRoomAndSitDownInfo = msgTab
end

---获取自己游戏是否停服
function BrnnGameDataManager:getMyGameSeverStop()
	local myGameStop = false
	local mygameSeverID = self._enterRoomAndSitDownInfo["game_id"]
	local gameSeverIDStop = self._gameSeverStop["game_id"]
	if mygameSeverID == gameSeverIDStop then
	 	myGameStop = true;
	end
	return myGameStop
end

return BrnnGameDataManager

