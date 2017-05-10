LhjGameDataManager = class("LhjGameDataManager");
--import("..views.DdzHelper")
--import("..views.DdzMsgId")
local scheduler = cc.Director:getInstance():getScheduler() 

LhjGameDataManager.instance = nil

function LhjGameDataManager:getInstance()
	if LhjGameDataManager.instance == nil then
		LhjGameDataManager.instance = LhjGameDataManager:create();
	end
	return LhjGameDataManager.instance;
end

function LhjGameDataManager:ctor()

	print("LhjGameDataManager:ctor")
	-- body
	self._states = 1; ---1下注状态  2 显示结果
	self._gameItemResults = nil --本局游戏结果
	self._winMoney = 0; --本局赢取的金钱
	self._winLines = nil; --本局中奖线
	self._cellTimes = 1;--当前底注倍数
	self._enterRoomAndSitDownInfo = nil;---进入游戏保存游戏信息
	self._systemTax = 0 --系统台费
	self._accumulative = 0
	self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	self.moneyInfo = {
		money = self.myPlayerInfo:getMoney(),
		bank = self.myPlayerInfo:getBank(),
	}

	    -- 房间参数信息（进场最少需要多少钱、底注等信息）
    self.roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
    -- 进入需要最小金币数量  和 底注
    self.MinJettonMoney =self.roomInfo[HallGameConfig.SecondRoomMinMoneyLimitKey]
    self.MinJetton = self.roomInfo[HallGameConfig.SecondRoomMinJettonLimitKey]
end



function LhjGameDataManager:OnMsg_Slotma_Start( msgData)
	self._gameItemResults = {}
	for i,v in ipairs(msgData.items or {}) do
		local index = math.ceil(i/5)
		self._gameItemResults[index] = self._gameItemResults[index] or {}
		table.insert(self._gameItemResults[index],v)
	end
	self._winMoney = msgData.money or 0
	self._winLines = msgData.pb_winline
	self._systemTax = msgData.tax or 0
	
	--按照中奖倍数排序
	if self._winLines then
		table.sort(self._winLines,function(tab1,tab2 )
			if tab1.times > tab2.times then
				return true 
			else
				return false 
			end
		end)
	end
end

--本轮结算
function LhjGameDataManager:settlement( )
	self.moneyInfo.money = self.moneyInfo.money  + self._winMoney  - self._systemTax
	self._accumulative = self._accumulative + self._winMoney
end

function LhjGameDataManager:deductedBet( benNum )
	self.moneyInfo.money = self.moneyInfo.money - benNum
end

function LhjGameDataManager:getMoneyInfo( )
	return self.moneyInfo or {money = 0,bank = 0}
end

--累计得分
function LhjGameDataManager:getAccumulative(  )
	return self._accumulative
end

function LhjGameDataManager:getSystemTax(  )
	return self._systemTax
end

--获取当前底注倍数
function LhjGameDataManager:getCellTimes(  )
	return self._cellTimes;
end

--获取赢取的金钱
function LhjGameDataManager:getWinMoney(  )
	return self._winMoney;
end

--获取游戏转轮结果列表
function LhjGameDataManager:getGameItemResults(  )
	return self._gameItemResults;
end
--获取本轮游戏中奖线
function LhjGameDataManager:getWinLines(  )
	return self._winLines;
end

--获取房间信息
function LhjGameDataManager:getRoomInfo()
	return 	self._enterRoomAndSitDownInfo
end

--返回底注
function LhjGameDataManager:getDizhuNum()
	return self.MinJetton
end

--返回最小入场金额
function LhjGameDataManager:getMinJettonMoney(  )
	return self.MinJettonMoney
end

function LhjGameDataManager:clearRoundData(  )
	self._gameItemResults = nil
	self._winMoney = 0
	self._winLines = nil
	self._systemTax = 0
end
---保存进入游戏
function LhjGameDataManager:OnMsg_EnterRoomAndSitDownInfo(msgTab)
	self._enterRoomAndSitDownInfo = msgTab
end

return LhjGameDataManager

