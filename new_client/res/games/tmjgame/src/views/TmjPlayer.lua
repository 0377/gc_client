-------------------------------------------------------------------------
-- Desc:    二人麻将玩家基础封装
-- Author:  zengzx
-- Date:    2017.4.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjPlayer = class("TmjPlayer",cc.Layer)
local TmjCard = requireForGameLuaFile("TmjCard")
local TmjHelper = import("..cfg.TmjHelper")
local TmjConfig = import("..cfg.TmjConfig")
local TmjCardTip = import("..cfg.TmjCardTip")
TmjPlayer.playerCmd = {
	[TmjConfig.cardOperation.GetOne] = function (self,cardInfo) if self['getOneCard'] then self['getOneCard'](self,cardInfo) end end, -- 摸牌
	[TmjConfig.cardOperation.Play] = function (self,cardInfo) if self['playCard'] then self['playCard'](self,cardInfo) end end, -- 打牌
	[TmjConfig.cardOperation.Chi] = function (self,cardInfo) if self['chiCard'] then self['chiCard'](self,cardInfo) end end, -- 吃
	[TmjConfig.cardOperation.Peng] = function (self,cardInfo) if self['pengCard'] then self['pengCard'](self,cardInfo) end end, -- 碰
	[TmjConfig.cardOperation.Gang] = function (self,cardInfo) if self['gangCard'] then self['gangCard'](self,cardInfo) end end, -- 杠
	[TmjConfig.cardOperation.AnGang] = function (self,cardInfo) if self['anGangCard'] then self['anGangCard'](self,cardInfo) end end, -- 杠
	[TmjConfig.cardOperation.BuGang] = function (self,cardInfo) if self['buGangCard'] then self['buGangCard'](self,cardInfo) end end, -- 补杠
	[TmjConfig.cardOperation.Ting] = function (self,cardInfo) if self['tingCard'] then self['tingCard'](self,cardInfo) end end, -- 听
	[TmjConfig.cardOperation.Hu] = function (self,cardInfo) if self['huCard'] then self['huCard'](self,cardInfo) end end, -- 胡
	[TmjConfig.cardOperation.BuHua] = function (self,cardInfo) if self['buHuaCard'] then self['buHuaCard'](self,cardInfo) end end, -- 补花
	[TmjConfig.cardOperation.RoundCard] = function (self,cardInfo) if self['setIsPlayCard'] then self['setIsPlayCard'](self,cardInfo) end end, -- 设置轮到谁出牌
	[TmjConfig.cardOperation.Double] = function (self,cardInfo) if self['doubleCard'] then self['doubleCard'](self,cardInfo) end end, -- 设置轮到谁出牌
	
}

function TmjPlayer:ctor(pinfo)
	self.logTag = self.__cname..".lua"
	self:enableNodeEvents()
	self.pType = nil --玩家类型
	self.cards = {} --存储玩家所有的牌信息(不包括打出去的) { node,info } node 存储节点  info 存储牌数据信息
	self.handCards = {} --存储玩家手里的牌 { node,info } node 存储节点  info 存储牌数据信息
	self.extraCards = {} -- 额外的牌（吃，碰，杠） { node,info } node 存储节点  info 存储牌数据信息
	self.outCards = {} -- 存储打出去的牌 { node,info } node 存储节点  info 存储牌数据信息
	self.getCard = nil -- 手里刚摸的牌 { node,info } node 存储节点  info 存储牌数据信息
	
	self.zhuangCard = nil --庄家牌
	self.cardsArray = {} --玩家的牌信息根据牌值作为Key进行存储 value为数量
	self.cardsExtraArray = {} --玩家的明牌信息根据牌值作为Key进行存储 value为数量
	self.pinfo = pinfo
	self.seatid = pinfo.seatid
	self.cardStartPos = pinfo.startPos or cc.p(0,0) --牌起始位置
	self.extraCardPos = pinfo.extraPos or cc.p(0,0) -- 其他牌的位置（这个变化会导致cardStartPos变化）
	self.outCardPos = pinfo.outCardPos or cc.p(0,0) -- 打出牌的位置
	self.getCardPos = pinfo.getCardPos or cc.p(0,0) -- 摸到牌的位置 
	self.outCardMaxLength = pinfo.outCardMaxLength or 10 -- 打出牌单行最大的牌数量
	self.cardDirection = pinfo.direction or TmjConfig.DealDirection.L_2_R --牌的方向 默认从左到右
	self.cardOffset = 0 --单个牌的间距
	self.cardCB0Index = 0 --完成动作0的索引值
	self.cardCB1Index = 0 --完成动作1的索引值
	
	self.isTingState = false --玩家是处于听状态
	self.buHuaCount = 0 --当前补花的个数
	self.isBanker = false --是否为庄家
	
	self.isPlayCard = false --是否轮到我出牌了
	
	self.headNode = nil --头像节点
	self.tingNode = nil --听牌icon
	
	self.lastCardTagArmature = nil --最后出牌的头上的箭头
end
--设置操作回调 吃，碰，杠，胡，打牌
function TmjPlayer:setOperationCallBack(operationFun)
	self.operationFun = operationFun
end
--设置是否轮到我出牌
--@param cardInfo 
--@key chairId 座位号
--@key time 剩余时间
function TmjPlayer:setIsPlayCard(cardInfo)
	ssdump(cardInfo,"设置是否轮到我出牌，我的座位号："..tostring(self.seatid))
	if not cardInfo or cardInfo.chairId~=self.seatid then
		self:removeCardTagAnim()
		self.isPlayCard = false
	else
		self.isPlayCard = cardInfo.chairId==self.seatid
		if cardInfo.time then
			self:setLeftTime(cardInfo.time)
		end
		if self.operationFun then
			self.operationFun(self.pType,TmjConfig.cardOperation.RoundCard)--吃牌结束
		end
	end

end
--删除牌上边的动画
function TmjPlayer:removeCardTagAnim()
	if TmjHelper.isLuaNodeValid(self.lastCardTagArmature) then
		sslog(self.logTag,"删除游标")
		self.lastCardTagArmature:removeFromParent()
	end
	self.lastCardTagArmature = nil
end

--设置听状态
function TmjPlayer:setTingState(isTing)
	self.isTingState = isTing
end
--设置剩余的操作时间 包括打牌考虑和别人打牌我的思考时间
function TmjPlayer:setLeftTime(leftTime)
	self.leftTime = leftTime
	self.curCountTime = self.leftTime
end
--步骤检测
--@param cardVal 输入的牌值
--@param operation 操作类型 
function TmjPlayer:checkOperation(cardVal,operation)
	if TmjCardTip.s_cmds[operation] then
		sslog(self.logTag,"输入的牌值 "..cardVal..",判断的操作 "..operation)		
		if operation==TmjCardTip.CardOperation.BuGang then
			--self.extraCards
			--ssdump(self:getExtraPair(),"判断步骤--额外的牌")
			return TmjCardTip.s_cmds[operation](CustomHelper.copyTab(self:getExtraPair()),cardVal)
		else
			--ssdump(self.cardsArray,"判断步骤--手里的牌")
			return TmjCardTip.s_cmds[operation](CustomHelper.copyTab(self.cardsArray),cardVal)
		end
		
	else
		sslog(self.logTag,"error check operation:"..operation)
	end
	return nil
end
--执行动作
--@param cardInfo 牌信息
function TmjPlayer:doOperation(operation,cardInfo)
	local cmdMethod = TmjPlayer.playerCmd[operation]
	if cmdMethod then
		cmdMethod(self,cardInfo)
	else
		sslog(self.logTag,"error do operation:"..tostring(operation))
	end
end
--返回明牌中碰的数据
function TmjPlayer:getExtraPair()
	local extraPeng = {}
	table.walk(self.extraCards,function (v,k)
		if v.type == TmjConfig.cardOperation.Peng then
			table.insert(extraPeng,v.val)
		end
	end)
	return extraPeng
end
--计算牌数组
function TmjPlayer:setCardArray(cardNodeInfos)
	if not cardNodeInfos or not next(cardNodeInfos) then
		return
	end
	local cardsArray = {}
	--从1开始填充 R_White
	for i=TmjConfig.Card.R_1,TmjConfig.Card.R_White do
		cardsArray[i] = 0 -- 初始化每个牌值的数量
	end
	local tempCards = {}
	table.walk(cardNodeInfos,function (card,k)
		table.insert(tempCards,CustomHelper.copyTab(card.info))
	end)
	TmjHelper.sortCardsInfo(tempCards)
	local preVal = nil
	local preCount = 1
	
	for i,v in ipairs(tempCards) do
		
		if v.val == preVal then
			preCount = preCount + 1
		else
			preCount = 1
			preVal = v.val
		end
		cardsArray[preVal] = preCount
	end
	TmjHelper.removeAll(tempCards)
	return cardsArray
end
--初始化头像信息
--@headInfo 头像信息
--@key gold  用户金币
--@key nickname  用户昵称
--@key headId  头像ID
--@key huaCount  花个数
--@key doubleCount  加倍数量
function TmjPlayer:setHeadInfo(TmjHeadNode,headInfo)
	if not TmjHelper.isLuaNodeValid(self.headNode) then
		self.headNode = TmjHeadNode:create().root
		self.headNode:addTo(self)
		self.headNode:setPosition(self.headPos)
	end
	local imgIcon = CustomHelper.seekNodeByName(self.headNode,"Image_icon")
	local textGold = CustomHelper.seekNodeByName(self.headNode,"Text_gold")
	local textId = CustomHelper.seekNodeByName(self.headNode,"Text_id")
	local textHua = CustomHelper.seekNodeByName(self.headNode,"Text_hua")
	local imgDouble = CustomHelper.seekNodeByName(self.headNode,"Image_double")
	local atlDouble = CustomHelper.seekNodeByName(self.headNode,"AtlasLabel_double")
	if headInfo.headId then
		local headPath = CustomHelper.getFullPath(string.format("hall_res/head_icon/%d.png",headInfo.headId or 1))
		if cc.FileUtils:getInstance():isFileExist(headPath) then
			imgIcon:loadTexture(headPath,ccui.TextureResType.localType)
		end
	end	
	if headInfo.gold then
		
		textGold:setString(CustomHelper.moneyShowStyleNone(headInfo.gold))
	end
	if headInfo.nickname then
		textId:setString(tostring(headInfo.nickname))
	end
	if headInfo.huaCount then
		self.huaCount = headInfo.huaCount
		textHua:setString(tostring(headInfo.huaCount))
	end
	if headInfo.doubleCount then
		imgDouble:setVisible(headInfo.doubleCount ~= 0 )
		atlDouble:setString(tostring(headInfo.doubleCount))
	end
	--CustomHelper.getFullPath("hall_res/head_icon/"..(self.headIconNum)..".png")
	
end

--创建牌
--@param cards 牌的数据结构集合
--@param isInstance 是否立即刷新
--@param dealCallbackFun 发牌动画播放完成回调
function TmjPlayer:createCards(cards,isInstance,dealCallbackFun)
	if not cards then
		return
	end
	--self.zhuangCard = nil
	table.walk(self.handCards,function (v,k)
		self:removeHandCard(v.info.val)
	end)

	table.walk(cards,function (v,k)
		--v.val
		local tmjCard = TmjCard:create(v)
		tmjCard:addTo(self,k)
		--self.cardStartPos
		if v.val ==0 or v.val >=TmjConfig.Card.R_Chry then
			--tmjCard:setScale(0.9)
		end
		tmjCard:setCardPosition(v.position,true)
		tmjCard:setCardPosition(self.cardStartPos,false)
		local tempCardInfoNode = {}
		tempCardInfoNode.node = tmjCard
		tempCardInfoNode.info = v
		table.insert(self.handCards,tempCardInfoNode)
		
	end)
	
	--self.cards = CustomHelper.copyTab(cards)
	self.cardsArray = self:setCardArray(self.handCards)
	--self:refreshCard(false)
	if isInstance then
		self:sortOpenCards(true)
	else
		self:runDealAction(dealCallbackFun)
	end
	
end
--显示牌的背面
function TmjPlayer:showBackCard()
	table.walk(self.handCards,function (TmjCard,k)
		local TmjCard = TmjCard.node
		TmjCard:showBack()
	end)
end
--显示牌的背面
function TmjPlayer:showFrontCard()
	table.walk(self.handCards,function (TmjCard,k)
			local TmjCard = TmjCard.node
			TmjCard:showFront()
	end)
end
--根据牌的顺序ID获取牌的位置
--@param index 牌的索引值
--@param cardSize 单个牌的尺寸
function TmjPlayer:getHandCardPosition(index,cardSize)
	return self.cardStartPos
end

--获取牌中间的位置
function TmjPlayer:getCardCenterPosition(cardsCount,cardSize)
	--self.cardStartPos.x+math.ceil(cardsCount/2)*(cardSize.width + self.cardOffset)
	local centerPos = self.cardStartPos
	if self.cardDirection == TmjConfig.DealDirection.L_2_R then
		centerPos = cc.pAdd(centerPos,cc.p(math.ceil(cardsCount/2)*(cardSize.width + self.cardOffset),0))
	elseif self.cardDirection == TmjConfig.DealDirection.R_2_L then
		centerPos = cc.pSub(centerPos,cc.p((math.ceil(cardsCount/2) - 1)*(cardSize.width + self.cardOffset),0))
	end
	return centerPos
end
--播放发牌动画
--@param dealCallback 发完牌的回调
function TmjPlayer:runDealAction(dealCallback)
	self.dealCallback = dealCallback
	local index = 0
	local dealOKFun = function ()
		index = index +1
		--print(index,table.nums(self.handCards))
		if index>=table.nums(self.handCards) then
			index = 0
			--都播放完成了
			self:refreshCard(false)
			self:runSortAction(handler(self,self.sortOpenCards))
			--self:runSortAction(handler(self,self.sortCards))
		end
	end
	table.walk(self.handCards,function (TmjCard,i)
		local TmjCard = TmjCard.node
		TmjCard:setLocalZOrder(i)
		local cardPos = self:getHandCardPosition(i,TmjCard:getContentSize())
		local move = cc.MoveTo:create(0.2,cardPos)

		local delayShowTime = 0.05*i
		--sslog(self.logTag,"index:"..i..",showTime:"..delayShowTime)
		
		local seqAction = transition.sequence({cc.DelayTime:create(delayShowTime),move,cc.CallFunc:create(dealOKFun)})
		TmjCard:runAction(seqAction)
	end)
end

--刷新牌的位置
--@param isAnimation 是否以动画的形式
--@param animCallFun 动画播完后的回调
function TmjPlayer:refreshCard(isAnimation,animCallFun)
	local cardCB1Index = 0
	table.walk(self.handCards,function (card,i)
		local card = card.node
		card:setLocalZOrder(i)
		local cardPos = self:getHandCardPosition(i,card:getContentSize())
		
		local function cardActionCB1()
			cardCB1Index = cardCB1Index + 1
			if cardCB1Index>=table.nums(self.handCards) then
				cardCB1Index = 0
				sslog(self.logTag,"展开动画播放完成")
				if animCallFun then
					animCallFun()
				end
			end
		end
		card:stopAllActions()
		if isAnimation then
			card:setCardPosition(cardPos,false)
			card:runAction(transition.sequence({
				cc.MoveTo:create(0.2,cardPos),
				cc.CallFunc:create(cardActionCB1)
			}))
			
		else
			card:setCardPosition(cardPos,true)
		end
		--ssdump(cardPos,"刷新手里牌的位置"..i)
	end)
end
--对牌进行排序
--@param isInstance 是否立即执行刷新，是否播放展开动画 
function TmjPlayer:sortOpenCards(isInstance)
	--牌信息重新排序
	TmjHelper.sortCards(self.handCards)
	--然后播放展开动画
	if isInstance then
		self:refreshCard(false)
	else
		performWithDelay(self,function ()
			--这里如果有 self.zhuangCard
--[[			if self.zhuangCard then
				ssdump(self.zhuangCard,"庄牌")
				self.getCard = self:removeHandCard(self.zhuangCard.val)
				if self.getCard and self.getCard.node then
					local x,y = self.getCard.node:getPosition()
					self.getCard.node:setCardPosition(self.getCardPos,true)
				end
				self.zhuangCard = nil
			end--]]
			self:refreshCard(true,self.dealCallback)
		end,1.2)
	end

	
end
--播放排序的动画
--@param sortCallBack 播放排序动作完成后的回调
function TmjPlayer:runSortAction(sortCallBack)
	local cardsCount  = table.nums(self.handCards)
	if cardsCount == 0 then
		return
	end
	local defalutCard = self.handCards[1].node
	local cardSize = defalutCard:getContentSize()
	--取中间的牌作为中点
	--self.cardStartPos.x+math.ceil(cardsCount/2)*(cardSize.width + self.cardOffset)
	local centerPos = self:getCardCenterPosition(cardsCount,cardSize)
	local cardCB0Index = 0
	local function cardActionCB0()
		cardCB0Index = cardCB0Index + 1
		if cardCB0Index>=table.nums(self.handCards) then
			cardCB0Index = 0
			sslog(self.logTag,"合上动画播放完成")
			if sortCallBack then
				sortCallBack()
			end
			
		end
	end
	table.walk(self.handCards,function (card,k)
		card.node:runAction(transition.sequence({
			cc.MoveTo:create(0.2,centerPos),
			cc.CallFunc:create(cardActionCB0)
		}))
	end)
	
end
--通过第一个匹配的牌值 删除手牌
function TmjPlayer:removeHandCard(cardId)
	if cardId < TmjConfig.Card.R_0 or cardId > TmjConfig.Card.R_Chry then
		cardId = TmjConfig.Card.R_0
		--return false
	end
	local deleteIndex = 0
	for i,v in pairs(self.handCards) do
		if v.info.val == cardId then
			deleteIndex = i
		end
	end
	return self:removeCardAt(deleteIndex)
end
--通过位置 删除牌
function TmjPlayer:removeCardAt(index)
	if not self.handCards[index] or not TmjHelper.isLuaNodeValid(self.handCards[index].node) then
		return false
	end
	local removedCard = self.handCards[index]
	table.remove(self.handCards,index)
	--self:refreshCard(false)
	return removedCard
end
--删除最后一张打出去的牌，别人吃，碰，刚，胡的时候
function TmjPlayer:removeLastOutCard()
	if not self.outCards or not next(self.outCards) then
		sslog(self.logTag,"打出去的牌是空的")
		return
	end
	local lastCard = self.outCards[#self.outCards]
	if TmjHelper.isLuaNodeValid(lastCard.node) then
		lastCard.node:removeFromParent()
	end
	table.remove(self.outCards,#self.outCards) --删除最后一张牌
	
end

--返回手牌数量
function TmjPlayer:getCardCount()
	return self.handCards and table.nums(self.handCards) or 0
end

--获取手牌中的第一个花牌的值
function TmjPlayer:getColorCard()
	local deleteIndex = nil
	--倒着查找
	local len = table.nums(self.handCards)
	for i=len,1,-1 do
		if self.handCards[i] and self.handCards[i].info.val >= TmjConfig.Card.R_Spring then
			deleteIndex = self.handCards[i]
			break
		end
	end
	return deleteIndex
end


--增加一张牌到手牌中去
function TmjPlayer:addToHandCard(cardInfo)
	--需要播放牌的动画
	--默认放置在手里牌中最后一个匹配顺序的位置
	local beforeIndex = table.nums(self.handCards) + 1
	for i,card in ipairs(self.handCards) do
		if card.info.val>cardInfo.info.val then
			beforeIndex = i
			break
		end
	end
	table.insert(self.handCards,beforeIndex,cardInfo)
	--
	self.cardsArray = self:setCardArray(self.handCards)
	self:refreshCard()
	sslog(self.logTag,"插入的位置:"..beforeIndex)
	
end
--设置打出去的牌 直接放出去 没有动画 牌不是手上的牌 用于恢复对局的时候调用
--@param cards 打出的牌集合
function TmjPlayer:setOutCards(cards)
	table.walk(cards,function (card,k)
		if type(card)=="number" then
			card = { val = card,position = display.center }
		end
		
		card.state = TmjConfig.CardState.State_Discard
		local newCard = self:createOneCard(card)
		table.insert(self.outCards,newCard)
		--最后一张牌的位置动画
		local outPos = self:getOutPosition(table.nums(self.outCards),newCard.node:getContentSize())
		newCard.node:stopAllActions()
		newCard.node:changeState(TmjConfig.CardState.State_Discard)
		newCard.node:setCardPosition(outPos,true)
		
	end)
end

--把牌打出去
function TmjPlayer:playCard(cardIndex)
	--挨个放到打出去的位置
	local cardNodeInfo = nil
	if cardIndex>0 then --打的牌不是摸到的牌，那么摸牌就该放到手牌中去
		cardNodeInfo = self:removeCardAt(cardIndex)
		if self.getCard and TmjHelper.isLuaNodeValid(self.getCard.node) then
			self:addToHandCard(self.getCard)
		end
	else -- 打的牌就是摸的牌
		cardNodeInfo = self.getCard
	end
	
	--self.cardStartPos
	table.insert(self.outCards,cardNodeInfo)
	--重新设置层级
	local outNum = table.nums(self.outCards)
	table.walk(self.outCards,function (cardBundle,k)
		local TmjCard = cardBundle.node
		TmjCard:setLocalZOrder(outNum - k)
	end)
	
	self:runOutCardAnim()
	--self:refreshCard()
	--如果摸到的牌不为空，把摸到的牌放到手牌中
	self.getCard = nil --打完牌后，摸到的牌都清空，已经打出去或者放到集合了
end
function TmjPlayer:runOutCardAnim()
	self:freshOutCard()
end
--刷新打出去的牌
function TmjPlayer:freshOutCard()
	--todo
	sslog(self.logTag,"刷新打出去的牌，通知打牌结束")
	self:showCardTagAnim()
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.Play)--打了一张牌
	end
end
--播放最后一张牌的游标动画
function TmjPlayer:showCardTagAnim()
	if not self.outCards or not next(self.outCards) then
		return --没有打出去的牌
	end
	local lastNode = self.outCards[#self.outCards].node
	
	local nodePos = cc.p(lastNode:getPositionX(),lastNode:getPositionY())
	local zorder = lastNode:getLocalZOrder()
	local parent = lastNode:getParent()
	if not TmjHelper.isLuaNodeValid(self.lastCardTagArmature) then
		self.lastCardTagArmature = ccs.Armature:create("ermj_px_eff")
		parent:addChild(self.lastCardTagArmature,zorder)
	end
	self.lastCardTagArmature:setPosition(cc.pAdd(nodePos,cc.p(0,60)))
	self.lastCardTagArmature:getAnimation():play("ani_10",-1, 1)
end

--获取打出去牌的位置
function TmjPlayer:getOutPosition(index,cardSize)
	return self.cardStartPos
end
--根据传入的牌组合，放到额外牌位置
function TmjPlayer:setExtraPosition(tempCardArr)
	--todo
end
--设置以前的补杠，暗杠 信息
function TmjPlayer:setExtraBuGangPosition(gangCardArr)
	--摸到的这张牌放到之前碰的上边
	local centerCard = gangCardArr[2]
	local x,y = centerCard.node:getPosition()
	--位置放到第二张牌的上边
	gangCardArr[4].node:changeState(TmjConfig.CardState.State_Extra)
	gangCardArr[4].node:setPosition(cc.p(x,y+30))
	--重置摸到的牌为空
	self.getCard = nil
end
--把手牌的最后一张牌放到摸牌位置
function TmjPlayer:setLastHandCardToGet()
	if not self.handCards or not next(self.handCards) then
		sslog(self.logTag,"手牌异常")
		return false
	end
	if self.getCard and next(self.getCard) then
		sslog(self.logTag,"手牌位置有了")
		return true
	end
	sslog(self.logTag,"设置最后一张牌为摸到的牌")
	local lastCard = self:removeCardAt(table.nums(self.handCards))
	self.getCard = lastCard
	self.getCard.node:setCardPosition(self.getCardPos,true)
	return true
end
--检测并设置是否需要将最后一张牌设置成为摸到的手牌
function TmjPlayer:checkToSetLastHandCard()
	sslog(self.logTag,"检测并设置最后一张牌为手牌")
	
	local allHandCard = table.nums(self.handCards or {})
	local gangCount = 0 --计算有多少个杠 一个杠 多一张牌
	for _,v in pairs(self.extraCards or {}) do
		allHandCard = allHandCard + table.nums(v.arr or {})
		if v.type == TmjConfig.cardOperation.Gang or v.type == TmjConfig.cardOperation.AnGang
		or v.type == TmjConfig.cardOperation.BuGang then
			gangCount = gangCount + 1 --每杠一个多一张牌
		end
	end
	sslog(self.logTag,"我的牌长度"..tostring(allHandCard))
	ssdump(self.getCard,"手牌信息")
	--手里的牌和旁边的牌有13张，那么就根据getCard判断是否需要将最后一张牌设置成为摸到的牌
	if allHandCard - gangCount >=14 and 
		(not self.getCard or not next(self.getCard)) then --手上有14张，没有摸到的牌
		return self:setLastHandCardToGet()
	end
	return false
end


--通过牌值计算牌的张数
function TmjPlayer:getCardCountByVal(val)
	local count = 0
	--明牌
	if self.extraCards then
		table.walk(self.extraCards,function (bundleData,k)
			if bundleData.arr then
				table.walk(bundleData.arr,function (v,kk)
					if v.info.val==val then
						count = count + 1
					end
				end)
			end
		end)
		
	end
	
	--打出去的牌
	if self.outCards then
		table.walk(self.outCards,function (cardInfo,k)
			if cardInfo.info.val == val then
				count = count + 1
			end
		end)
	end
	--手里的牌 如果是对手，手里的牌是255所以肯定是空
	if self.handCards then
		table.walk(self.handCards,function (card,k)
			if card.info.val == val then
				count = count + 1
			end
		end)
	end
	
	--摸到的牌
	if self.getCard then
		if self.getCard.info.val == val then
			count = count + 1
		end
	end
	return count
end

--创建一张牌 只创建 不放入任何集合中
--	会加入到UI中
--@param cardInfo 创建牌的信息
function TmjPlayer:createOneCard(cardInfo)
	local createdCard = {}
	createdCard.info = cardInfo
	
	createdCard.node = TmjCard:create(cardInfo)
	
	createdCard.node:addTo(self,table.nums(self.handCards) + 1)
	if cardInfo.position then
		createdCard.node:setCardPosition(cardInfo.position, true)
	end
	return createdCard
end

--上家出牌后，轮到我操作，是否吃，碰，胡，杠
-- 显示操作倒计时
--@param cardInfo 创建牌的信息
function TmjPlayer:getPreToPlay(cardInfo)
	--todo
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.Play)
	end
end

--摸到一张牌
--	不放到手牌中 重写的时候 子类自己放
--@param cardInfo 摸到的牌信息
function TmjPlayer:getOneCard(cardInfo)
	self.getCard = self:createOneCard(cardInfo)
	ssdump(self.getCard,"我摸到的牌是什么",10)
	--
--[[	local tempHandCards ={ {info = self.getCard.info } }
	--创建临时表，只有info
	table.walk(self.handCards,function (card,k)
		table.insert(tempHandCards,{info = card.info })
	end)--]]
	
	self.cardsArray = self:setCardArray(self.handCards)	
	tempHandCards = nil
	
	return self.getCard
end
--吃
--@param cardInfo 吃的牌信息
--@key outCard 外界的牌
--@key handCards 手上的牌，需要和外边的牌进行吃的
function TmjPlayer:chiCard(cardInfo)
	--todo
	if cardInfo and not cardInfo.createTag then 
		TmjConfig.playSound(TmjConfig.cardOperation.Chi,self:isMan())
	end
	
	
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.Chi)--吃牌结束
	end
end
--碰
--@param cardInfo 外界的牌
function TmjPlayer:pengCard(cardInfo)
	--todo
	if cardInfo and not cardInfo.createTag then 
		TmjConfig.playSound(TmjConfig.cardOperation.Peng,self:isMan())
	end
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.Peng)--碰牌结束
	end
end
--杠
--@param cardInfo 外界的牌
function TmjPlayer:gangCard(cardInfo)
	--todo
	if cardInfo and not cardInfo.createTag then 
		TmjConfig.playSound(TmjConfig.cardOperation.Gang,self:isMan())
	end
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.Gang)--杠牌结束
	end
end
--暗杠
--@param cardInfo 
function TmjPlayer:anGangCard(cardInfo)
	if cardInfo and not cardInfo.createTag then 
		TmjConfig.playSound(TmjConfig.cardOperation.AnGang,self:isMan())
	end
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.AnGang)--杠牌结束
	end
end
--补杠
--@param cardInfo 外界的牌
function TmjPlayer:buGangCard(cardInfo)
	--todo
	if cardInfo and not cardInfo.createTag then 
		TmjConfig.playSound(TmjConfig.cardOperation.BuGang,self:isMan())
	end
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.BuGang)--杠牌结束
	end
end
--听 播放听动画
function TmjPlayer:tingCard(cardInfo)
	--todo
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.Ting)--听牌结束
	end
end
--胡
--@param cardInfo 外界的牌
function TmjPlayer:huCard(cardInfo)
	--todo
	TmjConfig.playSound(TmjConfig.cardOperation.Hu,self:isMan())
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.Hu)--胡牌结束
	end
end
--补花
function TmjPlayer:buHuaCard(cardInfo)
	--todo
	
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.BuHua)--补花结束
	end
	self.cardsArray = self:setCardArray(self.handCards)
	--自己补花完成，设置那张牌是摸牌
	self:checkToSetLastHandCard()
end
--加倍
function TmjPlayer:doubleCard(cardInfo)
	if self.operationFun then
		self.operationFun(self.pType,TmjConfig.cardOperation.Double)--补花结束
	end
	self:setHeadInfo({ doubleCount = cardInfo.doubleCount })
end

--判断是否是男的
function TmjPlayer:isMan()
	local icon = self.pinfo and self.pinfo.icon or 1

    return icon > 5
end

function TmjPlayer:removeAllHandCard()
	for _,v in pairs(self.handCards) do
		if TmjHelper.isLuaNodeValid(v.node) then
			v.node:removeFromParent()
		end
		
		v.node = nil
	end
	TmjHelper.removeAll(self.handCards)
end
function TmjPlayer:removeAllExtraCard()
	--{arr = tempChiArr,type = TmjConfig.cardOperation.Chi,val = val }
	for _,v in pairs(self.extraCards) do
		if v.arr then
			for _,card in pairs(v.arr) do
				if TmjHelper.isLuaNodeValid(card.node) then
					card.node:removeFromParent()
					card.node = nil
				end
			end
			TmjHelper.removeAll(v.arr)
		end
	end
	TmjHelper.removeAll(self.extraCards)
end

function TmjPlayer:removeAllOutCard()
	for _,v in pairs(self.outCards) do
		if TmjHelper.isLuaNodeValid(v.node) then
			v.node:removeFromParent()
		end
		v.node = nil
	end
	TmjHelper.removeAll(self.outCards)
end
function TmjPlayer:onExit()
  --delete all cards
	TmjHelper.removeAll(self.cards)
	self.cards = nil
	self:removeAllHandCard()
	self:removeAllExtraCard()
	self:removeAllOutCard()
	TmjHelper.removeAll(self.cardsArray)
	TmjHelper.removeAll(self.cardsExtraArray)
	self.cardsArray = nil
	self.cardsExtraArray = nil
	if self.getCard and TmjHelper.isLuaNodeValid(self.getCard.node) then
		self.getCard.node:removeFromParent()
		self.getCard.node = nil
	end
	TmjHelper.removeAll(self.getCard)
	self.getCard = nil
	self:removeAllChildren()
	self.operationFun = nil --清空操作回调
	
	self.headNode = nil --头像节点
	self.tingNode = nil --听牌节点
end
return TmjPlayer