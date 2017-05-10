
gameBrnn = gameBrnn or {}

-- 游戏筹码配置 --
gameBrnn.CONFIG_NORMAL_COIN = {
    -- 0.1,1,5,10,50,100
    10,100,500,1000,5000
}

gameBrnn.CONFIG_NORMAL_COINS = {
    -- 0.1,1,5,10,50,100
	[1] = {100,1000,5000,10000,50000}, --高倍
    [2] = {100,500,1000,2000,5000},		--低倍
}

-----游戏上庄金币
gameBrnn.BankerCion = 
{
    1000000, --高倍
    300000   --低倍
}

gameBrnn.CardsV = 
{	
	---用下标来取扑克资源名字
	11,12,0,1,2,3,4,5,6,7,8,9,10,11,11,11
	-- [1] = 11,   --A
    -- [2] = 12,   --2 
    -- [3] = 0,   --3
    -- [4] = 1,   --4
    -- [5] = 2,   --5
    -- [6] = 3,   --6
    -- [7] = 4,   --7
    -- [8] = 5,   --8
    -- [9] = 6,   -- 9
    -- [10] = 7,   -- 10
    -- [11] = 8, -- j
    -- [12] = 9, --Q
    -- [13] = 10, --k 

    -- [14] = 13, -- 小王
    -- [15] = 14 -- 大王
}

gameBrnn.Sound = 
{
    brnnBg = "brnnBGM.mp3", --背景音乐
    brnnWin = "BRNNWIN.mp3",--赢钱
    brnnLose = "BRNNLOSE.mp3",---输钱
    brnn_ct_niu_1 = "brnn_ct_niu_1.mp3",
    brnn_ct_niu_2 = "brnn_ct_niu_2.mp3",
    brnn_ct_niu_3 = "brnn_ct_niu_3.mp3",
    brnn_ct_niu_4 = "brnn_ct_niu_4.mp3",
    brnn_ct_niu_5 = "brnn_ct_niu_5.mp3",
    brnn_ct_niu_6 = "brnn_ct_niu_6.mp3",
    brnn_ct_niu_7 = "brnn_ct_niu_7.mp3",
    brnn_ct_niu_8 = "brnn_ct_niu_8.mp3",
    brnn_ct_niu_9 = "brnn_ct_niu_9.mp3",
    brnn_ct_bomebome = "brnn_ct_bomebome.mp3", ---炸弹牛
    brnn_ct_sihuaniu = "brnn_ct_sihuaniu.mp3", ---4花牛
    brnn_ct_niuking = "brnn_ct_niuking.mp3", --5花牛
    brnn_ct_wuxiaoniu = "brnn_ct_wuxiaoniu.mp3",--5小牛
    brnn_ct_niuniu = "brnn_ct_niuniu.mp3", --牛牛
    brnn_ct_none = "brnn_ct_none.mp3", --没牛
    brnn_jetton = "brnn_jetton.mp3" --下注
}