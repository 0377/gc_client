-------------------------------------------------------------------------
-- Desc:    二人麻将玩法界面
-- Author:  zengzx
-- Date:    2017.4.21
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjGameLayer = class("TmjGameLayer",cc.Layer)

local TmjCard = requireForGameLuaFile("TmjCard")
local TmjConfig = import("..cfg.TmjConfig")
local TmjHelper = import("..cfg.TmjHelper")

local TmjFanXinInfoLayer = requireForGameLuaFile("TmjFanXinInfoLayer")
local TmjSettleWinLoseLayer = requireForGameLuaFile("TmjSettleWinLoseLayer")
local TmjSettleDrawnLayer = requireForGameLuaFile("TmjSettleDrawnLayer")

local TmjPlayLayerCCS = requireForGameLuaFile("TmjPlayLayerCCS")
local TmjTaskNodeCCS = requireForGameLuaFile("TmjTaskNodeCCS")
local TmjMenuNodeCCS = requireForGameLuaFile("TmjMenuNodeCCS")
local FileUtils = cc.FileUtils:getInstance()
local scheduler = cc.Director:getInstance():getScheduler()
function TmjGameLayer:ctor(parent)
	self.logTag = self.__cname..".lua"
	self.parent = parent
	self.exitFun = nil
	self:enableNodeEvents()
	self:initView()
	self:initTask()
	self:initMenu()
end
function TmjGameLayer:setExitCallBack(exitFun)
	self.exitFun = exitFun
end
function TmjGameLayer:initView()
	local node = TmjPlayLayerCCS:create()
	self:addChild(node.root)
	self.node = node.root
	--Panel_center
	self.centerPanel = CustomHelper.seekNodeByName(self.node,"Panel_center")

end
--初始化任务界面
function TmjGameLayer:initTask()
	self.taskNode = CustomHelper.seekNodeByName(self,"FileNode_task")
	self.taskNodePos = cc.p(self.taskNode:getPositionX(),self.taskNode:getPositionY())
	local imgBg = CustomHelper.seekNodeByName(self.taskNode,"Image_bg")
	self.taskNode:removeFromParent()
	self.taskNode:addTo(self.parent,TmjConfig.LayerOrder.GAME_TASK_LAYER)
	self.taskSize = imgBg:getContentSize()
	self.taskTargetPosition = {
		self.taskNodePos,
		cc.pAdd(self.taskNodePos,cc.p(self.taskSize.width - 90,0))
	}
	self.taskPosIndex = 1 --当前位置索引
	CustomHelper.seekNodeByName(self.taskNode,"Image_bg"):addTouchEventListener(handler(self,self.taskTouchListener))
	
	CustomHelper.seekNodeByName(self.taskNode,"Image_complete"):setVisible(false) --先隐藏完成图标
	local tempCard = CustomHelper.seekNodeByName(self.taskNode,"FileNode_card")
	local card = TmjCard:create({val = TmjConfig.Card.R_1,position = cc.p(tempCard:getPositionX(),tempCard:getPositionY()) })
	card:addTo(tempCard:getParent())
	card:setName("card")
	card:setScale(tempCard:getScale())
	card:changeState(TmjConfig.CardState.State_None)
	local cardPos = cc.p(tempCard:getPositionX(),tempCard:getPositionY())
	card:setCardPosition(cardPos,true)
				
	tempCard:removeFromParent()
end

--初始化菜单
function TmjGameLayer:initMenu()
	local menuNode = TmjMenuNodeCCS:create().root
	menuNode:move(display.width,display.height)
	menuNode:addTo(self.parent,TmjConfig.LayerOrder.GAME_MENU_LAYER)
	local btnClose = CustomHelper.seekNodeByName(menuNode,"Button_close")
	local btnOpen = CustomHelper.seekNodeByName(menuNode,"Button_open")
	
	CustomHelper.seekNodeByName(menuNode,"Button_back"):addTouchEventListener(handler(self,self.onBtnListener))
	CustomHelper.seekNodeByName(menuNode,"Button_music"):addTouchEventListener(handler(self,self.onBtnListener))
	CustomHelper.seekNodeByName(menuNode,"Button_sound"):addTouchEventListener(handler(self,self.onBtnListener))
	CustomHelper.seekNodeByName(menuNode,"Button_fanxing"):addTouchEventListener(handler(self,self.onBtnListener))
	
	self.musicNode = CustomHelper.seekNodeByName(menuNode,"Button_music")
	self.soundNode = CustomHelper.seekNodeByName(menuNode,"Button_sound")
	
	self:showMusicAndSoundInfoView()
	local function btnListener(ref,eventType)
		if eventType==ccui.TouchEventType.began then
			TmjConfig.playButtonSound()
		elseif eventType == ccui.TouchEventType.ended then
			if ref:getName()=="Button_close" then
				btnClose:setVisible(false)
				btnOpen:setVisible(true)
			elseif ref:getName()=="Button_open" then
				btnClose:setVisible(true)
				btnOpen:setVisible(false)
			end
		end
	end
	
	btnClose:addTouchEventListener(btnListener)
	btnOpen:addTouchEventListener(btnListener)
	
end

function TmjGameLayer:onBtnListener(ref,eventType)
	if eventType==ccui.TouchEventType.began then
		TmjConfig.playButtonSound()
	elseif eventType==ccui.TouchEventType.ended then
		if ref:getName()=="Button_back" then
			local TmjGameDataManager = TmjGameManager:getInstance():getDataManager()
			if not TmjGameDataManager.isGameOver then --在游戏中才弹出提示
				CustomHelper.showAlertView(
					Tmji18nUtils:getInstance():get('str_mjplay','exitAlert'),
					true,
					true,
				function(tipLayer)
					tipLayer:removeSelf()
				end,
				function ()
					if self.exitFun then
						self.exitFun()
					end
				end)
			else
				if self.exitFun then
					self.exitFun()
				end
			end
		elseif ref:getName()=="Button_sound" then
			local isOpenForSound = not GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
			GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch(isOpenForSound)
			if isOpenForSound == true then
				--todo
				GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
			else
				GameManager:getInstance():getMusicAndSoundManager():stopAllSound()
			end
			self:showMusicAndSoundInfoView()
		elseif ref:getName()=="Button_music" then
			local musicSwitch = not GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
			GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch(musicSwitch)
			if musicSwitch == true then
				--todo
				TmjConfig.playBgMusic()
			else
				GameManager:getInstance():getMusicAndSoundManager():stopMusic()
			end
			self:showMusicAndSoundInfoView()
		elseif ref:getName()=="Button_fanxing" then
			sslog(self.logTag,"打开番型界面")
			local TmjGameScene = self.parent
			TmjFanXinInfoLayer:create():addTo(TmjGameScene,TmjConfig.LayerOrder.GAME_FAN_LAYER)
			local resultData = {
				handCards = {
					{val = 1,position = display.center },
					{val = 1,position = display.center },
					{val = 1,position = display.center },
					
					{val = 2,position = display.center },
					{val = 2,position = display.center },
					{val = 2,position = display.center },
					
					{val = 3,position = display.center },
					{val = 3,position = display.center },
					{val = 3,position = display.center },
					
					
				},
				extraCards = {
					--{type =  TmjConfig.cardOperation.Peng,value = {createTag = true, val = 1 }},
					--{type =  TmjConfig.cardOperation.Gang,value = {createTag = true, val = 2 }}
				},
				me = {
					handCards = {
					{val = 1,position = display.center },
					{val = 1,position = display.center },
					{val = 1,position = display.center },
					
					{val = 2,position = display.center },
					{val = 2,position = display.center },
					{val = 2,position = display.center },
					
					{val = 3,position = display.center },
					{val = 3,position = display.center },
					{val = 3,position = display.center },
					
					
				},
				extraCards = {
					--{type =  TmjConfig.cardOperation.Peng,value = {createTag = true, val = 1 }},
					--{type =  TmjConfig.cardOperation.Gang,value = {createTag = true, val = 2 }}
				},
				},
				other = {
					handCards = {
					{val = 1,position = display.center },
					{val = 1,position = display.center },
					{val = 1,position = display.center },
					
					{val = 2,position = display.center },
					{val = 2,position = display.center },
					{val = 2,position = display.center },
					
					{val = 3,position = display.center },
					{val = 3,position = display.center },
					{val = 3,position = display.center },
					
					
				},
				extraCards = {
					--{type =  TmjConfig.cardOperation.Peng,value = {createTag = true, val = 2 }},
					--{type =  TmjConfig.cardOperation.Gang,value = {createTag = true, val = 1 }}
				},
				},
				is_hu = false,
				hu_fan = 10,
				win_money = 20,
				jiabei = 2,
				describe = "JIAN_KE,PENG_PENG_HU,HUA_PAI,HUA_PAI,BAO_TING,HU_JUE_ZHANG,ZI_MO,",
				taxes = 10,
				finish_task = true,
				taskInfo = {
					task_type = 2,
					task_tile = 2,
					task_scale = 2,
				}
			}
	
			--TmjSettleWinLoseLayer:create(resultData,exitFun,nextFun):addTo(self.parent,TmjConfig.LayerOrder.GAME_FAN_LAYER)
			--local TmjGameScene = self.parent
			--TmjSettleDrawnLayer:create(resultData,handler(TmjGameScene,TmjGameScene.exitGame),handler(TmjGameScene,TmjGameScene.nextGame)):addTo(self.parent,TmjConfig.LayerOrder.GAME_FAN_LAYER)
		end

	end

end

function TmjGameLayer:showMusicAndSoundInfoView()
	if TmjHelper.isLuaNodeValid(self.musicNode) then
		local musicSwitch = GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
		self.musicNode:loadTextureNormal(musicSwitch and "game_res/desk/yinyue1.png" or "game_res/desk/yinyue2.png" ,0)
	end
	if TmjHelper.isLuaNodeValid(self.soundNode) then
		local isOpenForSound = GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
		self.soundNode:loadTextureNormal(isOpenForSound and "game_res/desk/yinxiao1.png" or "game_res/desk/yinxiao2.png" ,0)
	end
end

--设置任务数据
--@param taskInfo 任务数据
--@key task_type 任务类型
--@key task_tile 那张牌
--@key task_scale 任务倍率
--@key accomplish 任务是否完成
function TmjGameLayer:setTaskData(taskInfo)
	if not taskInfo then
		self.taskNode:setVisible(false)
	end
	self.taskNode:setVisible(true)
	--AtlasLabel_winNumber
	--Image_tag
	--任务类型
	local task = TmjConfig.taskConfig[taskInfo.task_type]
	if task and FileUtils:isFileExist(task.taskRes) then
		CustomHelper.seekNodeByName(self.taskNode,"Image_tag"):loadTexture(task.taskRes)
	else
		sslog(self.logTag,"任务类型错误 "..tostring(taskInfo.task_type))
	end
	--完成后的倍率
	if taskInfo.task_scale then
		local taskrate = string.gsub(tostring(taskInfo.task_scale),"%.","/")
		CustomHelper.seekNodeByName(self.taskNode,"AtlasLabel_winNumber"):setString(taskrate)
	end
	--任务中完成的牌值
	if taskInfo.task_tile then
		CustomHelper.seekNodeByName(self.taskNode,"card"):init({val = taskInfo.task_tile,state = TmjConfig.CardState.State_Discard  })
	end
	--任务是否完成
	if taskInfo.accomplish then
		CustomHelper.seekNodeByName(self.taskNode,"Image_complete"):setVisible(taskInfo.accomplish==true)
	end
end

--隐藏中间信息
function TmjGameLayer:hideCenterPanel()
	if not TmjHelper.isLuaNodeValid(self.centerPanel) then
		return
	end
	self.centerPanel:setVisible(false)
	
--[[	local children = self.centerPanel:getChildren()
	if children then
		table.walk(children,function (node,k)
			node:setVisible(false)
		end)
	end--]]
	
end
--开始倒计时
function TmjGameLayer:startCountDown(curTime)
	self:stopCountDown()
	self.showTime = curTime
	if not self.showTime or self.showTime <=0 then
		return
	end
	self._scheduler = scheduler:scheduleScriptFunc(handler(self,self._onInterval), 1, false)
	self.centerPanel:getChildByName("Text_countdownTime"):setString(tostring(self.showTime).."s")
end
function TmjGameLayer:stopCountDown()
	if self._scheduler then
		scheduler:unscheduleScriptEntry(self._scheduler)
		self._scheduler = nil
	end
end

function TmjGameLayer:_onInterval(dt)
	self.showTime = self.showTime - 1
	if self.showTime<0 then
		self:stopCountDown()
	else
		CustomHelper.seekNodeByName(self.centerPanel,"Text_countdownTime"):setString(tostring(self.showTime).."s")
	end
	if self.showTime>0 and self.showTime <=5 then
		sslog(self.logTag,"播放倒计时音效")
		TmjConfig.playSound(TmjConfig.sType.GAME_LAST_SECOND)
	end
	
end
--设置中间的信息
--@param tableInfo 信息表
--@key bankerSide 哪边的庄家 1 自己 2 对家
--@key cardSide 哪边出牌了 1 自己 2 对家
--@key restTime 剩余的出牌时间
--@key restCardCount 剩余牌数量
--@key tableType 桌子类型 
--@key pour 底注
function TmjGameLayer:setCenterPanelInfo(tableInfo)
	if not TmjHelper.isLuaNodeValid(self.centerPanel) then
		return
	end
	ssdump(tableInfo,"设置中间的显示信息")
	self.centerPanel:setVisible(true)
	if tableInfo.bankerSide then
		sslog(self.logTag,"设置庄家显示"..tostring(tableInfo.bankerSide))
		self.centerPanel:getChildByName("Image_zhuang_up_light"):setVisible(tableInfo.bankerSide==2)
		self.centerPanel:getChildByName("Image_zhuang_down_light"):setVisible(tableInfo.bankerSide==1)
	end
	if tableInfo.cardSide then
		sslog(self.logTag,"设置该谁出牌"..tostring(tableInfo.cardSide))
		self.centerPanel:getChildByName("Image_zhuang_up"):setVisible(tableInfo.cardSide==2)
		self.centerPanel:getChildByName("Image_zhuang_down"):setVisible(tableInfo.cardSide==1)
	end
	if tableInfo.restTime then
		self.centerPanel:getChildByName("Text_countdownTime"):setString(string.format("%dS",tableInfo.restTime))
	end
	if tableInfo.restCardCount then
		sslog(self.logTag,"设置剩余牌数量"..tostring(tableInfo.restCardCount))
		self.centerPanel:getChildByName("Text_restCardCount"):setString("x"..tostring(tableInfo.restCardCount))
	end
	if tableInfo.tableType then
		local path = TmjConfig.tableType[tableInfo.tableType]
		if path and cc.FileUtils:getInstance():isFileExist(path) then
			self.centerPanel:getChildByName("Image_type"):loadTexture(path)
		else
			sslog(self.logTag,"未知的桌子类型 "..tostring(tableInfo.tableType))
		end
	end
	if tableInfo.pour then
		
		local pourStr = string.gsub(CustomHelper.moneyShowStyleNone(tableInfo.pour),"%.","/")
		
		self.centerPanel:getChildByName("AtlasLabel_pour"):setString(pourStr)
	end
	
	--Image_zhuang_up  Image_zhuang_up_light
	--Image_zhuang_down  Image_zhuang_down_light
	
	--Text_countdownTime Text_restCardCount
	
	--Image_type AtlasLabel_pour
	
end
--任务触摸控制
function TmjGameLayer:taskTouchListener(ref,eventType)
	if eventType==ccui.TouchEventType.began then
		TmjConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		self.taskNode:stopAllActions()
		--self.taskNodePos
	
		self.taskPosIndex = self.taskPosIndex + 1
		if self.taskPosIndex > 2 then
			self.taskPosIndex = 1
		end
		self.taskNode:runAction(cc.MoveTo:create(0.1,self.taskTargetPosition[self.taskPosIndex]))
	end

end


function TmjGameLayer:onEnter()
	
end
function TmjGameLayer:onExit()
	self:stopCountDown()
end
return TmjGameLayer