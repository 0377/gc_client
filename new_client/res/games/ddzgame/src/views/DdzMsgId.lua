--
-- Created by IntelliJ IDEA.
-- User: admin
-- Date: 2016/8/22
-- Time: 9:27
-- To change this template use File | Settings | File Templates.
--

-- KIND_ID						1001								//游戏 I D
-- GAME_NAME					TEXT("斗地主")						//游戏名字

gameDdz = gameDdz or {}


gameDdz.GAME_PLAYER     =       3


-- 数目定义
gameDdz.MAX_COUNT       =       20                                  -- 最大数目
gameDdz.FULL_COUNT      =       54                                  -- 全牌数目

-- 逻辑数目
gameDdz.NORMAL_COUNT	    =       17                              -- 常规数目
gameDdz.DISPATCH_COUNT	    =       51                              -- 派发数目
gameDdz.GOOD_CARD_COUTN	    =       38                              -- 好牌数目




-- MDM_GF_FRAME
gameDdz.GAME_SCENE_FREE     =       0                               -- 等待开始
gameDdz.GAME_SCENE_CALL     =       100                             -- 叫分状态
gameDdz.GAME_SCENE_PLAY     =       101                             -- 游戏进行


--        //空闲状态
--struct CMD_S_StatusFree
--    {
--        //游戏属性
--LONG							lCellScore;							//基础积分
--
--//时间信息
--BYTE							cbTimeOutCard;						//出牌时间
--BYTE							cbTimeCallScore;					//叫分时间
--BYTE							cbTimeStartGame;					//开始时间
--BYTE							cbTimeHeadOutCard;					//首出时间
--
--//历史积分
--SCORE							lTurnScore[GAME_PLAYER];			//积分信息
--SCORE							lCollectScore[GAME_PLAYER];			//积分信息
--};
--
--//叫分状态
--struct CMD_S_StatusCall
--    {
--        //时间信息
--BYTE							cbTimeOutCard;						//出牌时间
--BYTE							cbTimeCallScore;					//叫分时间
--BYTE							cbTimeStartGame;					//开始时间
--BYTE							cbTimeHeadOutCard;					//首出时间
--
--//游戏信息
--LONG							lCellScore;							//单元积分
--WORD							wCurrentUser;						//当前玩家
--BYTE							cbBankerScore;						//庄家叫分
--BYTE							cbScoreInfo[GAME_PLAYER];			//叫分信息
--BYTE							cbHandCardData[NORMAL_COUNT];		//手上扑克
--
--//历史积分
--SCORE							lTurnScore[GAME_PLAYER];			//积分信息
--SCORE							lCollectScore[GAME_PLAYER];			//积分信息
--};
--
--//游戏状态
--struct CMD_S_StatusPlay
--    {
--        //时间信息
--BYTE							cbTimeOutCard;						//出牌时间
--BYTE							cbTimeCallScore;					//叫分时间
--BYTE							cbTimeStartGame;					//开始时间
--BYTE							cbTimeHeadOutCard;					//首出时间
--
--//游戏变量
--LONG							lCellScore;							//单元积分
--BYTE							cbBombCount;						//炸弹次数
--WORD							wBankerUser;						//庄家用户
--WORD							wCurrentUser;						//当前玩家
--BYTE							cbBankerScore;						//庄家叫分
--
--//出牌信息
--WORD							wTurnWiner;							//胜利玩家
--BYTE							cbTurnCardCount;					//出牌数目
--BYTE							cbTurnCardData[MAX_COUNT];			//出牌数据
--
--//扑克信息
--BYTE							cbBankerCard[3];					//游戏底牌
--BYTE							cbHandCardData[MAX_COUNT];			//手上扑克
--BYTE							cbHandCardCount[GAME_PLAYER];		//扑克数目
--
--//历史积分
--SCORE							lTurnScore[GAME_PLAYER];			//积分信息
--SCORE							lCollectScore[GAME_PLAYER];			//积分信息
--};
gameDdz.US_FREE                     =   1                                --站立状态
gameDdz.US_SIT                      =   2                                --坐下状态
gameDdz.US_READY                    =   3                                --同意状态
gameDdz.US_LOOKON                   =   4                                --旁观状态
gameDdz.US_PLAYING                  =   5                                --游戏状态


-- MDM_GF_GAME
gameDdz.SUB_S_GAME_START	    =           100                 -- 游戏开始
gameDdz.SUB_S_CALL_SCORE	    =           101                 -- 用户叫分
gameDdz.SUB_S_BANKER_INFO	    =           102                 -- 庄家信息
gameDdz.SUB_S_OUT_CARD		    =           103                 -- 用户出牌
gameDdz.SUB_S_PASS_CARD		    =           104                 -- 用户放弃
gameDdz.SUB_S_GAME_CONCLUDE	    =           105                 -- 游戏结束
gameDdz.SUB_S_SET_BASESCORE	    =           106                 -- 设置基数
gameDdz.SUB_S_USER_HOSTING	    =           107                 -- 用户托管
gameDdz.SUB_S_CACEL_HOSTING	    =           108                 -- 取消托管
gameDdz.SUB_S_STATUS_PLAY	    =           109                 -- 游戏状态

gameDdz.SUB_C_CALL_SCORE        =           1                   -- 用户叫分
gameDdz.SUB_C_OUT_CARD	        =           2                   -- 用户出牌
gameDdz.SUB_C_PASS_CARD	        =           3                   -- 用户放弃
gameDdz.SUB_C_APPLY_HOSTING	    =           4                   -- 申请托管
gameDdz.SUB_C_CANCEL_HOSTING	=           5                   -- 取消托管


--        //发送扑克
--struct CMD_S_GameStart
--    {
--        WORD							wStartUser;							//开始玩家
--WORD				 			wCurrentUser;						//当前玩家
--BYTE							cbValidCardData;					//明牌扑克
--BYTE							cbValidCardIndex;					//明牌位置
--BYTE							cbCardData[NORMAL_COUNT];			//扑克列表
--};
--
--//机器人扑克
--struct CMD_S_AndroidCard
--    {
--        BYTE							cbHandCard[GAME_PLAYER][NORMAL_COUNT];//手上扑克
--WORD							wCurrentUser ;						//当前玩家
--};
--
--//用户叫分
--struct CMD_S_CallScore
--    {
--        WORD				 			wCurrentUser;						//当前玩家
--WORD							wCallScoreUser;						//叫分玩家
--BYTE							cbCurrentScore;						//当前叫分
--BYTE							cbUserCallScore;					//上次叫分
--};
--
--//庄家信息
--struct CMD_S_BankerInfo
--    {
--        WORD				 			wBankerUser;						//庄家玩家
--WORD				 			wCurrentUser;						//当前玩家
--BYTE							cbBankerScore;						//庄家叫分
--BYTE							cbBankerCard[3];					//庄家扑克
--};
--
--//用户出牌
--struct CMD_S_OutCard
--    {
--        BYTE							cbCardCount;						//出牌数目
--WORD				 			wCurrentUser;						//当前玩家
--WORD							wOutCardUser;						//出牌玩家
--BYTE							cbCardData[MAX_COUNT];				//扑克列表
--};
--
--//放弃出牌
--struct CMD_S_PassCard
--    {
--        BYTE							cbTurnOver;							//一轮结束
--WORD				 			wCurrentUser;						//当前玩家
--WORD				 			wPassCardUser;						//放弃玩家
--};
--
--//游戏结束
--struct CMD_S_GameConclude
--    {
--        //积分变量
--LONG							lCellScore;							//单元积分
--SCORE							lGameScore[GAME_PLAYER];			//游戏积分
--
--//春天标志
--BYTE							bChunTian;							//春天标志
--BYTE							bFanChunTian;						//春天标志
--
--//炸弹信息
--BYTE							cbBombCount;						//炸弹个数
--BYTE							cbEachBombCount[GAME_PLAYER];		//炸弹个数
--
--//游戏信息
--BYTE							cbBankerScore;						//叫分数目
--BYTE							cbCardCount[GAME_PLAYER];			//扑克数目
--BYTE							cbHandCardData[FULL_COUNT];			//扑克列表
--};

--用户放弃//用户叫分
--struct CMD_C_CallScore
--    {
--        BYTE							cbCallScore;						//叫分数目
--};
--
--//用户出牌
--struct CMD_C_OutCard
--    {
--        BYTE							cbCardCount;						//出牌数目
--BYTE							cbCardData[MAX_COUNT];				//扑克数据
--};
--
--//////////////////////////////////////////////////////////////////////////////////