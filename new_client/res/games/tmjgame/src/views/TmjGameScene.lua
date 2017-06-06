-------------------------------------------------------------------------
-- Desc:    二人麻将场景
-- Author:  zengzx
-- Date:    2017.4.10
-- Last: 
-- Content:  二人麻将游戏场景
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjGameScene = class("TmjGameScene",requireForGameLuaFile("SubGameBaseScene"))
local TmjConfig = import("..cfg.TmjConfig")
local TmjHelper = import("..cfg.TmjHelper")
local TmjGameMatchingLayer = requireForGameLuaFile("TmjGameMatchingLayer")
local TmjFanXinInfoLayer = requireForGameLuaFile("TmjFanXinInfoLayer")
local TmjGameLayer = requireForGameLuaFile("TmjGameLayer")
local TmjSettleWinLoseLayer = requireForGameLuaFile("TmjSettleWinLoseLayer")
local TmjSettleDrawnLayer = requireForGameLuaFile("TmjSettleDrawnLayer")
local TmjOperationFactory = requireForGameLuaFile("TmjOperationFactory")
--GameManager:getInstance():getHallManager():getSubGameManager()
function TmjGameScene.getNeedPreloadResArray()
	local resNeed = {
	"game_res/animation/ermj_px_eff/ermj_px_eff.ExportJson"
	}
	return resNeed
end
function TmjGameScene:ctor()
	TmjGameScene.super.ctor(self)
	self.logTag = self.__cname..".lua"
	self:setName("TmjGameScene")
	self:enableNodeEvents()
	
	--座位信息 按照座位ID作为Key存储
	self.seats = {}
	
	self.TmjGameDataManager = TmjGameManager:getInstance():getDataManager()
	
	self.isTrustee = false --是否托管状态
	self.operationComlete = true --动作执行完成
end

----注册消息
function TmjGameScene:registerNotification()
    TmjGameScene.super.registerNotification(self)
	
	for _,msgName in pairs(TmjConfig.MsgName) do
		--注册SC开头的消息
		if string.match(msgName,"SC_(.+)") then
			sslog(self.logTag,"注册消息 "..msgName)
			self:addOneTCPMsgListener(msgName)
		end
	end
end

function TmjGameScene:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"]
	--如果是我这边注册的消息
	if table.keyof(TmjConfig.MsgName,msgName) then
		local methodName = "onMsg"..msgName
		if self[methodName] then
			self[methodName](self)
		end
	end
    TmjGameScene.super.receiveServerResponseSuccessEvent(self,event)
end

--初始化玩法界面
function TmjGameScene:initPlayLayer()
	if TmjHelper.isLuaNodeValid(self.gameLayer) then
		self.gameLayer:removeAllChildren()
		self.gameLayer:removeFromParent()
	end
	
	self.gameLayer = TmjGameLayer:create(self)
	self:addChild(self.gameLayer,TmjConfig.LayerOrder.GAME_LAYER)
	self.gameLayer:hideCenterPanel()
	self.gameLayer:setExitCallBack(handler(self,self.exitGame))

	--self.gameLayer:setTaskData({taskType = 1,taskCard = 10,taskRate = 2 })
end
--显示等待界面
function TmjGameScene:showWaiting()
	self:closeWaiting()
	local mathcingLayer = TmjGameMatchingLayer:create(handler(self,self.exitGame))
	mathcingLayer:setName("mathcingLayer")
	self:addChild(mathcingLayer,TmjConfig.LayerOrder.TmjGameMatchingLayer)
end

function TmjGameScene:closeWaiting()
	self:removeChildByName("mathcingLayer")
end

function TmjGameScene:onEnter()
	sslog(self.logTag,"二人麻将onEnter")
    local gameingInfoTable = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
    if gameingInfoTable == nil then
        ---发送准备
        TmjGameManager:getInstance():sendGameReady()
    else
		--发送重连
        TmjGameManager:getInstance():sendReconnectMsg()
    end
	self:initPlayLayer()
	self:showWaiting()
--[[	self:initPlayer({path = "TmjMyPlayer",seatid = 1})
	self:initPlayer({path = "TmjOtherPlayer",seatid = 2})
	self:closeWaiting()--]]
--[[	local arr = {
	[1]=1,
	[2]=1,
	[3]=1,
	[4]=0,
	[5]=1,
	[6]=1,
	[7]=1,
	[8]=1,
	[9]=0,
	[10]=0,
	[11]=1,
	[12]=0,
	[13]=0,
	[14]=0,
	[15]=0,
	[16]=0,
		}
	local TmjCardTip = import("..cfg.TmjCardTip")
	ssdump(TmjCardTip.isTingHu(arr,11))--]]
	
end

function TmjGameScene:onExit()
	sslog(self.logTag,"二人麻将onExit")
	if self.seats then
		table.walk(self.seats,function (v,k)
			self:deletePlayer(k)
		end)
	end
	
end

function TmjGameScene:onEnterTransitionFinish()
	sslog(self.logTag,"二人麻将onEnterTransitionFinish")
end

function TmjGameScene:onExitTransitionStart()
	sslog(self.logTag,"二人麻将onExitTransitionStart")
end


--开局消息UI处理
function TmjGameScene:onMsgSC_Maajan_Desk_Enter()
	--开局后 播放音乐
	local musicSwitch = GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
	if musicSwitch then
		GameManager:getInstance():getMusicAndSoundManager():playMusicWithFile(HallSoundConfig.BgMusic.Hall)
	end
	
	local playerdatas = self.TmjGameDataManager.playerdatas
	local selfCharId = self.TmjGameDataManager.selfChairId --我自己的座位号
	local zhuangId = self.TmjGameDataManager.zhuangId --庄家的ID
	local taskData = self.TmjGameDataManager.taskData --任务数据
	--是否是恢复对局消息
	local isReconnect = self.TmjGameDataManager.isReconnect
	sslog(self.logTag,"开局消息")
	if not playerdatas then
		--消息处理异常
		sslog(self.logTag,"开局消息处理异常")
		return
	end
	self:closeWaiting()
	--这里应该先删除玩家 
	self:removeAllPlayer()
	
	TmjOperationFactory:getInstance():clearOperation()
	--初始化任务
	if TmjHelper.isLuaNodeValid(self.gameLayer) then
		self.gameLayer:setTaskData(taskData)
	end
	
	
	--self.operationComlete = isReconnect
	sslog(self.logTag,self.operationComlete)
	sslog(self.logTag,isReconnect)
	--播放完成开始动画之后的动作
	local function createPlayers()
		
		for charId,pdata in pairs(playerdatas) do
			local playerInfo = {}
			table.merge(playerInfo,pdata)
			playerInfo.seatid = charId
			if charId==selfCharId then
				playerInfo.path = "TmjMyPlayer"
				self:initPlayer(playerInfo)
			else
				playerInfo.path = "TmjOtherPlayer"
				self:initPlayer(playerInfo)
			end
			--创建牌
			if self.seats[charId] then
				self.seats[charId]:createCards(pdata.handCards,isReconnect,function ()
					
					--self:onMsgSC_Maajan_Discard_Round()--手动调用，该谁出牌了
					local isSetHand = self.seats[charId]:checkToSetLastHandCard()
					if isSetHand and charId == selfCharId then --这里要检查一下我的牌能不能胡，听
						self.seats[charId]:showStartHuOperation(nil)
					end
					--self.operationComlete = true --动作执行完毕
					self:loopMsgOperation()--继续查看队列需要操作的消息
					
				end)
				--如果吃，碰，杠，是有数据，就是回复对局
				if pdata.extraCards then
					table.walk(pdata.extraCards,function (extraData,k)
						--extraData.value --牌值
						--extraData.type 执行类型
						self.seats[charId]:doOperation(extraData.type,extraData.value)
					end)
				end
				--打出去的牌
				if pdata.outCard then
					self.seats[charId]:setOutCards(pdata.outCard)
				end
			else
				--用户创建失败
			end			
		end
		--设置庄家消息
		--selfCharId zhuangId
		self.gameLayer:setCenterPanelInfo({ bankerSide = (selfCharId==zhuangId and 1 or 2) })
		
		--如果是恢复对局
		if isReconnect then
			self:checkToSetLastHandCard()
			self:setReconnGameState()
			self:loopMsgOperation()--继续查看队列需要操作的消息
		end
			
	end
	
	--先播放开局动画
	if not isReconnect then
		TmjConfig.playAmature("ermj_px_eff","ani_07",nil,display.center,false,createPlayers)
	else
		createPlayers() --恢复对局的，直接创建玩家
	end
	

end
--通过牌值 获取玩家手中一共有多少张
function TmjGameScene:getShowCardCount(val)
	local totalCount = 0
	if self.seats then
		table.walk(self.seats,function (TmjPlayer,k)
			totalCount = totalCount + TmjPlayer:getCardCountByVal(val)
		end)
	end
	return totalCount
end

--检测并设置是否需要将最后一张牌设置成为摸到的手牌
function TmjGameScene:checkToSetLastHandCard()
	if self.seats then
		table.walk(self.seats,function (TmjPlayer,k)
			TmjPlayer:checkToSetLastHandCard()
		end)
	end
end

--根据游戏状态设置重连的时候各种状态
function TmjGameScene:setReconnGameState()
	--根据状态来进行提示操作
	--self.TmjGameDataManager.enterState
	--断线数据
	local playerdatas = self.TmjGameDataManager.playerdatas
	local reconnData = self.TmjGameDataManager.reconnData
	local showCardId = self.TmjGameDataManager.showCardChairId
	local selfCharId = self.TmjGameDataManager.selfChairId --我自己的座位号
	local gamestate = self.TmjGameDataManager.enterState --进入的时候的状态
	local leftTime = reconnData.act_left_time or 1 --操作时间
	local decisionTime = self.TmjGameDataManager.preDesionTime --别人打牌 思考时间
	
	if gamestate == TmjConfig.GameState.WAIT_CHU_PAI then --等待其他玩家出牌
		-- chu_pai_player_index 当前该谁出牌
		self.TmjGameDataManager.showCardChairId = reconnData.chu_pai_player_index
		--self.TmjGameDataManager:on_SC_Maajan_Discard_Round({chair_id = reconnData.chu_pai_player_index,time = leftTime  })
		--self:onMsgSC_Maajan_Discard_Round(leftTime)
		if selfCharId==reconnData.chu_pai_player_index then --如果这个时候是等待我出牌，那么判断我能不能有听，胡的操作
			--playerData.lastInputVal
			local lastGetCard = nil
			if reconnData.last_chu_pai>0 then --非首牌
				lastGetCard = playerdatas[selfCharId].lastInputVal
			end
			self.seats[selfCharId]:showStartHuOperation(lastGetCard)
			self.seats[selfCharId]:setLeftTime(leftTime)
			--这个时候，如果是听，那么我就该直接出牌了
			self.seats[selfCharId]:checkTingToPlay(hasOperation)
		end
	elseif gamestate == TmjConfig.GameState.WAIT_PENG_GANG_HU_CHI then--等待其他玩家对上一个出牌的进行操作
		--上一个打牌的是我，那么对面还没摸牌
		if self.seats[reconnData.chu_pai_player_index] then
			self.seats[reconnData.chu_pai_player_index]:showCardTagAnim()
		end
		--showCardTagAnim
		self.TmjGameDataManager.showCardChairId = self.TmjGameDataManager:getNotSelfChairId()
		if selfCharId==reconnData.chu_pai_player_index then --上一个出牌的是我，那么，等待对面操作
			sslog(self.logTag,"等待对面对我出的牌进行操作")
			--self:onMsgSC_Maajan_Discard_Round(leftTime)
			--self.TmjGameDataManager:on_SC_Maajan_Discard_Round({chair_id = self.TmjGameDataManager:getNotSelfChairId(),time = leftTime  })
		else
			sslog(self.logTag,"我要操作对面的出牌")
			local TmjMyPlayer = self.seats[selfCharId]
			if TmjMyPlayer then
				--self.TmjGameDataManager:on_SC_Maajan_Discard_Round({chair_id = selfCharId,time = leftTime  })
				TmjMyPlayer:setLeftTime(decisionTime)
				TmjMyPlayer:getPreToPlay({ val = reconnData.last_chu_pai})
				--self:onMsgSC_Maajan_Discard_Round(leftTime)
				
			else
				sslog(self.logTag,"座位号非法:"..tostring(selfCharId))
			end
		end
		
		--提示上一个的出牌信息
		
	elseif gamestate == TmjConfig.GameState.WAIT_BA_GANG_HU then
		
	end
	--self.seats[showCardId]
	

end
--胡牌消息UI返回
function TmjGameScene:onMsgSC_Maajan_Act_Win()
	sslog(self.logTag,"UI胡消息")
	self:loopMsgOperation()
	
	--self.operationComlete = false --动作执行中
end
--打牌消息UI返回
function TmjGameScene:onMsgSC_Maajan_Act_Discard()
	sslog(self.logTag,"UI打牌消息")
	self:loopMsgOperation()
	--self.operationComlete = false --动作执行中
end
--碰消息UI返回
function TmjGameScene:onMsgSC_Maajan_Act_Peng()
	sslog(self.logTag,"UI碰消息")
	self:loopMsgOperation()
	--self.operationComlete = false --动作执行中
end
--杠牌消息UI返回
function TmjGameScene:onMsgSC_Maajan_Act_Gang()
	sslog(self.logTag,"UI杠消息")
	self:loopMsgOperation()
	--self.operationComlete = false --动作执行中
end
--吃消息UI返回
function TmjGameScene:onMsgSC_Maajan_Act_Chi()
	sslog(self.logTag,"UI吃消息")
	self:loopMsgOperation()
	--self.operationComlete = false --动作执行中
end
--摸牌消息UI返回
function TmjGameScene:onMsgSC_Maajan_Draw()
	sslog(self.logTag,"UI摸牌消息")
	self:loopMsgOperation()
	--self.operationComlete = false --动作执行中
end
--加倍消息UI返回
function TmjGameScene:onMsgSC_Maajan_Act_Double()
	sslog(self.logTag,"UI加倍消息")
	self:loopMsgOperation()
--[[	local selfCharId = self.TmjGameDataManager.selfChairId --我自己的座位号
	local doubleActions = self.TmjGameDataManager.doubleActions --
	local playCardTime = self.TmjGameDataManager.playCardTime --打牌时间
	for seatId,TmjPlayer in pairs(self.seats) do
		if doubleActions[seatId] then
			TmjPlayer:setHeadInfo({ doubleCount = doubleActions[seatId]})
			if seatId==selfCharId then
				local TmjMyPlayer = TmjPlayer
				TmjMyPlayer:closeOperationPanel() --加倍后，打牌
				TmjMyPlayer:setIsPlayCard(true) --我继续出牌
				TmjMyPlayer:checkTingToPlay(false)
				self.gameLayer:startCountDown(playCardTime)
			end
		end
		--TmjPlayer
	end--]]
end
--剩余公牌消息UI返回
function TmjGameScene:onMsgSC_Maajan_Tile_Letf()
	--restCardCount
	local restCardCount = self.TmjGameDataManager.cardLeftCount
	self.gameLayer:setCenterPanelInfo({ restCardCount = restCardCount })
end
--该谁出牌消息UI返回
function TmjGameScene:onMsgSC_Maajan_Discard_Round(leftTime)
--[[	local showCardId = self.TmjGameDataManager.showCardChairId
	local selfCharId = self.TmjGameDataManager.selfChairId --我自己的座位号
	local playCardTime = self.TmjGameDataManager.playCardTime --打牌时间
	--self.seats[showCardId]
	self.gameLayer:setCenterPanelInfo({ cardSide = (selfCharId==showCardId and 1 or 2) })
	self.gameLayer:startCountDown(leftTime and leftTime or playCardTime)
	
	sslog(self.logTag,"轮到谁出牌了"..tostring(showCardId))
	for seatId,TmjPlayer in pairs(self.seats) do
		TmjPlayer:setLeftTime(leftTime and leftTime or playCardTime)
		TmjPlayer:setIsPlayCard(seatId==showCardId)		
		--TmjPlayer
	end--]]
	sslog(self.logTag,"UI轮到谁出牌消息")
	self:loopMsgOperation()
end
--开局后的补花消息UI返回
function TmjGameScene:onMsgSC_Maajan_Bu_Hua()
	sslog(self.logTag,"UI补花消息")
	self:loopMsgOperation()
	--self.operationComlete = false --动作执行中
end
--听牌的返回
function TmjGameScene:onMsgSC_Maajan_Act_BaoTing()
	sslog(self.logTag,"UI听牌消息")
	local tingState = self.TmjGameDataManager.tingState
	
	for seatId,TmjPlayer in pairs(self.seats) do
		if tingState[seatId] then
			TmjPlayer:setTingState(tingState[seatId].isTing)
		end
		
		--TmjPlayer
	end
end

function TmjGameScene:onMsgSC_Maajan_Game_Finish()
	sslog(self.logTag,"UI胡牌消息")
	self:loopMsgOperation()
	
end

function TmjGameScene:onMsgSC_ReconnectionPlay(msgTab)
	ssdump(msgTab,"断线重连返回消息")
	if msgTab.find_table==nil or msgTab.find_table==false then --没找到房间
		--游戏已经结束 退出到游戏大厅
       self:showGameOverTips()
	end
	
end
function TmjGameScene:showResultLayer()
	self:playerOperationHandler(nil,TmjConfig.cardOperation.Finish)
	local consultData = self.TmjGameDataManager.consultData
	local selfCharId = self.TmjGameDataManager.selfChairId
	local taskInfo = self.TmjGameDataManager.taskData
	local otherCharId = self.TmjGameDataManager:getNotSelfChairId()
	local selfData = consultData.players[selfCharId]
	local otherData = consultData.players[otherCharId]
	
	local resultData = CustomHelper.copyTab(selfData)
	--players
	resultData.me = {}
	resultData.me.extraCards = CustomHelper.copyTab(selfData.extraCards)
	resultData.me.handCards = CustomHelper.copyTab(selfData.handCards)
	resultData.other = {}
	resultData.other.extraCards = CustomHelper.copyTab(otherData.extraCards)
	resultData.other.handCards = CustomHelper.copyTab(otherData.handCards)
	resultData.taskInfo = taskInfo
	
	--判断赢输或者留局
	if consultData.winChairId == nil then --留局
		TmjSettleDrawnLayer:create(resultData,handler(self,self.exitGame),handler(self,self.nextGame)):addTo(self,TmjConfig.LayerOrder.GAME_RESULT_LAYER)
	else
		TmjSettleWinLoseLayer:create(resultData,handler(self,self.exitGame),handler(self,self.nextGame)):addTo(self,TmjConfig.LayerOrder.GAME_RESULT_LAYER)
	end
end

--玩家操作完成后的回调
--@param pType 玩家类型
--@param operationType 操作类型
function TmjGameScene:playerOperationHandler(pType,operationType)
	sslog(self.logTag,"玩家类型："..tostring(pType).."，操作类型"..tostring(operationType))
	self.operationComlete = true --动作执行完成
	--删除第一个，已经完成了
	local cardOperations = self.TmjGameDataManager.cardOperations
	
	if table.nums(cardOperations) >0 then
		table.remove(cardOperations,1)
	end
	--ssdump(cardOperations,"还剩那些操作需要执行",10)
	self:loopMsgOperation()--继续查看队列需要操作的消息
end
--循环执行玩家操作消息
function TmjGameScene:loopMsgOperation()
	if not self.operationComlete then
		sslog(self.logTag,"等待上一个操作完成")
		return
	end
	local selfCharId = self.TmjGameDataManager.selfChairId
	local cardOperations = self.TmjGameDataManager.cardOperations
	local decisionTime = self.TmjGameDataManager.preDesionTime
	if not cardOperations or not next(cardOperations) then
		sslog(self.logTag,"没有需要的操作")
		return
	end
	if not self.seats or not next(self.seats) then
		sslog(self.logTag,"座位上还没有人哦")
		return
	end
	self.operationComlete = false --正在处理这个消息
	--这里所有的消息都通过服务器来，包括自己的操作反馈
	
	local chairId = cardOperations[1].chairId
--	ssdump(cardOperations[1],"当前操作",10)
--	ssdump(cardOperations,"所有需要的操作",10)
--	sslog(self.logTag,"当前操作的座位号"..tostring(chairId))
	local cType = cardOperations[1].type
	local card = CustomHelper.copyTab(cardOperations[1].card)
	
	local TmjPlayer = self.seats[chairId]
	if not TmjPlayer then
		sslog(self.logTag,"什么鬼")
	else
		TmjPlayer:doOperation(cType,card)
	end
	
	--如果是吃，胡，碰，杠，那么要删除另外一个人的打出去的牌
	if cType == TmjConfig.cardOperation.Chi
	or cType == TmjConfig.cardOperation.Peng
	or cType == TmjConfig.cardOperation.Gang
	or cType == TmjConfig.cardOperation.Hu then
		--chairId 作为中的另外一个
		for cid,player in pairs(self.seats) do
			if cid ~=chairId then
				player:removeLastOutCard()
				player:removeCardTagAnim()
				break
			end
		end
	elseif cType == TmjConfig.cardOperation.Play then --如果是打牌消息 要删除另外一个人的游标动画
		for cid,player in pairs(self.seats) do
			if cid ~=chairId then
				player:removeCardTagAnim()
				break
			end
		end
	elseif cType == TmjConfig.cardOperation.RoundCard then
		local showCardId = self.TmjGameDataManager.showCardChairId
		local selfCharId = self.TmjGameDataManager.selfChairId --我自己的座位号
		local playCardTime = self.TmjGameDataManager.playCardTime --打牌时间
		--self.seats[showCardId]
		self.gameLayer:setCenterPanelInfo({ cardSide = (selfCharId==showCardId and 1 or 2) })
		self.gameLayer:startCountDown(playCardTime)
		
		sslog(self.logTag,"轮到谁出牌了"..tostring(showCardId))
		for seatId,TmjPlayer in pairs(self.seats) do
			if seatId~=chairId then
				TmjPlayer:setIsPlayCard(nil)	
			end
			--TmjPlayer:setLeftTime(leftTime and leftTime or playCardTime)
		end
	elseif cType == TmjConfig.cardOperation.RoundCard then
		local playCardTime = self.TmjGameDataManager.playCardTime --打牌时间
		self.gameLayer:startCountDown(playCardTime)
	elseif cType == TmjConfig.cardOperation.Finish then
		--延迟播放
		performWithDelay(self,handler(self,self.showResultLayer),1.2)
		
	end
	
	--其他人打牌，我自己要判断下能不能吃，胡，碰，杠
	if chairId~=selfCharId and cType == TmjConfig.cardOperation.Play then
		local TmjMyPlayer = self.seats[selfCharId]
		if TmjMyPlayer then
			TmjMyPlayer:setLeftTime(decisionTime)
			TmjMyPlayer:getPreToPlay(card)
		end
		--显示倒计时
		self.gameLayer:startCountDown(decisionTime)
	end

	
end

function TmjGameScene:initPlayer(playerInfo)
	--自己
	if not playerInfo then
		return
	end
	local playerPath = playerInfo.path --文件的路径
	local seatId = playerInfo.seatid --玩家座位ID
	local TmjPlayer = requireForGameLuaFile(playerPath)
	--remove first if exists
	self:deletePlayer(seatId)
	local player = TmjPlayer:create(playerInfo)
	
	player:setOperationCallBack(handler(self,self.playerOperationHandler))
	
	player:setHeadInfo({headId =playerInfo.icon or 1,gold = playerInfo.money or 1000,nickname= playerInfo.nickname or "TEST",huaCount =table.nums(playerInfo.huaCard or {}),doubleCount = 0  })
	player:setTingState(playerInfo.isTing or false)
	self.seats = self.seats or {}
	self.seats[seatId] = player
	self:addChild(player,TmjConfig.LayerOrder.GAME_PLAYER)

end

function TmjGameScene:deletePlayer(seatId)
	if not self.seats[seatId] then
		return
	end
	local player = self.seats[seatId]
	if TmjHelper.isLuaNodeValid(player) then
		player:removeFromParent()
	end
	self.seats[seatId] = nil
end
--删除所有玩家
function TmjGameScene:removeAllPlayer()
	for seatId,player in pairs(self.seats) do
		if TmjHelper.isLuaNodeValid(player) then
			player:removeFromParent()
		end
	end
	TmjHelper.removeAll(self.seats)
end


---重新连接成功
function TmjGameScene:callbackWhenReloginAndGetPlayerInfoFinished()
    -- body
    TmjGameScene.super.callbackWhenReloginAndGetPlayerInfoFinished(self)
    print("重新连接成功")
	TmjHelper.removeAll(self.TmjGameDataManager.cardOperations)
	self.TmjGameDataManager.cardOperations = {}
	
    local gameingInfoTable = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
    if gameingInfoTable == nil or self.TmjGameDataManager.isGameOver == true then
		self:showGameOverTips()
	else
		
		self:removeAllPlayer()
		self.isTrustee = false --是否托管状态
		self.operationComlete = true --动作执行完成
		self:initPlayLayer()
		self:showWaiting()
		TmjGameManager:getInstance():sendReconnectMsg()
    end

end
function TmjGameScene:showGameOverTips()
   CustomHelper.showAlertView(
			"本局已经结束,退回到大厅!!!",
			false,
			true,
			function(tipLayer)
				self:exitGame()
			end,
			function(tipLayer)
				self:exitGame();
			end
	)
end
---退出游戏界面
function TmjGameScene:exitGame(openSecondLayer)
	--退出游戏的时候 清空游戏数据
	GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(nil)
	TmjGameManager:getInstance():sendStandUpAndExitRoomMsg()
    --SceneController.goHallScene()
    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager()
	if subGameManager then
		subGameManager:onExit()
	else
		sslog(self.logTag,"子游戏管理器已经释放了")
	end
	if openSecondLayer == nil then
		SceneController.goHallScene()
	else
		SceneController.goHallScene(openSecondLayer)
	end
end
--下一局
function TmjGameScene:nextGame()
	--开下一局的游戏的时候 清空游戏数据
	GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(nil)
	--重置标识
	self:removeAllPlayer()
	self.isTrustee = false --是否托管状态
	self.operationComlete = true --动作执行完成
	TmjGameManager:getInstance():sendGameReady()
	self:removeAllChildren()
	self:initPlayLayer()
	self:showWaiting()
	
end


return TmjGameScene