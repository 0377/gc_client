HallGameConfig = {};
HallGameConfig.defalutIPAddr 					= "192.168.7.57"
HallGameConfig.defalutPort 						=  8004

HallGameConfig.game = {};


HallGameConfig.game.ID_DemoGame    = 2   
HallGameConfig.game.ID_DDZGame     = 5  -- 斗地主
HallGameConfig.game.ID_GFLOWER     = 6  -- 炸金花
HallGameConfig.game.ID_SHGame     = 7   --梭哈

HallGameConfig.game.ID_FISHGAME    = 3   --zzl 捕鱼游戏id  与服务器同步 李逵

HallGameConfig.game.ID_BRNNGame    = 8  -- 百人牛牛
HallGameConfig.game.ID_TMJGame    = 13  -- 二人麻将
HallGameConfig.game.ID_LHJGame     = 12 -- 老虎机
HallGameConfig.game.ID_DZPKGame    = 11 -- 德州扑克
HallGameConfig.game.ID_QZNNGame    = 14 -- 抢庄牛牛
HallGameConfig.game.ID_DFLHJGame    = 15 -- 多福老虎机
--- wKind:游戏ID gameName:游戏名称 module:游戏模块  entrance:游戏入口加载文件 dwClientVersion:游戏版本号
HallGameConfig.gameOrderList = 
{
	HallGameConfig.game.ID_DDZGame,
	--HallGameConfig.game.ID_FISHGAME2D,
	HallGameConfig.game.ID_GFLOWER,
	HallGameConfig.game.ID_FISHGAME,
	HallGameConfig.game.ID_BRNNGame,
	HallGameConfig.game.ID_TMJGame,
	HallGameConfig.game.ID_LHJGame,
	HallGameConfig.game.ID_DFLHJGame,
	HallGameConfig.game.ID_SHGame,
	HallGameConfig.game.ID_DZPKGame,
	HallGameConfig.game.ID_QZNNGame,
}
dump(HallGameConfig.gameOrderList, "HallGameConfig.gameOrderList", nesting)
---游戏配置信息 相关key
HallGameConfig.GameIDKey			       =			"first_game_type"
HallGameConfig.GameNameKey			       =			"name"
HallGameConfig.GameEntranceKey		       =			"gameModule"
HallGameConfig.GamePackageRootPathKey      =			"package_root_path"
HallGameConfig.GameIconKey			       =			"game_icon"
HallGameConfig.GameIconAnimKey		       =			"game_icon_anim"
HallGameConfig.GameShadowIconKey		   =			"game_shadow_icon"
HallGameConfig.GameVersionKey		       =			"version"
HallGameConfig.GameSecondTitleResKey	   =			"game_second_title_res"
HallGameConfig.GameSecondEffectResKey	   =			"game_second_eff_res"
HallGameConfig.SecondRoomKey 		       = 			"room"
HallGameConfig.SecondRoomIconKey	       =			"room_icon"
HallGameConfig.SecondRoomIconEffectKey	   =			"room_icon_eff" -- 特效信息
HallGameConfig.SecondRoomIDKey 		       =			"second_game_type"
HallGameConfig.SecondRoomNodeClassNameKey  =			"second_game_node"
HallGameConfig.SecondRoomNameKey	       =			"room_name"
HallGameConfig.SecondRoomMinMoneyLimitKey  = 			"money_limit" --最小入场金币限制
HallGameConfig.SecondRoomMinJettonLimitKey =			"cell_money" -- 底注
HallGameConfig.SecondRoomBeiShu			   = 			"beishu" -- 倍数
--游戏图标配置
HallGameConfig.game.IconConfig = {
	   [HallGameConfig.game.ID_DDZGame] = "hall_res/hall/bb_dating_youxitubiao_1_1.png",
    -- [app.config.game.ID_BJL] = "ui/hall/bb_dating_youxitubiao_4_1.png",
    -- [app.config.game.ID_BRNN] = "ui/hall/bb_dating_youxitubiao_3_1.png",
    -- [app.config.game.ID_FISH_LKPY] = "ui/hall/bb_dating_youxitubiao_5_1.png",
       [HallGameConfig.game.ID_GFLOWER] = "hall_res/hall/bb_dating_youxitubiao_2_1.png",
    -- [app.config.game.ID_FQZS] = "ui/hall/bb_dating_youxitubiao_7_1.png",
    -- [app.config.game.ID_SHT] = "ui/hall/bb_dating_youxitubiao_6_1.png",

    [HallGameConfig.game.ID_FISHGAME] = "hall_res/hall/bb_dating_youxitubiao_8_1.png",

    [HallGameConfig.game.ID_BRNNGame] = "hall_res/hall/bb_dating_youxitubiao_3_1.png",
	
    [HallGameConfig.game.ID_TMJGame] = "hall_res/hall/bb_dating_youxitubiao_9_1.png",

    [HallGameConfig.game.ID_LHJGame] = "hall_res/hall/bb_dating_youxitubiao_4_2.png",
     [HallGameConfig.game.ID_DFLHJGame] = "hall_res/hall/bb_dating_youxitubiao_4_2.png",
    [HallGameConfig.game.ID_DZPKGame] = "hall_res/hall/bb_dating_youxitubiao_10_1.png",

    [HallGameConfig.game.ID_SHGame] = "hall_res/hall/bb_dating_youxitubiao_5_2.png",

    [HallGameConfig.game.ID_QZNNGame] = "hall_res/hall/bb_dating_youxitubiao_6_1.png",


}
--动画美术资源名和路径
HallGameConfig.game.IconAnimResConfig = {
    {"baobo_hall_button_02", "baobo_hall_button_02/baobo_hall_button_02.ExportJson"},
    {"bb_hall_button_03", "bb_hall_button_03/bb_hall_button_03.ExportJson"},
    {"baobo_hall_button_04", "baobo_hall_button_04/baobo_hall_button_04.ExportJson"},
}

-- GameNode.Config_Ani = {
--     [app.config.game.ID_BJL] = {Ani_Name[1][1], "ani_03"},
--     [app.config.game.ID_BRNN] = {Ani_Name[1][1], "ani_04"},
--     [app.config.game.ID_FISH_LKPY] = {Ani_Name[1][1], "ani_05"},
--     [app.config.game.ID_GFLOWER] = {Ani_Name[1][1], "ani_01"},
--     [app.config.game.ID_DDZ] = {Ani_Name[1][1], "ani_02"},
--     [app.config.game.ID_FQZS] = {Ani_Name[2][1], "ani_01"},
--     [app.config.game.ID_SHT] = {Ani_Name[3][1], "ani_01"},
-- }
--游戏动画配置
HallGameConfig.game.IconAnimConfig = {
	[HallGameConfig.game.ID_DDZGame]  = HallGameConfig.game.IconAnimResConfig[1][1].."#ani_02",--#前面为动画资源名，后面为动画名
	[HallGameConfig.game.ID_GFLOWER]  = HallGameConfig.game.IconAnimResConfig[1][1].."#ani_01",--#前面为动画资源名，后面为动画名
	[HallGameConfig.game.ID_BRNNGame]  = HallGameConfig.game.IconAnimResConfig[1][1].."#ani_01",

	[HallGameConfig.game.ID_DZPKGame]  = HallGameConfig.game.IconAnimResConfig[1][1].."#ani_01",
	[HallGameConfig.game.ID_QZNNGame]  = HallGameConfig.game.IconAnimResConfig[1][1].."#ani_01",
}
--game const config
HallGameConfig.allGames = {
	[HallGameConfig.game.ID_DDZGame] = {
		[HallGameConfig.GameNameKey]		          = "斗地主",
		[HallGameConfig.GamePackageRootPathKey]       = "games/ddzgame/",         
		[HallGameConfig.GameEntranceKey]	          = "DdzGameEntry",
		[HallGameConfig.GameIconKey]	 			  =	HallGameConfig.game.IconConfig[HallGameConfig.game.ID_DDZGame],
		[HallGameConfig.GameShadowIconKey]			  = "hall_res/hall/bb_dating_tubiao_daoying_ddz.png",
		-- [HallGameConfig.GameIconAnimKey]			  = HallGameConfig.game.IconAnimConfig[HallGameConfig.game.ID_DDZGame],
		-- [HallGameConfig.SecondRoomNodeClassNameKey]   = "secondary_game_node.SecondaryDDZNode",
		-- [HallGameConfig.GameSecondEffectResKey]	      = "anim/game_select/bb_ddz_room_eff/bb_ddz_room_eff.ExportJson",--前面为资源名，后面为动画名
		[HallGameConfig.GameSecondTitleResKey]	      =	"hall_res/game_select/ddz_chart/bb_fc_ddz_biaotizi.png",
		[HallGameConfig.SecondRoomKey]		          = {
			{
				[HallGameConfig.SecondRoomNameKey]			  = "新手场",
				[HallGameConfig.SecondRoomIDKey] 			  = 1,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/ddz_chart/BB_icon_ddz_xsc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "普通场",
				[HallGameConfig.SecondRoomIDKey] 			  = 2,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/ddz_chart/BB_icon_ddz_cjc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_02",	
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 600,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	100			
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "高手场",
				[HallGameConfig.SecondRoomIDKey] 			  = 3,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/ddz_chart/BB_icon_ddz_gjc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_03",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 1000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	300				
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "大师场",
				[HallGameConfig.SecondRoomIDKey] 			  = 4,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/ddz_chart/BB_icon_ddz_fhc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_04",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 2000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	500						
			}
		}
	},
	[HallGameConfig.game.ID_GFLOWER] = {
		[HallGameConfig.GameNameKey]		          = "炸金花",
		[HallGameConfig.GamePackageRootPathKey]       = "games/gflower/",
		[HallGameConfig.GameEntranceKey]	          = "gflowerEntry",
		[HallGameConfig.GameIconKey]	 			  =	HallGameConfig.game.IconConfig[HallGameConfig.game.ID_GFLOWER],
		[HallGameConfig.GameShadowIconKey]			  = "hall_res/hall/bb_dating_tubiao_daoying_zjh.png",
		-- [HallGameConfig.GameIconAnimKey]			  = HallGameConfig.game.IconAnimConfig[HallGameConfig.game.ID_GFLOWER],
		-- [HallGameConfig.SecondRoomNodeClassNameKey]   = "secondary_game_node.SceondaryZJHNode",
		-- [HallGameConfig.GameSecondEffectResKey]	      = "anim/game_select/baobo_zjh_choice_02/baobo_zjh_choice_02.ExportJson",--前面为资源名，后面为动画名
		[HallGameConfig.GameSecondTitleResKey]	      =	"hall_res/game_select/zjh_chart/bb_fc_zjh_biaotizi.png",
		[HallGameConfig.SecondRoomKey]		          = {
			{
				[HallGameConfig.SecondRoomNameKey]			  = "新手",
				[HallGameConfig.SecondRoomIDKey] 			  = 1,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/zjh_chart/BB_icon_zjh_qgc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "初级",
				[HallGameConfig.SecondRoomIDKey] 			  = 2,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/zjh_chart/BB_icon_zjh_pmc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_02",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 600,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	100
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "高级",
				[HallGameConfig.SecondRoomIDKey] 			  = 3,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/zjh_chart/BB_icon_zjh_zdc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_03",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 1000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	300
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "富豪",
				[HallGameConfig.SecondRoomIDKey] 			  = 4,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/zjh_chart/BB_icon_zjh_fhc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_04",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 2000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	500
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "贵宾",
				[HallGameConfig.SecondRoomIDKey] 			  = 5,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/zjh_chart/BB_icon_zjh_gbc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_04",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 2000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	500
			}
		}
	},

	--捕鱼测试数据  zzl
	[HallGameConfig.game.ID_FISHGAME] = {
		[HallGameConfig.GameNameKey]		          = "捕鱼测试",
		[HallGameConfig.GamePackageRootPathKey]       = "games/fishgame/",
		[HallGameConfig.GameEntranceKey]	          = "FishgameEntry",
		[HallGameConfig.GameIconKey]	 			  =	HallGameConfig.game.IconConfig[HallGameConfig.game.ID_FISHGAME],
		[HallGameConfig.SecondRoomNodeClassNameKey]   = "secondary_game_node.SceondaryLKPYNode",
		[HallGameConfig.GameSecondTitleResKey]	      =	"hall_res/game_select/lkpy_chart/bb_fc_lkpy_biaotizi.png",
		[HallGameConfig.SecondRoomKey]		          = {
			{
				[HallGameConfig.SecondRoomNameKey]			  = "海沟",
				[HallGameConfig.SecondRoomIDKey] 			  = 1,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/lkpy_chart/BB_icon_lkpy_hg.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "浅滩",
				[HallGameConfig.SecondRoomIDKey] 			  = 2,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/lkpy_chart/BB_icon_lkpy_qt.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "深海",
				[HallGameConfig.SecondRoomIDKey] 			  = 3,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/lkpy_chart/BB_icon_lkpy_sh.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "峡湾",
				[HallGameConfig.SecondRoomIDKey] 			  = 4,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/lkpy_chart/BB_icon_lkpy_xw.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10
			},
		}
	},

	[HallGameConfig.game.ID_BRNNGame] = {
		[HallGameConfig.GameNameKey]		          = "百人牛牛",
		[HallGameConfig.GamePackageRootPathKey]       = "games/brnngame/",
		[HallGameConfig.GameEntranceKey]	          = "BrnnGameEntry",
		[HallGameConfig.GameIconKey]	 			  =	HallGameConfig.game.IconConfig[HallGameConfig.game.ID_BRNNGame],
		[HallGameConfig.GameShadowIconKey]			  = "hall_res/hall/bb_dating_tubiao_daoying_brnn.png",
		-- [HallGameConfig.GameIconAnimKey]			  = HallGameConfig.game.IconAnimConfig[HallGameConfig.game.ID_BRNNGame],
		[HallGameConfig.SecondRoomNodeClassNameKey]   = "secondary_game_node.SecondaryBRNNNode",
		-- [HallGameConfig.GameSecondEffectResKey]	      = "anim/game_select/baobo_zjh_choice_02/baobo_zjh_choice_02.ExportJson",--前面为资源名，后面为动画名
		[HallGameConfig.GameSecondTitleResKey]	      =	"hall_res/game_select/brnn_chart/bb_fc_brnn_biaotizi.png",
		[HallGameConfig.SecondRoomKey]		          = {
			{
				[HallGameConfig.SecondRoomNameKey]			  = "小牛场",
				[HallGameConfig.SecondRoomIDKey] 			  = 2,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/brnn_chart/BB_icon_brnn_xbc.png",
				[HallGameConfig.SecondRoomBeiShu]			  = 3,
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "高倍场",
				[HallGameConfig.SecondRoomIDKey] 			  = 1,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/brnn_chart/BB_icon_brnn_gbc.png",
				[HallGameConfig.SecondRoomBeiShu]			  = 10,
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			}
		}
	},
	[HallGameConfig.game.ID_TMJGame] = {
		[HallGameConfig.GameNameKey]		          = "二人麻将",
		[HallGameConfig.GamePackageRootPathKey]       = "games/tmjgame/",
		[HallGameConfig.GameEntranceKey]	          = "games.tmjgame.src.TmjGameEntry",
		[HallGameConfig.GameIconKey]	 			  =	HallGameConfig.game.IconConfig[HallGameConfig.game.ID_TMJGame],
		[HallGameConfig.GameShadowIconKey]			  = "hall_res/hall/bb_dating_tubiao_daoying_brnn.png",
		-- [HallGameConfig.GameIconAnimKey]			  = HallGameConfig.game.IconAnimConfig[HallGameConfig.game.ID_BRNNGame],
		-- [HallGameConfig.SecondRoomNodeClassNameKey]   = "secondary_game_node.SceondaryZJHNode",
		-- [HallGameConfig.GameSecondEffectResKey]	      = "anim/game_select/baobo_zjh_choice_02/baobo_zjh_choice_02.ExportJson",--前面为资源名，后面为动画名
		[HallGameConfig.GameSecondTitleResKey]	      =	"hall_res/game_select/ermj_chart/bb_fc_ermj_biaotizi.png",
		[HallGameConfig.SecondRoomKey]		          = {
			{
				[HallGameConfig.SecondRoomNameKey]			  = "小雀场",
				[HallGameConfig.SecondRoomIDKey] 			  = 1,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/ermj_chart/BB_icon_ermj_xqc.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "成雀场",
				[HallGameConfig.SecondRoomIDKey] 			  = 2,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/ermj_chart/BB_icon_ermj_cqc.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "老雀场",
				[HallGameConfig.SecondRoomIDKey] 			  = 3,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/ermj_chart/BB_icon_ermj_lqc.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "雀神场",
				[HallGameConfig.SecondRoomIDKey] 			  = 4,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/ermj_chart/BB_icon_ermj_qsc.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			}
		}
	},
	[HallGameConfig.game.ID_LHJGame] = {
		[HallGameConfig.GameNameKey]		          = "老虎机",
		[HallGameConfig.GamePackageRootPathKey]       = "games/lhjgame/",
		[HallGameConfig.GameEntranceKey]	          = "LhjGameEntry",
		[HallGameConfig.GameIconKey]	 			  =	HallGameConfig.game.IconConfig[HallGameConfig.game.ID_LHJGame],
		[HallGameConfig.GameShadowIconKey]			  = "hall_res/hall/bb_dating_tubiao_daoying_lhj.png",
		-- [HallGameConfig.GameIconAnimKey]			  = HallGameConfig.game.IconAnimConfig[HallGameConfig.game.ID_GFLOWER],
		-- [HallGameConfig.SecondRoomNodeClassNameKey]   = "secondary_game_node.SceondaryLHJNode",
		-- [HallGameConfig.GameSecondEffectResKey]	      = "anim/game_select/baobo_zjh_choice_02/baobo_zjh_choice_02.ExportJson",--前面为资源名，后面为动画名
		[HallGameConfig.GameSecondTitleResKey]	      =	"hall_res/game_select/slotmachine_chart/bb_fc_lhj_biaotizi.png",
		[HallGameConfig.SecondRoomKey]		          = {
			{
				[HallGameConfig.SecondRoomNameKey]			  = "练习",
				[HallGameConfig.SecondRoomIDKey] 			  = 1,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/slotmachine_chart/BB_icon_lhj_xsc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "水果",
				[HallGameConfig.SecondRoomIDKey] 			  = 2,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/slotmachine_chart/bb_fc_lhj_tb2.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_02",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 600,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	100
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "发财",
				[HallGameConfig.SecondRoomIDKey] 			  = 3,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/slotmachine_chart/BB_icon_lhj_fcc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_03",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 1000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	300
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "爆机",
				[HallGameConfig.SecondRoomIDKey] 			  = 4,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/slotmachine_chart/BB_icon_lhj_bjc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_04",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 2000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	500
			},
		}
	},

	[HallGameConfig.game.ID_DFLHJGame] = {
		[HallGameConfig.GameNameKey]		          = "多福老虎机",
		[HallGameConfig.GamePackageRootPathKey]       = "games/dflhjgame/",
		[HallGameConfig.GameEntranceKey]	          = "DflhjGameEntry",
		[HallGameConfig.GameIconKey]	 			  =	HallGameConfig.game.IconConfig[HallGameConfig.game.ID_DFLHJGame],
		[HallGameConfig.GameShadowIconKey]			  = "hall_res/hall/bb_dating_tubiao_daoying_lhj.png",
		-- [HallGameConfig.GameIconAnimKey]			  = HallGameConfig.game.IconAnimConfig[HallGameConfig.game.ID_GFLOWER],
		-- [HallGameConfig.SecondRoomNodeClassNameKey]   = "secondary_game_node.SceondaryLHJNode",
		-- [HallGameConfig.GameSecondEffectResKey]	      = "anim/game_select/baobo_zjh_choice_02/baobo_zjh_choice_02.ExportJson",--前面为资源名，后面为动画名
		[HallGameConfig.GameSecondTitleResKey]	      =	"hall_res/game_select/slotmachine_chart/bb_fc_lhj_biaotizi.png",
		[HallGameConfig.SecondRoomKey]		          = {
			{
				[HallGameConfig.SecondRoomNameKey]			  = "练习",
				[HallGameConfig.SecondRoomIDKey] 			  = 1,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/slotmachine_chart/BB_icon_lhj_xsc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10
			},
		}
	},
	
	[HallGameConfig.game.ID_DZPKGame] = {
		[HallGameConfig.GameNameKey]		          = "德州扑克",
		[HallGameConfig.GamePackageRootPathKey]       = "games/dzpkgame/",         
		[HallGameConfig.GameEntranceKey]	          = "games.dzpkgame.src.DzpkGameEntry",
		[HallGameConfig.GameIconKey]	 			  =	HallGameConfig.game.IconConfig[HallGameConfig.game.ID_DZPKGame],
		[HallGameConfig.GameShadowIconKey]			  = "hall_res/hall/bb_dating_tubiao_daoying_dzpk.png",
		-- [HallGameConfig.GameIconAnimKey]			  = HallGameConfig.game.IconAnimConfig[HallGameConfig.game.ID_DDZGame],
		[HallGameConfig.SecondRoomNodeClassNameKey]   = "secondary_game_node.SecondaryDZPKNode",
		-- [HallGameConfig.GameSecondEffectResKey]	      = "anim/game_select/bb_ddz_room_eff/bb_ddz_room_eff.ExportJson",--前面为资源名，后面为动画名
		[HallGameConfig.GameSecondTitleResKey]	      =	"hall_res/game_select/dzpk_chart/bb_fc_dzpk_biaotizi.png",
		[HallGameConfig.SecondRoomKey]		          = {
			{
				[HallGameConfig.SecondRoomNameKey]			  = "新手场",
				[HallGameConfig.SecondRoomIDKey] 			  = 1,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/dzpk_chart/BB_icon_dzpk_xsc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "高手场",
				[HallGameConfig.SecondRoomIDKey] 			  = 2,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/dzpk_chart/BB_icon_dzpk_gsc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_02",	
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 600,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	100			
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "大师场",
				[HallGameConfig.SecondRoomIDKey] 			  = 3,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/dzpk_chart/BB_icon_dzpk_dsc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_03",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 1000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	300				
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "专家场",
				[HallGameConfig.SecondRoomIDKey] 			  = 4,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/dzpk_chart/BB_icon_dzpk_zjc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_04",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 2000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	500						
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "土豪场",
				[HallGameConfig.SecondRoomIDKey] 			  = 5,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/np_zh_dzpk_chart/bb_fc_dzpk_tb4.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_04",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 2000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	500						
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "贵族场",
				[HallGameConfig.SecondRoomIDKey] 			  = 6,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/np_zh_dzpk_chart/bb_fc_dzpk_tb4.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_04",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 2000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	500						
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "皇家场",
				[HallGameConfig.SecondRoomIDKey] 			  = 7,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/np_zh_dzpk_chart/bb_fc_dzpk_tb4.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_04",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 2000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	500						
			}
		}
	},
	[HallGameConfig.game.ID_SHGame] = {
		[HallGameConfig.GameNameKey]		          = "二人梭哈",
		[HallGameConfig.GamePackageRootPathKey]       = "games/shgame/",
		[HallGameConfig.GameEntranceKey]	          = "games.shgame.src.SHGameEntry",
		[HallGameConfig.GameIconKey]	 			  =	HallGameConfig.game.IconConfig[HallGameConfig.game.ID_SHGame],
		[HallGameConfig.GameShadowIconKey]			  = "hall_res/hall/bb_dating_tubiao_daoying_brnn.png",
		-- [HallGameConfig.GameIconAnimKey]			  = HallGameConfig.game.IconAnimConfig[HallGameConfig.game.ID_BRNNGame],
		-- [HallGameConfig.SecondRoomNodeClassNameKey]   = "secondary_game_node.SceondaryZJHNode",
		-- [HallGameConfig.GameSecondEffectResKey]	      = "anim/game_select/baobo_zjh_choice_02/baobo_zjh_choice_02.ExportJson",--前面为资源名，后面为动画名
		[HallGameConfig.GameSecondTitleResKey]	      =	"hall_res/game_select/sh_chart/bb_fc_ersh_biaotizi.png",
		[HallGameConfig.SecondRoomKey]		          = {
			{
				[HallGameConfig.SecondRoomNameKey]			  = "新手场",
				[HallGameConfig.SecondRoomIDKey] 			  = 1,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/sh_chart/BB_icon_ersh_xsc.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "普通场",
				[HallGameConfig.SecondRoomIDKey] 			  = 2,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/sh_chart/BB_icon_ersh_ptc.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "高手场",
				[HallGameConfig.SecondRoomIDKey] 			  = 3,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/sh_chart/BB_icon_ersh_gsc.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "大师场",
				[HallGameConfig.SecondRoomIDKey] 			  = 4,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/sh_chart/BB_icon_ersh_dsc.png",
				--[HallGameConfig.SecondRoomIconEffectKey]	  = "baobo_zjh_choice_02#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
		}
	},
	[HallGameConfig.game.ID_QZNNGame] = {
		[HallGameConfig.GameNameKey]		          = "抢庄牛牛",
		[HallGameConfig.GamePackageRootPathKey]       = "games/qznngame/",
		[HallGameConfig.GameEntranceKey]	          = "games.qznngame.src.QznnGameEntry",
		[HallGameConfig.GameIconKey]	 			  =	HallGameConfig.game.IconConfig[HallGameConfig.game.ID_QZNNGame],
		[HallGameConfig.GameShadowIconKey]			  = "hall_res/hall/bb_dating_tubiao_daoying_dzpk.png",
		-- [HallGameConfig.GameIconAnimKey]			  = HallGameConfig.game.IconAnimConfig[HallGameConfig.game.ID_DDZGame],
		-- [HallGameConfig.SecondRoomNodeClassNameKey]   = "secondary_game_node.SecondaryDZPKNode",
		-- [HallGameConfig.GameSecondEffectResKey]	      = "anim/game_select/bb_ddz_room_eff/bb_ddz_room_eff.ExportJson",--前面为资源名，后面为动画名
		[HallGameConfig.GameSecondTitleResKey]	      =	"hall_res/game_select/qznn_chart/bb_fc_qznn_biaotizi.png",
		[HallGameConfig.SecondRoomKey]		          = {
			{
				[HallGameConfig.SecondRoomNameKey]			  = "小牛场",
				[HallGameConfig.SecondRoomIDKey] 			  = 1,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/qznn_chart/BB_icon_qznn_xnc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_01",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 200,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	10	
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "壮牛场",
				[HallGameConfig.SecondRoomIDKey] 			  = 2,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/qznn_chart/BB_icon_qznn_znc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_02",	
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 600,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	100			
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "铁牛场",
				[HallGameConfig.SecondRoomIDKey] 			  = 3,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/qznn_chart/BB_icon_qznn_tnc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_03",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 1000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	300				
			},
			{
				[HallGameConfig.SecondRoomNameKey]			  = "金牛场",
				[HallGameConfig.SecondRoomIDKey] 			  = 4,
				[HallGameConfig.SecondRoomIconKey]			  = "hall_res/game_select/qznn_chart/BB_icon_qznn_jnc.png",
				-- [HallGameConfig.SecondRoomIconEffectKey]	  = "bb_ddz_room_eff#ani_04",
				-- [HallGameConfig.SecondRoomMinMoneyLimitKey]	  = 2000,
				-- [HallGameConfig.SecondRoomMinJettonLimitKey]  =	500						
			}
		}
	}
}