-------------------------------------------------------------------------
-- Desc:    二人梭哈玩家基础封装
-- Author:  zengzx
-- Date:    2017.4.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHPlayer = class("SHPlayer",cc.Layer)
local SHCard = requireForGameLuaFile("SHCard")
local SHHelper = import("..cfg.SHHelper")
local SHConfig = import("..cfg.SHConfig")

local ChatAnimatorFactory = requireForGameLuaFile("ChatAnimatorFactory")

SHPlayer.playerCmd = {
	[SHConfig.CardOperation.Fall] = function (self,cardInfo) if self['fallCard'] then self['fallCard'](self,cardInfo) end end, -- 弃牌
	[SHConfig.CardOperation.Call] = function (self,cardInfo) if self['callCard'] then self['callCard'](self,cardInfo) end end, -- 跟注
	[SHConfig.CardOperation.Raise] = function (self,cardInfo) if self['raiseCard'] then self['raiseCard'](self,cardInfo) end end, -- 加注
	[SHConfig.CardOperation.ShowHand] = function (self,cardInfo) if self['showHandCard'] then self['showHandCard'](self,cardInfo) end end, -- 梭哈
	[SHConfig.CardOperation.Pass] = function (self,cardInfo) if self['passCard'] then self['passCard'](self,cardInfo) end end, -- 过牌
	[SHConfig.CardOperation.GetCard] = function (self,cardInfo) if self['getOneCard'] then self['getOneCard'](self,cardInfo) end end, -- 得到一张牌
	[SHConfig.CardOperation.ShowDecision] = function (self,cardInfo) if self['showDealView'] then self['showDealView'](self,cardInfo) end end, -- 该我说话

	
}

function SHPlayer:ctor(pinfo)
	self.pinfo = pinfo
	self.seatId = pinfo.seatid or 0
	self.logTag = self.__cname..".lua"
	self:enableNodeEvents()
	self.pType = nil --玩家类型
	self.cardInfos = {} --用于存储牌的位置，尺寸信息
	
	self.cards = {} --手上的牌 包含节点以及数据
	self.cardDatas = {} -- 手上牌的数据结构
	
	self.gamebet = 0 --当局下注
	
	self.zorderIndex = 1 --层级
	
end
--获取玩家的名字
function SHPlayer:getUserName()
	if self.pinfo then
		
	end
	return self.pinfo and self.pinfo.nickname or nil
	
end

--设置金币父容器
function SHPlayer:setGoldNode(panelNode)
	self.panelNode = panelNode
end
--初始化头像
--@param HeadNodeCCS 头像UI文件路径
function SHPlayer:initHead(HeadNode)
	if not SHHelper.isLuaNodeValid(self.headNode) then
		self.headNode = HeadNode
		--self.headNode:addTo(self)
		--self.headNode:setPosition(headPos)
	end
	self.headNode:setVisible(true)
	local headBg = CustomHelper.seekNodeByName(self.headNode,"Image_head")
	local userNameText = CustomHelper.seekNodeByName(self.headNode,"Text_userName")
	local goldText = CustomHelper.seekNodeByName(self.headNode,"Text_gold")
	local gameBetLabel = CustomHelper.seekNodeByName(self.headNode,"AtlasLabel_gamebet")
	local roundImg = CustomHelper.seekNodeByName(self.headNode,"Image_roundtag")
	local roundLabel = CustomHelper.seekNodeByName(self.headNode,"AtlasLabel_roundbet")
	
	
	
	headBg:removeAllChildren()
	userNameText:setString("")
	goldText:setString("")
	gameBetLabel:setString("0")
	
	roundImg:setVisible(false)
	roundLabel:setVisible(false)
	if not self.cardInfos or not next(self.cardInfos) then
		self.cardInfos = {}
		for i=1,5 do
			local fnode = CustomHelper.seekNodeByName(self.headNode,string.format("FileNode_%d",i))
			fnode:setVisible(false)
			
			local position = fnode:convertToWorldSpace(cc.p(0,0))
			table.insert(self.cardInfos,{ scale = fnode:getScale(),position = position })
		end
		
		
	end
	
end
--获得金币位置 金币是从玩家头像上飞过去的实际上就是头像的位置
function SHPlayer:getGoldPos( ... )
	-- body
	local Image_bg = CustomHelper.seekNodeByName(self.headNode,"Image_bg")
	local headBg = CustomHelper.seekNodeByName(self.headNode,"Image_head")
	return Image_bg:convertToWorldSpace(cc.p(headBg:getPositionX(),headBg:getPositionY()))
end
--设置操作回调 弃牌 跟注 加注 梭哈 过牌
function SHPlayer:setOperationCallBack(operationFun)
	self.operationFun = operationFun
end
--设置最大的倒计时
function SHPlayer:setMaxLeftTime(maxleftTime)
	self.maxLeftTime = maxleftTime
end
--设置剩余的操作时间
function SHPlayer:setLeftTime(leftTime)
	self.leftTime = leftTime
	self.curCountTime = self.leftTime
end
--设置下注的限制
function SHPlayer:setBetLimit(betLimit)
	self.betLimit = betLimit
end
--设置当前这轮的下注金额
function SHPlayer:setRoundBet(roundBet)
	self.roundBet = roundBet
end
--设置底注
function SHPlayer:setBaseBet(baseBet)
	self.baseBet = baseBet
end
--执行动作
--@param cardInfo 牌信息
function SHPlayer:doOperation(operation,cardInfo)
	local cmdMethod = SHPlayer.playerCmd[operation]
	if cmdMethod then
		cmdMethod(self,cardInfo)
	else
		sslog(self.logTag,"error do operation:"..tostring(operation))
	end
end

--初始化头像信息
--@headInfo 头像信息
--@key gold  用户金币
--@key username  用户昵称
--@key headId  头像ID
--@key gamebet  当局下注金额
--@key roundType  当轮操作类型 加注 跟注 梭哈  SHConfig.CardOperation  Fall,Call,Raise,ShowHand,Pass
--@key roundbet  当轮下注金额
function SHPlayer:setHeadInfo(headInfo)
	if not SHHelper.isLuaNodeValid(self.headNode) then
		return --头像还未初始化
	end
	local headBg = CustomHelper.seekNodeByName(self.headNode,"Image_head")
	local userNameText = CustomHelper.seekNodeByName(self.headNode,"Text_userName")
	local goldText = CustomHelper.seekNodeByName(self.headNode,"Text_gold")
	local gameBetLabel = CustomHelper.seekNodeByName(self.headNode,"AtlasLabel_gamebet")
	local roundImg = CustomHelper.seekNodeByName(self.headNode,"Image_roundtag")
	local roundLabel = CustomHelper.seekNodeByName(self.headNode,"AtlasLabel_roundbet")
	if headInfo.headId then
		local headPath = CustomHelper.getFullPath(string.format("hall_res/head_icon/%d.png",headInfo.headId or 1))
		if cc.FileUtils:getInstance():isFileExist(headPath) then
			headBg:removeAllChildren()
			local imgIcon = ccui.ImageView:create()
			imgIcon:ignoreContentAdaptWithSize(true)
			imgIcon:loadTexture(headPath,ccui.TextureResType.localType)
			imgIcon:setContentSize(headBg:getContentSize())
			imgIcon:addTo(headBg)
			imgIcon:move(headBg:getContentSize().width/2,headBg:getContentSize().height/2)
		end
	end	
	if headInfo.gold then
		self.gold = headInfo.gold --当前的金币数
		local goldStr = tostring(headInfo.gold/100)
		goldText:setString(goldStr)
	end
	if headInfo.username then
		userNameText:setString(tostring(headInfo.username))
	end
	if headInfo.gamebet then
		self.gamebet = headInfo.gamebet
		local s = string.gsub(tostring(headInfo.gamebet), '%.', '/' )
		gameBetLabel:setString(s)
	end
	
	if headInfo.roundType then
		local function getRoundImg(roundType)
			if roundType == SHConfig.CardOperation.Call then
				return "game_res/mainView/sh_genzhu.png","game_res/mainView/sh_szt_3.png"
			elseif roundType == SHConfig.CardOperation.Raise then
				return "game_res/mainView/sh_jiazhu.png","game_res/mainView/sh_szt_1.png"
			elseif roundType == SHConfig.CardOperation.ShowHand then
				return "game_res/mainView/sh_suoha.png","game_res/mainView/sh_szt_4.png"
			else --过 弃牌
				return nil,nil
			end
		end
		local roundImgPath,roundLabelPath = getRoundImg(headInfo.roundType)
		if not roundImgPath then
			roundImg:setVisible(false)
		else
			roundImg:setVisible(true)
			roundImg:loadTexture(roundImgPath,ccui.TextureResType.localType)
		end
		if not roundLabelPath then
			roundLabel:setVisible(false)
		else
			if headInfo.roundbet then --0,"game_res/mainView/sh_szt_2.png",13,17,"/"
				roundLabel:setVisible(true)
				local s = string.gsub(tostring(headInfo.roundbet), '%.', '/' )
				roundLabel:setProperty(s,roundLabelPath,13,17,"/")
			end
			
		end
		
	end
	
end
--播放操作的动画 在头像上显示一个角标
function SHPlayer:playOperationAnim(operation,diffY)
	local bg = CustomHelper.seekNodeByName(self.headNode,"Image_bg")
	if SHHelper.isLuaNodeValid(self.opAnimNode) then
		self.opAnimNode:removeFromParent()
		self.opAnimNode = nil
	end
	local spPath = nil
	if operation ==SHConfig.CardOperation.Fall then
		spPath = "game_res/mainView/sh_ltqp_qp.png"
	elseif operation == SHConfig.CardOperation.Call then
		spPath = "game_res/mainView/sh_ltqp_gz.png"
	elseif operation == SHConfig.CardOperation.Pass then
		spPath = "game_res/mainView/sh_ltqp_gp.png"
	elseif operation == SHConfig.CardOperation.Raise then
		spPath = "game_res/mainView/sh_ltqp_jz.png"
	elseif operation == SHConfig.CardOperation.ShowHand then
		spPath = "game_res/mainView/sh_ltqp_sh.png"
	end
	if spPath then
		self.opAnimNode = display.newSprite(spPath)
		self.opAnimNode:addTo(bg)
		local bgSize = bg:getContentSize()
		local bgPos = cc.p(bgSize.width/2,bgSize.height)
		local animNodeSize = self.opAnimNode:getContentSize()
		self.opAnimNode:setPosition(cc.pAdd(bgPos,cc.p(0,animNodeSize.height/2 + (diffY or 0))))
		
		--这里需要删除吗？？
	end
	
end
--播放牌型动画
--@param showDatas 传入的牌的数据集合 不传入的时候使用手上的牌进行播放
function SHPlayer:showCardType(showDatas)
	local cardDatas = {}
	if not showDatas then
		if not self.cards or not next(self.cards) then
			return
		end
		
		table.walk(self.cards,function (v,k)
			table.insert(cardDatas,v.info)
		end)
	else
		cardDatas = showDatas
	end

	local cardType = SHHelper.getCardType(cardDatas)
	if SHHelper.CardTypeAnim[cardType] then
		SHConfig.playAmature(
			"sh_pxdh_eff",
			SHHelper.CardTypeAnim[cardType],
			self,
			self.cardInfos[3].position,
			false,
			false)
	end
end
--播放聊天内容动画
function SHPlayer:showChatAnim(data)
	if self.chatAnimator then
		self.chatAnimator:stop() --如果有，先停止
		self.chatAnimator = nil
	end
end

--播放赢动画
function SHPlayer:showWinAnim()
	local imgBg = CustomHelper.seekNodeByName(self.headNode,"Image_bg")
	local bgSize = imgBg:getContentSize()
	SHConfig.playAmature("sh_pxdh_eff","ani_01",
		imgBg,
		cc.p(bgSize.width/2,bgSize.height/2 + 6),false,false)
end
--播放翻转牌的动画 视情况而定
function SHPlayer:runOpenCardAnim(createTag)

end
--删除倒计时动画
function SHPlayer:removeProgress()
	local bg = CustomHelper.seekNodeByName(self.headNode,"Image_bg")
	if SHHelper.isLuaNodeValid(bg) then
		bg:removeChildByName("progressTimer")
	end
	--手动重置一下
	self.curCountTime = self.maxLeftTime
end

function SHPlayer:getBetAmount()
	return self.gamebet
end

--拿到一张牌
--@param cardInfo 牌信息
--@key createTag 是否直接创建牌 没有动画的
--@key col 花色
--@key val 点数
function SHPlayer:getOneCard(cardInfo)
	
	
	if cardInfo and not cardInfo.createTag then
		local SHGameDataManager = SHGameManager:getInstance():getDataManager()
		SHGameDataManager.roundBet = 0 
		self:setRoundBet(0) --发牌后，重置当前这轮的下注额度
	end
	local curIndex = table.nums(self.cards) + 1
	local function getCardFun(createTag)
		self:runOpenCardAnim(createTag)
		if self.operationFun then
			self.operationFun(self.pType,SHConfig.CardOperation.GetCard)--得到牌结束
		end
	end
	
	local infos = self.cardInfos[curIndex]
	if infos then
		cardInfo.position = infos.position
		cardInfo.scale = infos.scale
		if curIndex == 1 then --第一张牌，是暗牌
			cardInfo.isDark = true
		end
		local cardNode = SHCard:create(cardInfo)
		table.insert(self.cards,{node = cardNode,info = cardInfo })
		cardNode:addTo(self)
		if cardInfo.createTag then
			cardNode:setCardPosition(cardInfo.position,true)
			getCardFun(cardInfo.createTag)
		else --播放动画
			--从屏幕中间飞过来
			--
			cardNode:setPosition(cc.pAdd(display.center,cc.p(0,50)))
			cardNode:setScale(1.0)
			local spawnAction = cc.Spawn:create(
				cc.ScaleTo:create(0.4,cardInfo.scale),
				cc.MoveTo:create(0.4,cardInfo.position),
				cc.EaseExponentialOut:create(cc.RotateBy:create(0.4,-360)))
			local action = transition.sequence({
				cc.DelayTime:create(0.8),
				spawnAction,
				cc.CallFunc:create(function ()
					getCardFun(false)
				end)
			})
			
			cardNode:runAction(action)
		end
		
		
	else --超过限制了
		sslog(self.logTag,"牌数量超过限制了"..tostring(curIndex))
		getCardFun(true)
	end
	
	
end
--显示需要我操作的UI 包括按钮，倒计时
--@param cardinfo 
--@key operationTypes 可以操作的类型集合
--@key max_add 最大的加注数额，也就是allin
function SHPlayer:showDealView(cardinfo)
	--self.leftTime
	if SHHelper.isLuaNodeValid(self.opAnimNode) then
		self.opAnimNode:removeFromParent()
		self.opAnimNode = nil
	end
	
	local leftTimeSp = {
		[self.maxLeftTime*0.2] = "game_res/mainView/sh_txkuang_wfg_3.png",
		[self.maxLeftTime*0.5] = "game_res/mainView/sh_txkuang_wfg_2.png",
		[self.maxLeftTime*0.8] = "game_res/mainView/sh_txkuang_wfg.png",
	}
	--根据剩余的时间，返回倒计时边框的资源
	local function getLeftTimeSp(time)
		local maxSp = leftTimeSp[self.maxLeftTime*0.2]
		for i,v in pairs(leftTimeSp) do
			if time>=i then
				maxSp = v
			end
		end
		return maxSp
	end
	
	local spriteProgress = display.newSprite(getLeftTimeSp(self.leftTime or 0))
	sslog(self.logTag,"当前倒计时:"..tostring(self.leftTime)..",最大倒计时:"..tonumber(self.maxLeftTime))
	local percent = 100*self.leftTime/self.maxLeftTime
	local bg = CustomHelper.seekNodeByName(self.headNode,"Image_bg")
	bg:removeChildByName("progressTimer")
	local bgSize = bg:getContentSize()
    local progressTimer = cc.ProgressTimer:create(spriteProgress)
	progressTimer:setName("progressTimer")
    progressTimer:setAnchorPoint(0.5, 0.5)
    progressTimer:setPosition(cc.p(bgSize.width/2,bgSize.height/2))
    progressTimer:setReverseDirection(true)
    progressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
	
    progressTimer:setPercentage(percent)
	progressTimer:addTo(bg)
	progressTimer:runAction(cc.ProgressFromTo:create(self.leftTime,percent,0))
	local seqAction = transition.sequence({
			cc.DelayTime:create(0.5),
			cc.CallFunc:create(function ()
				self.curCountTime = self.curCountTime - 0.5
				--sslog(self.logTag,"当前倒计时UI显示:"..tostring(self.curCountTime))
				if self.curCountTime<=0 then
					self.curCountTime = self.maxLeftTime
					progressTimer:stopAllActions()
					progressTimer:removeFromParent()
				else
					spriteProgress:setTexture(getLeftTimeSp(self.curCountTime))
				end
			end)
		})
	progressTimer:runAction(cc.RepeatForever:create(seqAction))
	
	if self.operationFun then
		self.operationFun(self.pType,SHConfig.CardOperation.ShowDecision) --说话操作结束
	end
end

--弃牌
function SHPlayer:fallCard(cardInfo)
	--todo
	if self.operationFun then
		self.operationFun(self.pType,SHConfig.CardOperation.Fall)--弃牌结束
	end
	self:setRoundBet(0)
--@key roundType  当轮操作类型 加注 跟注 梭哈  SHConfig.CardOperation  Fall,Call,Raise,ShowHand,Pass
--@key roundbet  当轮下注金额
	self:setHeadInfo({ roundType=SHConfig.CardOperation.Fall,roundbet = 0 })
end
--跟注
function SHPlayer:callCard(cardInfo)
	sslog(self.logTag,"玩家跟注")
	--todo

	--这里去最大的
	local SHGameDataManager = SHGameManager:getInstance():getDataManager()
	local roundBet = SHGameDataManager.roundBet /100
	local diff = roundBet
	if self.roundBet then
		diff = diff - self.roundBet
	end
	self:playBetAnim(diff*100)
--@key gamebet  当局下注金额
--@key roundType  当轮操作类型 加注 跟注 梭哈  SHConfig.CardOperation  Fall,Call,Raise,ShowHand,Pass
--@key roundbet  当轮下注金额
	self.gamebet = self.gamebet + diff
	self:setHeadInfo({ gamebet= self.gamebet,roundType=SHConfig.CardOperation.Call,roundbet = roundBet })
	self:addGameBetToTable(diff)
	if self.operationFun then
		self.operationFun(self.pType,SHConfig.CardOperation.Call)--跟注结束
	end
end
--加注
function SHPlayer:raiseCard(cardInfo)
	--todo
	sslog(self.logTag,"玩家加注"..tostring(cardInfo))

	local diff = cardInfo/100
	if self.roundBet then
		diff = diff - self.roundBet
	end
	local SHGameDataManager = SHGameManager:getInstance():getDataManager()
	SHGameDataManager.roundBet = cardInfo --这一轮的最大下注额度
	
	self:setRoundBet(cardInfo/100)
	--
	self:playBetAnim(diff*100)
--@key gamebet  当局下注金额
--@key roundType  当轮操作类型 加注 跟注 梭哈  SHConfig.CardOperation  Fall,Call,Raise,ShowHand,Pass
--@key roundbet  当轮下注金额
	self.gamebet = self.gamebet + diff
	self:setHeadInfo({ gamebet= self.gamebet,roundType=SHConfig.CardOperation.Raise,roundbet = cardInfo/100 })
	self:addGameBetToTable(diff)
	if self.operationFun then
		self.operationFun(self.pType,SHConfig.CardOperation.Raise)--加注结束
	end
end
--梭哈
function SHPlayer:showHandCard(cardInfo)
	--todo
	sslog(self.logTag,"玩家梭哈")

	
	local SHGameDataManager = SHGameManager:getInstance():getDataManager()
	local maxAdd = SHGameDataManager.maxAdd
	SHGameDataManager.roundBet = maxAdd --这一轮的最大下注额度
	sslog(self.logTag,"玩家梭哈SHGameDataManager.roundBet "..tostring(SHGameDataManager.roundBet))
	local diff = maxAdd /100
	if self.roundBet then
		diff = diff - self.roundBet
	end

	self:playBetAnim(diff*100)
--@key gamebet  当局下注金额
--@key roundType  当轮操作类型 加注 跟注 梭哈  SHConfig.CardOperation  Fall,Call,Raise,ShowHand,Pass
--@key roundbet  当轮下注金额
	self.gamebet = self.gamebet + diff
	self:setHeadInfo({ gamebet= self.gamebet,roundType=SHConfig.CardOperation.ShowHand,roundbet = maxAdd/100 })
	self:addGameBetToTable(diff)
	if self.operationFun then
		self.operationFun(self.pType,SHConfig.CardOperation.ShowHand)--梭哈结束
	end
end
--过牌
function SHPlayer:passCard(cardInfo)
	--todo
	sslog(self.logTag,"玩家过牌")

--@key roundType  当轮操作类型 加注 跟注 梭哈  SHConfig.CardOperation  Fall,Call,Raise,ShowHand,Pass
--@key roundbet  当轮下注金额
	self:setHeadInfo({ roundType=SHConfig.CardOperation.Pass,roundbet = 0 })
	if self.operationFun then
		self.operationFun(self.pType,SHConfig.CardOperation.Pass)--过牌结束
	end
end
--播放金币动画
--@param gold 金币数量
--@param createTag 是否是直接创建 true 就不需要动画了 恢复对局的时候需要
function SHPlayer:playBetAnim(gold,createTag)
	if not self.panelNode then
		return
	end
	local ret = SHConfig.splitGold(gold)

	for i,v in pairs(ret) do
		if v and v.count>0 then
			
			local srcPos = self.panelNode:convertToNodeSpace(self:getGoldPos())
			--拆分金币
			local size = self.panelNode:getContentSize()
			
			local destPos = cc.p(math.random(30,size.width - 60),size.height/2)
		
			self:rollGold(v.path,srcPos,destPos,v.count,createTag)
			
		end
	end
end

-- rollGold("*.png",Player:getGoldPos(),BankPlayer:getGoldPos(),math.abs(v.InCome)/BullGoldToImg,function ( ... )
function SHPlayer:rollGold( resPath,srcPos,destPos,count,createTag,callBack )
	-- body
	if not self.panelNode then
		return --
	end
  	local goldBatchNode = cc.SpriteBatchNode:create(resPath)
  	self.panelNode:addChild(goldBatchNode)
	local SHRadomArea = 20
  	local goldNodeTable = {}
	
	sslog(self.logTag,"加注金额资源:"..tostring(resPath)..",个数:"..tostring(count))
  	for i=1,count do
  		local goldNode = cc.Sprite:create(resPath)
  		if goldNode then
  			-- goldNode:setPosition(cc.p(screenSize.width/2,screenSize.height*0.5))
  			goldNode:setPosition(cc.p(srcPos.x + math.random(-SHRadomArea,SHRadomArea),srcPos.y+ math.random(-SHRadomArea,SHRadomArea)))
  			goldBatchNode:addChild(goldNode)
  			table.insert(goldNodeTable,goldNode)
  		end
  	end
  	--金币滚动
	--playSoundEffect("sound/effect/bullfight/goldroll")

  	for k,v in pairs(goldNodeTable) do
		if v then
			local r = 75.0
			local angle = math.pi * 2 * math.random()
			local lr = r * 0.5 + r * 0.5 * math.random()
			local dx = math.sin(angle) * lr
			local dy = math.cos(angle) * lr
			local toPos = cc.p(destPos.x + dx, destPos.y + dy)
			if createTag then --直接创建，没有动画
				v:move(toPos)
			else
				local moveAction = cc.EaseBackOut:create(cc.MoveTo:create(0.5, toPos))
				local config = {cc.p(v:getPositionX(),v:getPositionY()), cc.p(toPos.x+(destPos.x-toPos.x)*0.5, toPos.y+(destPos.y-toPos.y)*0.5+50), toPos}
				local bezierAction = cc.BezierTo:create(0.5, config)

				v:runAction(cc.Sequence:create(cc.DelayTime:create(0.25/count* (count - k)), 
					cc.EaseSineOut:create(bezierAction), 
					cc.CallFunc:create(function ( node )
						-- body
						--node:setVisible(false)
					end),
					cc.DelayTime:create(0.5),
					cc.CallFunc:create(function (node)
						-- body
						if callBack and k == #goldNodeTable then
							callBack()
						end
						
						if node then
							--node:removeFromParent()
						end
					end)))
			end

		end
	end
end

function SHPlayer:addGameBetToTable(diff)
	local event1 = cc.EventCustom:new(SHConfig.UIMsgName.SH_ADD_GAMEBET)
	event1.data = diff
	cc.Director:getInstance():getEventDispatcher():dispatchEvent(event1)
end

function SHPlayer:onExit()
  --delete all cards
	for i,v in pairs(self.cards) do
		if SHHelper.isLuaNodeValid(v.node) then
			v.node:removeFromParent()
			v.node = nil
		end
	end
	SHHelper.removeAll(self.cards)
	SHHelper.removeAll(self.cardDatas)
	SHHelper.removeAll(self.cardInfos)
	self.cards = nil
	self.cardDatas = nil
	self.cardInfos = nil
end
return SHPlayer