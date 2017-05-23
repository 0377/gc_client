--
-- Author: Your Name
-- Date: 2016-12-29 14:41:41
-- 游戏场景
--

local SubGameBaseScene = requireForGameLuaFile("SubGameBaseScene")
local FishGameScene = class(classname, SubGameBaseScene)
local FishGameFish = requireForGameLuaFile("FishGameFish")
local FishGameBullet = requireForGameLuaFile("FishGameBullet")
local Visual = requireForGameLuaFile("Visual")
local Fishes = requireForGameLuaFile("Fishes")
local CDefine = requireForGameLuaFile("CDefine")

local FishGameConfig = requireForGameLuaFile("FishGameConfig")
local FishGameXMLConfigManager = requireForGameLuaFile("FishGameXMLConfigManager")
local FishGameDataManager = requireForGameLuaFile("FishGameDataManager")
local FishGamePlayerInfo = requireForGameLuaFile("FishGamePlayerInfo")
local TestFishLayer = requireForGameLuaFile("TestFishLayer")
local FishGameBubble = requireForGameLuaFile("FishGameBubble")
local CachedNodeManager = requireForGameLuaFile("CachedNodeManager")

local dispatcher = cc.Director:getInstance():getEventDispatcher()

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

    --TestFishLayer.create():addTo(self, LAYER_ZORDER.TEST_LAYER)


    self.m_pBubbles = {}
    self.m_pBubbleLayer = display.newLayer():addTo(self, LAYER_ZORDER.BUBBLE)
    for i=1,4 do
        self.m_pBubbles[i] = FishGameBubble:create(i):align(display.LEFT_BOTTOM,0,0):addTo(self.m_pBubbleLayer)
    end
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

    local objMng = game.fishgame2d.FishObjectManager:GetInstance()
    objMng:RegisterBulletHitFishHandler(handler(self, self.on_event_BulletHitFish))
    objMng:RegisterEffectHandler(handler(self, self.on_event_FishEffect))
    objMng:Init(1280, 720, "config/")
    --    local pathManager = objMng:GetPathManager()
    --    pathManager:LoadData("config/", function(percent)
    --        if percent == 1 then
    --            self:on_msg_SendFish()
    --        end
    --    end)
    -- self.rootPath = DdzGameManager:getInstance():getPackageRootPath();
    -- elf.csbRootPath = "res/"..self.rootPath.."res/csb/"
    -- cc.FileUtils:getInstance():addSearchPath(self.csbRootPath, true)
    -- cc.FileUtils:getInstance():addSearchPath(self.csbRootPath.."game_res", true)

    local CCSLuaNode = requireForGameLuaFile("FishGameCCS")
    self._mainWnd = CCSLuaNode:create().root;
    self:addChild(self._mainWnd, LAYER_ZORDER.UI)
    self._touchLayer = display.newLayer()
    self:addChild(self._touchLayer, LAYER_ZORDER.TOUCH)
    self._touchLayer:setZOrder(0)
    self._touchLayer:registerScriptTouchHandler(handler(self, self.onTouchTTTTT))
    self._touchLayer:setTouchEnabled(true)
	
    self._effectLayer = display.newLayer()
    self:addChild(self._effectLayer)
    self._effectLayer:setZOrder(1)

    -- 初始化XML配置管理器
    self._xmlConfigManager = FishGameXMLConfigManager:getInstance()

    -- 初始化局部变量 --------------
    self._musicOpen = true
    self._soundOpen = true
    self._targetPos = cc.p(0, 0)
	self._lastFireTime = 0
	self._lastTouchTime = 0

    -- 玩家控件列表 --------------------
    self._playersUI = {}
    for i = 0, FishGameConfig.PLAYER_COUNT - 1 do
        self._playersUI[i] = {}
    end

    -- 初始化界面 ------------------
    self:initUI()

    -- 初始化声音
    self._musicOpen = not GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
    self._soundOpen = not GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
    self:onBtnSound(self._btnSound, ccui.TouchEventType.ended)
    self:onBtnMusic(self._btnMusic, ccui.TouchEventType.ended)

    -- 设置界面默认值
    self._ruleWndSelect = FishGameConfig.RULE_SELECT.NORMAL
    self:dealRuleSelect(self._ruleWndSelect)

    self._menuOpen = false
    self._pnlMenu:setVisible(self._menuOpen)

    --  添加玩家数据   测试数据！！！！！！！！！！！！！！！！！！！
    --    local dataMgr = FishGameManager:getInstance():getDataManager()
    --    dataMgr:addPlayer(0, 3, 9)
    --    dataMgr:addPlayer(1, 6, 9)
    --    dataMgr:addPlayer(0, 1, 9)
    --    dataMgr:addPlayer(0, 5, 8)

    -- 初始化XML配置 ---------------
    self:intXMLConfig()

    -- 初始化玩家 ------------------
    self:initPlayers()

    -- 初始化炮台信息 --------------
    self:initCannon()

    self:initBgSwitchWater()
end

-- 预加载资源路径
function FishGameScene.getNeedPreloadResArray()
    -- body
    print("getNeedPreloadResArray.............................")
    local resPaths = {
        CustomHelper.getFullPath("anim/fish_jinbi_1/fish_jinbi_1.ExportJson"),
        CustomHelper.getFullPath("anim/bubble_full_eff/bubble_full_eff.ExportJson"),
        CustomHelper.getFullPath("anim/effect_bg_water/effect_bg_water.ExportJson"),
        CustomHelper.getFullPath("anim/effect_transition_water/effect_transition_water.ExportJson"),
        CustomHelper.getFullPath("anim/effect_fish_bomb/effect_fish_bomb.ExportJson"),
        CustomHelper.getFullPath("anim/bb_likui_pao_bullet/bb_likui_pao_bullet.ExportJson"),
        CustomHelper.getFullPath("anim/effect_weapons_replace/effect_weapons_replace.ExportJson"),
    }

    local data = {}
    for _, v in pairs(Visual) do
        for __, vv in ipairs(v.die) do
            data[vv.image] = true
        end
        for __, vv in ipairs(v.live) do
            data[vv.image] = true
        end
    end
    for k, v in pairs(data) do
        table.insert(resPaths, CustomHelper.getFullPath("anim/fishes/" .. k .. ".ExportJson"))
    end


    for k, v in pairs(ChainConfig) do
        table.insert(resPaths, CustomHelper.getFullPath("anim/fishes/" .. v.image .. ".ExportJson"))
    end


    for k, v in pairs(FishGameConfig.PARTICAL_CONFIG) do
        dump("anim/" .. v.AniImage .. ".ExportJson")
        table.insert(resPaths, CustomHelper.getFullPath("anim/" .. v.AniImage .. "/" .. v.AniImage .. ".ExportJson"))
    end

    return resPaths
end

function FishGameScene:onEnter()
    self:switchScene(1, true)

    self._time = socket.gettime()
    self:onUpdate(handler(self, self._onInterval))

    self._scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self._onInterval_timeSync), 10, false)
    self:_onInterval_timeSync()

    self:getFishGameManager():sendGameReady()
end

function FishGameScene:onExit()
    if self._scheduler ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)
        self._scheduler = nil
    end

    --self._sound:Clear()  
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



    -- 更新锁定鱼的气泡
    for i=1,4 do
        self.m_pBubbles[i]:_onInterval(dt)
    end
end

function FishGameScene:_onInterval_timeSync()
    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager()
    subGameManager:send_CS_TimeSync()
end

-- 初始化XML配置
function FishGameScene:intXMLConfig()
end

-- 初始化界面
function FishGameScene:initUI()

    self:initMenuUI()

    self:initRuleWnd()
end

-- 初始化右边菜单栏
function FishGameScene:initMenuUI()

    self._btnShowMenu = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "btn_show_menu"), "ccui.Button")
    self._btnShowMenu:addTouchEventListener(handler(self, self.onBtnShowMenu))

    self._layerGame = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "layer_game"), "ccui.Layout"):hide()

    self._pnlMenu = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "panel_menu"), "ccui.Layout")

    self._btnRule = tolua.cast(CustomHelper.seekNodeByName(self._pnlMenu, "btn_rule"), "ccui.Button")
    self._btnRule:addTouchEventListener(handler(self, self.onBtnRule))

    self._btnMusic = tolua.cast(CustomHelper.seekNodeByName(self._pnlMenu, "btn_music"), "ccui.Button")
    self._btnMusic:addTouchEventListener(handler(self, self.onBtnMusic))

    self._btnSound = tolua.cast(CustomHelper.seekNodeByName(self._pnlMenu, "btn_sound"), "ccui.Button")
    self._btnSound:addTouchEventListener(handler(self, self.onBtnSound))

    self._btnQuit = tolua.cast(CustomHelper.seekNodeByName(self._pnlMenu, "btn_quit"), "ccui.Button")
    self._btnQuit:addTouchEventListener(handler(self, self.onBtnQuit))
end

-- 初始化规则界面
function FishGameScene:initRuleWnd()

    self._pnlRuleWnd = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "RuleView"), "ccui.Layout")
    self._pnlRuleWnd:setVisible(false)

    self._btnClose = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_close"), "ccui.Button")
    self._btnClose:addTouchEventListener(handler(self, self.onBtnRuleClose))

    self._btnNormal = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_normal"), "ccui.Button")
    self._btnNormal:addTouchEventListener(handler(self, self.onBtnRuleNormal))

    self._btnBigFish = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_big"), "ccui.Button")
    self._btnBigFish:addTouchEventListener(handler(self, self.onBtnRuleBigFish))

    self._btnSpecial = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_special"), "ccui.Button")
    self._btnSpecial:addTouchEventListener(handler(self, self.onBtnRuleSpecial))

    self._btnBoss = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_boss"), "ccui.Button")
    self._btnBoss:addTouchEventListener(handler(self, self.onBtnRuleBoss))

    self._pnlNormal = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_normal"), "ccui.Layout")

    self._pnlBigFish = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_bigfish"), "ccui.Layout")

    self._pnlSpecial = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_special"), "ccui.Layout")

    self._pnlBoss = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_boss"), "ccui.Layout")
end

-- 初始化玩家
function FishGameScene:initPlayers()

    self:initLTPlayer()

    self:initRTPlayer()

    self:initLBPlayer()

    self:initRBPlayer()
end

-- 点击事件
function FishGameScene:onTouchTTTTT(eventType, x, y)
	local time = socket.gettime()
    local dt = time - self._lastFireTime	
	local dataMgr = FishGameManager:getInstance():getDataManager()
	local fireInterval = dataMgr:getFireInterval()
	dump(eventType,"eventType")
	if dt*1000 >= fireInterval then
		self._lastFireTime = time
		self._targetPos = cc.p(x, y)
		local mychair = dataMgr:getMyChairId()
		local idx = mychair - 1
		local angle = self:updateCannonRotationToPosition(mychair, self._targetPos)
		if idx == FishGameConfig.PLAYER.LEFTTOP or idx == FishGameConfig.PLAYER.RIGHTTOP then
			angle = angle + math.pi / 2
		end

		angle = angle + math.pi / 2

		self._playersUI[idx].pnlCannon:setRotation(math.deg(math.pi - angle))

		self:fireTo(angle)
	end

--
--    self:addFishGold( {
--        fishX = x,
--        fishY = y,
--        cannonX = display.cx,
--        cannonY = 0,
--        score = 10,
--        baseScore = 1,
--    })

    --	for k = 1, FishGameConfig.PLAYER_COUNT do
    --		local idx = k - 1
    --	    local fireEffect = ccs.Armature:create("effect_bar_glod")
    --		fireEffect:getAnimation():play("star_yellow_Copy13_Copy15")
    --
    --		local v    = self._playersUI[idx].pnlCannon:getWorldPosition()
    --		local posx = v.x
    --		local posy = v.y
    --		local size = self._playersUI[idx].pnlCannon:getSize()
    --
    --		if idx == FishGameConfig.PLAYER.LEFTTOP or  idx == FishGameConfig.PLAYER.RIGHTTOP then
    --			fireEffect:setPosition(cc.p(posx , posy - size.height))
    --		elseif idx == FishGameConfig.PLAYER.RIGHTBOTTOM or idx == FishGameConfig.PLAYER.LEFTBOTTOM then
    --			fireEffect:setPosition(cc.p(posx , posy + size.height))
    --		end
    --
    --		self._effectLayer:addChild(fireEffect)
    --		fireEffect:runAction(transition.sequence({
    --			cc.DelayTime:create(0.5),
    --			cc.CallFunc:create(function(sender)
    --				sender:removeSelf()
    --			end)
    --		}))
    --	end


    --    if eventType == "began" then
    --        return true
    --    elseif eventType == "ended" then
    --                self:fireTo(math.rad(angle))
    --
    --
    --        --        self:addPartical({
    --        --            xPos = x,
    --        --            yPos = y,
    --        --            name = "salute1",
    --        --        })
    --- -        self:addChain({
    ---- start_x = display.width * 0.25,
    ---- start_y = display.cy,
    ---- end_x = display.width * 0.75,
    ---- end_y = display.cy,
    ---- type = E_Light
    ---- })
    -- end
end

-- 旋转炮台角度
function FishGameScene:updateCannonRotationToPosition(chairID, targetPos)
    local idx = chairID - 1
    local v = self._playersUI[idx].pnlCannon:getWorldPosition()

    --计算两点之间的夹角
    local dx = targetPos.x - v.x
    local dy = targetPos.y - v.y;
    local dis = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2)); --斜边长度

    local cos0 = dx / dis;
    local rad = math.acos(cos0);

    return rad
end

-- 初始化左上玩家
function FishGameScene:initLTPlayer()
    self._playersUI[FishGameConfig.PLAYER.LEFTTOP].txtScore = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plt_txt_score"), "ccui.Text")

    self._playersUI[FishGameConfig.PLAYER.LEFTTOP].pnlPlayer = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "player_lefttop"), "ccui.Layout")
    self._playersUI[FishGameConfig.PLAYER.LEFTTOP].pnlCannon = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plt_pnl_cannon"), "ccui.Layout")
end

-- 初始化右上玩家
function FishGameScene:initRTPlayer()
    self._playersUI[FishGameConfig.PLAYER.RIGHTTOP].txtScore = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prt_txt_score"), "ccui.Text")

    self._playersUI[FishGameConfig.PLAYER.RIGHTTOP].pnlPlayer = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "player_righttop"), "ccui.Layout")
    self._playersUI[FishGameConfig.PLAYER.RIGHTTOP].pnlCannon = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prt_pnl_cannon"), "ccui.Layout")
end

-- 初始化左下玩家
function FishGameScene:initLBPlayer()
    self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].txtScore = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plb_txt_score"), "ccui.Text")

    self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].btnSub = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plb_btn_sub"), "ccui.Button")
    self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].btnSub:addTouchEventListener(handler(self, self.onBtnChangeCannon))

    self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].btnAdd = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plb_btn_add"), "ccui.Button")
    self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].btnAdd:addTouchEventListener(handler(self, self.onBtnChangeCannon))

    self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].pnlInfo = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plb_player_info"), "ccui.Layout")

    self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].txtName = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plb_txt_player_name"), "ccui.Text")

    self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].pnlPlayer = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "player_leftbottom"), "ccui.Layout")
    self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].pnlCannon = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plb_pnl_cannon"), "ccui.Layout")
    self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].pnlLockFish = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plb_pnl_lockfishbk"), "ccui.Layout")
	self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].txtMoney = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plb_txt_money"), "ccui.TextAtlas")
end

-- 初始化右下玩家
function FishGameScene:initRBPlayer()
    self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].txtScore = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prb_txt_score"), "ccui.Text")

    self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].btnSub = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prb_btn_sub"), "ccui.Button")
    self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].btnSub:addTouchEventListener(handler(self, self.onBtnChangeCannon))

    self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].btnAdd = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prb_btn_add"), "ccui.Button")
    self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].btnAdd:addTouchEventListener(handler(self, self.onBtnChangeCannon))

    self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].pnlInfo = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prb_player_info"), "ccui.Layout")

    self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].txtName = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prb_txt_player_name"), "ccui.Text")

    self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].pnlPlayer = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "player_rightbottom"), "ccui.Layout")
    self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].pnlCannon = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prb_pnl_cannon"), "ccui.Layout")
    self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].pnlLockFish = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prb_pnl_lockfishbk"), "ccui.Layout")
	self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].txtMoney = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prb_txt_money"), "ccui.TextAtlas")
end

-- 显示菜单按钮点击事件
function FishGameScene:onBtnShowMenu(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    elseif eventType == ccui.TouchEventType.ended then
        self._menuOpen = not self._menuOpen
        self:dealMenuSwitchAction()

        for k = 1, FishGameConfig.PLAYER_COUNT do
            self:refreshPlayerInfo(k)
        end

    end
end

-- 处理菜单动画
function FishGameScene:dealMenuSwitchAction()
    self._pnlMenu:setVisible(self._menuOpen)
    if self._menuOpen == true then
        self._btnShowMenu:loadTextureNormal(FishGameConfig.BTN_IMG.MENU_DOWN_N)
        self._btnShowMenu:loadTexturePressed(FishGameConfig.BTN_IMG.MENU_DOWN_P)
        self._btnShowMenu:loadTextureDisabled(FishGameConfig.BTN_IMG.MENU_DOWN_P)
    else
        self._btnShowMenu:loadTextureNormal(FishGameConfig.BTN_IMG.MENU_UP_N)
        self._btnShowMenu:loadTexturePressed(FishGameConfig.BTN_IMG.MENU_UP_P)
        self._btnShowMenu:loadTextureDisabled(FishGameConfig.BTN_IMG.MENU_UP_P)
    end
end

function FishGameScene:onBtnRule(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        local ruleWndShow = self._pnlRuleWnd:isVisible()
        ruleWndShow = not ruleWndShow
        self._pnlRuleWnd:setVisible(ruleWndShow)

        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    end
end

function FishGameScene:onBtnChangeCannon(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        print("FishGameScene:onBtnChangeCannon!!!!!!!!!!!")
        local isAdd = 0
        if sender:getName() == "plb_btn_add" or sender:getName() == "prb_btn_add" then
            isAdd = 1
        end

        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        FishGameManager:getInstance():send_CS_ChangeCannon(isAdd)
    end
end


function FishGameScene:onBtnSound(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        self._soundOpen = not self._soundOpen
        if self._soundOpen == true then
            self._btnSound:loadTextureNormal(FishGameConfig.BTN_IMG.SOUND_ON_N)
            self._btnSound:loadTexturePressed(FishGameConfig.BTN_IMG.SOUND_ON_P)
            self._btnSound:loadTextureDisabled(FishGameConfig.BTN_IMG.SOUND_ON_P)

            GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch(true)
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        else
            self._btnSound:loadTextureNormal(FishGameConfig.BTN_IMG.SOUND_OFF_N)
            self._btnSound:loadTexturePressed(FishGameConfig.BTN_IMG.SOUND_OFF_P)
            self._btnSound:loadTextureDisabled(FishGameConfig.BTN_IMG.SOUND_OFF_P)

            GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch(false)
            GameManager:getInstance():getMusicAndSoundManager():stopAllSound();
        end
    end
end

function FishGameScene:onBtnMusic(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        self._musicOpen = not self._musicOpen
        if self._musicOpen == true then
            self._btnMusic:loadTextureNormal(FishGameConfig.BTN_IMG.MUSIC_ON_N)
            self._btnMusic:loadTexturePressed(FishGameConfig.BTN_IMG.MUSIC_ON_P)
            self._btnMusic:loadTextureDisabled(FishGameConfig.BTN_IMG.MUSIC_ON_P)

            GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch(true)
            self:getFishGameManager():getSoundManager():playBGM(nil, true)
        else
            self._btnMusic:loadTextureNormal(FishGameConfig.BTN_IMG.MUSIC_OFF_N)
            self._btnMusic:loadTexturePressed(FishGameConfig.BTN_IMG.MUSIC_OFF_P)
            self._btnMusic:loadTextureDisabled(FishGameConfig.BTN_IMG.MUSIC_OFF_P)

            GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch(false)
            GameManager:getInstance():getMusicAndSoundManager():stopMusic()
        end
    end
end

function FishGameScene:initCannonInfo(chair_id)
    if chair_id < 0 or chair_id >= FishGameConfig.PLAYER_COUNT then return end
    local idx = chair_id + 1
    local dataMgr = FishGameManager:getInstance():getDataManager()
    local playerInfo = dataMgr:getPlayerInfoById(idx)
    local cannonSetType = playerInfo:getCannonSet()
    local cannonType = playerInfo:getCannonType()
    local cannonSet = self._xmlConfigManager._cannonSetVector[cannonSetType]
    local cannon = cannonSet.Sets[cannonType]

    -- 清除原炮台
    self._playersUI[id].pnlCannon:removeAllChildren()

    -- 添加新炮台
    local rootPath = FishGameManager:getInstance():getPackageRootPath()
    local armature = ccs.Armature:create(cannon.Cannon.szResourceName)
    armature:getAnimation():play(cannon.Cannon.Name)
    self._playersUI[id].pnlCannon:addChild(armature)
end

function FishGameScene:initCannon()
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    for k, v in pairs(self._xmlConfigManager._cannonPosVector) do
        local id = k
        local posX = v.x
        local posY = v.y
        local direction = v.dir

        if id == FishGameConfig.PLAYER.LEFTBOTTOM then
            self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].pnlPlayer:setPosition(visibleSize.width * posX, 0)
            self._playersUI[FishGameConfig.PLAYER.LEFTBOTTOM].pnlCannon:setPosition(FishGameConfig.LBPLAYER_OFFSETX, visibleSize.height * posY)

            --self:initCannonInfo(id)
        elseif id == FishGameConfig.PLAYER.RIGHTBOTTOM then
            self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].pnlPlayer:setPosition(visibleSize.width * posX, 0)
            self._playersUI[FishGameConfig.PLAYER.RIGHTBOTTOM].pnlCannon:setPosition(FishGameConfig.RBPLAYER_OFFSETX, visibleSize.height * posY)


            --self:initCannonInfo(id)
        elseif id == FishGameConfig.PLAYER.RIGHTTOP then
            self._playersUI[FishGameConfig.PLAYER.RIGHTTOP].pnlPlayer:setPosition(visibleSize.width * posX, visibleSize.height)
            self._playersUI[FishGameConfig.PLAYER.RIGHTTOP].pnlCannon:setPosition(FishGameConfig.LTPLAYER_OFFSETX, visibleSize.height * (1 - posY))
            self._playersUI[FishGameConfig.PLAYER.RIGHTTOP].pnlCannon:setRotation(math.deg(math.pi))


            --self:initCannonInfo(id)
        elseif id == FishGameConfig.PLAYER.LEFTTOP then
            self._playersUI[FishGameConfig.PLAYER.LEFTTOP].pnlPlayer:setPosition(visibleSize.width * posX, visibleSize.height)
            self._playersUI[FishGameConfig.PLAYER.LEFTTOP].pnlCannon:setPosition(FishGameConfig.RTPLAYER_OFFSETX, visibleSize.height * (1 - posY))
            self._playersUI[FishGameConfig.PLAYER.LEFTTOP].pnlCannon:setRotation(math.deg(math.pi))

            --self:initCannonInfo(id)
        end
    end
end

function FishGameScene:initBgSwitchWater()

    local effSwitchWater = ccs.Armature:create("effect_transition_water")
    effSwitchWater:getAnimation():play("effect_transition_water_animation")

    effSwitchWater:align(display.LEFT_BOTTOM, 0, 0):addTo(self, LAYER_ZORDER.BACKGROUND_SWITCH_WATER)
    effSwitchWater:setVisible(false)
    self._bgSwitchWater = effSwitchWater
end


function FishGameScene:onBtnSound(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        self._soundOpen = not self._soundOpen
        if self._soundOpen == true then
            self._btnSound:loadTextureNormal(FishGameConfig.BTN_IMG.SOUND_ON_N)
            self._btnSound:loadTexturePressed(FishGameConfig.BTN_IMG.SOUND_ON_P)
            self._btnSound:loadTextureDisabled(FishGameConfig.BTN_IMG.SOUND_ON_P)
        else
            self._btnSound:loadTextureNormal(FishGameConfig.BTN_IMG.SOUND_OFF_N)
            self._btnSound:loadTexturePressed(FishGameConfig.BTN_IMG.SOUND_OFF_P)
            self._btnSound:loadTextureDisabled(FishGameConfig.BTN_IMG.SOUND_OFF_P)
        end
    end
end

function FishGameScene:onBtnQuit(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:returnToHallScene()
    end
end

function FishGameScene:onBtnRuleClose(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self._pnlRuleWnd:setVisible(false)
    end
end

function FishGameScene:onBtnRuleNormal(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:dealRuleSelect(FishGameConfig.RULE_SELECT.NORMAL)
    end
end

function FishGameScene:onBtnRuleBigFish(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:dealRuleSelect(FishGameConfig.RULE_SELECT.BIGFISH)
    end
end

function FishGameScene:onBtnRuleSpecial(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:dealRuleSelect(FishGameConfig.RULE_SELECT.SPECIAL)
    end
end

function FishGameScene:onBtnRuleBoss(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:dealRuleSelect(FishGameConfig.RULE_SELECT.BOSS)
    end
end

function FishGameScene:dealRuleSelect(sel)
    self._ruleWndSelect = sel
    if sel == FishGameConfig.RULE_SELECT.NORMAL then

        self._btnNormal:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_N)
        self._btnBigFish:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBoss:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnSpecial:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)

        self._pnlNormal:setVisible(true)
        self._pnlBigFish:setVisible(false)
        self._pnlBoss:setVisible(false)
        self._pnlSpecial:setVisible(false)

    elseif sel == FishGameConfig.RULE_SELECT.BIGFISH then

        self._btnNormal:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBigFish:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_N)
        self._btnBoss:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnSpecial:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)

        self._pnlNormal:setVisible(false)
        self._pnlBigFish:setVisible(true)
        self._pnlBoss:setVisible(false)
        self._pnlSpecial:setVisible(false)

    elseif sel == FishGameConfig.RULE_SELECT.SPECIAL then

        self._btnNormal:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBigFish:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBoss:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnSpecial:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_N)

        self._pnlNormal:setVisible(false)
        self._pnlBigFish:setVisible(false)
        self._pnlBoss:setVisible(false)
        self._pnlSpecial:setVisible(true)

    elseif sel == FishGameConfig.RULE_SELECT.BOSS then

        self._btnNormal:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBigFish:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBoss:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_N)
        self._btnSpecial:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)

        self._pnlNormal:setVisible(false)
        self._pnlBigFish:setVisible(false)
        self._pnlBoss:setVisible(true)
        self._pnlSpecial:setVisible(false)
    end
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
    elseif msgName == HallMsgManager.MsgName.SC_EnterRoomAndSitDown then
        self:on_msg_EnterRoomAndSitDown(msgTab)
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

function FishGameScene:hidePlayerInfo(chair_id)
    local idx = chair_id
    self._playersUI[idx].pnlInfo:setVisible(false)
    self._playersUI[idx].btnAdd:setVisible(false)
    self._playersUI[idx].btnSub:setVisible(false)
end

function FishGameScene:showPlayerInfo(chair_id)
    local idx = chair_id
    self._playersUI[idx].pnlInfo:setVisible(true)
    self._playersUI[idx].btnAdd:setVisible(true)
    self._playersUI[idx].btnSub:setVisible(true)
end

function FishGameScene:showCannonUI(chairid)
    local dataMgr = FishGameManager:getInstance():getDataManager()
    local player = dataMgr:getPlayerByChairId(chairid)
    local idx = chairid - 1
    if player ~= nil then
        local cannonSetV = player:getCannonSet()
        local cannonType = player:getCannonType()
        if cannonSetV == nil then cannonSetV = 0 end
        if cannonType == nil then cannonType = 0 end

        local cannonSet = self._xmlConfigManager._cannonSetVector[cannonSetV]
        local cannon = cannonSet.Sets[cannonType]
        self._playersUI[idx].pnlCannon:removeAllChildren()

        local rootPath = FishGameManager:getInstance():getPackageRootPath();
        local armature = ccs.Armature:create(cannon.Cannon.szResourceName)
        armature:getAnimation():play(cannon.Cannon.Name)
        self._playersUI[idx].pnlCannon:addChild(armature)

        local effectWeaponReplace = ccs.Armature:create("effect_weapons_replace")
        effectWeaponReplace:getAnimation():play("effect_weapons_replace_animation")
        self._playersUI[idx].pnlCannon:addChild(effectWeaponReplace)
        effectWeaponReplace:runAction(transition.sequence({
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function(sender)
                sender:removeSelf()
            end)
        }))
    end
end

function FishGameScene:setPlayerScore(chair_id, score)
    local s = score
    if s == nil then
        s = 0
    end
    local idx = chair_id
    self._playersUI[idx].txtScore:setString("" .. s .. "元")
end

function FishGameScene:showLockFishEffect(chair_id)
    local fishConfig = Fishes[18]
    local visualConfig = Visual[fishConfig.visualId]

    for _, v in ipairs(visualConfig.live) do
        local t_animation = ccs.Armature:create(v.image)
        t_animation:setScale(v.scale)
        local size = self._playersUI[0].pnlLockFish:getSize()
        dump(size, "size")
        t_animation:getAnimation():play(v.name)
        t_animation:setPosition(cc.p(size.width * 3 / 4, size.height * 3 / 4))

        self._playersUI[0].pnlLockFish:addChild(t_animation)
    end
end

function FishGameScene:removeLockFishEffect(chair_id)
    self._playersUI[0].pnlLockFish:removeAllChildren()
end

--  进入房间消息
function FishGameScene:on_msg_EnterRoomAndSitDown(msgTab)
end

--  中途有玩家进入消息
function FishGameScene:on_msg_NotifySitDown(msgTab)
end

--  中途退出玩家消息
function FishGameScene:on_msg_NotifyStandUp(msgTab)
end

function FishGameScene:on_msg_FishMul(msgTab)
end

function FishGameScene:on_msg_AddBuffer(msgTab)
end

function FishGameScene:on_msg_GameConfig(msgTab)
    local dataMgr = FishGameManager:getInstance():getDataManager()
    local mychair = dataMgr:getMyChairId() - 1
    if dataMgr:getMirrorShow() == true then
        if mychair == FishGameConfig.PLAYER.LEFTTOP then
            self:showPlayerInfo(FishGameConfig.PLAYER.LEFTBOTTOM)
            self:hidePlayerInfo(FishGameConfig.PLAYER.RIGHTBOTTOM)
        else
            self:showPlayerInfo(FishGameConfig.PLAYER.LEFTBOTTOM)
            self:hidePlayerInfo(FishGameConfig.PLAYER.RIGHTBOTTOM)
        end
		
    else
        if mychair == FishGameConfig.PLAYER.LEFTBOTTOM then
            self:showPlayerInfo(FishGameConfig.PLAYER.LEFTBOTTOM)
            self:hidePlayerInfo(FishGameConfig.PLAYER.RIGHTBOTTOM)
        else
            self:showPlayerInfo(FishGameConfig.PLAYER.RIGHTBOTTOM)
            self:hidePlayerInfo(FishGameConfig.PLAYER.LEFTBOTTOM)
        end
		
		local playerInfo  =  dataMgr:getPlayerByChairId(dataMgr:getMyChairId())
		if playerInfo ~= nil then
			local name = playerInfo:getNickName()
			self._playersUI[mychair].txtName:setString(playerInfo:getNickName())
			local bullet = self._xmlConfigManager._bulletVector[1]
			self._playersUI[mychair].txtScore:setString(""..bullet.nMulriple.."元")
		end
    end

    for _, v in ipairs(dataMgr._players) do
        if v ~= nil then
            self:showCannonUI(v:getChairId())
        end
    end
end

function FishGameScene:on_msg_BulletSet(msgTab)
end

function FishGameScene:on_msg_UserInfo(msgTab)
    local dataMgr = FishGameManager:getInstance():getDataManager()
    local mychair = msgTab.chair_id - 1
    mychair = dataMgr:getOperateChair(mychair)
	self._playersUI[mychair].txtMoney:setString(""..msgTab.score)
end

function FishGameScene:on_msg_ChangeScore(msgTab)
    dump(msgTab, "msgTab")
end

function FishGameScene:on_msg_SendDes(msgTab)
end

function FishGameScene:on_msg_LockFish(msgTab)
    --    msgTab.chair_id
    --    msgTab.lock_id
    -- 更新锁定界面
    local fish = game.fishgame2d.FishObjectManager:GetInstance():FindFish(msgTab.fish_id)
end

function FishGameScene:on_msg_AllowFire(msgTab)
end

function FishGameScene:on_msg_SwitchScene(msgTab)
    dump(msgTab)
    self:switchScene(msgTab.nst, msgTab.switching ~= 1)
end

function FishGameScene:on_msg_KillBullet(msgTab)
    local bullet = game.fishgame2d.FishObjectManager:GetInstance():FindBullet(msgTab.bullet_id)
    if bullet and bullet:getState() < EOS_DEAD then
        bullet:setState(EOS_DEAD)
    end
end

function FishGameScene:on_msg_KillFish(msgTab)
    --    FindFish
    --
    --    message SC_KillFish {
    --    enum MsgID { ID = 12110; }
    --    optional int32		chair_id=1;							//椅子ID
    --    optional int64	score=2;                  //鱼价值
    --    optional int32		fish_id=3;              //鱼ID
    --    optional int32			bscoe=4;              //子弹价值
    --    };
    dump(msgTab)

    local fish = game.fishgame2d.FishObjectManager:GetInstance():FindFish(msgTab.fish_id)
    if not fish then return end
    fish:setState(EOS_DEAD)
    local fishConf = Fishes[fish:getTypeId()]





    local x, y = fish:getPosition().x, fish:getPosition().y
    local canX, canY = FishGameXMLConfigManager:getInstance():getCannonPosition(msgTab.chair_id)

    -- 播放金币动画
    self:addFishGold( {
        fishX = x,
        fishY = y,
        cannonX = canX,
        cannonY = canY,
        score = msgTab.score ,
        baseScore = msgTab.bscoe,
    })


    local mul = msgTab.score / msgTab.bscoe
    --- 播放获取金币声音
    if self:getFishGameManager():getMyChairId() == msgTab.chair_id then
        local effect = mul < 30 and "Hit0.mp3" or (mul < 80 and "Hit1.mp3" or "Hit2.mp3")
        self:getFishGameManager():getSoundManager():playEffect(effect)
    end



    -- 鱼死亡时触发屏幕震动
    if fishConf.shakeScreen then
        local time = math.max(0.5, math.min(mul / 60, 1.5))
        local range = math.min(mul / 50, 2)
        self:shakeScreen(time, range, 0)
    end

    -- 播放鱼死亡的粒子动画
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
        self:addParticel({
            xPos = xPos,
            yPos = yPos,
            name = "salute1",
        })
    end

    -- 播放彩金动画
    if (fishConf.showBingo and mul >= 80) then
        self:showBingo({
            chair_id = msgTab.chair_id,
            score = msgTab.score,
        })
    end
end

function FishGameScene:on_msg_SendBullet(msgTab)

    --    self:addBullet(msgTab)

    --    dump(self:getFishGameManager():getMyChairId())
    --    dump(msgTab)
    if msgTab.chair_id ~= self:getFishGameManager():getDataManager():getMyChairId() then
        self:addBullet(msgTab)
    end
end

function FishGameScene:on_msg_CannonSet(msgTab)
    local dataMgr = FishGameManager:getInstance():getDataManager()
    local idx = msgTab.chair_id - 1
    idx = dataMgr:getOperateChair(idx)
    local cannonSetV = msgTab.cannon_set
    if cannonSetV == nil then cannonSetV = 0 end

    local cannonMul = msgTab.cannon_mul
    if cannonMul == nil then cannonMul = 0 end

    local cannonType = msgTab.cannon_type
    if cannonType == nil then cannonType = 0 end

    local cannonSet = self._xmlConfigManager._cannonSetVector[cannonSetV]
    local cannon = cannonSet.Sets[cannonType]
	local bullet = self._xmlConfigManager._bulletVector[cannonMul]
	dump(bullet,"bullet")

    local dataMgr = FishGameManager:getInstance():getDataManager()

    self._playersUI[idx].pnlCannon:removeAllChildren()

    local rootPath = FishGameManager:getInstance():getPackageRootPath();
    local armature = ccs.Armature:create(cannon.Cannon.szResourceName)
    armature:getAnimation():play(cannon.Cannon.Name)
    self._playersUI[idx].pnlCannon:addChild(armature)

    local effectWeaponReplace = ccs.Armature:create("effect_weapons_replace")
    effectWeaponReplace:getAnimation():play("effect_weapons_replace_animation")
    self._playersUI[idx].pnlCannon:addChild(effectWeaponReplace)
    effectWeaponReplace:runAction(transition.sequence({
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function(sender)
            sender:removeSelf()
        end)
    }))
	
	self._playersUI[idx].txtScore:setString(""..bullet.nMulriple.."元")
end

function FishGameScene:on_msg_SendFish(msgTab)
    self:addFish(msgTab)
end

function FishGameScene:on_msg_SendFishList(msgTab)
    for _, v in ipairs(msgTab.fishes) do
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
end

function FishGameScene:on_event_FishEffect(self, target, effect)
end

--- 添加鱼
function FishGameScene:addFish(fishInfo)
    --    dump(fishInfo)
    --    self._id = self._id or 0
    --    self._id = self._id + 1
    --    fishInfo = {
    --        fish_id = self._id,
    --        type_id = 802,
    --        path_id = math.random(100),
    --        create_tick = 0,
    --        offest_x = 0,
    --        offest_y = 0,
    --        dir = 0,
    --        delay = 0,
    --        server_tick = GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getServerTime(),
    --        fish_speed = 500,
    --        fis_type = 0,
    --        troop = false,
    --        refersh_id = 0,
    --    }


    local fish = FishGameFish:create(fishInfo)

    self.m_pFishLayer:addChild(fish)

    game.fishgame2d.FishObjectManager:GetInstance():AddFish(fish)

    local dataMgr = FishGameManager:getInstance():getDataManager()
    local player = dataMgr:getPlayerByChairId(1)
    player:setLockedFishId(fishInfo.fish_id)
    --    local fish = FishGameFish:create(fishInfo)
    --
    --    self.m_pFishLayer:addChild(fish)
    --    game.fishgame2d.FishObjectManager:GetInstance():AddFish(fish)

    return fish
end

function FishGameScene:refreshPlayerInfo(chair_id)
    local dataMgr = FishGameManager:getInstance():getDataManager()
    if dataMgr ~= nil then
        local playerInfo = dataMgr:getPlayerByChairId(chair_id)
        if playerInfo ~= nil then
            local idx = chair_id - 1
            dump(idx, "idx")
            if idx == FishGameConfig.PLAYER.LEFTTOP or
                idx == FishGameConfig.PLAYER.RIGHTTOP then
            else
            end
        end
    end
end

function FishGameScene:addBullet(data)
    self._bulletId = self._bulletId or 0
    self._bulletId = self._bulletId + 1

    local bullet = FishGameBullet:create(data)
    self.m_pBulletLayer:addChild(bullet)

    game.fishgame2d.FishObjectManager:GetInstance():AddBullet(bullet)


    --    local bullet = FishGameBullet:create(data)
    --    bullet:move(data.x_pos,data.y_pos)
    --    self.m_pBulletLayer:addChild(bullet)
    --
    --    game.fishgame2d.FishObjectManager:GetInstance():AddBullet(bullet)
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

function FishGameScene:fireTo(dir)
    self._bulletId = self._bulletId or 0
    self._bulletId = self._bulletId + 1
	local chairid = 0

	local po  = self._playersUI[chairid].pnlCannon:getWorldPosition()
	local x = po.x
	local y = po.y
    local serverTime = GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getServerTime()

    local data = {
        id = self._bulletId, -- 子弹ID
        chair_id = 0, -- 椅子ID
        create_tick = serverTime, -- 创建时间
        x_pos = x, -- X坐标
        y_pos = y, -- Y坐标
        cannon_type = 1, -- 炮类型
        multiply = 1, -- 子弹类型
        score = 0, -- 玩家金钱？
        direction = dir, -- 方向
        is_new = 0, -- 是否新子弹
        server_tick = serverTime, --系统时间
        is_double = 0, --双倍炮
    }

    self:addBullet(data)

    self:getFishGameManager():send_CS_Fire({
        direction = data.direction,
        fire_time = serverTime,
        client_id = self._bulletId,
    })
end

function FishGameScene:jumpToHallScene()
    self:returnToHallScene()
end

function FishGameScene:returnToHallScene()
    GameManager:getInstance():getHallManager():getHallMsgManager():sendStandUpAndExitRoom()

    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager();
    subGameManager:onExit();

    SceneController.goHallScene()
    self.isReturnToHallScene = true
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
function FishGameScene:switchScene(id, bInit)
    -- 播放切换场景音乐
    self:getFishGameManager():getSoundManager():playBGM(id, bInit)

    if bInit then
        if not tolua.isnull(self._background) then
            self._background:removeSelf()
        end

        local background = self:createBackground(id)
        background:align(display.LEFT_BOTTOM, 0, 0):addTo(self, LAYER_ZORDER.BACKGROUND)
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
        background:align(display.LEFT_BOTTOM, xBG, 0):addTo(self, LAYER_ZORDER.BACKGROUND_SWITCH)
        background:runAction(transition.sequence({
            cc.MoveTo:create(timeBg, cc.p(0, 0)),
            cc.CallFunc:create(function(sender)
                sender:setLocalZOrder(LAYER_ZORDER.BACKGROUND)

                -- 打开切换场景后碰撞
                game.fishgame2d.FishObjectManager:GetInstance():SetSwitchingScene(false)
                game.fishgame2d.FishObjectManager:GetInstance():RemoveAllFishes(false)
            end)
        }))
        self._background = background

        self._bgSwitchWater:stopAllActions()
        self._bgSwitchWater:move(display.width, 0)
        self._bgSwitchWater:show()
        self._bgSwitchWater:runAction(transition.sequence({
            cc.MoveBy:create(timeWater, cc.p(-xWater, 0)),
            cc.CallFunc:create(function(sender)
                sender:hide()
            end)
        }))
    end
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


function FishGameScene:showFireEffect(chair_id)
    local idx = chair_id - 1
    local fireEffect = ccs.Armature:create("effect_bar_glod")
    fireEffect:getAnimation():play("star_yellow_Copy13_Copy15")

    local v = self._playersUI[idx].pnlCannon:getWorldPosition()
    local posx = v.x
    local posy = v.y
    local size = self._playersUI[idx].pnlCannon:getSize()

    if idx == FishGameConfig.PLAYER.LEFTTOP or idx == FishGameConfig.PLAYER.RIGHTTOP then
        fireEffect:setPosition(cc.p(posx, posy - size.height))
    elseif idx == FishGameConfig.PLAYER.RIGHTBOTTOM or idx == FishGameConfig.PLAYER.LEFTBOTTOM then
        fireEffect:setPosition(cc.p(posx, posy + size.height))
    end

    self._effectLayer:addChild(fireEffect)
    fireEffect:runAction(transition.sequence({
        cc.DelayTime:create(0.5),
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

function FishGameScene:showEffectPartical(x, y, name)
    local config = FishGameConfig.PARTICAL_CONFIG[name]
    if not config then return end
    dump(name)
    dump(config)
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
local opacity = { 0xFF,0xFF * 0.3,0xFF * 0.1 }
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

    self._cacheMng:setCacheLimit("fish_jinbi_1",100)
    local runningCount = self._cacheMng:getRunningCount("fish_jinbi_1")
    local xxx = (100 - runningCount) / 100

    local shadowCount = math.max(1 + math.ceil(shadowCount_1 * xxx),2)
    --    local start = shadowCount - math.min(math.floor(#opacity * xxx),2)

    local coin_count = score / base * 0.5

    if (coin_count > 10) then coin_count = 10 end
    coin_count = coin_count * xxx

    if (coin_count < 1 ) then coin_count = 1 end

    local offsetX = fishX - intervalX * coin_count * 0.5 - 40
    local distance = game.fishgame2d.MathAide:CalcDistance(fishX, fishY, cannonX, cannonY)
    local distanceTime = distance / 2000

    for i = 1, coin_count do
        local x = offsetX + intervalX * (coin_count - i)
        for j=1,shadowCount do
            local icon = self._cacheMng:getCachedNode("fish_jinbi_1")
            if not icon then
                icon = ccs.Armature:create("fish_jinbi_1")
                icon:getAnimation():play("move")
                self:addEffectUp(icon, "fish_jinbi_1")

                self._cacheMng:addNode("fish_jinbi_1",icon)
            end

            icon:setPosition(x, fishY)
            icon:setScale(0.8)
            icon:setOpacity(opacity[j])

            icon:setVisible(false)
            icon:runAction(transition.sequence({
                cc.DelayTime:create(0.2 * i + 0.2 / shadowCount * (j - 1)),
                cc.CallFunc:create(funcHide),
                cc.JumpBy:create(0.6,cc.p(jumpByX,0),jumByHeight,2),
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

return FishGameScene
