-------------------------------------------------------------------------
-- Desc:    二人梭哈场景
-- Author:  zengzx
-- Date:    2017.5.11
-- Last: 
-- Content:  二人麻将游戏场景
--    1.负责消息UI处理
--	  2.玩家创建
--	  3.下注金额池子变动
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHGameScene = class("SHGameScene",requireForGameLuaFile("SubGameBaseScene"))
local SHConfig = import("..cfg.SHConfig")
local SHHelper = import("..cfg.SHHelper")
local DeviceUtils = requireForGameLuaFile("DeviceUtils")

local SHGameLayerCCS = requireForGameLuaFile("SHGameLayerCCS")

local SHCardTypeLayer = requireForGameLuaFile("SHCardTypeLayer")
local SHResultLayer = requireForGameLuaFile("SHResultLayer")
--GameManager:getInstance():getHallManager():getSubGameManager()
local scheduler = cc.Director:getInstance():getScheduler()
function SHGameScene.getNeedPreloadResArray()
	local resNeed = {
		CustomHelper.getFullPath("game_res/animation/sh_pxdh_eff.ExportJson"),
	}
	return resNeed
end
function SHGameScene:ctor()
	SHGameScene.super.ctor(self)
	self.logTag = self.__cname..".lua"
	self:setName("SHGameScene")
	self:enableNodeEvents()
	
	
	self.SHGameDataManager = SHGameManager:getInstance():getDataManager()
	self.operationComlete = true
	self.seats = {} --玩家信息

end

----注册消息
function SHGameScene:registerNotification()
    SHGameScene.super.registerNotification(self)
	
	for _,msgName in pairs(SHConfig.MsgName) do
		--注册SC开头的消息
		if string.match(msgName,"SC_(.+)") then
			sslog(self.logTag,"注册消息 "..msgName)
			self:addOneTCPMsgListener(msgName)
		end
		
	end
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_StandUpAndExitRoom)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_EnterRoomAndSitDown)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_NotifySitDown)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_NotifyStandUp)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_Ready)
	
	self:addCustomEventListener(SHConfig.UIMsgName.SH_ADD_GAMEBET, handler(self, self.changeTotalBet))
	self:addCustomEventListener(HallMsgManager.kNotifyName_RefreshPlayerInfo, handler(self, self.onHallMsgSC_NotifyMoney))
		
end

function SHGameScene:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"]
	--如果是我这边注册的消息
	if table.keyof(SHConfig.MsgName,msgName) then
		local methodName = "onMsg"..msgName
		if self[methodName] then
			self[methodName](self,userInfo)
		end
	elseif table.keyof(HallMsgManager.MsgName,msgName) then
		local methodName = "onHallMsg"..msgName
		if self[methodName] then
			self[methodName](self,userInfo)
		end
	end
    SHGameScene.super.receiveServerResponseSuccessEvent(self,event)
end


function SHGameScene:onEnter()
	sslog(self.logTag,"二人梭哈onEnter")
    local gameingInfoTable = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
    if gameingInfoTable == nil then
        ---发送准备
       SHGameManager:getInstance():sendGameReady()
    else
		--发送重连
       SHGameManager:getInstance():sendReconnectMsg()
    end
	self:initTable()
	self:initMenu() --显示菜单
	self:startDeviceSchedule()
end
--开启设备显示信息计时器
function SHGameScene:startDeviceSchedule()
	--进来就要显示时间的
	self._timescheduler = scheduler:scheduleScriptFunc(handler(self,self._intervalTime), 20, false)
	self:_intervalTime() --先调用一次
	--定时器获取wifi信号，电池电量
	self._wifischeduler = scheduler:scheduleScriptFunc(handler(self,self._intervalWIFI), 5, false)
	self:_intervalWIFI() --先调用一次
end
--电池和wifi的计时器
function SHGameScene:_intervalWIFI(dt)
	--@param deviceInfo 设备信息的数据集
	--@key signal 信号强度  0 没网 1 信号差 2 信号一般 3 信号很好
	--@key time 格式化时间
	--@key electric 电量 0-100 表示当前电量 <0 表示正在充电中
    ---电量
    local batteryLevel = DeviceUtils.getBatteryLevel()
    batteryLevel = math.max(batteryLevel,0) --这里的电量取最大数值 

    ---是否充电
    local  batteryStatus =  DeviceUtils.getBatteryStatus()
    if batteryStatus == true then
		batteryLevel = -1 --充电中
    end

    ----信号类型
    local  onnectivityType = DeviceUtils.getConnectivityType()
	local wifiLevel = 3
    if onnectivityType == 0  then --none
		wifiLevel = 0 --没网
    elseif onnectivityType == 2 then ---mobile
        local mobileSignalLevel = DeviceUtils.getMobileSignalLevel();
        wifiLevel = mobileSignalLevel
    elseif onnectivityType == 1 then ---wifi
        local wifiSignalLevel = DeviceUtils.getWifiSignalLevel()		
		wifiLevel = wifiSignalLevel
    end
	if self.setDeviceInfo then
		self:setDeviceInfo({ signal=wifiLevel,electric = batteryLevel })
	end
	
end

--停止时间计时器
function SHGameScene:stopDeviceSchedule()
	sslog(self.logTag,"停止设备计时器")
	if self._timescheduler then
		sslog(self.logTag,"停止时间计时器")
        scheduler:unscheduleScriptEntry(self._timescheduler)
        self._timescheduler = nil
    end
	if self._wifischeduler then
		sslog(self.logTag,"停止wifi计时器")
		scheduler:unscheduleScriptEntry(self._wifischeduler)
		self._wifischeduler = nil
	end
end
function SHGameScene:onExit()
	sslog(self.logTag,"二人梭哈onExit")
	
	self:stopDeviceSchedule()
end

function SHGameScene:onEnterTransitionFinish()
	sslog(self.logTag,"二人梭哈onEnterTransitionFinish")
end

function SHGameScene:onExitTransitionStart()
	sslog(self.logTag,"二人麻将onExitTransitionStart")
end


--玩家操作完成后的回调
--@param pType 玩家类型
--@param operationType 操作类型
function SHGameScene:playerOperationHandler(pType,operationType)
	sslog(self.logTag,"玩家类型:"..pType..",操作类型:"..operationType)
	self.operationComlete = true --动作执行完成
	--删除第一个，已经完成了
	local cardOperations = self.SHGameDataManager.cardOperations
	
	if table.nums(cardOperations) >0 then
		table.remove(cardOperations,1)
	end
	--ssdump(cardOperations,"还剩那些操作需要执行",10)
	self:loopMsgOperation()--继续查看队列需要操作的消息
end
--循环执行玩家操作消息
function SHGameScene:loopMsgOperation()
	if not self.operationComlete then
		sslog(self.logTag,"等待上一个操作完成")
		return
	end
	local selfCharId = self.SHGameDataManager.selfChairId
	local cardOperations = self.SHGameDataManager.cardOperations
	local decisionTime = self.SHGameDataManager.chooseTime
	if not cardOperations or not next(cardOperations) then
		sslog(self.logTag,"没有需要的操作")
		return
	end
	if not self.seats then
		sslog(self.logTag,"座位上没有人")
		return
	end
	
	self.operationComlete = false --正在处理这个消息
	--这里所有的消息都通过服务器来，包括自己的操作反馈
	--删除倒计时动画
	self:removePlayerProgress()
	
	local chairId = cardOperations[1].chairId
	--ssdump(cardOperations,"所有需要的操作",10)
	--ssdump(cardOperations[1],"当前操作",10)
	local function closeSelfOperationNodes()
		if self.seats and self.seats[selfCharId] then
			local SHMyPlayer = self.seats[selfCharId]
			SHMyPlayer:hideOperationNodes()
			
		end
	end
	if cType and cType ~= SHConfig.CardOperation.ShowDecision then
		closeSelfOperationNodes()
	end
	sslog(self.logTag,"当前操作的座位号"..tostring(chairId))
	local cType = cardOperations[1].type
	local card = cardOperations[1].card --CustomHelper.copyTab(cardOperations[1].card)
	if chairId then --单个座位的操作
		local SHPlayer = self.seats[chairId]
		if not SHPlayer then
			sslog(self.logTag,"什么鬼")
			self:playerOperationHandler("错误的位置","错误的操作")
		end
		SHPlayer:doOperation(cType,card)
	else --结算消息
		if cType == SHConfig.CardOperation.GameOver then
			self:playerOperationHandler("所有玩家","结算")
			self:gameOver()
		end
		
	end


	
	if card and cType and cType == SHConfig.CardOperation.Raise
	or cType == SHConfig.CardOperation.ShowHand then
		--self:setTableInfo({ totalbet = tonumber(card),isAdd = true } )
	end
	if cType and cType== SHConfig.CardOperation.ShowDecision then
		self:setCountDown(decisionTime)
	elseif cType == SHConfig.CardOperation.GetCard then
		--这里清除所有玩家的上轮加注显示
		if self.seats then
			table.walk(self.seats,function (SHPlayer,seatId)
				SHPlayer:closeLastRoundShow()
			end)
		end
		self:closeCountDown()
	else
		self:closeCountDown()
	end
	
end
function SHGameScene:changeTotalBet(event)
	local bet = event or 0
	sslog(self.logTag,"当前加注"..tostring(bet))
	self:setTableInfo({ totalbet = bet,isAdd = true } )
end

---重新连接成功
function SHGameScene:callbackWhenReloginAndGetPlayerInfoFinished(event)
    -- body
    SHGameScene.super.callbackWhenReloginAndGetPlayerInfoFinished(self,event)
    print("重新连接成功")
	SHHelper.removeAll(self.SHGameDataManager.cardOperations)
	self.SHGameDataManager.cardOperations = {}
	
    local gameingInfoTable = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
    if gameingInfoTable == nil or self.SHGameDataManager.isGameOver == true then
       self:showGameOverTips()
       
	else
		--删除牌型提示
		self:removeChildByName("SHCardTypeLayer")
		--删除结算
		self:removeChildByName("SHResultLayer")
		--删除聊天界面
		self:removeChildByName("SHChatLayer")
		self:removeAllPlayer()
		self.operationComlete = true --动作执行完成
		self:initTable() --桌子初始化
		self:initMenu() --显示菜单
		self:startDeviceSchedule()
		SHGameManager:getInstance():sendReconnectMsg()
    end

end
--初始化桌子
function SHGameScene:initTable()
	if SHHelper.isLuaNodeValid(self.tableNode) then
		self.tableNode:removeFromParent()
	end
	self.tableNode = SHGameLayerCCS:create().root
	self.tableNode:addTo(self)
	
	--把该隐藏的都隐藏掉
	local readyImg = CustomHelper.seekNodeByName(self.tableNode,"Image_ready")
	local panelBet = CustomHelper.seekNodeByName(self.tableNode,"Panel_bet")
	local fnodeMe = CustomHelper.seekNodeByName(self.tableNode,"FileNode_me")
	local fnodeOther = CustomHelper.seekNodeByName(self.tableNode,"FileNode_other")
	local fnodeDevice = CustomHelper.seekNodeByName(self.tableNode,"FileNode_device")
	local fnodeMenu = CustomHelper.seekNodeByName(self.tableNode,"FileNode_menu")
	local fnodeTable = CustomHelper.seekNodeByName(self.tableNode,"FileNode_tableinfo")
	
	local fnodeButtons = CustomHelper.seekNodeByName(self.tableNode,"FileNode_button")
	local fnodeCountDown = CustomHelper.seekNodeByName(self.tableNode,"FileNode_countdown")
	
	
	readyImg:setVisible(true)
	panelBet:removeAllChildren()
	fnodeMe:setVisible(false)
	fnodeOther:setVisible(false)
	fnodeMenu:setVisible(false)
	fnodeTable:setVisible(false)
	fnodeButtons:setVisible(false)
	fnodeCountDown:setVisible(false)
end
--生成一个玩家
--@param playerInfo 玩家数据
--@key path 文件路径
--@key seatid 座位ID
--@key fnode 头像的节点 从gamelayer中去获取
function SHGameScene:addOnePlayer(playerInfo)
	if not playerInfo then
		return
	end
	local playerPath = playerInfo.path --文件的路径
	local seatId = playerInfo.seatid --玩家座位ID
	local SHPlayer = requireForGameLuaFile(playerPath)
	--remove first if exists
	self:deletePlayer(seatId)
	local player = SHPlayer:create(playerInfo)
	
	player:setOperationCallBack(handler(self,self.playerOperationHandler))
	player:initHead(playerInfo.fnode)
	player:setMaxLeftTime(playerInfo.chooseTime)
	player:setLeftTime(playerInfo.leftTime)
	player:setGoldNode(CustomHelper.seekNodeByName(self.tableNode,"Panel_bet"))
	local gamebet = playerInfo.add_total or 0
	
	--@headInfo 头像信息
	--@key gold  用户金币
	--@key username  用户昵称
	--@key headId  头像ID
	--@key gamebet  当局下注金额
	--@key roundType  当轮操作类型 加注 跟注 梭哈  SHConfig.CardOperation  Fall,Call,Raise,ShowHand,Pass
	--@key roundbet  当轮下注金额
	player:setHeadInfo({
		headId =playerInfo.headId,gold = playerInfo.money,
		username=playerInfo.nickname,gamebet = gamebet/100,
		})
	if gamebet>0 then
		player:playBetAnim(gamebet,true)
	end
	
	self.seats = self.seats or {}
	self.seats[seatId] = player
	self:addChild(player,SHConfig.LayerOrder.GAME_PLAYER)
	
end
--定时刷新时间
function SHGameScene:_intervalTime(dt)
	local date=os.date("%H:%M")
	if self.setDeviceInfo then
		self:setDeviceInfo({time = date})
	end
	
end
--设置桌子信息
--@param tinfo 桌子信息
--@key basebet 底注
--@key maxbet 限注
--@key totalbet 底池
--@key name 桌子名字
--@key isAdd 底池是否显示添加的
function SHGameScene:setTableInfo(tinfo)
	local fnodeTable = CustomHelper.seekNodeByName(self.tableNode,"FileNode_tableinfo")
	if not tinfo or not SHHelper.isLuaNodeValid(fnodeTable) then
		return 
	end
	fnodeTable:setVisible(true)
	local nameText = CustomHelper.seekNodeByName(fnodeTable,"Text_title") --名字
	local baseText = CustomHelper.seekNodeByName(fnodeTable,"Text_base") --底注
	local limitText = CustomHelper.seekNodeByName(fnodeTable,"Text_limit") --限注
	local totalText = CustomHelper.seekNodeByName(fnodeTable,"Text_total") --底池
	
	if tinfo.name then
		nameText:setString(tostring(tinfo.name))
	end
	if tinfo.basebet then
		baseText:setString(tostring(tinfo.basebet/100))
	end
	if tinfo.maxbet and tinfo.basebet then
		limitText:setString(tostring(tinfo.maxbet*tinfo.basebet/100))
	end
	if tinfo.totalbet then
		local oldTotal = totalText:getString()
		sslog(self.logTag,"以前的加注额度："..oldTotal)
		
		local newTotal = tinfo.totalbet
		if tinfo.isAdd then
			newTotal = newTotal +tonumber(oldTotal)
		end
		sslog(self.logTag,"现在的加注额度："..tostring(newTotal))
		totalText:setString(tostring(newTotal))
	end
end

--设置设备信息
--@param deviceInfo 设备信息的数据集
--@key signal 信号强度  0 没网 1 信号差 2 信号一般 3 信号很好
--@key time 格式化时间
--@key electric 电量 0-100 表示当前电量 <0 表示正在充电中
function SHGameScene:setDeviceInfo(deviceInfo)
	--fnodeDevice
	local fnodeDevice = CustomHelper.seekNodeByName(self.tableNode,"FileNode_device")
	if not deviceInfo or not SHHelper.isLuaNodeValid(fnodeDevice) then
		return 
	end
	local signalImg = CustomHelper.seekNodeByName(fnodeDevice,"Image_signal") --信号强度
	local electricBar = CustomHelper.seekNodeByName(fnodeDevice,"LoadingBar_1") --电池电量
	local timeImg = CustomHelper.seekNodeByName(fnodeDevice,"Text_time") --当前时间
	if deviceInfo.signal~=nil then --信号
		signalImg:ignoreContentAdaptWithSize(false)
		local sign = {
			[0] = "game_res/mainView/ddz_wifi_1.png", --没网
			[1] = "game_res/mainView/ddz_wifi_4.png", --信号差
			[2] = "game_res/mainView/ddz_wifi_3.png", -- 一般
			[3] = "game_res/mainView/ddz_wifi_2.png",-- 信号很好
		}
		local signPath = sign[deviceInfo.signal] or sign[1]
		signalImg:loadTexture(signPath,ccui.TextureResType.localType)
	end
	
	if deviceInfo.time then
		timeImg:setString(tostring(deviceInfo.time))
	end
	if deviceInfo.electric~=nil then --电量
		if deviceInfo.electric<0 then --小于0表示充电中
			electricBar:loadTexture("game_res/mainView/ddz_dl_sd.png",ccui.TextureResType.localType)
			electricBar:setPercent(100)
		elseif deviceInfo.electric>=0 and deviceInfo.electric <20 then
			electricBar:loadTexture("game_res/mainView/ddz_dl_bz.png",ccui.TextureResType.localType)
			electricBar:setPercent(tonumber(deviceInfo.electric))
		elseif deviceInfo.electric>=20 then
			electricBar:loadTexture("game_res/mainView/ddz_dl_zc.png",ccui.TextureResType.localType)
			electricBar:setPercent(tonumber(deviceInfo.electric))
		end
		
	end
end
--关闭倒计时
function SHGameScene:closeCountDown()
	local fnodeCountDown = CustomHelper.seekNodeByName(self.tableNode,"FileNode_countdown")
	if SHHelper.isLuaNodeValid(fnodeCountDown) then
		fnodeCountDown:setVisible(false)
		local timeLabel = CustomHelper.seekNodeByName(fnodeCountDown,"AtlasLabel_time")
		timeLabel:stopAllActions()
		timeLabel:setString(tostring(0))
	end
	if SHHelper.isLuaNodeValid(self.progressTimer) then
		self.progressTimer:setPercentage(100) --满值 100%
	end 
end

function SHGameScene:setCountDown(limitTime)
	--FileNode_countdown
	sslog(self.logTag,"界面倒计时开始:"..tostring(limitTime))
	local fnodeCountDown = CustomHelper.seekNodeByName(self.tableNode,"FileNode_countdown")
	
	local timeLabel = CustomHelper.seekNodeByName(fnodeCountDown,"AtlasLabel_time")
	timeLabel:setString(tostring(limitTime))
	fnodeCountDown:setVisible(true)
	if not SHHelper.isLuaNodeValid(self.progressTimer) then

		local spBar = CustomHelper.seekNodeByName(fnodeCountDown,"Sprite_bar")
		local proParent = spBar:getParent()
		local x,y = spBar:getPosition()
		
		spBar:setVisible(false)
		
		self.progressTimer = cc.ProgressTimer:create(display.newSprite("game_res/mainView/sh_djs_2.png"))
		self.progressTimer:addTo(proParent)
		self.progressTimer:move(x,y)
		self.progressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
		self.progressTimer:setReverseProgress(true)
	else
		self.progressTimer:stopAllActions()
	end
	
    self.progressTimer:setPercentage(100) --满值 100%
	
	local actionProgress = cc.ProgressFromTo:create(limitTime,100,0)
	self.progressTimer:runAction(actionProgress)
	local curTime = limitTime
	local function timeLabelFun()
		curTime = curTime - 1
		if curTime>=0 then
			timeLabel:setString(tostring(curTime))
		else
			timeLabel:stopAllActions()
			fnodeCountDown:setVisible(false)
		end
	end
	
	local seqAction = transition.sequence({
	cc.DelayTime:create(1.0),
	cc.CallFunc:create(timeLabelFun) })
	timeLabel:runAction(cc.RepeatForever:create(seqAction))
end
--初始化菜单按钮
function SHGameScene:initMenu()
	--FileNode_menu
	local fnodeMenu = CustomHelper.seekNodeByName(self.tableNode,"FileNode_menu")
	fnodeMenu:setVisible(true)
	self:showMusicAndSoundInfoView()
	CustomHelper.seekNodeByName(fnodeMenu,"Button_open"):addTouchEventListener(handler(self,self.menuListener))
	CustomHelper.seekNodeByName(fnodeMenu,"Button_close"):addTouchEventListener(handler(self,self.menuListener))
	CustomHelper.seekNodeByName(fnodeMenu,"Button_quit"):addTouchEventListener(handler(self,self.menuListener))
	CustomHelper.seekNodeByName(fnodeMenu,"Button_sound"):addTouchEventListener(handler(self,self.menuListener))
	CustomHelper.seekNodeByName(fnodeMenu,"Button_music"):addTouchEventListener(handler(self,self.menuListener))
	CustomHelper.seekNodeByName(fnodeMenu,"Button_ctype"):addTouchEventListener(handler(self,self.menuListener))
	--fnodeMenu.animation:play("animation0",true)
end

function SHGameScene:menuListener(ref,eventType)
	if not ref then
		return
	end
	if eventType==ccui.TouchEventType.began then
		SHConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		local fnodeMenu = CustomHelper.seekNodeByName(self.tableNode,"FileNode_menu")
		if ref:getName()=="Button_open" then
			fnodeMenu.animation:play("animation0",false)
		elseif ref:getName() == "Button_close" then
			fnodeMenu.animation:play("animation1",false)
		elseif ref:getName() == "Button_quit" then --退出游戏
			--isInGame
			local SHGameDataManager = SHGameManager:getInstance():getDataManager()
			if SHGameDataManager.isInGame then --在游戏中才弹出提示
		
				CustomHelper.showAlertView(
					SHi18nUtils:getInstance():get('str_gameing','exitAlert2'),
					true,
					true,
				function(tipLayer)
					tipLayer:removeSelf()
				end,
				handler(self,self.exitGame))
			else
				self:exitGame()
			end

		elseif ref:getName() == "Button_sound" then --音效
			local isOpenForSound = not GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
			GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch(isOpenForSound)
			if isOpenForSound == true then
				--todo
				GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
			else
				GameManager:getInstance():getMusicAndSoundManager():stopAllSound()
			end
			self:showMusicAndSoundInfoView()
		elseif ref:getName() == "Button_music" then --音乐
			local musicSwitch = not GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
			GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch(musicSwitch)
			if musicSwitch == true then
				--todo
				SHConfig.playBgMusic()
			else
				GameManager:getInstance():getMusicAndSoundManager():stopMusic()
			end
			self:showMusicAndSoundInfoView()
		elseif ref:getName() == "Button_ctype" then --牌型
			--自己手上的牌要传递进入
			local SHGameDataManager = SHGameManager:getInstance():getDataManager()
			local selfChairId = SHGameDataManager.selfChairId
			local playerdatas = SHGameDataManager.playerdatas
			local handCards = nil
			if playerdatas and selfChairId then
				handcards = playerdatas[selfChairId].handCards
			end
			SHCardTypeLayer:create(handcards):addTo(self,SHConfig.LayerOrder.GAME_CARDTIP_LAYER)
		end
	end
end
function SHGameScene:showMusicAndSoundInfoView()
	local fnodeMenu = CustomHelper.seekNodeByName(self.tableNode,"FileNode_menu")
	local musicNode = CustomHelper.seekNodeByName(fnodeMenu,"Button_music")
	local soundNode = CustomHelper.seekNodeByName(fnodeMenu,"Button_sound")
	
	if SHHelper.isLuaNodeValid(musicNode) then
		local musicSwitch = GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
		local normalPath = (musicSwitch and "game_res/mainView/sh_button_yyk.png" or "game_res/mainView/sh_button_yyg.png" )
		local pressedPath = (musicSwitch and "game_res/mainView/sh_button_yyk_pressed.png" or "game_res/mainView/sh_button_yyg_pressed.png")
		
		musicNode:loadTextureNormal(normalPath ,0)
		musicNode:loadTexturePressed(pressedPath ,0)
	end
	if SHHelper.isLuaNodeValid(soundNode) then
		local isOpenForSound = GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
		local normalPath = (isOpenForSound and "game_res/mainView/sh_button_yxk.png" or "game_res/mainView/sh_button_yxg.png")
		local pressedPath = (isOpenForSound and "game_res/mainView/sh_button_yxk_pressed.png" or "game_res/mainView/sh_button_yxg_pressed.png")
		
		soundNode:loadTextureNormal(normalPath ,0)
		soundNode:loadTexturePressed(pressedPath ,0)
	end
end
function SHGameScene:onHallMsgSC_StandUpAndExitRoom(msgTab)
	sslog(self.logTag,"二人梭哈 站起离开了")
	
end

function SHGameScene:onHallMsgSC_EnterRoomAndSitDown(msgTab)
	sslog(self.logTag,"二人梭哈 进入并且坐下了")
	
end
--	enum MsgID { ID = 11013; }
--	optional int32 table_id = 1;
--	optional PlayerVisualInfo pb_visual_info = 2;	// 坐下玩家
--	optional bool is_onfline = 4;					// 是重新上线
function SHGameScene:onHallMsgSC_NotifySitDown(msgTab)
	sslog(self.logTag,"二人梭哈 通知坐下")

	
end
--	optional int32 table_id = 1;
--	optional int32 chair_id = 2;
--	optional int32 guid = 3;
--	optional bool is_offline = 4;					// 是掉线
function SHGameScene:onHallMsgSC_NotifyStandUp(msgTab)
	sslog(self.logTag,"二人梭哈 通知站起")

end
function SHGameScene:onHallMsgSC_Ready(msgTab)
	sslog(self.logTag,"二人梭哈 准备OK")
	--ssdump(msgTab,self.logTag)
end
function SHGameScene:onHallMsgSC_NotifyMoney()
	sslog(self.logTag,"我的玩家金币变动")
	local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
	local SHGameDataManager = SHGameManager:getInstance():getDataManager()
	local selfCharId = SHGameDataManager.selfChairId --我自己的座位号
	if self.seats and selfCharId then
		local SHMyPlayer = self.seats[selfCharId]
		if SHMyPlayer then
			
			SHMyPlayer:setHeadInfo({gold = myPlayerInfo:getMoney() })
		end
	end
end

--进入游戏开局消息
function SHGameScene:onMsgSC_ShowHand_Desk_Enter()
	local SHGameDataManager = SHGameManager:getInstance():getDataManager()
	if not SHGameDataManager.valideStart then --判断是否非法开局
		--非法开局，直接发送准备消息
		self:showGameOverTips()
		return
	end
	--开局后 播放音乐
	SHConfig.playBgMusic()
	--把该隐藏的都隐藏掉
	local readyImg = CustomHelper.seekNodeByName(self.tableNode,"Image_ready")
	readyImg:setVisible(false) --匹配隐藏
	self:removeAllPlayer()

	
	local playerdatas = SHGameDataManager.playerdatas

	local selfCharId = SHGameDataManager.selfChairId --我自己的座位号
	local zhuangId = SHGameDataManager.zhuangId --庄家的ID
	local isReconnect = SHGameDataManager.isReconnect --是否重连
	local chooseTime = SHGameDataManager.chooseTime --选择时间
	local reconnData = SHGameDataManager.reconnData --重连数据
	local baseScore = SHGameDataManager.baseScore --底注
	local maxCall = SHGameDataManager.maxCall --限注 倍数
	local totalbet = 0
	--@headInfo 头像信息
	--@key gold  用户金币
	--@key username  用户昵称
	--@key headId  头像ID
	--@key gamebet  当局下注金额
	--@key roundType  当轮操作类型 加注 跟注 梭哈  SHConfig.CardOperation  Fall,Call,Raise,ShowHand,Pass
	--@key roundbet  当轮下注金额
	for charId,pdata in pairs(playerdatas) do
		local playerInfo = {}
		totalbet = totalbet + (pdata.add_total or 0)
		table.merge(playerInfo,pdata)
		playerInfo.seatid = charId
		playerInfo.chooseTime = chooseTime
		playerInfo.leftTime = chooseTime
		if isReconnect and reconnData and reconnData.act_left_time then
			playerInfo.leftTime = reconnData.act_left_time
		end
		
		if charId==selfCharId then
			playerInfo.path = "SHMyPlayer"
			playerInfo.fnode = CustomHelper.seekNodeByName(self.tableNode,"FileNode_me")
			self:addOnePlayer(playerInfo)
		else
		
			playerInfo.path = "SHOtherPlayer"
			playerInfo.fnode = CustomHelper.seekNodeByName(self.tableNode,"FileNode_other")
			self:addOnePlayer(playerInfo)
		end
			
	end
	if self.seats and selfCharId then
		local SHMyPlayer = self.seats[selfCharId]
		if SHMyPlayer then
			local playerInfo = playerdatas[selfCharId]
			SHMyPlayer:initOperationNode(CustomHelper.seekNodeByName(self.tableNode,"FileNode_button"))
			SHMyPlayer:setBaseBet(baseScore/100)
			SHMyPlayer:setBetLimit(maxCall)
			local roundbet = playerInfo.cur_round_add or 0
			roundbet = roundbet /100
			SHMyPlayer:setRoundBet(roundbet)
			
		end
	end
	local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
	--设置桌子信息
	--@param tinfo 桌子信息
	--@key basebet 底注
	--@key maxbet 限注
	--@key totalbet 底池
	--@key name 桌子名字
	local tinfo = {
		basebet = baseScore,
		maxbet = maxCall,
		totalbet = totalbet/100,
		name = roomInfo[HallGameConfig.SecondRoomNameKey]
	}
	self:setTableInfo(tinfo,false)
	--间隔时间执行第一张的发牌动画
	--如果是恢复对局，直接执行
	if isReconnect then
		self:loopMsgOperation()
	else --正常开局，间隔时间
		self:runAction(transition.sequence{
			cc.DelayTime:create(0.8),
			cc.CallFunc:create(handler(self,self.loopMsgOperation))
		})
	end
	
end
--桌子状态
function SHGameScene:onMsgSC_ShowHand_Desk_State()

end
--结算消息
function SHGameScene:onMsgSC_ShowHand_Game_Finish()
	sslog(self.logTag,"UI结算消息")
	self:loopMsgOperation()
end
--翻牌  下一回合 发牌消息
function SHGameScene:onMsgSC_ShowHand_Next_Round()
	sslog(self.logTag,"UI摸牌消息")
	self:loopMsgOperation()
end
--加注=倍数*底注，allin = -1，跟注 = 0
function SHGameScene:onMsgSC_ShowHandAddScore()
	sslog(self.logTag,"UI加注，跟注，梭哈消息")
	self:loopMsgOperation()
end
--弃牌
function SHGameScene:onMsgSC_ShowHandGiveUp()
	sslog(self.logTag,"UI弃牌消息")
	self:loopMsgOperation()
end
--让牌
function SHGameScene:onMsgSC_ShowHandPass()
	sslog(self.logTag,"UI让牌消息")
	self:loopMsgOperation()
end
--更新发言者
function SHGameScene:onMsgSC_ShowHand_NextTurn()
	sslog(self.logTag,"UI轮到谁发言消息")
	self:loopMsgOperation()
end
--玩家聊天返回
function SHGameScene:onMsgSC_ChatTable(msgTab)
	sslog(self.logTag,"UI玩家聊天返回")
	--根据ID 谁播放动画
	--SHPlayer:showChatAnim(data)
	if self.seats then
		table.walk(self.seats,function (SHPlayer,seatId)
			if msgTab.chat_guid == SHPlayer:getUserID() then
				SHPlayer:showChatAnim(msgTab.chat_content)
			end
		end)
	end

end
function SHGameScene:onMsgSC_ReconnectionPlay(msgTab)
	ssdump(msgTab,"断线重连返回消息")
	if msgTab.find_table==nil or msgTab.find_table==false then --没找到房间
		--游戏已经结束 退出到游戏大厅
       self:showGameOverTips()
	end
	
end
--删除玩家的倒计时动画
function SHGameScene:removePlayerProgress()
	if self.seats then
		table.walk(self.seats,function (SHPlayer,seatId)
			SHPlayer:removeProgress()
		end)
	end
end

--结算循环队列调用
function SHGameScene:gameOver()
	sslog(self.logTag,"UI结算处理")
	--删除聊天界面
	self:removeChildByName("SHChatLayer")
	--删除牌型提示
	self:removeChildByName("SHCardTypeLayer")
	
	local SHGameDataManager = SHGameManager:getInstance():getDataManager()
	
	local gameOverDatas = SHGameDataManager.gameOverDatas
	local selfCharId = SHGameDataManager.selfChairId
	local otherCharId = SHGameDataManager:getNotSelfChairId()
	
	--先比牌
	--gameOverDatas[selfCharId]
	local SHMyPlayer = self.seats[selfCharId]
	local playerData = gameOverDatas[selfCharId]
	if SHMyPlayer then 
		SHMyPlayer:showCardType() --我自己的牌，手里牌已知了
		if playerData.is_win then
			SHMyPlayer:showWinAnim()
		else
			SHMyPlayer:showLoseAnim()
			local betAmount = SHMyPlayer:getBetAmount() or 0
			betAmount = -betAmount
			playerData.win_money = betAmount*100 --单位 分
		end
	end
	local SHOtherPlayer = self.seats[otherCharId]
	playerData = gameOverDatas[otherCharId]
	if SHOtherPlayer then
		SHOtherPlayer:showCardType(playerData.handCards) --对面的牌，传递进入
		if playerData.is_win then
			SHOtherPlayer:showWinAnim()
		else
			SHOtherPlayer:showLoseAnim()
			local betAmount = SHOtherPlayer:getBetAmount() or 0
			betAmount = -betAmount
			playerData.win_money = betAmount*100 --单位 分
		end
	end
	--2s 后弹出结算界面
	self:runAction(transition.sequence{ 
		cc.DelayTime:create(2),
		cc.CallFunc:create(handler(self,self.showResultLayer))
	})
	
end
--显示结算界面
function SHGameScene:showResultLayer()
	local SHGameDataManager = SHGameManager:getInstance():getDataManager()
	local gameOverDatas = SHGameDataManager.gameOverDatas
	local selfCharId = SHGameDataManager.selfChairId
	local otherCharId = SHGameDataManager:getNotSelfChairId()
	--删除牌型提示
	self:removeChildByName("SHCardTypeLayer")
	local resulData = gameOverDatas
	resulData.selfCHairId = selfCharId
	resulData.otherCharId = otherCharId
	SHResultLayer:create(resulData,handler(self,self.exitGame),handler(self,self.nextGame)):addTo(self,SHConfig.LayerOrder.GAME_RESULT_LAYER)
	
end
--删除所有的玩家
function SHGameScene:deletePlayer(seatId)
	if not self.seats or not seatId then
		return
	end
	local SHPlayer = self.seats[seatId]
	if SHHelper.isLuaNodeValid(SHPlayer) then
		SHPlayer:removeFromParent()
		
	end
	self.seats[seatId] = nil
end
--删除所有的玩家
function SHGameScene:removeAllPlayer()
	if not self.seats then
		return
	end
	table.walk(self.seats,function (v,k)
		v:removeFromParent()
	end)
	SHHelper.removeAll(self.seats)
	self.seats = nil
end

function SHGameScene:showGameOverTips()
   CustomHelper.showAlertView(
			SHi18nUtils:getInstance():get('str_gameing','gameover'),
			false,
			true,
			function(tipLayer)
				self:exitGame()
			end,
			function(tipLayer)
				self:exitGame()
			end
	)
end

---退出游戏界面
function SHGameScene:exitGame()
	self:stopDeviceSchedule()
	--退出游戏发送弃牌操作
	--退出游戏的时候 清空游戏数据
	GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(nil)
	SHGameManager:getInstance():sendFallExitMsg()
	SHGameManager:getInstance():sendStandUpAndExitRoomMsg()
    SceneController.goHallScene()
	
    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager()
	if subGameManager then
		subGameManager:onExit()
	else
		sslog(self.logTag,"子游戏管理器已经释放了")
	end
end
--下一局
function SHGameScene:nextGame()
	--退出游戏的时候 清空游戏数据
	GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(nil)
	--重置标识
	
	self.operationComlete = true
	--删除玩家
	self:removeAllPlayer()
	--删除牌型提示
	self:removeChildByName("SHCardTypeLayer")
	--删除结算
	self:removeChildByName("SHResultLayer")
	--删除聊天界面
	self:removeChildByName("SHChatLayer")
	--停止时间计时器
	self:stopDeviceSchedule()
	--重新创建桌子
	self:initTable()
	--显示菜单
	self:initMenu()
	self:startDeviceSchedule()
	SHGameManager:getInstance():sendGameReady()
	
end


return SHGameScene