--
-- Author: yangfan
-- Date: 2017-3-28 
-- 捕鱼游戏配置
--

FishGameConfig = FishGameConfig or {}

----------------------------------数值配置----------------------------------------------------------
-- 规则界面的选择项目
FishGameConfig.RULE_SELECT ={
        NORMAL      = 1,
        BIGFISH     = 2,
        BOSS        = 3,
        SPECIAL     = 4,
}


-- 玩家对应的编号
FishGameConfig.PLAYER ={
        LEFTBOTTOM      = 1,
        RIGHTBOTTOM     = 2,
        RIGHTTOP        = 3,
        LEFTTOP         = 4,
}

FishGameConfig.LBPLAYER_OFFSETX   = 190
FishGameConfig.RBPLAYER_OFFSETX   = 165
FishGameConfig.LTPLAYER_OFFSETX   = 165
FishGameConfig.RTPLAYER_OFFSETX   = 165

FishGameConfig.PLAYER_COUNT       = 4
FishGameConfig.CANNONTYPE_COUNT   = 4


----------------------------------资源配置----------------------------------------------------------
-- 捕鱼场景图片资源路径
FishGameConfig.IMAGE_SCENE = {
--    "scene/Map_likui_001.jpg",
--    "scene/Map_likui_002.jpg",
--    "scene/Map_likui_003.jpg",
    "scene/Map_0.jpg",
    "scene/Map_1.jpg",
    "scene/Map_2.jpg",
    "scene/Map_3.jpg",
    "scene/Map_4.jpg",
    "scene/Map_5.jpg",

}

-- 捕鱼按钮背景（因为点击需要切换图片的按钮才添加）
FishGameConfig.BTN_IMG ={
    MENU_UP_N       = "game_res/by_button_shang_normal.png",
    MENU_UP_P       = "game_res/by_button_shang_pressed.png",
    MENU_DOWN_N     = "game_res/by_button_xia_normal.png",
    MENU_DOWN_P     = "game_res/by_button_xia_pressed.png",
    SOUND_ON_N      = "game_res/by_button_yxk_normal.png",
    SOUND_ON_P      = "game_res/by_button_yxk_pressed.png",
    SOUND_OFF_N     = "game_res/by_button_yxg_normal.png",
    SOUND_OFF_P     = "game_res/by_button_yxg_pressed.png",
    MUSIC_ON_N      = "game_res/by_button_yyk_normal.png",
    NUSIC_ON_P      = "game_res/by_button_yyk_pressed.png",
    MUSIC_OFF_N     = "game_res/by_button_yyg_normal.png",
    MUSIC_OFF_P     = "game_res/by_button_yyg_pressed.png",
    RULE_N          = "game_res/by_gzsm_button_1.png",
    RULE_P          = "game_res/by_gzsm_button_2.png",
}

-- 捕鱼XML配置文件路径
FishGameConfig.XML_CONFIG = {
    BOUNDING_BOX    = "config/BoundingBox.xml",
    BULLET_SET      = "config/BulletSet.xml",
    CANNON_SET      = "config/CannonSet.xml",
    FISH            = "config/Fish.xml",
    FISH_SOUND      = "config/FishSound.xml",
    FRAME_DEFINE    = "config/FrameDefine.xml",
    PATH            = "config/path.xml",
    SCENE           = "config/Scene.xml",
    SPECIAL         = "config/Special.xml",
    SYSTEM          = "config/System.xml",
    TROOP_SET       = "config/TroopSet.xml",
    VISUAL          = "config/Visual.xml",
}

FishGameConfig.PARTICAL_CONFIG = {
    ["salute1"] = { AniImage = "fish_effect_bomb_big_01", AniName = "Animation1" },
    ["bubble"] = { AniImage = "fish_effect_bomb_big_02", AniName = "Animation1" },
    ["switch"] = { AniImage = "fish_effect_bomb_big_03", AniName = "Animation1" },
    ["bomb"] = { AniImage = "fish_effect_bomb_big_04", AniName = "Animation1" },
}

FishGameConfig.FishVisualZOrder = nil


FishGameConfig.FISHNAME_ICON_CONFIG = {
    [16] = "ui/fishname/ts_cjk_yinsefangtousha.png",  -- 银色方头鲨
    [17] = "ui/fishname/ts_cjk_jinsefangtousha.png",  -- 金色方头鲨
    [18] = "ui/fishname/ts_cjk_haitun.png",  -- 海豚
    [19] = "ui/fishname/ts_cjk_jinsehujing.png",  -- 金色虎鲨
    [20] = "ui/fishname/ts_cjk_shuangtouqie.png",  -- 双头企鹅
    [21] = "ui/fishname/ts_cjk_yinlong.png",        -- 银龙
    [22] = "ui/fishname/ts_cjk_jinlong.png",        -- 金龙
    [23] = "ui/fishname/ts_cjk_shenhaizhangyu.png", -- 深海章鱼
    [24] = "ui/fishname/ts_cjk_meirenyu.png",       -- 美人鱼
    [25] = "ui/fishname/ts_cjk_yunliangchuan.png",       -- 运粮船
    [29] = "ui/fishname/ts_cjk_likui.png",       -- 李逵
    [601] = "ui/fishname/ts_cjk_yuwang.png",       -- 鱼王
    [602] = "ui/fishname/ts_cjk_yuwang.png",       -- 鱼王
    [603] = "ui/fishname/ts_cjk_yuwang.png",       -- 鱼王
    [604] = "ui/fishname/ts_cjk_yuwang.png",       -- 鱼王
    [605] = "ui/fishname/ts_cjk_yuwang.png",       -- 鱼王
    [606] = "ui/fishname/ts_cjk_yuwang.png",       -- 鱼王
    [607] = "ui/fishname/ts_cjk_yuwang.png",       -- 鱼王
    [608] = "ui/fishname/ts_cjk_yuwang.png",       -- 鱼王
    [609] = "ui/fishname/ts_cjk_yuwang.png",       -- 鱼王
    [610] = "ui/fishname/ts_cjk_yuwang.png",       -- 鱼王
}

return FishGameConfig