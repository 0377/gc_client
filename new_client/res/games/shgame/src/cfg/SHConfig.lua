-------------------------------------------------------------------------
-- Desc:    二人梭哈游各种配置
-- Author:  zengzx
-- Date:    2017.5.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHConfig = {}
--界面层级定义
SHConfig.LayerOrder = {
	GAME_LAYER = 1,--游戏层级 (任务)
	GAME_PLAYER = 2, --玩家层级
	GAME_OPERATION_LAYER = 3, --玩家选择操作层级
	GAME_HUTIP_LAYER = 4, --胡牌提示层级
	GAME_TASK_LAYER = 5, --任务界面
	GAME_MENU_LAYER = 5, --设置界面
	GAME_CARDTIP_LAYER = 6, --牌型提示
	GAME_CHAT_LAYER = 6, --聊天快捷提示
	GAME_RESULT_LAYER = 7, --结算界面

	GAME_EFFECT_LAYER = 10, --特效播放层级
}
--UI消息头
SHConfig.UIMsgName = {
	SH_ADD_GAMEBET = "SH_ADD_GAMEBET", --增加游戏底池

}
--pb 消息头
SHConfig.MsgName = {

	CS_ReconnectionPlay = 'CS_ReconnectionPlay', ---断线重连发送消息
	CS_ChatTable = 'CS_ChatTable', ---同桌聊天
		
	CS_ShowHandAddScore = 'CS_ShowHandAddScore', --加注=倍数*底注，allin = -1，跟注 = 0
	CS_ShowHandGiveUp = 'CS_ShowHandGiveUp', --弃牌
	CS_ShowHandPass = 'CS_ShowHandPass', --让牌

	
	SC_ShowHand_Desk_Enter = 'SC_ShowHand_Desk_Enter', --玩家进入
	SC_ShowHand_Desk_State = 'SC_ShowHand_Desk_State', --服务器的游戏状态
	SC_ShowHand_Game_Finish = 'SC_ShowHand_Game_Finish', --玩家
	SC_ShowHand_Next_Round = 'SC_ShowHand_Next_Round', --翻牌  下一回合
	SC_ShowHandAddScore = 'SC_ShowHandAddScore', --加注=倍数*底注，allin = -1，跟注 = 0
	SC_ShowHandGiveUp = 'SC_ShowHandGiveUp', --弃牌
	SC_ShowHandPass = 'SC_ShowHandPass', --让牌
	SC_ShowHand_NextTurn = 'SC_ShowHand_NextTurn', --更新发言者
	
	
	SC_ChatTable = 'SC_ChatTable', --聊天返回
	SC_NotifyMoney = 'SC_NotifyMoney', --玩家金币变动

	
}
-- 牌点数 
SHConfig.CardVal = {
	V_0 = 0, --空的
	V_8 = 8,
	V_9 = 9,
	V_10 = 10,
	V_J = 11,
	V_Q = 12,
	V_K = 13,
	V_A = 14,
}
-- 牌花色 方块 <  草花 < 红桃 <黑桃
SHConfig.CardColor = {
	T_NULL = -1, --
	T_SPADE = 0, --黑桃
	T_HEART = 3, --红桃
	T_CLUB = 2, --梅花 
	T_DIAMOND = 1, --方块
}


--牌的状态
SHConfig.CardState = {
	State_Empty = "State_Empty", --空状态
	State_None = "StateNone", --背面状态
	State_Normal = "StateNormal", --正面显示状态 显示花色和点数
	State_Hand = "StateHand", --底牌 暗灰色状态
}



--玩家类型
SHConfig.PlayerType = {
	Type_self = 1, --自己
	Type_Opposite = 2, --对家
}

--发牌的方向
SHConfig.DealDirection = {
	L_2_R = 1,--从左到右
	R_2_L = 2,--从右到左
}
--玩家动作
SHConfig.CardOperation = {
	GetCard = 8, --得到一张牌
	ShowDecision = 6, --发言
	GameOver = 7, --结算
	Fall = 1, --弃牌
	Call = 2, --跟注
	Raise = 3, --加注
	ShowHand = 4, --梭哈
	Pass = 5, --过牌
}
--UI动画方向 定义方向
SHConfig.Pop_Dir = {
    Up = 0,
    Down = 1,
    Left = 2,
    Right = 3,
}


SHConfig.characterMaxCount = 30 --输入文字最大的输入长度
SHConfig.characterBubbleMaxLen = 30 --气泡动画文字的最大长度

SHConfig.characterDiffTime = 5 --文字动画连续最大间隔时间
SHConfig.characterSer = 3 --文字动画连续最大次数

--动画类型
SHConfig.animatorType = {
	Facial = 1, --表情
	Character = 2, --文字
}
--动画播放状态
SHConfig.animatorState = {
	Init = 1, --初始化状态
	Playing = 2, --播放状态
	Stoped = 3, --停止状态
}

--把服务器的牌值转换成本地的牌值
--服务器牌值规则
--@param serVal 服务器牌值 25 - 52 转换成本地从8-A 一共七张牌 四种花色
function SHConfig.convertToLocalCardVal(serVal)
	if not serVal then
		return 0
	end
	return math.ceil(serVal / 4) + 1
end
--把服务器的牌值转换成本地的牌花色
--服务器牌值规则
--@param serVal 服务器牌值 25 - 52 转换成本地从8-A 一共七张牌 四种花色
function SHConfig.convertToLocalCardColor(serVal)
	return serVal % 4
end
--把服务器的牌值转换成本地的牌数据
--服务器牌值规则
--@param serVal 服务器牌值 25 - 52 转换成本地从8-A 一共七张牌 四种花色
function SHConfig.convertToLocalCard(serVal)
	local val = SHConfig.convertToLocalCardVal(serVal)
	local col = SHConfig.convertToLocalCardColor(serVal)
	return  {val = val,col = col } --牌的结构按照val  牌值 8-A ；col 花色 黑桃0 红桃3 梅花2 方块1
end
--把本地的牌转换成服务器的牌值
--@param localTable 本地的牌数据
--@key val 牌值
--@key col 花色
function SHConfig.convertToServerCard(localTable)
	if not localTable or not localTable.val or not localTable.col then
		sslog("SHConfig.lua","本地牌转换至服务器牌异常")
		ssdump(localTable,"本地牌转换至服务器牌异常")
		return 0 --牌异常
	end
	return (localTable.col >0 and localTable.col or 4) + (localTable.val -2)*4
end
--拆分金币 1分、10分、100分
function SHConfig.splitGold(gold)
	gold = gold or 0
	local ret = {}
	local bai = math.floor(gold/100)
	local shi = math.floor((gold - bai*100)/10)
	local ge = gold - bai*100 - shi*10
	ret[1] = {count = ge,path = "game_res/mainView/sh_cm_1.png"}
	ret[10] = {count = shi,path = "game_res/mainView/sh_cm_2.png"}
	ret[100] = {count = bai,path = "game_res/mainView/sh_cm_3.png"}
	return ret
end

--播放骨骼动画
--@param aniFile 动作名字
--@param aniName 动画名字
--@param parentNode 父节点
--@param animPos 位置
--@param isLoop 是否循环
--@param autoRemove 播放完成是否删除
--@param movementFun 动画播放完成回调
function SHConfig.playAmature(aniFile,aniName,parentNode,animPos,isLoop,autoRemove,movementFun)
	local anim = ccs.Armature:create(aniFile)
	anim:getAnimation():setMovementEventCallFunc(function(sender, type, id)
		if type == ccs.MovementEventType.complete or type == ccs.MovementEventType.loopComplete and id == aniName then
			if not isLoop then
				if autoRemove then
					sender:removeSelf()
				end
				if movementFun then
					movementFun()
				end
			end
		end
	end)
	anim:getAnimation():play(aniName)
	anim:setPosition(animPos)
	--pos(display.cx, display.cy)
	parentNode = parentNode or display.getRunningScene()
	parentNode:addChild(anim,SHConfig.LayerOrder.GAME_EFFECT_LAYER)
end
--按钮
function SHConfig.playButtonSound()
	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
end

return SHConfig