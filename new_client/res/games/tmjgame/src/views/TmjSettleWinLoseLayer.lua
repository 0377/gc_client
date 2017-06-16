-------------------------------------------------------------------------
-- Desc:    二人麻将结算界面
-- Author:  zengzx
-- Date:    2017.4.21
-- Last: 
-- Content:  
--    1.结算界面 包括胜利，失败
-- Modify:
--	 2017/6/8 Button_back 根据策划要求，不要关闭按钮
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjSettleWinLoseLayer = class("TmjSettleWinLoseLayer",requireForGameLuaFile("TmjPopBaseLayer"))
local TmjWinLoseLayerCCS = requireForGameLuaFile("TmjWinLoseLayerCCS")
local TmjConfig = import("..cfg.TmjConfig")
local TmjHelper = import("..cfg.TmjHelper")
local TmjCard = requireForGameLuaFile("TmjCard")
local scheduler = cc.Director:getInstance():getScheduler()
local countDownTime = 25 --倒计时的长度
--@param resultData 结算数据 me other 
--@param exitCallBack 退出回调
--@param nexCallBack 下一局回调
function TmjSettleWinLoseLayer:ctor(resultData,exitCallBack,nexCallBack)
	TmjSettleWinLoseLayer.super.ctor(self)
	self.resultData = resultData
	self.exitCallBack = exitCallBack --退出按钮回调
	self.nexCallBack = nexCallBack --下一局回调
	self.countTime = countDownTime --当前倒计时
	
	
end

function TmjSettleWinLoseLayer:onEnter()
	TmjSettleWinLoseLayer.super.onEnter(self)
	local node = TmjWinLoseLayerCCS:create()
	self:addChild(node.root)
	CustomHelper.seekNodeByName(node.root,"Button_back"):addTouchEventListener(handler(self,self.onTouchListener))
	CustomHelper.seekNodeByName(node.root,"Button_opponent_card"):addTouchEventListener(handler(self,self.onTouchListener))
	CustomHelper.seekNodeByName(node.root,"Button_self_card"):addTouchEventListener(handler(self,self.onTouchListener))
	CustomHelper.seekNodeByName(node.root,"Button_exit"):addTouchEventListener(handler(self,self.onTouchListener))
	CustomHelper.seekNodeByName(node.root,"Button_next"):addTouchEventListener(handler(self,self.onTouchListener))
	--应策划要求，关闭按钮不要
	CustomHelper.seekNodeByName(node.root,"Button_back"):setVisible(false)
	self.node = node.root
	self:initSettleTag(CustomHelper.seekNodeByName(node.root,"Image_settleTag"))
	self:initPanelInfo(CustomHelper.seekNodeByName(node.root,"Panel_info"))
	self.scrollView = CustomHelper.seekNodeByName(node.root,"ScrollView_desc")
	self.imgBar = CustomHelper.seekNodeByName(node.root,"Image_bar")
	self:initHuDesc(self.scrollView,self.imgBar)
	self:initCardInfo(CustomHelper.seekNodeByName(node.root,"FileNode_showcard"),self.resultData.extraCards,self.resultData.handCards)
	
	self:popIn(CustomHelper.seekNodeByName(self.node,"Image_bg"),TmjConfig.Pop_Dir.Up)
	local isWin = self.resultData.winChairId == self.resultData.me.chair_id 
	if self.resultData and isWin then
		TmjConfig.playSound(TmjConfig.sType.GAME_WIN)
	else
		TmjConfig.playSound(TmjConfig.sType.GAME_LOSE)
	end
	

	self:startTimeScheduler()
end
function TmjSettleWinLoseLayer:startTimeScheduler()
	self:stopTimeScheduler()
	--self.timeInterval
	if self.hasSliderBar then --有滑块的时候才显示
		local aniInterval = cc.Director:getInstance():getAnimationInterval()
		self.timeInterval = scheduler:scheduleScriptFunc(handler(self,self._timeInterval), aniInterval, false)
	end

end
function TmjSettleWinLoseLayer:stopTimeScheduler()
	if self.timeInterval then
        scheduler:unscheduleScriptEntry(self.timeInterval)
        self.timeInterval = nil
    end
end
function TmjSettleWinLoseLayer:_timeInterval(dt)
	local pos = self.scrollView:getInnerContainerPosition()
	local innerSize = self.scrollView:getInnerContainerSize()
	local contentSize = self.scrollView:getContentSize()
	--
	if pos.y>=0 then
		pos.y = 0
		contentSize.height = 0
	end
	local percent = 100*(innerSize.height + pos.y - contentSize.height) / innerSize.height

	self.imgBar:setPositionY(self:getSliderPostionYByPercent(percent))
end
--初始化结算标签页面
function TmjSettleWinLoseLayer:initSettleTag(tagNode)
	if not self.resultData then
		return
	end
	local tag = CustomHelper.seekNodeByName(tagNode,"Image_tag")
	
	local tagAmature = CustomHelper.seekNodeByName(tag,"tag_Amature")
	local isWin = self.resultData.winChairId == self.resultData.me.chair_id 
	tag:loadTexture(isWin and "game_res/settle/shengli.png" or "game_res/settle/shibai.png")
	if not isWin then
		--tagAmature:setVisible(false)
		tag:removeAllChildren()
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
--初始化信息界面
function TmjSettleWinLoseLayer:initPanelInfo(panelNode)
	local isWin = self.resultData.winChairId == self.resultData.me.chair_id 
	local imgResult = CustomHelper.seekNodeByName(panelNode,"Image_result")
	imgResult:loadTexture(isWin and "game_res/settle/niyingle.png" or "game_res/settle/nishule.png")
	
	CustomHelper.seekNodeByName(panelNode,"Text_result"):setString(CustomHelper.moneyShowStyleNone(math.abs(self.resultData.win_money)))
	if self.resultData.taxes then
		
		CustomHelper.seekNodeByName(panelNode,"Text_tax"):setString("-"..CustomHelper.moneyShowStyleNone(math.abs(self.resultData.taxes)))
	else
		CustomHelper.seekNodeByName(panelNode,"Text_tax"):setString("0")
	end
	
	
	--显示规则 番数x 加倍次数 x 完成任务倍数
	if self.resultData.hu_fan then
		--计算原始番数
		local originFan = self.resultData.hu_fan
		if self.resultData.jiabei and self.resultData.jiabei > 0 then
			originFan = originFan / math.pow(2,self.resultData.jiabei)
		end
		if self.resultData.finish_task and self.resultData.taskInfo.task_scale and self.resultData.taskInfo.task_scale>0 then
			originFan = originFan / self.resultData.taskInfo.task_scale
		end
		local fanDesc = string.format(Tmji18nUtils:getInstance():get('str_mjplay','fan'),originFan)
		local hasExtra = false
		local totalFan = self.resultData.hu_fan
		if self.resultData.jiabei and self.resultData.jiabei > 0 then
			fanDesc = fanDesc.."x"..string.format(Tmji18nUtils:getInstance():get('str_mjplay','rate'), math.pow(2,self.resultData.jiabei))
			hasExtra = true
			--totalFan = totalFan * math.pow(2,self.resultData.jiabei)
		end
		if self.resultData.finish_task then
			fanDesc = fanDesc.."x"..string.format(Tmji18nUtils:getInstance():get('str_mjplay','rate'),self.resultData.taskInfo.task_scale)
			hasExtra = true
			--totalFan = totalFan * self.resultData.taskInfo.task_scale
		end
		if hasExtra then
			fanDesc = fanDesc.."="..string.format(Tmji18nUtils:getInstance():get('str_mjplay','fan'),totalFan)
		end
		CustomHelper.seekNodeByName(panelNode,"Text_total"):setString(fanDesc)
	end
	
	--倒计时
	self.textTime = CustomHelper.seekNodeByName(panelNode,"Text_time")
	
	self.textTime:setString(tostring(countDownTime).."s")
	local spriteProgress = CustomHelper.seekNodeByName(panelNode,"Image_loading_time")
	
	local spritParent = spriteProgress:getParent()
	local proX,proY = spriteProgress:getPosition()
	spriteProgress:removeFromParentAndCleanup(false)
    
    local progressTimer = cc.ProgressTimer:create(spriteProgress)
    progressTimer:setAnchorPoint(0.5, 0.5)
    progressTimer:setPosition(cc.p(proX,proY))
    progressTimer:setReverseDirection(true)
    progressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    progressTimer:setPercentage(100)
	progressTimer:addTo(spritParent)
   
	self.proTimer = progressTimer
	
    -- 创建定时任务 --
    self._scheduler = scheduler:scheduleScriptFunc(handler(self,self._onInterval), 1, false)
	self.proTimer:runAction(cc.ProgressFromTo:create(countDownTime,100,0))
end
--初始化胡牌番信息
function TmjSettleWinLoseLayer:initHuDesc(scrollView,sliderBar)
	-- self.resultData.describe
	local descs = string.split(self.resultData.describe,",")
	--里边的花牌要累加起来
	local huaCount = 0
	local newDescs = {}
	local huaStartIndex = nil
	table.walk(descs,function (huTye,i)
		if TmjConfig.CARD_HU_TYPE_INFO.HUA_PAI.name==huTye then
			if not huaStartIndex then
				huaStartIndex = i
				table.insert(newDescs,huTye)
			end
			huaCount = huaCount + 1
		elseif huTye and string.len(huTye)>0 then
			table.insert(newDescs,huTye)
		end
	end)
	
	self.scrollView = scrollView
	local xindex = 0
	local yindex = 0
	local posIndex = { {10,195},{370,560} }
	local ydiff = 60
	local height = ydiff*math.ceil(table.nums(newDescs)/2) + 20
	local viewSize = scrollView:getContentSize()
	scrollView:setInnerContainerSize(cc.size(viewSize.width,height))
	scrollView:setScrollBarEnabled(false)
	self.hasSliderBar = true
	if height<=viewSize.height then
		sliderBar:getParent():setVisible(false)
		self.hasSliderBar = false
	else
		sliderBar:addTouchEventListener(handler(self,self.barListener))
		
		local sliderSize = sliderBar:getContentSize()
		local sliderBgSize = sliderBar:getParent():getContentSize()
		self.barPosYLimit = {sliderSize.height/2,sliderBgSize.height - sliderSize.height/2 }
	end

	for _,v in pairs(newDescs) do
		local huInfo = TmjConfig.CARD_HU_TYPE_INFO[v]
		if huInfo then
			if not huInfo.fan or huInfo.fan<=0 then
				scrollView:removeAllChildren()
				break
			else
				--huInfo.fan
				--huInfo.res
				xindex = xindex + 1
				if xindex> 2 then
					xindex = 1
					yindex = yindex + 1
				end
								
				local imgFanInfo = ccui.ImageView:create(huInfo.res,0)
				imgFanInfo:setAnchorPoint(cc.p(0,1.0))
				
				imgFanInfo:addTo(scrollView)
				local y = height - ydiff*(yindex) 
				imgFanInfo:setPosition(cc.p(posIndex[xindex][1],y))
				local showFanCount = huInfo.fan
				if v == TmjConfig.CARD_HU_TYPE_INFO.HUA_PAI.name and huaCount>0 then
					showFanCount = huaCount
				end
				local imgFan = ccui.ImageView:create(string.format("game_res/fan/%dfan.png",showFanCount),0)
				imgFan:setAnchorPoint(cc.p(0,1.0))
				imgFan:addTo(scrollView)
				imgFan:setPosition(cc.p(posIndex[xindex][2],y))
				
			end
			
		else
			sslog(self.logTag,"未找到胡牌信息"..tostring(v))
		end
		
	end
end
--初始化牌信息界面
--@param extraCards 明牌
--@param handCards 手牌
function TmjSettleWinLoseLayer:initCardInfo(showCard,extraCards,handCards)
	--FileNode_showcard
	self:removeCardInfo()
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
			if count==4 then --杠
				for i=1,count do
					local card = TmjCard:create({ val=v.value.val,position=display.center })
					card:addTo(parentNode,2)
					table.insert(self.extraCards,card)
					table.insert(tempCardArr,card)
				end
			else -- 碰，吃
				table.walk(v.value.handCards,function (extraCard,k)
					local card = TmjCard:create({ val=extraCard.val,position=display.center })
					card:addTo(parentNode,2)
					table.insert(self.extraCards,card)
					table.insert(tempCardArr,card)
				end)
				local card = TmjCard:create({ val=v.value.outCard.val,position=display.center })
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
function TmjSettleWinLoseLayer:setHandPosition(scale,startPos,tempCardArr)
	for i,v in pairs(tempCardArr) do
		v:changeState(TmjConfig.CardState.State_Down)
		v:setLocalZOrder(i)
		v:setScale(scale)
		local nodeWidth = v:getContentSize().width
		v:setPosition(cc.pAdd(startPos,cc.p((i-1)*nodeWidth,0)))
		
	end
end

--根据传入的牌组合，放到额外牌位置
function TmjSettleWinLoseLayer:setExtraPosition(scale,startPos,tempCardArr)
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

function TmjSettleWinLoseLayer:removeCardInfo()
	if self.extraCards then
		table.walk(self.extraCards,function (card,k)
			card:removeFromParent()
			
		end)
		TmjHelper.removeAll(self.extraCards)
	end
	if self.handCards then
		table.walk(self.handCards,function (card,k)
			card:removeFromParent()
			
		end)
		TmjHelper.removeAll(self.handCards)
	end
end

function TmjSettleWinLoseLayer:barListener(ref,eventType)
	if eventType == ccui.TouchEventType.began then
		--ref:getTouchBeganPosition()
		local pos = self:convertSliderPosition(ref,ref:getTouchBeganPosition())
		ref:setPositionY(pos.y)
		local percent = self:convertScrollPercent(pos.y)
		self.scrollView:jumpToPercentVertical(percent)
		
		self:stopTimeScheduler()
	elseif eventType == ccui.TouchEventType.moved then	
		local pos = self:convertSliderPosition(ref,ref:getTouchMovePosition())
		ref:setPositionY(pos.y)
		local percent = self:convertScrollPercent(pos.y)
		self.scrollView:jumpToPercentVertical(percent)
		
	elseif eventType == ccui.TouchEventType.ended then
		self:startTimeScheduler()
	elseif eventType == ccui.TouchEventType.canceled then
		--
		self:startTimeScheduler()
	end
end
--通过位置 转换scrollview的显示百分比
function TmjSettleWinLoseLayer:convertScrollPercent(posy)
	return 100 - 100*(posy - self.barPosYLimit[1])/(self.barPosYLimit[2] - self.barPosYLimit[1])
end

function TmjSettleWinLoseLayer:convertSliderPosition(ref,pos)
	
	local newpos = ref:getParent():convertToNodeSpace(pos)
	if newpos.y < self.barPosYLimit[1] then
		newpos.y = self.barPosYLimit[1]
	elseif newpos.y > self.barPosYLimit[2] then
		newpos.y = self.barPosYLimit[2]
	end
	return newpos	
end
function TmjSettleWinLoseLayer:getSliderPostionYByPercent(percent)
	local percent = math.min(percent,100)
	local percent = math.max(percent,0)
	return (self.barPosYLimit[2] - self.barPosYLimit[1])*(1 - percent/100) + self.barPosYLimit[1]
end
function TmjSettleWinLoseLayer:_onInterval(dt)
	self.countTime = self.countTime - 1
	if self.countTime >=0 then
		self.textTime:setString(tostring(self.countTime).."s")
		
	else
		self:stopScheduler()
		if self.exitCallBack then
			self.exitCallBack()
		end
		--self:removeFromParent()
	end
	
end


function TmjSettleWinLoseLayer:onExit()
	TmjSettleWinLoseLayer.super.onExit(self)
	self.exitCallBack = nil
	self.nexCallBack = nil
	self.resultData = nil
	self:stopScheduler()
	self:stopTimeScheduler()
end
function TmjSettleWinLoseLayer:onTouchListener(ref,eventType)
	if eventType == ccui.TouchEventType.began then
		TmjConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		if ref:getName()=="Button_back" then
			--退出到大厅
			if self.exitCallBack then
				self.exitCallBack()
			end
		elseif ref:getName()=="Button_opponent_card" then
			--对手的牌型
			self:initCardInfo(CustomHelper.seekNodeByName(self.node,"FileNode_showcard"),self.resultData.other.extraCards,self.resultData.other.handCards)
			local bar = CustomHelper.seekNodeByName(self.node,"Image_slider")
			local scrollview = CustomHelper.seekNodeByName(self.node,"ScrollView_desc")
			
			
			if self.resultData.winChairId == self.resultData.me.chair_id then --是我赢了
				scrollview:setVisible(false)
				if self.hasSliderBar then
					bar:setVisible(false)
				end
			else
				scrollview:setVisible(true)
				if self.hasSliderBar then
					bar:setVisible(true)
				end
			end
		elseif ref:getName()=="Button_self_card" then			
			--自己的牌型
			self:initCardInfo(CustomHelper.seekNodeByName(self.node,"FileNode_showcard"),self.resultData.me.extraCards,self.resultData.me.handCards)
			local bar = CustomHelper.seekNodeByName(self.node,"Image_slider")
			local scrollview = CustomHelper.seekNodeByName(self.node,"ScrollView_desc")
			if self.resultData.winChairId ~= self.resultData.me.chair_id then --是对面赢了
				scrollview:setVisible(false)
				if self.hasSliderBar then
					bar:setVisible(false)
				end
			else
				scrollview:setVisible(true)
				if self.hasSliderBar then
					bar:setVisible(true)
				end
			end
		elseif ref:getName()=="Button_exit" then
			--退出到大厅
			if self.exitCallBack then
				self.exitCallBack()
			end
		elseif ref:getName()=="Button_next" then
			--继续匹配下一局
			if self:checkTokickOut() then
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
function TmjSettleWinLoseLayer:stopScheduler()
    if self._scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)
        self._scheduler = nil
    end
end
--检查是否要被踢出去
function TmjSettleWinLoseLayer:checkTokickOut()
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

function TmjSettleWinLoseLayer:showLackMoney()
	--lackgold
	self:stopScheduler()
	if TmjHelper.isLuaNodeValid(self.proTimer) then
		self.proTimer:stopAllActions()
	end
	local bankCallbackFunc = function (  )
		local secondLayer = {}
		secondLayer.tag = ViewManager.SECOND_LAYER_TAG.BANK             
		local BankCenterLayer = requireForGameLuaFile("BankCenterLayer")
		secondLayer.parme = BankCenterLayer.ViewType.WithDraw
		local data = {}
		table.insert(data,secondLayer)
		if self.exitCallBack then
			self.exitCallBack(data)
		end
	end

	local storyCallbackFunc = function (  )
		local secondLayer = {}
		secondLayer.tag = ViewManager.SECOND_LAYER_TAG.STORY
		local data = {}
		table.insert(data,secondLayer)
		if self.exitCallBack then
			self.exitCallBack(data)
		end
	end
	local exitCallBackFunc = function ()
		if self.exitCallBack then
			self.exitCallBack()
		end
	end
	local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
	CustomHelper.showLackMoneyAlertView(roomInfo[HallGameConfig.SecondRoomMinMoneyLimitKey],
										Tmji18nUtils:getInstance():get('str_mjplay','lackgold'),
										exitCallBackFunc,
										bankCallbackFunc,
										storyCallbackFunc,
										nil)
--[[	CustomHelper.showAlertView(
			Tmji18nUtils:getInstance():get('str_mjplay','lackgold'),
			false,
			true,
			self.exitCallBack,
			self.exitCallBack
	)--]]
end

return TmjSettleWinLoseLayer