GFlowerConfig = GFlowerConfig or {}
GFlowerConfig.GAME_ID = 1000  -- 游戏ID

--sx
GFlowerConfig.CHAIR_COUNT   = 5     -- 椅子数
GFlowerConfig.CARD_COUNT    = 3     -- 玩家手牌数
GFlowerConfig.MAX_ROUND     = 20    -- 最大轮数
GFlowerConfig.PR_MAX_ROUND  = 100   -- 私人房间最大轮数
GFlowerConfig.COIN_NUM      = 5     -- 筹码数
GFlowerConfig.CHAIR_SELF    = 1     -- 自己
GFlowerConfig.MAX_JETTON    = 300

-- 房间类型 --
GFlowerConfig.ROOM_TYPE = { 1, 2, 3, 4 }
GFlowerConfig.COUNT_DOWN_TIME = 15    -- 倒计时
GFlowerConfig.START_MIN_NUMBER = 2    -- 最小开始人数
GFlowerConfig.CARD_SPACE = 15         -- 扑克间距

-- 结算界面准备倒计时
GFlowerConfig.READY_TIME = 10

-- 加注倍数  --sx
GFlowerConfig.ADD_BTN_TIMES  = {1, 2, 5, 8, 10}

-- 根据场次 把不同的筹码比例赋值给 GFlowerConfig.ADD_BTN_TIMES
GFlowerConfig.ADD_BTN_TIMES_LIST = {
    {1, 2, 5, 8, 10},
    {1, 2, 5, 8, 10},
    {1, 2, 5, 8, 10},
    {1, 2, 5, 8, 10},
    {1, 2, 5, 8, 10},
}

-- 私人房间配置
GFlowerConfig.PRIVATE_ROOM = {
	{ score = {10, 20, 50, 80, 100}, 			money_limit = 10}, 
	{ score = {100, 200, 500, 800, 1000}, 		money_limit = 100}, 
	{ score = {500, 1000, 2500, 4000, 5000}, 	money_limit = 500}, 
	{ score = {1000, 2000, 5000, 8000, 10000}, 	money_limit = 1000}
} 

-- 私人房间房主位置号
GFlowerConfig.PR_MASTER  = 1

GFlowerConfig.ROOM_STATE ={
    FREE        = 1,
    READY       = 2,
    PLAY        = 3,
}

GFlowerConfig.TAX ={
   OPEN         = 3,
}

-- 卡牌缩放倍数 --
GFlowerConfig.CARD_INIT_SCALE = 0.5
GFlowerConfig.CARD_STAY_SCALE_OTHER = 0.6
GFlowerConfig.CARD_STAY_SCALE_ME = 0.8
GFlowerConfig.CARD_COMPARE_SCALE = 1.0


-- 动画标志
GFlowerConfig.FANPAI_TAG    = 105
GFlowerConfig.WIN_TAG       = 110
GFlowerConfig.PAIXIN_TAG    = 109

-- 牌型动画播放时间 --
GFlowerConfig.CARD_TYPE_BAOZI_ANI_TIME      = 1.4
GFlowerConfig.CARD_TYPE_JINHUA_ANI_TIME     = 0.9
GFlowerConfig.CARD_TYPE_SHUNJIN_ANI_TIME    = 1.33
GFlowerConfig.CARD_TYPE_SHUNZI_ANI_TIME     = 1.33
GFlowerConfig.CARD_TYPE_DUIZI_ANI_TIME      = 0.9

GFlowerConfig.FANPAI_ANI_TIME               = 0.5 

-- 按钮点击缩放倍数 --
GFlowerConfig.BTN_CLICK_SCALE = 0.8
GFlowerConfig.AUTO_READY_SCALE = 0.92

-- 牌型 --
GFlowerConfig.CARD_TYPE = {
    ["CT_SINGLE"] = 1,      -- 单牌
    ["CT_DOUBLE"] = 2,      -- 对子
    ["CT_JIN_HUA"] = 4,     -- 金花
    ["CT_SHUN_ZI"] = 3,     -- 顺子
    ["CT_SHUN_JIN"] = 5,    -- 顺金
    ["CT_BAO_ZI"] = 6,      -- 豹子
    ["CT_SPECIAL"] = 7,     -- 特殊
}

-- 玩家状态 --sx
GFlowerConfig.PLAYER_STATUS = {
    ["STAND"] = -1,         -- 观战
    ["FREE"] = 0,           -- 空闲
    ["READY"] = 1,          -- 准备
    ["WAIT"] = 2,           -- 等待下注
    ["CONTROL"] = 3,        -- 准备操作
    ["LOOK"] = 4,           -- 看牌
    ["COMPARE"] = 5,        -- 比牌
    ["DROP"] = 6,           -- 弃牌
    ["LOSE"] = 7,           -- 淘汰
    ["EXIT"] = 8,           -- 离开
}

-- 筹码资源路径 --sx
GFlowerConfig.COIN_SPRITE_STR = {
    "game_res/baobo_zjh_choma_0x.png",
    "game_res/baobo_zjh_choma_4x.png",
    "game_res/baobo_zjh_chouma_3x.png",
    "game_res/baobo_zjh_chouma_2x.png",
    "game_res/baobo_zjh_chouma_1x.png"
}

-- 状态图片 --sx
GFlowerConfig.IMAGE_PLAYER_STATUS = {
    READY = "game_res/baobo_zjh_yizhunbei.png",  --已准备
    DROP = "game_res/baobo_zjh_qipai.png",       --弃牌
    LOSE = "game_res/baobo_zjh_taotai.png",      --淘汰
    STAND = "game_res/baobo_dengdairuzhuo.png"   --等待入桌
}

-- 气泡贴图 -- sx
GFlowerConfig.IMAGE_PLAYER_CALL = {
    ALL_IN = "game_res/baobo_zjh_art_quanya.png",
    BI_PAI = "game_res/baobo_zjh_art_bipai.png",
    GIVE_UP = "game_res/baobo_zjh_art_qipai.png",
    FOLLOW = "game_res/baobo_zjh_art_genzhu.png",
    ADD_SCORE = "game_res/baobo_zjh_art_jiazhu.png",
}

-- 倒计时图片 -- sx
GFlowerConfig.IMAGE_COUNT_DOWN = {
    "game_res/baobo_zjh_dengdai_1.png",
    "game_res/baobo_zjh_dengdai_2.png",
    "game_res/baobo_zjh_dengdai_3.png",
}

-- 计算界面图片 --
GFlowerConfig.IMAGE_JIESUAN = {
    READY_ENABLE   = "game_res/baobo_zjh_art_zb.png",
    READY_DISABLE  = "game_res/baobo_zjh_art_zb40.png",
    AUTO_READY_GOU = "game_res/baobo_zdks_icon_gou.png" 
}

-- 金花音效音乐按钮图片 --
GFlowerConfig.BTN_IMG = {
    MUSIC_ON_N      = "game_res/baobo_zjh_icon_yyk.png",
    MUSIC_ON_P      = "game_res/baobo_zjh_icon_yyk2.png",
    MUSIC_OFF_N     = "game_res/baobo_zjh_icon_yyg.png",
    MUSIC_OFF_P     = "game_res/baobo_zjh_icon_yyg2.png",
    SOUND_ON_N      = "game_res/baobo_zjh_icon_yxk.png",
    SOUND_ON_P      = "game_res/baobo_zjh_icon_yxk2.png",
    SOUND_OFF_N     = "game_res/baobo_zjh_icon_yxg.png",
    SOUND_OFF_P     = "game_res/baobo_zjh_icon_yxg2.png",
}

-- 按钮文字 --sx
GFlowerConfig.IMAGE_CONTROL_BTN = {
    ALL_IN = {
       "game_res/baobo_zjh_art_qy.png",
       "game_res/baobo_zjh_art_qy40.png",
    },
    BI_PAI = {
        "game_res/baobo_zjh_art_bp.png",
        "game_res/baobo_zjh_art_bp40.png",
    },
    GIVE_UP = {
        "game_res/baobo_zjh_art_qp.png",
        "game_res/baobo_zjh_art_qp40.png"
    },
    FOLLOW = {
        "game_res/baobo_zjh_art_gz.png",
        "game_res/baobo_zjh_art_gz40.png",
    },
    ADD_SCORE = {
        "game_res/baobo_zjh_art_jz.png",
        "game_res/baobo_zjh_art_jz40.png"
    },
    LOOK_CARD = {
        "game_res/baobo_zjh_art_kp.png",
        "game_res/baobo_zjh_art_kp40.png"
    },
}

-- 扑克背面 --sx
GFlowerConfig.POKER = {
    BACK_NORMAL = "games/gflower/res/gpoker/poker_back.png",
    BACK_INVALID = "games/gflower/res/gpoker/baobo_pukepai_2.png"
}

-- 比牌遮罩 --
GFlowerConfig.SHADE_STR = "game_res/baobo_yuanxingqie.png"

-- 玩家坐标 -- sx
GFlowerConfig.PLAYER_LOCATION = {
    { x = 449, y = 247 },
    { x = 1154, y = 267 },
    { x = 1122, y = 500 },
    { x = 148, y = 500 },
    { x = 93, y = 267 },
}

-- 手牌位置 --sx
GFlowerConfig.PLAYER_CARD_POS = {
    { x = 570, y = 250 },
    { x = 964, y = 267 },
    { x = 932, y = 500 },
    { x = 240, y = 500 },
    { x = 185, y = 267 }
}

return GFlowerConfig