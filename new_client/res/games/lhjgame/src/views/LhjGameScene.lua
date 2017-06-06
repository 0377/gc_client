local SubGameBaseScene = requireForGameLuaFile("SubGameBaseScene")
local LhjGameScene = class("LhjGameScene",SubGameBaseScene);
local scheduler = cc.Director:getInstance():getScheduler()

-- 线 - 坐标
local _lineConfig = {
    {2, 2, 2, 2, 2},
    {3, 3, 3, 3, 3},
    {1, 1, 1, 1, 1},
    {3, 2, 1, 2, 3},
    {1, 2, 3, 2, 1},
    {3, 3, 2, 3, 3},
    {1, 1, 2, 1, 1},
    {2, 1, 1, 1, 2},
    {2, 3, 3, 3, 2}
}

local EASE_PAR = 1

local MAX_LINE = 9
local MAX_BET_MULTIPLE = 10
LhjGameScene.LOOP_TIME = 0.1
LhjGameScene.GAME_STATUS = {
    READAY_STATUS = 1, --准备阶段
    ACCLERA_STATUS = 2,--加速阶段
    LOOP_STATUS =3,--滚动循环阶段
    STOP_STATUS = 4,--停止减速阶段
    FLASH_STATUS =5,--中奖线闪烁阶段
    SHOW_RESULT = 6,--显示结果阶段
    SHOUFEN_ANIM_STATUS = 7,--收分动画阶段
}


LhjGameScene.IMG = {}
LhjGameScene.IMG[1] = "game_res/wz_pg.png"--9 --斧头=苹果                   20
LhjGameScene.IMG[2] = "game_res/wz_lm.png"--8 --银枪=橘子                   30
LhjGameScene.IMG[3] = "game_res/wz_xg.png"--7 --大刀=西瓜                   50
LhjGameScene.IMG[4] = "game_res/wz_yt.png"--6 --鲁智深=荔枝                 70
LhjGameScene.IMG[5] = "game_res/wz_xj.png"--5 --林冲=香蕉                   100
LhjGameScene.IMG[6] = "game_res/wz_pt.png"--4 --松江=菠萝                   150
LhjGameScene.IMG[7] = "game_res/wz_bar.png"--3 --替天行道=bar    200
LhjGameScene.IMG[8] = "game_res/wz_qqq.png"--2 --忠义堂=777      500

LhjGameScene.IMG_MOHU1 = {}
LhjGameScene.IMG_MOHU1[1] = "game_res/wz_pg_hu_1.png"--9 --斧头=苹果                   20
LhjGameScene.IMG_MOHU1[2] = "game_res/wz_lm_hu_1.png"--8 --银枪=橘子                   30
LhjGameScene.IMG_MOHU1[3] = "game_res/wz_xg_hu_1.png"--7 --大刀=西瓜                   50
LhjGameScene.IMG_MOHU1[4] = "game_res/wz_yt_hu_1.png"--6 --鲁智深=荔枝                 70
LhjGameScene.IMG_MOHU1[5] = "game_res/wz_xj_hu_1.png"--5 --林冲=香蕉                   100
LhjGameScene.IMG_MOHU1[6] = "game_res/wz_pt_hu_1.png"--4 --松江=菠萝                   150
LhjGameScene.IMG_MOHU1[7] = "game_res/wz_bar_hu_1.png"--3 --替天行道=bar    200
LhjGameScene.IMG_MOHU1[8] = "game_res/wz_qqq_hu_1.png"--2 --忠义堂=777      500

LhjGameScene.IMG_MOHU2 = {}
LhjGameScene.IMG_MOHU2[1] = "game_res/wz_pg_hu_2.png"--9 --斧头=苹果                   20
LhjGameScene.IMG_MOHU2[2] = "game_res/wz_lm_hu_2.png"--8 --银枪=橘子                   30
LhjGameScene.IMG_MOHU2[3] = "game_res/wz_xg_hu_2.png"--7 --大刀=西瓜                   50
LhjGameScene.IMG_MOHU2[4] = "game_res/wz_yt_hu_2.png"--6 --鲁智深=荔枝                 70
LhjGameScene.IMG_MOHU2[5] = "game_res/wz_xj_hu_2.png"--5 --林冲=香蕉                   100
LhjGameScene.IMG_MOHU2[6] = "game_res/wz_pt_hu_2.png"--4 --松江=菠萝                   150
LhjGameScene.IMG_MOHU2[7] = "game_res/wz_bar_hu_2.png"--3 --替天行道=bar    200
LhjGameScene.IMG_MOHU2[8] = "game_res/wz_qqq_hu_2.png"--2 --忠义堂=777      500


LhjGameScene.SOUND = {
    bg = "lhjSound/lhj_bg_music.mp3",
    line = "lhjSound/sound-tiger-line-button.mp3", --选线/按钮
    winline = "lhjSound/lhj_line_sound.mp3", --中奖连线
    start = "lhjSound/sound-tiger-rool-start.mp3",
    shoufen = "lhjSound/lhj_shoufen_sound.mp3",
    getscore =  "lhjSound/lhj_getscore_sound.mp3",
    stop =  "lhjSound/lhj_getscore_sound.mp3",
    bigwincoin =  "lhjSound/lhj_bigwincoin_sound.mp3",


}

local slotma_items = {
    {id = 1, symbol = "苹果",  winingtype ={{number = 3,times = 2},{number = 4,times = 5},{times = 20}}},
    {id = 2, symbol = "橙子",  winingtype ={{number = 3,times = 3},{number = 4,times = 10},{times = 40}}},
    {id = 3, symbol = "西瓜",  winingtype ={{number = 3,times = 5},{number = 4,times = 15},{times = 60}}},
    {id = 4, symbol = "荔枝",  winingtype ={{number = 3,times = 7},{number = 4,times = 20},{times = 100}}},
    {id = 5, symbol = "香蕉",  winingtype ={{number = 3,times = 10},{number = 4,times = 30},{times = 160}}},
    {id = 6, symbol = "菠萝",  winingtype ={{number = 3,times = 15},{number = 4,times = 40},{times = 200}}},
    {id = 7, symbol = "BAR",   winingtype ={{number = 3,times = 20},{number = 4,times = 80},{times = 400}}},
    {id = 8, symbol = "777",   winingtype ={{number = 3,times = 50},{number = 4,times = 200},{times = 1000}}},
}

----初始化要加载的资源
function LhjGameScene.getNeedPreloadResArray()
    -- body
    local  res = {
        CustomHelper.getFullPath("game_res/wz_pg.png"),
        CustomHelper.getFullPath("game_res/wz_lm.png"),
        CustomHelper.getFullPath("game_res/wz_xg.png"),
        CustomHelper.getFullPath("game_res/wz_yt.png"),
        CustomHelper.getFullPath("game_res/wz_xj.png"),
        CustomHelper.getFullPath("game_res/wz_pt.png"),
        CustomHelper.getFullPath("game_res/wz_bar.png"),
        CustomHelper.getFullPath("game_res/wz_qqq.png"),
        CustomHelper.getFullPath("anim/slots_race_pop_middle_gold_01/slots_race_pop_middle_gold_01.ExportJson")
    }
    return res
end
function LhjGameScene:ctor()
    self._isAuto = false --是不是自动模式
    self._isBtnListOpen = false --是否展开右上角按钮列表
    self._currentLine = MAX_LINE --当前线数
    self._currentBetMultiple = 1 --当前底注倍数
    self._isStopLoop = false --是否点击或自动停止滚动

    self._tableResult = nil --最后结算数据
    self.isShowingMarquee  = false
    self._gameStatus = LhjGameScene.GAME_STATUS.READAY_STATUS
    ---初始化数据对象
    self.lhjGameManager = LhjGameManager:getInstance();
    self._clickStartTime = nil
    self._scheduler = nil

    self._isPlayBigWinAnimTime = false
   

    self.fruitTab = self.fruitTab or {} --游戏中水果节点
    self.numAndLine = self.numAndLine or {} --连线
    ---初始化UI
    self:initUI();



    ---初始化自己的信息
    self:showMyInfo()

    ---背景音乐
    MusicAndSoundManager:getInstance():playMusicWithFile(LhjGameScene.SOUND.bg, true)
    self:showMarqueeTip();
    LhjGameScene.super.ctor(self);
end
function LhjGameScene:onEnterTransitionFinish()
    self:isContinueGameConditions()
end
----初始化界面
function LhjGameScene:initUI()
     ---初始化界面
    local CCSLuaNode =  requireForGameLuaFile("LhjGameSceneCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
   
    self.cumulativeScoreTxt = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "cumulative_score_txt"), "ccui.TextAtlas");
    self.bankMoneyTxt = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bank_money_txt"), "ccui.TextAtlas");
    self.moneyTxt = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "money_txt"), "ccui.TextAtlas");
    self.betTxt = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bet_txt"), "ccui.TextAtlas");

    
    for i=1,MAX_LINE do
        --left 亮数字
        local leftNumLight = tolua.cast(CustomHelper.seekNodeByName(self.csNode, string.format("icon%d_left",i)), "ccui.ImageView");
         --left 暗数字
        local leftNumBark = tolua.cast(CustomHelper.seekNodeByName(self.csNode, string.format("icon%d_2_left",i)), "ccui.ImageView");
          --right 亮数字
        local rightNumLight = tolua.cast(CustomHelper.seekNodeByName(self.csNode, string.format("icon%d_right",i)), "ccui.ImageView");
         --right 暗数字
        local rightNumBark = tolua.cast(CustomHelper.seekNodeByName(self.csNode, string.format("icon%d_2_right",i)),"ccui.ImageView");
        local line = tolua.cast(CustomHelper.seekNodeByName(self.csNode, string.format("line_%d",i)), "ccui.ImageView");
        local tab = {
            leftNumLight        = leftNumLight,
            leftNumBark         = leftNumBark,
            rightNumLight       = rightNumLight,
            rightNumBark        = rightNumBark,
            line                = line,
        }
        table.insert(self.numAndLine ,tab)
    end

    self.btnXs = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_xs"), "ccui.Button"); --线数
    self.btnMaxLine = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_max_line"), "ccui.Button"); --满线
    self.btnBet = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_bet"), "ccui.Button"); --底注
    self.btnMaxBet = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_max_bet"), "ccui.Button"); --满注
    self.btnStart = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_start"), "ccui.Button"); --开始
    self.btnCancalAuto = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_cancal_auto"), "ccui.Button"); --取消自动
    self.btnStop = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_stop"), "ccui.Button"); --停止
    self.btnShoufen = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_shoufen"), "ccui.Button"); --停止

       
     self.btnXs:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.began then
           GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            local lineNumTxt = tolua.cast(CustomHelper.seekNodeByName(self.btnXs, "line_num_txt"), "ccui.TextAtlas"); --线数
            local lineNumTxt2 = tolua.cast(CustomHelper.seekNodeByName(self.btnXs, "line_num_txt_2"), "ccui.TextAtlas"); --线数
            --显示下注倍数
            lineNumTxt2:setVisible(true)
            lineNumTxt:setVisible(false)

        elseif eventType == ccui.TouchEventType.moved then
                local lineNumTxt = tolua.cast(CustomHelper.seekNodeByName(self.btnXs, "line_num_txt"), "ccui.TextAtlas"); --线数
                local lineNumTxt2 = tolua.cast(CustomHelper.seekNodeByName(self.btnXs, "line_num_txt_2"), "ccui.TextAtlas"); --线数
                lineNumTxt2:setVisible( sender:isHighlighted())
                lineNumTxt:setVisible(not sender:isHighlighted())
          
     
        elseif eventType == ccui.TouchEventType.ended then
            if self._gameStatus ~= LhjGameScene.GAME_STATUS.READAY_STATUS then
                local lineNumTxt = tolua.cast(CustomHelper.seekNodeByName(self.btnXs, "line_num_txt"), "ccui.TextAtlas"); --线数
                local lineNumTxt2 = tolua.cast(CustomHelper.seekNodeByName(self.btnXs, "line_num_txt_2"), "ccui.TextAtlas"); --线数
                --显示下注倍数
                lineNumTxt2:setVisible(false)
                lineNumTxt:setVisible(true)
                return  
            end
            self:setLineNum(self._currentLine + 1);
            
        elseif eventType == ccui.TouchEventType.canceled then
            local lineNumTxt = tolua.cast(CustomHelper.seekNodeByName(self.btnXs, "line_num_txt"), "ccui.TextAtlas"); --线数
            local lineNumTxt2 = tolua.cast(CustomHelper.seekNodeByName(self.btnXs, "line_num_txt_2"), "ccui.TextAtlas"); --线数
            --显示下注倍数
            lineNumTxt2:setVisible(false)
            lineNumTxt:setVisible(true)
            print("ccui.TouchEventType.canceled")
        end
    end); 




    self.btnMaxLine:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        if self._gameStatus ~= LhjGameScene.GAME_STATUS.READAY_STATUS then return  end
        self:setLineNum(9);
    end) 

    self.btnBet:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            local betNumTxt = tolua.cast(CustomHelper.seekNodeByName(self.btnBet, "bet_num_txt"), "ccui.TextAtlas"); --线数
            local betNumTxt2 = tolua.cast(CustomHelper.seekNodeByName(self.btnBet, "bet_num_txt_2"), "ccui.TextAtlas"); --线数
            --显示下注倍数
            betNumTxt2:setVisible(true)
            betNumTxt:setVisible(false)

        elseif eventType == ccui.TouchEventType.moved then
                local betNumTxt = tolua.cast(CustomHelper.seekNodeByName(self.btnBet, "bet_num_txt"), "ccui.TextAtlas"); --线数
                local betNumTxt2 = tolua.cast(CustomHelper.seekNodeByName(self.btnBet, "bet_num_txt_2"), "ccui.TextAtlas"); --线数
                betNumTxt2:setVisible( sender:isHighlighted())
                betNumTxt:setVisible(not sender:isHighlighted())
          
     
        elseif eventType == ccui.TouchEventType.ended then
            if self._gameStatus ~= LhjGameScene.GAME_STATUS.READAY_STATUS then 
                local betNumTxt = tolua.cast(CustomHelper.seekNodeByName(self.btnBet, "bet_num_txt"), "ccui.TextAtlas"); --线数
                local betNumTxt2 = tolua.cast(CustomHelper.seekNodeByName(self.btnBet, "bet_num_txt_2"), "ccui.TextAtlas"); --线数
                --显示下注倍数
                betNumTxt2:setVisible(false)
                betNumTxt:setVisible(true)
                return 
            end
            self:setBet(self._currentBetMultiple + 1);
        elseif eventType == ccui.TouchEventType.canceled then
            local betNumTxt = tolua.cast(CustomHelper.seekNodeByName(self.btnBet, "bet_num_txt"), "ccui.TextAtlas"); --线数
            local betNumTxt2 = tolua.cast(CustomHelper.seekNodeByName(self.btnBet, "bet_num_txt_2"), "ccui.TextAtlas"); --线数
            --显示下注倍数
            betNumTxt2:setVisible(false)
            betNumTxt:setVisible(true)
            print("ccui.TouchEventType.canceled")
        end
    end); 
    self.btnShoufen:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        if self._gameStatus == LhjGameScene.GAME_STATUS.SHOUFEN_ANIM_STATUS then return end
        if self._winLayout:isVisible() and self._isPlayBigWinAnimTime == false then
            self:showShouFenAnim()
        end
    end) 

    self.btnMaxBet:addClickEventListener(function()
         GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        if self._gameStatus ~= LhjGameScene.GAME_STATUS.READAY_STATUS then return  end
        self:setBet(10);
    end)

    local function btnClick(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            self._clickStartTime = os.time()
            self._scheduler = CustomHelper.performWithDelayGlobal(function (  )
                self._isAuto = true
                self:startNextRound()
            end, 2)
        elseif eventType == ccui.TouchEventType.moved then
            
        elseif eventType == ccui.TouchEventType.ended then
            if not self._clickStartTime then return end
            if self._gameStatus ~= LhjGameScene.GAME_STATUS.READAY_STATUS then return end 
            CustomHelper.unscheduleGlobal(self._scheduler)
            self._scheduler = nil
            if os.time() - self._clickStartTime > 1 then --长按
                self._isAuto = true
            end
            
            self:startNextRound()
        elseif eventType == ccui.TouchEventType.canceled then
           self._clickStartTime = nil
        end
    end 
    self.btnStart:addTouchEventListener(btnClick) 

    self.btnCancalAuto:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        self._isAuto = false
        self:btnVisibleControl()
    end) 
    self.btnStop:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
       
       --只在加速或loop时执行逻辑
        if self._gameStatus == LhjGameScene.GAME_STATUS.ACCLERA_STATUS or self._gameStatus == LhjGameScene.GAME_STATUS.LOOP_STATUS then
             if  self._gameStatus == LhjGameScene.GAME_STATUS.STOP_STATUS then
            --已经减速 和中奖项目闪烁时 return
                return 
            end
             CustomHelper.unscheduleGlobal(self._scheduler)
            self._scheduler = nil
            self:stopLoop(0.5)
        end 
    end)    

    self:setLineNum(self._currentLine)

    --初始化游戏界面的水果节点
   for i=1,5 do
       local list = tolua.cast(CustomHelper.seekNodeByName(self.csNode, string.format("fruits_list_%d",i)), "ccui.Layout")
       table.insert(self.fruitTab,list)
   end
   self:initFruits()

   --右上角按钮
    self.btnsList = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btns_list"), "ccui.Widget");
    self.btnOpenList = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_open_list"), "ccui.Button");
    self.btnOpenList:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self.btnOpenList:setTouchEnabled(false)
        if not self._isBtnListOpen then
            local action = {}
            action[1] = cc.MoveTo:create(LhjGameScene.LOOP_TIME,cc.p(0,0))
            action[2] = cc.CallFunc:create(function (  )
                local icon = tolua.cast(CustomHelper.seekNodeByName(self.btnOpenList, "btn_icon"), "ccui.ImageView");
                icon:setScaleY(-1)
                self.btnOpenList:setTouchEnabled(true)
                self._isBtnListOpen = true
            end)
            self.btnsList:runAction(cc.Sequence:create(action))

        else
            local action = {}
            action[1] = cc.MoveTo:create(LhjGameScene.LOOP_TIME,cc.p(0,488))
            action[2] = cc.CallFunc:create(function (  )
                local icon = tolua.cast(CustomHelper.seekNodeByName(self.btnOpenList, "btn_icon"), "ccui.ImageView");
                icon:setScaleY(1)
                self._isBtnListOpen = false
                self.btnOpenList:setTouchEnabled(true)
            end)
            self.btnsList:runAction( cc.Sequence:create(action))
        end
    end)  

    local btn_exit = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_exit"), "ccui.Button");
    btn_exit:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:exitGame()
    end)  
    local btn_sound = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_sound"), "ccui.Button");

    local function setSoundBtnIcon(  )
        local isOpenForSound =  GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
        local icon = tolua.cast(CustomHelper.seekNodeByName(btn_sound, "btn_icon"), "ccui.ImageView"); 
        if not isOpenForSound then
            icon:loadTexture("game_res/wz_sz_sy_2.png")
        else
            icon:loadTexture("game_res/wz_sz_sy.png")
        end
    end
    setSoundBtnIcon()
    btn_sound:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        local isOpenForSound = not GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
        GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch(isOpenForSound);
        
        if isOpenForSound == true then
            --todo
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        else
            GameManager:getInstance():getMusicAndSoundManager():stopAllSound();
        end
        setSoundBtnIcon()
    end)  
    local btn_help = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_help"), "ccui.Button");
    btn_help:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        local tips = requireForGameLuaFile("LhjGameTips")
        local tipsLayer = tips:create()
        self:addChild(tipsLayer,100)
    end)  
    local btn_music = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_music"), "ccui.Button");

    local function setMusicBtnIcon(  )
        local musicSwitch =  GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
        local icon = tolua.cast(CustomHelper.seekNodeByName(btn_music, "btn_icon"), "ccui.ImageView"); 
        if musicSwitch then
            icon:loadTexture("game_res/wz_sz_yy.png")
            GameManager:getInstance():getMusicAndSoundManager():playMusicWithFile(HallSoundConfig.BgMusic.Hall)
        else
            icon:loadTexture("game_res/wz_sz_yy_2.png")
            GameManager:getInstance():getMusicAndSoundManager():stopMusic()
        end
    end


    btn_music:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        local musicSwitch = not GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
        GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch(musicSwitch)
        setMusicBtnIcon()
    end)  
    setMusicBtnIcon()
    self._winLayout = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "win_layout"), "ccui.Layout");
    self._winLayout:setVisible(false)
    for i,v in ipairs(self.csNode:getChildren()) do
        print(v:getName())
    end


     local function winLayoutClick(sender,eventType)
        if eventType == ccui.TouchEventType.began then
           
        elseif eventType == ccui.TouchEventType.moved then
            
        elseif eventType == ccui.TouchEventType.ended then
            if self._gameStatus == LhjGameScene.GAME_STATUS.SHOUFEN_ANIM_STATUS then return end
            if self._winLayout:isVisible()  and self._isPlayBigWinAnimTime == false then
                self:showShouFenAnim()
            end
        elseif eventType == ccui.TouchEventType.canceled then
        end
    end 

    self._winLayout:addTouchEventListener(winLayoutClick)  


    self._startAnim = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "slots_race_pop_middle_gold_01"),"ccs.Armature")
    self._startAnim:setVisible(false)

    self._btnLagan = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_lagan"), "ccui.Button");
    self._btnLagan:addClickEventListener(function()
        self:startNextRound()
    end)  
    self._btnLagan:setVisible(true)

    if self.marqueeText == nil then
        --todo
        self.marqueeText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "marquee_text"), "ccui.Text");
    end
    self.marqueeText:setString("")
    self.marqueePanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "marquee_layout"), "ccui.Layout");
    self.marqueePanel:setOpacity(0);


    self:setBet(self._currentBetMultiple)
    self._winBetNode = tolua.cast(CustomHelper.seekNodeByName(self._winLayout, "win_bet_node"), "cc.Node");
    local winLight = tolua.cast(CustomHelper.seekNodeByName(self._winBetNode, "win_light"), "cc.Sprite");
    local animation =cc.Animation:create()                                                                           
    for i=1,2 do  
        local frameName = string.format("game_res/jiujiu_lhj_caideng_%d.png",i)                                                     
        local spriteFrame = cc.SpriteFrame:create(frameName,cc.rect(0,0,251,125))         
        animation:addSpriteFrame(spriteFrame)                                                           
    end  
    animation:setDelayPerUnit(0.1)
    winLight:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))


end

--初始化进入游戏时界面中显示的水果
function LhjGameScene:initFruits(  )
    math.randomseed(os.time())
    self:randomItems(0,0)
end

function LhjGameScene:sendMsgStart()
    local lineTab = {}
    for i=1,self._currentLine do
        table.insert(lineTab,i)
    end
    self.lhjGameManager:sendStartGame(self._currentBetMultiple,lineTab)
end

function LhjGameScene:setLineNum(lineNum)

    self._currentLine = lineNum > MAX_LINE and 1 or lineNum

    for i=1,9 do
        assert(self.numAndLine[i])
        self.numAndLine[i].leftNumLight:setVisible(i<=self._currentLine)
        self.numAndLine[i].rightNumLight:setVisible(i<=self._currentLine)
        self.numAndLine[i].line:setVisible(i<=self._currentLine)
        self.numAndLine[i].leftNumBark:setVisible(i>self._currentLine)
        self.numAndLine[i].rightNumBark:setVisible(i>self._currentLine)
    end
    local lineNumTxt = tolua.cast(CustomHelper.seekNodeByName(self.btnXs, "line_num_txt"), "ccui.TextAtlas"); --线数
    local lineNumTxt2 = tolua.cast(CustomHelper.seekNodeByName(self.btnXs, "line_num_txt_2"), "ccui.TextAtlas"); --线数
    --显示下注倍数
   
    lineNumTxt2:setVisible(false)
    lineNumTxt:setVisible(true)
    lineNumTxt:setString(tostring(self._currentLine))
    lineNumTxt2:setString(tostring(self._currentLine))
    self:showBetNum();

end

function LhjGameScene:setBet(multiple)
    self._currentBetMultiple = multiple > MAX_BET_MULTIPLE and 1 or multiple
    local betNumTxt = tolua.cast(CustomHelper.seekNodeByName(self.btnBet, "bet_num_txt"), "ccui.TextAtlas"); --线数
    local betNumTxt2 = tolua.cast(CustomHelper.seekNodeByName(self.btnBet, "bet_num_txt_2"), "ccui.TextAtlas"); --线数
    --显示下注倍数
   
    betNumTxt2:setVisible(false)
    betNumTxt:setVisible(true)
    local dizhu = CustomHelper.moneyShowStyleNone(self._currentBetMultiple * self.lhjGameManager:getDataManager():getDizhuNum()) 
    betNumTxt:setString(tostring(dizhu))
    betNumTxt2:setString(tostring(dizhu))

    local scale = 70 / betNumTxt:getContentSize().width 
    dump(betNumTxt:getContentSize())
    if scale > 1 then scale = 1 end
    betNumTxt:setScale(scale)
    betNumTxt2:setScale(scale)
    self:showBetNum();
end


----退出房间
function LhjGameScene:exitGame(openSecondLayer)
    ---释放资源

    local needLoadResArray = LhjGameScene.getNeedPreloadResArray();
    for i,v in ipairs(needLoadResArray) do
        if string.find(v,".ExportJson") then
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v);
        end
    end

    self.lhjGameManager:sendLeaveGame()
    self.lhjGameManager:sendStandUpAndExitRoomMsg()
    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

    if self._scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)   
        self._scheduler = nil
    end


    self.lhjGameManager:clearLoadedOneGameFiles()

    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager();
    if subGameManager ~= nil then
        subGameManager:onExit();
    end

    SceneController.goHallScene(openSecondLayer);
 
end
--开始下一轮
function LhjGameScene:startNextRound( )
    if not self:isContinueGameConditions() then
        self:alertAlertViewWhenServerMaintain()
        return 
    end
    local function  verificationGold(  )
        local betNum = self._currentLine * self.lhjGameManager:getDataManager():getDizhuNum()* self._currentBetMultiple; --下注金额
        local cancalCallbackFunc = function (  )
            self:exitGame(nil)
        end

        local bankCallbackFunc = function (  )
            local secondLayer = {}
            secondLayer.tag = ViewManager.SECOND_LAYER_TAG.BANK             
            local BankCenterLayer = requireForGameLuaFile("BankCenterLayer")
            secondLayer.parme = BankCenterLayer.ViewType.WithDraw
            local data = {}
            table.insert(data,secondLayer)
            self:exitGame(data)
        end

        local storyCallbackFunc = function (  )
            local secondLayer = {}
            secondLayer.tag = ViewManager.SECOND_LAYER_TAG.STORY
            local data = {}
            table.insert(data,secondLayer)
            self:exitGame(data)
        end


        if CustomHelper.showLackMoneyAlertView(betNum,"金币不足，是否去充值？",cancalCallbackFunc,bankCallbackFunc,storyCallbackFunc,closeCallbackFunc) then
            return false
        else
            return true 
        end

    end
    if not verificationGold() then return end
    self._gameStatus = LhjGameScene.GAME_STATUS.ACCLERA_STATUS
    self:btnVisibleControl()

    --隐藏line 
    local function hideLine()
        for i=1,9 do
            self.numAndLine[i].line:setVisible(false)
        end
    end
    hideLine()
    self._isStopLoop = false
    self:sendMsgStart()
    self:startLoopAnim()
  
    local start = self.lhjGameManager:getDataManager():getMoneyInfo().money
    self.lhjGameManager:getDataManager():deductedBet(self._currentLine*self._currentBetMultiple *self.lhjGameManager:getDataManager():getDizhuNum())
    local endNum = self.lhjGameManager:getDataManager():getMoneyInfo().money
    self:moneyAnimFactory(self.moneyTxt,start ,endNum,6)



    self._startAnim:setVisible(true)
    self._btnLagan:setVisible(false)
    self._startAnim:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
        if _type == ccs.MovementEventType.start then
        elseif _type == ccs.MovementEventType.complete then
           self._startAnim:setVisible(false)
           self._btnLagan:setVisible(true)
        elseif _type == 2 then
        end
    end)
    self._startAnim:getAnimation():play("ani_01")
    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(LhjGameScene.SOUND.start)
end

function LhjGameScene:startLoopAnim(  )
    local function loop( item )
        self._gameStatus = LhjGameScene.GAME_STATUS.LOOP_STATUS
        if self._isStopLoop and  self.lhjGameManager:getDataManager():getGameItemResults() then
            self:stopLoop()
            return 
        end
        local action = {}
        action[1] = cc.MoveBy:create(LhjGameScene.LOOP_TIME,cc.p(0,-312))
        action[2] = cc.CallFunc:create(function (  )
            if self._isStopLoop  and self.lhjGameManager:getDataManager():getGameItemResults() then
                self:stopLoop()
                return
            end
            if item:getPositionY() < 0 then
                --当停止滚动时item继续原先的动画 滚动到不可见区域被移除
               
                item:setPositionY(item:getPositionY() + 624)
                item:setTexture(LhjGameScene.IMG_MOHU2[math.random(1,8)])
                
            end
            --滚动停止时 完成action后不在继续
            item:runAction(cc.Sequence:create(action))
            
        end)
        item:runAction(cc.Sequence:create(action))
    end
  
    --正常滚屏的速度为v = 312/ LOOP_TIME(0.2)
    --加速时间t内从0 加速到v 位移d = 312*3  加速度为v0
    -- d = 1/2 *v0 * t*t    v0*t = v 经过计算加速时间1.2s 加速度1300


    --获得加速过程中不同时间节点的位移
    --av = 加速度 1300
    --t1 总时间 1.2
    --t2 间隔时间 0.2 
    local function getAccelerationMoveDistance( av,t1,t2 )
        local temp = {}
        for i=1,math.ceil(t1/t2) do
           temp[i] = 1/2 *av *(t2*i)*(t2*i) - 1/2 *av *(t2*(i-1))*(t2*(i-1)) 
        end   
        return temp
    end
    local dis = getAccelerationMoveDistance(1300,1.2,0.3)
    local function accelerate(item,index ) --加速
        local action = {}
        action[1] = cc.EaseIn:create(cc.MoveBy:create(1.5,cc.p(0,-312*3)),EASE_PAR + index*2)
        --
        -- action[1] = cc.EaseIn:create(cc.MoveBy:create(1,cc.p(0,-dis[1])),EASE_PAR + index*2)
        -- for i=2,4 do
        --     action[i] = cc.MoveBy:create(0.3,cc.p(0,-dis[i]))
        -- end
             
        action[2] = cc.CallFunc:create(function (  )
            --加速结束的时候 3屏items 去掉最下面的一屏
            if item:getPositionY() < 0 and item:getPositionY() > -312 then
                --当停止滚动时item继续原先的动画 滚动到不可见区域被移除
                item:setPositionY(item:getPositionY() + 624)
                item:setTexture(LhjGameScene.IMG_MOHU2[math.random(1,8)])
                loop(item)
            elseif item:getPositionY() > 0 then
                loop(item)
            elseif item:getPositionY() < -312 then
                item:removeSelf()
            end
        end)
        item:runAction(cc.Sequence:create(action))
    end

    self:randomItems(1,1) 
    self:randomItems(2,1) --在不可见区域加上4页实现加速滚动
    self:randomItems(3,1)
    for i,widget in ipairs(self.fruitTab) do
        local listNode = widget
        for _,item in ipairs(listNode:getChildren()) do
           accelerate(item,i);
        end
    end
    if  self._scheduler then 
        CustomHelper.unscheduleGlobal(self._scheduler)
        self._scheduler = nil
    end
    self._scheduler = CustomHelper.performWithDelayGlobal(function (  )
        self:stopLoop()
    end, 3)
end




function LhjGameScene:stopLoop( time)
    self._isStopLoop = true
    if not self.lhjGameManager:getDataManager():getGameItemResults() then return end
    if  self._gameStatus == LhjGameScene.GAME_STATUS.STOP_STATUS then
        --加速时不停止 加速完成后停止
        return 
    end 

    self._gameStatus = LhjGameScene.GAME_STATUS.STOP_STATUS
    if  self._scheduler then 
        CustomHelper.unscheduleGlobal(self._scheduler)
        self._scheduler = nil
    end
    self:btnVisibleControl()
    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(LhjGameScene.SOUND.stop)
    if time == nil then time = 1 end
    
    self._tableResult = {}
    for index,widget in ipairs(self.fruitTab) do
        self._tableResult[index] = {}
        local listNode = widget
        --remove 不在正中正在显示的item 
        local highItemY = 0
        for _,item in ipairs(listNode:getChildren()) do
            local posY =  item:getPositionY()
            if posY < 0 and posY > 312 then
               item:removeSelf()
            else
                highItemY =  posY > highItemY and posY or highItemY
            end
        end
        --在本列最顶端加入5行随机item
        local posX = 50
        highItemY = highItemY + 104
        local row = 5 
        if time < 1 then row = 2 end


        for i=1,row do
            local fruitId = math.random(1,8)
            local img = nil
            if i <=3 then
                img = cc.Sprite:create(LhjGameScene.IMG_MOHU2[fruitId])
            else
                img = cc.Sprite:create(LhjGameScene.IMG_MOHU1[fruitId])
            end 
            img:setPosition(cc.p(posX,highItemY))
            highItemY = highItemY + 104
            listNode:add(img)
        end

           --在本列最顶端加入服务器结果
        
        for i=1,3 do
            local fruitId = self.lhjGameManager:getDataManager():getGameItemResults()[i][index]
            local img = cc.Sprite:create(LhjGameScene.IMG[fruitId])
            img:setPosition(cc.p(posX,highItemY))
            highItemY = highItemY + 104
            listNode:add(img)

            self._tableResult[index][i] = img
        end

        highItemY = highItemY - 104
        for _,item in ipairs(listNode:getChildren()) do
            item:stopAllActions()
            local action = {}
            action[1] = cc.EaseOut:create(cc.MoveBy:create(time,cc.p(0,312-highItemY - 52 )),EASE_PAR *4 - index/2)
            action[2] = cc.CallFunc:create(function (  )
                if item:getPositionY() < 0 then
                    item:removeSelf()
                end
            end)
            item:runAction(cc.Sequence:create(action))
        end

       
    end
    --2秒后显示结果
    if  self._scheduler then 
        CustomHelper.unscheduleGlobal(self._scheduler)
        self._scheduler = nil
    end
    self._scheduler = CustomHelper.performWithDelayGlobal(function (  )
        self:showResult()
    end, time)
end

--结果 中奖动画
function LhjGameScene:showResult( )

    local line = self.lhjGameManager:getDataManager():getWinLines()
    if not line or #line == 0 then
        --没有中奖 转下一流程
        self._gameStatus = LhjGameScene.GAME_STATUS.READAY_STATUS
        self:btnVisibleControl()
        if self._isAuto then
            self:startNextRound()
        end
        return 
    end
    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(LhjGameScene.SOUND.win)
    local function flashLight( index )
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(LhjGameScene.SOUND.winline)
        if index > #line then
           index = 1
        end 
        local flashLine = line[index].lineid --中奖线编号
        local itemid = line[index].itemid --中奖物品id
        local action = {}
        action[1] = cc.Blink:create(1, 5)
        action[2] = cc.CallFunc:create(function (  )
            index = index + 1
            flashLight(index)
        end)
        local lineImg = self.numAndLine[flashLine].line
        lineImg:runAction(cc.Sequence:create(action))
        local  num = 0
        for col =1,5 do --列
            for row=1,3 do --行
                local img = self._tableResult[col][row]
               
                if row ~= _lineConfig[flashLine][col] then
                    img:setColor(cc.c3b(88 , 88, 88))
                else
                    --中奖需要在一条线上连续3个相同item 所以中奖的item在线上的前一个或后一个必定是相同的
                    local function isContinuityItem()
                        local function firstOne()
                            if col == 1 then 
                                return false 
                            else 
                               return  self.lhjGameManager:getDataManager():getGameItemResults()[_lineConfig[flashLine][col -1]][col -1] == itemid
                            end
                        end

                        local function lastOne()
                            if col == 5 then 
                                return false 
                            else 
                               return  self.lhjGameManager:getDataManager():getGameItemResults()[_lineConfig[flashLine][col + 1]][col + 1] == itemid
                            end
                        end


                        return firstOne() or lastOne()
                    end

                    if self.lhjGameManager:getDataManager():getGameItemResults()[row][col] == itemid and isContinuityItem() then
                        img:setColor(cc.c3b(255 , 255, 255))
                        local action = cc.Blink:create(1, 5)
                        img:runAction(action)
                    else
                        img:setColor(cc.c3b(88 , 88, 88))
                    end
                end
            end
        end
    end
    self._gameStatus = LhjGameScene.GAME_STATUS.FLASH_STATUS
    self:btnVisibleControl()
    flashLight(1)



    if  self._scheduler then 
        CustomHelper.unscheduleGlobal(self._scheduler)
        self._scheduler = nil
    end
    self._scheduler = CustomHelper.performWithDelayGlobal(function (  )
            self:showResultSettlement()
        end, 1)


     
end

--中奖线 item 闪烁动画 在 下一轮开始前 回复正常
function LhjGameScene:viewNormal(  )
        -- 界面动画停止 回复到正常状态
    local line = self.lhjGameManager:getDataManager():getWinLines()
    for i,v in ipairs(line) do
        local flashLine = v.lineid --中奖线编号
        local lineImg = self.numAndLine[flashLine].line
        lineImg:setVisible(false)
        lineImg:setOpacity(255)
        lineImg:stopAllActions()
    end
    for col =1,5 do --列
        for row=1,3 do --行
            local img = self._tableResult[col][row]
            img:stopAllActions()
            img:setColor(cc.c3b(255,255,255))
            img:setOpacity(255)
            img:setVisible(true)
        end
    end
end


function LhjGameScene:showShouFenAnim(  )
    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(LhjGameScene.SOUND.shoufen)
    self._gameStatus = LhjGameScene.GAME_STATUS.SHOUFEN_ANIM_STATUS
    self:btnVisibleControl()

    local node =  tolua.cast(CustomHelper.seekNodeByName(self._winLayout, "slots_race_pop_middle_gold_01"), "ccs.Armature"); 
    local node =  tolua.cast(CustomHelper.seekNodeByName(self._winLayout, "slots_race_pop_middle_gold_01"), "ccs.Armature")
    node:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
        if _type == ccs.MovementEventType.start then
        elseif _type == ccs.MovementEventType.complete then
            self._winLayout:setVisible(false)
            self:viewNormal()
            self._gameStatus = LhjGameScene.GAME_STATUS.READAY_STATUS
            self:btnVisibleControl()
            if self._isAuto then
                self:startNextRound()
            end
        elseif _type == 2 then
        end
    end)
    local winBets = self.lhjGameManager:getDataManager():getWinBets()
    if winBets >= 30 then 
        node:getAnimation():play("large_03_1")
    else
        node:getAnimation():play("large_03")
    end
    self:moneyAnim()
    local smallWinNumTxt =  tolua.cast(CustomHelper.seekNodeByName(self._winLayout, "small_win_num_txt"), "ccui.TextAtlas")
    local shuishouTxt =  tolua.cast(CustomHelper.seekNodeByName(self._winLayout, "shuishou_txt"), "ccui.Text")
    local buttonPosY = self.moneyTxt:getPositionY()
    smallWinNumTxt:setPositionY(100)
    shuishouTxt:setPositionY(60)
    smallWinNumTxt:setVisible(true)
    shuishouTxt:setVisible(true)


    local function wordAnim( node )
        local action = {}
        action[1] = cc.MoveBy:create(0.8,cc.p(0,50))
        action[2] = cc.CallFunc:create(function (  )
            node:setVisible(false)
        end)
        node:runAction(cc.Sequence:create(action))
    end
    wordAnim( smallWinNumTxt )
    wordAnim( shuishouTxt )
end

--显示结算界面
function LhjGameScene:showResultSettlement()
    
    self._gameStatus = LhjGameScene.GAME_STATUS.SHOW_RESULT
    self:btnVisibleControl()
    self._winLayout:setVisible(true)
    local winNumTxt =  tolua.cast(CustomHelper.seekNodeByName(self._winLayout, "win_num_txt"), "ccui.TextAtlas");
    winNumTxt:setString(CustomHelper.moneyShowStyleNone(self.lhjGameManager:getDataManager():getWinMoney()))
    local smallWinNumTxt =  tolua.cast(CustomHelper.seekNodeByName(self._winLayout, "small_win_num_txt"), "ccui.TextAtlas")
    local shuishouTxt =  tolua.cast(CustomHelper.seekNodeByName(self._winLayout, "shuishou_txt"), "ccui.Text")
    smallWinNumTxt:setString(string.format("/%s",CustomHelper.moneyShowStyleNone(self.lhjGameManager:getDataManager():getWinMoney() - self.lhjGameManager:getDataManager():getSystemTax()))) -- "/"做"+"处理
    shuishouTxt:setString(string.format("税收:%s",CustomHelper.moneyShowStyleNone(self.lhjGameManager:getDataManager():getSystemTax())))
    smallWinNumTxt:setVisible(false)
    shuishouTxt:setVisible(false)
    --anim

    local winWordImg = tolua.cast(CustomHelper.seekNodeByName(self._winBetNode, "win_word_img"), "ccui.ImageView");
    local winBetTxt = tolua.cast(CustomHelper.seekNodeByName(self._winBetNode, "win_bet_txt"), "ccui.TextAtlas");

    local winBets = self.lhjGameManager:getDataManager():getWinBets()
    local node =  tolua.cast(CustomHelper.seekNodeByName(self._winLayout, "slots_race_pop_middle_gold_01"), "ccs.Armature"); 
    node:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
        if _type == ccs.MovementEventType.start then
        elseif _type == ccs.MovementEventType.complete then
            if id == "large_04" then
                self._isPlayBigWinAnimTime = false
                node:getAnimation():play("large_01_1")
            elseif id == "large_01_1" then
                 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(LhjGameScene.SOUND.getscore)
                node:getAnimation():play("large_02_1",-1,0)
            elseif id == "large_02_1" then
                self:showShouFenAnim()
            elseif id ==  "large_01" then
                node:getAnimation():play("large_02",-1,0)
            elseif id == "large_02" then
                self:showShouFenAnim()
            end
        elseif _type == 2 then
        end
    end)



    if winBets >= 30 then 
        winWordImg:loadTexture("game_res/jiujiu_lhj_bigwin.png")
       
        self._isPlayBigWinAnimTime = true
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(LhjGameScene.SOUND.bigwincoin)
        node:getAnimation():play("large_04")
    else
        winWordImg:loadTexture("game_res/jiujiu_lhj_win.png")
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(LhjGameScene.SOUND.getscore)
        node:getAnimation():play("large_01")
    end
    winBetTxt:setString(winBets)




   -- self._winLayout:getChildByName("slots_race_pop_middle_gold_01")
    
end




function LhjGameScene:randomItems(page,degree)
    for i,v in ipairs(self.fruitTab) do
        local listNode = v
        local posX = 50
        local startY = 52 + 312*page
        for i=1,3 do
            local fruitId = math.random(1,8)
            local img = nil
            if degree and degree == 1 then
                img =cc.Sprite:create(LhjGameScene.IMG_MOHU1[fruitId])
            else
                img =cc.Sprite:create(LhjGameScene.IMG[fruitId])
            end
            img:setPosition(cc.p(posX,startY))
            startY = startY + 104
            listNode:add(img)
        end
    end
end


--所以按钮通过状态机控制是否可见
function LhjGameScene:btnVisibleControl( )
    -- self._btnLagan:setTouchEnabled(self._gameStatus == LhjGameScene.GAME_STATUS.READAY_STATUS)
    if self._isAuto then
        self.btnCancalAuto:setVisible(true)
        self.btnStart:setVisible(false)
        self.btnStop:setVisible(false)
        self.btnShoufen:setVisible(false) 
        
    else
        self.btnCancalAuto:setVisible(false)
        self.btnStart:setVisible(self._gameStatus == LhjGameScene.GAME_STATUS.READAY_STATUS)
        self.btnStop:setVisible(self._gameStatus == LhjGameScene.GAME_STATUS.FLASH_STATUS or self._gameStatus == LhjGameScene.GAME_STATUS.ACCLERA_STATUS or self._gameStatus == LhjGameScene.GAME_STATUS.LOOP_STATUS or self._gameStatus == LhjGameScene.GAME_STATUS.STOP_STATUS)
        self.btnShoufen:setVisible(self._gameStatus == LhjGameScene.GAME_STATUS.SHOW_RESULT or self._gameStatus == LhjGameScene.GAME_STATUS.SHOUFEN_ANIM_STATUS)  
        self._btnLagan:setTouchEnabled(self._gameStatus == LhjGameScene.GAME_STATUS.READAY_STATUS)
    end
end

--数字变化动画 工厂函数
function LhjGameScene:moneyAnimFactory(node,start ,endNum,charWidth)
    local off = math.floor((endNum -start) / 8)
    local action = {}
    local index = 1
    for i=1,7 do
        action[index] = cc.CallFunc:create(function ()
            start = start + off
            if off < 0 then
                if start < endNum then start = endNum end
            else
                if start > endNum then start = endNum end
            end
            node:setString(CustomHelper.moneyShowStyleNone(start)) 
            self:stringTxtAdaptation(node,charWidth or 6 )
        end)
        index = index + 1
        action[index] = cc.DelayTime:create(0.1)
        index = index + 1
    end
    action[index] = cc.CallFunc:create(function ()
            if start > endNum then start = endNum end
            node:setString(CustomHelper.moneyShowStyleNone(endNum)) 
        end)
    node:runAction(cc.Sequence:create(action))
end



----加钱动画
function LhjGameScene:moneyAnim()
    local startMoney = self.lhjGameManager:getDataManager():getMoneyInfo().money
    local startAccumulative = self.lhjGameManager:getDataManager():getAccumulative()
    self.lhjGameManager:getDataManager():settlement()
    local endMoney = self.lhjGameManager:getDataManager():getMoneyInfo().money
    local endAccumulative = self.lhjGameManager:getDataManager():getAccumulative()

    -- 0.8s 完成动画 变化8次
  
    self:moneyAnimFactory(self.cumulativeScoreTxt,startAccumulative ,endAccumulative,8)
 
    self:moneyAnimFactory(self.moneyTxt,startMoney ,endMoney,6)
end


----更新自己的money 动画
function LhjGameScene:updateMyInfo()
    self:showMyInfo()
end

----自己的信息
function LhjGameScene:showMyInfo()
   
    self.cumulativeScoreTxt:setString(CustomHelper.moneyShowStyleNone(self.lhjGameManager:getDataManager():getAccumulative())) --累计积分
    self:stringTxtAdaptation( self.cumulativeScoreTxt,8 )
    self.bankMoneyTxt:setString(CustomHelper.moneyShowStyleNone(self.lhjGameManager:getDataManager():getMoneyInfo().bank))
    self:stringTxtAdaptation( self.bankMoneyTxt,6 )
    self.moneyTxt:setString(CustomHelper.moneyShowStyleNone(self.lhjGameManager:getDataManager():getMoneyInfo().money))
    self:stringTxtAdaptation( self.moneyTxt,6 )
end

--界面中显示数字的宽度适配
--txt node
-- charWidth 几个字符宽
function LhjGameScene:stringTxtAdaptation( txt,charWidth )
    if txt:getContentSize().width > 24 * charWidth then
        txt:setScale(24 * charWidth / txt:getContentSize().width)
    end
end

--显示下注金额
function LhjGameScene:showBetNum(  )

    local betNum = self._currentLine * self.lhjGameManager:getDataManager():getDizhuNum()* self._currentBetMultiple
    self.betTxt:setString(CustomHelper.moneyShowStyleNone(betNum))
    self:stringTxtAdaptation( self.betTxt,6 )
end



---取一个数整数
function LhjGameScene:getIntPart(x)
    if x <= 0 then
       return math.ceil(x);
    end

    if math.ceil(x) == x then
       x = math.ceil(x);
    else
       x = math.ceil(x) - 1;
    end
    return x;
end

--去充值界面
function LhjGameScene:jumpToHallScene()
    self:exitGame()
end

---注册消息
function LhjGameScene:registerNotification()
    self:addOneTCPMsgListener(LhjGameManager.MsgName.CS_Slotma_Start,{LhjGameManager.MsgName.SC_Slotma_Start},3)
    self:addOneTCPMsgListener(LhjGameManager.MsgName.SC_Slotma_Start)
    self:addOneTCPMsgListener(LhjGameManager.MsgName.SC_SimpleRespons)
   

     local marqueeShowListener =  cc.EventListenerCustom:create(HallMsgManager.kNotifyName_NeedShowMarqueeInfo,function(event) 
       self:showMarqueeTip()
    end);
    self.super.registerNotification(self);
    -----
end


---重新连接成功
function LhjGameScene:callbackWhenReloginAndGetPlayerInfoFinished(event)
    -- body
    print("重新连接成功")
    LhjGameScene.super.callbackWhenReloginAndGetPlayerInfoFinished(self,event);
    if self._scheduler then

        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)   
        self._scheduler = nil
    end
    self.lhjGameManager:clearLoadedOneGameFiles()
    local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
    local gameTypeID = roomInfo[HallGameConfig.GameIDKey]
    local roomID = roomInfo[HallGameConfig.SecondRoomIDKey]

    CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("entering_gamescene_tip"));
    GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterOneGameMsg(gameTypeID,roomID);
end


----收到服务器返回的失败的通知，如果登录失败，密码错误
function LhjGameScene:receiveServerResponseErrorEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"]
    LhjGameScene.super.receiveServerResponseErrorEvent(self,event);
end

function LhjGameScene:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == LhjGameManager.MsgName.SC_Slotma_Start then --成功收到demo命令
        -- self:startLoopAnim()
       
    elseif msgName == LhjGameManager.MsgName.SC_SimpleRespons then 
    -- SLOTMA_TYPE_SUCESS                  = 0;                                //成功
    -- SLOTMA_TYPE_ERRORID                 = 1;                                //chairid错误
    -- SLOTMA_TYPE_NOMONEY                 = 2;                                //金钱不足
    -- SLOTMA_TYPE_LINERROR                = 3;                                //线型错误
    -- SLOTMA_TYPE_NOLINE    
        if userInfo.status == 2 then
            CustomHelper.showAlertView("金币不足，请重新进入游戏",false,true,nil, function(tipLayer)
                self:exitGame()
            end)
        elseif userInfo.status == 3 then
            CustomHelper.showAlertView("线型错误,请重新进入游戏",false,true,nil, function(tipLayer)
                self:exitGame()
            end)
        end
    elseif msgName == HallMsgManager.MsgName.SC_GameMaintain then
        --todo
        if self._gameStatus == LhjGameScene.GAME_STATUS.READAY_STATUS then
            if self:isContinueGameConditions() == false then
                --todo
                self:alertAlertViewWhenServerMaintain()
            end
        end
        return;
    end
    LhjGameScene.super.receiveServerResponseSuccessEvent(self,event)
end


--显示跑马灯动画
function LhjGameScene:showMarqueeTip()
    local marqueeInfo = GameManager:getInstance():getHallManager():getHallDataManager():getNextNeedShowMarqueeInfo();
    if self.isShowingMarquee == true or marqueeInfo == nil then
        --todo
        return;
    end
    local marqueeTipStr = marqueeInfo.content;
    marqueeTipStr = CustomHelper.decodeURI(marqueeTipStr)
    self.isShowingMarquee = true
    if marqueeTipStr == nil then
        --todo
        return;
    end

    -- dump(self.marqueeText, "self.marqueeText", nesting)
    if marqueeTipStr then
        --todo
        self.marqueePanel:runAction(
            cc.Sequence:create(
                cc.FadeIn:create(0.5),
                cc.CallFunc:create(
                    function()
                        self.marqueeText:setString(marqueeTipStr);
                        local clipperWidth = self.marqueeText:getParent():getContentSize().width
                        local marqueeTextWidth = self.marqueeText:getContentSize().width
                        local needMoveWidth = marqueeTextWidth + clipperWidth;
                        self.marqueeText:setPosition(cc.p(clipperWidth,self.marqueeText:getPositionY()));
                        self.marqueeText:stopAllActions();
                        local speed = 80.0;
                        local time = needMoveWidth/speed;
                        local seq = cc.Sequence:create(
                            cc.MoveTo:create(time,cc.p(-marqueeTextWidth,self.marqueeText:getPositionY())),
                            cc.CallFunc:create(function()
                                GameManager:getInstance():getHallManager():getHallDataManager():callbackWhenOneMarqueeShowFinished(marqueeInfo)
                                local marqueeInfo = GameManager:getInstance():getHallManager():getHallDataManager():getNextNeedShowMarqueeInfo();
                                dump(marqueeInfo, "marqueeInfo", nesting)
                                if marqueeInfo == nil then
                                    --todo
                                    self.marqueePanel:runAction(cc.FadeOut:create(0.5))
                                end
                                self.isShowingMarquee = false
                            end)
                            );
                        self.marqueeText:runAction(seq) 
                    end
                )
            )
        )   

    end
end



return LhjGameScene