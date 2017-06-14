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
local SHGameNormalScene = class("SHGameNormalScene",requireForGameLuaFile("SHGameBaseScene"))
local SHConfig = import("..cfg.SHConfig")
local SHHelper = import("..cfg.SHHelper")
local DeviceUtils = requireForGameLuaFile("DeviceUtils")

local SHGameLayerCCS = requireForGameLuaFile("SHGameLayerCCS")

local SHCardTypeLayer = requireForGameLuaFile("SHCardTypeLayer")
local SHResultLayer = requireForGameLuaFile("SHResultLayer")
--GameManager:getInstance():getHallManager():getSubGameManager()
local scheduler = cc.Director:getInstance():getScheduler()
function SHGameNormalScene.getNeedPreloadResArray()
	local resNeed = {
		CustomHelper.getFullPath("game_res/animation/sh_pxdh_eff.ExportJson"),
	}
	return resNeed
end
function SHGameNormalScene:ctor()
	SHGameNormalScene.super.ctor(self)
	self:setName("SHGameNormalScene")
	
	self.SHGameDataNormalManager = SHGameManager:getInstance():getDataManager()
	self.operationComlete = true
	self.seats = {} --玩家信息

end


function SHGameNormalScene:onEnter()
	SHGameNormalScene.super.onEnter(self)
	self:initTable()
	self:initMenu() --显示菜单
	self:startDeviceSchedule()
end
--开启设备显示信息计时器
function SHGameNormalScene:startDeviceSchedule()
	SHGameNormalScene.super.startDeviceSchedule(self)
end
--电池和wifi的计时器
function SHGameNormalScene:_intervalWIFI(dt)
	SHGameNormalScene.super._intervalWIFI(self,dt)
end

--停止时间计时器
function SHGameNormalScene:stopDeviceSchedule()
	SHGameNormalScene.super.stopDeviceSchedule(self)
end
function SHGameNormalScene:onExit()
	sslog(self.logTag,"二人梭哈onExit")
	SHGameNormalScene.super.onExit(self)
	self:stopDeviceSchedule()
end

function SHGameNormalScene:onEnterTransitionFinish()
	SHGameNormalScene.super.onEnterTransitionFinish(self)
end

function SHGameNormalScene:onExitTransitionStart()
	SHGameNormalScene.super.onExitTransitionStart(self)
end


---重新连接成功
function SHGameNormalScene:callbackWhenReloginAndGetPlayerInfoFinished(event)
    -- body
    SHGameNormalScene.super.callbackWhenReloginAndGetPlayerInfoFinished(self,event)
    print("重新连接成功")
	SHHelper.removeAll(self.SHGameDataNormalManager.cardOperations)
	self.SHGameDataNormalManager.cardOperations = {}
	
    local gameingInfoTable = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
    if gameingInfoTable == nil or self.SHGameDataNormalManager.isGameOver == true then
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
function SHGameNormalScene:initTable()
	SHGameNormalScene.super.initTable(self)
end
--生成一个玩家
--@param playerInfo 玩家数据
--@key path 文件路径
--@key seatid 座位ID
--@key fnode 头像的节点 从gamelayer中去获取
function SHGameNormalScene:addOnePlayer(playerInfo)
	SHGameNormalScene.super.addOnePlayer(self,playerInfo)
end



function SHGameNormalScene:menuListener(ref,eventType)
	SHGameNormalScene.super.menuListener(self,ref,eventType)
end

function SHGameNormalScene:onHallMsgSC_StandUpAndExitRoom(msgTab)
	SHGameNormalScene.super.onHallMsgSC_StandUpAndExitRoom(self,msgTab)
end

function SHGameNormalScene:onHallMsgSC_EnterRoomAndSitDown(msgTab)
	SHGameNormalScene.super.onHallMsgSC_EnterRoomAndSitDown(self,msgTab)
	
end
--	enum MsgID { ID = 11013; }
--	optional int32 table_id = 1;
--	optional PlayerVisualInfo pb_visual_info = 2;	// 坐下玩家
--	optional bool is_onfline = 4;					// 是重新上线
function SHGameNormalScene:onHallMsgSC_NotifySitDown(msgTab)
	SHGameNormalScene.super.onHallMsgSC_NotifySitDown(self,msgTab)

	
end
--	optional int32 table_id = 1;
--	optional int32 chair_id = 2;
--	optional int32 guid = 3;
--	optional bool is_offline = 4;					// 是掉线
function SHGameNormalScene:onHallMsgSC_NotifyStandUp(msgTab)
	SHGameNormalScene.super.onHallMsgSC_NotifyStandUp(self,msgTab)

end
function SHGameNormalScene:onHallMsgSC_Ready(msgTab)
	SHGameNormalScene.super.onHallMsgSC_Ready(self,msgTab)
	--ssdump(msgTab,self.logTag)
end
function SHGameNormalScene:onHallMsgSC_NotifyMoney()
	SHGameNormalScene.super.onHallMsgSC_NotifyMoney(self)
end

--进入游戏开局消息
function SHGameNormalScene:onMsgSC_ShowHand_Desk_Enter()
	SHGameNormalScene.super.onMsgSC_ShowHand_Desk_Enter(self)
end
--桌子状态
function SHGameNormalScene:onMsgSC_ShowHand_Desk_State()
	SHGameNormalScene.super.onMsgSC_ShowHand_Desk_State(self)
end
--结算消息
function SHGameNormalScene:onMsgSC_ShowHand_Game_Finish()
	SHGameNormalScene.super.onMsgSC_ShowHand_Game_Finish(self)
end
--翻牌  下一回合 发牌消息
function SHGameNormalScene:onMsgSC_ShowHand_Next_Round()
	SHGameNormalScene.super.onMsgSC_ShowHand_Next_Round(self)
end
--加注=倍数*底注，allin = -1，跟注 = 0
function SHGameNormalScene:onMsgSC_ShowHandAddScore()
	SHGameNormalScene.super.onMsgSC_ShowHandAddScore(self)
end
--弃牌
function SHGameNormalScene:onMsgSC_ShowHandGiveUp()
	SHGameNormalScene.super.onMsgSC_ShowHandGiveUp(self)
end
--让牌
function SHGameNormalScene:onMsgSC_ShowHandPass()
	SHGameNormalScene.super.onMsgSC_ShowHandPass(self)
end
--更新发言者
function SHGameNormalScene:onMsgSC_ShowHand_NextTurn()
	SHGameNormalScene.super.onMsgSC_ShowHand_NextTurn(self)
end
--玩家聊天返回
function SHGameNormalScene:onMsgSC_ChatTable(msgTab)
	SHGameNormalScene.super.onMsgSC_ChatTable(self,msgTab)
end


--结算循环队列调用
function SHGameNormalScene:gameOver()
	SHGameNormalScene.super.gameOver(self)
end
--显示结算界面
function SHGameNormalScene:showResultLayer()
	SHGameNormalScene.super.showResultLayer(self)
	local SHGameDataNormalManager = SHGameManager:getInstance():getDataManager()
	local gameOverDatas = SHGameDataNormalManager.gameOverDatas
	local selfCharId = SHGameDataNormalManager.selfChairId
	local otherCharId = SHGameDataNormalManager:getNotSelfChairId()
	--删除牌型提示
	self:removeChildByName("SHCardTypeLayer")
	local resulData = gameOverDatas
	resulData.selfCHairId = selfCharId
	resulData.otherCharId = otherCharId
	SHResultLayer:create(resulData,handler(self,self.exitGame),handler(self,self.nextGame)):addTo(self,SHConfig.LayerOrder.GAME_RESULT_LAYER)
	
end


---退出游戏界面
function SHGameNormalScene:exitGame(openSecondLayer)
	SHGameNormalScene.super.exitGame(self,openSecondLayer)
	--退出游戏发送弃牌操作
	--退出游戏的时候 清空游戏数据
	GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(nil)
	SHGameManager:getInstance():sendFallExitMsg()
	SHGameManager:getInstance():sendStandUpAndExitRoomMsg()
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
function SHGameNormalScene:nextGame()
	SHGameNormalScene.super.nextGame(self)
end


return SHGameNormalScene