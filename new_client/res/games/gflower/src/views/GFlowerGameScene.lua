--local GFlowerGameManager = import("..controller.GFlowerGameManager");
local GFlowerConfig = requireForGameLuaFile("GFlowerConfig")
local GFlowerPoker = requireForGameLuaFile("GFlowerPoker")
local GFlowerSound = requireForGameLuaFile("GFlowerSound")

local SubGameBaseScene = requireForGameLuaFile("SubGameBaseScene");
--CustomHelper.customrequireForGameLuaFileLuaFile(file)
local GFlowerGameScene = class("GFlowerGameScene",SubGameBaseScene);

-- 计时 
local scheduler = cc.Director:getInstance():getScheduler()

-- -- 比牌相关 参数
local GF_COMPARE_ANI_TAG = 101
local GF_UP_RES_ANI = 102
local GF_DOWN_RES_ANI = 103

local GF_ADD_ZORDER = 30

-- 比牌界面层级 
local Compare_ZOrder = 30


function GFlowerGameScene.getNeedPreloadResArray()
    -- body
    local  res = {
        CustomHelper.getFullPath("anim/bb_zjh_win_eff/bb_zjh_win_eff.ExportJson"),
        CustomHelper.getFullPath("anim/zhajinhua_shouhuo_01/zhajinhua_shouhuo_01.ExportJson"),
        CustomHelper.getFullPath("anim/zhajinhua_supervisor/zhajinhua_supervisor.ExportJson"),
        CustomHelper.getFullPath("anim/zjh_pxdh_eff/zjh_pxdh_eff.ExportJson"),
        CustomHelper.getFullPath("anim/zjh_vs_eff/zjh_vs_eff.ExportJson"),
        CustomHelper.getFullPath("anim/zjh_vs_xb_eff/zjh_vs_xb_eff.ExportJson"),
        CustomHelper.getFullPath("anim/zjh_paixin_eff/zjh_paixin_eff.ExportJson"),
        CustomHelper.getFullPath("anim/bb_zjh_fanpai/bb_zjh_fanpai.ExportJson"),
        CustomHelper.getFullPath("anim/zjh_fanpai_eff/zjh_fanpai_eff.ExportJson"),
        CustomHelper.getFullPath("anim/dkj_fanpai_eff/dkj_fanpai_eff.ExportJson"),
    }
    return res
end
--请求失败通知，网络连接状态变化
--单列获取
function GFlowerGameScene:getInstance(isNewSelf)
    
    if isNewSelf == true then
        GFlowerGameScene.instance = nil
    end

    if GFlowerGameScene.instance == nil then
        --todo
        GFlowerGameScene.instance = GFlowerGameScene:create();
    end

    return GFlowerGameScene.instance;
end

--退出到主场景函数
function GFlowerGameScene:returnToHallScene(...)
    if self.isReturnToHallScene == false then
        self:removeScheduler()

        self._logic:InitData()
        self._logic._gameScene = nil

        self._menuOpen = true
        self:MenuControl(not self._menuOpen)

        GFlowerGameManager.instance = nil;
        GFlowerGameScene.instance = nil
    
        local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager();
        subGameManager:onExit();
        SceneController.goHallScene()
        self.isReturnToHallScene = true
    end
    --print("-----------------------------------------------------------------------------------------清除单列")
end

---重新连接成功
function GFlowerGameScene:callbackWhenReloginAndGetPlayerInfoFinished()
    GFlowerGameScene:getInstance().super.callbackWhenReloginAndGetPlayerInfoFinished(self,event);
    --print("+++++++++++++程序没关闭的情况重连+++++++++++++重新连接成功")
    GFlowerGameManager:getInstance():sendMsgReconnectionPlay()
    if self._logic.room_state ~= GFlowerConfig.ROOM_STATE.PLAY then
        CustomHelper.showAlertView(
                "上局已经结束, 请重新进入!!!",
                false,
                true,
                nil,
            function(tipLayer)
                GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                --self:returnToHallScene()
            end)
        return;
    else
        CustomHelper.showAlertView(
                "请重新进入房间!!!",
                false,
                true,
            function(tipLayer)
                -- 玩家断网 又来 网的情况 直接给玩家弃牌了 退出房间
                local player = self._logic:getGFPlayerByClientId(GFlowerConfig.CHAIR_SELF)
                if player:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK
                or player:getGameState() == GFlowerConfig.PLAYER_STATUS.CONTROL then
                    GFlowerGameManager:getInstance():send_CS_ZhaJinHuaGiveUp()
                end
                GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                --self:returnToHallScene();
            end,
            function(tipLayer)
                local player = self._logic:getGFPlayerByClientId(GFlowerConfig.CHAIR_SELF)
                if player:getGameState()  == GFlowerConfig.PLAYER_STATUS.LOOK
                or player:getGameState()  == GFlowerConfig.PLAYER_STATUS.CONTROL then
                    GFlowerGameManager:getInstance():send_CS_ZhaJinHuaGiveUp()
                end
                GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                --self:returnToHallScene();
        end)
    end
end

--服务器维护关闭
function GFlowerGameScene:On_serverStop()
    
    CustomHelper.showAlertView(
                "服务器关闭，请退出游戏!!!",
                false,
                true,
            function(tipLayer)
                GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                --self:returnToHallScene();
            end,
            function(tipLayer)
                GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                --self:returnToHallScene();
        end)
end


--重连后游戏结束 就退出房间
function GFlowerGameScene:exitRoom()
    --GFlowerGameScene.instance = nil
    print("GFlowerGameScene:exitRoom ............................")
    GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
    self:returnToHallScene()
end
--请求失败通知，网络连接状态变化
function GFlowerGameScene:callbackWhenConnectionStatusChange(event)
    GFlowerGameScene.super.callbackWhenConnectionStatusChange(self,event);
    --print("++++++++++++++++++++++++++网络断开1111")
end

--初始化场景
function GFlowerGameScene:ctor()

    -- 调用父类
    GFlowerGameScene.super.ctor(self);

    self.rootPath = GFlowerGameManager:getInstance():getPackageRootPath();
    self.csbRootPath = "res/"..self.rootPath.."res/csb/"
    local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("GameZJH.csb");
    self.m_widget = cc.CSLoader:createNode(csNodePath);
    self.csNode = self.m_widget
    self:addChild(self.csNode);

    -- 初始化逻辑类
    self._logic = GFlowerGameManager:getInstance():getDataManager()
    self._logic:setGFlowerSceneObj(self);


    -- 每个玩家只有一个操作倒计时动画 在进入场景时创建
    self._daojishius = {}

    -- 初始化菜单 --
    self:InitMenuUI()

    -- 玩家信息初始化 --
    self:InitPlayerUi()

    -- 下排操作按钮 --
    self:InitPlayBtn();

    -- 其他界面 --
    self:InitOtherUi();

    -- 手牌 --
    self:CardUiInit()

    -- 音效管理 --
    self:SoundInit()

    -- 结算倒计时
    self.ready_timeNum = 0
    self.countDown     = 0

    -- 跟到底延迟计时
    self.genDaoDiDelay = 0

    -- 是否已经往大厅跳转
    self.isReturnToHallScene = false

    -- 播放跑马灯
    self:showMarqueeTip()
end

-- 音效 --
function GFlowerGameScene:SoundInit()
    self._soundMgr = GFlowerSound.new()
    local soundOpen = false
    local musicOpen = false
    if GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch() == true then
        musicOpen = true
    end
     if GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch() == true then
        soundOpen = true
    end

    self._soundMgr:setSound(soundOpen)
    self._soundMgr:setMusic(musicOpen)
    if musicOpen == true then
        self.button_Music:loadTextureNormal(GFlowerConfig.BTN_IMG.MUSIC_ON_N)
        self.button_Music:loadTexturePressed(GFlowerConfig.BTN_IMG.MUSIC_ON_P)
        self.button_Music:loadTextureDisabled(GFlowerConfig.BTN_IMG.MUSIC_ON_P)
        self._soundMgr:PlayBgm(1)
    else
        self.button_Music:loadTextureNormal(GFlowerConfig.BTN_IMG.MUSIC_OFF_N)
        self.button_Music:loadTexturePressed(GFlowerConfig.BTN_IMG.MUSIC_OFF_P)
        self.button_Music:loadTextureDisabled(GFlowerConfig.BTN_IMG.MUSIC_OFF_P)
    end

    if soundOpen == true then
        self.button_Sound:loadTextureNormal(GFlowerConfig.BTN_IMG.SOUND_ON_N)
        self.button_Sound:loadTexturePressed(GFlowerConfig.BTN_IMG.SOUND_ON_P)
        self.button_Sound:loadTextureDisabled(GFlowerConfig.BTN_IMG.SOUND_ON_P)
    else
        self.button_Sound:loadTextureNormal(GFlowerConfig.BTN_IMG.SOUND_OFF_N)
        self.button_Sound:loadTexturePressed(GFlowerConfig.BTN_IMG.SOUND_OFF_P)
        self.button_Sound:loadTextureDisabled(GFlowerConfig.BTN_IMG.SOUND_OFF_P)
    end
end

---倒计时刷新 GFlowerConfig.READY_TIME
function GFlowerGameScene:_onInterval_StandUp()
    
    --print("--------------------------------------onEnter"..self._StandUp)
    if self._StandUp <= -1 then
        if self._scheduler ~= nil then
            self:removeScheduler()
        end

        if self._logic.StandUp then
            CustomHelper.showAlertView(
                    "获取房间状态失败，请回到大厅重新进入!!!",
                    false,
                    true,
                function(tipLayer)
                    GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                    --self:returnToHallScene();
                end,
                function(tipLayer)
                    GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                    --self:returnToHallScene();
            end)
            return
        --else
            --print("-----------------------------------------------获取状态有返回")
        end
    end
    self._StandUp = self._StandUp - 1
end

function GFlowerGameScene:check_StandUp()
-- 发送 send_CS_ZhaJinHuaGetPlayerStatus 3秒后没返回 说明进入桌子失败 退出场景
    self:removeScheduler()
    self._StandUp = 3
    self:_onInterval_StandUp()
    self._scheduler = scheduler:scheduleScriptFunc(function(dt)
                self:_onInterval_StandUp()
                end, 1, false);
end

function GFlowerGameScene:onEnter()
    --print("-------------------------------------------------------------------------------------------onEnter")

    self.isReturnToHallScene = false
    ---判断是否是重连进来的
    local gameingInfoTable = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
    if gameingInfoTable == nil then
        -- 获取房间内玩家状态 再坐下
        print("GFlowerGameScene:onEnter ...............................................................")
        GFlowerGameManager:getInstance():send_CS_ZhaJinHuaGetPlayerStatus()
         --print("玩家正常进入--------------------------")
    else
        GFlowerGameManager:getInstance():sendMsgReconnectionPlay()
        GFlowerGameManager:getInstance():sendMsgZhaJinHuaGetSitDown()
        --print("玩家重连进入--------------------------")
    end

    -- 初始化所有按钮 不可点击 --
    self:gfInitMeBtn(false)

    -- 荷官动画 不重复加载
    if self._aniGirl == nil then
        --print("------------------------------------------------荷官动画1")
        self._aniGirl = ccs.Armature:create("zhajinhua_supervisor")
        self._aniGirl:setPosition(95, 80)
        self._aniGirl:setAnchorPoint(0.5, 0.5)
        self._aniGirl:setScale(0.8)
        self._aniGirl:getAnimation():play("stay")
        self.m_widget:getChildByName("panel_girl"):addChild(self._aniGirl)
    end
end

function GFlowerGameScene:onExit()
    --self._sound:Clear()
        
    local loadAramtureResTab = GFlowerGameScene.getNeedPreloadResArray()
    for i, res in ipairs(loadAramtureResTab) do
        if res ~= "" then
            if string.find(res,".ExportJson") then
                ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(res);
            end
        end
    end
    GFlowerGameScene.instance = nil
    self:removeScheduler()
end

function GFlowerGameScene:removeScheduler()
    if self._scheduler ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)   
        self._scheduler = nil
    end
end

-- 筹码随机位置生成 --
local function GetCoinRandPos()
    local _pos = {}
    local p_x = math.random(460, 820)
    local p_y = math.random(350, 460)
    _pos.x = p_x
    _pos.y = p_y
    return _pos
end

function GFlowerGameScene:InitMenuUI()
    --菜单收缩栏
    local Image_Menu = self.m_widget:getChildByName("Image_Menu")
    Image_Menu:setLocalZOrder(30)
    self.Button_Menu = self.m_widget:getChildByName("Image_Menu"):getChildByName("Button_Menu")
    --self.Button_Menu:setLocalZOrder(30)

    local Panel_Menu = self.m_widget:getChildByName("Panel_Menu")
    self.MoveMenu = self.m_widget:getChildByName("Panel_Menu"):getChildByName("MoveMenu")
    Panel_Menu:setLocalZOrder(30)

    -- 初始化菜单为缩进去 --
    self._menuOpen = true
    self:MenuControl(not self._menuOpen)

    local Button_Exit = self.MoveMenu:getChildByName("Button_Exit")
    local Button_Change = self.MoveMenu:getChildByName("Button_Change")

    local Button_Rule = self.MoveMenu:getChildByName("Button_Rule")
    local Button_Px = self.MoveMenu:getChildByName("Button_Px")
    self.button_Music = self.MoveMenu:getChildByName("Button_Music")
    self.button_Sound = self.MoveMenu:getChildByName("Button_Sound")
    -- 菜单控制按钮 --
    self.Button_Menu:addTouchEventListener(handler(self, self._onBtnTouched_result_close))

    -- 退出 换桌
    Button_Exit:addTouchEventListener(handler(self, self._onBtnTouched_result_close))
    -- 换桌按钮隐藏
    --Button_Change:addTouchEventListener(handler(self, self._onBtnTouched_tips_Visible))
    Button_Change:setVisible(false)

    -- 牌型 规则
    Button_Rule:addTouchEventListener(handler(self, self._onBtnTouched_tips_Visible))
    Button_Px:addTouchEventListener(handler(self, self._onBtnTouched_tips_Visible))

    -- 音乐音效
    self.button_Music:addTouchEventListener(handler(self, self._onBtnTouched_Music))
    self.button_Sound:addTouchEventListener(handler(self, self._onBtnTouched_Sound))
    
    --换桌提示框
    self.huanzhuotip = self.m_widget:getChildByName("huanzhuotip")
    local sure = self.huanzhuotip:getChildByName("sure")
    local cancel = self.huanzhuotip:getChildByName("cancel")
    sure:addTouchEventListener(handler(self, self._onBtnTouched_result_close))
    cancel:addTouchEventListener(handler(self, self._onBtnTouched_result_close))
    self.huanzhuotip:setVisible(false)
    self.huanzhuotip:setLocalZOrder(40)
    -- 提示框文本
    self.changetable_or_exit_tips = self.huanzhuotip:getChildByName("Image_174"):getChildByName("Text_1")

    --规则弹出框
    self.Panel_guize = self.m_widget:getChildByName("Panel_guize")
    self.Panel_guize:setVisible(false)
    local close_btn_guize = self.Panel_guize:getChildByName("close_btn")
    close_btn_guize:addTouchEventListener(handler(self, self._onBtnTouched_tips_Visible))
    self.Panel_guize:setLocalZOrder(40)

    --牌型
    self.Panel_px = self.m_widget:getChildByName("Panel_px")
    self.Panel_px:setVisible(false)
    self.Panel_px:addTouchEventListener(handler(self, self._onBtnTouched_tips_Visible))
    self.Panel_px:setLocalZOrder(40)
end

-- 玩家信息初始化 --
function GFlowerGameScene:InitPlayerUi()

    self.gf_player = {}
    -- 不在这里初始化，避免换桌和重连等 创建多次
    --self._daojishius = {}
    self.playerhead = {}
    self.playername = {}
    self.playergold = {}
    self.playerxiazhu = {}
    self.playerready = {}
    self.playerCallBg = {}
    self.playerCallAction = {}
    self.playerLook = {}
    self.playerLight = {}

    self.playercardendPos = {}

    --5个玩家的手牌容器(每个玩家三张牌) i表示第几个玩家
    self.player5_3Card = {}

    for i = 1, GFlowerConfig.CHAIR_COUNT do
        
        self.gf_player[i] = self.m_widget:getChildByName("Image_player_"..i)
        self.gf_player[i]:setVisible(false)
        self.gf_player[i]:setLocalZOrder(20)

        -- 重连或者换桌 时不再创建
        if self._daojishius[i] == nil then
            -- 加载资源图片
            local spriteProgress = cc.Sprite:create(self.rootPath.."res/csb/game_res/baobo_zjh_dengdai_1.png")

            self._daojishius[i] = cc.ProgressTimer:create(spriteProgress)
            local size = self.gf_player[i]:getContentSize()
            self._daojishius[i]:setPosition(cc.p(size.width/2, size.height/2))
            self._daojishius[i]:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
            self._daojishius[i]:stopAllActions()
            self._daojishius[i]:setVisible(false)
            self._daojishius[i]:setLocalZOrder(5)

            self.gf_player[i]:addChild(self._daojishius[i])
        end

        self.playerhead[i] = self.gf_player[i]:getChildByName("Image_HeadIcon")
        self.playername[i] = self.gf_player[i]:getChildByName("Label_Name")
        --self.playername[i]:setTextAreaSize(cc.size(120, 20))
        self.playergold[i] = self.gf_player[i]:getChildByName("Label_GoldNum")
        self.playerxiazhu[i] = self.gf_player[i]:getChildByName("Label_XiaZhuNum")
        self.playerxiazhu[i]:setString("获取中")

        self.playerready[i] = self.gf_player[i]:getChildByName("Image_Ready")
        self.playerready[i]:setVisible(false)

        self.playerCallBg[i] = self.gf_player[i]:getChildByName("Image_Action")
        self.playerCallBg[i]:setVisible(false)
        self.playerCallBg[i]:setLocalZOrder(6)

        self.playerCallAction[i] = self.gf_player[i]:getChildByName("Action")
        self.playerCallAction[i]:setVisible(false)
        self.playerCallAction[i]:setLocalZOrder(7)

        self.playerLook[i] = self.gf_player[i]:getChildByName("Image_Look")
        self.playerLook[i]:setVisible(false)
        self.playerLook[i]:setLocalZOrder(5)

        self.playerLight[i] = self.gf_player[i]:getChildByName("Image_Light")
        self.playerLight[i]:setVisible(false)
        self.playerLight[i]:setLocalZOrder(5)

        -- 比牌/取消比牌按钮 --
        --local playercompare1 = self.gf_player[i]:getChildByName("BtnPlayer")
        --self.playercompare1[i] = self.gf_player[i]:getChildByName("BtnPlayer")
        --self.playercompare[i]:addTouchEventListener(handler(self, self.On_CompareUserBtn))
        --playercompare1:setTouchEnabled(false)
        --playercompare1:setVisible(false)
        --playercompare1:setTag(i)

        -- 手牌位置 --
        self.playercardendPos[i] = GFlowerConfig.PLAYER_CARD_POS[i]

        --5个玩家的手牌容器(每个玩家三张牌) i表示第几个玩家
        self.player5_3Card[i] = {}
    end

end

-- 操作按钮 --
function GFlowerGameScene:InitPlayBtn()
    -- 玩家操作按钮容器 --
    self._controlMenu = 
    {
        GIVE_UP = {},
        ALL_IN = {},
        BI_PAI = {},
        LOOK_CARD = {},
        ADD_SCORE = {},
        FOLLOW = {},
    }

    -- 操作按钮层 --
    self.Panel_Btn_Menu = self.m_widget:getChildByName("Panel_Btn_Menu");

    -- 放弃按钮
    self.Button_Giveup = self.Panel_Btn_Menu:getChildByName("Button_Giveup")
    self.Button_Giveup:addTouchEventListener(handler(self, self._onBtnTouched_play_btn))
    self.Image_GiveUp = self.Button_Giveup:getChildByName("Image_2")

    -- 全押按钮
    self.Button_All = self.Panel_Btn_Menu:getChildByName("Button_All")
    self.Button_All:addTouchEventListener(handler(self,self._onBtnTouched_play_btn))
    self.Image_All = self.Button_All:getChildByName("Image_2")

    -- 比牌按钮
    self.Button_Compare = self.Panel_Btn_Menu:getChildByName("Button_Compare")
    self.Button_Compare:addTouchEventListener(handler(self,self._onBtnTouched_play_btn))
    self.Image_Compare = self.Button_Compare:getChildByName("Image_2")

    -- 看牌按钮
    self.Button_Look = self.Panel_Btn_Menu:getChildByName("Button_Look")
    self.Button_Look:addTouchEventListener(handler(self,self._onBtnTouched_play_btn))
    self.Image_Look = self.Button_Look:getChildByName("Image_2")

    -- 加注按钮
    self.Button_Add = self.Panel_Btn_Menu:getChildByName("Button_Add")
    self.Button_Add:addTouchEventListener(handler(self,self._onBtnTouched_play_btn))
    self.Image_Add = self.Button_Add:getChildByName("Image_2")

    -- 跟注按钮
    self.Button_Follow = self.Panel_Btn_Menu:getChildByName("Button_Follow")
    self.Button_Follow:addTouchEventListener(handler(self,self._onBtnTouched_play_btn))
    self.Image_Follow = self.Button_Follow:getChildByName("Image_2")

    -- 加注界面取消按钮 --
    --self.Button_Cancel = ccui.Helper:seekWidgetByName(self.Panel_JettonZone, "Button_Cancel")
    --self.Button_Cancel:addTouchEventListener(handler(self, self.on_btn_AddCancel))

    -- 操作按钮 --
    self._controlMenu.ALL_IN["Button"] = self.Button_All
    self._controlMenu.BI_PAI["Button"] = self.Button_Compare
    self._controlMenu.GIVE_UP["Button"] = self.Button_Giveup
    self._controlMenu.FOLLOW["Button"] = self.Button_Follow
    self._controlMenu.ADD_SCORE["Button"] = self.Button_Add
    self._controlMenu.LOOK_CARD["Button"] = self.Button_Look

    self._controlMenu.ALL_IN["Image"] = self.Image_All
    self._controlMenu.BI_PAI["Image"] = self.Image_Compare
    self._controlMenu.GIVE_UP["Image"] = self.Image_GiveUp
    self._controlMenu.FOLLOW["Image"] = self.Image_Follow
    self._controlMenu.ADD_SCORE["Image"] = self.Image_Add
    self._controlMenu.LOOK_CARD["Image"] = self.Image_Look
end

-- 其他界面 --
function GFlowerGameScene:InitOtherUi()

    -- 金币父节点 -- 
    self.coinParent = cc.Sprite:create()
    self.m_widget:addChild(self.coinParent)

    --所有筹码容器
    self._coinSprite = {}
    -- 比牌按钮
    self.playercompare = {}

    -- 比牌动画是否在进行
    self.is_compare = false

    -- 比牌遮罩
    self.Panel_compare = self.m_widget:getChildByName("Panel_compare")
    self.Panel_compare:setVisible(false)
    self.Panel_compare:setLocalZOrder(100)
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        -- 比牌/取消比牌按钮 --
        self.playercompare[i] = self.Panel_compare:getChildByName("BtnPlayer"..i)
        self.playercompare[i]:addTouchEventListener(handler(self, self.On_CompareUserBtn))
        self.playercompare[i]:setTouchEnabled(false)
        self.playercompare[i]:setVisible(false)
        self.playercompare[i]:setTag(i)

        if i ~= 1 then
            local _compareAni = ccs.Armature:create("zjh_paixin_eff")
            self.playercompare[i]:addChild(_compareAni)
            _compareAni:setLocalZOrder(2)
            _compareAni:setPosition(53, 53)
            _compareAni:getAnimation():play("ani_08")
        end

    end

    -- 跑马灯
    self.marqueePanel = self.m_widget:getChildByName("Image_TextBg")
    self.marqueePanel:setOpacity(0)

    local Panel_Zoumadeng = self.marqueePanel:getChildByName("Panel_Zoumadeng")
    self.marqueeText = Panel_Zoumadeng:getChildByName("Label_Text")
    self.marqueeText:setString("")

    -- 总注文本
    local Image_zongzhu = self.m_widget:getChildByName("Image_zongzhu")
    self.Text_danzhu = Image_zongzhu:getChildByName("Text_danzhu")
    self.Text_zongzhu = Image_zongzhu:getChildByName("Text_zongzhu")
    self.Text_danzhu:setString("0")
    self.Text_zongzhu:setString("0")

    -- 底注文本 --
    self.Label_Dizhu = self.m_widget:getChildByName("Label_Dizhu")
    self.Label_Dizhu:setString("")
    -- 轮数文本 --
    self.Label_Lunshu = self.m_widget:getChildByName("Label_Lunshu")
    self.Label_Lunshu:setString("0")

    -- 当前玩家的灯光效果 --
    self.rotateLight = self.m_widget:getChildByName("icon_light")
    self.rotateLight:setVisible(false)

    -- 结算界面 --
    self.jiesuan = self.m_widget:getChildByName("jiesuan")
    self.jiesuan:setVisible(false)
    self.jiesuan:setLocalZOrder(29)
    self.btn_ready = self.jiesuan:getChildByName("btn_ready")
    self.readyImage = self.btn_ready:getChildByName("Image_4")
    self.btn_ready:addTouchEventListener(handler(self,self._onBtnTouched_GameOver))

    self.btn_autoready = self.jiesuan:getChildByName("btn_autoready")
    self.autoreadyImage = self.btn_autoready:getChildByName("Image_3")
    self.autoreadyImage:setVisible(false)
    self.btn_autoready:addTouchEventListener(handler(self,self._onBtnTouched_GameOver))

    -- 结算界面准备倒计时
    self.ready_time_di = self.jiesuan:getChildByName("Image_jiesuan_di")
    --self.ready_time_di:setPosition(640 + 130, 147)
    self.ready_time = self.ready_time_di:getChildByName("Label_CountDown")

    -- 倒计时转圈动画
    if self.jiesuan_djs_ani == nil then
        local spriteProgress = cc.Sprite:create(self.rootPath.."res/csb/game_res/zjh_jiesuan_time.png")
        self.jiesuan_djs_ani = cc.ProgressTimer:create(spriteProgress)
        local size = self.ready_time_di:getContentSize()
        self.jiesuan_djs_ani:setPosition(cc.p(size.width/2, size.height/2))
        self.jiesuan_djs_ani:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
        self.jiesuan_djs_ani:stopAllActions()
        self.jiesuan_djs_ani:setVisible(false)
        self.jiesuan_djs_ani:setLocalZOrder(5)
        self.ready_time_di:addChild(self.jiesuan_djs_ani)
    end

    -- 比牌界面 --
    self.compare = self.m_widget:getChildByName("compare")
    self.compare:setVisible(false)
    self.compare:setLocalZOrder(Compare_ZOrder)

    -- 开始按钮 --
    self.Button_StartGame = self.m_widget:getChildByName("Button_StartGame")
    self.Button_StartGame:setVisible(false)

    -- 牌型动画容器 --
    self.Panel_PaiXin = self.m_widget:getChildByName("Panel_SpecialAnimation")
    local   cardType_Ani = ccs.Armature:create("zjh_paixin_eff")
    self.Panel_PaiXin:addChild(cardType_Ani)
    self.Panel_PaiXin:setGlobalZOrder(3000)
    self.Panel_PaiXin:setLocalZOrder(3000)
    cardType_Ani:setGlobalZOrder(3000)
    cardType_Ani:setLocalZOrder(3000)
    cardType_Ani:setPosition(100, 120)
    cardType_Ani:setTag(GFlowerConfig.PAIXIN_TAG)
    cardType_Ani:setVisible(false)

    -- 跟到底按钮
    self.Button_FollowDi = self.m_widget:getChildByName("Button__FollowDi")
    self.Image_FollowDiFlag = self.Button_FollowDi:getChildByName("Image_FollowDiFlag")
    self.Image_FollowDiFlag:setVisible(false)
    self.Button_FollowDi:addTouchEventListener(handler(self,self._onBtnTouched_FollowDi))

    -- 加注弹出框 --
    self.Panel_JettonZone = self.m_widget:getChildByName("Panel_JettonZone")
    self.Panel_JettonZone:setVisible(false)

    -- 筹码选择框 取消按钮
    local JettonZone_cancel = self.Panel_JettonZone:getChildByName("Button_Cancel")
    JettonZone_cancel:addTouchEventListener(handler(self,self._onBtnTouched_FollowDi))

    -- 全场比牌ui --
    self.Panel_OpenCard = self.m_widget:getChildByName("Panel_OpenCard")
    self.Label_OpenCard = self.Panel_OpenCard:getChildByName("Label_Reason")
    self.Image_OpenCard = self.Panel_OpenCard:getChildByName("Image_247")
    self.Image_VS = self.Panel_OpenCard:getChildByName("Image_244")
    self.Image_VS:setVisible(false)
    self.Panel_OpenCard:setVisible(false)
    self.Panel_OpenCard:setLocalZOrder(32)

    -- 全场比牌 动画 --
    if self.Ani_OpenCard == nil then
        self.Ani_OpenCard = ccs.Armature:create("bb_zjh_win_eff")
        self.Ani_OpenCard:setPosition(640, 380)
        self.Panel_OpenCard:addChild(self.Ani_OpenCard)
    end

    -- 游戏开始提示 --
    self.Image_begin = self.m_widget:getChildByName("Image_begin")
    self.Image_begin:setVisible(false)
    self.Txt_StartCountDown = self.Image_begin:getChildByName("Text_startTime")
end

function GFlowerGameScene:setImageBeginVisible(Visible)
    if Visible then
        if self.Image_begin:isVisible() == false then
            self.Image_begin:setVisible(Visible)
        end
    else
        self.Image_begin:setVisible(Visible)
    end
end


--初始化筹码 一共5种筹码(起始跟注为默认筹码) 加注筹码编号2 ~ 5
function GFlowerGameScene:On_InitJetton()
    for i = 2, GFlowerConfig.COIN_NUM do

        local add_btn = self.Panel_JettonZone:getChildByName("Button_Jetton_" .. i)
        local add_Label_Jetton = add_btn:getChildByName("Label_Jetton")

        add_btn:setTag(i)
        add_btn:addTouchEventListener(handler(self,self._onBtnTouched_bet))

        -- 设置筹码显示值
        add_Label_Jetton:setString(""..(self._logic.MinJetton * GFlowerConfig.ADD_BTN_TIMES[i])/CustomHelper.goldToMoneyRate())
    end
end

----------------------------------------------------------------------
-- 结算 按钮响应 --
function GFlowerGameScene:_onBtnTouched_GameOver(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        if sender:getName() ~= "btn_autoready" then
            sender:setScale(GFlowerConfig.BTN_CLICK_SCALE)
        else
            sender:setScale(GFlowerConfig.AUTO_READY_SCALE)
        end
    elseif eventType == ccui.TouchEventType.ended then
        if sender:getName() == "btn_ready" then
			if self:isContinueGameConditions() == false then
			--todo
				return
			end
            self.btn_ready:setTouchEnabled(false)
            self.btn_ready:setBright(false)
            self.readyImage:loadTexture(GFlowerConfig.IMAGE_JIESUAN.READY_DISABLE)

            self:dealJieSuanReady()

            --终止倒计时
            if self._scheduler ~= nil then
                self:removeScheduler()
            end

            self.ready_time_di:setVisible(false)

            --关闭结算界面
            self.jiesuan:setVisible(false)
        elseif sender:getName() == "btn_autoready" then
            self.autoreadyImage:setVisible(not self.autoreadyImage:isVisible())
        end
        sender:setScale(1)
    else
        sender:setScale(1)
    end
end

--  处理结算准备按钮事件
function GFlowerGameScene:dealJieSuanReady()
    self._logic:clearPlayerDownMoney()
    self._logic:resetMainTableData()

    -- 如果房间 不处于战斗状态 玩家进入后强制准备
    if self.room_state ~= GFlowerConfig.ROOM_STATE.PLAY then

        self:removeAllCoin()
        GameManager:getInstance():getHallManager():getHallMsgManager():sendGameReady()
    else
        self:recoverMainTableUI()
     
        if self.coinList then
            self:connectAllDeskCoin(self.coinList)
        end
    end
end

-- 跟到底按钮响应 --
function GFlowerGameScene:_onBtnTouched_FollowDi(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        sender:setScale(GFlowerConfig.BTN_CLICK_SCALE)
        --GMusicSound:getInstance():playSound(SOUND_HALL_TOUCH)
    elseif eventType == ccui.TouchEventType.ended then
        sender:setScale(1)
        if sender:getName() == "Button__FollowDi" then
            if self.Image_FollowDiFlag:isVisible() then
                self._logic.gendaodi = false
                self.Image_FollowDiFlag:setVisible(false)
                --print("跟到底--否")
            else
                self._logic.gendaodi = true
                self.Image_FollowDiFlag:setVisible(true)
                --print("跟到底--是")
            end

            if self._logic.gendaodi == false then
                if self._scheduler ~= nil then
                    self:removeScheduler()
                end
            else
                -- 如果是该自己操作，就跟一回合 
                if self._logic.doing_id == GFlowerConfig.CHAIR_SELF then
                    self.Button_Follow:setEnabled(false)
                    self.Image_Follow:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN["FOLLOW"][2])
                    local player = self._logic:getGFPlayerByClientId(GFlowerConfig.CHAIR_SELF)
                    if  player:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK then
                        self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, self._logic.follow_num, 2)
                    else
                        self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, self._logic.follow_num, 1)
                    end

                    GFlowerGameManager:getInstance():send_CS_ZhaJinHuaAddScore(GFlowerConfig.ADD_BTN_TIMES[self._logic.follow_num] * self._logic.MinJetton)
                end
            end

        elseif sender:getName() == "Button_Cancel" then
            self.Button_Add:setEnabled(true)
            self.Image_Add:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN["ADD_SCORE"][1])
            self.Panel_JettonZone:setVisible(false)
            self.Panel_Btn_Menu:setVisible(true)
        end
        --sender:setScale(1)
    else
        sender:setScale(1)
    end
end

-- 找哪个玩家比牌
function GFlowerGameScene:On_CompareUserBtn(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        sender:setScale(GFlowerConfig.BTN_CLICK_SCALE)
        --GMusicSound:getInstance():playSound(SOUND_HALL_TOUCH)
    elseif eventType == ccui.TouchEventType.ended then
        sender:setScale(1)
        local chair_id = sender:getTag()
        if chair_id == 1 then
            self:isVisibleCompareBtn(false)
        else
            GFlowerGameManager:getInstance():send_CS_ZhaJinHuaCompareCard(chair_id)
        end
    else
        sender:setScale(1)
    end
end

--下排操作按钮对应的响应 --
function GFlowerGameScene:_onBtnTouched_play_btn(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
        sender:setScale(GFlowerConfig.BTN_CLICK_SCALE)
    --     GMusicSound:getInstance():playSound(SOUND_HALL_TOUCH)
    elseif eventType == ccui.TouchEventType.ended then
        sender:setScale(1)
        if sender:getName() == "Button_Giveup" then
            -- 弃牌
            GFlowerGameManager:getInstance():send_CS_ZhaJinHuaGiveUp()
        elseif sender:getName() == "Button_All" then
            -- 全压1 直接发 1
            self.Button_All:setEnabled(false)
            self.Image_All:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN["ALL_IN"][2])
            self._logic:AllCoinList(self._logic.MinJettonMoney*GFlowerConfig.MAX_JETTON)
            self:AllInScore(GFlowerConfig.CHAIR_SELF)
            GFlowerGameManager:getInstance():send_CS_ZhaJinHuaShowHandScore(1)
        elseif sender:getName() == "Button_Compare" then
            -- 比牌
            -- 如果场上还剩两个玩家，直接发送比牌消息
            if self._logic:getPlayingNum() == 2 then
                GFlowerGameManager:getInstance():send_CS_ZhaJinHuaCompareCard(self._logic:getCompareNum())
            else
                self:isVisibleCompareBtn(true)
            end
        elseif sender:getName() == "Button_Look" then
            -- 看牌
            GFlowerGameManager:getInstance():send_CS_ZhaJinHuaLookCard()
        elseif sender:getName() == "Button_Add" then
            -- 加注
            self.Button_Add:setEnabled(false)
            self.Image_Add:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN["ADD_SCORE"][2])
            self.Panel_JettonZone:setVisible(true)
            self.Panel_Btn_Menu:setVisible(false)

            -- 检测可用的加注按钮
            self:setAddSorceBtn()
        elseif sender:getName() == "Button_Follow" then
            --跟注self._logic.follow_num
            self.Button_Follow:setEnabled(false)
            self.Image_Follow:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN["FOLLOW"][2])
            local player = self._logic:getGFPlayerByClientId(GFlowerConfig.CHAIR_SELF)
            if  player:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK then
                self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, self._logic.follow_num, 2)
            else
                self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, self._logic.follow_num, 1)
            end

            GFlowerGameManager:getInstance():send_CS_ZhaJinHuaAddScore(GFlowerConfig.ADD_BTN_TIMES[self._logic.follow_num] * self._logic.MinJetton)
        end
        --sender:setScale(1)
    else
        sender:setScale(1)
    end
end

-- 根据当前跟注禁用小于当前跟注的加注
function GFlowerGameScene:setAddSorceBtn()
    
    for i = 2, GFlowerConfig.COIN_NUM do
        local btn = self.Panel_JettonZone:getChildByTag(i)
        -- 禁用小于当前跟注编号的加注按钮
        if i <= self._logic.follow_num then
            btn:setTouchEnabled(false)
            btn:setBright(false)
        else
            btn:setTouchEnabled(true)
            btn:setBright(true)
        end
    end
end

-- 加注选择点击 --
function GFlowerGameScene:_onBtnTouched_bet(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then

        self.Panel_JettonZone:setVisible(false)
        self.Panel_Btn_Menu:setVisible(true)

        -- 发送加注信息
        local chouma_type = sender:getTag()
        local player = self._logic:getGFPlayerByClientId(GFlowerConfig.CHAIR_SELF)
        if player:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK then
            self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, chouma_type, 2)
        else
            self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, chouma_type, 1)
        end
        GFlowerGameManager:getInstance():send_CS_ZhaJinHuaAddScore(GFlowerConfig.ADD_BTN_TIMES[chouma_type] * self._logic.MinJetton)
    end
end

function GFlowerGameScene:_onBtnTouched_Music(sender, eventType)
   if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        local mv = self._soundMgr:getMusic()
        mv = not mv
        GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch(mv)
        self._soundMgr:setMusic(mv)

        if mv == true then
            self.button_Music:loadTextureNormal(GFlowerConfig.BTN_IMG.MUSIC_ON_N)
            self.button_Music:loadTexturePressed(GFlowerConfig.BTN_IMG.MUSIC_ON_P)
            self.button_Music:loadTextureDisabled(GFlowerConfig.BTN_IMG.MUSIC_ON_P)
        else
            self.button_Music:loadTextureNormal(GFlowerConfig.BTN_IMG.MUSIC_OFF_N)
            self.button_Music:loadTexturePressed(GFlowerConfig.BTN_IMG.MUSIC_OFF_P)
            self.button_Music:loadTextureDisabled(GFlowerConfig.BTN_IMG.MUSIC_OFF_P)
        end
    end
end

function GFlowerGameScene:_onBtnTouched_Sound(sender, eventType)
   if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        local sv = self._soundMgr:getSound()
        sv = not sv
        GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch(sv)
        self._soundMgr:setSound(sv)

        if sv == true then
            self.button_Sound:loadTextureNormal(GFlowerConfig.BTN_IMG.SOUND_ON_N)
            self.button_Sound:loadTexturePressed(GFlowerConfig.BTN_IMG.SOUND_ON_P)
            self.button_Sound:loadTextureDisabled(GFlowerConfig.BTN_IMG.SOUND_ON_P)
        else
            self.button_Sound:loadTextureNormal(GFlowerConfig.BTN_IMG.SOUND_OFF_N)
            self.button_Sound:loadTexturePressed(GFlowerConfig.BTN_IMG.SOUND_OFF_P)
            self.button_Sound:loadTextureDisabled(GFlowerConfig.BTN_IMG.SOUND_OFF_P)
        end
    end
end

--规则 牌型 换桌层 影藏或者显示
function GFlowerGameScene:_onBtnTouched_tips_Visible(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        --GMusicSound:getInstance():playSound(SOUND_HALL_TOUCH)
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        if sender:getName() == "Button_Rule"  or sender:getName() == "close_btn" then
            self.Panel_guize:setVisible(not self.Panel_guize:isVisible())
        elseif sender:getName() == "Button_Change" then
            --print("点击换桌")
            -- 如果玩家还没弃牌 先弃牌
            local player = self._logic:getGFPlayerByClientId(GFlowerConfig.CHAIR_SELF)
            if player:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK
            or player:getGameState() == GFlowerConfig.PLAYER_STATUS.CONTROL then
                -- 临时添加一个变量 记录玩家是点击的换桌或者退出操作
                -- true 表示换桌  false表示退出
                self.huanzhuo_or_exit = true
                self.changetable_or_exit_tips:setString("现在换桌，已下注的筹码将不会\n退回哦，确定换桌吗？")
                self.huanzhuotip:setVisible(not self.huanzhuotip:isVisible())
            else
                GFlowerGameManager:getInstance():sendMsgChangeTable()
            end

        elseif sender:getName() == "Button_Px"  or sender:getName() == "Panel_px" then
            self.Panel_px:setVisible(not self.Panel_px:isVisible())
        end
    end
end

--退出游戏 -- 是否确认换桌 -- 收缩展开菜单
function GFlowerGameScene:_onBtnTouched_result_close(sender, eventType)
    -- if eventType == ccui.TouchEventType.began then
    --     GMusicSound:getInstance():playSound(SOUND_HALL_TOUCH)
   if eventType == ccui.TouchEventType.ended then
      
        local gfplayer = self._logic:getGfPlayers()[self._logic.myServerChairId]
        --print("self._logic.s_chair: ",self._logic.s_chair," ,gfplayer: ",gfplayer)
        --dump(gfplayer,"gfplayer")
        local state    = gfplayer:getGameState()
        if sender:getName() == "Button_Exit" then
            -- 如果玩家还没弃牌 先弃牌
            if state == GFlowerConfig.PLAYER_STATUS.LOOK
            or state == GFlowerConfig.PLAYER_STATUS.CONTROL then
                -- false 表示换桌  true表示退出
                self.huanzhuo_or_exit = false
                self.changetable_or_exit_tips:setString("现在退出将视为弃牌，已下注的\n筹码将不会退还，是否确认退出？")
                self.huanzhuotip:setVisible(not self.huanzhuotip:isVisible())
            else
                GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                --self:returnToHallScene()
            end
        elseif sender:getName() == "Button_Menu" then
            self:MenuControl(not self._menuOpen)
        elseif sender:getName() == "sure" then
            -- 确定换桌
            self.huanzhuotip:setVisible(false)
            -- 如果玩家还没弃牌 先弃牌
            if state == GFlowerConfig.PLAYER_STATUS.LOOK
            or state == GFlowerConfig.PLAYER_STATUS.CONTROL then

                print("GFlowerGameScene:_onBtnTouched_result_close")
                GFlowerGameManager:getInstance():send_CS_ZhaJinHuaGiveUp()
            end

            -- true 表示换桌  false表示退出
            if self.huanzhuo_or_exit then
                GFlowerGameManager:getInstance():sendMsgChangeTable()
            else
                GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                --self:returnToHallScene()
            end
        elseif sender:getName() == "cancel" then
            -- 取消换桌
            self.huanzhuotip:setVisible(false)
        end
    end
end

-- 菜单收缩动画 --
function GFlowerGameScene:MenuControl(isOpen)
    if isOpen then
        self.MoveMenu:setPositionX(580)
        self.MoveMenu:stopAllActions()
        self.MoveMenu:runAction(cc.MoveTo:create(0.2, cc.p(0,0)))
        self.Button_Menu:setRotation(0)
        self._menuOpen = true
    else
        self.MoveMenu:stopAllActions()
        self.MoveMenu:runAction(cc.MoveTo:create(0.2, cc.p(500, 0)))
        self.Button_Menu:setRotation(180)
        self._menuOpen = false
    end
end

-- 操作倒计时动画 --
function GFlowerGameScene:UsingDaojishi(showChair, timenum)
    if showChair < 1 or showChair > GFlowerConfig.CHAIR_COUNT then 
        return 
    end

    local _time1 = math.floor(timenum / 3)
    local _progress = self._daojishius[showChair]
    local function daojishi3()
        local _lastTime = timenum - _time1 * 2
        local _action3 = cc.ProgressFromTo:create(_lastTime, 33, 0)
        _progress:setSprite(cc.Sprite:create(GFlowerConfig.IMAGE_COUNT_DOWN[3]))
        if showChair == 1 then
            _progress:runAction(cc.Sequence:create(_action3, cc.CallFunc:create(
                function()
                    
                    --如果动画结束还没操作，视为弃牌
                    self:CloseDojishi(showChair)
                    --GFlowerGameManager:getInstance():send_CS_ZhaJinHuaGiveUp()
                    --print("x--over")
                end)))
        else
            _progress:runAction(_action3)
        end
    end

    local function daojishi2()
        local _action2 = cc.Sequence:create(cc.ProgressFromTo:create(_time1, 66, 33), cc.CallFunc:create(daojishi3))
        _progress:setSprite(cc.Sprite:create(GFlowerConfig.IMAGE_COUNT_DOWN[2]))
        _progress:runAction(_action2)
    end

    local _action1 = cc.Sequence:create(cc.ProgressFromTo:create(_time1, 100, 66), cc.CallFunc:create(daojishi2))

    _progress:stopAllActions()
    _progress:setVisible(true)
    _progress:setSprite(cc.Sprite:create(GFlowerConfig.IMAGE_COUNT_DOWN[1]))
    _progress:runAction(_action1)

end

-- 停止操作倒计时动画 --
function GFlowerGameScene:CloseDojishi(showChair)
    self._daojishius[showChair]:stopAllActions()
    self._daojishius[showChair]:setVisible(false)
end

-- 生成筹码 -- 类型 1 - 5  
function GFlowerGameScene:CreateCoin(coinType)

    -- 筹码图片
    local _coinSprite = display.newSprite(GFlowerConfig.COIN_SPRITE_STR[coinType])

    -- 筹码显示文本数值
    local _coinLabel = cc.Label:create()
    local _coinScore = GFlowerConfig.ADD_BTN_TIMES[coinType] * self._logic.MinJetton/CustomHelper.goldToMoneyRate()

    _coinLabel:setString("".._coinScore)
    _coinLabel:setSystemFontSize(24)
    _coinLabel:setPosition(
        _coinSprite:getContentSize().width / 2,
        _coinSprite:getContentSize().height / 2
        )
    _coinSprite:addChild(_coinLabel)
    return _coinSprite
end

-- 筹码 飞入 -- 飞出玩家  筹码类型  筹码数量
function GFlowerGameScene:CoinFlyAction(chairId, scoreType, coinNum)
    local _pos = GFlowerConfig.PLAYER_LOCATION[chairId]

    for i = 1, coinNum do
        local _coinSprite = self:CreateCoin(scoreType)
        _coinSprite:setPosition(_pos.x, _pos.y)
        self.coinParent:addChild(_coinSprite)
        local _pos1 = GetCoinRandPos()
        _coinSprite:runAction(cc.MoveTo:create(0.2, cc.p(_pos1.x, _pos1.y)))
        table.insert(self._coinSprite, _coinSprite)
    end
    -- 音效 筹码飞入 --
    self._soundMgr:PlayEffect_CoinFlyIn()
end

-- 重连和换桌生成 在卓的所有筹码
function GFlowerGameScene:connectAllDeskCoin(coinList)
    local AllInNum = 1
    local AllInList = {}
    local minJetton = self._logic.MinJetton/CustomHelper.goldToMoneyRate()

    -- 把score拆分计算为筹码编号
    for incex, score in pairs(coinList) do
        local allnum = (score/CustomHelper.goldToMoneyRate())
        while( allnum > 0 ) do
            if allnum >= minJetton * GFlowerConfig.ADD_BTN_TIMES[5] then
                AllInList[AllInNum] = 5
                allnum = allnum - minJetton * GFlowerConfig.ADD_BTN_TIMES[5]
            elseif allnum >= minJetton * GFlowerConfig.ADD_BTN_TIMES[4] then
                AllInList[AllInNum] = 4
                allnum = allnum - minJetton * GFlowerConfig.ADD_BTN_TIMES[4]
            elseif allnum >= minJetton * GFlowerConfig.ADD_BTN_TIMES[3] then
                AllInList[AllInNum] = 3
                allnum = allnum - minJetton * GFlowerConfig.ADD_BTN_TIMES[3]
            elseif allnum >= minJetton * GFlowerConfig.ADD_BTN_TIMES[2] then
                AllInList[AllInNum] = 2
                allnum = allnum - minJetton * GFlowerConfig.ADD_BTN_TIMES[2]
            elseif allnum >= minJetton * GFlowerConfig.ADD_BTN_TIMES[1] then
                AllInList[AllInNum] = 1
                allnum = allnum - minJetton * GFlowerConfig.ADD_BTN_TIMES[1]
            else
                AllInList[AllInNum] = 1
                break
            end
            AllInNum = AllInNum + 1
        end
    end

    -- 根据筹码编号制作筹码
    for incex, scoreType in pairs(AllInList) do
        local _pos = GetCoinRandPos()
        local _coinSprite = self:CreateCoin(scoreType)
        _coinSprite:setPosition(_pos.x, _pos.y)
        self.coinParent:addChild(_coinSprite)
        table.insert(self._coinSprite, _coinSprite)
    end
end


-- 扑克初始化 --
function GFlowerGameScene:CardUiInit()
    self.gf_cardChildNode = {}
    local _allCardCount = GFlowerConfig.CARD_COUNT * GFlowerConfig.CHAIR_COUNT
    for i = 1, _allCardCount do
        self.gf_cardChildNode[i] = GFlowerPoker.new(false)
        self.m_widget:addChild(self.gf_cardChildNode[i], i)
    end
    self:gfInitCard(false)
end

--初始化牌
function GFlowerGameScene:gfInitCard(isfapai)
    local gf_cardscale = GFlowerConfig.CARD_INIT_SCALE
    local gf_cardspace = GFlowerConfig.CARD_SPACE
    local _allCardCount = GFlowerConfig.CHAIR_COUNT * GFlowerConfig.CARD_COUNT
    for i = 1, _allCardCount do
        self.gf_cardChildNode[i]:stopAllActions()
        self.gf_cardChildNode[i]:setVisible(false)
        self.gf_cardChildNode[i]:setContent(false, 0, false)
        self.gf_cardChildNode[i]:setPosition(cc.p(640 + i * gf_cardspace, 400))
        self.gf_cardChildNode[i]:setScale(gf_cardscale)
        self.gf_cardChildNode[i]:setInvalid(false)
        self.gf_cardChildNode[i]:setLocalZOrder(i)
        self.gf_cardChildNode[i]:setRotation(0)
    end

    if isfapai == false then 
        return 
    end

    local players = self._logic.playerOrder
    -- 计算需要发牌的玩家个数
    local playercount = 0  
    for k, _chairId in pairs(players) do
        if _chairId ~= 0 then
            playercount = playercount + 1
        end
    end

    -- 再总共需要发牌的数量显示出来，最多显示 5 * 3 张
    local card_num  = playercount * GFlowerConfig.CARD_COUNT
    for i = 1, card_num do
        self.gf_cardChildNode[i]:setVisible(true)
    end
    -- 开始发牌动画
    self:gfFapaiAnimi(playercount, qishiplayer)
end

-- 发牌动画 --
function GFlowerGameScene:gfFapaiAnimi(playercount, qishiplayer)
    -- 音效 发牌 --
    self._soundMgr:PlayEffect_SendCard()

    local players = self._logic.playerOrder
    local gf_fpjg = 0.2
    local gf_dfsf = 0.1
    for i = 1, GFlowerConfig.CARD_COUNT do
        local j = 1
        -- 根据玩家数量 发牌 （_chairId为0说明该位置没有玩家）
        for k, _chairId in pairs(players) do
            if _chairId ~= 0 then
                local _cardScale = nil
                local _delayTime = gf_dfsf * ((i-1) * playercount + j - 1)
                local _cardIndex = (i-1) * playercount + j
                local gf_temppos = self.playercardendPos[_chairId]
                local gf_daytime = cc.DelayTime:create(_delayTime + 0.3)
                if _chairId == 1 then
                    _cardScale = GFlowerConfig.CARD_STAY_SCALE_ME
                else
                    _cardScale = GFlowerConfig.CARD_STAY_SCALE_OTHER
                end

                local _spawnAction = transition.sequence({
                    gf_daytime,
                    cc.Spawn:create(
                        cc.MoveTo:create(gf_fpjg, cc.p(gf_temppos.x + i * 25, gf_temppos.y)),
                        cc.ScaleTo:create(gf_fpjg, _cardScale),
                        cc.RotateTo:create(gf_fpjg, 720)
                        )
                    })
                self.gf_cardChildNode[_cardIndex]:runAction(_spawnAction)

                if i == GFlowerConfig.CARD_COUNT and j == playercount then
                    self.gf_cardChildNode[_cardIndex]:runAction(
                        cc.Sequence:create(gf_daytime, cc.CallFunc:create(handler(self, self.gfFapaiAnimiCallBack))))
                end

                -- 得到服务器发牌通知后 才能把指定的牌分给 指定的玩家
                -- 自己看牌后服务器才会把牌编号发过来 这里不用初始化玩家是什么牌
                -- local gf_temppos = self.playercardendPos[_chairId]
                self.player5_3Card[_chairId][i] = self.gf_cardChildNode[_cardIndex]

                j = j + 1
            end
        end
    end
end

-- 发牌动画回掉 --
function GFlowerGameScene:gfFapaiAnimiCallBack()
    self:UsingDaojishi(self._logic.doing_id, GFlowerConfig.COUNT_DOWN_TIME)
    self:MoveLight(self._logic.doing_id)

    -- 刷新下排按钮
    self:UpdateMenuBtn()

    -- 如果选择了跟到底 且 当前轮到自己操作
    if self._logic.gendaodi == true and self._logic.doing_id  == GFlowerConfig.CHAIR_SELF then
        local player = self._logic:getGFPlayerByClientId(GFlowerConfig.CHAIR_SELF)
        if player:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK then
            self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, self._logic.follow_num, 2)
        else
            self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, self._logic.follow_num, 1)
        end
        print("gfFapaiAnimiCallBack 加注 =======================================： ",GFlowerConfig.ADD_BTN_TIMES[self._logic.follow_num] * self._logic.MinJetton)
        GFlowerGameManager:getInstance():send_CS_ZhaJinHuaAddScore(GFlowerConfig.ADD_BTN_TIMES[self._logic.follow_num] * self._logic.MinJetton)
    end
end

-- 灯光转动 动画
function GFlowerGameScene:MoveLight(nextPlayer)
    local node = self.gf_player[nextPlayer]

    local distance = game.fishgame2d.MathAide:CalcDistance(node:getPositionX(), node:getPositionY(), self.rotateLight:getPositionX(),  self.rotateLight:getPositionY())
    local reg = game.fishgame2d.MathAide:CalcAngle(node:getPositionX(), node:getPositionY(), self.rotateLight:getPositionX(),  self.rotateLight:getPositionY())
    local scale = distance / self.rotateLight:getContentSize().height

    if self.rotateLight:isVisible() then
        self.rotateLight:stopAllActions()
        self.rotateLight:runAction(cc.Spawn:create(cc.RotateTo:create(0.1, math.deg(-reg)),
            cc.ScaleTo:create(0.1,1,scale)))
    else
        self.rotateLight:setRotation(math.deg(-reg))
        self.rotateLight:setScaleY(distance / self.rotateLight:getContentSize().height)
    end
    --self._iconPlayerLight:pos(cc.p(node:getPosition()))

    self.rotateLight:setVisible(true)
    --self._iconPlayerLight:setVisible(true)
end

-- 比牌按钮控制
function GFlowerGameScene:isVisibleCompareBtn(isVisible)
    --GFlowerGameScene据玩家状态得知可以和哪些玩家比牌
    -- 发起比牌 显示按钮
    self.Panel_compare:setVisible(isVisible)
    if isVisible then
        for idx, player in pairs(self._logic.gfPlayers) do
            local state     = player:getGameState()
            local client_id = player:getClientChairId()
            -- 只能和 看牌 准备操作（视为闷牌） 的玩家比牌
            if state == GFlowerConfig.PLAYER_STATUS.LOOK
            or state == GFlowerConfig.PLAYER_STATUS.CONTROL then
                self.playercompare[client_id]:setVisible(true)
                self.playercompare[client_id]:setTouchEnabled(true)
            end
        end
    --比牌返回 隐藏按钮
    else
        for i = 1, GFlowerConfig.CHAIR_COUNT  do
            self.playercompare[i]:setVisible(false)
            self.playercompare[i]:setTouchEnabled(false)
        end
    end
end

-- 玩家状态更新4种： 准备 READY    等待入桌 STAND    淘汰 LOSE    弃牌 DROP
-- GFlowerConfig.IMAGE_PLAYER_STATUS["STAND"]
function GFlowerGameScene:UpdatePlayerStatus(chair_id)
    -- 观战
    local gfplayer = self._logic:getGFPlayerByClientId(chair_id)
    local state    = gfplayer:getGameState() 
    if state == GFlowerConfig.PLAYER_STATUS.STAND then
        print("ChairID: "..chair_id.." 观战。。。。。。。。。。。。。。。")
        self.playerready[chair_id]:loadTexture(GFlowerConfig.IMAGE_PLAYER_STATUS["STAND"])
        self.playerready[chair_id]:setVisible(true)
    -- 准备
    elseif state == GFlowerConfig.PLAYER_STATUS.READY then
        print("ChairID: "..chair_id.." 准备。。。。。。。。。。。。。。。")
        self.playerready[chair_id]:loadTexture(GFlowerConfig.IMAGE_PLAYER_STATUS["READY"])
        self.playerready[chair_id]:setVisible(true)
    -- 淘汰
    elseif state == GFlowerConfig.PLAYER_STATUS.LOSE then
        self.playerready[chair_id]:loadTexture(GFlowerConfig.IMAGE_PLAYER_STATUS["LOSE"])
        self.playerready[chair_id]:setVisible(true)
        -- 显示闪电图片
        self.playerLight[chair_id]:setVisible(true)
        -- 隐藏看牌图片
        self.playerLook[chair_id]:setVisible(false)
  
        -- 把牌背置灰
        self:setInvalidCard(chair_id, true)
    -- 弃牌
    elseif state == GFlowerConfig.PLAYER_STATUS.DROP then
        print("ChairID: "..chair_id.." 弃牌。。。。。。。。。。。。。。。")
        self.playerready[chair_id]:loadTexture(GFlowerConfig.IMAGE_PLAYER_STATUS["DROP"])
        self.playerready[chair_id]:setVisible(true)
        self.playerLight[chair_id]:setVisible(true)
        self.playerLook[chair_id]:setVisible(false)
        self:setInvalidCard(chair_id, true)
    -- 看牌
    elseif state == GFlowerConfig.PLAYER_STATUS.LOOK then
        -- 如果不是自己才显示看牌图片
        if chair_id ~= 1 then
            self.playerLook[chair_id]:setVisible(true)
        end
    else
        --print("更新状态id："..chair_id)
        self.playerready[chair_id]:setVisible(false)
    end

end

-- 重连和换桌 处理灯光 和 文本
function GFlowerGameScene:recoverMainTableUI()

    -- 启动操作倒计时动画 和 灯光到当前玩家
    self:UsingDaojishi(self._logic.doing_id, GFlowerConfig.COUNT_DOWN_TIME)
    self:MoveLight(self._logic.doing_id)

    -- 刷新操作按钮
    self:UpdateMenuBtn()

    -- 设置文本
    -- 单住
    self.Text_danzhu:setString(CustomHelper.moneyShowStyleNone(self._logic.MinJetton))

    -- 总注
    self.Text_zongzhu:setString(CustomHelper.moneyShowStyleNone(self._logic.deskAllMoney))

    -- 底注文本 --
    self.Label_Dizhu:setString(CustomHelper.moneyShowStyleNone(self._logic.MinJetton))
    --print("---------------------------------onEnter---------------重置文字文本2："..self._logic.MinJetton)

    -- 轮数文本 --
    self.Label_Lunshu:setString(""..self._logic.roundNum)

    -- 各个玩家下注的累积
    for idx, gfplayer in pairs(self._logic.gfPlayers) do
        -- 从父节点和表中删除
        local downMoney = gfplayer:getDownMoney()
        local client_id = self._logic:getLocalChairId(gfplayer:getChairId())
        if downMoney > 0 then
            self.playerxiazhu[client_id]:setString(CustomHelper.moneyShowStyleNone(downMoney))
        end
        self:UpdatePlayerStatus(client_id)
    end
end


-- 重置文本 和 部分隐藏
function GFlowerGameScene:resetMainTableUI()
    self.Text_danzhu:setString(CustomHelper.moneyShowStyleNone(self._logic.MinJetton))
    self.Text_zongzhu:setString("0")
    -- 底注文本 --
    self.Label_Dizhu:setString(CustomHelper.moneyShowStyleNone(self._logic.MinJetton))
    --print("---------------------------------onEnter---------------重置文字文本1："..self._logic.MinJetton)
    -- 轮数文本 --
    self.Label_Lunshu:setString("0")

    -- 影藏灯光
    self.rotateLight:setVisible(false)

    --关闭所有操作倒计时动画
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self:CloseDojishi(i)
        self.playerxiazhu[i]:setString("获取中")
    end
end

-- 清空桌面筹码
function GFlowerGameScene:removeAllCoin()
    -- 清除桌上的筹码
    self.coinParent:removeAllChildren()
    -- 清零筹码容器
    self._coinSprite = {}
end


-- 隐藏所有玩家状态
function GFlowerGameScene:hideAllPlayerStateUI()
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self.playerready[i]:setVisible(false)
        self.playerCallBg[i]:setVisible(false)
        self.playerCallAction[i]:setVisible(false)
        self.playerLook[i]:setVisible(false)
        self.playerLight[i]:setVisible(false)
        self.playercompare[i]:setVisible(false)
    end
end

-- 隐藏指定玩家的所有状态UI
function GFlowerGameScene:hidePlayrStateUI(client_id)
    self.playerready[client_id]:setVisible(false)
    self.playerCallBg[client_id]:setVisible(false)
    self.playerCallAction[client_id]:setVisible(false)
    self.playerLook[client_id]:setVisible(false)
    self.playerLight[client_id]:setVisible(false)
    self.playercompare[client_id]:setVisible(false)
end
---------------------------------------------------------------------------------------------------

-- 玩家准备
function GFlowerGameScene:On_Ready(tid)
    if tid == 0 then
        --self.jiesuan:setVisible(false)
        -- 禁用准备按钮
        self.btn_ready:setTouchEnabled(false)
        self.btn_ready:setBright(false)

        -- 玩家界面状态   
        self:UpdatePlayerStatus(1)

        --隐藏倒计时
        self.Txt_StartCountDown:setVisible(false)

        -- 影藏灯光
        self.rotateLight:setVisible(false)
        --print("--------------------------------------------玩家准备2")
    else
        -- 玩家界面状态
        self:UpdatePlayerStatus(tid)
        --print("--------------------------------------------玩家准备3")
    end
end


-- 游戏开始 霸底 发牌--
function GFlowerGameScene:On_GameStart(begin_chair)
    self.isReturnToHallScene = false

    -- 清除上一把残留的玩家
    self._logic:clearOutJieSuanPlayer()

    -- 开始按钮 隐藏 --
    self:setImageBeginVisible(false)
    
    self.jiesuan:setVisible(false)
   
    -- 隐藏所有玩家的状态UIr
    self:hideAllPlayerStateUI()

    -- 所有按钮 不可点击 --
    self:gfInitMeBtn(false)

    -- 设置轮数
    self:setLunshuStr(self._logic.roundNum)

    -- 设置底注
    self:setDiZhu()

    self.m_widget:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
            -- 初始化下排按钮

            -- 筹码飞入动画 --
            for k, player in pairs(self._logic.gfPlayers) do
                self:CoinFlyAction(player:getClientChairId(), self._logic.follow_num, 1)
            end
        end),
        cc.DelayTime:create(1),
        cc.CallFunc:create(function()
            -- 发牌动画 --
            self:gfInitCard(true)
        end)
    ))
end

-- 设置所有在场玩家底注
function GFlowerGameScene:setDiZhu()
    for idx, player in pairs(self._logic.gfPlayers) do
       local client_id = player:getClientChairId()
        -- 下注累积
        if player:getDownMoney() > 0 then
            self.playerxiazhu[client_id]:setString(CustomHelper.moneyShowStyleNone(player:getDownMoney()))
        end
    end
end

-- 隐藏所有手牌
function GFlowerGameScene:hideAllCard()
    for index, card_node in pairs(self.gf_cardChildNode) do
        card_node:setVisible(false)
    end
end

-- 中途进入玩家 显示某个玩家的手牌 --
function GFlowerGameScene:setPlayerCardVisible(_chairId)
    -- 获取该玩家的手牌位置
    local gf_temppos = self.playercardendPos[_chairId]
    -- 反正后面进入的玩家没有自己手牌 也看不到别人牌
    -- 所以这里只是按照一定规律模拟显示下手牌（和发牌的规律不一样）
    for i = 1, GFlowerConfig.CARD_COUNT do
        local _cardIndex = _chairId * GFlowerConfig.CARD_COUNT - GFlowerConfig.CARD_COUNT + i
        self.gf_cardChildNode[_cardIndex]:setPosition(cc.p(gf_temppos.x + i * 25, gf_temppos.y))

        if _chairId == 1 then
            self.gf_cardChildNode[_cardIndex]:setScale(GFlowerConfig.CARD_STAY_SCALE_ME)
        else
            self.gf_cardChildNode[_cardIndex]:setScale(GFlowerConfig.CARD_STAY_SCALE_OTHER)
        end
        self.player5_3Card[_chairId][i] = self.gf_cardChildNode[_cardIndex]
        self.player5_3Card[_chairId][i]:setVisible(true)
    end
end

--  隐藏某个玩家的手牌
function GFlowerGameScene:hidePlayerCard(client_id)
    for idx = 1, GFlowerConfig.CARD_COUNT do
        if self.player5_3Card[client_id] ~= nil and self.player5_3Card[client_id][idx] ~= nil then
            self.player5_3Card[client_id][idx]:setVisible(false)
        end
    end
end

-- 更新玩家信息
function GFlowerGameScene:setPlayerInfo(gfplayer)
    local chair = gfplayer:getClientChairId()
    self.playername[chair]:setString(gfplayer:getNickName())
    local p_money  = CustomHelper.moneyShowStyleNone(gfplayer:getMoney())
    print("GFlowerGameScene:setPlayerInfo ... NickName: "..gfplayer:getNickName().." Money: "..p_money.." Chair: "..gfplayer:getClientChairId())
    self.playergold[chair]:setString(p_money)
    self.playerhead[chair]:loadTexture(CustomHelper.getFullPath("hall_res/head_icon/"..(gfplayer:getHeadIconNum())..".png"))
    local  downMoney = gfplayer:getDownMoney()
    if downMoney == 0 then 
        self.playerxiazhu[chair]:setString("获取中")
    else
        self.playerxiazhu[chair]:setString(CustomHelper.moneyShowStyleNone(downMoney))
    end
    self.gf_player[chair]:setVisible(true)
end

-- 其他玩家进入
function GFlowerGameScene:On_NotifyPlayerEnter(gfplayer)
    self:setPlayerInfo(gfplayer)

    -- 玩家界面状态
    local client_id = gfplayer:getClientChairId()
    self:UpdatePlayerStatus(client_id)

    self.gf_player[client_id]:setVisible(true)
end

-- 自己进入
function GFlowerGameScene:On_PlayerEnter(gfplayer)
    self:setPlayerInfo(gfplayer)

    -- 玩家界面状态
    local client_id = gfplayer:getClientChairId()
    self:UpdatePlayerStatus(client_id)

    -- 按状态显示玩家手牌
    if self._logic.room_state == GFlowerConfig.ROOM_STATE.PLAY then
        for k, v in pairs(self._logic.gfPlayers) do
            if v:getGameState() ~= 0 then
                if v:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK
                or v:getGameState() == GFlowerConfig.PLAYER_STATUS.CONTROL 
                or v:getGameState() == GFlowerConfig.PLAYER_STATUS.DROP 
                or v:getGameState() == GFlowerConfig.PLAYER_STATUS.LOSE then
                    print("玩家id：",v:getClientChairId())
                    self:setPlayerCardVisible(v:getClientChairId())
                end
            end
        end
    end
end

-- 隐藏所有玩家手牌
function GFlowerGameScene:hideAllPlayersCard()
    -- 手牌记录容器清空
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self.player5_3Card[i] = {}
    end

    -- 隐藏所有手牌
    for index, card_1 in pairs(self.gf_cardChildNode) do
        card_1:setVisible(false)
    end
    
end

-- 别的玩家退出
function GFlowerGameScene:On_NotifyStandUp(client_chair)
    -- 如果有两个以上玩家准备
    if self._logic:getReadyPlayerNum() < 2 then
        self:setImageBeginVisible(false)
    end

    -- 隐藏退出玩家
    self.gf_player[client_chair]:setVisible(false)

    -- 隐藏玩家手牌
    self:hidePlayerCard(client_chair)

    -- 隐藏所有玩家状态信息 
    self:hidePlayrStateUI(client_chair)

    -- 如果是自己退出
    if client_chair == GFlowerConfig.CHAIR_SELF and self._logic.huanzhuo == false then
        --print("---------------------------进入时被服务器踢出----------------------------------")
        CustomHelper.showAlertView(
                    "开局前您没准备，请回到大厅重新进入!!",
                    false,
                    true,
                function(tipLayer)
                    GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                end,
                function(tipLayer)
                    GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
            end)
            return
    end
end


-- 玩家喊话气泡 -- ALL_IN  BI_PAI  GIVE_UP  FOLLOW  ADD_SCORE
function GFlowerGameScene:PlayerCall(client_id, action)

    local _imagePlayerCallBg = self.playerCallBg[client_id]
    local _imagePlayerCallAction = self.playerCallAction[client_id]

    local _playerCallStr = GFlowerConfig.IMAGE_PLAYER_CALL[action]
    if _playerCallStr then
        _imagePlayerCallBg:setVisible(true)
        _imagePlayerCallAction:setVisible(true)
        _imagePlayerCallAction:loadTexture(_playerCallStr)
        if action ~= "ALL_IN" then
            _imagePlayerCallBg:stopAllActions()
            _imagePlayerCallBg:runAction(cc.Sequence:create(
                cc.DelayTime:create(0.8),
                cc.CallFunc:create(function()
                    _imagePlayerCallBg:setVisible(false)
                    _imagePlayerCallAction:setVisible(false)
                    end)
                ))
        end
    end

    local gfPlayer = self._logic:getGFPlayerByClientId(client_id)
    -- 音效 玩家--
    local isMan = self:isMan(gfPlayer:getHeadIconNum())
    self._soundMgr:PlayEffect_PlayerSound(isMan, action)
end


function GFlowerGameScene:isMan(icon)
    if icon == nil then 
        return true
    end
        return icon > 5
end

-- 弃牌 返回
function GFlowerGameScene:On_ZhaJinHuaGiveUp(giveup_chair, next_chair)
    -- 玩家喊话气泡 -- ALL_IN  BI_PAI  GIVE_UP  FOLLOW  ADD_SCORE
    self:PlayerCall(giveup_chair, "GIVE_UP")
    
    -- 玩家界面状态
    self:UpdatePlayerStatus(giveup_chair)

    -- 关闭操作计时动画
    self:CloseDojishi(giveup_chair)
    -- 如果不是当前玩家在操作弃牌，不刷新倒计时动画
    --if giveup_chair == self._logic.doing_id then
    self:UsingDaojishi(self._logic.doing_id, GFlowerConfig.COUNT_DOWN_TIME)
    self:MoveLight(self._logic.doing_id)
    --end

    -- 刷新下排按钮
    self:UpdateMenuBtn()
end

-- 全下筹码飞入
function GFlowerGameScene:AllInScore(add_chair)
    for k, index in pairs(self._logic.AllInList) do
        self:CoinFlyAction(add_chair, index, 1)
    end
end

-- 加注 跟注 全下 返回
function GFlowerGameScene:On_ZhaJinHuaAddScore(add_chair, next_chair)

    -- 玩家喊话气泡 -- ALL_IN  BI_PAI  GIVE_UP  FOLLOW  ADD_SCORE
    if self._logic.is_AllIn then
        self:PlayerCall(add_chair, "ALL_IN")
    else
        if self._logic.is_add == true then
            self:PlayerCall(add_chair, "ADD_SCORE")
        else
            self:PlayerCall(add_chair, "FOLLOW")
        end
    end

    -- 如果是全下 计算飞出筹码 如果是自己在点击的时候飞筹码，其他玩家在收到消息的时候播放动画
    if add_chair ~= GFlowerConfig.CHAIR_SELF  then
        if self._logic.is_AllIn then
            self:AllInScore(add_chair)
        else
            -- 飞筹码 如果看牌了 需要跟双倍
            local lPlayer = self._logic:getGFPlayerByClientId(add_chair)
            if lPlayer:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK then
                self:CoinFlyAction(add_chair, self._logic.follow_num, 2)
            else
                self:CoinFlyAction(add_chair, self._logic.follow_num, 1)
            end
        end
    end

    self:CloseDojishi(add_chair)
    self:UsingDaojishi(self._logic.doing_id, GFlowerConfig.COUNT_DOWN_TIME)
    self:MoveLight(self._logic.doing_id)

    -- 刷新下排按钮
    self:UpdateMenuBtn()

    -- 如果选择了跟到底 且 当前轮到自己操作
    if self._logic.room_state == GFlowerConfig.ROOM_STATE.PLAY then
        if self._logic.gendaodi == true and self._logic.doing_id  == GFlowerConfig.CHAIR_SELF then
            -- 如果对方全压1
            if self._logic.is_AllIn == true then
                GFlowerGameManager:getInstance():send_CS_ZhaJinHuaShowHandScore(1)
                --print("-----------------跟到底 全压")
            else
                --print("-----------------跟到底 普通跟注")
                if self._logic.roundNum < 21 then
                    self.genDaoDiDelay = 1
                    self:removeScheduler()
                    self._scheduler = scheduler:scheduleScriptFunc(function(dt)
                                self:_onGenDaodiCountDown()
                                end, 1, false)
                end
            end
        end
    end
end

-- 弃牌设置牌为灰色
function GFlowerGameScene:setInvalidCard(chair_id, isInvalid)
    for index = 1, 3 do
        -- card 为服务器给的牌编号，对应资源图片
        if self.player5_3Card[chair_id][index] ~= nil then
            self.player5_3Card[chair_id][index]:setInvalid(isInvalid)
        end
    end
end

-- 把玩家牌设置为背面
function GFlowerGameScene:backPlayerCard(chair_id)
    for index = 1, 3 do
        if self.player5_3Card[chair_id][index] ~= nil then
            self.player5_3Card[chair_id][index]:setInvalid(true)
        end
    end
end

-- 翻开玩家的牌
function GFlowerGameScene:showPlayerCard(chair_id, card_list, needAction)

    for index, card_id in pairs(card_list) do
        -- card 为服务器给的牌编号，对应资源图片
        if self.player5_3Card[chair_id][index] ~= nil then
            self.player5_3Card[chair_id][index]:setContent(true, card_id, needAction)
        end
    end
end

-- 牌大小排序
function GFlowerGameScene:sortPlayerCard(card_list)

    --dump(card_list, "牌大小排序-----")
    for i = 1, 2 do
        if card_list[i] > card_list[i + 1] then
            local n = card_list[i]
            card_list[i] = card_list[i + 1]
            card_list[i + 1] = n
        end
    end

    if card_list[1] > card_list[2] then
        local n = card_list[1]
        card_list[1] = card_list[2]
        card_list[2] = n
    end
end

-- 自己看牌返回
function GFlowerGameScene:On_ZhaJinHuaLookCard(card_list)

    if card_list ~= nil then
        -- 排序
        self:sortPlayerCard(card_list)
        -- 自己本地的椅子id 被强制为1 
        self:showPlayerCard(GFlowerConfig.CHAIR_SELF, card_list, true)

        self:showCardAnimation(card_list)
    end

    -- 刷新下排按钮
    self:UpdateMenuBtn()
end

-- 特殊花色动画
function GFlowerGameScene:showCardAnimation(card_list)

    -- 点数排序
    local   point = {}
    point[1]    = math.floor(card_list[1]/4)
    point[2]    = math.floor(card_list[2]/4)
    point[3]    = math.floor(card_list[3]/4)
    table.sort(point)

    -- 取出花色
    local   huase_1   = math.fmod(card_list[1], 4)
    local   huase_2   = math.fmod(card_list[2], 4)
    local   huase_3   = math.fmod(card_list[3], 4)

    local playerInfo    = GameManager:getInstance():getHallManager():getPlayerInfo()
    local isMan         = self:isMan(playerInfo:getHeadIconNum())

    if point[1] == point[2] and point[1] == point[3] then
    -- 豹子
        self._soundMgr:PlayEffect_CardType(isMan, GFlowerConfig.CARD_TYPE.CT_BAO_ZI)

        self.Panel_PaiXin = self.m_widget:getChildByName("Panel_SpecialAnimation")
        local   cardType_Ani = self.Panel_PaiXin:getChildByTag(GFlowerConfig.PAIXIN_TAG)
        self.Panel_PaiXin:runAction(cc.Sequence:create(
        cc.CallFunc:create(function()
            self.Panel_PaiXin:setVisible(true)
            cardType_Ani:setVisible(true)
            cardType_Ani:getAnimation():play("ani_01")
        end),
        cc.DelayTime:create(GFlowerConfig.CARD_TYPE_BAOZI_ANI_TIME ),
        cc.CallFunc:create(function()
            self.Panel_PaiXin:setVisible(false)
            end)
        )) 
    
    elseif point[1] == point[2] or point[1] == point[3] or point[2] == point[3] then 
        -- 对子
        self._soundMgr:PlayEffect_CardType(isMan, GFlowerConfig.CARD_TYPE.CT_DOUBLE)

        self.Panel_PaiXin = self.m_widget:getChildByName("Panel_SpecialAnimation")
        local   cardType_Ani = self.Panel_PaiXin:getChildByTag(GFlowerConfig.PAIXIN_TAG)
        self.Panel_PaiXin:runAction(cc.Sequence:create(
        cc.CallFunc:create(function()
            self.Panel_PaiXin:setVisible(true)
            cardType_Ani:setVisible(true)
            cardType_Ani:getAnimation():play("ani_05")
        end),
        cc.DelayTime:create(GFlowerConfig.CARD_TYPE_DUIZI_ANI_TIME ),
        cc.CallFunc:create(function()
            self.Panel_PaiXin:setVisible(false)
            end)
        )) 
    else
        if huase_1 == huase_2 and huase_2 == huase_3 then
            if point[1]+1 == point[2] and point[1] + 2 == point[3] then
                --顺金
                self._soundMgr:PlayEffect_CardType(isMan, GFlowerConfig.CARD_TYPE.CT_SHUN_JIN)

                self.Panel_PaiXin = self.m_widget:getChildByName("Panel_SpecialAnimation")
                local   cardType_Ani = self.Panel_PaiXin:getChildByTag(GFlowerConfig.PAIXIN_TAG)
                self.Panel_PaiXin:runAction(cc.Sequence:create(
                cc.CallFunc:create(function()
                    self.Panel_PaiXin:setVisible(true)
                    cardType_Ani:setVisible(true)
                    cardType_Ani:getAnimation():play("ani_02")
                end),
                cc.DelayTime:create(GFlowerConfig.CARD_TYPE_SHUNJIN_ANI_TIME ),
                cc.CallFunc:create(function()
                    self.Panel_PaiXin:setVisible(false)
                    end)
                )) 

            else
                --金花
                self._soundMgr:PlayEffect_CardType(isMan, GFlowerConfig.CARD_TYPE.CT_JIN_HUA)

                self.Panel_PaiXin = self.m_widget:getChildByName("Panel_SpecialAnimation")
                local   cardType_Ani = self.Panel_PaiXin:getChildByTag(GFlowerConfig.PAIXIN_TAG)
                self.Panel_PaiXin:runAction(cc.Sequence:create(
                cc.CallFunc:create(function()
                    self.Panel_PaiXin:setVisible(true)
                    cardType_Ani:setVisible(true)
                    cardType_Ani:getAnimation():play("ani_03")
                end),
                cc.DelayTime:create(GFlowerConfig.CARD_TYPE_JINHUA_ANI_TIME ),
                cc.CallFunc:create(function()
                    self.Panel_PaiXin:setVisible(false)
                    end)
                )) 
            end
        else
           if point[1]+1 == point[2] and point[1] + 2 == point[3] then
               -- 顺子
               self._soundMgr:PlayEffect_CardType(isMan, GFlowerConfig.CARD_TYPE.CT_SHUN_ZI)

               self.Panel_PaiXin = self.m_widget:getChildByName("Panel_SpecialAnimation")
               local   cardType_Ani = self.Panel_PaiXin:getChildByTag(GFlowerConfig.PAIXIN_TAG)
               self.Panel_PaiXin:runAction(cc.Sequence:create(
               cc.CallFunc:create(function()
                   self.Panel_PaiXin:setVisible(true)
                   cardType_Ani:setVisible(true)
                   cardType_Ani:getAnimation():play("ani_04")
               end),
               cc.DelayTime:create(GFlowerConfig.CARD_TYPE_SHUNZI_ANI_TIME ),
               cc.CallFunc:create(function()
                   self.Panel_PaiXin:setVisible(false)
                   end)
               )) 
           end
        end
    end
end

-- 比牌返回
function GFlowerGameScene:On_ZhaJinHuaCompareCard(cur_id, win_id, lost_id)

    -- 玩家喊话气泡 -- ALL_IN  BI_PAI  GIVE_UP  FOLLOW  ADD_SCORE
    self:PlayerCall(self._logic.doing_id, "BI_PAI")

    -- 隐藏比牌按钮
    self:isVisibleCompareBtn(false)

    -- 飞筹码 比牌需要 * 2筹码
    self:CoinFlyAction(self._logic.doing_id, self._logic.follow_num, 2)

    -- 比牌动画
    print("On_ZhaJinHuaCompareCard!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    self:CompareCard(cur_id, win_id, lost_id)
end

-- 游戏结束
function GFlowerGameScene:On_ZhaJinHuaEnd()
    -- 记录结果
    self.win_id         = self._logic:getLocalChairId(self._logic.win_chair_id)
    self.player_Endlist = self._logic.player_end_list
    self.tax            = self._logic.tax
    self.isPlayFlyOutAction = false

    -- 关闭所有操作倒计时动画
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self:CloseDojishi(i)
    end

    -- 设置所有按钮不可点击
    self:gfInitMeBtn(false)

    -- 跟到底显示为 否
    self._logic.gendaodi = false
    self.Image_FollowDiFlag:setVisible(false)

    --全场比牌
    if self._logic.all_Compare then
        print("GFlowerGameScene:On_ZhaJinHuaEnd() !!!!!!!!!!!!!!!!!!!")
        self:OpenCardAni()
    else
        -- 如果比牌动画还没结束
        if self.is_compare == false then
            self:endOpenCardAni()
        end
    end
end

-- 筹码 飞出 --
function GFlowerGameScene:CoinFlyOutAction(chairId)
    if self.isPlayFlyOutAction == false then
        local _pos = GFlowerConfig.PLAYER_LOCATION[chairId]
        local _delayTime = 0
        local coinAllNum = table.getn(self._coinSprite);
        local unitCoinTime = 2.0/coinAllNum
        for k, _coinSprite in pairs(self._coinSprite) do
            if _coinSprite and not tolua.isnull(_coinSprite) then
                _delayTime = _delayTime + 0.03
                _coinSprite:runAction(cc.Sequence:create(
                    cc.DelayTime:create(_delayTime),
                    cc.MoveTo:create(unitCoinTime, _pos),
                    cc.CallFunc:create(function()
                        --_coinSprite:setVisible(false)
                        -- 从父节点和表中删除
                        table.remove(self._coinSprite, k)
                        _coinSprite:removeFromParent()
                    end)
                    ))
            end
        end

        -- 播放赢家动画
        local ani_win = self.gf_player[chairId]:getChildByTag(GFlowerConfig.WIN_TAG)
        if ani_win == nil then
            ani_win = ccs.Armature:create("zjh_paixin_eff")
            self.gf_player[chairId]:addChild(ani_win)
            ani_win:setLocalZOrder(50)
            ani_win:setTag(GFlowerConfig.WIN_TAG)
            ani_win:setPosition(60, 60)
        end
        ani_win:setVisible(true)
        ani_win:getAnimation():play("ani_06")

        --_delayTime = _delayTime + 4 - unitCoinTime*0.03
        -- 音效 筹码飞出 --
        self._soundMgr:PlayEffect_CoinFlyOut()
        self.isPlayFlyOutAction = true
    end
end

function GFlowerGameScene:onGameOver()
    -- 本局结束，在下面处理
    self.m_widget:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.8),
        cc.CallFunc:create(handler(self, self.showJieSuanPanel))
        ))
end


---倒计时刷新 GFlowerConfig.READY_TIME
function GFlowerGameScene:_onInterval()

    self.Txt_StartCountDown:setString(self.ready_timeNum.."S")
    self.ready_time:setString(self.ready_timeNum.."S")
    self.ready_timeNum = self.ready_timeNum - 1
    
    if self.ready_timeNum <= -1 then
        self.Txt_StartCountDown:setVisible(false)
        self.ready_time_di:setVisible(false)
        if self._scheduler ~= nil then
            self:removeScheduler()
        end
		if self:isContinueGameConditions() == true then
			--判断是否勾选自动准备
			if self.autoreadyImage:isVisible() then
				self:dealJieSuanReady()
				--关闭结算界面
				self.jiesuan:setVisible(false)
			else
				GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
			end
		end
        --判断是否勾选自动准备
        -- if self.autoreadyImage:isVisible() then
        --    self:dealJieSuanReady()
            --关闭结算界面
        --    self.jiesuan:setVisible(false)
        --else
        --    GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
        --end
    end
end

function GFlowerGameScene:startCountDown(CountDown)

    self:setImageBeginVisible(true)
    self.Txt_StartCountDown:setVisible(true)
    self.ready_timeNum = CountDown
    self.Txt_StartCountDown:setString(self.ready_timeNum.."S")
    self.ready_time:setString(self.ready_timeNum.."S")

    self:removeScheduler()
    self:_onInterval()
    self._scheduler = scheduler:scheduleScriptFunc(function(dt)
                self:_onInterval()
                end, 1, false);
end

function GFlowerGameScene:_onGenDaodiCountDown()
    self.genDaoDiDelay = self.genDaoDiDelay - 1
    if self.genDaoDiDelay <= -1 then
       local lPlayer = self._logic:getGFPlayerByClientId(GFlowerConfig.CHAIR_SELF)
        if lPlayer:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK then
            self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, self._logic.follow_num, 2)
        else
            self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, self._logic.follow_num, 1)
        end
        GFlowerGameManager:getInstance():send_CS_ZhaJinHuaAddScore(GFlowerConfig.ADD_BTN_TIMES[self._logic.follow_num] * self._logic.MinJetton )
        if self._scheduler ~= nil then
            self:removeScheduler()
        end
    end
end

-- 清除主界面信息
function GFlowerGameScene:clearMainTableUI()
    self:isVisibleCompareBtn(false)

    -- 清除桌面UI
    self:resetMainTableUI()

    -- 隐藏所有玩家的状态UI
    self:hideAllPlayerStateUI()

    -- 隐藏所有玩家手牌
    self:hideAllPlayersCard()

    -- 清除赢家动画
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        local ani_win = self.gf_player[i]:getChildByTag(GFlowerConfig.WIN_TAG)
        if ani_win ~= nil then
            ani_win:setVisible(false)
            ani_win:removeFromParent()
        end
    end
end

-- 清除结算界面信息
function GFlowerGameScene:clearJieSuanPanelInfo()
   -- 启用准备按钮
    self.btn_ready:setTouchEnabled(true)
    self.btn_ready:setBright(true)
    self.readyImage:loadTexture(GFlowerConfig.IMAGE_JIESUAN.READY_ENABLE)
    self.ready_time_di:setVisible(true)

    MyToastLayer.new(self, "倒计时结束前，您还没准备将返回大厅！")

    -- 首先设置 所有位置为空
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        -- 获取控件
        local playerUI1 = self.jiesuan:getChildByName("player"..i)
        local Image_null1 = playerUI1:getChildByName("Image_null")
        local Panel_Player1 = playerUI1:getChildByName("Panel_Player")
        Image_null1:setVisible(true)
        Panel_Player1:setVisible(false)

        -- 隐藏赢家动画
        local jiesuan_winAni1 = playerUI1:getChildByTag(GFlowerConfig.WIN_TAG)
        if jiesuan_winAni1 ~= nil then
            jiesuan_winAni1:setVisible(false)
            jiesuan_winAni1:removeFromParent()
        end
    end
end

function GFlowerGameScene:setJieSuanPanelInfo()
    local Image_Self = self.jiesuan:getChildByName("Image_Self")
    local Image_self_light = self.jiesuan:getChildByName("Image_self_light")
    Image_Self:setVisible(false)
    Image_self_light:setVisible(false)
    -- 再根据结果设置结算界面信息
    local  index = 1
    dump(self.player_Endlist,"self.player_Endlist")
    for k, player in pairs(self.player_Endlist) do
   
        local card_list = player.cards
        if card_list ~= nil then
            -- 排序
            self:sortPlayerCard(card_list)
            local playerName       = player.name
            local playerHead       = player.header_icon
            local playerDownMoney  = 0
            local playerState      = player.status

            local gfplayer   = self._logic:getGFPayerByGuid(player.guid)
            if gfplayer == nil then
                 local outplayer  = self._logic:getOutJieSuanPlayerByGuid(player.guid)
                 if outplayer ~= nil then 
                    playerDownMoney   = outplayer["downMoney"] 
                 end
            else
                 playerDownMoney   = gfplayer:getDownMoney()
            end
            if playerHead == 0 or playerHead == nil then
                playerHead = 1  --默认头像为1
            end

            -- 把服务器id 转换为 本地id
            local client_chair_id = self._logic:getLocalChairId(player.chair_id)

            -- 获取控件
            local playerUI = self.jiesuan:getChildByName("player"..client_chair_id)
            local Image_null = playerUI:getChildByName("Image_null")
            local Panel_Player = playerUI:getChildByName("Panel_Player")
            Image_null:setVisible(false)
            Panel_Player:setVisible(true)

            -- 玩家状态 淘汰 或者 弃牌
            local Image_caozuo = Panel_Player:getChildByName("Image_caozuo")
            Image_caozuo:setVisible(false)

            -- 玩家名字
            local name = Panel_Player:getChildByName("name")
            name:setString(playerName)

            -- 玩家头像
            local headicon = Panel_Player:getChildByName("headicon")
            headicon:loadTexture(CustomHelper.getFullPath("hall_res/head_icon/"..playerHead..".png"))

            -- 输赢分数
            local score = player.score

            -- 底注服务器没加...所以没跟注的玩家不返回这个值
            if score == nil then
                score = self._logic.MinJetton
            end
            -- 赢
            local Image_winer = Panel_Player:getChildByName("Image_winer")
            -- 输
            local Image_lost = Panel_Player:getChildByName("Image_126")
            if client_chair_id == self.win_id then
                -- 是否显示税收设置 self._logic.is_shuishou
                if self._logic.is_shuishou then
                    Image_lost:setVisible(false)
                    Image_winer:setVisible(true)
                    local win_num = Image_winer:getChildByName("icon")
                    local tax = Image_winer:getChildByName("tax")
                    
                    win_num:setString(""..(score - playerDownMoney)/ CustomHelper.goldToMoneyRate())
                    tax:setString(""..self.tax / CustomHelper.goldToMoneyRate())
                else
                    Image_lost:setVisible(true)
                    Image_winer:setVisible(false)
                    local score_num = Image_lost:getChildByName("icon")
                    score_num:setString(""..(score - playerDownMoney) / CustomHelper.goldToMoneyRate())
                end

                -- 按牌编号显示牌
                for k1, num in pairs(card_list) do
                    if k1 ~= -1 then
                        local poker = Panel_Player:getChildByName("poker"..k1)
                        local pokername = "games/gflower/res/gpoker/poker_" ..num.. ".png"
                        poker:loadTexture(pokername)
                   else
                        local poker = Panel_Player:getChildByName("poker"..k1)
                        poker:loadTexture(GFlowerConfig.POKER.BACK_NORMAL)
                   end
                end

                -- 自己标志 和 背光
                if client_chair_id == GFlowerConfig.CHAIR_SELF then
                    -- 自己标志 和 背光
                    Image_Self:setVisible(true)
                    Image_self_light:setVisible(true)
                end

                -- 显示播放赢家动画
                local jiesuan_winAni = playerUI:getChildByTag(GFlowerConfig.WIN_TAG)
                if jiesuan_winAni == nil then
                    jiesuan_winAni = ccs.Armature:create("zjh_paixin_eff")
                    playerUI:addChild(jiesuan_winAni)
                    jiesuan_winAni:setLocalZOrder(10)
                    jiesuan_winAni:setTag(GFlowerConfig.WIN_TAG)
                    jiesuan_winAni:setScale(0.8)
                    jiesuan_winAni:setPosition(100, 40)
                end
                jiesuan_winAni:setVisible(true)
                jiesuan_winAni:getAnimation():play("ani_07")
 
            else
                Image_lost:setVisible(true)
                Image_winer:setVisible(false)
                local score_num = Image_lost:getChildByName("icon")
                score_num:setString(""..score / CustomHelper.goldToMoneyRate())

                Image_caozuo:setVisible(true)
                --默认为弃牌 否则为淘汰
                local caozuo_file = "games/gflower/res/csb/game_res/zjh_wanjia_qp.png"
                if playerState == GFlowerConfig.PLAYER_STATUS.LOSE then
                    caozuo_file = "games/gflower/res/csb/game_res/zjh_wanjia_tt.png"
                end

                -- 如果是自己 就翻开 
                if client_chair_id == GFlowerConfig.CHAIR_SELF then
                    -- 玩家的牌 card_list[1]  2  3
                    for k1, num in pairs(card_list) do
                        if num ~= -1 then
                            local poker = Panel_Player:getChildByName("poker"..k1)
                            local pokername = "games/gflower/res/gpoker/poker_" ..num.. ".png"
                            poker:loadTexture(pokername)
                        else
                            local poker = Panel_Player:getChildByName("poker"..k1)
                            poker:loadTexture(GFlowerConfig.POKER.BACK_NORMAL)
                        end
                    end

                    -- 自己标志 和 背光
                    Image_Self:setVisible(true)
                    Image_self_light:setVisible(true)
                else
                    -- 别人的牌以服务器发过来的为准
                    for k1, num in pairs(card_list) do
                        if num ~= -1 then
                            local poker = Panel_Player:getChildByName("poker"..k1)
                            local pokername = "games/gflower/res/gpoker/poker_" ..num.. ".png"
                            poker:loadTexture(pokername)
                        else
                            local poker = Panel_Player:getChildByName("poker"..k1)
                            poker:loadTexture(GFlowerConfig.POKER.BACK_NORMAL)
                        end
                    end
                end

                Image_caozuo:loadTexture(caozuo_file)
            end
        end
        --print("index========="..client_chair_id)
    end
end

-- 更新结算界面
function GFlowerGameScene:showJieSuanPanel()
    -- 启动结算界面不准备倒计时 
    --[[if self._logic.huanzhuo == false then
        self._logic.huanzhuo = true
    else
        self.jiesuan:setVisible(false)
        return
    end ]]--

    -- 倒计时转圈动画
    self:Using_jiesuan_Daojishi(self.countDown)

    -- 清除结算界面信息
    self:clearJieSuanPanelInfo()

    -- 设置结算界面为可见
    self.jiesuan:setVisible(true)

    -- 设置结算界面信息
    self:setJieSuanPanelInfo()

    -- 游戏结束设置所有玩家状态为 站起
    self._logic:setAllPlayerState(GFlowerConfig.PLAYER_STATUS.STAND)

    -- 结算界面出来后再把钱给赢家加上
    self:updateEndMoney()
    
    -- 清除主界面UI属性
    self:clearMainTableUI()

    -- 清除临时的结果数据
    self.win_id = nil
    self.player_Endlist = nil
    self.tax = nil

    -- 如果玩家金币已经不足 强制退出
    local playerSelf = self._logic:getGfPlayers()[self._logic.myServerChairId]
    if playerSelf:getMoney() - self._logic.MinJettonMoney < 0 then
        CustomHelper.showAlertView(
                    "金额不足,退回到大厅!!!",
                    false,
                    true,
                function(tipLayer)
                    --GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                    self:returnToHallScene();
                end,
                function(tipLayer)
                    --GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
                    self:returnToHallScene();
            end)
        return
    end
end

function GFlowerGameScene:updateEndMoney()
    --print("sx++++++++++++++++++++++++++赢家加钱结算1")
    -- 赢家加钱
    local win_id = self._logic:getLocalChairId(self._logic.win_chair_id)
    for k, player in pairs(self._logic.player_end_list) do

        if player.chair_id == self._logic.win_chair_id then
            local gfPlayer = self._logic:getGfPlayers()[self._logic.win_chair_id]
            if gfPlayer ~= nil then
                local money = gfPlayer:getMoney()
                money = money + player.score
                gfPlayer:setMoney(money)

                self:On_UpdatePlayerMoney(gfPlayer)
            end
            break
        end
    end
end

---------------------------------------------------------------------------------------------------
-- 游戏操作按钮 状态切换 --
function GFlowerGameScene:BtnControlModel(b_name, b_click)

    local _controlBtn = self._controlMenu[b_name]["Button"]
    local _controlImage = self._controlMenu[b_name]["Image"]
    if _controlBtn and _controlImage then
        if b_click then
            _controlBtn:setEnabled(true)
            _controlBtn:setTouchEnabled(true)
            _controlBtn:setBright(true)
            _controlImage:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN[b_name][1])
        else
            _controlBtn:setEnabled(false)
            _controlBtn:setTouchEnabled(false)
            _controlBtn:setBright(false)
            _controlImage:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN[b_name][2])
        end
    end
end

-- 初始化自己的所有按钮
function GFlowerGameScene:gfInitMeBtn(btouch)
    if btouch then
        for k, v in pairs(self._controlMenu) do
            self:BtnControlModel(k, true)
        end
    else
        for k, v in pairs(self._controlMenu) do
            self:BtnControlModel(k, false)
        end
    end
    self.Panel_Btn_Menu:setVisible(true)
    self.Panel_JettonZone:setVisible(false)
end

-- 如果是自己 更新按钮状态
function GFlowerGameScene:UpdateMenuBtn()
    self:gfInitMeBtn(false)

    local lPlayer = self._logic:getGFPlayerByClientId(GFlowerConfig.CHAIR_SELF)

    if self._logic.room_state == GFlowerConfig.ROOM_STATE.PLAY then
        self:BtnControlModel("GIVE_UP", true)

        --如果是看牌按钮 必须要过了第一轮才能看牌
        if self._logic.isSelfLookCard == false and self._logic.roundNum > 1 then
            self:BtnControlModel("LOOK_CARD", true)
        end

        -- 自己的本地id默认为1，如果是自己
        if self._logic.doing_id == GFlowerConfig.CHAIR_SELF then

            -- 如果对方已经全压，只能让玩家操作弃牌、全压、看牌
            if self._logic.is_AllIn == true then
                self:BtnControlModel("ALL_IN", true)
            -- 否则正常处理按钮
            else
                -- 场上剩下只两个玩家 且 回合超过1 才能全下
                print("UpdateMenuBtn.  GetPlayingNum: ",self._logic:getPlayingNum()," RoundNum: ", self._logic.roundNum)
                if self._logic:getPlayingNum() == 2 and self._logic.roundNum > 1 then
                    local playerSelf = self._logic:getGfPlayers()[self._logic.myServerChairId]
                    if playerSelf:getMoney() > GFlowerConfig.ADD_BTN_TIMES[5] * self._logic.MinJetton then
                        self:BtnControlModel("ALL_IN", true)
                    end
                end

                self:BtnControlModel("FOLLOW", true)
                self:BtnControlModel("ADD_SCORE", true)

                -- 加注已经到顶
                if self._logic.follow_num >= 5 then
                    self:BtnControlModel("ADD_SCORE", false)
                end

                --如果是看牌按钮 必须要过了第一轮才能看牌
                if self._logic.roundNum >= 2 then
                    self:BtnControlModel("BI_PAI", true)
                end

                -- 玩家已经看牌 和 没看牌情况
                if lPlayer:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK then
                    -- 玩家剩余金额 不足 或者 等于 当前跟注金额 不允许加注和跟注了 只能比牌和全压
                    if lPlayer:getMoney() - self._logic.follow_money * 2 <= GFlowerConfig.ADD_BTN_TIMES[5] * self._logic.MinJetton * 2 then
                        self:BtnControlModel("FOLLOW", false)
                        self:BtnControlModel("ADD_SCORE", false)

                        -- 跟到底处理
                        self._logic.gendaodi = false
                        self.Image_FollowDiFlag:setVisible(false)
                        MyToastLayer.new(self, "剩余金币已经不足以继续跟注")
                    end
                else
                    -- 玩家剩余金额 不足 或者 等于 当前跟注金额 不允许加注和跟注了 只能比牌和全压
                    if lPlayer:getMoney() - self._logic.follow_money <= GFlowerConfig.ADD_BTN_TIMES[5] * self._logic.MinJetton * 2 then
                        self:BtnControlModel("FOLLOW", false)
                        self:BtnControlModel("ADD_SCORE", false)

                        -- 跟到底处理
                        self._logic.gendaodi = false
                        self.Image_FollowDiFlag:setVisible(false)
                        MyToastLayer.new(self, "剩余金币已经不足以继续跟注")
                    end
                end
            end
        end

        -- 如果是 弃牌 淘汰 观战
        local state = lPlayer:getGameState()
        if state == GFlowerConfig.PLAYER_STATUS.DROP
        or state == GFlowerConfig.PLAYER_STATUS.LOSE
        or state == GFlowerConfig.PLAYER_STATUS.STAND
        then
            self:gfInitMeBtn(false)
        end
    end
end

-- 更新轮数文本
function GFlowerGameScene:On_updateLunshuStr(client_id)
    local add_round = true
    local round = self._logic.roundNum + 1
    for k, v in pairs(self._logic.gfPlayers) do
        local state   = v:getGameState()
        if state == GFlowerConfig.PLAYER_STATUS.CONTROL or
           state == GFlowerConfig.PLAYER_STATUS.LOOK then
            -- 不和自己比
            if v:getClientChairId() ~= client_id then
                -- 如果该玩家轮数+1后 有存活的玩家和该玩家轮数不等 说明这轮还没结束
                local num = v:getRoundNum()
                if round ~= num then
                    add_round = false
                    break
                end
            end
        end
    end
    
    if add_round == true then
        self._logic.roundNum = self._logic.roundNum + 1
        if self._logic.roundNum < 21 then
            if self.Label_Lunshu then
                self.Label_Lunshu:setString(""..self._logic.roundNum)
            end
        end
    end
end

-- 更新玩家金币数量
function GFlowerGameScene:On_UpdatePlayerMoney(gfplayer)
    local client_id = gfplayer:getClientChairId()
    -- 金币
    self.playergold[client_id]:setString(CustomHelper.moneyShowStyleNone(gfplayer:getMoney()))

    -- 下注累积
    if gfplayer:getDownMoney() > 0 then
        self.playerxiazhu[client_id]:setString(CustomHelper.moneyShowStyleNone(gfplayer:getDownMoney()))
    end
end

-- 更新桌面总注 单注大小
function GFlowerGameScene:On_UpdateDeskMoney(follow_num, all_money)
    -- 单注大小
    self.Text_danzhu:setString(""..follow_num/CustomHelper.goldToMoneyRate())

    -- 桌面总注
    self.Text_zongzhu:setString(""..all_money/CustomHelper.goldToMoneyRate())
end

function GFlowerGameScene:setLunshuStr(num)
    if self.Label_Lunshu then
        self.Label_Lunshu:setString(""..num)
    end
end

function GFlowerGameScene:setComparePlayerInfo(name_win, money_win, name_lost, money_lost, icon_win, icon_lost)

    local _comparePanel = self.compare
    -- 玩家上
    local _playerUp = _comparePanel:getChildByName("Player_Up")
    -- 名字
    local name = _playerUp:getChildByName("name")
    --name:setTextAreaSize(cc.size(120, 20))
    name:setString(name_win)
    -- 金钱
    local num = _playerUp:getChildByName("Label_GoldNum")
    local p_Money = CustomHelper.moneyShowStyleNone(money_win)
    num:setString(""..p_Money)
    -- 头像
    local headicon = _playerUp:getChildByName("headicon")
    local tPlayer = self._logic:getGFPlayerByClientId(icon_win)
    headicon:loadTexture(CustomHelper.getFullPath("hall_res/head_icon/"..(tPlayer:getHeadIconNum())..".png"))

    -- 玩家下
    local _playerDown = _comparePanel:getChildByName("Player_Down")
    -- 名字
    local name_d = _playerDown:getChildByName("name")
    --name_d:setTextAreaSize(cc.size(120, 20))
    name_d:setString(name_lost)
    -- 金钱
    local num_d = _playerDown:getChildByName("Label_GoldNum")
    p_Money = CustomHelper.moneyShowStyleNone(money_lost)
    num_d:setString(""..p_Money)
    -- 头像
    local headicon_d = _playerDown:getChildByName("headicon")
    local bPlayer = self._logic:getGFPlayerByClientId(icon_lost)
    headicon_d:loadTexture(CustomHelper.getFullPath("hall_res/head_icon/"..(bPlayer:getHeadIconNum())..".png"))
end


-- 比牌 --
function GFlowerGameScene:CompareCard(cur_id, win_id, lost_id)
    -- 比牌动画设置为正在进行
    self.is_compare = true

    -- 按钮控制关闭 --
    self:gfInitMeBtn(false)

    -- 比牌主界面飞出动画 --
    local _moveTime = 0.5
    local _scaleCount = GFlowerConfig.CARD_COMPARE_SCALE
    local _comparePanel = self.compare
    _comparePanel:setVisible(true)

    -- 玩家上 和 玩家下
    local _playerUp = _comparePanel:getChildByName("Player_Up")
    local _playerDown = _comparePanel:getChildByName("Player_Down")
    -- vs 图片
    local _spriteVS = _comparePanel:getChildByName("Image_9"):getChildByName("Image_10")
    _spriteVS:setVisible(true)

    local _upPos = {
        x = _playerUp:getPositionX(),
        y = _playerUp:getPositionY()
    }
    local _downPos = {
        x = _playerDown:getPositionX(),
        y = _playerDown:getPositionY()
    }
    _playerUp:setPosition(-500, _upPos.y)
    _playerDown:setPosition(1500, _downPos.y)
    _playerUp:runAction(cc.MoveTo:create(0.3, _upPos))
    _playerDown:runAction(cc.MoveTo:create(0.3, _downPos))

    -- 手牌动画     self.player5_3Card
    local _upCardPos = {}
    local _downCardPos = {}
    local _upCardZOrder = {}
    local _downCardZOrder = {}
    local _upCardScale = {}
    local _downCardScale = {}
    local _upCardRotation = {}
    local _downCardRotation = {}
    for i = 1, GFlowerConfig.CARD_COUNT do
        --上 赢家
        local _upCardSprite = self.player5_3Card[win_id][i]
        _upCardZOrder[i] = _upCardSprite:getLocalZOrder()
        _upCardPos[i] = {
            x = _upCardSprite:getPositionX(),
            y = _upCardSprite:getPositionY()
        }
        _upCardScale[i] = _upCardSprite:getScale()
        _upCardRotation[i] = _upCardSprite:getRotation()
        _upCardSprite:setLocalZOrder(_upCardZOrder[i] + GF_ADD_ZORDER)
        local _aimPos = cc.p(_upPos.x + 30*(i-1) + 350, _upPos.y + 25)
        _upCardSprite:stopAllActions()
        _upCardSprite:runAction(cc.Spawn:create(
            cc.MoveTo:create(_moveTime, _aimPos),
            cc.ScaleTo:create(_moveTime, _scaleCount),
            cc.RotateTo:create(_moveTime, 0)
            ))

        -- 下 输家
        local _downCardSprite = self.player5_3Card[lost_id][i]
        _downCardZOrder[i] = _downCardSprite:getLocalZOrder()
        _downCardPos[i] = {
            x = _downCardSprite:getPositionX(),
            y = _downCardSprite:getPositionY()
        }
        _downCardScale[i] = _downCardSprite:getScale()
        _downCardRotation[i] = _downCardSprite:getRotation()
        _downCardSprite:setLocalZOrder(_downCardZOrder[i] + GF_ADD_ZORDER)
        _aimPos = cc.p(_downPos.x + 30*(i-1) + 320, _downPos.y + 25)
        _downCardSprite:stopAllActions()
        _downCardSprite:runAction(cc.Spawn:create(
            cc.MoveTo:create(_moveTime, _aimPos),
            cc.ScaleTo:create(_moveTime, _scaleCount),
            cc.RotateTo:create(_moveTime, 0)
            ))
    end

    -- 显示自己玩家的牌
    local function showCard()
        -- 自己本地的椅子id 被强制为1 

        -- -- 测试翻牌
        -- local card_list = {}
        -- card_list[1] = 2
        -- card_list[2] = 2
        -- card_list[3] = 2

        -- -- 如果自己参与了比牌 才会翻开自己的牌
        -- -- 除自己外的人比牌都不翻开
        -- if win_id == 1 then
        --     self:showPlayerCard(win_id, card_list)
        -- elseif lost_id == 1 then
        --     self:showPlayerCard(lost_id, card_list)
        -- end
	end

    -- 闪电 --
    local _compareAni = _comparePanel:getChildByTag(GF_COMPARE_ANI_TAG)
    local _compareAni2 = _comparePanel:getChildByTag(GF_COMPARE_ANI_TAG + 100)
    local function callfunc1()
        _spriteVS:setVisible(true)
        if not _compareAni then
            _compareAni = ccs.Armature:create("zjh_vs_xb_eff")
            _compareAni:setTag(GF_COMPARE_ANI_TAG)
            _compareAni:setPosition(330, 360)
            _compareAni:setLocalZOrder(5)
            _comparePanel:addChild(_compareAni)
        end
        if not _compareAni2 then
            _compareAni2 = ccs.Armature:create("zjh_vs_xb_eff")
            _compareAni2:setTag(GF_COMPARE_ANI_TAG + 100)
            _compareAni2:setPosition(330, 360)
            _compareAni2:setLocalZOrder(5)
            _comparePanel:addChild(_compareAni2)
            _compareAni2:setVisible(false)
        end
        local _compare_name = "ani_04"
        local _time_num = 0.5
        --if not _upPlayer:IsEliminate() then
            --_compare_name = "ani_05"
        --end
        --if isfanpai then
            _compare_name = "ani_02"
            --if not _upPlayer:IsEliminate() then
                --_compare_name = "ani_03"
            --end
            _time_num = 1
        --end
        _comparePanel:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                _compareAni:setVisible(true)
                _compareAni:getAnimation():play("ani_01")
            end),
            cc.DelayTime:create(_time_num),
            cc.CallFunc:create(function()
                _compareAni2:setVisible(true)
                -- 音效 闪电 --
                self._soundMgr:PlayEffect_Compare()

                _compareAni2:getAnimation():play(_compare_name)
                end)
            ))

        -- 如果自己没看过牌 翻开自己的牌
        if self._logic.lost_cards ~= nil then
            if self._lookCard == 1 then
                self:sortPlayerCard(self._logic.lost_cards)
                self:showPlayerCard(lost_id, self._logic.lost_cards, false)
            end
        end

        -- 如果游戏结束 翻开两家的牌
        if self._logic.room_state ~= GFlowerConfig.ROOM_STATE.PLAY then
            --print("--------------比牌时游戏结束")
            for k, player in pairs(self.player_Endlist) do
                local card_list = player.cards
                if card_list ~= nil then

                    -- 如果比牌玩家中有自己 并且已经看过牌 才展示牌
                    if win_id == GFlowerConfig.CHAIR_SELF or lost_id == GFlowerConfig.CHAIR_SELF then
                        local client_chair_id = self._logic:getLocalChairId(player.chair_id)
                        if win_id == client_chair_id then
                            if self._lookCard == 1 then
                                self:sortPlayerCard(card_list)
                                self:showPlayerCard(win_id, card_list, false)
                            end
                        end

                        if lost_id == client_chair_id then
                            if self._lookCard == 1 then
                                self:sortPlayerCard(card_list)
                                self:showPlayerCard(lost_id, card_list, false)
                            end
                        end 
                    end
                end
            end
        end
    end

    -- 输赢 --
    local _aniUpResult = _comparePanel:getChildByTag(GF_UP_RES_ANI)
    local _aniDownResult = _comparePanel:getChildByTag(GF_DOWN_RES_ANI)
    local function callfunc2()

        -- 上 赢家
        if not _aniUpResult then
            _aniUpResult = ccs.Armature:create("zjh_vs_eff")
            _aniUpResult:setPosition(400, 80)
            _aniUpResult:setTag(GF_UP_RES_ANI)
            _playerUp:addChild(_aniUpResult)
        end

        -- 下 输家
        if not _aniDownResult then
            _aniDownResult = ccs.Armature:create("zjh_vs_eff")
            _aniDownResult:setPosition(120, 80)
            _aniDownResult:setTag(GF_DOWN_RES_ANI)
            _playerDown:addChild(_aniDownResult)
        end
        _aniUpResult:setVisible(true)
        _aniDownResult:setVisible(true)
        --if _upPlayer:IsEliminate() then
            --_aniUpResult:getAnimation():play("ani_02")
            --_aniDownResult:getAnimation():play("ani_03")
        --else
        _aniUpResult:getAnimation():play("ani_03")
        _aniDownResult:getAnimation():play("ani_02")
        --end
    end

    -- 手牌飞出 --
    local function callfunc3()
        _comparePanel:setVisible(false)
        
        _aniUpResult:setVisible(false)
        _aniDownResult:setVisible(false)

        for i = 1, GFlowerConfig.CARD_COUNT do
            local _upCardSprite = self.player5_3Card[win_id][i]
            local _downCardSprite = self.player5_3Card[lost_id][i]
            _upCardSprite:setLocalZOrder(_upCardZOrder[i])
            _downCardSprite:setLocalZOrder(_downCardZOrder[i])

            _upCardSprite:stopAllActions()
            _upCardSprite:runAction(cc.Spawn:create(
                cc.MoveTo:create(_moveTime, _upCardPos[i]),
                cc.ScaleTo:create(_moveTime, _upCardScale[i]),
                cc.RotateTo:create(_moveTime, _upCardRotation[i])
                ))

            -- if isfanpai then
            --     _downCardSprite:resetUI()
            --     _upCardSprite:resetUI()
            -- end

            _downCardSprite:stopAllActions()
            _downCardSprite:runAction(cc.Spawn:create(
                cc.MoveTo:create(_moveTime, _downCardPos[i]),
                cc.ScaleTo:create(_moveTime, _downCardScale[i]),
                cc.RotateTo:create(_moveTime, _downCardRotation[i])
                ))
        end
    end

    -- 设置状态 --
    local function callfunc4()

        -- 设置和自己比牌的那个玩家牌为背面
        if self._logic.win_cards ~= nil then
            self:setInvalidCard(win_id, false)
            self._logic.win_cards = nil
            self._logic.lost_cards = nil
        end

        -- 玩家界面状态
        self:UpdatePlayerStatus(lost_id)
        
        -- 如果是最后两个玩家在比牌，执行游戏结束操作
        if self._logic.room_state ~= GFlowerConfig.ROOM_STATE.PLAY then
            
            -- 关闭上个玩家的操作计时动画
            self:CloseDojishi(self._logic.doing_id)

            -- 赢家收筹码动画
            self:CoinFlyOutAction(self.win_id)
        else
            -- 关闭上个玩家的操作计时动画
            self:CloseDojishi(self._logic.doing_id)

            -- 当前玩家跳到下一个
            self._logic.doing_id = cur_id
    
            -- 打灯到下个玩家 和 启动操作倒计时动画
            self:CloseDojishi(self._logic.doing_id)
            self:UsingDaojishi(self._logic.doing_id, GFlowerConfig.COUNT_DOWN_TIME)
            self:MoveLight(self._logic.doing_id)

            -- 刷新下排按钮
            self:UpdateMenuBtn()

            -- 如果选择了跟到底 且 当前轮到自己操作
            if self._logic.gendaodi == true and self._logic.doing_id  == GFlowerConfig.CHAIR_SELF then
                local lPlayer = self._logic:getGFPlayerByClientId(GFlowerConfig.CHAIR_SELF)
                if lPlayer:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK then
                    self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, self._logic.follow_num, 2)
                else
                    self:CoinFlyAction(GFlowerConfig.CHAIR_SELF, self._logic.follow_num, 1)
                end
                GFlowerGameManager:getInstance():send_CS_ZhaJinHuaAddScore(GFlowerConfig.ADD_BTN_TIMES[self._logic.follow_num] * self._logic.MinJetton)
            end
        end
    end

    -- 是否结束 --
    local function callfunc5()
        -- 比牌动画设置为结束
        self.is_compare = false

        -- 播放开牌动画
        local COMPARE_CARD_ANIMATION_DELAY = 7
        if self._logic.room_state ~= GFlowerConfig.ROOM_STATE.PLAY then
            self.countDown = self.countDown - COMPARE_CARD_ANIMATION_DELAY
            self:endOpenCardAni()
        end
    end

    local callfuncAction = nil

    callfuncAction = transition.sequence({
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(callfunc1),
        cc.CallFunc:create(showCard),
        --cc.CallFunc:create(fanpaidonghua),
        cc.DelayTime:create(3),
        cc.CallFunc:create(callfunc2),
        cc.DelayTime:create(1.5),
        cc.CallFunc:create(callfunc3),
        cc.DelayTime:create(1.0),
        cc.CallFunc:create(callfunc4),
        cc.CallFunc:create(callfunc5)
    })

    _comparePanel:stopAllActions()
    _comparePanel:runAction(callfuncAction)
end

--显示跑马灯动画
function GFlowerGameScene:showMarqueeTip()
    local marqueeInfo = GameManager:getInstance():getHallManager():getHallDataManager():getNextNeedShowMarqueeInfo();
    if self.isShowingMarquee == true or marqueeInfo == nil then
        return;
    end
    local marqueeTipStr = marqueeInfo.content;
    marqueeTipStr = CustomHelper.decodeURI(marqueeTipStr)
    self.isShowingMarquee = true
    if marqueeTipStr == nil then
        return;
    end

    -- dump(self.marqueeText, "self.marqueeText", nesting)
    if marqueeTipStr then
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
                                --dump(marqueeInfo, "marqueeInfo", nesting)
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

-- 结算开牌动画
function GFlowerGameScene:endOpenCardAni()
    local _delayTime = 0

        -- 展示玩家牌 --
    local function callfunc1()

        for k, player in pairs(self.player_Endlist) do
            local card_list = player.cards
            if card_list ~= nil then
                local client_chair_id = self._logic:getLocalChairId(player.chair_id)
                self:sortPlayerCard(card_list)
                self.playerLight[client_chair_id]:setVisible(false)
                self.playerLook[client_chair_id]:setVisible(false)
                _delayTime = _delayTime + 1
                self.Panel_OpenCard:runAction(cc.Sequence:create(
                cc.DelayTime:create(_delayTime),
                cc.CallFunc:create(function()
                    -- 翻开玩家的牌
                    self:showPlayerCard(client_chair_id, card_list, true)
                end)
                ))
            end
        end
    end

    local OPNE_CARD_ANIMATION_DELAY = 8
    local function callfunc2()
        self.Panel_OpenCard:setVisible(false)
        self:CoinFlyOutAction(self.win_id)
        self.countDown = self.countDown - OPNE_CARD_ANIMATION_DELAY
        self:startCountDown(self.countDown)
        self:onGameOver()
    end

    local callfuncAction = nil
    callfuncAction = transition.sequence({
        cc.CallFunc:create(callfunc1),
        cc.DelayTime:create(_delayTime + 4),
        cc.CallFunc:create(callfunc2)
    })

    self.Panel_OpenCard:stopAllActions()
    self.Panel_OpenCard:runAction(callfuncAction)
end

-- 全场比牌 开牌动画 --
function GFlowerGameScene:OpenCardAni()
    local _delayTime = 0

    local function callfunc1()
        --print("全场比牌，轮数大小为："..self._logic.roundNum)
        if self._logic.roundNum >= 20 then
            self.Label_OpenCard:setString("20回合数已满，进入全场比牌")
        else
            self.Label_OpenCard:setString("有玩家金币不足，进入全场比牌")
        end

        self.Panel_OpenCard:setVisible(true)
        self.Ani_OpenCard:getAnimation():play("ani_03")
    end

    -- 展示玩家牌 --
    local function callfunc2()

        for k, player in pairs(self.player_Endlist) do
            local card_list = player.cards
            if card_list ~= nil then
                local client_chair_id = self._logic:getLocalChairId(player.chair_id)
                -- 只翻开没死的玩家的牌
                local lPlayer = self._logic:getGFPlayerByClientId(client_chair_id)
                if lPlayer ~= nil then
                    if lPlayer:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK
                    or lPlayer:getGameState() == GFlowerConfig.PLAYER_STATUS.CONTROL then
                        -- 排序
                        self:sortPlayerCard(card_list)

                        _delayTime = _delayTime + 1
                        self.Panel_OpenCard:runAction(cc.Sequence:create(
                        cc.DelayTime:create(_delayTime),
                        cc.CallFunc:create(function()
                            -- 翻开玩家的牌
                            self:showPlayerCard(client_chair_id, card_list, false)
                        end)
                        ))
                    end
                end
            end
        end
    end

    local function callfunc5()
        self._logic.all_Compare = false
        self.Panel_OpenCard:setVisible(false)
        self:CoinFlyOutAction(self.win_id)

        local OPNE_ALL_CARD_ANIMATION_DELAY = 8
        self.countDown = self.countDown - OPNE_ALL_CARD_ANIMATION_DELAY
        self:startCountDown(self.countDown)
        self:onGameOver()
    end


    local callfuncAction = nil
    callfuncAction = transition.sequence({
        cc.CallFunc:create(callfunc2),
        cc.DelayTime:create(_delayTime + 4),
        cc.CallFunc:create(callfunc5)
    })
  
    self.Panel_OpenCard:stopAllActions()
    self.Panel_OpenCard:runAction(callfuncAction)
end

-- 结算倒计时动画 --
function GFlowerGameScene:Using_jiesuan_Daojishi(timenum)

    local _progress = self.jiesuan_djs_ani

    local function daojishi1()
        _progress:stopAllActions()
        _progress:setVisible(false)
    end

    local _action1 = cc.Sequence:create(cc.ProgressFromTo:create(timenum, 100, 0), cc.CallFunc:create(daojishi1))
    _progress:stopAllActions()
    _progress:setVisible(true)
    _progress:runAction(_action1)
end

--监听相关通知
function GFlowerGameScene:registerNotification()
    local marqueeShowListener =  cc.EventListenerCustom:create(HallMsgManager.kNotifyName_NeedShowMarqueeInfo,function(event) 
       self:showMarqueeTip()
    end);

    self.eventDispatcher:addEventListenerWithSceneGraphPriority(marqueeShowListener,self);

    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_StandUpAndExitRoom)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_EnterRoomAndSitDown)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_NotifySitDown)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_NotifyStandUp)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_Ready)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaStart)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaAddScore)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaGiveUp)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaLookCard)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaNotifyLookCard)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaCompareCard)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaEnd)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaReConnect)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaWatch)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaGetSitDown)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaLostCards)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaReadyTime)
    self:addOneTCPMsgListener(GFlowerGameManager.MsgName.SC_ZhaJinHuaClientReadyTime)

    GFlowerGameScene.super.registerNotification(self)
end

function GFlowerGameScene:receiveServerResponseSuccessEvent(event)
    local msgTab = event.userInfo;
    local msgName = msgTab["msgName"];
    if msgName == HallMsgManager.MsgName.SC_StandUpAndExitRoom then 
        self:returnToHallScene()
    elseif msgName == HallMsgManager.MsgName.SC_EnterRoomAndSitDown then
        self:on_msg_EnterRoomAndSitDown(msgTab)
    elseif msgName == HallMsgManager.MsgName.SC_NotifySitDown then
        self:on_msg_NotifySitDown(msgTab)
    elseif msgName == HallMsgManager.MsgName.SC_NotifyStandUp then
        self:on_msg_NotifyStandUp(msgTab)
    elseif msgName == HallMsgManager.MsgName.SC_Ready then
        self:on_msg_Ready(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaStart then
        self:on_msg_ZhaJinHuaStart(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaEnd then
        self:on_msg_ZhaJinHuaEnd(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaLostCards then
        self:on_msg_ZhaJinHuaLostCards(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaWatch then
        self:on_msg_ZhaJinHuaWatch(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaLookCard then
        self:on_msg_ZhaJinHuaLookCard(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaNotifyLookCard then
        self:on_msg_ZhaJinHuaNotifyLookCard(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaReConnect then
        self:on_msg_ZhaJinHuaReConnect(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaAddScore then
        self:on_msg_ZhaJinHuaAddScore(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaGiveUp then
        self:on_msg_ZhaJinHuaGiveUp(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaCompareCard then
        self:on_msg_ZhaJinHuaCompareCard(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaReadyTime then
        self:on_msg_ZhaJinHuaReadyTime(msgTab)
    elseif msgName == GFlowerGameManager.MsgName.SC_ZhaJinHuaClientReadyTime then
        self:on_msg_ZhaJinHuaClientReadyTime(msgTab)
            ---游戏停服通知
    elseif msgName == HallMsgManager.MsgName.SC_GameMaintain then
        --服务器维护中，如果玩家没有正在游戏中，则直接弹出
        if self._logic.room_state ~= GFlowerConfig.ROOM_STATE.PLAY then
            self:isContinueGameConditions()
        end
    end

    GFlowerGameScene.super.receiveServerResponseSuccessEvent(self, event)
end

function GFlowerGameScene:on_msg_ZhaJinHuaReConnect(msgTab)
--  这么诡异的写法是因为不熟悉这个消息的具体情况
   if msgTab.isseecard then
   else
        -- 如果不在房间退出到主场景
        self:exitRoom()
    end
end

function GFlowerGameScene:on_msg_Ready(msgTab)
    local server_chairid = msgTab.ready_chair_id
    local client_chair_id = self._logic:getLocalChairId(server_chairid)

    if self._logic.myServerChairId == server_chairid then
        self:On_Ready(0)
    else
        self:On_Ready(client_chair_id)
    end
end

function GFlowerGameScene:on_msg_ZhaJinHuaAddScore(msgTab)

    local server_add_score_id   = msgTab.add_score_chair_id
    local server_next_id        = msgTab.cur_chair_id
    local client_add_score_id   = self._logic:getLocalChairId(server_add_score_id)
    local client_next_id        = self._logic:getLocalChairId(server_next_id)

    local gfplayer  = self._logic:getGFPlayerByClientId(client_add_score_id)
    self:On_UpdatePlayerMoney(gfplayer)

    self:On_UpdateDeskMoney(self._logic.follow_money, self._logic.deskAllMoney)

    self:On_updateLunshuStr(client_add_score_id)

    self:On_ZhaJinHuaAddScore(client_add_score_id, client_next_id)
end

function GFlowerGameScene:on_msg_ZhaJinHuaGiveUp(msgTab)

    local server_giveup_id  = msgTab.giveup_chair_id
    local server_next_id    = msgTab.cur_chair_id
    local client_giveup_id  = self._logic:getLocalChairId(server_giveup_id)
    local client_next_id    = self._logic:getLocalChairId(server_next_id)
    
    self:On_updateLunshuStr(client_giveup_id)

    self:On_ZhaJinHuaGiveUp(client_giveup_id, client_next_id)
end

function GFlowerGameScene:on_msg_ZhaJinHuaReadyTime(msgTab)
    self:recordCountDown(msgTab.time)
end

function GFlowerGameScene:on_msg_ZhaJinHuaClientReadyTime(msgTab)
    self:recordCountDown(msgTab.time)
end

function GFlowerGameScene:on_msg_ZhaJinHuaCompareCard(msgTab)
    local server_next_player    = msgTab.cur_chair_id      
    local server_win_player     = msgTab.win_chair_id     
    local server_lost_player    = msgTab.lost_chair_id    
    local client_next_id        = self._logic:getLocalChairId(server_next_player)
    local client_win_id         = self._logic:getLocalChairId(server_win_player)
    local client_lost_id        = self._logic:getLocalChairId(server_lost_player)

    local wPlayer = self._logic:getGFPlayerByClientId(client_win_id)
    local lPlayer = self._logic:getGFPlayerByClientId(client_lost_id)

    self:On_UpdatePlayerMoney(wPlayer)
    self:On_UpdatePlayerMoney(lPlayer)

    self:On_UpdateDeskMoney(self._logic.follow_money, self._logic.deskAllMoney)

    self:On_updateLunshuStr(self._logic.doing_id)

    --  不是全场比牌才显示比牌动画
    if self._logic.all_Compare == false then
        local name_win =  wPlayer:getNickName()
        local money_win = wPlayer:getMoney()
        local name_lost = lPlayer:getNickName()
        local money_lost = lPlayer:getMoney()

        self:setComparePlayerInfo(name_win, money_win, name_lost, money_lost, client_win_id, client_lost_id)
    
        self:On_ZhaJinHuaCompareCard(client_next_id, client_win_id, client_lost_id)
    end
end

function GFlowerGameScene:on_msg_ZhaJinHuaStart(msgTab)
    print("GFlowerGameScene:on_msg_ZhaJinHuaStart  ")
    --dump(msgTab,"msgTab")
    -- 更新总注 单注大小
    self:On_UpdateDeskMoney(self._logic.follow_money, self._logic.deskAllMoney)

    --  清除无效玩家界面信息
    for idx = 1,  GFlowerConfig.CHAIR_COUNT do
        if self._logic.validPlayerTag[idx] == 0 then
            self:On_NotifyStandUp(idx)
        end
    end

    -- 发牌动画执行完毕后发牌
    self:On_GameStart(self._logic.doing_id)
end

function GFlowerGameScene:on_msg_NotifyStandUp(msgTab)
   print("GFlowerGameScene:on_msg_NotifyStandUp  UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU")
   local gfplayer  =  self._logic:getGFPayerByGuid(msgTab.guid)
   if gfplayer == nil then
   -- 为空说明玩家数据已经被清理， 这里需要将界面的数据清理掉。
       local client_chair = self._logic:getLocalChairId(msgTab.chair_id)
       self:On_NotifyStandUp(client_chair)
   else
       if msgTab.chair_id == self._logic.myServerChairId then
		local gameSwitchStatus = GameManager:getInstance():getHallManager():getSubGameManager():getGameSwitchStatus()
		if gameSwitchStatus == GameMaintainStatus.On then
           return;
		end
        print(" 玩家现有金币： ",gfplayer:getMoney()," 房间限制金币： ",self._logic.MinJettonMoney)
        if gfplayer:getMoney() >= self._logic.MinJettonMoney then
		    self:jumpToHallScene()
        end
       end
   end
end

function GFlowerGameScene:on_msg_ZhaJinHuaLookCard(msgTab)
    self:On_ZhaJinHuaLookCard(msgTab.cards)
end

function GFlowerGameScene:on_msg_ZhaJinHuaNotifyLookCard(msgTab)
    local client_chair_id = self._logic:getLocalChairId(msgTab.lookcard_chair_id)
    
    -- 玩家界面状态
    self:UpdatePlayerStatus(client_chair_id)
end

function GFlowerGameScene:on_msg_ZhaJinHuaWatch(msgTab)

   -- 重置文本 隐藏打灯效果
    self:resetMainTableUI()

    -- 初始化筹码（在获取底注之后再初始化）
    self:On_InitJetton()

    for k, player in pairs (self._logic.gfPlayers) do
        if self._logic.myServerChairId == player:getChairId() then
            self:On_PlayerEnter(player)
        else
            self:On_NotifyPlayerEnter(player)
        end
    end

        -- 如果房间 不处于战斗状态 玩家进入后强制准备
    if self._logic.room_state ~= GFlowerConfig.ROOM_STATE.PLAY then
        -- 清空桌面筹码 其他情况不清除
        self:removeAllCoin()

        GameManager:getInstance():getHallManager():getHallMsgManager():sendGameReady();
    else
        self:recoverMainTableUI()
        
        -- 生成桌面所有筹码
        if self._logic.coinList  ~= nil then
            self:connectAllDeskCoin(self._logic.coinList)
        end
    end
end

function GFlowerGameScene:on_msg_ZhaJinHuaEnd(msgTab)
    -- 界面更新
    self:On_ZhaJinHuaEnd()
end

function GFlowerGameScene:on_msg_EnterRoomAndSitDown(msgTab)
    print("GFlowerGameScene:on_msg_EnterRoomAndSitDown  ")
end

function GFlowerGameScene:on_msg_NotifySitDown(msgTab)
    
    local server_chairid = msgTab.pb_visual_info["chair_id"]
    local gfplayers = self._logic:getGfPlayers()
    local gfPlayer = gfplayers[server_chairid]

    self:On_NotifyPlayerEnter(gfPlayer)
end

function GFlowerGameScene:on_msg_ZhaJinHuaLostCards(msgTab)
    print("GFlowerGameScene:on_msg_ZhaJinHuaLostCards  ")
end

function GFlowerGameScene:receiveServerResponseErrorEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_StandUpAndExitRoom then 
		--local gameSwitchStatus = GameManager:getInstance():getHallManager():getSubGameManager():getGameSwitchStatus()
		--if gameSwitchStatus == GameMaintainStatus.On then
        --   return;
		--end
        self:jumpToHallScene()
    end

    GFlowerGameScene.super.receiveServerResponseErrorEvent(self, event)
end

function GFlowerGameScene:receiveMsgRequestErrorEvent(event)
    self.Button_Add:setEnabled(true)
    self.Image_Add:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN["ADD_SCORE"][1])
    self.Button_All:setEnabled(true)
    self.Image_All:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN["ALL_IN"][1])
    self.Button_Follow:setEnabled(true)
    self.Image_Follow:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN["FOLLOW"][1])
    GFlowerGameScene.super.receiveMsgRequestErrorEvent(self, event)
end

function GFlowerGameScene:jumpToHallScene()
    GFlowerGameManager:getInstance():sendStandUpAndExitRoomMsg()
    self:returnToHallScene()
end

function GFlowerGameScene:recordCountDown(_time)
    self.countDown = _time
end

---------------------------
return GFlowerGameScene;