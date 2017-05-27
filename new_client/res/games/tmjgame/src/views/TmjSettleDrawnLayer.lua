-------------------------------------------------------------------------
-- Desc:    二人麻将留局界面
-- Author:  zengzx
-- Date:    2017.4.21
-- Last: 
-- Content:  
--    1.结算界面 包括胜利，失败
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjSettleDrawnLayer = class("TmjSettleDrawnLayer",requireForGameLuaFile("TmjPopBaseLayer"))
local TmjDrawnGameLayerCCS = requireForGameLuaFile("TmjDrawnGameLayerCCS")
local TmjConfig = import("..cfg.TmjConfig")
local TmjHelper = import("..cfg.TmjHelper")
local TmjCard = requireForGameLuaFile("TmjCard")
local scheduler = cc.Director:getInstance():getScheduler()
local countDownTime = 15 --倒计时的长度
--@param resultData 结算数据 me other 
--@param exitCallBack 退出回调
--@param nexCallBack 下一局回调
function TmjSettleDrawnLayer:ctor(resultData,exitCallBack,nexCallBack)
	TmjSettleDrawnLayer.super.ctor(self)
	self.resultData = resultData
	self.exitCallBack = exitCallBack --退出按钮回调
	self.nexCallBack = nexCallBack --下一局回调
	self.countTime = countDownTime --当前倒计时
	
	
end

function TmjSettleDrawnLayer:onEnter()
	TmjSettleDrawnLayer.super.onEnter(self)
	local node = TmjDrawnGameLayerCCS:create()
	self:addChild(node.root)
	CustomHelper.seekNodeByName(node.root,"Button_back"):addTouchEventListener(handler(self,self.onTouchListener))
	CustomHelper.seekNodeByName(node.root,"Button_exit"):addTouchEventListener(handler(self,self.onTouchListener))
	CustomHelper.seekNodeByName(node.root,"Button_next"):addTouchEventListener(handler(self,self.onTouchListener))
	
	self.node = node.root
	self:initSettleTag(CustomHelper.seekNodeByName(node.root,"Image_settleTag"))
	self:initCardInfo(CustomHelper.seekNodeByName(node.root,"FileNode_other"),self.resultData.other.extraCards,self.resultData.other.handCards)
	self:initCardInfo(CustomHelper.seekNodeByName(node.root,"FileNode_me"),self.resultData.me.extraCards,self.resultData.me.handCards)
	self:popIn(CustomHelper.seekNodeByName(self.node,"Image_bg"),TmjConfig.Pop_Dir.Up)
end
--初始化结算标签页面
function TmjSettleDrawnLayer:initSettleTag(tagNode)
	if not self.resultData then
		return
	end

	--任务的节点
	local taskInfo = self.resultData.taskInfo
	--@param taskInfo 任务数据
	--@key task_type 任务类型
	--@key task_tile 那张牌
	--@key task_scale 任务倍率
	--@key accomplish 任务是否完成
	local task = TmjConfig.taskConfig[taskInfo.task_type]
	if task and cc.FileUtils:getInstance():isFileExist(task.taskRes) then
		CustomHelper.seekNodeByName(tagNode,"Image_task"):loadTexture(task.taskRes)
		CustomHelper.seekNodeByName(tagNode,"Image_task"):ignoreContentAdaptWithSize(true)
	else
		sslog(self.logTag,"任务类型错误 "..tostring(taskInfo.task_type))
	end
	--完成后的倍率
	if taskInfo.task_scale then
		local taskrate = string.gsub(tostring(taskInfo.task_scale),"%.","/")
		CustomHelper.seekNodeByName(tagNode,"AtlasLabel_win_score"):setString(taskrate)
	end
	--任务中完成的牌值
	if taskInfo.task_tile then
		local fnode = CustomHelper.seekNodeByName(tagNode,"FileNode_card")
		
		local card = TmjCard:create({val = taskInfo.task_tile,state = TmjConfig.CardState.State_Discard })
		card:addTo(fnode:getParent())
		card:setScale(fnode:getScale())
		card:changeState(TmjConfig.CardState.State_Discard)
		card:setCardPosition(cc.p(fnode:getPositionX(),fnode:getPositionY()),true)
		fnode:removeFromParent()
		
	end
	--任务是否完成
	CustomHelper.seekNodeByName(tagNode,"Image_win_tag"):loadTexture(self.resultData.finish_task and "game_res/settle/wancheng.png" or "game_res/settle/weiwancheng.png")
	
end
--初始化牌信息界面
--@param extraCards 明牌
--@param handCards 手牌
function TmjSettleDrawnLayer:initCardInfo(showCard,extraCards,handCards)
	--FileNode_showcard
	
	showCard:setVisible(false)
	local parentNode = showCard:getParent()
	local scale = showCard:getScale()
	local startPos = cc.p(showCard:getPositionX(),showCard:getPositionY())
	--先显示明牌
	self.extraCards = {}
	local extraWidth = cc.p(0,0)
	if extraCards then
		for _,v in pairs(extraCards) do --{type =  TmjConfig.cardOperation.Peng,value = {{createTag = true, val = 1 }},

			local count = 3 
			if v.type==TmjConfig.cardOperation.Gang 
			or v.type==TmjConfig.cardOperation.AnGang 
			or v.type==TmjConfig.cardOperation.BuGang then
				count = 4
			end
			local tempCardArr = {}
			for i=1,count do
				local card = TmjCard:create({ val=v.value.val,position=display.center })
				card:addTo(parentNode,2)
				table.insert(self.extraCards,card)
				table.insert(tempCardArr,card)
			end
			extraWidth = self:setExtraPosition(scale,startPos,tempCardArr)
			startPos.x = startPos.x + extraWidth.x
			
		end
	end

	--local extraWidth = self:setExtraPosition(scale,startPos,self.extraCards)
	
	
	self.handCards = {}
	if handCards then
		for _,v in pairs(handCards) do --{type =  TmjConfig.cardOperation.Peng,value = {{createTag = true, val = 1 }},
			local card = TmjCard:create({ val=v.val,position=display.center })
			card:addTo(parentNode,2)
			table.insert(self.handCards,card)
		end
	end

	self:setHandPosition(scale,startPos,self.handCards)
	
	
	local allHandCard = table.nums(self.handCards or {})
	local gangCount = 0 --计算有多少个杠 一个杠 多一张牌
	for _,v in pairs(extraCards or {}) do
		allHandCard = allHandCard + 3
		if v.type == TmjConfig.cardOperation.Gang or v.type == TmjConfig.cardOperation.AnGang
		or v.type == TmjConfig.cardOperation.BuGang then
			allHandCard = allHandCard + 1
			gangCount = gangCount + 1 --每杠一个多一张牌
		end
	end

	--手里的牌和旁边的牌有13张，那么就根据getCard判断是否需要将最后一张牌设置成为摸到的牌
	if allHandCard - gangCount >=14 then --手上有14张，没有摸到的牌
		local x = self.handCards[#self.handCards]:getPositionX()
			
		self.handCards[#self.handCards]:setPositionX(x +10)
	end
	
end
function TmjSettleDrawnLayer:setHandPosition(scale,startPos,tempCardArr)
	for i,v in pairs(tempCardArr) do
		v:changeState(TmjConfig.CardState.State_Down)
		v:setLocalZOrder(i)
		v:setScale(scale)
		local nodeWidth = v:getContentSize().width
		v:setPosition(cc.pAdd(startPos,cc.p((i-1)*nodeWidth,0)))
		
	end
end

--根据传入的牌组合，放到额外牌位置
function TmjSettleDrawnLayer:setExtraPosition(scale,startPos,tempCardArr)
	--self.extraCardPos
	local maxWidth = 0
	
	for i,v in pairs(tempCardArr) do
		v:changeState(TmjConfig.CardState.State_Extra)
		v:setLocalZOrder(i)
		v:setScale(scale)
		local nodeWidth = v:getContentSize().width
		print(nodeWidth)
		if i<=3 then --前三张牌
			v:setPosition(cc.pAdd(startPos,cc.p((i-1)*nodeWidth,0)))
			maxWidth = maxWidth + nodeWidth
		else --第四张牌 目前外边只有最多只有四张
			v:setPosition(cc.pAdd(startPos,cc.p(nodeWidth,20)))
		end
	end
	--更新额外牌的位置起始位置
	--移动的位置
	local moveDiff = cc.p(maxWidth +10,0)
	--self.extraCardPos = cc.pAdd(self.extraCardPos,moveDiff)
	--self.cardStartPos = cc.pAdd(self.cardStartPos,moveDiff)
	return moveDiff
end

function TmjSettleDrawnLayer:_onInterval(dt)
	self.countTime = self.countTime - 1
	if self.countTime >=0 then
		self.textTime:setString(tostring(self.countTime).."s")
		
	else
		self:stopScheduler()
		if self.exitCallBack then
			self.exitCallBack()
		end
	end
	
end


function TmjSettleDrawnLayer:onExit()
	TmjSettleDrawnLayer.super.onExit(self)
	self.exitCallBack = nil
	self.nexCallBack = nil
	self.resultData = nil
	self:stopScheduler()
end
function TmjSettleDrawnLayer:onTouchListener(ref,eventType)
	if eventType == ccui.TouchEventType.began then
		TmjConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		if ref:getName()=="Button_back" then
			--退出到大厅
			if self.exitCallBack then
				self.exitCallBack()
			end
		elseif ref:getName()=="Button_exit" then
			--退出到大厅
			if self.exitCallBack then
				self.exitCallBack()
			end
		elseif ref:getName()=="Button_next" then
			--继续匹配下一局
			if not self:checkTokickOut() then
				self:showLackMoney()
			else
				if self.nexCallBack then
					self.nexCallBack()
				end
			end

			--self:removeFromParent()
		end
		
		
	end
end
function TmjSettleDrawnLayer:stopScheduler()
    if self._scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)
        self._scheduler = nil
    end
end
--检查是否要被踢出去
function TmjSettleDrawnLayer:checkTokickOut()
	local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
	local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
	if roomInfo and myPlayerInfo and roomInfo[HallGameConfig.SecondRoomMinMoneyLimitKey] then
		sslog(self.logTag,"玩家当前金币数量："..tostring(myPlayerInfo:getMoney()))
		sslog(self.logTag,"当前房间的最低进入限制："..tostring(roomInfo[HallGameConfig.SecondRoomMinMoneyLimitKey]))
		if myPlayerInfo:getMoney() < roomInfo[HallGameConfig.SecondRoomMinMoneyLimitKey] then
			return true
		end
	end
	return false
end

function TmjSettleDrawnLayer:showLackMoney()
	--lackgold
	self:stopScheduler()
	if TmjHelper.isLuaNodeValid(self.proTimer) then
		self.proTimer:stopAllActions()
	end
	CustomHelper.showAlertView(
			Tmji18nUtils:getInstance():get('str_mjplay','lackgold'),
			false,
			true,
			self.exitCallBack,
			self.exitCallBack
	)
end

return TmjSettleDrawnLayer