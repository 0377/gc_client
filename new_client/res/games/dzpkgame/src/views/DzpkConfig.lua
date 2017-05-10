
gameDzpk = gameDzpk or {}

-- 游戏筹码配置 --
gameDzpk.CONFIG_NORMAL_COIN = {
    -- 0.1,1,5,10,50,100
    10,100,500,1000,5000
}

-----游戏上庄金币
gameDzpk.BankerCion = 50000

gameDzpk.CardsV = 
{	
	---用下标来取扑克资源名字
	11,12,0,1,2,3,4,5,6,7,8,9,10,10,10,10
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

gameDzpk.Sound = 
{
    dzpkBg = "dzpkBGM.mp3", --背景音乐
    dzpkWin = "DZPKWIN.mp3",--赢钱
    dzpkLose = "DZPKLOSE.mp3",---输钱
    dzpk_ct_niu_1 = "dzpk_ct_niu_1.mp3",
    dzpk_ct_niu_2 = "dzpk_ct_niu_2.mp3",
    dzpk_ct_niu_3 = "dzpk_ct_niu_3.mp3",
    dzpk_ct_niu_4 = "dzpk_ct_niu_4.mp3",
    dzpk_ct_niu_5 = "dzpk_ct_niu_5.mp3",
    dzpk_ct_niu_6 = "dzpk_ct_niu_6.mp3",
    dzpk_ct_niu_7 = "dzpk_ct_niu_7.mp3",
    dzpk_ct_niu_8 = "dzpk_ct_niu_8.mp3",
    dzpk_ct_niu_9 = "dzpk_ct_niu_9.mp3",
    dzpk_ct_bomebome = "dzpk_ct_bomebome.mp3", ---炸弹牛
    dzpk_ct_sihuaniu = "dzpk_ct_sihuaniu.mp3", ---4花牛
    dzpk_ct_niuking = "dzpk_ct_niuking.mp3", --5花牛
    dzpk_ct_niuniu = "dzpk_ct_niuniu.mp3", --牛牛
    dzpk_ct_none = "dzpk_ct_none.mp3", --没牛
    dzpk_jetton = "dzpk_jetton.mp3" --下注
}