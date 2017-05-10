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
FishGameConfig.PLAYER_IDX ={
        LEFTBOTTOM      = 0,
        RIGHTBOTTOM     = 1,
        RIGHTTOP        = 2,
        LEFTTOP         = 3,
}

----------------------------------资源配置----------------------------------------------------------
-- 捕鱼场景图片资源路径
FishGameConfig.IMAGE_SCENE = {
    SCENE_01 = "games/fishgame/res/scene/Map_01.png",
    SCENE_02 = "games/fishgame/res/scene/Map_02.png",
    SCENE_03 = "games/fishgame/res/scene/Map_03.png",
    SCENE_04 = "games/fishgame/res/scene/Map_04.png",
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
    BOUNDING_BOX    = "games/fishgame/res/config/BoundingBox.xml",
    BULLET_SET      = "games/fishgame/res/config/BulletSet.xml",
    CANNON_SET      = "games/fishgame/res/config/CannonSet.xml",
    FISH            = "games/fishgame/res/config/Fish.xml",
    FISH_SOUND      = "games/fishgame/res/config/FishSound.xml",
    FRAME_DEFINE    = "games/fishgame/res/config/FrameDefine.xml",
    PATH            = "games/fishgame/res/config/path.xml",
    SCENE           = "games/fishgame/res/config/Scene.xml",
    SPECIAL         = "games/fishgame/res/config/Special.xml",
    SYSTEM          = "games/fishgame/res/config/System.xml",
    TROOP_SET       = "games/fishgame/res/config/TroopSet.xml",
    VISUAL          = "games/fishgame/res/config/Visual.xml",
}

return FishGameConfig