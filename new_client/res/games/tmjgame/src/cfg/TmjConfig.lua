-------------------------------------------------------------------------
-- Desc:    二人麻将游各种配置
-- Author:  zengzx
-- Date:    2017.4.10
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjConfig = {}
--界面层级定义
TmjConfig.LayerOrder = {
	GAME_LAYER = 1,--游戏层级 (任务)
	GAME_PLAYER = 2, --玩家层级
	GAME_OPERATION_LAYER = 3, --玩家选择操作层级
	GAME_HUTIP_LAYER = 4, --胡牌提示层级
	GAME_TASK_LAYER = 5, --任务界面
	GAME_MENU_LAYER = 5, --设置界面
	GAME_FAN_LAYER = 6, --番型提示界面
	GAME_RESULT_LAYER = 7, --结算界面
	TmjGameMatchingLayer = 10,--匹配界面层级

	GAME_EFFECT_LAYER = 10, --特效播放层级
}
--pb 消息头
TmjConfig.MsgName = {

	CS_ReconnectionPlay = 'CS_ReconnectionPlay', ---断线重连发送消息
		
	CS_Maajan_Act_Win = 'CS_Maajan_Act_Win', --胡
	CS_Maajan_Act_Double = 'CS_Maajan_Act_Double', --加倍
	CS_Maajan_Act_Discard = 'CS_Maajan_Act_Discard', --打牌
	CS_Maajan_Act_Peng = 'CS_Maajan_Act_Peng', --碰
	CS_Maajan_Act_Gang = 'CS_Maajan_Act_Gang', --杠
	CS_Maajan_Act_Pass = 'CS_Maajan_Act_Pass', --过
	CS_Maajan_Act_Chi = 'CS_Maajan_Act_Chi', --吃
	CS_Maajan_Act_Trustee = 'CS_Maajan_Act_Trustee', --托管
	CS_Maajan_Act_BaoTing = 'CS_Maajan_Act_BaoTing', --报听请求
	
	SC_Maajan_Desk_Enter = 'SC_Maajan_Desk_Enter', --玩家进入
	SC_Maajan_Act_Win = 'SC_Maajan_Act_Win', --胡
	SC_Maajan_Act_Double = 'SC_Maajan_Act_Double', --加倍
	SC_Maajan_Act_Discard = 'SC_Maajan_Act_Discard', --打牌
	SC_Maajan_Act_Peng = 'SC_Maajan_Act_Peng', --碰
	SC_Maajan_Act_Gang = 'SC_Maajan_Act_Gang', --杠
	SC_Maajan_Act_Chi = 'SC_Maajan_Act_Chi', --吃
	SC_Maajan_Tile_Letf = 'SC_Maajan_Tile_Letf', --剩余多少张公牌
	SC_Maajan_Discard_Round = 'SC_Maajan_Discard_Round', --该谁出牌
	SC_Maajan_Desk_State = 'SC_Maajan_Desk_State', --服务器的游戏状态
	SC_Maajan_Draw = 'SC_Maajan_Draw', --摸牌 含补花	
	SC_Maajan_Bu_Hua = 'SC_Maajan_Bu_Hua', --开始阶段补花	
	SC_Maajan_Act_BaoTing = 'SC_Maajan_Act_BaoTing', --报听返回	
	SC_Maajan_Act_Trustee = 'SC_Maajan_Act_Trustee', --托管返回	
	
	SC_Maajan_Game_Finish = 'SC_Maajan_Game_Finish', --结算消息
	SC_ReconnectionPlay = 'SC_ReconnectionPlay', --重连返回
}
--1 - 9万 - 东 - 西 - 南 - 北 - 中 - 发 - 白 - 春 - 夏 - 秋 - 冬 - 梅 - 兰 - 竹 - 菊
TmjConfig.Card = {
	R_0 = 0, -- 背面
	R_1 = 1, -- 1万
	R_2 = 2, -- 2万
	R_3 = 3, -- 3万
	R_4 = 4, -- 4万
	R_5 = 5, -- 5万
	R_6 = 6, -- 6万
	R_7 = 7, -- 7万
	R_8 = 8, -- 8万
	R_9 = 9, -- 9万
	R_E = 10, -- 东
	R_W = 11, -- 西
	R_S = 12, -- 南
	R_N = 13, -- 北
	R_Read = 14, -- 红中
	R_Green = 15, -- 绿发
	R_White = 16, -- 白板
	R_Spring = 17, -- 春
	R_Summer = 18, -- 夏
	R_Autumn = 19, -- 秋
	R_Winter = 20, -- 冬
	R_WinSweet = 21, -- 梅花
	R_Orchid = 22, -- 兰花
	R_Bamboo = 23, -- 竹
	R_Chry = 24, -- 菊花
}

--牌的状态
TmjConfig.CardState = {
	State_Empty = "State_Empty", --空状态
	State_None = "StateNone", --背面状态
	State_Discard = "StateDiscard", --打出去
	State_Down = "StateDown", -- 手上放下
	State_Up = "StateUp", -- 手上拿起
	State_Extra = "StateExtra", -- 旁边的牌（吃，碰，杠）
}

--输入事件 （服务器专用s）
TmjConfig.FSM_event = {
    UPDATE          = 0,	--time update
	TRUSTEE			= 1,	--托管
	CHI				= 2,	--吃
	PENG  			= 3,	--碰  
	GANG  			= 4,	--杠
	HU	  			= 5,	--胡
	PASS  			= 6,	--过
	CHU_PAI			= 7,	--出牌
	JIA_BEI			= 8,	--加倍
}

--玩家类型
TmjConfig.PlayerType = {
	Type_self = 1, --自己
	Type_Opposite = 2, --对家
}
--玩家状态
TmjConfig.PlayerState = {
	
}

--发牌的方向
TmjConfig.DealDirection = {
	L_2_R = 1,--从左到右
	R_2_L = 2,--从右到左
}
--玩家动作
TmjConfig.cardOperation = {
	GetOne = 1, -- 摸牌
	Play = 2, -- 打牌
	Chi = 3, -- 吃
	Peng = 4, -- 碰
	Gang = 5, -- 杠
	AnGang = 6, -- 暗杠
	BuGang = 7, -- 补杠
	Ting = 8, -- 听
	Hu = 9, -- 胡
	BuHua = 10, -- 补花
	
	RoundCard = 21, -- 轮到谁出牌
	Double = 22, -- 加倍
	Finish = 23, -- 结算
}
--游戏的状态
TmjConfig.GameState = {
	PRE_BEGIN = 0,--预开始
	XI_PAI = 1,--洗牌
	BU_HUA_BIG = 2,--补花
	WAIT_MO_PAI = 4,--等待 摸牌
	WAIT_CHU_PAI = 5,--等待 出牌
	WAIT_PENG_GANG_HU_CHI = 6,--等待 碰 杠 胡 用户出牌的时候
	WAIT_BA_GANG_HU = 7,--等待胡，用户补杠的时候，强胡
	
	GAME_BALANCE = 15,--结算
	GAME_CLOSE = 16,--关闭游戏
	GAME_ERR = 17,--发生错误

	GAME_IDLE_HEAD = 0x1000,--用于客户端播放动画延迟
}
--UI动画方向 定义方向
TmjConfig.Pop_Dir = {
    Up = 0,
    Down = 1,
    Left = 2,
    Right = 3,
}

--桌子类型配置
TmjConfig.tableType = {
	[1] = "game_res/desk/laoquechang.png", --小雀场
	[2] = "game_res/desk/chengquechang.png", --成雀场
	[3] = "game_res/desk/queshenchang.png", --雀神场
}
--任务配置
TmjConfig.taskConfig = {
	--吃
	[TmjConfig.FSM_event.CHI]  = { 
		taskRes = "game_res/desk/chi3.png",
	},
	--胡
	[TmjConfig.FSM_event.HU]  = {
		taskRes = "game_res/desk/hu3.png",
	},
	--碰
	[TmjConfig.FSM_event.PENG]  = {
		taskRes = "game_res/desk/peng3.png",
	},
	--杠
	[TmjConfig.FSM_event.GANG]  = {
		taskRes = "game_res/desk/gang3.png",
	},
}
--胡牌的信息配置
TmjConfig.CARD_HU_TYPE_INFO = {
	WEI_HU					= {name = "WEI_HU",fan = 0},				--未胡
------------------------------叠加-------------------------------------------------
	TIAN_HU					= {name = "TIAN_HU",fan = 88,res="game_res/fan/tianhu.png"},				--天胡
	DI_HU					= {name = "DI_HU",fan = 88,res="game_res/fan/dihu.png"},				--地胡
	REN_HU					= {name = "REN_HU",fan = 64,res="game_res/fan/renhu.png"},				--人胡
	TIAN_TING				= {name = "TIAN_TING",fan = 32,res="game_res/fan/tianting.png"},			--天听
	QING_YI_SE				= {name = "QING_YI_SE",fan = 16,res="game_res/fan/qingyise.png"},			--清一色
	QUAN_HUA				= {name = "QUAN_HUA",fan = 16,res="game_res/fan/quanhua.png"},				--全花
	ZI_YI_SE				= {name = "ZI_YI_SE",fan = 64,res="game_res/fan/ziyise.png"},				--字一色
	MIAO_SHOU_HUI_CHUN		= {name = "MIAO_SHOU_HUI_CHUN",fan = 8,res="game_res/fan/miaoshouhuichun.png"},	--妙手回春
	HAI_DI_LAO_YUE			= {name = "HAI_DI_LAO_YUE",fan = 8,res="game_res/fan/haidilaoyue.png"},		--海底捞月
	GANG_SHANG_HUA			= {name = "GANG_SHANG_HUA",fan = 8,res="game_res/fan/gangshangkaihua.png"},		--杠上开花
	QUAN_QIU_REN			= {name = "QUAN_QIU_REN",fan = 8,res="game_res/fan/quanqiuren.png"},			--全求人
	SHUANG_AN_GANG			= {name = "SHUANG_AN_GANG",fan = 6,res="game_res/fan/shuangangang.png"},		--双暗杠
	SHUANG_JIAN_KE			= {name = "SHUANG_JIAN_KE",fan = 6,res="game_res/fan/shuangjianke.png"},		--双箭刻
	HUN_YI_SE				= {name = "HUN_YI_SE",fan = 6,res="game_res/fan/hunyise.png"},				--混一色
	BU_QIU_REN				= {name = "BU_QIU_REN",fan = 4,res="game_res/fan/buqiuren.png"},			--不求人
	SHUANG_MING_GANG		= {name = "SHUANG_MING_GANG",fan = 4,res="game_res/fan/shuangminggang.png"},		--双明杠
	HU_JUE_ZHANG			= {name = "HU_JUE_ZHANG",fan = 4,res="game_res/fan/hujuezhang.png"},			--胡绝张
	JIAN_KE					= {name = "JIAN_KE",fan = 2,res="game_res/fan/jianke.png"},				--箭刻
	MEN_QING				= {name = "MEN_QING",fan = 2,res="game_res/fan/menqianqing.png"},				--门前清
	ZI_AN_GANG				= {name = "ZI_AN_GANG",fan = 2,res="game_res/fan/dihu.png"},			--自暗杠
	DUAN_YAO				= {name = "DUAN_YAO",fan = 2,res="game_res/fan/duanyao.png"},				--断幺
	SI_GUI_YI				= {name = "SI_GUI_YI",fan = 2,res="game_res/fan/siguiyi.png"},				--四归一
	PING_HU					= {name = "PING_HU",fan = 2,res="game_res/fan/pinghu.png"},				--平胡
	SHUANG_AN_KE			= {name = "SHUANG_AN_KE",fan = 2,res="game_res/fan/dihu.png"},			--双暗刻
	SAN_AN_KE				= {name = "SAN_AN_KE",fan = 16,res="game_res/fan/dihu.png"},			--三暗刻
	SI_AN_KE				= {name = "SI_AN_KE",fan = 64,res="game_res/fan/sianke.png"},				--四暗刻
	BAO_TING				= {name = "BAO_TING",fan = 2,res="game_res/fan/baoting.png"},				--报听
	MEN_FENG_KE				= {name = "MEN_FENG_KE",fan = 2,res="game_res/fan/menfengke.png"},			--门风刻
	QUAN_FENG_KE			= {name = "QUAN_FENG_KE",fan = 2,res="game_res/fan/dihu.png"},			--圈风刻
	ZI_MO					= {name = "ZI_MO",fan = 1,res="game_res/fan/zimo.png"},					--自摸
	DAN_DIAO_JIANG			= {name = "DAN_DIAO_JIANG",fan = 1,res="game_res/fan/dandiaojiang.png"},		--单钓将
	YI_BAN_GAO	 			= {name = "YI_BAN_GAO",fan = 1,res="game_res/fan/yibangao.png"},			--一般高
	LAO_SHAO_FU	 			= {name = "LAO_SHAO_FU",fan = 1,res="game_res/fan/laoshaofu.png"},			--老少副
	LIAN_LIU	 			= {name = "LIAN_LIU",fan = 1,res="game_res/fan/lianliu.png"},				--连六
	YAO_JIU_KE	 			= {name = "YAO_JIU_KE",fan = 1,res="game_res/fan/yaojiuke.png"},			--幺九刻
	MING_GANG	 			= {name = "MING_GANG",fan = 1,res="game_res/fan/minggang.png"},				--明杠
	DA_SAN_FENG				= {name = "DA_SAN_FENG",fan = 24,res="game_res/fan/dasanfeng.png"},			--大三风
	XIAO_SAN_FENG			= {name = "XIAO_SAN_FENG",fan = 24,res="game_res/fan/xiaosanfeng.png"},		--小三风
	PENG_PENG_HU			= {name = "PENG_PENG_HU",fan = 6,res="game_res/fan/pengpenghu.png"},			--碰碰胡
	SAN_GANG				= {name = "SAN_GANG",fan = 32,res="game_res/fan/sangang.png"},				--三杠
	QUAN_DAI_YAO			= {name = "QUAN_DAI_YAO",fan = 4,res="game_res/fan/quandaiyao.png"},			--全带幺
	QIANG_GANG_HU			= {name = "QIANG_GANG_HU",fan = 8,res="game_res/fan/qiangganghu.png"},			--抢杠胡
	HUA_PAI					= {name = "HUA_PAI",fan = 1,res="game_res/fan/huapai.png"},				--花牌
-----------------------------------------------------------------------------------
	DA_QI_XIN			= {name = "DA_QI_XIN",fan = 88,res="game_res/fan/daqixing.png"},			--大七星
	LIAN_QI_DUI 		= {name = "LIAN_QI_DUI",fan = 88,res="game_res/fan/lianqidui.png"},			--连七对
	SAN_YUAN_QI_DUI		= {name = "SAN_YUAN_QI_DUI",fan = 48,res="game_res/fan/sanyuanqiduizi.png"},		--三元七对子
	SI_XI_QI_DUI		= {name = "SI_XI_QI_DUI",fan = 48,res="game_res/fan/sixiqiduizi.png"},			--四喜七对子
	NORMAL_QI_DUI 		= {name = "NORMAL_QI_DUI",fan = 24,res="game_res/fan/dihu.png"},		--普通七对
---------------------
	DA_YU_WU 			= {name = "DA_YU_WU",fan = 88,res="game_res/fan/dayuwu.png"},				--大于五
	XIAO_YU_WU 			= {name = "XIAO_YU_WU",fan = 88,res="game_res/fan/xiaoyuwu.png"},			--小于五
	DA_SI_XI			= {name = "DA_SI_XI",fan = 88,res="game_res/fan/dasixi.png"},				--大四喜
	XIAO_SI_XI			= {name = "XIAO_SI_XI",fan = 64,res="game_res/fan/xiaosixi.png"},			--小四喜
	DA_SAN_YUAN			= {name = "DA_SAN_YUAN",fan = 88,res="game_res/fan/dasanyuan.png"},			--大三元
	XIAO_SAN_YUAN		= {name = "XIAO_SAN_YUAN",fan = 64,res="game_res/fan/xiaosanyuan.png"},		--小三元
	JIU_LIAN_BAO_DENG	= {name = "JIU_LIAN_BAO_DENG",fan = 88,res="game_res/fan/jiulianbaodeng.png"},	--九莲宝灯
	LUO_HAN_18			= {name = "LUO_HAN_18",fan = 88,res="game_res/fan/dihu.png"},			--18罗汉
	SHUANG_LONG_HUI		= {name = "SHUANG_LONG_HUI",fan = 64,res="game_res/fan/yiseshuanglonghui.png"},		--一色双龙会
	YI_SE_SI_TONG_SHUN	= {name = "YI_SE_SI_TONG_SHUN",fan = 48,res="game_res/fan/yisesitongshun.png"},	--一色四同顺
	YI_SE_SI_JIE_GAO	= {name = "YI_SE_SI_JIE_GAO",fan = 48,res="game_res/fan/yisesijiegao.png"},		--一色四节高
	YI_SE_SI_BU_GAO		= {name = "YI_SE_SI_BU_GAO",fan = 32,res="game_res/fan/yisesibugao.png"},		--一色四步高
	HUN_YAO_JIU			= {name = "HUN_YAO_JIU",fan = 32,res="game_res/fan/hunyaojiu.png"},			--混幺九
	YI_SE_SAN_JIE_GAO	= {name = "YI_SE_SAN_JIE_GAO",fan = 24,res="game_res/fan/yisesanjiegao.png"},	--一色三节高
	YI_SE_SAN_TONG_SHUN	= {name = "YI_SE_SAN_TONG_SHUN",fan = 24,res="game_res/fan/yisesantongshun.png"},	--一色三同顺
	SI_ZI_KE			= {name = "SI_ZI_KE",fan = 24,res="game_res/fan/dihu.png"},				--四字刻
	QING_LONG			= {name = "QING_LONG",fan = 16,res="game_res/fan/qinglong.png"},			--清龙
	YI_SE_SAN_BU_GAO	= {name = "YI_SE_SAN_BU_GAO",fan = 16,res="game_res/fan/yisesanbugao.png"},		--一色三步高
}
--把服务器的牌值转换成本地的牌值
--服务器牌值规则
--一万到九万， 东-南-西-北  -中-发-白-   春-夏-秋-冬-梅-兰-竹-菊--
--	1-9		    10-13			14-16		20-27
function TmjConfig.convertToLocalCard(serVal)
	return serVal<=TmjConfig.Card.R_White and serVal or (serVal - 20) + TmjConfig.Card.R_Spring
end
--把本地的牌值转换成服务器的牌值
function TmjConfig.convertToServerCard(localVal)
	return localVal <= TmjConfig.Card.R_White and localVal or (localVal - TmjConfig.Card.R_Spring) + 20
end
--播放骨骼动画
--@param aniFile 动作名字
--@param aniName 动画名字
--@param parentNode 父节点
--@param animPos 位置
--@param isLoop 是否循环
--@param movementFun 动画播放完成回调
function TmjConfig.playAmature(aniFile,aniName,parentNode,animPos,isLoop,movementFun)
	local anim = ccs.Armature:create(aniFile)
	anim:getAnimation():setMovementEventCallFunc(function(sender, type, id)
		if type == ccs.MovementEventType.complete and id == aniName then
			if not isLoop then
				sender:removeSelf()
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
	parentNode:addChild(anim,TmjConfig.LayerOrder.GAME_EFFECT_LAYER)
end
--按钮
function TmjConfig.playButtonSound()
	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
end

return TmjConfig