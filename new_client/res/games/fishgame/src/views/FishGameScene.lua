local FishGameScene = class("FishGameScene", requireForGameLuaFile("SubGameBaseScene"))
local FishGameFish = requireForGameLuaFile("FishGameFish")
local FishGameBullet = requireForGameLuaFile("FishGameBullet")
local Visual = requireForGameLuaFile("Visual")
local Fishes = requireForGameLuaFile("Fishes")
local CDefine = requireForGameLuaFile("CDefine")
local ConnonSet = requireForGameLuaFile("ConnonSet")

local FishGameConfig = requireForGameLuaFile("FishGameConfig")
local FishGameXMLConfigManager = requireForGameLuaFile("FishGameXMLConfigManager")
local FishGameDataManager = requireForGameLuaFile("FishGameDataManager")
local FishGamePlayerInfo = requireForGameLuaFile("FishGamePlayerInfo")
local TestFishLayer = requireForGameLuaFile("TestFishLayer")
local FishGameBubble = requireForGameLuaFile("FishGameBubble")
local CachedNodeManager = requireForGameLuaFile("CachedNodeManager")
local FishGameRuleLayer = requireForGameLuaFile("FishGameRuleLayer")
local FishGameCannon = requireForGameLuaFile("FishGameCannon")

local ChainConfig = {
    [E_Red] = { image = "fish_42", animation = "move" },
    [E_Blue] = { image = "fish_41", animation = "move" },
    [E_Light] = { image = "fish_40", animation = "move" },
}


local LAYER_ZORDER = {
    BACKGROUND = 1,
    EFFECT_DOWN = 2,
    FISHES = 3,
    BUBBLE = 4,
    EFFECT_UP = 5,
    BACKGROUND_SWITCH = 10,
    BACKGROUND_SWITCH_WATER = 11,
    BULLET = 15,
    TOUCH = 19,
    UI = 20,
    TEST_LAYER = 50,
}

-- 场景初始化方法
function FishGameScene:ctor()
    FishGameScene.super.ctor(self)
    CustomHelper.addSetterAndGetterMethod(self, "fishGameManager", GameManager:getInstance():getHallManager():getSubGameManager())
    CustomHelper.addSetterAndGetterMethod(self, "dataManager", self:getFishGameManager():getDataManager())
    CustomHelper.addSetterAndGetterMethod(self, "soundManager", self:getFishGameManager():getSoundManager())


    local objMng = game.fishgame2d.FishObjectManager:GetInstance()
    objMng:SetMirrowShow(self:getDataManager():getMirrorShow())
    objMng:RegisterBulletHitFishHandler(handler(self, self.on_event_BulletHitFish))
    objMng:RegisterEffectHandler(handler(self, self.on_event_FishEffect))
    objMng:Init(1280, 720, "config/")

    --TestFishLayer.create():addTo(self, LAYER_ZORDER.TEST_LAYER)
    self._time = socket.gettime()
    self:onUpdate(handler(self, self._onInterval))
    self._scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self._onInterval_timeSync), 10, false)


    self.m_winningNode = {}
    self.m_pChains = {}
    self.m_pParticals = {}
    -- 鱼摆摆 --
    self.m_FishLayerList = {}
    self.m_pFishLayer = display.newLayer():addTo(self, LAYER_ZORDER.FISHES)
    -- 子弹 --
    self.m_BulletLayerList = {}
    self.m_pBulletLayer = display.newLayer():addTo(self, LAYER_ZORDER.BULLET)
    -- 效果 --
    self.m_EffectDownLayerList = {}
    self.m_EffectUpLayerList = {}
    self.m_pEffectDownLayer = display.newLayer():addTo(self, LAYER_ZORDER.EFFECT_DOWN)
    self.m_pEffectUpLayer = display.newLayer():addTo(self, LAYER_ZORDER.EFFECT_UP)

    -- 节点缓存管理器 --
    self._cacheMng = CachedNodeManager.new()

    self._mainUI = requireForGameLuaFile("FishGameCCS"):create().root:addTo(self, LAYER_ZORDER.UI)

    local layerTouch = display.newLayer():addTo(self, LAYER_ZORDER.TOUCH)
    layerTouch:registerScriptTouchHandler(handler(self, self._onTouched_TTTTT))
    layerTouch:setTouchEnabled(true)

    -- 初始化XML配置管理器
    self._xmlConfigManager = FishGameXMLConfigManager:getInstance()

    -- 初始化局部变量 --------------
    self._musicOpen = true
    self._soundOpen = true
    self._targetPos = cc.p(display.cx, display.cy)
    self._lastFireTime = 0
    self._lastTouchTime = 0

    self._longTouch = false
    self._autoFire = false
    self._autoFireTime = 0
    self._lockFish = false

    -- 自己最大子弹数量限制 --
    self.m_dwLastFireTick = -1
    self.m_nBulletCount = 0

    -- 玩家控件列表 --------------------
    self._playersUI = {}
    self._playerCannon = {}


    -- 初始化界面 ------------------
    self:initUI()

    -- 初始化玩家 ------------------
    self:initPlayers()

    self:initBgSwitchWater()
    -- 初始化声音状态
    self:updateMusicAndSoundStatus()

    self:updateSceneBackground(1, true)
end

--- 预加载资源路径
function FishGameScene.getNeedPreloadResArray()
    -- body
    print("getNeedPreloadResArray.............................")
    local resPaths = {
        CustomHelper.getFullPath("anim/fish_effect_boss/fish_effect_boss.ExportJson"),
        CustomHelper.getFullPath("anim/effect_bar_glod/effect_bar_glod.ExportJson"),
        CustomHelper.getFullPath("anim/fish_jinbi_1/fish_jinbi_1.ExportJson"),
        CustomHelper.getFullPath("anim/bubble_full_eff/bubble_full_eff.ExportJson"),
        CustomHelper.getFullPath("anim/effect_bg_water/effect_bg_water.ExportJson"),
        CustomHelper.getFullPath("anim/effect_transition_water/effect_transition_water.ExportJson"),
        CustomHelper.getFullPath("anim/effect_fish_bomb/effect_fish_bomb.ExportJson"),
        CustomHelper.getFullPath("anim/bb_likui_pao_bullet/bb_likui_pao_bullet.ExportJson"),
        CustomHelper.getFullPath("anim/effect_weapons_replace/effect_weapons_replace.ExportJson"),

        CustomHelper.getFullPath("anim/eff_fish_button_right_lock_auto_lk/eff_fish_button_right_lock_auto_lk.ExportJson"),
    }
    -- 鱼
    local indexFish = 1
    local data = {}
    for _, v in pairs(Visual) do
        for __, vv in ipairs(v.die) do
            if not data[vv.image] then
                data[vv.image] = indexFish
                indexFish = indexFish + 1
            end
        end
        for __, vv in ipairs(v.live) do
            if not data[vv.image] then
                data[vv.image] = indexFish
                indexFish = indexFish + 1
            end
        end
    end
    FishGameConfig.FishVisualZOrder = data
    for k, v in pairs(data) do
        table.insert(resPaths, CustomHelper.getFullPath("anim/fishes/" .. k .. ".ExportJson"))
    end


    for k, v in pairs(ChainConfig) do
        table.insert(resPaths, CustomHelper.getFullPath("anim/fishes/" .. v.image .. ".ExportJson"))
    end
    -- 子弹和炮
    local tmpData= {}
    for _,v in ipairs(ConnonSet.connonSet) do
        for __,vv in ipairs(v.cannonType) do
            tmpData[vv.cannon.resName] = true
            tmpData[vv.bullet.resName] = true
            tmpData[vv.net.resName] = true
        end
    end
    for k,v in pairs(tmpData) do
        table.insert(resPaths, CustomHelper.getFullPath("anim/" .. k .. "/" .. k .. ".ExportJson"))

    end

    -- 炸弹粒子
    for k, v in pairs(FishGameConfig.PARTICAL_CONFIG) do
        table.insert(resPaths, CustomHelper.getFullPath("anim/" .. v.AniImage .. "/" .. v.AniImage .. ".ExportJson"))
    end

    return resPaths
end

function FishGameScene:onEnter()
    self:_onInterval_timeSync()
    self:getFishGameManager():sendGameReady()
end

function FishGameScene:onExit()
    game.fishgame2d.FishObjectManager:GetInstance():RemoveAllFishes(true)
    game.fishgame2d.FishObjectManager:GetInstance():RemoveAllBullets(true)
    game.fishgame2d.FishObjectManager:GetInstance():Clear()
    game.fishgame2d.FishObjectManager:DestroyInstance()
    if self._scheduler ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)
        self._scheduler = nil
    end

    local loadAramtureResTab = FishGameScene:getNeedPreloadResArray()
    for i, res in ipairs(loadAramtureResTab) do
        if res ~= "" then
            if string.find(res, ".ExportJson") then
                ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(res);
            end
        end
    end
end

function FishGameScene:_onInterval(dt)
    local time = socket.gettime()
    local dt = time - self._time
    self._time = time

    game.fishgame2d.FishObjectManager:GetInstance():OnUpdate(dt)


    -- 增加链子效果 --
    local index = 1
    local count = 0
    while index <= #self.m_pChains do
        if count <= 5 then
            count = count + 1
            local chainInfo = self.m_pChains[index]
            self:showChain(chainInfo)
            table.remove(self.m_pChains, index)
        else
            index = index + 1
        end
    end
    -- 鱼的死亡光效 --
    local index, count = 1, 0
    while index <= #self.m_pParticals do
        if count <= 3 then
            count = count + 1
            local partical = self.m_pParticals[index]
            self:showEffectPartical(partical.fishX, partical.fishY, partical.name)

            table.remove(self.m_pParticals, index)
        else
            index = index + 1
        end
    end

    -- 更新锁定鱼的炮台方向
    local dataMgr = self:getDataManager()
    local myChairId = dataMgr:getMyChairId()
    for i = 1, 4 do
        if i ~= myChairId then
            local player = dataMgr:getPlayerByChairId(i)
            if player then
                local optIndex = player:getOptIndex()
                local fishId = player and player:getLockedFishId()
                if fishId and fishId ~= 0 then
                    local fish = game.fishgame2d.FishObjectManager:GetInstance():FindFish(fishId)
                    if fish then
                        local angle = self:updateCannonRotationToPosition(optIndex, fish:getPosition())
                        self._playersUI[optIndex].node_cannon:setRotation(math.deg(-angle + math.pi / 2))
                    end
                end
            end
        end
    end
    -- 自己锁定鱼的状态
    local player = dataMgr:getMyPlayerInfo()
    local optIndex = player:getOptIndex()
    local fishId = player and player:getLockedFishId()
    self._btnLock.armature:setVisible(fishId and fishId ~= 0)

    --- 处于锁定状态，但没有锁定的鱼，发送锁定新的鱼
    if not (fishId and fishId ~= 0) then
        if self._lockFish then
            if self._lockTime == 0 then
                self:getFishGameManager():send_CS_LockFish(true)
            end
            self._lockTime = self._lockTime + dt
            if self._lockTime > 3 then
                self._lockTime = 0
            end
        end
    else
        local fish = game.fishgame2d.FishObjectManager:GetInstance():FindFish(fishId)
        if fish then
            self._targetPos.x = fish:getPosition().x
            self._targetPos.y = fish:getPosition().y
        end
    end
    local angle = self:updateCannonRotationToPosition(optIndex, self._targetPos)
    self._playersUI[optIndex].node_cannon:setRotation(math.deg(-angle + math.pi / 2))


    -- 自动攻击
    if self._autoFire or self._longTouch then
        if self._autoFireTime == 0 then
            self:fireTo(self._targetPos)
        end
        self._autoFireTime = self._autoFireTime + dt
        if self._autoFireTime >= dataMgr:getFireInterval() then
            self._autoFireTime = 0;
        end
    end
end

function FishGameScene:_onInterval_timeSync()
    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager()
    subGameManager:send_CS_TimeSync()
end

-- 初始化界面
function FishGameScene:initUI()
    local menu = self._mainUI:getChildByName("panel_menu")
    local handlerMenu = handler(self, self._onBtnTouched_Menu)
    local btnList = {
        "btn_rule",
        "btn_music",
        "btn_sound",
        "btn_quit",
        "btn_open",
        "btn_close",
    }
    for _, v in ipairs(btnList) do
        menu:getChildByName(v):addTouchEventListener(handlerMenu)
    end

    -- 自动发炮和锁定攻击
    local handlerAutoLock = handler(self, self._onBtnTouched_AutoAndLock)
    local btnList = {
        "btn_auto",
        "btn_lock",
    }
    for _, v in ipairs(btnList) do
        local btn = self._mainUI:getChildByName(v)
        btn:setTouchEnabled(true)
        btn:addTouchEventListener(handlerAutoLock)
        btn.armature = btn:getChildByName("eff_fish_button_right_lock_auto_lk"):hide()
        if v == "btn_lock" then
            self._btnLock = btn
        end
    end
end

-- 初始化玩家
function FishGameScene:initPlayers()
    local hanler_opt = handler(self, self._onBtnTouched_OptCannon)

    --- 锁定气泡
    local layerBubble = display.newLayer():addTo(self, LAYER_ZORDER.BUBBLE)

    for i = 1, FishGameConfig.PLAYER_COUNT do
        local conf = ConnonSet.cannonPos[i]
        local node = CustomHelper.seekNodeByName(self._mainUI, "player_" .. i)


        local bg_info = node:getChildByName("bg_info"):hide()
        local label_money = node:getChildByName("label_money"):hide()
        local label_name = node:getChildByName("label_name"):hide()
        local bg_cannon_sc = node:getChildByName("bg_cannon_sc"):hide()
        local label_score = node:getChildByName("plb_txt_score"):hide()
        local btn_sub = node:getChildByName("btn_sub"):hide()
        local btn_add = node:getChildByName("btn_add"):hide()
        local node_cannon = node:getChildByName("node_cannon"):hide()
        local node_winning = node:getChildByName("node_winning")
        local node_lockfish = node:getChildByName("node_lockfish"):hide()

        btn_sub:addTouchEventListener(hanler_opt)
        btn_add:addTouchEventListener(hanler_opt)

        node:setPositionX(conf.pos[1])

        if i > 2 then
            node_cannon:setRotation(180)
        end

        self._playersUI[i] = {
            bg_info = bg_info,
            label_money = label_money,
            label_name = label_name,
            bg_cannon_sc = bg_cannon_sc,
            label_score = label_score,
            btn_sub = btn_sub,
            btn_add = btn_add,
            node_cannon = node_cannon,
            node_winning = node_winning,
        }

        self._playerCannon[i] = FishGameCannon:create(i, conf):addTo(node_cannon)

        FishGameBubble:create(i, node_lockfish):align(display.LEFT_BOTTOM, 0, 0):addTo(layerBubble)
    end

    -- 初始化桌面上的信息
    local players = self:getFishGameManager():getDataManager():getPlayeres()
    for i = 1, FishGameConfig.PLAYER_COUNT do
        self:showPlayerInfo(players[i])
    end
end

--- 初始化切换场景波浪
function FishGameScene:initBgSwitchWater()
    local effSwitchWater = ccs.Armature:create("effect_transition_water")
    effSwitchWater:getAnimation():play("effect_transition_water_animation")

    effSwitchWater:align(display.LEFT_BOTTOM, 0, 0):addTo(self, LAYER_ZORDER.BACKGROUND_SWITCH_WATER)
    effSwitchWater:setVisible(false)
    self._bgSwitchWater = effSwitchWater
end

--- 点击事件
function FishGameScene:_onTouched_TTTTT(eventType, x, y)
    local time = socket.gettime()
    local dt = time - self._lastFireTime
    local dataMgr = FishGameManager:getInstance():getDataManager()
    local fireInterval = dataMgr:getFireInterval()


    local player = self:getFishGameManager():getDataManager():getMyPlayerInfo()
    local fishId = player and player:getLockedFishId()
    local lockFish = fishId and fishId ~= 0

    -- 选中锁定鱼的状态下，点击可以切换到锁定指定鱼
    if self._lockFish then
        local fishId = game.fishgame2d.FishObjectManager:GetInstance():TestHitFish(x, y)
        if fishId ~= -1 then
            self:getFishGameManager():send_CS_LockSepcFish(fishId)
        end
    end

    if not lockFish then
        self._targetPos.x = x
        self._targetPos.y = y
    end
    if eventType == "began" then
        self._longTouch = true
        if not self._autoFire then
            self._autoFireTime = 0.01;
        end

        self:fireTo(self._targetPos, true)
        return true
    elseif eventType == "moved" then
    elseif eventType == "ended" then
        self._longTouch = false
    end
end

function FishGameScene:_onBtnTouched_Menu(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        local name = sender:getName()

        if name == "btn_close" then
            sender:getParent().animation:play("open", false)
        elseif name == "btn_open" then
            sender:getParent().animation:play("close", false)
        elseif name == "btn_music" then
            local musicSwitch = not GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
            GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch(musicSwitch)
            if musicSwitch == true then
                self:getFishGameManager():getSoundManager():playBGM(nil, true)
            else
                GameManager:getInstance():getMusicAndSoundManager():stopMusic()
            end
            self:updateMusicAndSoundStatus()
        elseif name == "btn_sound" then
            local isOpenForSound = not GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
            GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch(isOpenForSound)
            if isOpenForSound == true then
                GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            else
                GameManager:getInstance():getMusicAndSoundManager():stopAllSound()
            end
            self:updateMusicAndSoundStatus()
        elseif name == "btn_quit" then
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
            self:returnToHallScene()
        elseif name == "btn_rule" then
            if not tolua.isnull(self._layerRule) then return end
            self._layerRule = FishGameRuleLayer:create():addTo(self, LAYER_ZORDER.UI)
        end
    end
end

function FishGameScene:_onBtnTouched_OptCannon(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        local name = sender:getName()
        if name == "btn_sub" then
            self:getFishGameManager():send_CS_ChangeCannon(false)
        elseif name == "btn_add" then
            self:getFishGameManager():send_CS_ChangeCannon(true)
        end
    end
end

function FishGameScene:_onBtnTouched_AutoAndLock(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        sender:setScale(1.1)
    elseif eventType == ccui.TouchEventType.canceled then
        sender:setScale(1)
    elseif eventType == ccui.TouchEventType.ended then
        sender:setScale(1)

        local name = sender:getName()
        if name == "btn_auto" then
            self._autoFire = not self._autoFire
            if self._autoFire then
                self._autoFireTime = 0
            end
            sender.armature:setVisible(self._autoFire)
        elseif name == "btn_lock" then
            self._lockTime = 0


            if self._lockFish then
                local dataMgr = self:getDataManager()
                local player = dataMgr:getMyPlayerInfo()
                local fishId = player:getLockedFishId()
                if not (fishId and fishId ~= 0) then
                    self:getFishGameManager():send_CS_LockFish(true)
                    self._lockTime = 0
                    return
                end
            end

            self._lockFish = not self._lockFish
            if not self._lockFish then
                self:getFishGameManager():send_CS_LockFish(false)
            end
        end
    end
end

-- 旋转炮台角度
function FishGameScene:updateCannonRotationToPosition(chairID, targetPos)
    local po = self._playerCannon[chairID]:getCannonPosition()
    return math.atan2(targetPos.y - po[2], targetPos.x - po[1])
end

--监听相关通知
function FishGameScene:registerNotification()

    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_StandUpAndExitRoom)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_EnterRoomAndSitDown)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_NotifySitDown)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_NotifyStandUp)

    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_FishMul)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_AddBuffer)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_BulletSet)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_SendDes)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_LockFish)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_AllowFire)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_SwitchScene)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_KillBullet)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_KillFish)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_SendBullet)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_CannonSet)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_SendFish)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_SendFishList)

    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_GameConfig)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_UserInfo)
    self:addOneTCPMsgListener(FishGameManager.MsgName.SC_ChangeScore)

    FishGameScene.super.registerNotification(self)
end

function FishGameScene:receiveServerResponseSuccessEvent(event)
    local msgTab = event.userInfo;
    local msgName = msgTab["msgName"];
    if msgName == HallMsgManager.MsgName.SC_StandUpAndExitRoom then
        self:returnToHallScene()
    elseif msgName == HallMsgManager.MsgName.SC_NotifySitDown then
        self:on_msg_NotifySitDown(msgTab)
    elseif msgName == HallMsgManager.MsgName.SC_NotifyStandUp then
        self:on_msg_NotifyStandUp(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_GameConfig then
        self:on_msg_GameConfig(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_UserInfo then
        self:on_msg_UserInfo(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_ChangeScore then
        self:on_msg_ChangeScore(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_FishMul then
        self:on_msg_FishMul(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_AddBuffer then
        self:on_msg_AddBuffer(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_BulletSet then
        self:on_msg_BulletSet(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_SendDes then
        self:on_msg_SendDes(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_LockFish then
        self:on_msg_LockFish(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_AllowFire then
        self:on_msg_AllowFire(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_SwitchScene then
        self:on_msg_SwitchScene(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_KillBullet then
        self:on_msg_KillBullet(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_KillFish then
        self:on_msg_KillFish(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_SendBullet then
        self:on_msg_SendBullet(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_CannonSet then
        self:on_msg_CannonSet(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_SendFish then
        self:on_msg_SendFish(msgTab)
    elseif msgName == FishGameManager.MsgName.SC_SendFishList then
        self:on_msg_SendFishList(msgTab)
    end

    FishGameScene.super.receiveServerResponseSuccessEvent(self, event)
end

---重新连接成功
function FishGameScene:callbackWhenReloginAndGetPlayerInfoFinished(event)
    FishGameScene.super.callbackWhenReloginAndGetPlayerInfoFinished(self,event);

    --- 尝试直接发送进入游戏消息
    local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
    local gameTypeID = roomInfo[HallGameConfig.GameIDKey]
    local roomID = roomInfo[HallGameConfig.SecondRoomIDKey]

    CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("entering_gamescene_tip"));
    GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterOneGameMsg(gameTypeID,roomID);
end

function FishGameScene:hidePlayerInfo(optIndex)

    local nodePlayer = self._playersUI[optIndex]
    nodePlayer.bg_info:hide()
    nodePlayer.label_money:hide()
    nodePlayer.label_name:hide()
    nodePlayer.bg_cannon_sc:hide()
    nodePlayer.label_score:hide()
    nodePlayer.btn_sub:hide()
    nodePlayer.btn_add:hide()
    nodePlayer.node_cannon:hide()
    nodePlayer.node_winning:hide()
end

function FishGameScene:showPlayerInfo(player)
    if not player then return end

    local optIndex = player:getOptIndex()

    local nodePlayer = self._playersUI[optIndex]

    nodePlayer.bg_info:show()
    nodePlayer.label_money:show()
    nodePlayer.label_name:show()
    nodePlayer.bg_cannon_sc:show()
    nodePlayer.label_score:show()

    nodePlayer.node_cannon:show()
    nodePlayer.node_winning:show()

    if player:isMyself() then
        nodePlayer.btn_sub:show()
        nodePlayer.btn_add:show()
    else
        nodePlayer.btn_sub:hide()
        nodePlayer.btn_add:hide()
    end


    nodePlayer.label_name:setString(player:getNickName())


    player:setTableUI(nodePlayer)
    player:setCannon(self._playerCannon[optIndex])
    player:setBubble(self._playerCannon[optIndex])
end

--  中途有玩家进入消息
function FishGameScene:on_msg_NotifySitDown(msgTab)
    local player = self:getDataManager():getPlayerByChairId(msgTab.pb_visual_info.chair_id)
    self:showPlayerInfo(player)
end

--  中途退出玩家消息
function FishGameScene:on_msg_NotifyStandUp(msgTab)
    self:hidePlayerInfo(self:getDataManager():getOperateChair(msgTab.chair_id))
end

function FishGameScene:on_msg_FishMul(msgTab)
end

function FishGameScene:on_msg_AddBuffer(msgTab)
end

function FishGameScene:on_msg_GameConfig(msgTab)
end

function FishGameScene:on_msg_BulletSet(msgTab)
end

function FishGameScene:on_msg_UserInfo(msgTab)
end

function FishGameScene:on_msg_ChangeScore(msgTab)
    dump(msgTab, "msgTab")
end

function FishGameScene:on_msg_SendDes(msgTab)
    self:showBossAnimation({
        type = "troop"
    })
end

function FishGameScene:on_msg_LockFish(msgTab)
    --    msgTab.chair_id
    --    msgTab.lock_id
end

function FishGameScene:on_msg_AllowFire(msgTab)
end

function FishGameScene:on_msg_SwitchScene(msgTab)
    self:updateSceneBackground(msgTab.nst, msgTab.switching ~= 1)
end

function FishGameScene:on_msg_KillBullet(msgTab)
--    local bullet = game.fishgame2d.FishObjectManager:GetInstance():FindBullet(msgTab.bullet_id)
--    if bullet and bullet:getState() < EOS_DEAD then
--        if bullet:isMine() then
--            -- 删除子弹 --
--            self.m_nBulletCount = self.m_nBulletCount - 1
--        end
--        bullet:setState(EOS_DEAD)
--    end
end

function FishGameScene:on_msg_KillFish(msgTab)
    -- message SC_KillFish {
    -- enum MsgID { ID = 12110; }
    -- optional int32		chair_id=1;							//椅子ID
    -- optional int64	score=2;                  //鱼价值
    -- optional int32		fish_id=3;              //鱼ID
    -- optional int32			bscoe=4;              //子弹价值
    -- };
    -- 更新玩家分数
    local dataMgr = self:getDataManager()
    local player = dataMgr:getPlayerByChairId(msgTab.chair_id)
    if not player then return end
    local optIndex = player:getOptIndex()

    player:setScore(player:getScore() + msgTab.score)

    -- 添加鱼
    local fish = game.fishgame2d.FishObjectManager:GetInstance():FindFish(msgTab.fish_id)
    if not fish then return end

    fish:setState(EOS_DEAD)
    local fishConf = Fishes[fish:getTypeId()]

    local x, y = fish:getPosition().x, fish:getPosition().y
    local canPos = player:getCannon():getCannonPosition()
    local canX, canY = canPos[1], canPos[2]

    -- 播放金币动画
    self:addFishGold({
        fishX = x,
        fishY = y,
        cannonX = canX,
        cannonY = canY,
        score = msgTab.score,
        baseScore = msgTab.bscoe,
    })

    local mul = msgTab.score / msgTab.bscoe
    --- 播放获取金币声音
    if dataMgr:getMyChairId() == msgTab.chair_id then
        local effect = mul < 30 and "Hit0.mp3" or (mul < 80 and "Hit1.mp3" or "Hit2.mp3")
        self:getFishGameManager():getSoundManager():playEffect(effect)
    end

    --- 鱼死亡时触发屏幕震动
    if fishConf.shakeScreen then
        local time = math.max(0.5, math.min(mul / 60, 1.5))
        local range = math.min(mul / 50, 2)
        self:shakeScreen(time, range, 0)
    end

    --- 播放鱼死亡的粒子动画
    if fishConf.particle ~= "0" then
        self:addPartical({
            xPos = fish:getPosition().x,
            yPos = fish:getPosition().y,
            name = fishConf.particle,
        })
    end
    if mul >= 50 then
        local xPos = fish:getPosition().x
        local yPos = fish:getPosition().y
        self:addPartical({
            xPos = xPos,
            yPos = yPos,
            name = "salute1",
        })
    end

    -- 播放彩金动画
    self:showEffectWinnings({
        wChairID = msgTab.chair_id,
        lScore = msgTab.score,
        BScore = msgTab.bscoe,
        nVisualID = fishConf.visualId,
    })
end

function FishGameScene:on_msg_SendBullet(msgTab)
    local dataMgr = self:getDataManager()
    if msgTab.chair_id ~= dataMgr:getMyChairId() then
        self:addBullet(msgTab)

        local player = dataMgr:getPlayerByChairId(msgTab.chair_id)
        local optIndex = player:getOptIndex()
        local mychair = player:getChairId()
        local idx = optIndex

        local angle = msgTab.direction

        if dataMgr:getMirrorShow() then
            angle = angle + math.pi
        end

        self._playersUI[idx].node_cannon:setRotation(math.deg(math.pi - angle))
        self._playerCannon[idx]:_doAction_Fire()
    end

    local dataMgr = self:getDataManager()
    local player = dataMgr:getPlayerByChairId(msgTab.chair_id)
    local optIndex = player:getOptIndex()

    player:setScore(msgTab.score)
end

function FishGameScene:on_msg_CannonSet(msgTab)
    dump(msgTab)
    local player = self:getDataManager():getPlayerByChairId(msgTab.chair_id)
    local optIndex = player:getOptIndex()

    self._playerCannon[optIndex]:updateCannon(msgTab.cannon_set, msgTab.cannon_type, msgTab.cannon_mul)

    local bulletSet = self:getDataManager()._bulletSet[msgTab.cannon_mul + 1]
    if not bulletSet then return end
    self._playersUI[optIndex].label_score:setString(CustomHelper.moneyShowStyleNone(bulletSet.mulriple))

    --- 播放切换声音
    if player:isMyself() then
        self:getFishGameManager():getSoundManager():playEffect("MakeUP.mp3")
    end
end

function FishGameScene:on_msg_SendFish(msgTab)
    self:addFish(msgTab)
end

function FishGameScene:on_msg_SendFishList(msgTab)
    for _, v in ipairs(msgTab.pb_fishes) do
        self:addFish(v)
    end
end

function FishGameScene:on_event_BulletHitFish(bullet, fish)
    fish:onHit()
    bullet:setState(EOS_DEAD)

    self:getFishGameManager():send_CS_Netcast({
        bullet_id = bullet:getId(),
        fish_id = fish:getId(),
    })

    if bullet:isMine() then
        -- 删除子弹 --
        self.m_nBulletCount = self.m_nBulletCount - 1
    end
end

function FishGameScene:on_event_FishEffect(pSelf, target, effect)
    if effect:GetEffectType() == EffectType.ETP_KILL then
        local param_0 = effect:GetParam(0)
        local typeLight = E_Red
        if param_0 == 2 then
            typeLight = E_Blue
        elseif param_0 == 3 then
            typeLight = E_Light
        end

        typeLight = E_Light

        self:addChain({
            type = typeLight,
            start_x = pSelf:getPosition().x,
            start_y = pSelf:getPosition().y,
            end_x = target:getPosition().x,
            end_y = target:getPosition().y,
        })

        target:setState(EOS_DEAD)
    end
end

--- 添加鱼
function FishGameScene:addFish(fishInfo)
    local fish = FishGameFish:create(fishInfo):addTo(self.m_pFishLayer)

    if fishInfo.type_id == 29 then
        self:showBossAnimation({
            type = "boss"
        })
    end

    game.fishgame2d.FishObjectManager:GetInstance():AddFish(fish)

    return fish
end

function FishGameScene:addBullet(data)
    local player = self:getDataManager():getPlayerByChairId(data.chair_id)
    if not player then return end

    local bullet = FishGameBullet:create(data,player):addTo(self.m_pBulletLayer)

    bullet:SetTarget(player and player:getLockedFishId() or 0)
    game.fishgame2d.FishObjectManager:GetInstance():AddBullet(bullet)

    return bullet
end

function FishGameScene:addEffectDown(effect, key)
    if not self.m_EffectDownLayerList[key] then
        self.m_EffectDownLayerList[key] = display.newLayer():addTo(self.m_pEffectDownLayer)
    end
    self.m_EffectDownLayerList[key]:addChild(effect)
end

function FishGameScene:addEffectUp(effect, key)
    if not self.m_EffectUpLayerList[key] then
        self.m_EffectUpLayerList[key] = display.newLayer():addTo(self.m_pEffectUpLayer)
    end
    self.m_EffectUpLayerList[key]:addChild(effect)
end

function FishGameScene:addChain(_chain)
    if not _chain then return end
    if #self.m_pChains > 25 then return end


    local startX, startY = _chain.start_x, _chain.start_y
    local endX, endY = _chain.end_x, _chain.end_y
    --    startX, startY = CGameConfig.GetInstance():ConvertCoord(startX, startY)
    --    endX, endY = CGameConfig.GetInstance():ConvertCoord(endX, endY)

    table.insert(self.m_pChains, {
        startX = startX,
        startY = startY,
        endX = endX,
        endY = endY,
        lightType = _chain.type,
    })
end

function FishGameScene:addFishGold(_fishGold)
    self:showFishGold(_fishGold)
    self:showFishGoldLabel(_fishGold)
end

function FishGameScene:addPartical(_info)
    if not _info then return end
    if #self.m_pParticals > 10 then return end


    local fishX, fishY = _info.xPos or 0, _info.yPos or 0
    --    fishX, fishY = CGameConfig.GetInstance():ConvertCoord(fishX, fishY)

    table.insert(self.m_pParticals, {
        fishX = fishX,
        fishY = fishY,
        name = _info.name,
    })
end

function FishGameScene:fireTo(targetPos, _handle)
    local dataMgr = self:getDataManager()

    -- 当前不允许发炮
    if not dataMgr:getAllowFire() then
        return
    end

    local player = dataMgr:getMyPlayerInfo()
    local bulletSet = dataMgr._bulletSet[player:getCannonMul() + 1]
    local optIndex = player:getOptIndex()
    local mychair = player:getChairId()

    -- FIX 如果当前自己的子弹没有耗完，则不提示金币不足
    -- 如果当前的金币不够，不能够发射子弹
    local error,needMoney
    if player:getScore() < bulletSet.mulriple then
        error = "您的金币不足，请返回大厅进行充值!!!"
        needMoney = bulletSet.mulriple
    elseif player:getScore() < dataMgr:getRoomInfo()[HallGameConfig.SecondRoomMinMoneyLimitKey] then
        error = "您的金币低于本房间最低入场要求，请返回大厅进行充值!!!"
        needMoney = dataMgr:getRoomInfo()[HallGameConfig.SecondRoomMinMoneyLimitKey]
    end

    if error then
        -- FIX 如果当前自己的子弹没有耗完，则不提示金币不足
        if self.m_nBulletCount > 0 then return end
        self:showAlertLackMoney(error,needMoney)
        return
    end

    -- 如果当前自己的子弹数量大于最大子弹数量
    if self.m_nBulletCount >= dataMgr:getMaxBulletCount() then
        return
    end
    self.m_nBulletCount = self.m_nBulletCount + 1

    -- 扣除金币
    player:setScore(player:getScore() - bulletSet.mulriple)

    -- 计算角度
    local angle = self:updateCannonRotationToPosition(optIndex, self._targetPos)
    self._playersUI[optIndex].node_cannon:setRotation(math.deg(-angle + math.pi / 2))

    if self:getDataManager():getMirrorShow() then
        angle = angle + math.pi
    end

    --- 播放声音
    self:getFishGameManager():getSoundManager():playEffect("GunFire0.mp3")
    self._playerCannon[optIndex]:_doAction_Fire()


    -- 创建子弹并添加到场景
    local po = self._playerCannon[mychair]:getCannonPosition()
    local x = po[1]
    local y = po[2]
    local offset = 100
    x = x + math.sin(-angle + math.pi / 2) * offset
    y = y + math.cos(-angle + math.pi / 2) * offset

    local serverTime = dataMgr:getServerTime()
    local bulletId = dataMgr:getMyBulletId()
    self:addBullet({
        id = bulletId, -- 子弹ID
        chair_id = mychair, -- 椅子ID
        create_tick = serverTime, -- 创建时间
        x_pos = x, -- X坐标
        y_pos = y, -- Y坐标
        cannon_type = player:getCannonType(), -- 炮类型
        multiply = player:getCannonMul(), -- 子弹类型
        score = 0, -- 玩家金钱？
        direction = angle + math.pi / 2, -- 方向
        is_new = 1, -- 是否新子弹
        server_tick = serverTime, --系统时间
        is_double = 0, --双倍炮
    })

    -- 发送子弹消息
    self:getFishGameManager():send_CS_Fire({
        direction = angle + math.pi / 2,
        fire_time = serverTime,
        client_id = bulletId,
        pos_x = x,
        pos_y = y,
    })
end

function FishGameScene:jumpToHallScene()
    self:returnToHallScene()
end

function FishGameScene:returnToHallScene(...)
    GameManager:getInstance():getHallManager():getHallMsgManager():sendStandUpAndExitRoom()
    self:getFishGameManager():onExit()

    SceneController.goHallScene(...)
    self.isReturnToHallScene = true
end

--- 震动屏幕
function FishGameScene:shakeScreen(time, range, delaytime)
    time = time or 0
    range = range or 0
    delaytime = delaytime or 0

    local interval = 20 * range
    local scene = display.getRunningScene()
    local node = display.newNode():addTo(scene)
    node:runAction(transition.sequence({
        cc.DelayTime:create(delaytime),
        ccext.FuncAction:create(time, function(sender, percent)
            if percent == 1 then
                scene:setPosition(0, 0)
            else
                local _time = time * (1 - percent)
                local base = math.max(1, interval * _time)
                local base_2 = base * 0.5
                scene:setPosition(math.random() * base - base_2, math.random() * base - base_2)
            end
        end),
        cc.CallFunc:create(function(sender)
            sender:removeSelf()
        end)
    }))
end

function FishGameScene:showBingo(_bingo)
    local chairId = _bingo.chair_id
    local score = _bingo.score

    local node = display.newNode()
    node:setCascadeOpacityEnabled(true)


    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("fishgame2d/animation/effect_bar_glod/effect_bar_glod.ExportJson")
    local animaNode = ccs.Armature:create("effect_bar_glod")
    animaNode:getAnimation():play("move")
    animaNode:setAnchorPoint(0.5, 0.5)
    animaNode:addTo(node)


    --  图片的大小 700 280
    local x, y = CGameConfig.GetInstance():GetShowBingonPosition(chairId)
    local labelScore = cc.LabelAtlas:_create("0123456789", "fishgame2d/ui/effect_bar_glod_numbers.png", 35, 46, 48)
    labelScore:setString(score or "0")
    labelScore:setAnchorPoint(1, 0.5)
    labelScore:pos(180, 3)
    labelScore:addTo(node)
    node:pos(x, y)
    self:AddEffectUp(node, "effect_bar_glod_numbers.png")

    --    30帧每秒
    --    总共50帧
    --    第一帧   透明度百分之40    大小缩放百分之30
    --    第二帧   透明度百分之46    大小缩放百分之43
    --    第三帧   透明度百分之52    大小缩放百分之55
    --    第四帧   透明度百分之58    大小缩放百分之68
    --    第五帧   透明度百分之64    大小缩放百分之81
    --    第六帧   透明度百分之70    大小缩放百分之93
    --    第七帧   透明度百分之76    大小缩放百分之106
    --    第八帧   透明度百分之82    大小缩放百分之102
    --    第九帧   透明度百分之88    大小缩放百分之98
    --    第十帧   透明度百分之94    大小缩放百分之99
    --    第十一帧 透明度百分之100   大小缩放百分之100
    --    第十一到50帧透明度和大小都100
    --
    --    51帧直接消失

    --    local FPS = 20
    --    print(11 / FPS)
    --    print(7 / FPS)
    --    print(1 / FPS)
    --    print(3 / FPS)
    --    print(39 / FPS)
    node:setOpacity(0xFF * 0.4)
    node:setScale(0.3)
    node:runAction(transition.sequence({
        cc.Spawn:create({
            cc.FadeTo:create(0.55, 0xFF),
            transition.sequence({
                cc.ScaleTo:create(0.35, 1.06),
                cc.ScaleTo:create(0.05, 0.98),
                cc.ScaleTo:create(0.15, 1),
            }),
        }),
        cc.DelayTime:create(1.95),
        cc.CallFunc:create(function(sender)
            sender:removeSelf()
        end)
    }))
end

--- 播放
function FishGameScene:showChain(_chain)
    local distance = game.fishgame2d.MathAide:CalcDistance(_chain.startX, _chain.startY, _chain.endX, _chain.endY)
    local angle = game.fishgame2d.MathAide:CalcAngle(_chain.startX, _chain.startY, _chain.endX, _chain.endY)
    local config = ChainConfig[_chain.lightType]
    dump(_chain)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("fishgame2d/animation/" .. config.image .. "/" .. config.image .. ".ExportJson")
    local animaNode = ccs.Armature:create(config.image)
    animaNode:getAnimation():play(config.animation)
    animaNode:setAnchorPoint(0.5, 0.5)
    animaNode:setScaleX(distance / animaNode:getContentSize().width)
    animaNode:move((_chain.startX + _chain.endX) / 2, (_chain.startY + _chain.endY) / 2)
    animaNode:setRotation(-math.deg(angle) - 90)

    animaNode:runAction(transition.sequence({
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function(sender)
            sender:removeSelf()
        end)
    }))
    self:addEffectDown(animaNode, config.image)

    if _chain.lightType == E_Light then
        self:getFishGameManager():getSoundManager():playEffect("electric.mp3")
    else
        self:getFishGameManager():getSoundManager():playEffect("laser.mp3")
    end
end

function FishGameScene:showEffectWinnings(args)
    args = args or {}
    local wChairID = args.wChairID or 0
    local lScore = args.lScore or 0
    local baseScore = args.BScore or 0
    local nVisualID = args.nVisualID or 0

    local dataMgr = self:getDataManager()
    local player = dataMgr:getPlayerByChairId(wChairID)
    if not player then return end

    local optIndex = player:getOptIndex()
    local times = lScore / baseScore
    --- 倍数覆盖
    local winningNode = self.m_winningNode[optIndex]
    if not tolua.isnull(winningNode) and winningNode.times and winningNode.times > times then
        return
    end
    if not tolua.isnull(winningNode) then winningNode:removeSelf() end

    local nameAni
    if times >= 100 then
        nameAni = "ani_03"
    elseif times >= 50 then
        nameAni = "ani_02"
    elseif times >= 30 then
        nameAni = "ani_01"
    end
    if not nameAni then return end

    --- 播放声音
    if times >= 100 then
        self:getFishGameManager():getSoundManager():playEffect("TNNFDCLNV.mp3")
    else
        self:getFishGameManager():getSoundManager():playEffect("CJ.mp3")
    end

    --- 添加节点
    local node = display.newNode()
    node:setCascadeOpacityEnabled(true)
    node:move(self._playersUI[optIndex].node_winning:convertToWorldSpace(cc.p(0,0)))
    node.times = times
    self.m_winningNode[optIndex] = node

    local armature = ccs.Armature:create("effect_bar_glod")
    armature:getAnimation():play(nameAni)
    if times >= 100 then
    elseif times >= 50 then
        armature:setScale(0.85)
    elseif times >= 30 then
        armature:setScale(0.7)
    end

    local iconConfig = FishGameConfig.FISHNAME_ICON_CONFIG[nVisualID or 0]
    if iconConfig then
        display.newSprite(iconConfig):addTo(node,1):align(display.CENTER,0,-80)
    end

    local fileName = player:isMyself() and "ui/number_02.png" or "ui/number_01.png"
    local text = CustomHelper.moneyShowStyleNone(lScore)
    text = string.gsub(text, "%.", ";")
    text = string.format(":%s",text)
    local labelScore = cc.LabelAtlas:_create("0123456789", fileName, 37, 46, 48)
    labelScore:setString(text)
    labelScore:setAnchorPoint(0.5, 0.5)

    node:addChild(armature)
    node:addChild(labelScore)
    self:addEffectUp(node, "-2")

    labelScore:runAction(cc.RepeatForever:create(transition.sequence({
        cc.RotateTo:create(0.3, 30),
        cc.RotateTo:create(0.6, -30),
        cc.RotateTo:create(0.3, 0),
    })))
    node:runAction(transition.sequence({
        -- 应雷总口头安排改为5秒
        -- cc.DelayTime:create(2),
        cc.DelayTime:create(5),
        cc.Spawn:create({
            cc.ScaleTo:create(0.2, 0.3),
            cc.FadeOut:create(0.2),
        }),
        cc.CallFunc:create(function(sender)
            sender:removeSelf()
            self.m_winningNode[optIndex] = nil
        end),
    }))

    armature = nil
    labelScore = nil
    node = nil
end

function FishGameScene:showBossAnimation(args)
    args = args or {}
    local type = args.type or 0

    local config = {
        ["boss"] = "ani_01",
        ["troop"] = "ani_02",
    }

    if not(type and config[type]) then return end

    if not tolua.isnull(self._bossAnimation) then self._bossAnimation:removeSelf() end

    local armature = ccs.Armature:create("fish_effect_boss")
    armature:getAnimation():play(config[type])
    armature:align(display.CENTER,display.cx,display.height * 0.618)
    armature:runAction(transition.sequence({
        cc.DelayTime:create(10),
        cc.CallFunc:create(function(sender)
            sender:removeSelf()
        end),
    }))

    self._bossAnimation = armature

    self:addEffectUp(armature, "fish_effect_boss",999)
end


function FishGameScene:ShowEffectJetton(wChairID, lScore, baseScore)
    if lScore <= 0 then return end
    local pJetton = self.m_pJetton[wChairID]
    if not pJetton then return end

    -- 计算显示的筹码数量 --
    local nCount = 0
    local Max_Jetton_Count = 60
    if #pJetton == 0 then
        nCount = math.min(Max_Jetton_Count, math.max(1, math.floor(lScore / baseScore * 0.5)))
    else
        local nMaxLayer = 1
        local max_score = 0
        for _, v in ipairs(pJetton) do
            if (v.m_lScore > max_score) then
                nMaxLayer = v.m_nCount
                max_score = v.m_lScore
            end
        end
        nCount = math.min(Max_Jetton_Count, math.max(1, math.floor(lScore * nMaxLayer / max_score)))
    end

    local panenCannon = FishGame2DLogic.getInstance():GetUILayer():GetChairPanel(wChairID)
    if not panenCannon then return end

    local reverse = panenCannon.bUp
    local xOffset
    if FishGame2DLogic.getInstance():getMyChairId() == wChairID then
        if panenCannon.id % 2 == (panenCannon.bUp and 1 or 0) then
            xOffset =  -150
        else
            xOffset = 345
        end
    else
        if panenCannon.id % 2 == (panenCannon.bUp and 1 or 0) then
            xOffset = -280
        else
            xOffset = 85
        end
    end
    local x = panenCannon.widgetCannon:getPositionX() + xOffset
    local y = panenCannon.widgetCannon:getPositionY() + (panenCannon.bUp and -75 or 75)
    local lastJetton = pJetton[#pJetton]

    local color = Jetton.COLOR.GREEN
    if lastJetton and lastJetton:GetColor() == Jetton.COLOR.GREEN then
        color = Jetton.COLOR.RED
    end

    local jettonCount = self:GetMaxJettonCount()
    local jetton = Jetton.new({
        wChairID = wChairID,
        lScore = lScore,
        nColor = color,
        nCount = nCount,
        bUp = panenCannon.bUp,
        bReverse = reverse,
        onRevemoHandler = handler(self, self._onJettonRemoved)
    })
    if reverse then
        jetton:pos(x + math.min(jettonCount, #pJetton) * Jetton.INTERVAL + Jetton.INTERVAL * 0.5, y)
    else
        jetton:pos(x - math.min(jettonCount, #pJetton) * Jetton.INTERVAL - Jetton.INTERVAL * 0.5, y)
    end
    self:AddEffectUp(jetton, "-1")

    table.insert(pJetton, jetton)

    for i = 1, #pJetton - jettonCount + 1 do
        pJetton[i]:_doAction_End()
    end
end


function FishGameScene:showEffectPartical(x, y, name)
    local config = FishGameConfig.PARTICAL_CONFIG[name]
    if not config then return end

    local animaNode = ccs.Armature:create(config.AniImage)
    animaNode:getAnimation():play(config.AniName)
    animaNode:setAnchorPoint(0.5, 0.5)
    if name == "salute1" then
        animaNode:setPosition(x, y + 270)
    else
        animaNode:setPosition(x, y)
    end
    animaNode:runAction(transition.sequence({
        cc.DelayTime:create(1.95),
        cc.CallFunc:create(function(sender)
            sender:removeSelf()
        end)
    }))
    self:addEffectUp(animaNode, config.AniImage)
    if name == "bomb" then
        self:getFishGameManager():getSoundManager():playEffect("BigBang.mp3")
    elseif name == "switch" then
        self:getFishGameManager():getSoundManager():playEffect("fireworks.mp3")
    else
        self:getFishGameManager():getSoundManager():playEffect("Bigfireworks.mp3")
    end
end


local intervalX = 20
local jumpByX = 20
local jumByHeight = 100
local opacity = { 0xFF, 0xFF * 0.3, 0xFF * 0.1 }
local shadowCount_1 = #opacity - 1
local function funcHide(sender)
    sender:setVisible(true)
end

function FishGameScene:showFishGold(args)
    args = args or {}
    local fishX = args.fishX or 0
    local fishY = args.fishY or 0
    local cannonX = args.cannonX or 0
    local cannonY = args.cannonY or 0
    local score = args.score or 0
    local base = args.base or 0
    local wChairID = args.wChairID or 0

    if score <= 0 then return end

    self._cacheMng:setCacheLimit("fish_jinbi_1", 100)
    local runningCount = self._cacheMng:getRunningCount("fish_jinbi_1")
    local xxx = (100 - runningCount) / 100

    local shadowCount = math.max(1 + math.ceil(shadowCount_1 * xxx), 2)
    --    local start = shadowCount - math.min(math.floor(#opacity * xxx),2)

    local coin_count = score / base * 0.5

    if (coin_count > 10) then coin_count = 10 end
    coin_count = coin_count * xxx

    if (coin_count < 1) then coin_count = 1 end

    local offsetX = fishX - intervalX * coin_count * 0.5 - 40
    local distance = game.fishgame2d.MathAide:CalcDistance(fishX, fishY, cannonX, cannonY)
    local distanceTime = distance / 2000

    for i = 1, coin_count do
        local x = offsetX + intervalX * (coin_count - i)
        for j = 1, shadowCount do
            local icon = self._cacheMng:getCachedNode("fish_jinbi_1")
            if not icon then
                icon = ccs.Armature:create("fish_jinbi_1")
                icon:getAnimation():play("move")
                self:addEffectUp(icon, "fish_jinbi_1")

                self._cacheMng:addNode("fish_jinbi_1", icon)
            end

            icon:setPosition(x, fishY)
            icon:setScale(0.8)
            icon:setOpacity(opacity[j])

            icon:setVisible(false)
            icon:runAction(transition.sequence({
                cc.DelayTime:create(0.2 * i + 0.2 / shadowCount * (j - 1)),
                cc.CallFunc:create(funcHide),
                cc.JumpBy:create(0.6, cc.p(jumpByX, 0), jumByHeight, 2),
                cc.DelayTime:create(0.1),
                cc.MoveTo:create(distanceTime, cc.p(cannonX, cannonY)),
                cc.CallFunc:create(function(sender)
                    --sender:removeSelf()
                    self._cacheMng:markUnused(sender)
                end)
            }))
            icon = nil
        end
    end
end

function FishGameScene:showFishGoldLabel(args)
    args = args or {}
    local fishX = args.fishX or 0
    local fishY = args.fishY or 0
    local cannonX = args.cannonX or 0
    local cannonY = args.cannonY or 0
    local score = args.score or 0
    local base = args.base or 0
    local wChairID = args.wChairID or 0

    if score <= 0 then return end

    score = CustomHelper.moneyShowStyleNone(score)

    -- 金币数字显示 --
    local labelScore = cc.LabelAtlas:_create("0123456789", "ui/gold_hit_numbers.png", 117, 150, 48)
    self:addEffectUp(labelScore, "gold_hit_numbers.png")
    labelScore:setString(score or 0)
    labelScore:setAnchorPoint(0.5, 0.5)
    labelScore:move(fishX, fishY)

    labelScore:setOpacity(63)
    labelScore:setScale(0.13)
    labelScore:runAction(transition.sequence({
        cc.Spawn:create({
            cc.FadeTo:create(0.1, 0xFF),
            transition.sequence({
                cc.ScaleTo:create(0.1, 0.56),
                cc.ScaleTo:create(0.15, 0.43),
            }),
        }),
        cc.DelayTime:create(0.73),
        cc.FadeTo:create(0.34, 198),
        cc.Spawn:create({
            cc.FadeTo:create(0.24, 25),
            cc.ScaleTo:create(0.24, 0.13),
        }),
        cc.CallFunc:create(function(sender)
            sender:removeSelf()
        end)
    }))
    labelScore = nil
end

--- 弹出缺钱提示
function FishGameScene:showAlertLackMoney(needMoneyTip,compareMoney)
    local cancalCallbackFunc = function() self:returnToHallScene() end
    local closeCallbackFunc = function() self:returnToHallScene() end
    local bankCallbackFunc = function()
        local BankCenterLayer = requireForGameLuaFile("BankCenterLayer")
        self:returnToHallScene({
            { tag = ViewManager.SECOND_LAYER_TAG.BANK, parme = BankCenterLayer.ViewType.WithDraw },
        })
    end
    local storyCallbackFunc = function()
        self:returnToHallScene({
            { tag = ViewManager.SECOND_LAYER_TAG.STORY },
        })
    end

    local dataMgr = self:getDataManager()
    local player = dataMgr:getMyPlayerInfo()
    local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();

    local money = player:getScore()
    local bank = myPlayerInfo:getBank()
    if money >= compareMoney then return false end

    local TipLayer = requireForGameLuaFile("TipLayer");
    local tipLayer = TipLayer:create();
    if money + bank >= compareMoney then --银行有钱足够，可以去提款
        tipLayer:showLackMoneyAlertView(needMoneyTip, "bank", "story", bankCallbackFunc, storyCallbackFunc, closeCallbackFunc)
    else --银行有钱不过，去充值
        tipLayer:showLackMoneyAlertView(needMoneyTip, nil, "story", cancalCallbackFunc, storyCallbackFunc, closeCallbackFunc)
    end

    local tipLayerName = CustomHelper.md5String("TipLayer")
    tipLayer:setName(tipLayerName);
    local parent = cc.Director:getInstance():getRunningScene();
    if parent:getChildByName(tipLayerName) then
        --todo
        return tipLayer;
    end
    parent:addChild(tipLayer, 1000);
    return true;
end

--- 创建背景
function FishGameScene:createBackground(id)
    local image = FishGameConfig.IMAGE_SCENE[id] or FishGameConfig.IMAGE_SCENE[1]
    local background = display.newSprite(image)

    local effBubble = ccs.Armature:create("bubble_full_eff")
    effBubble:getAnimation():play("ani_01")
    effBubble:align(display.CENTER, display.cx, display.cy):addTo(background)

    local effWater = ccs.Armature:create("effect_bg_water")
    effWater:getAnimation():play("effect_bg_water_animation")
    effWater:align(display.CENTER, display.cx, display.cy):addTo(background)

    return background
end

--- 切换场景
function FishGameScene:updateSceneBackground(id, bInit)
    -- 播放切换场景音乐
    local dataMng = self:getDataManager()
    local gameMng = self:getFishGameManager()
    gameMng:getSoundManager():playBGM(id, bInit)

    if bInit then
        if not tolua.isnull(self._background) then
            self._background:removeSelf()
        end

        local background = self:createBackground(id)
        background:align(display.CENTER, display.cx, display.cy):addTo(self, LAYER_ZORDER.BACKGROUND)
        if dataMng:getMirrorShow() then
            background:setRotation(180)
        else
            background:setRotation(0)
        end

        self._background = background
    else
        -- 关闭切换场景时碰撞
        game.fishgame2d.FishObjectManager:GetInstance():SetSwitchingScene(true)

        local speed = 230
        local xBG = display.width + 100
        local xWater = display.width + 400
        local timeBg = (xBG) / speed
        local timeWater = (xWater) / speed

        if not tolua.isnull(self._background) then
            self._background:runAction(transition.sequence({
                cc.DelayTime:create(timeBg),
                cc.CallFunc:create(function(sender)
                    sender:removeSelf()
                end)
            }))
            self._background = nil
        end

        local background = self:createBackground(id)
        background:addTo(self, LAYER_ZORDER.BACKGROUND_SWITCH)

        if dataMng:getMirrorShow() then
            background:setRotation(180)
            background:align(display.CENTER, -xBG + display.cx, display.cy)
        else
            background:setRotation(0)
            background:align(display.CENTER, xBG + display.cx, display.cy)
        end
        background:runAction(transition.sequence({
            cc.MoveTo:create(timeBg, cc.p(display.cx, display.cy)),
            cc.CallFunc:create(function(sender)
                sender:setLocalZOrder(LAYER_ZORDER.BACKGROUND)

                -- 打开切换场景后碰撞
                game.fishgame2d.FishObjectManager:GetInstance():SetSwitchingScene(false)
                game.fishgame2d.FishObjectManager:GetInstance():RemoveAllFishes(false)
            end)
        }))
        self._background = background

        -- 波纹动画
        local bgSwitchWater = self._bgSwitchWater
        bgSwitchWater:stopAllActions()
        bgSwitchWater:show()
        if dataMng:getMirrorShow() then
            bgSwitchWater:setRotation(180)
            bgSwitchWater:align(display.LEFT_CENTER, 0, display.cy)
            bgSwitchWater:runAction(transition.sequence({
                cc.MoveBy:create(timeWater, cc.p(xWater, 0)),
                cc.CallFunc:create(function(sender)
                    sender:hide()
                end)
            }))
        else
            bgSwitchWater:setRotation(0)
            bgSwitchWater:align(display.LEFT_CENTER, display.width, display.cy)
            bgSwitchWater:runAction(transition.sequence({
                cc.MoveBy:create(timeWater, cc.p(-xWater, 0)),
                cc.CallFunc:create(function(sender)
                    sender:hide()
                end)
            }))
        end
    end
end

--- 更新声音和音乐状态
function FishGameScene:updateMusicAndSoundStatus()
    local panel_menu = self._mainUI:getChildByName("panel_menu")

    local nodeMusic = panel_menu:getChildByName("btn_music")
    local nodeSound = panel_menu:getChildByName("btn_sound")

    local musicSwitch = GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
    nodeMusic:loadTextureNormal(musicSwitch and FishGameConfig.BTN_IMG.MUSIC_ON_N or FishGameConfig.BTN_IMG.MUSIC_OFF_N)
    nodeMusic:loadTexturePressed(musicSwitch and FishGameConfig.BTN_IMG.NUSIC_ON_P or FishGameConfig.BTN_IMG.MUSIC_OFF_P)
    nodeMusic:loadTextureDisabled(musicSwitch and FishGameConfig.BTN_IMG.NUSIC_ON_P or FishGameConfig.BTN_IMG.MUSIC_OFF_P)

    local soundSwitch = GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
    nodeSound:loadTextureNormal(soundSwitch and FishGameConfig.BTN_IMG.SOUND_ON_N or FishGameConfig.BTN_IMG.SOUND_OFF_N)
    nodeSound:loadTexturePressed(soundSwitch and FishGameConfig.BTN_IMG.SOUND_ON_P or FishGameConfig.BTN_IMG.SOUND_OFF_P)
    nodeSound:loadTextureDisabled(soundSwitch and FishGameConfig.BTN_IMG.SOUND_ON_P or FishGameConfig.BTN_IMG.SOUND_OFF_P)
end

return FishGameScene
