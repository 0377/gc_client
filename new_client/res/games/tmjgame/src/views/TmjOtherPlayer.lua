-------------------------------------------------------------------------
-- Desc:    二人麻将玩家基础封装
-- Author:  zengzx
-- Date:    2017.4.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjOtherPlayer = class("TmjOtherPlayer",requireForGameLuaFile("TmjPlayer"))
local TmjConfig = import("..cfg.TmjConfig")
local TmjHelper = import("..cfg.TmjHelper")
local TmjCardTip = import("..cfg.TmjCardTip")

local TmjHeadNode = requireForGameLuaFile("TmjHeadNode_2_CCS")
function TmjOtherPlayer:ctor(pInfo)
	TmjOtherPlayer.super.ctor(self,pInfo)
	--目前其他玩家只有对家
	self.pType = TmjConfig.PlayerType.Type_Opposite
	self.cardStartPos = cc.p(1000,630)
	self.extraCardPos = cc.p(1020,630)
	self.outCardPos = cc.p(1000,500)
	self.getCardPos = cc.p(170,630) -- 摸到牌的位置 
	self.headPos = cc.p(1150,630)
	self.outCardMaxLength = 8
	
	self.cardDirection = TmjConfig.DealDirection.R_2_L --牌的方向
end

function TmjOtherPlayer:onEnter()
--[[	local cards = {
		{val = TmjConfig.Card.R_0,position = display.center },
		{val = TmjConfig.Card.R_0,position = display.center },
		{val = TmjConfig.Card.R_0,position = display.center },
		{val = TmjConfig.Card.R_0,position = display.center },
		{val = TmjConfig.Card.R_0,position = display.center },
		{val = TmjConfig.Card.R_0,position = display.center },
		{val = TmjConfig.Card.R_0,position = display.center },
		{val = TmjConfig.Card.R_0,position = display.center },
		{val = TmjConfig.Card.R_0,position = display.center },
		
	}
	self:createCards(cards)
	--self:showBackCard()
	performWithDelay(self,function ()
		local inputCard = {val = TmjConfig.Card.R_1,position = display.center }
		--self:getPreToPlay(inputCard)
		--self:getOneCard(inputCard)
		self:doOperation(TmjConfig.cardOperation.Peng,inputCard)
		--inputCard = {val = TmjConfig.Card.R_1,position = display.center }
		--self:doOperation(TmjConfig.cardOperation.Play,inputCard)

		--local inputCard2 = {val = TmjConfig.Card.R_1,position = display.center }
		--self:doOperation(TmjConfig.cardOperation.Gang,inputCard2)
		--self:removeOenColorCard()
		
		
	end,4)--]]

	
end
--设置头像信息
--@headInfo 头像信息
--@key gold  用户金币
--@key nickname  用户昵称
--@key headId  头像ID
--@key huaCount  花个数
--@key doubleCount  加倍数量
function TmjOtherPlayer:setHeadInfo(headInfo)
	TmjOtherPlayer.super.setHeadInfo(self,TmjHeadNode,headInfo)
	
end
function TmjOtherPlayer:createCards(cards,isInstance,dealCallbackFun)
	--其他玩家的牌，要小点
	table.walk(cards,function (card,k)
		card.scale = 0.8
	end)
	TmjOtherPlayer.super.createCards(self,cards,isInstance,dealCallbackFun)
	self:showBackCard()
end

--设置听状态
function TmjOtherPlayer:setTingState(isTing)
	if not self.isTingState and isTing then --之前没听，现在听了，UI变化
		--显示听
		sslog(self.logTag,"显示听牌的UI")
		TmjConfig.playSound(TmjConfig.cardOperation.Ting,self:isMan())
		if not TmjHelper.isLuaNodeValid(self.tingNode) then
			self.tingNode = ccui.Button:create("game_res/desk/ting.png","game_res/desk/ting.png")
			self.tingNode:addTo(self,100)
			self.tingNode:move(cc.p(display.width/2,self.cardStartPos.y))
		end
	elseif not isTing then --不是听
		if TmjHelper.isLuaNodeValid(self.tingNode) then
			self.tingNode:removeFromParent()
			self.tingNode = nil
		end
	end
	TmjOtherPlayer.super.setTingState(self,isTing)
end

--执行牌操作
--@param cardInfos 牌信息 数组
--@param oldCardCount 需要删除的牌的张数
--@param createTag 恢复对局创建的 是的话，就不删除
function TmjOtherPlayer:doOperationCard(cardInfos,oldCardCount,createTag)
	local tempCardArr = {}
	local val = {}
	local newCardCount = cardInfos and table.nums(cardInfos) or 0
	--table.insert(self.extraCards,outCard)

	for _,v in pairs(cardInfos) do
		local outCard = self:createOneCard(v)
		table.insert(tempCardArr,outCard)
		table.insert(val,v.val)
	end
	
	TmjHelper.sortCards(tempCardArr)
	if createTag then
		--创建的，就不能删除了
	else
		for i=1,oldCardCount do
			local handCard = self:removeHandCard(TmjConfig.Card.R_0)
			if handCard and TmjHelper.isLuaNodeValid(handCard.node) then
				handCard.node:removeFromParent()
			end
		end
	end

	return tempCardArr,val
end

--根据牌的顺序ID获取牌的位置
--@param index 牌的索引值
--@param cardSize 单个牌的尺寸
function TmjOtherPlayer:getHandCardPosition(index,cardSize)
	local cardPos = TmjOtherPlayer.super.getHandCardPosition(self,index,cardSize)
	if self.cardDirection == TmjConfig.DealDirection.R_2_L then
		cardPos = cc.pSub(cardPos,cc.p((index-1)*(cardSize.width + self.cardOffset),0))
	end
	return cardPos
end


--上家出牌后，轮到我操作，是否吃，碰，胡，杠
-- 显示操作倒计时
--@param cardInfo 创建牌的信息
function TmjOtherPlayer:getPreToPlay(cardInfo)
	--todo
end
--其他人的打牌里边，参数只能是牌的具体结构 明牌
function TmjOtherPlayer:playCard(cardIndex)
	if type(cardIndex)~="table" or not cardIndex.val then
		sslog(self.logTag,"打牌的数据有问题")
		return
	end
	sslog(self.logTag,"其他玩家打牌")
	ssdump(cardIndex,"其他人的打牌信息")
	--其他玩家固定打一张牌
	--先删除摸的牌
	cardIndex.position = cc.p(self.getCardPos.x,self.getCardPos.y)
	if self.getCard and TmjHelper.isLuaNodeValid(self.getCard.node) then
		sslog(self.logTag,"打的是摸得牌")
		self.getCard.node:removeFromParent()
	else
		local handCard = self:removeHandCard(TmjConfig.Card.R_0)
		sslog(self.logTag,"从手里打出一张牌")
		if handCard and TmjHelper.isLuaNodeValid(handCard.node) then
			cardIndex.position.x,cardIndex.position.y = handCard.node:getPosition()
			handCard.node:removeFromParent()
		end
		
	end
	sslog(self.logTag,"播放打牌动画")
	--self.cardStartPos
	cardIndex.state = TmjConfig.CardState.State_Discard
	TmjConfig.playSound(TmjConfig.cardOperation.Play,self:isMan(),cardIndex.val)
	table.insert(self.outCards,self:createOneCard(cardIndex))
	self:runOutCardAnim()
	self:refreshCard()
	--如果摸到的牌不为空，把摸到的牌放到手牌中
	self.getCard = nil --打完牌后，摸到的牌都清空，已经打出去或者放到集合了
	
end

--摸到一张牌
--	不放到手牌中 重写的时候 子类自己放
--@param cardInfo 摸到的牌信息
function TmjOtherPlayer:getOneCard(cardInfo)
	sslog(self.logTag,"摸牌")
	
	--这里摸牌的时候，长度
	local cardLen = table.nums(cardInfo)
	
	--循环播放摸到牌的动画
	local function loopPlayGetCard(index)
		local card = cardInfo[index]
		
		card.scale = 0.8
		self:playGetCardAnim(card,function ()
			--摸到的牌是花，播放补花动画
			if index==cardLen then
				if self.operationFun then
					self.operationFun(self.pType,TmjConfig.cardOperation.GetOne)
				end
			else
				--增加补花数量
				self.huaCount = self.huaCount or 0
				self.huaCount = self.huaCount + 1
				self:setHeadInfo({ huaCount = self.huaCount })
				TmjConfig.playSound(TmjConfig.cardOperation.BuHua,self:isMan())
				
				TmjConfig.playAmature("ermj_px_eff","ani_12",nil,cc.p(display.cx,self.getCardPos.y),false,function ()
					if self.getCard and TmjHelper.isLuaNodeValid(self.getCard.node) then
						self.getCard.node:removeFromParent()
						ssdump(cardInfo[index + 1],"花牌数据")
						sslog(self.logTag,"播放摸到牌的补花动画")
						index = index + 2
						loopPlayGetCard(index)
					end
				end)
			end

		end)
		
	end
	--需要播放牌的动画
	--摸到牌的位置，默认放在右手边
	loopPlayGetCard(1)
	

	
end
--播放摸到一张牌的动画 包括数据处理
--@param cardInfo 一个单张牌的数据
function TmjOtherPlayer:playGetCardAnim(cardInfo,callback)
	TmjOtherPlayer.super.getOneCard(self,cardInfo)
	local tGetcard = self.getCard
	if not tGetcard or not TmjHelper.isLuaNodeValid(tGetcard.node) then
		return --还没摸牌
	end
	--self.outCardPos
	tGetcard.node:stopAllActions()
	tGetcard.node:setCardPosition(self.getCardPos,true)
	if callback then
		callback()
	end
	
end

--吃
--@param cardInfo 吃的牌信息
--@key outCard 外界的牌
--@key handCards 手上的牌，需要和外边的牌进行吃的
function TmjOtherPlayer:chiCard(cardInfo)
	--todo
	sslog(self.logTag,"吃")
	--播放吃的动画
	if not cardInfo.createTag then --非新建的才播放
		TmjConfig.playAmature("ermj_px_eff","ani_03",nil,cc.p(display.center.x,self.cardStartPos.y),false)
	end
	
	--self.extraCards
	if cardInfo.outCard then
		cardInfo.outCard.scale = 0.8
	end
	if cardInfo.handCards then
		table.walk(cardInfo.handCards,function (card,k)
			card.scale = 0.8
		end)
	end
	local cardInfos = {}
	table.insert(cardInfos,cardInfo.outCard)
	table.insertto(cardInfos,cardInfo.handCards,table.nums(cardInfos)+1)
	local tempPengArr,val = self:doOperationCard(cardInfos,2,cardInfo.createTag)
	table.insert(self.extraCards,{arr = tempPengArr,type = TmjConfig.cardOperation.Chi,val = val })
	TmjHelper.sortCards(tempPengArr)
	--更新这些牌的位置
	self:setExtraPosition(tempPengArr)
	--吃了后把最右边的牌，放到摸牌位置
	self:checkToSetLastHandCard()
	TmjOtherPlayer.super.chiCard(self,cardInfo)
end
--碰
--@param cardInfo 外界的牌
function TmjOtherPlayer:pengCard(cardInfo)
	--todo
	sslog(self.logTag,"碰")
	--播放碰的动画
	if not cardInfo.createTag then --非新建的才播放
		TmjConfig.playAmature("ermj_px_eff","ani_01",nil,cc.p(display.center.x,self.cardStartPos.y),false)
	end
	local tempCardInfo = nil
	--这种情况是开局解析出来的 恢复对局
	if cardInfo.handCards and next(cardInfo.handCards) then
		tempCardInfo = cardInfo.handCards[1]
		tempCardInfo.createTag = cardInfo.createTag
	else
		tempCardInfo = cardInfo
	end
	--self.extraCards
	local cardInfos = {}
	tempCardInfo.scale = 0.8
	table.insert(cardInfos,tempCardInfo)
	table.insert(cardInfos,tempCardInfo)
	table.insert(cardInfos,tempCardInfo)
	local tempPengArr,val = self:doOperationCard(cardInfos,2,tempCardInfo.createTag)
	
	table.insert(self.extraCards,{arr = tempPengArr,type = TmjConfig.cardOperation.Peng,val = val })
	--更新这些牌的位置
	self:setExtraPosition(tempPengArr)
	local getCardInfo = self.getCard
	local hands = self.handCards
	--吃了后把最右边的牌，放到摸牌位置
	self:checkToSetLastHandCard()
	
	TmjOtherPlayer.super.pengCard(self,tempCardInfo)
end
--杠
--@param cardInfo 外界的牌
function TmjOtherPlayer:gangCard(cardInfo)
	--todo
	sslog(self.logTag,"杠")
	--播放杠的动画
	if not cardInfo.createTag then --非新建的才播放
		TmjConfig.playAmature("ermj_px_eff","ani_02",nil,cc.p(display.center.x,self.cardStartPos.y),false)
	end
	
	--self.extraCards
	local cardInfos = {}
	cardInfo.scale = 0.8
	table.insert(cardInfos,cardInfo)
	table.insert(cardInfos,cardInfo)
	table.insert(cardInfos,cardInfo)
	table.insert(cardInfos,cardInfo)
	local tempPengArr,val = self:doOperationCard(cardInfos,3,cardInfo.createTag)
	table.insert(self.extraCards,{arr = tempPengArr,type = TmjConfig.cardOperation.Gang,val = val })
	--更新这些牌的位置
	self:setExtraPosition(tempPengArr)
	TmjOtherPlayer.super.gangCard(self,cardInfo)
end
--暗杠
--@param cardInfo 
function TmjOtherPlayer:anGangCard(cardInfo)
	sslog(self.logTag,"暗杠")
	--播放杠的动画
	if not cardInfo.createTag then --非新建的才播放
		TmjConfig.playAmature("ermj_px_eff","ani_02",nil,cc.p(display.center.x,self.cardStartPos.y),false)
	end
	
	--self.extraCards
	local cardInfos = {}
	cardInfo.scale = 0.8
	table.insert(cardInfos,cardInfo)
	table.insert(cardInfos,cardInfo)
	table.insert(cardInfos,cardInfo)
	table.insert(cardInfos,cardInfo)
	local tempPengArr,val = self:doOperationCard(cardInfos,4,cardInfo.createTag)
	table.insert(self.extraCards,{arr = tempPengArr,type = TmjConfig.cardOperation.AnGang,val = val })
	--更新这些牌的位置
	self:setExtraPosition(tempPengArr)
	TmjOtherPlayer.super.anGangCard(self,cardInfo)
end
--补杠
--@param cardInfo 摸到的牌
function TmjOtherPlayer:buGangCard(cardInfo)
	--todo
	sslog(self.logTag,"补杠")
	--播放杠的动画
	if not cardInfo.createTag then --非新建的才播放
		TmjConfig.playAmature("ermj_px_eff","ani_02",nil,cc.p(display.center.x,self.cardStartPos.y),false)
	end
	
	local function findBuGangCards(cardinfo)
		local tempBuGangArrData = nil
		for _,v in pairs(self.extraCards) do
			if v.type == TmjConfig.cardOperation.Peng and v.val[1] == cardInfo.val then --之前是碰的牌
				tempBuGangArrData = v
				break
			end
		end
		return tempBuGangArrData
	end
	cardInfo.scale = 0.8
	local tempBuGangArrData = findBuGangCards(cardInfo)
	--如果这里没找到，那就是数据异常了
	if not tempBuGangArrData then
		sslog(self.logTag,"补杠操作异常，额外牌中没有能补杠当前的牌的对子")
		ssdump(self.extraCards,"额外的牌",5)
		ssdump(self.getCard,"摸的牌",5)
		return
	end
	--其他玩家的时候，要删除摸到的牌，因为摸到的牌是背面牌
	if self.getCard and TmjHelper.isLuaNodeValid(self.getCard.node) then
		self.getCard.node:removeFromParent()
	end
	
	table.insert(tempBuGangArrData.arr,self:createOneCard(cardInfo))
	table.insert(tempBuGangArrData.val,cardInfo.val)
	tempBuGangArrData.type = TmjConfig.cardOperation.BuGang --把碰改成按杠
	self:setExtraBuGangPosition(tempBuGangArrData.arr)
	TmjOtherPlayer.super.buGangCard(self,cardInfo)
end
--听 播放听动画
function TmjOtherPlayer:tingCard(cardInfo)
	--todo
	sslog(self.logTag,"听牌")
	TmjConfig.playSound(TmjConfig.cardOperation.Ting,self:isMan())
end
--胡
--@param cardInfo 外界的牌
function TmjOtherPlayer:huCard(cardInfo)
	TmjOtherPlayer.super.huCard(self,cardInfo)
	--todo
	sslog(self.logTag,"胡牌")
	--播放杠的动画
	TmjConfig.playAmature("ermj_px_eff","ani_04",nil,cc.p(display.center.x,self.cardStartPos.y),false)
end
--补花 其他玩家补花的时候，数据结构按照
function TmjOtherPlayer:buHuaCard(cardInfo)
	--todo
	sslog(self.logTag,"其他玩家补花")
	--摸到牌的补花动画 如果有
	local function loopGetCardBuHua(cardInfos,index)
		if index<= table.nums(cardInfos) then
			self.huaCount = self.huaCount or 0
			self.huaCount = self.huaCount + 1
			TmjConfig.playSound(TmjConfig.cardOperation.BuHua,self:isMan())
			self:setHeadInfo({ huaCount = self.huaCount })
			sslog(self.logTag,"当前index:"..tostring(index))
			if cardInfos[index+1].val>=TmjConfig.Card.R_Spring and cardInfos[index+1].val<= TmjConfig.Card.R_Chry then
				sslog(self.logTag,"播放补花动画")
			else
				sslog(self.logTag,"补花时，摸到正常的牌")
			end
			
			TmjConfig.playAmature("ermj_px_eff","ani_12",nil,cc.p(display.cx,self.getCardPos.y),false,function ()
				sslog(self.logTag,"补花动画播放完成")
				index = index + 2
				loopGetCardBuHua(cardInfos,index)
			end)
			
		else
			--最后一张了，不是花
			--如果有手牌
			--不用管了
			sslog(self.logTag,"补花结束")
			TmjOtherPlayer.super.buHuaCard(self,cardInfo)
		end
		
	end
	
	loopGetCardBuHua(cardInfo,1)
	
end
function TmjOtherPlayer:checkToSetLastHandCard()
	sslog(self.logTag,"其他玩家检测最后一张牌为手牌动作")
	TmjOtherPlayer.super.checkToSetLastHandCard(self)
end
--根据传入的牌组合，放到额外牌位置
function TmjOtherPlayer:setExtraPosition(tempCardArr)
	--self.extraCardPos
	local maxWidth = 0
	
	for i,v in pairs(tempCardArr) do
		v.node:changeState(TmjConfig.CardState.State_Extra)
		v.node:setLocalZOrder(i)
		local nodeWidth = v.node:getContentSize().width
		if i<=3 then --前三张牌
			v.node:setPosition(cc.pSub(self.extraCardPos,cc.p((i-1)*nodeWidth,0)))
			maxWidth = maxWidth + nodeWidth
		else --第四张牌 目前外边只有最多只有四张
			v.node:setPosition(cc.pSub(self.extraCardPos,cc.p(nodeWidth,-25)))
		end
	end
	--更新额外牌的位置起始位置
	--移动的位置
	local moveDiff = cc.p(maxWidth +7,0)
	self.extraCardPos = cc.pSub(self.extraCardPos,moveDiff)
	self.cardStartPos = cc.pSub(self.cardStartPos,moveDiff)
	--刷新位置
	self:refreshCard(false)
	ssdump(self.extraCards,"额外牌信息",5)
end
--获取打出去牌的位置
--这里要判断打出去的牌的位置放在哪
--@param index 打出牌的是第几张
--@param cardSize 每张牌的大小，这个大小应该是倒下去牌的大小
function TmjOtherPlayer:getOutPosition(index,cardSize)
	--self.outCardMaxLength
	local x = (index-1) % self.outCardMaxLength
	local y = math.floor((index - 1) / self.outCardMaxLength)	
	local outPos = cc.pSub(self.outCardPos,cc.p(x*cardSize.width,y*cardSize.height ))
	--outPos.y = outPos.y + 200
	return outPos
end

--根据牌的顺序ID获取牌的位置
--@param index 牌的索引值
--@param cardSize 单个牌的尺寸
function TmjOtherPlayer:getHandCardPosition(index,cardSize)
	local cardPos = TmjOtherPlayer.super.getHandCardPosition(self,index,cardSize)
	cardPos = cc.pSub(cardPos,cc.p((index-1)*(cardSize.width + self.cardOffset),0))
	return cardPos
end
--播放打牌的动画
function TmjOtherPlayer:runOutCardAnim()
	--最后一张牌的位置动画
	local lastNode = self.outCards[#self.outCards].node
	
	local outPos = self:getOutPosition(#self.outCards,lastNode:getContentSize())
	lastNode:stopAllActions()
	local curPos = cc.p(lastNode:getPositionX(),lastNode:getPositionY())
	local len = cc.pGetDistance(outPos,curPos)
	local speed = 4000
	local seqAction = transition.sequence({cc.MoveTo:create(len/speed,outPos),cc.CallFunc:create(handler(self,self.freshOutCard))})
	lastNode:runAction(seqAction)
end
return TmjOtherPlayer