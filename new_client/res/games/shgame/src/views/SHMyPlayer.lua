local SHMyPlayer = class("SHMyPlayer",requireForGameLuaFile("SHPlayer"))
local SHHelper = import("..cfg.SHHelper")
local SHConfig = import("..cfg.SHConfig")
local HeadNodeCCS = requireForGameLuaFile("SHHeadNode_1")
local SHRaiseBetButtonsCCS = requireForGameLuaFile("SHRaiseBetButtonsCCS")
local SHChatLayer = requireForGameLuaFile("SHChatLayer")

local ChatAnimatorFactory = requireForGameLuaFile("ChatAnimatorFactory")
local scheduler = cc.Director:getInstance():getScheduler()

function SHMyPlayer:ctor(pinfo)
	SHMyPlayer.super.ctor(self,pinfo)
	self.pType = SHConfig.PlayerType.Type_self --玩家类型
	self.operationNodes = {}
	self.raiseButtons = nil --加注按钮组
	self.betLimit = -1 --没有限制
end
function SHMyPlayer:initHead(HeadNode)
	SHMyPlayer.super.initHead(self,HeadNode)
	
end
--设置下注的限制
--@param betLimit 下注的最大限额
function SHMyPlayer:setBetLimit(betLimit)
	SHMyPlayer.super.setBetLimit(self,betLimit)
end
--设置当前这轮的下注金额
--是我的情况下，还要更新跟注的金额
--@param roundBet 这一轮最大的下注
function SHMyPlayer:setRoundBet(roundBet)
	SHMyPlayer.super.setRoundBet(self,roundBet)
	local callNode = self.operationNodes[SHConfig.CardOperation.Call]
	local atlasCall = CustomHelper.seekNodeByName(callNode,"AtlasLabel_call")
	atlasCall:setString(tostring(roundBet or 0))
	
end
--设置底注
--@param baseBet 底注
function SHMyPlayer:setBaseBet(baseBet)
	SHMyPlayer.super.setBaseBet(self,baseBet)
end

--初始化操作节点
function SHMyPlayer:initOperationNode(OperationNode)
	self.operationNode = OperationNode
	self.operationNode:setVisible(true)
	
	--先隐藏其他节点
--SHConfig.CardOperation
--	Fall = 1, --弃牌
--	Call = 2, --跟注
--	Raise = 3, --加注
--	ShowHand = 4, --梭哈
--	Pass = 5, --过牌
	self.operationNodes[SHConfig.CardOperation.Fall] = CustomHelper.seekNodeByName(self.operationNode,"Button_discard")
	self.operationNodes[SHConfig.CardOperation.Call] = CustomHelper.seekNodeByName(self.operationNode,"Button_call")
	self.operationNodes[SHConfig.CardOperation.Raise] = CustomHelper.seekNodeByName(self.operationNode,"Button_raise")
	self.operationNodes[SHConfig.CardOperation.ShowHand] = CustomHelper.seekNodeByName(self.operationNode,"Button_showhand")
	self.operationNodes[SHConfig.CardOperation.Pass] = CustomHelper.seekNodeByName(self.operationNode,"Button_pass")
	
	
	CustomHelper.seekNodeByName(self.operationNode,"Button_chat"):addTouchEventListener(handler(self,self.chatListener))
	
	table.walk(self.operationNodes,function (v,k)
		v:setVisible(false)
		v:addTouchEventListener(handler(self,self.operationListener))
	end)
	
end
--隐藏操作节点 同时要把加注的按钮组删除
function SHMyPlayer:hideOperationNodes()
	table.walk(self.operationNodes,function (v,k)
		v:setVisible(false)
		if SHConfig.CardOperation.Raise == k then
			local raiseImg = CustomHelper.seekNodeByName(v,"Image_raise")
			raiseImg:ignoreContentAdaptWithSize(true)
			raiseImg:loadTexture("game_res/mainView/sh_wenzi_jz.png",ccui.TextureResType.localType)
		end
	end)
	self:removeRaiseButtons()
end

--创建加注按钮组
function SHMyPlayer:createRaiseButtons()
	
	if not self.baseBet or not self.betLimit then
		
		sslog(self.logTag,"当前下注底注"..tostring(self.baseBet))
		return --还没有下注的 或者底注未设置
	end
	self.roundBet = self.roundBet or self.baseBet
	
	local raiseBtn = self.operationNodes[SHConfig.CardOperation.Raise]
	if not SHHelper.isLuaNodeValid(raiseBtn) then
		sslog(self.logTag,"加注按钮还没有呢，不能创建加注按钮组")
		return
	end
	self.raiseButtons = SHRaiseBetButtonsCCS:create().root
	self.raiseButtons:addTo(raiseBtn:getParent())
	local x,y = raiseBtn:getPosition()
	local size = raiseBtn:getContentSize()
	self.raiseButtons:move(x,y+size.height/2 + 10)
	local SHGameDataBaseManager = SHGameManager:getInstance():getDataManager()
	local maxAdd = self.baseBet*self.betLimit
	local roundBet = SHGameDataBaseManager.roundBet /100
	sslog(self.logTag,"maxAdd:"..tostring(maxAdd).."self.gold:"..tostring(self.gold))
	if self.gold then
		maxAdd = self.gold/100 < maxAdd and self.gold/100 or maxAdd
	end
	
	--需要显示几个加注的  
	--self.roundBet 当前这轮最高的倍数
	--self.betLimit 限注
	--self.gold 我的金币数
	--self.baseBet 底注
	local curTimes = math.ceil(roundBet/self.baseBet) --当前是多少倍了
	local tempTimes = roundBet/self.baseBet
	
	local isInt = not (((curTimes - tempTimes > 0) and true) or false)
	if curTimes<=0 then
		curTimes = 1 --默认从1开始
	else
		curTimes = curTimes*2
	end
	local startTimes = curTimes --isInt and curTimes +1 or curTimes --显示的第一个加倍多少
	for i=1,4 do
		local btn = CustomHelper.seekNodeByName(self.raiseButtons,string.format("Button_%d",i))
		btn:setVisible(false)
		btn:setTag(i)
		local label = CustomHelper.seekNodeByName(self.raiseButtons,string.format("AtlasLabel_%d",i))
		local showBet = startTimes * self.baseBet*math.pow(2,i-1)
		btn:addTouchEventListener(handler(self,self.raiseButtonListener))
		sslog(self.logTag,"显示的加倍数:"..tostring(showBet)..",最大的加倍额度:"..tostring(maxAdd))
		if showBet <= maxAdd then -- 未超过最大允许的
			btn:setVisible(true)
			
			local s = string.gsub(CustomHelper.moneyShowStyleNone(showBet*100), '%.', '/' )
			label:setString(s)
		else
			if i>1 then
				local preBet = startTimes * self.baseBet*math.pow(2,i-2)
				if preBet < maxAdd then --上一个加注金额未超过我的金币
					btn:setVisible(true)
					local s = string.gsub(CustomHelper.moneyShowStyleNone(maxAdd*100), '%.', '/' )
					label:setString(s)
				end
				
			end
			
		end
		
	end
end
function SHMyPlayer:raiseButtonListener(ref,eventType)
	if not ref then
		return
	end
	if eventType==ccui.TouchEventType.began then
		SHConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		local atlasBet = CustomHelper.seekNodeByName(ref,string.format("AtlasLabel_%d",ref:getTag()))
		--发送加注消息
		local target = string.gsub(atlasBet:getString(), '/', '.' )
		
		local sendTarget = tonumber(target)*CustomHelper.goldToMoneyRate()
		
		SHGameManager:getInstance():sendRaiseMsg(sendTarget)--发送是以分为单位
		self:hideOperationNodes()
		self:stopCountDownSchedule()
	end
end
function SHMyPlayer:removeRaiseButtons()
	if SHHelper.isLuaNodeValid(self.raiseButtons) then
		self.raiseButtons:removeFromParent()
	end
	self.raiseButtons = nil
end

function SHMyPlayer:chatListener(ref,eventType)
	if not ref then
		return
	end
	if eventType==ccui.TouchEventType.began then
		SHConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		if ref:getName()=="Button_chat" then --弃牌
			SHChatLayer:create():addTo(self:getParent(),SHConfig.LayerOrder.GAME_CHAT_LAYER)
		end
		
	end
end

function SHMyPlayer:operationListener(ref,eventType)
	if not ref then
		return
	end
	if eventType==ccui.TouchEventType.began then
		SHConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		if ref:getName()=="Button_discard" then --弃牌
			--self:hideOperationNodes()
			self:stopCountDownSchedule()
			
			SHGameManager:getInstance():sendFallMsg()
			--发送弃牌消息
		elseif ref:getName()=="Button_call" then --跟注
			--self:hideOperationNodes()
			self:stopCountDownSchedule()
			
			SHGameManager:getInstance():sendCallMsg()
			--发送跟注消息
		elseif ref:getName()=="Button_showhand" then --梭哈
			--self:hideOperationNodes()
			self:stopCountDownSchedule()
			
			SHGameManager:getInstance():sendShowHandMsg()
			--发送梭哈消息
		elseif ref:getName()=="Button_pass" then -- 过牌
			--self:hideOperationNodes()
			self:stopCountDownSchedule()
			SHGameManager:getInstance():sendPassMsg()
			--发送过牌消息
		elseif ref:getName()=="Button_raise" then -- 加注
			--Image_raise
			local raiseImg = CustomHelper.seekNodeByName(ref,"Image_raise")
			raiseImg:ignoreContentAdaptWithSize(true)
			if not SHHelper.isLuaNodeValid(self.raiseButtons) then
				self:createRaiseButtons()
				raiseImg:loadTexture("game_res/mainView/sh_wenzi_bjz.png",ccui.TextureResType.localType)
			else
				self:removeRaiseButtons()
				raiseImg:loadTexture("game_res/mainView/sh_wenzi_jz.png",ccui.TextureResType.localType)
			end
		end
	end
end

--播放聊天内容动画
function SHMyPlayer:showChatAnim(data)
	SHMyPlayer.super.showChatAnim(self,data)
	local animData = { content = data }
	--parentNode --动画播放的父节点
	--position or cc.p(0,0) --动画播放的位置
	--zorder or 10 --动画的层级
	--flippedX or false --是否X轴反转
	--flippedY or false --是否X轴反转
	local pNode = CustomHelper.seekNodeByName(self.headNode,"Image_bg")
	local pSize = pNode:getContentSize()
	local playerData = {
		parentNode = pNode, 
		position = cc.p(pSize.width,pSize.height),
		zorder = 1,
		flippedX = true,
		isMan = self:isMan(),
		}
	self.chatAnimator = ChatAnimatorFactory.createAnimator(SHConfig.animatorType.Character,animData,playerData)
end

--播放牌型动画
--@param showDatas 传入的牌的数据集合 不传入的时候使用手上的牌进行播放
function SHMyPlayer:showCardType(showDatas)
	--显示我手牌，把底牌亮出来
	local SHCardInfo = self.cards[1] --第一张牌
	local SHCard = SHCardInfo.node --第一张牌
	if SHCard then
		SHCard.mState = SHConfig.CardState.State_Normal
		SHCard:showFront(false)
		--SHCard:changeState(SHConfig.CardState.State_Normal)
	end
	SHMyPlayer.super.showCardType(self,showDatas)
end
--播放赢动画 我自己的有音效
function SHMyPlayer:showWinAnim()
	SHConfig.playSound(SHConfig.SoundType.ResultWin)
	SHMyPlayer.super.showWinAnim(self)
end
--播放失败动画 我自己的有音效
function SHMyPlayer:showLoseAnim()
	SHConfig.playSound(SHConfig.SoundType.ResultLose)
	SHMyPlayer.super.showLoseAnim(self)
end

--显示操作按钮 弃牌 跟注/过牌 加注 梭哈
--理论上是我得到一张牌的时候，需要操作 
--但是和得到一张牌消息分开处理
--@param cardinfo 
--@key operationTypes 可以操作的类型集合
--@key max_add 最大的加注数额，也就是allin
function SHMyPlayer:showDealView(cardinfo)
	local operationTypes = cardinfo.types
	self.operationTypes = operationTypes
	local max_add = cardinfo.max_add
	local SHGameDataBaseManager = SHGameManager:getInstance():getDataManager()
	local roundbet = SHGameDataBaseManager.roundBet and SHGameDataBaseManager.roundBet/100 or 0 --这一轮的最大下注额度
	local diffBet = roundbet - self.roundBet
	
	sslog(self.logTag,"跟注多少"..tostring(diffBet))
	SHMyPlayer.super.showDealView(self)
	table.walk(self.operationNodes,function (v,k)
		--如果操作里边有这个，那么就可以显示
		if table.keyof(operationTypes,k) then
			v:setVisible(true)
		else
			v:setVisible(false)
		end
		
		if k==SHConfig.CardOperation.Call then
			local callAtlas = CustomHelper.seekNodeByName(v,"AtlasLabel_call")
			local callImg = CustomHelper.seekNodeByName(v,"Image_call")
			
			local s = string.gsub(CustomHelper.moneyShowStyleNone(diffBet*100), '%.', '/' )
			callAtlas:setString(s)
			local btnWidth = v:getContentSize().width
			local textWidth = callAtlas:getContentSize().width + callImg:getContentSize().width
			if btnWidth>textWidth then
				local center = (btnWidth - textWidth)/2
				callImg:setPositionX(center+callImg:getContentSize().width/2)
				callAtlas:setPositionX(center+callImg:getContentSize().width)
			end
		elseif k == SHConfig.CardOperation.ShowHand or 
			k == SHConfig.CardOperation.Raise then --梭哈不会隐藏，只是不能点
			v:setVisible(true)
			if table.keyof(operationTypes,k) then
				v:setEnabled(true) -- 按钮还原
			else
				v:setEnabled(false) -- 按钮置灰
			end
		end

	end)

	--跟注
	
	self.countDownTime = self.leftTime
	--倒计时结束处理
	self:stopCountDownSchedule()
	self._countDownScheduler = scheduler:scheduleScriptFunc(handler(self,self._onInterval), 1, false)
	
end
function SHMyPlayer:stopCountDownSchedule()
	if self._countDownScheduler then
		scheduler:unscheduleScriptEntry(self._countDownScheduler)
		self._countDownScheduler = nil
	end
end
--轮到我的操作的倒计时
function SHMyPlayer:_onInterval(dt)
	if not self.countDownTime or self.countDownTime <= 0 then
		self:stopCountDownSchedule()
		if type(self.countDownTime)=="number" then
			--倒计时结束了，我该 过牌还是弃牌
			sslog(self.logTag,"我的倒计时结束了，被动发送操作")
			--如果可以过牌，就过，否则弃牌
			if self.operationTypes then
				if table.keyof(self.operationTypes,SHConfig.CardOperation.Pass) then
					SHGameManager:getInstance():sendPassMsg()
				else
					SHGameManager:getInstance():sendFallMsg()
				end
				
			end
			
			
		end
		
		self.countDownTime = nil
	else
		self.countDownTime = self.countDownTime - 1
	end
end
--播放翻转牌的动画 视情况而定
function SHMyPlayer:runOpenCardAnim(createTag)
	self.cards = self.cards or {}
	if table.nums(self.cards) > 0 then
		local SHCard = self.cards[#self.cards].node
		if createTag then
			if table.nums(self.cards)==1 then --第一张牌 不翻转
				SHCard.mState = SHConfig.CardState.State_Hand
				SHCard:showFront(true)
			else
				SHCard.mState = SHConfig.CardState.State_Normal
				SHCard:showFront(false)
			end
			
		else
			if table.nums(self.cards)==1 then --第一张牌 不翻转
				SHCard:changeState(SHConfig.CardState.State_Hand)
			else
				SHCard:changeState(SHConfig.CardState.State_Normal)
			end
		end

	end
end

function SHMyPlayer:getOneCard(cardInfo)
	--根据我手上的牌张数决定当前的牌是名牌还是手牌
	if cardInfo then
		cardInfo.state = SHConfig.CardState.State_None
	end
	SHMyPlayer.super.getOneCard(self,cardInfo)
	
end
--弃牌
function SHMyPlayer:fallCard(cardInfo)
	self:playOperationAnim(SHConfig.CardOperation.Fall)
	SHMyPlayer.super.fallCard(self,cardInfo)
	self:hideOperationNodes()
end
--跟注
function SHMyPlayer:callCard(cardInfo)
	self:playOperationAnim(SHConfig.CardOperation.Call)
	SHMyPlayer.super.callCard(self,cardInfo)
	self:hideOperationNodes()
end
--加注
function SHMyPlayer:raiseCard(cardInfo)
	--todo
	self:playOperationAnim(SHConfig.CardOperation.Raise)
	SHMyPlayer.super.raiseCard(self,cardInfo)
	self:hideOperationNodes()
end
--梭哈
function SHMyPlayer:showHandCard(cardInfo)
	--todo
	self:playOperationAnim(SHConfig.CardOperation.ShowHand)
	SHMyPlayer.super.showHandCard(self,cardInfo)
	self:hideOperationNodes()
end
--过牌
function SHMyPlayer:passCard(cardInfo)
	--todo
	self:playOperationAnim(SHConfig.CardOperation.Pass)
	SHMyPlayer.super.passCard(self,cardInfo)
	self:hideOperationNodes()
end

function SHMyPlayer:onExit()
	SHMyPlayer.super.onExit(self)
	self:stopCountDownSchedule()
end

return SHMyPlayer