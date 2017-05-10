
-- 服务端
GF_SUB_S_GAME_START     =   100     -- 游戏开始
GF_SUB_S_ADD_SCORE      =   101     -- 加注结果
GF_SUB_S_GIVE_UP        =   102     -- 放弃跟注
GF_SUB_S_SEND_CARD      =   103     -- 发牌消息
GF_SUB_S_GAME_END       =   104     -- 游戏结束
GF_SUB_S_COMPARE_CARD   =   105     -- 比牌跟注
GF_SUB_S_LOOK_CARD      =   106     -- 看牌跟注
GF_SUB_S_PLAYER_EXIT    =   107     -- 用户强退
GF_SUB_S_OPEN_CARD      =   108     -- 开牌消息
GF_SUB_S_WAIT_COMPARE   =   109     -- 等待比牌
GF_SUB_S_LAST_COMPARE_DATA = 110	-- 最后比牌
GF_SUB_S_NO_MONEY		=	111		-- 金币不足


-- 客户端
GF_SUB_C_ADD_SCORE         =   1    -- 用户加注
GF_SUB_C_GIVE_UP           =   2    -- 放弃消息
GF_SUB_C_COMPARE_CARD      =   3    -- 比牌消息
GF_SUB_C_LOOK_CARD         =   4    -- 看牌消息
GF_SUB_C_OPEN_CARD         =   5    -- 开牌消息
GF_SUB_C_WAIT_COMPARE      =   6    -- 等待比牌
GF_SUB_C_FINISH_FLASH      =   7    -- 完成动画

-- 框架
GF_GS_TK_FREE       = 101   -- 等待开始
GF_GS_TK_CALL       = 102   -- 叫庄
GF_GS_TK_SCORE      = 103   -- 下注
GF_GS_TK_PLAYING    = 104   -- 进行
GF_SUB_GF_SYSTEM_MESSAGE = 200 -- 系统消息

-- 状态
GF_GAME_FREE = 18
GF_GAME_PLAYING = 94
