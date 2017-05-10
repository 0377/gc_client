--
-- Author: Your Name
-- Date: 2016-12-29 14:41:41
-- 游戏场景
--
local SubGameBaseScene = requireForGameLuaFile("SubGameBaseScene")
local FishGameScene = class(classname, SubGameBaseScene)
import("..controller.FishGameConfig")
import("..controller.FishGameXMLConfigManager")
local dispatcher = cc.Director:getInstance():getEventDispatcher()

-- 场景初始化方法
function FishGameScene:ctor()
    
    -- self.rootPath = DdzGameManager:getInstance():getPackageRootPath();
    -- elf.csbRootPath = "res/"..self.rootPath.."res/csb/"
    -- cc.FileUtils:getInstance():addSearchPath(self.csbRootPath, true)
    -- cc.FileUtils:getInstance():addSearchPath(self.csbRootPath.."game_res", true)
    local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("FishGame.csb");
    --local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("ddzGameLayerCSSfdsafdas.csb");
    self._mainWnd = cc.CSLoader:createNode(csNodePath)
    self:addChild(self._mainWnd)
    self._touchLayer = display.newLayer()
    self:addChild(self._touchLayer)
    self._touchLayer:setZOrder(0)
    --self._touchLayer:addTouchEventListener(handler(self, self.onTouchTTTTT))
    self._touchLayer:registerScriptTouchHandler(handler(self, self.onTouchTTTTT))
    self._touchLayer:setTouchEnabled(true)


    -- 初始化XML配置管理器
    self._xmlConfigManager = FishGameXMLConfigManager:getInstance()

    -- 初始化局部变量 --------------
	self._musicOpen     = true
    self._soundOpen     = true
    self._targetPos     = cc.p(0, 0)

    -- 玩家列表 --------------------
    self._players        = {}

    -- 初始化界面 ------------------
    self:initUI()

    -- 设置界面默认值
    self._ruleWndSelect = FishGameConfig.RULE_SELECT.NORMAL
    self:dealRuleSelect(self._ruleWndSelect)

    self._menuOpen      = false
    self._pnlMenu:setVisible(self._menuOpen)


    -- 初始化XML配置 ---------------
    self:intXMLConfig()

    -- 初始化玩家 ------------------
    self:initPlayers()

    self:initCannon()
end

-- 预加载资源路径
function FishGameScene.getNeedPreloadResArray()
	-- body
    print("getNeedPreloadResArray.............................")
	local resPaths = {
        CustomHelper.getFullPath("anim/bb_likui_pao_bullet/bb_likui_pao_bullet.ExportJson"),
        CustomHelper.getFullPath("anim/effect_weapons_replace/effect_weapons_replace.ExportJson"),
	}

	return resPaths
end

function FishGameScene:onExit()
    
    --self._sound:Clear()  
    local loadAramtureResTab = FishGameScene:getNeedPreloadResArray()
    for i, res in ipairs(loadAramtureResTab) do
        if res ~= "" then
            if string.find(res,".ExportJson") then
                ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(res);
            end
        end
    end
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

    self._btnShowMenu   = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "btn_show_menu"), "ccui.Button")
    self._btnShowMenu:addTouchEventListener(handler(self, self.onBtnShowMenu))

    self._pnlMenu       = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "panel_menu"), "ccui.Layout")

    self._btnRule       = tolua.cast(CustomHelper.seekNodeByName(self._pnlMenu, "btn_rule"), "ccui.Button")
    self._btnRule:addTouchEventListener(handler(self, self.onBtnRule))

    self._btnMusic      = tolua.cast(CustomHelper.seekNodeByName(self._pnlMenu, "btn_music"), "ccui.Button")
    self._btnMusic:addTouchEventListener(handler(self, self.onBtnMusic))

    self._btnSound      = tolua.cast(CustomHelper.seekNodeByName(self._pnlMenu, "btn_sound"), "ccui.Button")
    self._btnSound:addTouchEventListener(handler(self, self.onBtnSound))

    self._btnQuit       = tolua.cast(CustomHelper.seekNodeByName(self._pnlMenu, "btn_quit"), "ccui.Button")
    self._btnQuit:addTouchEventListener(handler(self, self.onBtnQuit))
end

-- 初始化规则界面
function FishGameScene:initRuleWnd()

    self._pnlRuleWnd    = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "RuleView"), "ccui.Layout")
    self._pnlRuleWnd:setVisible(false)

    self._btnClose      = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_close"), "ccui.Button")
    self._btnClose:addTouchEventListener(handler(self, self.onBtnRuleClose))

    self._btnNormal     = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_normal"), "ccui.Button")
    self._btnNormal:addTouchEventListener(handler(self, self.onBtnRuleNormal))

    self._btnBigFish    = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_big"), "ccui.Button")
    self._btnBigFish:addTouchEventListener(handler(self, self.onBtnRuleBigFish))

    self._btnSpecial    = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_special"), "ccui.Button")
    self._btnSpecial:addTouchEventListener(handler(self, self.onBtnRuleSpecial))

    self._btnBoss       = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_boss"), "ccui.Button")
    self._btnBoss:addTouchEventListener(handler(self, self.onBtnRuleBoss))

    self._pnlNormal     = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_normal"), "ccui.Layout")

    self._pnlBigFish    = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_bigfish"), "ccui.Layout")

    self._pnlSpecial    = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_special"), "ccui.Layout")

    self._pnlBoss       = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_boss"), "ccui.Layout")
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
    --local name, x, y = event.name, event.x, event.y
    --print("FishGame_OnTouch Name: "..eventType.." X: "..x.." Y: "..y)
    self._targetPos  = cc.p(x, y)

    angle = self:updateCannonRotationToPosition(0, self._targetPos)

    --print("*************  FishGame_OnTouch angle: "..angle)
    if self._xmlConfigManager:mirrorShow() then
        --player:GetCannon():SetCannonAngle(-angle - math.pi / 2)
        angle = -angle - math.pi/2
        print("onTouchTTTTT  11111111111111111")
    else
        --player:GetCannon():SetCannonAngle(angle + math.pi / 2)
        angle = angle + math.pi / 2
        print("onTouchTTTTT  22222222222222222")
    end
    print("*************  FishGame_OnTouch angle: "..angle)
    self._pnlLBPCannon:setRotation(math.deg(math.pi-angle))
end

-- 旋转炮台角度
function FishGameScene:updateCannonRotationToPosition(chairID, targetPos)
    local Posx = self._pnlLBPCannon:getPositionX()
    local Posy = self._pnlLBPCannon:getPositionY()
    local cannonX, cannonY = self._xmlConfigManager:getCannonPosition(chairID)
    cannonX, cannonY = self._xmlConfigManager:convertCoord(cannonX, cannonY)

    print("updateCannonRotationToPosition: cannonX: "..cannonX.." cannonY: "..cannonY.."LTCannonPos: "..Posx..","..Posy)
    --计算两点之间的夹角
    local dx = targetPos.x - cannonX
    local dy = targetPos.y - cannonY;
    local dis = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2)); --斜边长度
    local tan0 = dy / dx;

    local cos0 = dx / dis;
    local rad = math.acos(cos0);

    return rad
end

-- 初始化左上玩家
function FishGameScene:initLTPlayer()
    --self._player[FishGameConfig.PLAYER_IDX.LEFTTOP].score = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plt_txt_score"), "ccui.Text")
end

-- 初始化右上玩家
function FishGameScene:initRTPlayer()
    --self._player[FishGameConfig.PLAYER_IDX.RIGHTTOP].score = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prt_txt_score"), "ccui.Text")
end

-- 初始化左下玩家
function FishGameScene:initLBPlayer()
    --self._player[FishGameConfig.PLAYER_IDX.LEFTBOTTOM].score = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "plb_txt_score"), "ccui.Text")
end

-- 初始化右下玩家
function FishGameScene:initRBPlayer()
    --self._player[FishGameConfig.PLAYER_IDX.RIGHTBOTTOM].score = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "prb_txt_score"), "ccui.Text")
end

-- 显示菜单按钮点击事件
function FishGameScene:onBtnShowMenu(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        self._menuOpen = not self._menuOpen
        self:dealMenuSwitchAction()
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
        else
            self._btnMusic:loadTextureNormal(FishGameConfig.BTN_IMG.MUSIC_OFF_N)
            self._btnMusic:loadTexturePressed(FishGameConfig.BTN_IMG.MUSIC_OFF_P)
            self._btnMusic:loadTextureDisabled(FishGameConfig.BTN_IMG.MUSIC_OFF_P)
        end
    end
end

function FishGameScene:initCannon()
    local visibleSize = cc.Director:getInstance():getVisibleSize()

    -- 创建炮台 --
    self._panelCannons = {}

    for k, v in pairs(self._xmlConfigManager._cannonPosVector) do
        local id        = k
        local posX      = v.x
        local posY      = v.y
        local direction = v.dir

        --local widgetCannon, panel_cannon, panel_cannon_effect_down
        if id == FishGameConfig.PLAYER_IDX.LEFTBOTTOM then
            -- 下面 --
            print("initCannon  ID: 0000000000000000000000 V.SIZE:"..visibleSize.width.." . "..visibleSize.height.." POSX:"..posX.." POSY:"..posY.." DIR:"..direction)
            self._pnlLBPlayer       = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "player_leftbottom"), "ccui.Layout")
            self._pnlLBPCannon      = tolua.cast(CustomHelper.seekNodeByName(self._pnlLBPlayer, "plb_pnl_cannon"), "ccui.Layout")
            --widgetCannon = ccui.Helper:seekWidgetByName(self.m_widget, "cannon_00" .. indexDown)
            --panel_cannon = ccui.Helper:seekWidgetByName(widgetCannon, "panel_cannon")
            --panel_cannon_effect_down = ccui.Helper:seekWidgetByName(widgetCannon, "panel_cannon_effect_down")
            --widgetCannon:setPosition(visibleSize.width * posX, 0)
            --panel_cannon:setPosition(0, visibleSize.height * posY)
            self._pnlLBPlayer:setPosition(visibleSize.width*posX, 0)
            self._pnlLBPCannon:setPosition(190, visibleSize.height*posY)
            --panel_cannon_effect_down:setPosition(0, visibleSize.height * posY)
            local cannonSetType     = 0
            local cannonType        = 1
            local cannonMultiply    = 9
            local cannonSet         = self._xmlConfigManager._cannonSetVector[cannonSetType]
            local bulletConfig      = self._xmlConfigManager._bulletVector[cannonMultiply + 1]

            local cannon = cannonSet.Sets[cannonType]
            self._bulletConfig      = bulletConfig
            self._nMultiply         = 2
            self._nMultiplyOffsetX, self.m_nMultiplyOffsetY = cannon.Cannon.PosX, cannon.Cannon.PosY
            self._cannonConfig      = cannon

               -- 切换图片 --
            --local mul = cannon:GetBulletConfig().nMulriple
            --local mulX, mulY = cannon:GetMultiplyOffset()
            local size = self._pnlLBPCannon:getContentSize();

            self._pnlLBPCannon:removeAllChildren()
            -- 由于跟异步加载的重叠可能导致加载不成功，改成指定加载 --
            local rootPath = FishGameManager:getInstance():getPackageRootPath();
            print("szResourceName: ...."..cannon.Cannon.szResourceName)
            local armature = ccs.Armature:create(cannon.Cannon.szResourceName)
            print("+++++++++++++++++++++++++++ ： Name: "..cannon.Cannon.Name)
            armature:getAnimation():play(cannon.Cannon.Name)
            print(" --------------------------------------- ")
            self._pnlLBPCannon:addChild(armature)

            -- 有特效就加上特效
           --[[ if cannon and cannon.CannonEffect then
                local EffectName = "res/"..rootPath.."res/anim/"..cannon.CannonEffect.szResourceName
                local armature = ccs.Armature:create(EffectName)
                print("+++++++++++++++++++++++++++ ： CannonEffectName: "..cannon.CannonEffect.Name)
                armature:getAnimation():play(cannon.CannonEffect.Name)
                self._pnlLBPCannon:addChild(armature)
            end ]]--

            --cannon:setAnimationNode(armature)

       --[[ self._pnlLBPCannon:setScale(0.1)
            self._pnlLBPCannon:stopAllActions()
            self._pnlLBPCannon:runAction(cc.ScaleTo:create(0.2, 1))

            -- 转换 --
            if playerPanel.bUp then
                mulY = -mulY
            end
            if CGameConfig.getInstance():MirrorShow() then
                mulY = -mulY
            end

            local text
            if app.config.IS_IN_AUDIT then
                text = string.format("%s", mul)
            else
                text = string.format("%s元", mul / 100)
            end
            playerPanel.label_level:setString(text)
            
            -- 播放切换武器动画 --
            local switchAnimation =  "res/"..rootPath.."res/anim/effect_weapons_replace/effect_weapons_replace.ExportJson"
            self:addArmatureFileInfoWithAutoCleanup(switchAnimation)
            local effectWeaponReplace = ccs.Armature:create("effect_weapons_replace")
            effectWeaponReplace:getAnimation():play("effect_weapons_replace_animation")
            self._pnlLBPCannon:addChild(effectWeaponReplace)
            effectWeaponReplace:runAction(transition.sequence({
                cc.DelayTime:create(0.5),
                cc.CallFunc:create(function(sender)
                    sender:removeSelf()
                end)
            }))   ]]--

        elseif id == FishGameConfig.PLAYER_IDX.RIGHTBOTTOM then
            print("initCannon  ID: 111111111111111111".." POSX:"..posX.." POSY:"..posY.." DIR:"..direction)
            self._pnlRBPlayer       = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "player_rightbottom"), "ccui.Layout")
            self._pnlRBPCannon      = tolua.cast(CustomHelper.seekNodeByName(self._pnlRBPlayer, "prb_pnl_cannon"), "ccui.Layout")
            self._pnlRBPlayer:setPosition(visibleSize.width*posX, 0)
            self._pnlRBPCannon:setPosition(165, visibleSize.height*posY)

            local cannonSetType     = 1
            local cannonType        = 3
            local cannonMultiply    = 9
            local cannonSet         = self._xmlConfigManager._cannonSetVector[cannonSetType]
            local bulletConfig      = self._xmlConfigManager._bulletVector[cannonMultiply + 1]

            local cannon = cannonSet.Sets[cannonType]
            self._bulletConfig      = bulletConfig
            self._nMultiply         = 2
            self._nMultiplyOffsetX, self.m_nMultiplyOffsetY = cannon.Cannon.PosX, cannon.Cannon.PosY
            self._cannonConfig      = cannon

               -- 切换图片 --
            --local mul = cannon:GetBulletConfig().nMulriple
            --local mulX, mulY = cannon:GetMultiplyOffset()
            local size = self._pnlRBPCannon:getContentSize();

            self._pnlRBPCannon:removeAllChildren()
            -- 由于跟异步加载的重叠可能导致加载不成功，改成指定加载 --
            local rootPath = FishGameManager:getInstance():getPackageRootPath();
            print("szResourceName: ...."..cannon.Cannon.szResourceName)
            local armature = ccs.Armature:create(cannon.Cannon.szResourceName)
            print("+++++++++++++++++++++++++++ ： Name: "..cannon.Cannon.Name)
            armature:getAnimation():play(cannon.Cannon.Name)
            print(" --------------------------------------- ")
            self._pnlRBPCannon:addChild(armature)


        elseif id == FishGameConfig.PLAYER_IDX.RIGHTTOP then
            print("initCannon  ID: 222222222222222222".." POSX:"..posX.." POSY:"..posY.." DIR:"..direction)
            self._pnlRTPlayer       = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "player_righttop"), "ccui.Layout")
            self._pnlRTPCannon      = tolua.cast(CustomHelper.seekNodeByName(self._pnlRTPlayer, "prt_pnl_cannon"), "ccui.Layout")
            self._pnlRTPlayer:setPosition(visibleSize.width * posX, visibleSize.height)
            self._pnlRTPCannon:setPosition(165, visibleSize.height * (1 - posY))

            local cannonSetType     = 0
            local cannonType        = 4
            local cannonMultiply    = 9
            local cannonSet         = self._xmlConfigManager._cannonSetVector[cannonSetType]
            local bulletConfig      = self._xmlConfigManager._bulletVector[cannonMultiply + 1]

            local cannon = cannonSet.Sets[cannonType]
            self._bulletConfig      = bulletConfig
            self._nMultiply         = 2
            self._nMultiplyOffsetX, self._nMultiplyOffsetY = cannon.Cannon.PosX, cannon.Cannon.PosY
            self._cannonConfig      = cannon

               -- 切换图片 --
            --local mul = cannon:GetBulletConfig().nMulriple
            --local mulX, mulY = cannon:GetMultiplyOffset()
            local size = self._pnlRTPCannon:getContentSize();

            self._pnlRTPCannon:removeAllChildren()
            -- 由于跟异步加载的重叠可能导致加载不成功，改成指定加载 --
            local rootPath = FishGameManager:getInstance():getPackageRootPath();
            print("szResourceName: ...."..cannon.Cannon.szResourceName)
            local armature = ccs.Armature:create(cannon.Cannon.szResourceName)
            print("+++++++++++++++++++++++++++ ： Name: "..cannon.Cannon.Name)
            armature:getAnimation():play(cannon.Cannon.Name)
            print(" --------------------------------------- ")
            self._pnlRTPCannon:addChild(armature)
            self._pnlRTPCannon:setRotation(math.deg(math.pi))

        elseif id == FishGameConfig.PLAYER_IDX.LEFTTOP then
            print("initCannon  ID: 333333333333333333".." POSX:"..posX.." POSY:"..posY.." DIR:"..direction)
            self._pnlLTPlayer       = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "player_lefttop"), "ccui.Layout")
            self._pnlLTPCannon      = tolua.cast(CustomHelper.seekNodeByName(self._pnlLTPlayer, "plt_pnl_cannon"), "ccui.Layout")
            self._pnlLTPlayer:setPosition(visibleSize.width * posX, visibleSize.height)
            self._pnlLTPCannon:setPosition(165, visibleSize.height * (1 - posY))

            local cannonSetType     = 0
            local cannonType        = 8
            local cannonMultiply    = 9
            local cannonSet         = self._xmlConfigManager._cannonSetVector[cannonSetType]
            local bulletConfig      = self._xmlConfigManager._bulletVector[cannonMultiply + 1]

            local cannon = cannonSet.Sets[cannonType]
            self._bulletConfig      = bulletConfig
            self._nMultiply         = 2
            self._nMultiplyOffsetX, self._nMultiplyOffsetY = cannon.Cannon.PosX, cannon.Cannon.PosY
            self._cannonConfig      = cannon

               -- 切换图片 --
            --local mul = cannon:GetBulletConfig().nMulriple
            --local mulX, mulY = cannon:GetMultiplyOffset()
            local size = self._pnlRTPCannon:getContentSize();

            self._pnlLTPCannon:removeAllChildren()
            -- 由于跟异步加载的重叠可能导致加载不成功，改成指定加载 --
            local rootPath = FishGameManager:getInstance():getPackageRootPath();
            print("szResourceName: ...."..cannon.Cannon.szResourceName)
            local armature = ccs.Armature:create(cannon.Cannon.szResourceName)
            print("+++++++++++++++++++++++++++ ： Name: "..cannon.Cannon.Name)
            armature:getAnimation():play(cannon.Cannon.Name)
            print(" --------------------------------------- ")
            self._pnlLTPCannon:addChild(armature)
            self._pnlLTPCannon:setRotation(math.deg(math.pi))

            -- 上面 --
            --widgetCannon = ccui.Helper:seekWidgetByName(self.m_widget, "cannon_00" .. indexUp + 2)
            --panel_cannon = ccui.Helper:seekWidgetByName(widgetCannon, "panel_cannon")
            --panel_cannon_effect_down = ccui.Helper:seekWidgetByName(widgetCannon, "panel_cannon_effect_down")
            --widgetCannon:setPosition(visibleSize.width * posX, visibleSize.height)
            --panel_cannon:setPosition(0, -visibleSize.height * (1 - posY))
            --panel_cannon_effect_down:setPosition(0, -visibleSize.height * (1 - posY))
        end

        --local label_level = ccui.Helper:seekWidgetByName(widgetCannon, "lable_level")
        --local label_name = ccui.Helper:seekWidgetByName(widgetCannon, "label_name")
        --local lable_gold = ccui.Helper:seekWidgetByName(widgetCannon, "label_gold")
        --local lable_gold_0 = ccui.Helper:seekWidgetByName(widgetCannon, "label_gold_0")
        --local lable_gold_1 = ccui.Helper:seekWidgetByName(widgetCannon, "label_gold_1")
        --local btn_up = ccui.Helper:seekWidgetByName(widgetCannon, "btn_up")
        --local btn_down = ccui.Helper:seekWidgetByName(widgetCannon, "btn_down")
        --local bg_user = ccui.Helper:seekWidgetByName(widgetCannon, "bg_user")

       --[[ self._panelCannons[id] = {
            id = id,
            widgetCannon = widgetCannon,
            label_level = label_level,
            label_name = label_name,
            lable_gold = lable_gold,
            lable_gold_0 = lable_gold_0,
            lable_gold_1 = lable_gold_1,
            btn_up = btn_up,
            btn_down = btn_down,
            bg_user = bg_user,
            panel_cannon = panel_cannon,
            panel_cannon_effect_down = panel_cannon_effect_down,
            cannonDirection = direction,
            bUp = direction == 0,
        }]]--
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
        else
            self._btnSound:loadTextureNormal(FishGameConfig.BTN_IMG.SOUND_OFF_N)
            self._btnSound:loadTexturePressed(FishGameConfig.BTN_IMG.SOUND_OFF_P)
            self._btnSound:loadTextureDisabled(FishGameConfig.BTN_IMG.SOUND_OFF_P)
        end
    end
end

-- 攻击目标位置  -------------------
function FishGameScene:fireTo(targetPos)

end

function FishGameScene:onBtnQuit(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
    end
end

function FishGameScene:onBtnRuleClose(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        self._pnlRuleWnd:setVisible(false)
    end
end

function FishGameScene:onBtnRuleNormal(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        self:dealRuleSelect(FishGameConfig.RULE_SELECT.NORMAL)
    end
end

function FishGameScene:onBtnRuleBigFish(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        self:dealRuleSelect(FishGameConfig.RULE_SELECT.BIGFISH)
    end
end

function FishGameScene:onBtnRuleSpecial(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        self:dealRuleSelect(FishGameConfig.RULE_SELECT.SPECIAL)
    end
end

function FishGameScene:onBtnRuleBoss(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
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

return FishGameScene
