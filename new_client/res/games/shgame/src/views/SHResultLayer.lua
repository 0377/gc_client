-------------------------------------------------------------------------
-- Desc:    二人梭哈结算界面
-- Author:  zengzx
-- Date:    2017.5.11
-- Last: 
-- Content:  
--    1.结算界面 
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHResultLayer = class("SHResultLayer",requireForGameLuaFile("SHPopBaseLayer"))
local SHResultLayerCCS = requireForGameLuaFile("SHResultLayerCCS")
local SHConfig = import("..cfg.SHConfig")
local SHHelper = import("..cfg.SHHelper")
local SHCard = requireForGameLuaFile("SHCard")
local scheduler = cc.Director:getInstance():getScheduler()

local CardTypeImg = {
	--高牌 散牌
	[SHHelper.CardType.HIGH_CARD] = "game_res/secondView/sh_js_sp.png",
	--一对
	[SHHelper.CardType.ONE_PAIR] = "game_res/secondView/sh_js_yd.png",
	--两对
	[SHHelper.CardType.TWO_PAIR] = "game_res/secondView/sh_js_ld.png",
	--三条
	[SHHelper.CardType.THREE] = "game_res/secondView/sh_js_sant.png",
	--顺子
	[SHHelper.CardType.STRAIGHT] = "game_res/secondView/sh_js_sz.png",
	 --同花
	[SHHelper.CardType.FLUSH] = "game_res/secondView/sh_js_th.png",
	--满堂红 fullhouse 三带一对
	[SHHelper.CardType.THREE_PAIR] = "game_res/secondView/sh_js_mth.png",
	--四条
	[SHHelper.CardType.FOUR] = "game_res/secondView/sh_js_st.png",
	--同花顺
	[SHHelper.CardType.STRAIGHT_FLUSH] = "game_res/secondView/sh_js_ths.png",
}
local countDownTime = 15 --倒计时的长度
--@param resultData 结算数据 me other 
--@param exitCallBack 退出回调
--@param nexCallBack 下一局回调
function SHResultLayer:ctor(resultData,exitCallBack,nexCallBack)
	
	SHResultLayer.super.ctor(self)
	self:setName("SHResultLayer")
	self.resultData = resultData
	self.exitCallBack = exitCallBack --退出按钮回调
	self.nexCallBack = nexCallBack --下一局回调
	self.countTime = countDownTime --当前倒计时
	self:enableNodeEvents()
	
end

function SHResultLayer:onEnter()
	local node = SHResultLayerCCS:create()
	self:addChild(node.root)
	CustomHelper.seekNodeByName(node.root,"Button_close"):addTouchEventListener(handler(self,self.onTouchListener))
	CustomHelper.seekNodeByName(node.root,"Button_start"):addTouchEventListener(handler(self,self.onTouchListener))
	CustomHelper.seekNodeByName(node.root,"Button_autoReady"):addTouchEventListener(handler(self,self.onTouchListener))
	self.timeLabel = CustomHelper.seekNodeByName(node.root,"AtlasLabel_time")
	
	self.readyCheckBox = CustomHelper.seekNodeByName(node.root,"CheckBox_ready")	
	self.readyCheckBox:addTouchEventListener(handler(self,self.onTouchListener))
	self.node = node.root
	self._scheduler = scheduler:scheduleScriptFunc(handler(self,self._onInterval), 1, false)
	self.timeLabel:setString(tostring(self.countTime))
	
	local spriteProgress = CustomHelper.seekNodeByName(node.root,"Sprite_bar")
	local proX,proY = spriteProgress:getPosition()
	local spritParent = spriteProgress:getParent()
	spriteProgress:setVisible(false)
	
	--spriteProgress:removeFromParentAndCleanUp(false)
    local progressTimer = cc.ProgressTimer:create(display.newSprite("game_res/secondView/sh_djs_2.png"))
    progressTimer:setAnchorPoint(0.5, 0.5)
    progressTimer:setPosition(cc.p(proX,proY))
    progressTimer:setReverseDirection(true)
    progressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    progressTimer:setPercentage(100)
	progressTimer:addTo(spritParent)
   
	self.proTimer = progressTimer
	progressTimer:runAction(cc.ProgressFromTo:create(countDownTime,100,0))
	
	local otherImg = CustomHelper.seekNodeByName(node.root,"Image_other")
	local meImg = CustomHelper.seekNodeByName(node.root,"Image_me")
--	resulData.selfCHairId = selfCharId
--  resulData.otherCharId = otherCharId
	--自己的
	self:setPlayerResult(meImg,self.resultData[self.resultData.selfCHairId])
	--对面的
	self:setPlayerResult(otherImg,self.resultData[self.resultData.otherCharId])
	
	local Image_bg = CustomHelper.seekNodeByName(node.root,"Image_bg")
	self:popIn(Image_bg,SHConfig.Pop_Dir.Right)
	
end
--设置玩家结算信息
--@param rootImg 玩家父节点
--@param resultData 玩家数据
function SHResultLayer:setPlayerResult(rootImg,resultData)
	if not SHHelper.isLuaNodeValid(rootImg) or not resultData then
		sslog(self.logTag,"玩家信息或者节点错误")
		return
	end
	--头像
	local headFrame = CustomHelper.seekNodeByName(rootImg,"Image_head_frame")
	if resultData.headId then
		local headPath = CustomHelper.getFullPath(string.format("hall_res/head_icon/%d.png",resultData.headId or 1))
		if cc.FileUtils:getInstance():isFileExist(headPath) then
			headFrame:removeAllChildren()
			local imgIcon = ccui.ImageView:create()
			imgIcon:ignoreContentAdaptWithSize(true)
			imgIcon:loadTexture(headPath,ccui.TextureResType.localType)
			imgIcon:setContentSize(headFrame:getContentSize())
			imgIcon:addTo(headFrame)
			imgIcon:move(headFrame:getContentSize().width/2,headFrame:getContentSize().height/2)
		end
	end
	--输赢了多少钱
	local textMoney = CustomHelper.seekNodeByName(rootImg,"AtlasLabel_moeny")
	
	if resultData.win_money then
		local s = string.gsub(tostring(resultData.win_money/100), '%.', '/' )
		local s = string.gsub(s, '%-', ';' )
		textMoney:setString(s)
	end
	--税收 赢了的才才有
	local textTax = CustomHelper.seekNodeByName(rootImg,"Text_tax")
	if not resultData.taxes then
		textTax:setVisible(false)
	else
		textTax:setVisible(true)
		
		local s = tostring(math.abs(resultData.taxes)/100)
		textTax:setString(string.format(SHi18nUtils:getInstance():get('str_gameover','tax'),s))
	end
	resultData.handCards = resultData.handCards or {}
	--手上的牌
	for i=1,5 do
		local fnode = CustomHelper.seekNodeByName(rootImg,string.format("FileNode_card%d",i))
		if resultData.handCards[i] then
			local card = SHCard:create(resultData.handCards[i])
			card:addTo(fnode:getParent())
			card:setScale(fnode:getScale())
			card:setCardPosition(cc.p(fnode:getPositionX(),fnode:getPositionY()),true)
		end
		if SHHelper.isLuaNodeValid(fnode) then
			fnode:removeFromParent()
		end
		
	end
	--牌型比较标志
	local resultImg = CustomHelper.seekNodeByName(rootImg,"Image_result")
	--sh_js_xk_2
	resultImg:ignoreContentAdaptWithSize(true)
	local resultPath = (resultData.is_win==true and "game_res/secondView/sh_js_xk_1.png" or "game_res/secondView/sh_js_xk_2.png")
	resultImg:loadTexture(resultPath ,ccui.TextureResType.localType)
	resultImg:setLocalZOrder(2)
	--Image_type
	local typeImg = CustomHelper.seekNodeByName(rootImg,"Image_type")
	typeImg:ignoreContentAdaptWithSize(true)
	local winImg = CustomHelper.seekNodeByName(rootImg,"Image_win")
	local cardType = SHHelper.getCardType(resultData.handCards)
	local ctimg = CardTypeImg[cardType]
	if not ctimg or not cc.FileUtils:getInstance():isFileExist(ctimg) then
		resultImg:setVisible(false)
	else
		resultImg:setVisible(true)
		typeImg:loadTexture(ctimg,ccui.TextureResType.localType)
		winImg:setVisible(resultData.is_win==true)
		local contentWidth = typeImg:getContentSize().width + (resultData.is_win==true and winImg:getContentSize().width or 0)
		
		local resultImgSize = resultImg:getContentSize()
		local startPos = (resultImgSize.width - contentWidth) / 2
		typeImg:setPosition(cc.p(startPos+typeImg:getContentSize().width/2,resultImgSize.height/2))
		if resultData.is_win==true then
			winImg:setPosition(cc.p(startPos+typeImg:getContentSize().width+winImg:getContentSize().width/2,resultImgSize.height/2))
		end
	end
	
end

function SHResultLayer:_onInterval(dt)
	self.countTime = self.countTime - 1
	if self.countTime >=0 then
		self.timeLabel:setString(tostring(self.countTime))
		
	else
		self:stopScheduler()
		--是否勾选了自动准备
		if self.readyCheckBox:isSelected() then
			if self:checkTokickOut() then
				if self.exitCallBack then
					self.exitCallBack()
				end
			else
				if self.nexCallBack then
					self.nexCallBack()
				end
			end
		else
			if self.exitCallBack then
				self.exitCallBack()
			end
		end

		
	end
	
end
function SHResultLayer:stopScheduler()
	if self._scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)
        self._scheduler = nil
    end
end

function SHResultLayer:onExit()
	SHResultLayer.super.onExit(self)
	self.exitCallBack = nil
	self.nexCallBack = nil
	self.resultData = nil
    self:stopScheduler()

end

function SHResultLayer:onTouchBegin(touch,event)
  if event:getEventCode() == cc.EventCode.BEGAN then
        return true
    elseif event:getEventCode() == cc.EventCode.ENDED then
       -- self:close()
    end
end

function SHResultLayer:onTouchListener(ref,eventType)
	if eventType == ccui.TouchEventType.began then
		SHConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		if ref:getName()=="Button_close" then
			--退出到大厅
			self:stopScheduler()
			if self.exitCallBack then
				self.exitCallBack()
			end
		elseif ref:getName()=="Button_autoReady" then
			--setSelected
			self.readyCheckBox:setSelected(not self.readyCheckBox:isSelected())
			
		elseif ref:getName()=="Button_start" then
			--继续匹配下一局
			self:stopScheduler()
			--HallGameConfig.SecondRoomMinJettonLimitKey
			if self:checkTokickOut() then
				if self.exitCallBack then
					self.exitCallBack()
				end
			else
				if self.nexCallBack then
					self.nexCallBack()
				end
			end

			--self:removeFromParent()
		end
		
		
	end
end
--检查是否要被踢出去
function SHResultLayer:checkTokickOut()
	local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
	local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
	if roomInfo and myPlayerInfo and roomInfo[HallGameConfig.SecondRoomMinJettonLimitKey] then
		if myPlayerInfo:getMoney() < roomInfo[HallGameConfig.SecondRoomMinJettonLimitKey] then
			return true
		end
	end
	return false
end

return SHResultLayer