local scheduler = requireForGameLuaFile("frame.src.cocos-ext.scheduler")

local GFlowerConfig = import(".GFlowerConfig")
local GFlowerLogic = import(".GFlowerLogic")
local GFlowerSound = import(".GFlowerSound")
local GFlowerPoker = import(".GFlowerPoker")
--local GameGFlower = class("GameGFlower", function()
--    return display.newScene("GameGFlower")
--end)

local GameGFlower = class("GameGFlower",requireForGameLuaFile("CustomBaseView"))

local COIN_NUM = 5
local GF_TALK_LAYER_TAG = 100
local GF_COMPARE_ANI_TAG = 101
local GF_UP_RES_ANI = 102
local GF_DOWN_RES_ANI = 103
local GF_ADD_ZORDER = 30

-- 飞入筹码 --
GameGFlower._coinSprite = {}
-- 比牌状态 --
GameGFlower._nowCompare = false
-- 结束状态 --
GameGFlower._nowEnd = false
-- 玩家操作倒计时(游戏中) --
GameGFlower._countDown = GFlowerConfig.COUNT_DOWN_TIME
-- 是否跟到底标记
GameGFlower.FollowDiFlag = 0
-- 是否显示下注筹码
GameGFlower.DisplayAddFlag = 0
-- 操作时 是否游戏中 --
GameGFlower.gf_me_chaozuo = 0
-- 比牌玩家
GameGFlower.gf_bipaiuser = 0
-- 是否是其他玩家的人全压 --
GameGFlower._isAllIn = false
-- 菜单开关 --
GameGFlower._menuOpen = false
-- 其他玩家的牌显示 --
GameGFlower._otherPlayercard = 0
-- 其他玩家的牌显示 --
GameGFlower._allcomparechairs = {}
-- 玩家准备检测次数 --
GameGFlower._playerReadyCheckTimes = 0
-- 是否启用全压
GameGFlower._canplayCompareCard = false
-- 玩家操作按钮 --
GameGFlower._controlMenu = {
    ALL_IN = {},
    BI_PAI = {},
    GIVE_UP = {},
    FOLLOW = {},
    ADD_SCORE = {},
    LOOK_CARD = {},
}

-- 筹码随机位置生成 --
local function GetCoinRandPos()
    local _pos = {}
    local p_x = math.random(460, 820)
    local p_y = math.random(350, 460)
    _pos.x = p_x
    _pos.y = p_y
    return _pos
end

-- 点是否在sender上 --
local function pointInSender(sender, m_point)
    local _anPoint = sender:getAnchorPoint()
    local _width = sender:getContentSize().width
    local _height = sender:getContentSize().height
    local _rect = cc.rect(
        sender:getPositionX() - _width * _anPoint.x,
        sender:getPositionY() - _height * _anPoint.y,
        _width, _height
        )
    if cc.rectContainsPoint(_rect, m_point) then
        return true
    else
        return false
    end
end

local moduleName = ...
function GameGFlower:ctor()
    GameGFlower.super.ctor(self)

    local GFlowerGameManager = import(".controller.GFlowerGameManager",moduleName)
    self._gameManager = GFlowerGameManager.getInstance()

    -- json初始化 --
    self.layerUI = ccs.GUIReader:getInstance():widgetFromJsonFile("GameGFlower/GameGFlower_baobo.json")
    self:addChild(self.layerUI)

    -- 动画 --
    self:AnimationInit()

    -- 静态UI --
    self:GameUiInit()

    -- 手牌 --
    self:CardUiInit()

    -- 提示框 --
    self:TipBoxInit()

    -- 玩家信息 --
    self:PlayerUiInit()

    -- 其他 --
    self:NewNodeInit()

    --  走马灯 --
--    self:LanternAction()
--
    -- 音效管理 --
    self:SoundInit()

    -- 菜单 --
    self:MenuControl(false)



    for _,v in pairs( self._gameManager.MsgName) do
        self:addOneTCPMsgListener(v)
    end
end

function GameGFlower:callbackWhenConnectionStatusChange(event)
    dump(event)

end

function GameGFlower:receiveServerResponseErrorEvent(event)
    dump(event)

end

function GameGFlower:receiveServerResponseSuccessEvent(event)
    dump(event)
end


-- 音效 --
function GameGFlower:SoundInit()
    self._soundMgr = GFlowerSound.new()
    self._soundMgr:PlayBgm(1)
end

-- 新创建node --
function GameGFlower:NewNodeInit()
    -- 聊天界面 --
--    self.talkLayer = TalkLayer.new()
--    self.layerUI:addChild(self.talkLayer, GF_TALK_LAYER_TAG)

    -- 牌型动画父节点 --
    self._cardTypeParent = cc.Sprite:create()
    self._cardTypeParent:setLocalZOrder(GF_ADD_ZORDER * 2)
    self.layerUI:addChild(self._cardTypeParent)

    -- 金币父节点 --
    self._coinParent = cc.Sprite:create()
    self.layerUI:addChild(self._coinParent)

    -- 比牌遮罩层 --
    local width = cc.Director:getInstance():getVisibleSize().width
    local height = cc.Director:getInstance():getVisibleSize().height

    self._shadeLayOut = ccui.Layout:create()
    self._shadeLayOut:setContentSize(width, height)
    self._shadeLayOut:setLocalZOrder(GF_ADD_ZORDER * 2)
    self._shadeLayOut:setNodeEventEnabled(true)
    self._swallowLayOut = ccui.Layout:create()
    self._swallowLayOut:setContentSize(width, height)
    self._swallowLayOut:setSwallowTouches(true)
    self._swallowLayOut:setTouchEnabled(true)
    self._swallowLayOut:setLocalZOrder(self._shadeLayOut:getLocalZOrder() - 1)
    self.layerUI:addChild(self._swallowLayOut)
    self.layerUI:addChild(self._shadeLayOut)
    local _shadeLayer = cc.LayerColor:create(cc.c3b(0, 0, 0))
    _shadeLayer:setOpacity(90)
    _shadeLayer:setContentSize(cc.size(width, height))
    self.m_pClippingNode = cc.ClippingNode:create()
    self.m_pClippingNode:setAlphaThreshold(0.05)
    self.m_pClippingNode:addChild(_shadeLayer)
    self.m_pClippingNode:setInverted(true)
    self._shadeLayOut:addChild(self.m_pClippingNode)
    self.m_Stencil = cc.Node:create()
    self.m_pClippingNode:setStencil(self.m_Stencil)

    -- 当前玩家的灯光效果 --
    local iconLight = self.layerUI:getChildByName("icon_light")
    iconLight:setVisible(false)
    self._iconLight = iconLight

    local iconPlayerLight = display.newSprite("GameGFlower/baobo_zjh_guang.png")
    iconPlayerLight:setOpacity(0xFF * 0.5)
    iconPlayerLight:runAction(cc.RepeatForever:create(transition.sequence({
        cc.FadeTo:create(1,0xFF * 0.1),
        cc.FadeTo:create(0.5,0xFF * 0.5),
    })))
    iconPlayerLight:setVisible(false)
    iconPlayerLight:addTo(self.layerUI,21)
    self._iconPlayerLight = iconPlayerLight

    local _compareClicked = false
    local function clickLayerEvent(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            _compareClicked = false
            for k, v in pairs(self.m_Stencil:getChildren()) do
                if pointInSender(v, sender:getTouchBeganPosition()) then
                    self._swallowLayOut:setVisible(false)
                    _compareClicked = true
                    break
                end
            end
        elseif eventType == ccui.TouchEventType.ended then
            if not _compareClicked then
                self:CancelCompare()
            end
        end
    end

    self._shadeLayOut:setTouchEnabled(true)
    self._shadeLayOut:setSwallowTouches(false)
--    self._shadeLayOut:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self._shadeLayOut:addTouchEventListener(clickLayerEvent)
    self._shadeLayOut:setVisible(false)
    self._swallowLayOut:setVisible(false)

    -- 全场比牌 动画 --
    self.Ani_OpenCard = ccs.Armature:create("bb_zjh_win_eff")
    self.Ani_OpenCard:setPosition(640, 380)
    self.Panel_OpenCard:addChild(self.Ani_OpenCard)

    -- 赢家光效 动画 --
    self.Ani_WinPlayer = ccs.Armature:create("bb_zjh_win_eff")
    self.layerUI:addChild(self.Ani_WinPlayer)
    self.Ani_WinPlayer:setLocalZOrder(GF_ADD_ZORDER * 2)
    self.Ani_WinPlayer:setVisible(false)

    -- 开始按钮点击光效 --
    self.Ani_StartButton = ccs.Armature:create("bb_zjh_win_eff")
    self.Ani_StartButton:setPosition(651, 360)
    self.layerUI:addChild(self.Ani_StartButton)
    self.Ani_StartButton:setLocalZOrder(GF_ADD_ZORDER * 2)
    self.Ani_StartButton:setVisible(false)
end

-- 提示框 --
function GameGFlower:TipBoxInit()
--    self.gf_tipBox = BombBox.new(true, STR_HCPY_EXIT,
--        function(event)
--            self:gfgotoGameChoice()
--        end,
--        function(even)
--            self.gf_tipBox:setVisible(false)
--        end)
--    self:addChild(self.gf_tipBox, 1001)
--    self.gf_tipBox:setVisible(false)
--
--    self.gf_closeBox = BombBox.new(true, STR_HCPY_NET_CLOSE,
--        function(event)
--            uiManager:runScene("GameChoice")
--            app.hallLogic.needEnterGame = true
--        end,
--        function(even)
--            uiManager:runScene("GameChoice")
--        end)
--    self:addChild(self.gf_closeBox, 1002)
--    self.gf_closeBox:setVisible(false)
end

-- 静态UI --
function GameGFlower:GameUiInit()
    -- 换桌按钮
    self.Button_Change = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Change")
    self.Button_Change:addTouchEventListener(handler(self,self.OnBtnEventChange))

    -- 换桌界面的按钮
    self._changeTablePanel = ccui.Helper:seekWidgetByName(self.layerUI, "huanzhuotip")
    self._changeTablePanel:setVisible(false)
    self._changeTablePanel:getChildByName("sure"):
        addTouchEventListener(handler(self,self.OnBtnEventChangeBtn))
    self._changeTablePanel:getChildByName("cancel"):
        addTouchEventListener(handler(self,self.OnBtnEventChangeBtn))
    self._changeTablePanel:getChildByName("cancel"):setTag(10002)
    -- 牌型按钮
    self.Button_Px = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Px")
    self.Button_Px:addTouchEventListener(handler(self,self.OnBtnEventPx))

    -- 规则按钮
    self.Button_Rule = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Rule")
    self.Button_Rule:addTouchEventListener(handler(self,self.OnBtnEventRule))

    -- 规则界面 --
    self._rullPanel = ccui.Helper:seekWidgetByName(self.layerUI, "Panel_guize")
    self._rullPanel:setVisible(false)
    self._rullPanel:getChildByName("Image_95"):getChildByName("close_btn"):
        addTouchEventListener(handler(self, self.OnBtnEventRuleClose))

    -- 退出按钮
    self.Button_Exit = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Exit")
    self.Button_Exit:addTouchEventListener(handler(self, self.OnBtnEventExit))

    -- 菜单层 --
    self.Panel_Menu = ccui.Helper:seekWidgetByName(self.layerUI, "MoveMenu")

    -- 菜单开关 --
    self.Button_Menu = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Menu")
    self.Button_Menu:addTouchEventListener(handler(self, self.on_btn_GameMenu))

    self.m_labelJetton = {}
    self.m_btnJettons = {}
    -- 下注筹码面板
    self.Panel_JettonZone = ccui.Helper:seekWidgetByName(self.layerUI, "Panel_JettonZone")
    self.Panel_JettonZone:setVisible(false)

    -- 聊天按钮
    self.Button_Chat = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Chat")
    self.Button_Chat:addTouchEventListener(handler(self,self.OnBtnEventChat))

    -- 底注 文本 --
    self.Label_Dizhu = ccui.Helper:seekWidgetByName(self.layerUI, "Label_Dizhu")
    -- 单注 文本
    self.Label_Danzhu = ccui.Helper:seekWidgetByName(self.layerUI, "Label_Danzhu")
    -- 轮数 文本
    self.Label_Lunshu = ccui.Helper:seekWidgetByName(self.layerUI, "Label_Lunshu")
    -- 总注 文本
    self.Label_Zongzhu = ccui.Helper:seekWidgetByName(self.layerUI, "Label_Zongzhu")

    -- 开始按钮
    self.Button_StartGame = ccui.Helper:seekWidgetByName(self.layerUI, "Button_StartGame")
    self.Button_StartGame:addTouchEventListener(handler(self,self.OnBtnEventStart))
    self.Button_StartGame:setVisible(false)

    -- 开始按钮倒计时 --
    self.Label_StartCT = ccui.Helper:seekWidgetByName(self.Button_StartGame, "Label_CT")

    -- 放弃按钮
    self.Button_Giveup = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Giveup")
    self.Button_Giveup:addTouchEventListener(handler(self,self.OnBtnEventGiveup))
    self.Image_GiveUp = ccui.Helper:seekWidgetByName(self.Button_Giveup, "Image_99")

    -- 全押按钮
    self.Button_All = ccui.Helper:seekWidgetByName(self.layerUI, "Button_All")
    self.Button_All:addTouchEventListener(handler(self,self.OnBtnEventAll))
    self.Image_All = ccui.Helper:seekWidgetByName(self.Button_All, "Image_99")

    -- 比牌按钮
    self.Button_Compare = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Compare")
    self.Button_Compare:addTouchEventListener(handler(self,self.OnBtnEventCompare))
    self.Image_Compare = ccui.Helper:seekWidgetByName(self.Button_Compare, "Image_99")

    -- 看牌按钮
    self.Button_Look = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Look")
    self.Button_Look:addTouchEventListener(handler(self,self.OnBtnEventLook))
    self.Image_Look = ccui.Helper:seekWidgetByName(self.Button_Look, "Image_200")

    -- 加注按钮
    self.Button_Add = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Add")
    self.Button_Add:addTouchEventListener(handler(self,self.OnBtnEventAdd))
    self.Image_Add = ccui.Helper:seekWidgetByName(self.Button_Add, "Image_201")

    -- 跟注按钮
    self.Button_Follow = ccui.Helper:seekWidgetByName(self.layerUI, "Button_Follow")
    self.Button_Follow:addTouchEventListener(handler(self,self.OnBtnEventFollow))
    self.Image_Follow = ccui.Helper:seekWidgetByName(self.Button_Follow, "Image_202")

    -- 跟到底按钮
    self.Button_FollowDi = ccui.Helper:seekWidgetByName(self.layerUI, "Button__FollowDi")
    self.Button_FollowDi:getChildByName("Image_FollowDiFlag"):setVisible(false)
    self.Button_FollowDi:addTouchEventListener(handler(self,self.OnBtnEventFollowDi))

    -- 加注界面取消按钮 --
    self.Button_Cancel = ccui.Helper:seekWidgetByName(self.Panel_JettonZone, "Button_Cancel")
    self.Button_Cancel:addTouchEventListener(handler(self, self.on_btn_AddCancel))

    -- 操作按钮界面 --
    self.Panel_Control = ccui.Helper:seekWidgetByName(self.layerUI, "Panel_Btn_Menu")

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

    -- 比牌界面 --
    self._comparePanel = ccui.Helper:seekWidgetByName(self.layerUI, "compare")
    self._comparePanel:setVisible(false)

    -- 结算界面 --
    self._resultPanel = ccui.Helper:seekWidgetByName(self.layerUI, "jiesuan")
    self._resultPanel:setVisible(false)

    -- 结算准备倒计时 --
    self.Label_ResultCT = ccui.Helper:seekWidgetByName(self._resultPanel, "Label_CountDown")

    --结算界面的按钮
    self._resultPanel:getChildByName("btn_huanzhuo"):
        addTouchEventListener(handler(self,self.OnBtnEventChangeBtn))
    self._resultPanel:getChildByName("btn_ready"):
        addTouchEventListener(handler(self,self.OnBtnEventStart))

    -- 牌型界面 --
    self._cardTypePanel = ccui.Helper:seekWidgetByName(self.layerUI, "Panel_px")
    self._cardTypePanel:setVisible(false)

    self._cardTypePanel:addTouchEventListener(function(sender, eventType)
        if self._cardTypePanel:isVisible() == true and eventType == ccui.TouchEventType.ended then
            self._cardTypePanel:setVisible(false)
        end
    end)

    -- 开牌界面 --
    self.Panel_OpenCard = ccui.Helper:seekWidgetByName(self.layerUI, "Panel_OpenCard")
    self.Label_OpenCard = ccui.Helper:seekWidgetByName(self.Panel_OpenCard, "Label_Reason")
    self.Image_OpenCard = ccui.Helper:seekWidgetByName(self.Panel_OpenCard, "Image_247")
    self.Panel_OpenCard:setVisible(false)

    -- 所有按钮 不可点击 --
    self:gfInitMeBtn(false)
end

-- 玩家信息 --
function GameGFlower:PlayerUiInit()
    self.gf_player = {}
    self._daojishius = {}
    self.imageready = {}
    self.gf_cardendPos = {}
    self.gf_everyuserCard = {}
    self.gf_compareUserBtn = {}
    self._imagePlayerLook = {}
    self._imagePlayerCallBg = {}
    self._imagePlayerCallAction = {}
    self._imagePlayerLight = {}
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self._daojishius[i] = cc.ProgressTimer:create(cc.Sprite:create("GameGFlower/baobo_zjh_dengdai_1.png"))
        self.gf_player[i] = self.layerUI:getChildByName("Image_player_"..i)
        self.gf_player[i]:addChild(self._daojishius[i])
        local size = self.gf_player[i]:getContentSize()
        self._daojishius[i]:setPosition(cc.p(size.width/2, size.height/2))
        self.imageready[i] = self.gf_player[i]:getChildByName("Image_Ready")
        self._imagePlayerCallBg[i] = self.gf_player[i]:getChildByName("Image_Action")
        self._imagePlayerCallAction[i] = self.gf_player[i]:getChildByName("Action")
        self._imagePlayerLight[i] = ccui.Helper:seekWidgetByName(self.gf_player[i], "Image_Light")
        -- 比牌/取消比牌按钮 --
        self.gf_compareUserBtn[i] = self.gf_player[i]:getChildByName("BtnPlayer")
        self.gf_compareUserBtn[i]:addTouchEventListener(handler(self, self.gfCompareUserBtn))
        self.gf_compareUserBtn[i]:setTouchEnabled(false)
        self.gf_compareUserBtn[i]:setVisible(false)
        self.gf_compareUserBtn[i]:setTag(i)
        if i ~= 1 then
            self.gf_player[i]:setVisible(false)
            self._imagePlayerLook[i] = ccui.Helper:seekWidgetByName(self.gf_player[i], "Image_Look")
        end

        self.gf_cardendPos[i] = GFlowerConfig.PLAYER_CARD_POS[i]
        self._daojishius[i]:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
        self._daojishius[i]:stopAllActions()
        self._daojishius[i]:setVisible(false)
        self._daojishius[i]:setLocalZOrder(5)
        self.gf_everyuserCard[i] = {}
    end
end

-- 扑克初始化 --
function GameGFlower:CardUiInit()
    self.gf_cardChildNode = {}
    local _allCardCount = GFlowerConfig.CARD_COUNT * GFlowerConfig.CHAIR_COUNT
    for i = 1, _allCardCount do
        self.gf_cardChildNode[i] = GFlowerPoker.new(false)
        self.layerUI:addChild(self.gf_cardChildNode[i], i)
    end
    self:gfInitCard(false)
end

-- 动画初始化 --
function GameGFlower:AnimationInit()
    -- 比牌动画 --
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(
        "GameGFlower/zjh_vs_eff/zjh_vs_eff0.png",
        "GameGFlower/zjh_vs_eff/zjh_vs_eff0.plist" ,
        "GameGFlower/zjh_vs_eff/zjh_vs_eff.ExportJson"
        )

    -- 比牌动画 --
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(
        "GameGFlower/zjh_vs_xb_eff/zjh_vs_xb_eff0.png",
        "GameGFlower/zjh_vs_xb_eff/zjh_vs_xb_eff0.plist" ,
        "GameGFlower/zjh_vs_xb_eff/zjh_vs_xb_eff.ExportJson"
        )

    -- 美女动画 --
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(
        "GameGFlower/zhajinhua_supervisor/zhajinhua_supervisor0.png",
        "GameGFlower/zhajinhua_supervisor/zhajinhua_supervisor0.plist" ,
        "GameGFlower/zhajinhua_supervisor/zhajinhua_supervisor.ExportJson"
        )
    self._aniGirl = ccs.Armature:create("zhajinhua_supervisor")
    self._aniGirl:setPosition(80, 70)
    self._aniGirl:setAnchorPoint(0.5, 0.5)
    self._aniGirl:getAnimation():play("stay")
    self.layerUI:getChildByName("panel_girl"):addChild(self._aniGirl)

    -- 牌型动画 --
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(
        "GameGFlower/zjh_pxdh_eff/zjh_pxdh_eff0.png",
        "GameGFlower/zjh_pxdh_eff/zjh_pxdh_eff0.plist" ,
        "GameGFlower/zjh_pxdh_eff/zjh_pxdh_eff.ExportJson"
        )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(
        "GameGFlower/zjh_pxdh_eff/zjh_pxdh_eff_20.png",
        "GameGFlower/zjh_pxdh_eff/zjh_pxdh_eff_20.plist" ,
        "GameGFlower/zjh_pxdh_eff/zjh_pxdh_eff_2.ExportJson"
        )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(
        "GameGFlower/zjh_pxdh_eff/zjh_pxdh_eff_30.png",
        "GameGFlower/zjh_pxdh_eff/zjh_pxdh_eff_30.plist" ,
        "GameGFlower/zjh_pxdh_eff/zjh_pxdh_eff_3.ExportJson"
        )
    -- 开牌动画 --
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(
        "GameGFlower/bb_zjh_win_eff/bb_zjh_win_eff0.png",
        "GameGFlower/bb_zjh_win_eff/bb_zjh_win_eff0.plist" ,
        "GameGFlower/bb_zjh_win_eff/bb_zjh_win_eff.ExportJson"
        )
    -- 钞票收获动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(
        "GameGFlower/zhajinhua_shouhuo_01/zhajinhua_shouhuo_010.png",
        "GameGFlower/zhajinhua_shouhuo_01/zhajinhua_shouhuo_010.plist" ,
        "GameGFlower/zhajinhua_shouhuo_01/zhajinhua_shouhuo_01.ExportJson"
        )
end

-- 加注界面取消按钮 --
function GameGFlower:on_btn_AddCancel(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        self.Panel_Control:setVisible(true)
        self.Panel_JettonZone:setVisible(false)
    end
end


--初始化牌
function GameGFlower:gfInitCard(isfapai, qishiplayer)
    local gf_cardscale = GFlowerConfig.CARD_INIT_SCALE
    local gf_cardspace = GFlowerConfig.CARD_SPACE
    local _allCardCount = GFlowerConfig.CHAIR_COUNT * GFlowerConfig.CARD_COUNT
    for i = 1, _allCardCount do
        self.gf_cardChildNode[i]:stopAllActions()
        self.gf_cardChildNode[i]:setVisible(false)
        self.gf_cardChildNode[i]:setContent(false, 0)
        self.gf_cardChildNode[i]:setPosition(cc.p(640 + i * gf_cardspace, 400))
        self.gf_cardChildNode[i]:setScale(gf_cardscale)
        self.gf_cardChildNode[i]:setInvalid(false)
        self.gf_cardChildNode[i]:setLocalZOrder(i)
        self.gf_cardChildNode[i]:setRotation(0)
        -- self.gf_cardChildNode[i]:InitCardStatus()
    end
    if not isfapai or not qishiplayer then return end

    --获取那些玩家在游戏中
    local gf_logic = GFlowerLogic.getInstance()
    self.gf_playinguser = {}
    local gf_index, gf_totalplayer = 1, 0
    for k, v in pairs(gf_logic._pChairs) do
        if v:GetGameStatus() == GFlowerConfig.PLAYER_STATUS.WAIT then
            gf_index = (k + GFlowerConfig.CHAIR_COUNT - qishiplayer) % GFlowerConfig.CHAIR_COUNT + 1
            self.gf_playinguser[gf_index] = v:GetChairId()
            gf_totalplayer = gf_totalplayer + 1
        end
    end
    local gf_startx = 640 - ((gf_totalplayer * GFlowerConfig.CARD_COUNT - 1) * gf_cardspace + 232 * gf_cardscale) / 2
    for i = 1, gf_totalplayer * GFlowerConfig.CARD_COUNT do
        self.gf_cardChildNode[i]:setVisible(true)
        self.gf_cardChildNode[i]:setPosition(cc.p(gf_startx + i * gf_cardspace, 400))
    end
    self:gfFapaiAnimi(gf_totalplayer, qishiplayer)
end

-- 菜单开关 --
function GameGFlower:MenuControl(isOpen)
    if isOpen then
        self.Panel_Menu:setPositionX(500)
        self.Panel_Menu:stopAllActions()
        self.Panel_Menu:runAction(cc.MoveTo:create(0.2, cc.p(0,0)))
        self.Button_Menu:setRotation(180)
        self._menuOpen = true
    else
        self.Panel_Menu:stopAllActions()
        self.Panel_Menu:runAction(cc.MoveTo:create(0.2, cc.p(500, 0)))
        self.Button_Menu:setRotation(0)
        self._menuOpen = false
    end
end

-- 菜单开关按钮事件 --
function GameGFlower:on_btn_GameMenu(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        self:MenuControl(not self._menuOpen)
    end
end

-- 发牌动画 --
function GameGFlower:gfFapaiAnimi(playercount, qishiplayer)
    local _logic = GFlowerLogic.getInstance()
    -- 音效 发牌 --
    self._soundMgr:PlayEffect_SendCard()

    local gf_fpjg = 0.2
    local gf_dfsf = 0.1
    for i = 1, GFlowerConfig.CARD_COUNT do
        local j = 1
        for _, _chairId in pairs(self.gf_playinguser) do
            local _cardScale = nil
            local _delayTime = gf_dfsf * ((i-1) * playercount + j - 1)
            local _cardIndex = (i-1) * playercount + j
            local gf_temppos = self.gf_cardendPos[_chairId]
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
            self.gf_everyuserCard[_chairId][i] = self.gf_cardChildNode[_cardIndex]
            local _player = _logic._pChairs[_chairId]
            self.gf_everyuserCard[_chairId][i]:setContent(false, _player:GetPlayerCard()[i])
            j = j + 1
        end
    end
end

-- 发牌动画回掉 --
function GameGFlower:gfFapaiAnimiCallBack()
    local gflogic = GFlowerLogic.getInstance()
    self:StartChaozuoUser(gflogic._currentChairId)
end

-- 加注筹码点击 --
function GameGFlower:_onBtnTouched_bet(sender, eventType, index)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        local _logic = GFlowerLogic.getInstance()
        local _player = _logic._pChairs[1]
        --dump("_onBtnTouched_bet:"..index)
        local gf_lscore = GFlowerConfig.ADD_BTN_TIMES[index + 1] * _logic._singleScore
        gf_lscore = tonumber(gf_lscore)
        if _player:IsLookCard() then
            gf_lscore = gf_lscore * 2
        end
        _logic:SendMsgAddScore(gf_lscore, 0, 0)
    end
end

-- 准备按钮事件 --
function GameGFlower:OnBtnEventStart(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        if self._isticu then
            if not self:getChildByTag(10003) then
                self:stopAllActions()
                self:queQian()
            end
            return
        end
        GFlowerLogic.getInstance():SendReady()
        self.layerUI:getChildByName("jiesuan"):setVisible(false)
    end
end

-- 换桌按钮事件
function GameGFlower:OnBtnEventChange(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        self.layerUI:getChildByName("jiesuan"):setVisible(false)
        if GFlowerLogic:getInstance()._pChairs[1]:GetGameStatus() <= GFlowerConfig.PLAYER_STATUS.READY then
            if self._isticu then
                if not self:getChildByTag(10003) then
                    self:stopAllActions()
                    self:queQian()
                end
                return
            end
            --执行换桌逻辑
            app.table:changeTable()
            sender:setTouchEnabled(false)
            -- 数据清空 --
            GFlowerLogic.getInstance():ClearPart()
            self:ResetUI()
            return
        end
        self.layerUI:getChildByName("huanzhuotip"):setVisible(true)
    end
end

-- 换桌按钮事件
function GameGFlower:OnBtnEventChangeBtn(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        if sender:getTag() == 10002 then
            self.layerUI:getChildByName("huanzhuotip"):setVisible(false)
        else
            if self._isticu then
                if not self:getChildByTag(10003) then
                    self:stopAllActions()
                    self:queQian()
                end
                return
            end
            --执行换桌逻辑
            app.table:changeTable()
            -- 数据清空 --
            GFlowerLogic.getInstance():ClearPart()
            self:ResetUI()
        end
    end
end

-- 界面数据重置 --
function GameGFlower:ResetUI()
    -- 数据 --
    self._coinSprite = {}
    self._nowCompare = false
    self._nowEnd = false
    self.FollowDiFlag = 0
    self.DisplayAddFlag = 0
    self.gf_me_chaozuo = 0
    self._otherPlayercard = 0
    self._allcomparechairs = {}
    self._playerReadyCheckTimes = 0
    -- UI --
    self:stopAllActions()
    self.layerUI:stopAllActions()
    self.Button_StartGame:setVisible(false)
    self.Panel_JettonZone:setVisible(false)
    self.gf_tipBox:setVisible(false)
    self.gf_closeBox:setVisible(false)
    self._aniGirl:getAnimation():play("stay")
    self._resultPanel:setVisible(false)
    self._comparePanel:stopAllActions()
    self._comparePanel:setVisible(false)
    ccui.Helper:seekWidgetByName(self.layerUI, "Panel_253"):setVisible(false)

    self._changeTablePanel:setVisible(false)
    self._rullPanel:setVisible(false)
    self._cardTypePanel:setVisible(false)
    self.Button_FollowDi:getChildByName("Image_FollowDiFlag"):setVisible(false)
    self._coinParent:removeAllChildren()
    self._cardTypeParent:removeAllChildren()
    self.Ani_WinPlayer:setVisible(false)
    self.Panel_OpenCard:setVisible(false)

    self._iconLight:setVisible(false)
    self._iconPlayerLight:setVisible(false)
    ccui.Helper:seekWidgetByName(self.layerUI, "Panel_253"):setVisible(false)

    for i = 1, GFlowerConfig.CHAIR_COUNT do
        if i ~= 1 then
            self.gf_player[i]:setVisible(false)
            self._imagePlayerLook[i]:setVisible(false)
            self.gf_compareUserBtn[i]:setTouchEnabled(false)
            self.gf_compareUserBtn[i]:setVisible(false)
        end
        self.imageready[i]:setVisible(false)
        self._imagePlayerLight[i]:setVisible(false)
        self.gf_everyuserCard[i] = {}
        self._daojishius[i]:stopAllActions()
        self._daojishius[i]:setVisible(false)
    end

    if self._scheduleHandle1 then
        scheduler.unscheduleGlobal(self._scheduleHandle1)
        self._scheduleHandle1 = nil
    end
    -- 接口 --
    self:gfInitCard(false)
    self:gfInitMeBtn(false)
    self:UpdateGameInfo()
    self:HideCompareShade()
end

-- 牌型按钮事件
function GameGFlower:OnBtnEventPx(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        local gf_paixing = self._cardTypePanel
        if gf_paixing:isVisible() then
            gf_paixing:setVisible(false)
        else
            gf_paixing:setVisible(true)
        end
    end
end

-- 聊天 --
function GameGFlower:onTrumpet(nickname, content)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif self.talkLayer then
        self.talkLayer:setLabel(nickname, content)
    end
end

-- 规则按钮事件
function GameGFlower:OnBtnEventRule(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        self._rullPanel:setVisible(true)
    end
end

-- 规则退出按钮事件
function GameGFlower:OnBtnEventRuleClose(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        self._rullPanel:setVisible(false)
    end
end

-- 退出按钮事件
function GameGFlower:OnBtnEventExit(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        if not GFlowerLogic.getInstance()._pChairs[1]:IsInGame() then
            sender:setTouchEnabled(false)
            self:gfgotoGameChoice()
        else
            app.hall.BombBox:Create({
                text = "现在退出，已下注的筹码将不会返回哦，确认退出吗？",
                width = 600,
                height = 250,
                cancle = function(sender)
                end,
                confirm = function()
                    sender:setTouchEnabled(false)
                    self:gfgotoGameChoice()
                end
                })
        end
    end
end

-- 弃牌按钮事件
function GameGFlower:OnBtnEventGiveup(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
        sender:setScale(GFlowerConfig.BTN_CLICK_SCALE)
    elseif eventType == ccui.TouchEventType.ended then
        GFlowerLogic.getInstance():SendMsgGiveUp()
        self.Button_Giveup:setScale(1)
    -- elseif pointInSender(sender, sender:getTouchMovePosition()) then
    --     self.Button_Giveup:setScale(GFlowerConfig.BTN_CLICK_SCALE)
    else
        self.Button_Giveup:setScale(1)
    end
end

-- 全压按钮事件
function GameGFlower:OnBtnEventAll(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
        sender:setScale(GFlowerConfig.BTN_CLICK_SCALE)
    elseif eventType == ccui.TouchEventType.ended then
        sender:setScale(1)
        local gf_logic = GFlowerLogic.getInstance()
        --todo
        self._isAllIn = true
        gf_logic:SendMsgAddScore(0, 0, 1)
    -- elseif pointInSender(sender, sender:getTouchMovePosition()) then
    --     self.Button_All:setScale(GFlowerConfig.BTN_CLICK_SCALE)
    else
        sender:setScale(1)
    end
end

-- 增加遮罩 --
function GameGFlower:AddCompareShade(showChair)
    local _child = self.gf_compareUserBtn[showChair]
    local _parent = _child:getParent()
    local _pos = {}
    _pos.x, _pos.y = _child:getPosition()
    local _shadePos = self.m_Stencil:convertToNodeSpace(_parent:convertToWorldSpace(_pos))
    local _stencil = cc.Sprite:create(GFlowerConfig.SHADE_STR)
    _stencil:pos(_shadePos.x, _shadePos.y)
    -- dump(_shadePos)
    self.m_Stencil:addChild(_stencil)
end

function GameGFlower:CompareWaiting()
    local gf_logic = GFlowerLogic.getInstance()

    self:gfInitMeBtn(false)
    -- self:UsingDaojishi(1, GFlowerConfig.COUNT_DOWN_TIME)

    -- 遮罩 --
    self:ShowCompareShade()

end

--比牌遮罩层显示 --
function GameGFlower:ShowCompareShade()
    self.m_Stencil:removeAllChildren()
    local gf_logic = GFlowerLogic.getInstance()
    for _chairId, _player in pairs(gf_logic._pChairs) do
        if _player:IsInGame() then
            self.gf_compareUserBtn[_chairId]:setTouchEnabled(true)
            self.gf_compareUserBtn[_chairId]:setVisible(true)
            self:AddCompareShade(_chairId)
        end
    end
    self._shadeLayOut:setVisible(true)
    self._swallowLayOut:setVisible(true)
end

-- 比牌遮罩层隐藏 --
function GameGFlower:HideCompareShade()
    self.m_Stencil:removeAllChildren()
    self._shadeLayOut:setVisible(false)
    self._swallowLayOut:setVisible(false)
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self.gf_compareUserBtn[i]:setTouchEnabled(false)
        self.gf_compareUserBtn[i]:setVisible(false)
    end
end

-- 比牌取消 --
function GameGFlower:CancelCompare()
    self:HideCompareShade()
    -- self:StartChaozuoUser(1)
    -- 玩家操作按钮判断 --
    self:JudgeControlBtn()
end

-- 比牌发起 --
function GameGFlower:SendCompareCard(chairId)
    local gf_logic = GFlowerLogic.getInstance()
    local gf_lscore = gf_logic._minScore * 2
    if gf_logic._pChairs[1]:IsLookCard() then
        gf_lscore = gf_lscore * 2
    end
    local gf_player = gf_logic._pChairs[chairId]
    if chairId >= 2 and gf_player then
        gf_logic:SendMsgAddScore(gf_lscore, 1, 0)
        gf_logic:SendMsgWaitCompare()
        gf_logic:SendMsgCompareCard(gf_player:GetwChairId())
    end

end

-- 比牌对象按钮监听函数 --
function GameGFlower:gfCompareUserBtn(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        self.gf_bipaiuser = sender:getTag()
        local gf_logic = GFlowerLogic.getInstance()
        print("GameGFlower:gfCompareUserBtn  -----" .. self.gf_bipaiuser)

        local gf_player = gf_logic._pChairs[self.gf_bipaiuser]
        if self.gf_bipaiuser >= 2 and gf_player then
            self:SendCompareCard(self.gf_bipaiuser)
            -- 遮罩隐藏 --
            self:HideCompareShade()
        else
            self:CancelCompare()
        end

    end
end

-- 比牌按钮事件
function GameGFlower:OnBtnEventCompare(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        sender:setScale(GFlowerConfig.BTN_CLICK_SCALE)
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        sender:setScale(1)
        local _logic = GFlowerLogic.getInstance()
        if not _logic._pChairs[1]:AddSocreEnough() then
                print("自己金币不足===========")
            _logic:SendMsgOpenCard()
            return
        end
        if _logic:GetInGamePlayer() > 2 then
            self:CompareWaiting()
        else
            for _, _player in pairs(_logic._pChairs) do
                if not _player:IsMySelf() and _player:IsInGame() then
                    self:gfInitMeBtn(false)
                    self:SendCompareCard(_player:GetChairId())
                    break
                end
            end
        end
    -- elseif pointInSender(sender, sender:getTouchMovePosition()) then
    --     self.Button_Compare:setScale(GFlowerConfig.BTN_CLICK_SCALE)
    else
        sender:setScale(1)
    end
end

-- 看牌按钮事件
function GameGFlower:OnBtnEventLook(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        sender:setScale(GFlowerConfig.BTN_CLICK_SCALE)
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        sender:setScale(1)
        self:gfSetAddBtn()
        GFlowerLogic.getInstance():SendMsgLookCard()
    -- elseif pointInSender(sender, sender:getTouchMovePosition()) then
    --     self.Button_Look:setScale(GFlowerConfig.BTN_CLICK_SCALE)
    -- else
    --     self.Button_Look:setScale(1)
    else
        sender:setScale(1)
    end
end

-- 加注按钮事件
function GameGFlower:OnBtnEventAdd(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        sender:setScale(GFlowerConfig.BTN_CLICK_SCALE)
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        sender:setScale(1)
        self:gfSetAddBtn()
        self.Panel_JettonZone:setVisible(true)
        self.Panel_Control:setVisible(false)
    -- elseif pointInSender(sender, sender:getTouchMovePosition()) then
    --     self.Button_Add:setScale(GFlowerConfig.BTN_CLICK_SCALE)
    else
        sender:setScale(1)
    end
end

-- 跟注按钮事件
function GameGFlower:OnBtnEventFollow(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        sender:setScale(GFlowerConfig.BTN_CLICK_SCALE)
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        sender:setScale(1)
        local gf_logic = GFlowerLogic.getInstance()
        local gf_lscore = gf_logic._minScore
        local _player = gf_logic._pChairs[1]
        if _player:IsLookCard() then
            gf_lscore = gf_lscore * 2
        end
        print("跟住消息                 "..gf_lscore)
        gf_logic:SendMsgAddScore(gf_lscore, 0, 0)
    -- elseif pointInSender(sender, sender:getTouchMovePosition()) then
    --     self.Button_Follow:setScale(GFlowerConfig.BTN_CLICK_SCALE)
    else
        sender:setScale(1)
    end
end

-- 跟到底按钮事件
function GameGFlower:OnBtnEventFollowDi(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self._soundMgr:PlayerEffect_Click()
    elseif eventType == ccui.TouchEventType.ended then
        local _flag = sender:getChildByName("Image_FollowDiFlag")
        if self.FollowDiFlag ~= 0 then
            --不跟到底 到 跟到底
            _flag:setVisible(false)
            self.FollowDiFlag = 0
        else
            --跟到底 到 不跟到底
            _flag:setVisible(true)
            self.FollowDiFlag = 1
            if GFlowerLogic.getInstance()._currentChairId == 1 and
                self.Button_Follow:isTouchEnabled() then
                self:OnBtnEventFollow(self.Button_Follow, ccui.TouchEventType.ended)
            end
        end
    end
end

-- 设置那些加注按钮可以用 --
function GameGFlower:gfSetAddBtn()
    local gf_fangjian = GFlowerLogic.getInstance()._fangjianbiaozhi
    local gf_logic = GFlowerLogic.getInstance()
    local _player = gf_logic._pChairs[1]
    -- local _jettonTimes = 1
    -- if _player:IsLookCard() then
    --     _jettonTimes = 2
    -- end

    for i = 1, COIN_NUM - 1 do
        local _jettonNum = GFlowerLogic.getInstance()._singleScore * GFlowerConfig.ADD_BTN_TIMES[i + 1]
        local _nowScore = gf_logic._minScore --* _jettonTimes
        self.m_btnJettons[i]:getChildByName("Image_look"):setVisible(_player:IsLookCard())
        -- if _player:IsLookCard() then
        --     self.m_labelJetton[i]:setString(app.table:MoneyShowStyle(_jettonNum*2))
        -- else
        --     self.m_labelJetton[i]:setString(app.table:MoneyShowStyle(_jettonNum*2))
        -- end
        if _jettonNum < _nowScore or _jettonNum == _nowScore and gf_logic._isAddScore then
            self.m_btnJettons[i]:setBright(false)
            self.m_btnJettons[i]:setTouchEnabled(false)
        else
            self.m_btnJettons[i]:setBright(true)
            self.m_btnJettons[i]:setTouchEnabled(true)
        end
    end

end

-- 桌面重置 --
function GameGFlower:ResetDesk()
    local gflogic = GFlowerLogic.getInstance()
    -- 界面重置 --
    self:HideCompareShade()
    self.Ani_WinPlayer:setVisible(false)
    self.Panel_OpenCard:setVisible(false)
    self._coinParent:removeAllChildren()
    self._cardTypeParent:removeAllChildren()
    self._coinSprite = {}
    self:gfInitCard(false)
    self:gfInitMeBtn(false)
    self.Button_FollowDi:getChildByName("Image_FollowDiFlag"):setVisible(false)
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self:gfClearUser(i)
        local _player = gflogic._pChairs[i]
        if _player then
            local _chairId = _player:GetChairId()
            _player:SetGameScore(0)
            print("玩家的状态   ----   ".._player:GetGameStatus())
            if _player:GetGameStatus() == GFlowerConfig.PLAYER_STATUS.EXIT or
            _player:GetGameStatus() == GFlowerConfig.PLAYER_STATUS.STAND then
                gflogic._pChairs[i] = nil
            else
                _player:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.FREE)
            end
        end
        self:UpdatePlayerInfo(i)
    end
    -- 重置灯光 --
    self._iconLight:setVisible(false)
    self._iconPlayerLight:setVisible(false)

    -- 数据还原 --
    self._isAllIn = false
    self._canplayCompareCard = false
    self._nowEnd = false
    self.FollowDiFlag = 0
    self._otherPlayercard = 0
    gflogic:ResetDesk()
    self:UpdateGameInfo()
end

-- 游戏结束 --
function GameGFlower:GameEnd()
    self._nowEnd = true
    if self._nowCompare then return end

    -- 操作按钮--
    self:gfInitMeBtn(false)

    local gflogic = GFlowerLogic.getInstance()

    local _winnerChair = gflogic._winnerChairId

    -- 飞吻 --
    if _winnerChair == 1 then
        self._aniGirl:getAnimation():play("kiss")
    end

    -- 筹码飞出 --
    self:CoinFlyOutAction(_winnerChair)

    -- 赢家光效 --
    self.Ani_WinPlayer:setVisible(true)
    self.Ani_WinPlayer:setPosition(GFlowerConfig.PLAYER_LOCATION[_winnerChair])
    self.Ani_WinPlayer:getAnimation():play("ani_01")
    -- 停止所有的计时器 --
    for k=1,GFlowerConfig.CHAIR_COUNT do
        self:CloseDojishi(k)
        self._imagePlayerLight[k]:setVisible(false)
        if k ~= 1 then
            self._imagePlayerLook[k]:setVisible(false)
        end
    end
    -- for k,v in pairs(gflogic._pChairs) do
    --     if v and v:GetGameStatus() >= GFlowerConfig.PLAYER_STATUS.WAIT then
    --         self:CloseDojishi(k)
    --         self._imagePlayerLight[k]:setVisible(false)
    --         if k ~= 1 then
    --             self._imagePlayerLook[k]:setVisible(false)
    --         end
    --     end
    -- end
    self._iconLight:setVisible(false)
    self._iconPlayerLight:setVisible(false)
    ccui.Helper:seekWidgetByName(self.layerUI, "Panel_253"):setVisible(false)
end

-- 清理所有数据 --
function GameGFlower:gfClearUser(showChair)
    if showChair < 1 or showChair > 5 then return end
    self.gf_everyuserCard[showChair] = {}
    self.imageready[showChair]:setVisible(false)
    self._imagePlayerLight[showChair]:setVisible(false)
    self._imagePlayerCallAction[showChair]:setVisible(false)
    self._imagePlayerCallBg[showChair]:setVisible(false)
    if showChair ~= 1 then
        self.gf_compareUserBtn[showChair]:setVisible(false)
        self.gf_compareUserBtn[showChair]:setTouchEnabled(false)
        self._imagePlayerLook[showChair]:setVisible(false)
    end
end


function GameGFlower:onEnter()
--    GFlowerLogic.getInstance():init(self)
--    app.table:registGameLogic(GFlowerLogic.getInstance())

    -- local gf_logic = GFlowerLogic.getInstance()
    -- -- 加载桌面
    -- self.layerUI:getChildByName("Image_Bg"):
    -- loadTexture("GameGFlower/zjh_bg_"..GFlowerLogic.getInstance()._fangjianbiaozhi..".png")

    --断线提示
--    app.eventDispather:addListenerEvent(eventGameNetClosed, self, function(data)
--        self:gfnewCloseMsg()
--        return
--    end)
--
--self._gameManager:sendGameReady()
--self._gameManager:send_CS_EnterRoom()

end

--网络链接断开
function GameGFlower:gfnewCloseMsg()
    self.gf_closeBox:showText()
end

function GameGFlower:onExit()
    if self._scheduleHandle then
        scheduler.unscheduleGlobal(self._scheduleHandle)
        self._scheduleHandle = nil
    end
    if self._scheduleHandle1 then
        scheduler.unscheduleGlobal(self._scheduleHandle1)
        self._scheduleHandle1 = nil
    end
    app.musicSound:stopMusic()
    app.eventDispather:delListenerEvent(self)
    app.eventDispather:doDelListener()
end

-- 进入游戏 空闲状态 --
function GameGFlower:GameFree()
    if GFlowerLogic.getInstance()._pChairs[1]:GetwStatus() == US_SIT then
        --self:ShowStartButton()
        GFlowerLogic.getInstance():SendReady()
    end
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self:UpdatePlayerInfo(i)
    end
end

-- 进入游戏 进行状态 --
function GameGFlower:GamePlaying()
    -- 处理牌 --
    local gf_logic = GFlowerLogic.getInstance()
    for k, v in pairs(gf_logic._pChairs) do
        if v:GetGameStatus() >= GFlowerConfig.PLAYER_STATUS.WAIT then
            for i = 1, GFlowerConfig.CARD_COUNT do
                local gf_temp_index = (k - 1) * GFlowerConfig.CARD_COUNT + i
                local gf_temp_pos = self.gf_cardendPos[k]
                self.gf_cardChildNode[gf_temp_index]:setVisible(true)
                self.gf_cardChildNode[gf_temp_index]:setPosition(cc.p(gf_temp_pos.x + i*25,gf_temp_pos.y))
                self.gf_cardChildNode[gf_temp_index]:setScale(GFlowerConfig.CARD_STAY_SCALE_OTHER)
                self.gf_everyuserCard[k][i] = self.gf_cardChildNode[gf_temp_index]
            end

            self:UpdatePlayerInfo(v:GetChairId())
        end
    end
    -- 发送准备 --
    gf_logic:SendReady()
    -- 当前那个玩家 --
    self:UsingDaojishi(gf_logic._currentChairId, GFlowerConfig.COUNT_DOWN_TIME)
end


-- 玩家进入 --
function GameGFlower:PlayerEnterGame(showChair)
    local _logic = GFlowerLogic:getInstance()
    local _player = _logic._pChairs[showChair]
    if not _player then return end

    if not _player:IsMySelf() then
        self.gf_player[showChair]:setVisible(true)
    else
        -- self.Button_Change:setTouchEnabled(true)
        -- _logic:sendReady()
    end

    self:UpdatePlayerInfo(showChair)
end

function GameGFlower:CheckPlayerAllReady()
    if self._playerReadyCheckTimes > 0 then
        return
    end
    local _logic = GFlowerLogic:getInstance()
    if (_logic:GameIsFree() or _logic:GameIsEnd()) and self:AllPlayerReadyExceptMe() then
        self._playerReadyCheckTimes = self._playerReadyCheckTimes + 1
        self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                self._soundMgr:PlayEffect_AllReady()
                end),
            cc.DelayTime:create(2.0),
            cc.CallFunc:create(function()
                self._playerReadyCheckTimes = 0
                end)
            ))

    end
end

-- 根据状态 更新玩家数据 --
function GameGFlower:UpdatePlayerByStatus(showChair)
    local _logic = GFlowerLogic:getInstance()
    local _player = _logic._pChairs[showChair]

    if not _player then return end

    self.gf_player[showChair]:setVisible(true)
    if _player:IsExit() then
        self.gf_player[showChair]:setVisible(false)
        self._imagePlayerLight[showChair]:setVisible(false)
        self.imageready[showChair]:setVisible(false)
    elseif _player:IsWatchGame() then
        if _player:IsMySelf() then
            self:HideStartButton()
            self:CloseDojishi(showChair)
        end
        self.imageready[showChair]:loadTexture(GFlowerConfig.IMAGE_PLAYER_STATUS["STAND"])
        self.imageready[showChair]:setVisible(true)
    elseif _player:IsReady() then
        if _player:IsMySelf() then
            if self.Button_StartGame:isVisible() then
                self:HideStartButtonWithAni()
            else
                self:HideStartButton()
            end
            self:CloseDojishi(showChair)
        else
            self:CheckPlayerAllReady()
        end
        self.imageready[showChair]:loadTexture(GFlowerConfig.IMAGE_PLAYER_STATUS["READY"])
        self.imageready[showChair]:setVisible(true)
        self:CloseDojishi(showChair)
    elseif _player:IsWaiting() then
        self:CloseDojishi(showChair)
    elseif _player:IsControl() then

    elseif _player:IsDrop() then
        self.imageready[showChair]:loadTexture(GFlowerConfig.IMAGE_PLAYER_STATUS["DROP"])
        self.imageready[showChair]:setVisible(true)
        self._imagePlayerLight[showChair]:setVisible(true)
        if not _player:IsMySelf() then
            self._imagePlayerLook[showChair]:setVisible(false)
        end
        self:CloseDojishi(showChair)
        for i = 1, GFlowerConfig.CARD_COUNT do
            if self.gf_everyuserCard[showChair][i] then
                self.gf_everyuserCard[showChair][i]:setInvalid(true)
            end
        end
    elseif _player:IsLose() then
        self.imageready[showChair]:loadTexture(GFlowerConfig.IMAGE_PLAYER_STATUS["LOSE"])
        self.imageready[showChair]:setVisible(true)
        self._imagePlayerLight[showChair]:setVisible(true)
        if not _player:IsMySelf() then
            self._imagePlayerLook[showChair]:setVisible(false)
        end
        for i = 1, GFlowerConfig.CARD_COUNT do
            self.gf_everyuserCard[showChair][i]:setInvalid(true)
        end
        self:CloseDojishi(showChair)
    elseif _player:IsLookCard() then
        -- if not _player:IsMySelf() then
        --     self._imagePlayerLook[showChair]:setVisible(true)
        -- end
        -- if GFlowerLogic.getInstance()._currentChairId == _player:GetChairId() then
        --     self:UsingDaojishi(showChair, GFlowerConfig.COUNT_DOWN_TIME)
        -- end
    elseif _player:IsComparing() then
        self:CloseDojishi(showChair)
    elseif _player:IsFree() then
        if _player:IsMySelf() and not self._resultPanel:isVisible() and
        _logic:GetGameStatus() ~= GFlowerConfig.GAME_STATUS.GAME_PLAY and
        _logic._receive == true then
            GFlowerLogic.getInstance():SendReady()
            --self:ShowStartButton()
        end
        self.imageready[showChair]:setVisible(false)
        self._imagePlayerLight[showChair]:setVisible(false)
    else
        if _player:IsMySelf() then
            self:HideStartButton()
        else
            self._imagePlayerLook[showChair]:setVisible(false)
        end
        self.imageready[showChair]:setVisible(false)
        self._imagePlayerLight[showChair]:setVisible(false)
        self:CloseDojishi(showChair)
    end

    -- local _gameStatus = _player:GetGameStatus()
    -- if _gameStatus == GFlowerConfig.PLAYER_STATUS.EXIT then

    -- elseif _gameStatus == GFlowerConfig.PLAYER_STATUS.READY then

    -- elseif _gameStatus == GFlowerConfig.PLAYER_STATUS.WAIT then

    -- elseif _gameStatus == GFlowerConfig.PLAYER_STATUS.LOSE then

    -- elseif _gameStatus == GFlowerConfig.PLAYER_STATUS.DROP then

    -- elseif _gameStatus == GFlowerConfig.PLAYER_STATUS.LOOK then

    -- elseif _gameStatus == GFlowerConfig.PLAYER_STATUS.CONTROL then

    -- elseif _gameStatus == GFlowerConfig.PLAYER_STATUS.COMPARE then

    -- elseif _gameStatus == GFlowerConfig.PLAYER_STATUS.FREE then

    --     -- self:gfClearUser(showChair)
    -- else

    -- end

end

-- 玩家信息更新 --
function GameGFlower:UpdatePlayerInfo(showChair)
    local player = GFlowerLogic:getInstance()._pChairs[showChair]
    if not player then
        self.gf_player[showChair]:setVisible(false)
        return
    end

    if player:GetGameStatus() == GFlowerConfig.PLAYER_STATUS.EXIT or
        player:GetGameStatus() == GFlowerConfig.PLAYER_STATUS.STAND then
        self.gf_player[showChair]:setVisible(false)
        return
    end


    self:UpdatePlayerByStatus(showChair)

    if self._nowCompare then return end

    local _playerNameLabel = self.gf_player[showChair]:getChildByName("Label_Name")
    local _playerGoldLabel = self.gf_player[showChair]:getChildByName("Label_GoldNum")
    local _playerHeadIcon = self.gf_player[showChair]:getChildByName("Image_HeadIcon")
    local _playerAddScoreLabel = self.gf_player[showChair]:getChildByName("Label_XiaZhuNum")
    -- if player:GetGameScore() == nil or  player:GetGameScore() == 0 then
    --     _playerAddScoreLabel:setString("获取中")
    -- else
    --     _playerAddScoreLabel:setString(app.table:MoneyShowStyle(player:GetGameScore()))
    -- end

    if player:GetGameScore() == nil or player:GetGameScore() == 0 then
        _addScore = "获取中"
        self.gf_player[showChair]:getChildByName("Label_XiaZhuNum"):setVisible(false)
        self.gf_player[showChair]:getChildByName("Image_XiaZuBg"):setVisible(false)
    else
        self.gf_player[showChair]:getChildByName("Label_XiaZhuNum"):setVisible(true)
        self.gf_player[showChair]:getChildByName("Image_XiaZuBg"):setVisible(true)
        _addScore = app.table:MoneyShowStyle(player:GetGameScore())
        self.gf_player[showChair]:getChildByName("Label_XiaZhuNum"):setString(_addScore)
    end

    _playerNameLabel:setString(player:GetUserAdress())
    --_playerNameLabel:setString(player:GetNickName())
    _playerGoldLabel:setString(app.table:MoneyShowStyle(player:GetOwnScore()))
    _playerHeadIcon:loadTexture(player:GetHeadStr("Square"))

end

-- 玩家状态检测 --
function GameGFlower:AllPlayerReadyExceptMe()
    local _logic = GFlowerLogic.getInstance()
    local _meReady = true
    local _otherReady = true
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        local _player = _logic._pChairs[i]
        if _player then
            if _player:IsMySelf() then
                if _player:GetGameStatus() ~= GFlowerConfig.PLAYER_STATUS.READY then
                    _meReady = false
                end
            else
                if _player:GetGameStatus() ~= GFlowerConfig.PLAYER_STATUS.READY then
                    _otherReady = false
                    break
                end
            end
        end
    end
    if not _meReady and _otherReady then
        return true
    else
        return false
    end
end

-- 筹码初始化 --
function GameGFlower:JettonInit()
    local gf_logic = GFlowerLogic.getInstance()

    -- 筹码按钮数值 --
    for i = 1, COIN_NUM - 1 do
        local index = i
        local _btn = self.Panel_JettonZone:getChildByName("Button_Jetton_" .. index)
        local _Label_Jetton = _btn:getChildByName("Label_Jetton")
        local _jettonNum = GFlowerConfig.ADD_BTN_TIMES[index + 1] * gf_logic._singleScore
        self.m_labelJetton[index] = _Label_Jetton
        self.m_labelJetton[index]:setString(app.table:MoneyShowStyle(_jettonNum))
        self.m_btnJettons[index] = _btn
        self.m_btnJettons[index]:setVisible(true)
        _btn:addTouchEventListener(function(sender, eventType)
            self:_onBtnTouched_bet(sender, eventType, index)
        end)
    end
end

-- 游戏开始 --
function GameGFlower:GameStart()
    -- 下注筹码 --
    -- 开始按钮 隐藏 --
    self:HideStartButton()
    self.layerUI:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function()
            self:JettonInit()

            -- 筹码飞入动画 --
            local gflogic = GFlowerLogic:getInstance()
            for k, v in pairs(gflogic._pChairs) do
                if v:IsInGame() then
                    local _coinType = self:GetCoinType(gflogic._singleScore)
                    self:CoinFlyAction(k, _coinType, 1)
                end
            end

            -- 初始化加注信息 --
            self:UpdateGameInfo()
            -- 更新玩家状态 --
            for i = 1, GFlowerConfig.CHAIR_COUNT do
                self:UpdatePlayerByStatus(i)
                self:HidePlayerStatusInfo(i)
                self:UpdateAddScore(i)
            end
        end),
        cc.DelayTime:create(1),
        cc.CallFunc:create(function()
            -- 发牌动画 --
            self:gfInitCard(true, GFlowerLogic.getInstance()._currentChairId)
        end)
        ))
end

-- 玩家离开 --
function GameGFlower:PlayerExitGame(chairId)
    --if self._nowCompare then return end
    local _logic = GFlowerLogic.getInstance()
    local _player = _logic._pChairs[chairId]
    if _player.iscompare and _player.iscompare == true then return end
    if _logic:GetGameStatus() == GFlowerConfig.GAME_STATUS.GAME_FREE then
        _logic._pChairs[chairId] = nil
    end
    self.gf_player[chairId]:setVisible(false)
    self._imagePlayerLight[chairId]:setVisible(false)
    self._daojishius[chairId]:stopAllActions()
    self._daojishius[chairId]:setVisible(false)
    self.imageready[chairId]:setVisible(false)
    if chairId ~= 1 then
        self._imagePlayerLook[chairId]:setVisible(false)
        self.gf_compareUserBtn[chairId]:setTouchEnabled(false)
        self.gf_compareUserBtn[chairId]:setVisible(false)
    end
    self.imageready[chairId]:setVisible(false)

    for k,v in pairs(self.gf_everyuserCard[chairId]) do
        v:setVisible(false)
    end
    _logic._pChairs[chairId] = nil
    _logic:UpdateHalfToDesk()
end

-- 自己操作UI重置 --
function GameGFlower:ResetMyControlUi()
    self:HideCompareShade()
    self:gfInitMeBtn(false)
end

-- 玩家放弃 --
function GameGFlower:PlayerDropCard(chairId)
    if not chairId or chairId < 1 or chairId > GFlowerConfig.CHAIR_COUNT then return end
    local _logic = GFlowerLogic.getInstance()
    local gf_player = _logic._pChairs[chairId]
    local _nextChairId = _logic:GetNextChairId()
    self:UpdateAddScore(chairId)

    --动画回掉才显示状态
    if _logic._currentChairId == chairId then
        self:CloseDojishi(chairId)
        self:StartChaozuoUser(_nextChairId)
    end

    --设置玩家的状态
    self:UpdatePlayerByStatus(chairId)
    self:PlayerCall(chairId, "GIVE_UP")

end

-- 玩家喊话气泡 --
function GameGFlower:PlayerCall(chairId, action)
    local _logic = GFlowerLogic.getInstance()

    for i = 1, GFlowerConfig.CHAIR_COUNT do
        local _imagePlayerCallBg = self._imagePlayerCallBg[i]
        local _imagePlayerCallAction = self._imagePlayerCallAction[i]
        if i ~= chairId then
            _imagePlayerCallBg:setVisible(false)
            _imagePlayerCallAction:setVisible(false)
        else
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
            -- 音效 玩家--
            self._soundMgr:PlayEffect_PlayerSound(_logic._pChairs[chairId]:IsMan(), action)
        end
    end
end


-- 玩家加注 --
function GameGFlower:PlayerAddGameScore(chairId, addScore)
    local _logic = GFlowerLogic.getInstance()
    local _player = _logic._pChairs[chairId]
    local _nextChairId = _logic:GetNextChairId()

    self:CloseDojishi(chairId)
    self:UpdateAddScore(chairId)
    self:UpdateGameInfo()


    if _logic:IsMaxRound() then
        _logic:SendMsgOpenCard()
        return
    end

    self:StartChaozuoUser(_nextChairId)

    -- 筹码动作 --
    local _coinType = self:GetCoinType(_logic._minScore)
    local _coinNum = _player:GetCoinNum()
    self:CoinFlyAction(chairId, _coinType, _coinNum)

    -- 玩家动作 --
    self:PlayerCall(chairId, "ADD_SCORE")

end

-- 获取筹码大小 --
function GameGFlower:GetCoinScore(coinType)
    local _logic = GFlowerLogic.getInstance()
    return _logic._singleScore * GFlowerConfig.ADD_BTN_TIMES[coinType]
end

-- 玩家全压 --
function GameGFlower:PlayerAllInGameScore(chairId)
    local _logic = GFlowerLogic.getInstance()
    local _player = _logic._pChairs[chairId]
    local _nextChairId = _logic:GetNextChairId()

    self:CloseDojishi(chairId)
    self:UpdateAddScore(chairId)
    self:UpdateGameInfo()
    self:StartChaozuoUser(_nextChairId, 1)

    local _addScore = _player:GetRoundScore()
    local _coinType = 1
    for i = 1, COIN_NUM do
        local _coinScore = self:GetCoinScore(i)
        if _addScore > _coinScore then
            _coinType = i
        end
    end

    local _coinScore = self:GetCoinScore(_coinType)
    local _coinNum = math.floor(_addScore / _coinScore) + 1
    if _coinNum > 10 then _coinNum = 10 end
    self:CoinFlyAction(chairId, _coinType, _coinNum)

    -- 玩家动作 --
    self:PlayerCall(chairId, "ALL_IN")
end

-- 玩家跟注 --
function GameGFlower:PlayerFollowGameScore(chairId)
    local _logic = GFlowerLogic.getInstance()
    local _player = _logic._pChairs[chairId]
    local _nextChairId = _logic:GetNextChairId()
    local _nextPlayer = _logic._pChairs[_nextChairId]

    self:CloseDojishi(chairId)
    self:UpdateAddScore(chairId)
    self:UpdateGameInfo()

    if _logic:IsMaxRound() then
        _logic:SendMsgOpenCard()
        return
    end
    self:StartChaozuoUser(_nextChairId)

    -- 筹码动作 --
    local _coinType = self:GetCoinType(_logic._minScore)
    local _coinNum = _player:GetCoinNum()
    self:CoinFlyAction(chairId, _coinType, _coinNum)
    -- 玩家动作 --
    self:PlayerCall(chairId, "FOLLOW")

end

-- 筹码数->筹码类型 --
function GameGFlower:GetCoinType(addScore)
    for i = 1, COIN_NUM do
        if GFlowerConfig.ADD_BTN_TIMES[i] == GFlowerLogic.getInstance()._currentTimes then
            return i
        end
    end
    for i = 1, COIN_NUM do
        local _typeScore = GFlowerLogic.getInstance()._singleScore * GFlowerConfig.ADD_BTN_TIMES[i]
        if addScore == _typeScore then
            return i
        end
    end
    return math.random(1, 4)
end

-- 牌型动画 --
function GameGFlower:CardTypeAnimation(cardType, showChair,cardpos)
    local _cardAniType = nil
    local _cardAniName = nil
    if cardType == GFlowerConfig.CARD_TYPE.CT_DOUBLE then
        _cardAniType = "zjh_pxdh_eff"
        _cardAniName = "ani_01"
    elseif cardType == GFlowerConfig.CARD_TYPE.CT_SHUN_ZI then
        _cardAniType = "zjh_pxdh_eff"
        _cardAniName = "ani_02"
    elseif cardType == GFlowerConfig.CARD_TYPE.CT_JIN_HUA then
        _cardAniType = "zjh_pxdh_eff"
        _cardAniName = "ani_03"
    elseif cardType == GFlowerConfig.CARD_TYPE.CT_SHUN_JIN then
        _cardAniType = "zjh_pxdh_eff_2"
        _cardAniName = "ani_02"
    elseif cardType == GFlowerConfig.CARD_TYPE.CT_BAO_ZI then
        _cardAniType = "zjh_pxdh_eff_3"
        _cardAniName = "ani_01"
    end
    if _cardAniType and _cardAniName then
        local _cardAni = ccs.Armature:create(_cardAniType)
        if showChair == 0 then
            _cardAni:setPosition(cardpos)
        else
            _cardAni:setPosition(GFlowerConfig.PLAYER_CARD_POS[showChair])
        end
        self._cardTypeParent:addChild(_cardAni)
        _cardAni:getAnimation():play(_cardAniName)
    end
end

-- 用户看牌 --
function GameGFlower:PlayerLookCard(chairId)
    self:UpdateAddScore(chairId)

    --设置玩家的状态
    local gf_player = GFlowerLogic.getInstance()._pChairs[chairId]
    if gf_player then
        gf_player:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.LOOK)
        -- 音效 玩家 看牌 -
        self:PlayerCall(chairId, "LOOK_CARD")

        if gf_player:IsMySelf() then
            self.imageready[chairId]:setVisible(false)
            if GFlowerLogic.getInstance()._currentChairId == 1 then
                print("当前操作玩家  .."..GFlowerLogic.getInstance()._currentChairId)
                self:UsingDaojishi(1, GFlowerConfig.COUNT_DOWN_TIME)
                self:gfSetAddBtn()
            end
            self:BtnControlModel("LOOK_CARD", false)
            -- 牌型动画 --
            self:PlayerOpenCard(1)
            -- 音效 牌型 --
            self._soundMgr:PlayEffect_CardType(gf_player:IsMan(), _cardType)
        else
            if GFlowerLogic.getInstance()._currentChairId == chairId then
                self:UsingDaojishi(chairId, GFlowerConfig.COUNT_DOWN_TIME)
            end
            self._imagePlayerLook[chairId]:setVisible(true)
            self.gf_everyuserCard[chairId][2]:setRotation(15)
            self.gf_everyuserCard[chairId][3]:setRotation(30)
        end
    end


end

-- 比牌 --
function GameGFlower:CompareCard(compareChairId,isfanpai)
    local _logic = GFlowerLogic.getInstance()
    isfanpai = self._canplayCompareCard
    isfanpai = _logic:CanAllIn()
    if _logic._pChairs[1]:GetGameStatus() >= GFlowerConfig.PLAYER_STATUS.DROP
        or _logic._pChairs[1]:GetGameStatus() < GFlowerConfig.PLAYER_STATUS.WAIT then
        isfanpai = false
    end
    dump(tostring(isfanpai))
    if self._nowCompare then return end
    self._nowCompare = true

    -- 按钮控制关闭 --
    self:gfInitMeBtn(false)

    -- 动画 --
    local _moveTime = 0.5
    local _scaleCount = GFlowerConfig.CARD_COMPARE_SCALE
    local _comparePanel = self._comparePanel
    _comparePanel:setVisible(true)
    local _playerUp = _comparePanel:getChildByName("Player_Up")
    local _playerDown = _comparePanel:getChildByName("Player_Down")
    local _spriteVS = _comparePanel:getChildByName("Image_102")
                                    :getChildByName("Image_103")
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
    local _upName = _playerUp:getChildByName("name")
    local _upHead = _playerUp:getChildByName("headicon")
    local _upGoldNum = _playerUp:getChildByName("Label_GoldNum")
    local _downName = _playerDown:getChildByName("name")
    local _downHead = _playerDown:getChildByName("headicon")
    local _downGoldNum = _playerDown:getChildByName("Label_GoldNum")
    local _currentChairId = _logic._currentChairId

    local _upChairId = compareChairId[1]
    local _downChairId = compareChairId[2]
    local _myCompare = false
    for _, _chairId in pairs(compareChairId) do
        if _chairId == 1 then
            _myCompare = true
            _downChairId = _chairId
        else
            _upChairId = _chairId
        end
    end
    if not _myCompare then
        for _, _chairId in pairs(compareChairId) do
            if _chairId == _currentChairId then
                _downChairId = _chairId
            else
                _upChairId = _chairId
            end
        end
    end

    local _nickName, _headStr, _score
    local _upPlayer = _logic._pChairs[_upChairId]
    _upPlayer.iscompare = true
    local _addScore = nil
    _score = _upPlayer:GetOwnScore() or 0
    _score = app.table:MoneyShowStyle(_score)

    _nickName = _upPlayer:GetUserAdress()--GetNickName()
    _headStr = _upPlayer:GetHeadStr("Square")
    _upName:setString(_nickName)
    _upHead:loadTexture(_headStr)
    _upGoldNum:setString(_score)

    local _downPlayer = _logic._pChairs[_downChairId]
    _downPlayer.iscompare = true
    _nickName = _downPlayer:GetUserAdress()--GetNickName()
    _headStr = _downPlayer:GetHeadStr("Square")
    _score = _downPlayer:GetOwnScore() or 0
    _score = app.table:MoneyShowStyle(_score)

    _downName:setString(_nickName)
    _downHead:loadTexture(_headStr)
    _downGoldNum:setString(_score)

    local _upCardPos = {}
    local _downCardPos = {}
    local _upCardZOrder = {}
    local _downCardZOrder = {}
    local _upCardScale = {}
    local _downCardScale = {}
    local _upCardRotation = {}
    local _downCardRotation = {}
    for i = 1, GFlowerConfig.CARD_COUNT do
        local _upCardSprite = self.gf_everyuserCard[_upChairId][i]
        _upCardZOrder[i] = _upCardSprite:getLocalZOrder()
        _upCardPos[i] = {
            x = _upCardSprite:getPositionX(),
            y = _upCardSprite:getPositionY()
        }
        _upCardScale[i] = _upCardSprite:getScale()
        _upCardRotation[i] = _upCardSprite:getRotation()
        _upCardSprite:setLocalZOrder(_upCardZOrder[i] + GF_ADD_ZORDER)
        local _aimPos = cc.p(_upPos.x + 30*(i-1) + 300, _upPos.y + 25)
        _upCardSprite:stopAllActions()
        _upCardSprite:runAction(cc.Spawn:create(
            cc.MoveTo:create(_moveTime, _aimPos),
            cc.ScaleTo:create(_moveTime, _scaleCount),
            cc.RotateTo:create(_moveTime, 0)
            ))
        local _downCardSprite = self.gf_everyuserCard[_downChairId][i]
        _downCardZOrder[i] = _downCardSprite:getLocalZOrder()
        _downCardPos[i] = {
            x = _downCardSprite:getPositionX(),
            y = _downCardSprite:getPositionY()
        }
        _downCardScale[i] = _downCardSprite:getScale()
        _downCardRotation[i] = _downCardSprite:getRotation()
        _downCardSprite:setLocalZOrder(_downCardZOrder[i] + GF_ADD_ZORDER)
        _aimPos = cc.p(_downPos.x + 30*(i-1) + 270, _downPos.y + 25)
        _downCardSprite:stopAllActions()
        _downCardSprite:runAction(cc.Spawn:create(
            cc.MoveTo:create(_moveTime, _aimPos),
            cc.ScaleTo:create(_moveTime, _scaleCount),
            cc.RotateTo:create(_moveTime, 0)
            ))
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
        if not _upPlayer:IsEliminate() then
            _compare_name = "ani_05"
        end
        if isfanpai then
            _compare_name = "ani_02"
            if not _upPlayer:IsEliminate() then
                _compare_name = "ani_03"
            end
            _time_num = 1
        end
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
    end
    -- 输赢 --
    local _aniUpResult = _comparePanel:getChildByTag(GF_UP_RES_ANI)
    local _aniDownResult = _comparePanel:getChildByTag(GF_DOWN_RES_ANI)
    local function callfunc2()
        if not _aniUpResult then
            _aniUpResult = ccs.Armature:create("zjh_vs_eff")
            _aniUpResult:setPosition(400, 80)
            _aniUpResult:setTag(GF_UP_RES_ANI)
            _playerUp:addChild(_aniUpResult)
        end
        if not _aniDownResult then
            _aniDownResult = ccs.Armature:create("zjh_vs_eff")
            _aniDownResult:setPosition(120, 80)
            _aniDownResult:setTag(GF_DOWN_RES_ANI)
            _playerDown:addChild(_aniDownResult)
        end
        _aniUpResult:setVisible(true)
        _aniDownResult:setVisible(true)
        local lostChairID = _upChairId
        if _upPlayer:IsEliminate() then
            _aniUpResult:getAnimation():play("ani_02")
            _aniDownResult:getAnimation():play("ani_03")
        else
            lostChairID = _downChairId
            _aniUpResult:getAnimation():play("ani_03")
            _aniDownResult:getAnimation():play("ani_02")
        end
        if not isfanpai then
            _aniUpResult:getAnimation():setMovementEventCallFunc(function(sender, type)
                    if type == ccs.MovementEventType.complete then
                        for i = 1, GFlowerConfig.CARD_COUNT do
                            local _upCardSprite = self.gf_everyuserCard[_upChairId][i]
                            local _downCardSprite = self.gf_everyuserCard[_downChairId][i]

                            _downCardSprite:resetUI()
                            _upCardSprite:resetUI()
                            self.gf_everyuserCard[lostChairID][i]:setInvalid(true)
                        end
                    end
                end)
        end
    end
    -- 手牌飞出 --
    local function callfunc3()
        _comparePanel:setVisible(false)
        -- if not isfanpai then
        --     _compareAni:setVisible(false)
        -- end
        _aniUpResult:setVisible(false)
        _aniDownResult:setVisible(false)
        for i = 1, GFlowerConfig.CARD_COUNT do
            local _upCardSprite = self.gf_everyuserCard[_upChairId][i]
            local _downCardSprite = self.gf_everyuserCard[_downChairId][i]
            _upCardSprite:setLocalZOrder(_upCardZOrder[i])
            _downCardSprite:setLocalZOrder(_downCardZOrder[i])
            _upCardSprite:stopAllActions()
            _upCardSprite:runAction(cc.Spawn:create(
                cc.MoveTo:create(_moveTime, _upCardPos[i]),
                cc.ScaleTo:create(_moveTime, _upCardScale[i]),
                cc.RotateTo:create(_moveTime, _upCardRotation[i])
                ))

            if isfanpai then
                _downCardSprite:resetUI()
                _upCardSprite:resetUI()
            end
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
        local gf_player = GFlowerLogic.getInstance()._pChairs[chairId]
        local gf_loseuser = _upChairId
        if _upPlayer:IsEliminate() then
            if _upPlayer:GetGameStatus() ~= GFlowerConfig.PLAYER_STATUS.EXIT then
                _upPlayer:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.LOSE)
            end
            if _downPlayer:GetGameStatus() ~= GFlowerConfig.PLAYER_STATUS.EXIT then
                _downPlayer:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.WAIT)
            end
        else
            if _upPlayer:GetGameStatus() ~= GFlowerConfig.PLAYER_STATUS.EXIT then
                _upPlayer:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.WAIT)
            end
            if _downPlayer:GetGameStatus() ~= GFlowerConfig.PLAYER_STATUS.EXIT then
                _downPlayer:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.LOSE)
            end
            gf_loseuser = _downChairId
        end
        -- 玩家状态 --
        self:UpdatePlayerByStatus(_upChairId)
        self:UpdatePlayerByStatus(_downChairId)
        -- 设置当前玩家 --
        if _logic:GetInGamePlayer() >= 2 then
            self:StartChaozuoUser(_logic:GetNextChairId())
        else
            self._iconLight:setVisible(false)
            if _upChairId == 1 then
                self._otherPlayercard = _downChairId
            elseif _downChairId == 1 then
                self._otherPlayercard = _upChairId
            end
        end
        -- 隐藏喊话界面 --
        for i = 1, GFlowerConfig.CHAIR_COUNT do
            self._imagePlayerCallBg[i]:setVisible(false)
            self._imagePlayerCallAction[i]:setVisible(false)
        end
    end
    -- 是否结束 --
    local function callfunc5()
        self._nowCompare = false
        _downPlayer.iscompare = false
        _upPlayer.iscompare = false
        self:UpdatePlayerInfo(_upChairId)
        self:UpdatePlayerInfo(_downChairId)
        if _upPlayer:GetGameStatus() == GFlowerConfig.PLAYER_STATUS.EXIT then
            self:PlayerExitGame(_upChairId)
        end
        if _upPlayer:GetGameStatus() == GFlowerConfig.PLAYER_STATUS.EXIT then
            self:PlayerExitGame(_downChairId)
        end
        if isfanpai then
            if _upPlayer:IsEliminate() then
                if _upChairId ~= 1 then
                    self._imagePlayerLook[_upChairId]:setVisible(false)
                end
            else
                if _downChairId ~= 1 then
                    self._imagePlayerLook[_downChairId]:setVisible(false)
                end
            end
        end
        if self._nowEnd then
            self:GameEnd()
        end
    end

    -- 翻牌动画 --
    local function fanpaidonghua()
        _spriteVS:setVisible(true)
        local _type_pos = cc.p(700,560)
        print("zijishifoukanpai   "..tostring(_logic._pChairs[1]:IsLookCard()))
        if (_upChairId == 1 or _downChairId == 1) and _logic._pChairs[1]:IsLookCard() then
            local _other_chair = _upChairId
            if _upChairId == 1 then
                _other_chair = _downChairId
                _type_pos = cc.p(640,250)
            end
            local _other_player = _logic._pChairs[_other_chair]
            local _othercard = _other_player:GetPlayerCard()
            for i = 1, GFlowerConfig.CARD_COUNT do
                local _otherSprite = self.gf_everyuserCard[_other_chair][i]
                _otherSprite:setContent(false,_othercard[i])
                local ani_name = "ani_02"
                local delaytime = (i - 1)*0.66
                if i == 3 then
                    ani_name = "ani_01"
                    delaytime = (i - 1)*0.66 + 0.3
                end
                _otherSprite:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime),cc.CallFunc:create(
                    function ()
                        local _temp_Zorder = _otherSprite:getLocalZOrder()
                        _otherSprite:setLocalZOrder(_temp_Zorder + 3)
                        if i == 3 then
                            local args = {self,_type_pos,_other_player:GetCardType()}
                            _otherSprite:fanpaianimate(ani_name,_temp_Zorder,i,args)
                        else
                            _otherSprite:fanpaianimate(ani_name,_temp_Zorder,i)
                        end
                    end)))
            end
            return
        end
        local _upcard = _upPlayer:GetPlayerCard()
        local _downcard = _downPlayer:GetPlayerCard()
        for i = 1, GFlowerConfig.CARD_COUNT do
            local _upCardSprite = self.gf_everyuserCard[_upChairId][i]
            _upCardSprite:setContent(false,_upcard[i], false)
            local ani_name = "ani_02"
            local delaytime = (i - 1)*0.66
            if i == 3 then
                ani_name = "ani_01"
                delaytime = (i - 1)*0.66 + 0.3
            end
            _upCardSprite:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime),cc.CallFunc:create(
                function ()
                    local _temp_Zorder = _upCardSprite:getLocalZOrder()
                    _upCardSprite:setLocalZOrder(_temp_Zorder + 3)
                    if i == 3 then
                        local args = {self,cc.p(700,560),_upPlayer:GetCardType()}
                        _upCardSprite:fanpaianimate(ani_name,_temp_Zorder, i,args)
                    else
                        _upCardSprite:fanpaianimate(ani_name,_temp_Zorder,i)
                    end
                end)))
            local _downCardSprite = self.gf_everyuserCard[_downChairId][i]
            _downCardSprite:setContent(false,_downcard[i], false)
            _downCardSprite:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime + 0.3),cc.CallFunc:create(
                function ()
                    local _temp_Zorder = _downCardSprite:getLocalZOrder()
                    _downCardSprite:setLocalZOrder(_temp_Zorder + 3)
                    if i == 3 then
                        local args = {self,cc.p(640,250),_downPlayer:GetCardType()}
                        _downCardSprite:fanpaianimate(ani_name,_temp_Zorder,i ,args)
                    else
                        _downCardSprite:fanpaianimate(ani_name,_temp_Zorder, i)
                    end
                end)))
        end
    end

    local callfuncAction = nil
    if not isfanpai then
        callfuncAction = transition.sequence({
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(callfunc1),
            cc.DelayTime:create(1.0),
            cc.CallFunc:create(callfunc2),
            cc.DelayTime:create(2.5),
            cc.CallFunc:create(callfunc3),
            cc.DelayTime:create(1.0),
            cc.CallFunc:create(callfunc4),
            cc.CallFunc:create(callfunc5)
        })
    else
        callfuncAction = transition.sequence({
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(callfunc1),
            cc.CallFunc:create(fanpaidonghua),
            cc.DelayTime:create(3),
            cc.CallFunc:create(callfunc2),
            cc.DelayTime:create(1.5),
            cc.CallFunc:create(callfunc3),
            cc.DelayTime:create(1.0),
            cc.CallFunc:create(callfunc4),
            cc.CallFunc:create(callfunc5)
        })
    end
    _comparePanel:stopAllActions()
    _comparePanel:runAction(callfuncAction)

end

-- 荷官倒计时检测 --
function GameGFlower:CheckPlayGirlWait()
    local _countDown = GFlowerConfig.COUNT_DOWN_TIME
    local function timer()
        _countDown = _countDown - 1
        if _countDown < 4 then
            self._aniGirl:getAnimation():play("wait")
            scheduler.unscheduleGlobal(self._scheduleHandle)
        end
    end
    if self._scheduleHandle == nil then
        self._scheduleHandle = scheduler.scheduleGlobal(timer, 1)
    end
end

-- 准备倒计时 --
function GameGFlower:CheckReadyTime()
    local _countDown1 = GFlowerConfig.COUNT_DOWN_TIME
    local _countDown2 = GFlowerConfig.COUNT_DOWN_TIME
    self.Label_ResultCT:setString("(" .. _countDown1 .. "S)")
    self.Label_StartCT:setString("(" .. _countDown2 .. "S)")
    local function Timer()
        if self._resultPanel:isVisible() then
            _countDown1 = _countDown1 - 1
            self.Label_ResultCT:setString("(" .. _countDown1 .. "S)")
            if _countDown1 < 0 then
                self:gfgotoGameChoice()
            end
        elseif self.Button_StartGame:isVisible() then
            _countDown2 = _countDown2 - 1
            self.Label_StartCT:setString("(" .. _countDown2 .. "S)")
            if _countDown2 < 0 then
                self:gfgotoGameChoice()
            end
        elseif self._scheduleHandle1 then
            scheduler.unscheduleGlobal(self._scheduleHandle1)
            self._scheduleHandle1 = nil
        end
    end
    if self._scheduleHandle1 == nil then
        self._scheduleHandle1 = scheduler.scheduleGlobal(Timer, 1)
    end
end


-- 玩家翻牌动作 --
function GameGFlower:PlayerOpenCard(showChair)
    local _logic = GFlowerLogic.getInstance()
    local _player = _logic._pChairs[showChair]
    local _imagePlayer = self.gf_player[showChair]
    -- if _player:IsMySelf() and _player:IsLookCard() then
    --     return
    -- end
    local function open()
        for i = 1, GFlowerConfig.CARD_COUNT do
            if self.gf_everyuserCard[showChair][i] then
                self.gf_everyuserCard[showChair][i]:OpenAction()
            end
        end
    end
    local function showType()
        local _cardType = _player:GetCardType()
        self:CardTypeAnimation(_cardType, showChair)
    end

    _imagePlayer:runAction(cc.Sequence:create(
        cc.CallFunc:create(open),
        cc.DelayTime:create(0.2),
        cc.CallFunc:create(showType)
        ))

end

-- 开牌动画 --
function GameGFlower:OpenCardAni()
    local _logic = GFlowerLogic.getInstance()
    self.Panel_OpenCard:setVisible(true)
    self.Ani_OpenCard:getAnimation():play("ani_03")
    local _currentChairId = _logic._currentChairId
    local _chairs = {}
    -- 开牌椅子 --
    local GetOpenChair = nil
    GetOpenChair = function(_currentId)
        table.insert(_chairs, _currentId)
        table.insert(self._allcomparechairs, _currentId)
        if _logic:GetNext(_currentId) == _currentChairId then
            return
        end
        GetOpenChair(_logic:GetNext(_currentId))
    end
    GetOpenChair(_currentChairId)

    local _delayTime = 0
    for i = 1, #_chairs do
        local _chairId = _chairs[i]
        local _player = _logic._pChairs[_chairId]
        _delayTime = _delayTime + 0.5 * i
        local function OpenCard()
            if not (_player:IsMySelf() and _player:IsLookCard()) then
                self:PlayerOpenCard(_chairId)
            end
        end
        self:runAction(cc.Sequence:create(
            cc.DelayTime:create(_delayTime),
            cc.CallFunc:create(OpenCard)
            ))
    end

    self.layerUI:runAction(cc.Sequence:create(
        cc.DelayTime:create(_delayTime + 1),
        cc.CallFunc:create(function()
            self.Panel_OpenCard:setVisible(false)
            _logic:SendMsgFinishFlash()
            end)
        ))

end


-- 开牌消息 --
function GameGFlower:gfGameOpenCard()
    local gf_logic = GFlowerLogic.getInstance()
    self:CloseDojishi(gf_logic._currentChairId)
    -- 开牌动画 --
    if self._isAllIn then
        -- 全压 比牌 --
        local _comparePlayers = {
            gf_logic._currentChairId,
            gf_logic:GetNextChairId()
        }
        self:CompareCard(_comparePlayers,true)
        gf_logic:SendMsgFinishFlash()
    else
        local _reasonStr = nil
        -- 轮数最大开牌 --
        if gf_logic._nowRound >= GFlowerConfig.MAX_ROUND then
            _reasonStr = "达到" .. GFlowerConfig.MAX_ROUND .. "限制，进入全场比牌"
        else
            -- 金币不足开牌 --
            local _minChair = gf_logic:GetMinMoneyPlayer()
            local _player = gf_logic._pChairs[_minChair]
            _reasonStr = "由于“" .. _player:GetNickName() .."”金币不足，进入全场比牌"
        end
        self.Label_OpenCard:setString(_reasonStr)
        self:OpenCardAni()
    end

end

-- 启动那个玩家的操作 --
function GameGFlower:StartChaozuoUser(currentPlayer, bAllIn)
    local _logic = GFlowerLogic.getInstance()
    local gf_me_player = _logic._pChairs[1]
    if currentPlayer then
        local _player = _logic._pChairs[currentPlayer]
        -- 设置当前玩家 --
        _logic:SetCurrentPlayer(currentPlayer)
        -- 状态 --
        _player:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.CONTROL)
        -- 美女 摆手 --
        self._aniGirl:getAnimation():play("showhand")
        -- 倒计时 --
        self:UsingDaojishi(currentPlayer, GFlowerConfig.COUNT_DOWN_TIME)
        -- 美女 敲桌 --
        self:CheckPlayGirlWait()
        -- 游戏信息 更新 --
        self:UpdateGameInfo()
        -- 玩家信息 更新 --
        self:UpdatePlayerInfo(currentPlayer)

        local node = self.gf_player[currentPlayer]
        local distance = fishgame.MathAide:CalcDistance(node:getPositionX(), node:getPositionY(), self._iconLight:getPositionX(),  self._iconLight:getPositionY())
        local reg = fishgame.MathAide:CalcAngle(node:getPositionX(), node:getPositionY(), self._iconLight:getPositionX(),  self._iconLight:getPositionY())
        local scale = distance / self._iconLight:getContentSize().height
        if self._iconLight:isVisible() then
            self._iconLight:stopAllActions()
            self._iconLight:runAction(cc.Spawn:create(cc.RotateTo:create(0.1,math.deg(-reg)),
                cc.ScaleTo:create(0.1,1,scale)))
        else
            self._iconLight:setRotation(math.deg(-reg))
            self._iconLight:setScaleY(distance / self._iconLight:getContentSize().height)
        end
        self._iconPlayerLight:pos(node:getPosition())

        self._iconLight:setVisible(true)
        self._iconPlayerLight:setVisible(true)

        if currentPlayer == 1 then
            -- 处理全压 --
            if bAllIn == 1 then
                self:gfInitMeBtn(false)
                if self._isAllIn then
                    _logic:SendMsgOpenCard()
                else
                    self:BtnControlModel("ALL_IN", true)
                    self:BtnControlModel("GIVE_UP", true)
                    if gf_me_player:IsLookCard() then
                        self:BtnControlModel("LOOK_CARD", false)
                    else
                        self:BtnControlModel("LOOK_CARD", true)
                    end
                end
                return
            end

            -- 钱不足 --
            if not gf_me_player:AddSocreEnough() then
                self:BtnControlModel("FOLLOW", false)
                self.FollowDiFlag = 0
                ccui.Helper:seekWidgetByName(self.layerUI, "Panel_253"):setVisible(true)
                self.Button_FollowDi:getChildByName("Image_FollowDiFlag"):setVisible(false)
                self:BtnControlModel("ADD_SCORE", false)
                self:BtnControlModel("BI_PAI", true)
                return
            end

            --处理一直跟按钮
            if self.FollowDiFlag == 1 then
                self:gfInitMeBtn(false)
                self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function()
                    self:OnBtnEventFollow(self.Button_Follow, ccui.TouchEventType.ended)
                    end)))
                return
            end

            self.gf_me_chaozuo = 2
            -- 出局 --
            if gf_me_player:LostGame() then
                self:gfInitMeBtn(false)
                return
            end
            -- 音效 请下注 --
            if gf_me_player:GetGameStatus() == GFlowerConfig.PLAYER_STATUS.CONTROL then
                self._soundMgr:PlayEffect_ToAdd()
            end

            -- 玩家操作按钮判断 --
            self:JudgeControlBtn()

        else
            self:gfInitMeBtn(false)
            -- 启动玩家的弃牌和看牌按钮
            print("判断启动按个按钮")
            self:gfStartGiveup_look()
        end
    end
end

-- 游戏操作按钮 状态切换 --
function GameGFlower:BtnControlModel(b_name, b_click)
    if b_name == "LOOK_CARD" and GFlowerLogic.getInstance():GetGameRound() < 2 then
        b_click = false
    end
    local _controlBtn = self._controlMenu[b_name]["Button"]
    local _controlImage = self._controlMenu[b_name]["Image"]
    if _controlBtn and _controlImage then
        if b_click then
            if b_name == "ALL_IN" then
                self._canplayCompareCard = true
            end
            _controlBtn:setTouchEnabled(true)
            _controlBtn:setBright(true)
            _controlImage:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN[b_name][1])
        else
            _controlBtn:setTouchEnabled(false)
            _controlBtn:setBright(false)
            _controlImage:loadTexture(GFlowerConfig.IMAGE_CONTROL_BTN[b_name][2])
        end
    end
end

-- 游戏操作按钮 状态切换 --
function GameGFlower:gfStartGiveup_look(b_name, b_click)
    local _logic = GFlowerLogic.getInstance()
    if _logic._currentChairId == 1 then return end
    local gf_me_player = _logic._pChairs[1]
    if not gf_me_player or
        gf_me_player:GetGameStatus() < GFlowerConfig.PLAYER_STATUS.WAIT or
        gf_me_player:GetGameStatus() >= GFlowerConfig.PLAYER_STATUS.DROP then return end
    if gf_me_player:IsDrop() then return end
    if self._isAllIn == true then
        self:BtnControlModel("LOOK_CARD", false)
        self:BtnControlModel("GIVE_UP", false)
        return
    end
    print("玩家的状态           "..gf_me_player:GetGameStatus())
    if not gf_me_player:IsLookCard() then
        self:BtnControlModel("LOOK_CARD", true)
    end
    self:BtnControlModel("GIVE_UP", true)
end

--
function GameGFlower:JudgeControlBtn()
    local _logic = GFlowerLogic.getInstance()
    local gf_me_player = _logic._pChairs[1]

    -- 弃牌按钮 --
    self:BtnControlModel("GIVE_UP", true)

    -- 看牌按钮 --
    if gf_me_player:IsLookCard() then
        self:BtnControlModel("LOOK_CARD", false)
    else
        self:BtnControlModel("LOOK_CARD", true)
    end
    -- 跟注按钮 --
    if _logic:CanFollowGameScore() then
        self:BtnControlModel("FOLLOW", true)
    else
        self:BtnControlModel("FOLLOW", false)
    end
    -- 全压按钮 --
    if _logic:CanAllIn() then
        self:BtnControlModel("ALL_IN", true)
    else
        self:BtnControlModel("ALL_IN", false)
    end
    -- 处理比牌按钮
    if _logic:CanCompareCard() then
        self:BtnControlModel("BI_PAI", true)
    else
        self:BtnControlModel("BI_PAI", false)
    end
    -- 处理加注按钮
    if _logic:CanAddGameScore() then
        self:BtnControlModel("ADD_SCORE", true)
    else
        self:BtnControlModel("ADD_SCORE", false)
    end

end

-- 初始化自己的所有按钮
function GameGFlower:gfInitMeBtn(btouch)
    if btouch then
        for k, v in pairs(self._controlMenu) do
            self:BtnControlModel(k, true)
        end
    else
        for k, v in pairs(self._controlMenu) do
            self:BtnControlModel(k, false)
        end
    end

    self.Panel_Control:setVisible(true)
    self.Panel_JettonZone:setVisible(false)
end

-- 初始化界面元素 --(处理场景)
function GameGFlower:UpdateGameInfo()
    local gflogic = GFlowerLogic.getInstance()
    if gflogic._singleScore == nil then
        self.Label_Dizhu:setString(0)
    else
        self.Label_Dizhu:setString(app.table:MoneyShowStyle(gflogic._singleScore))
    end
    if gflogic._minScore == nil then
        self.Label_Danzhu:setString(0)
    else
        self.Label_Danzhu:setString(app.table:MoneyShowStyle(gflogic._minScore))
    end
    if gflogic._allScore == nil then
        self.Label_Zongzhu:setString(0)
    else
        self.Label_Zongzhu:setString(app.table:MoneyShowStyle(gflogic._allScore))
    end
    if gflogic._nowRound == nil then
        self.Label_Lunshu:setString(0)
    else
        self.Label_Lunshu:setString(gflogic._nowRound .. "/" .. GFlowerConfig.MAX_ROUND)
    end
end

-- 生成筹码 --
function GameGFlower:CreateCoin(coinType)
    local _logic = GFlowerLogic.getInstance()
    local _coinSprite = display.newSprite(GFlowerConfig.COIN_SPRITE_STR[coinType])
    local _coinLabel = cc.Label:create()
    local _coinScore = GFlowerConfig.ADD_BTN_TIMES[coinType] * _logic._singleScore
    _coinLabel:setString(app.table:MoneyShowStyle(_coinScore))
    _coinLabel:setSystemFontSize(24)
    _coinLabel:setPosition(
        _coinSprite:getContentSize().width / 2,
        _coinSprite:getContentSize().height / 2
        )
    _coinSprite:addChild(_coinLabel)
    return _coinSprite
end

-- 桌面筹码 --
function GameGFlower:DeskCoinInit()
    local gf_logic = GFlowerLogic.getInstance()

    -- 桌面筹码 --
    local _allScore = gf_logic._allScore
    local _singleScore = gf_logic._singleScore
    local _currentTimes = gf_logic._currentTimes

    local _coinNumTable = {}
    local GetCoinNum = nil
    GetCoinNum = function(count, timesCount)
        if count <= 0 or timesCount <= 0 or timesCount > #GFlowerConfig.ADD_BTN_TIMES then
            return
        end
        -- dump(timesCount)
        local _times = GFlowerConfig.ADD_BTN_TIMES[timesCount]
        local _jettonNum = _times * _singleScore
        local _remainNum = count % _jettonNum
        local _coinNum = math.floor(count / _jettonNum)
        -- local _coinInfo = {[timesCount] = _coinNum}
        -- dump(_coinInfo)
        _coinNumTable[timesCount] = _coinNum
        -- dump(_coinNumTable)
        if _remainNum == 0 then
            return
        else
            GetCoinNum(_remainNum, timesCount-1)
        end
    end

    if _allScore ~= 0 then
        local _timesCount = #GFlowerConfig.ADD_BTN_TIMES
        GetCoinNum(_allScore, _timesCount)
        -- dump(_coinNumTable)
        for _type, _num in pairs(_coinNumTable) do
            for i = 1, _num do
                local _pos = GetCoinRandPos()
                local _coinSprite = self:CreateCoin(_type)
                _coinSprite:setPosition(_pos.x, _pos.y)
                self._coinParent:addChild(_coinSprite)
                table.insert(self._coinSprite, _coinSprite)
            end
        end
        -- local _timesCount = #GFlowerConfig.ADD_BTN_TIMES
        -- for i = 1, _timesCount do
        --     local _nowScore = _singleScore * GFlowerConfig.ADD_BTN_TIMES[_timesCount - i]

        -- local _times = _allScore / (_singleScore * _currentTimes)
        -- _times = math.min(100,_times)
        -- for i = 1, _times do
        --     local _pos = GetCoinRandPos()
        --     local _coinType = math.random(1, 4)
        --     local _coinSprite = self:CreateCoin(_coinType)
        --     _coinSprite:setPosition(_pos.x, _pos.y)
        --     self._coinParent:addChild(_coinSprite)
        --     table.insert(self._coinSprite, _coinSprite)
        -- end
    end
end

-- 初始化一次 --
function GameGFlower:InitOnce()
    -- 桌面筹码 --
    self:DeskCoinInit()

    -- 下注筹码 --
    self:JettonInit()
end

-- 倒计时通用接口 --
function GameGFlower:UsingDaojishi(showChair, timenum)
    if showChair < 1 or showChair > GFlowerConfig.CHAIR_COUNT then return end

    local _time1 = math.floor(timenum / 3)
    local _progress = self._daojishius[showChair]
    local function daojishi3()
        local _lastTime = timenum - _time1 * 2
        local _action3 = cc.ProgressFromTo:create(_lastTime, 33, 0)
        _progress:setSprite(cc.Sprite:create(GFlowerConfig.IMAGE_COUNT_DOWN[3]))
        if showChair == 1 then
            _progress:runAction(cc.Sequence:create(
                _action3,
                cc.CallFunc:create(function()
                    if self.gf_me_chaozuo == 1 and showChair == 1 then
                        self:gfgotoGameChoice()
                    elseif self.gf_me_chaozuo == 2 and showChair == 1 then
                        GFlowerLogic.getInstance():SendMsgGiveUp()
                        -- 操作UI重置 --
                        self:ResetMyControlUi()
                    end
                end)))
        else
            _progress:runAction(_action3)
        end
    end

    local function daojishi2()
        local _action2 = cc.Sequence:create(
            cc.ProgressFromTo:create(_time1, 66, 33),
            cc.CallFunc:create(daojishi3)
            )
        _progress:setSprite(cc.Sprite:create(GFlowerConfig.IMAGE_COUNT_DOWN[2]))
        _progress:runAction(_action2)
    end

    local _action1 = cc.Sequence:create(
        cc.ProgressFromTo:create(_time1, 100, 66),
        cc.CallFunc:create(daojishi2)
        )

    _progress:stopAllActions()
    _progress:setVisible(true)
    _progress:setSprite(cc.Sprite:create(GFlowerConfig.IMAGE_COUNT_DOWN[1]))
    _progress:runAction(_action1)

end

-- 停止倒计时 --
function GameGFlower:CloseDojishi(showChair)
    self._daojishius[showChair]:stopAllActions()
    self._daojishius[showChair]:setVisible(false)
end

-- 启动开始按钮 --
function GameGFlower:ShowStartButton()
    -- self:UsingDaojishi(1, GFlowerConfig.COUNT_DOWN_TIME)
    self.gf_me_chaozuo = 1
    self.Button_StartGame:setOpacity(255)
    self.Button_StartGame:setVisible(true)
    self.Button_StartGame:setTouchEnabled(true)
    -- 倒计时检测 --
    self:CheckReadyTime()
end

-- 隐藏开始按钮 --
function GameGFlower:HideStartButton()
    self.Button_StartGame:setVisible(false)
    self.Button_StartGame:setTouchEnabled(false)
end

-- 点击开始按钮隐藏事件 --
function GameGFlower:HideStartButtonWithAni()
    local function Light()
        self.Ani_StartButton:setVisible(true)
        self.Ani_StartButton:getAnimation():play("ani_02")
    end

    self.Button_StartGame:runAction(cc.Sequence:create(
        cc.CallFunc:create(Light),
        cc.DelayTime:create(0.3),
        cc.FadeOut:create(0.5),
        cc.CallFunc:create(function()
            self:HideStartButton()
            end)))

end

-- 隐藏玩家状态信息 --
function GameGFlower:HidePlayerStatusInfo(showChair)
    self.imageready[showChair]:setVisible(false)
end

-- 更新玩家加注 --
function GameGFlower:UpdateAddScore(showChair)
    local gflogic = GFlowerLogic.getInstance()
    local player = gflogic._pChairs[showChair]
    if not player then return end

    local _addScore = nil
    local _pGameScore = player:GetGameScore()
    if not _pGameScore or _pGameScore == 0 then
        _addScore = "获取中"
        self.gf_player[showChair]:getChildByName("Label_XiaZhuNum"):setVisible(false)
        self.gf_player[showChair]:getChildByName("Image_XiaZuBg"):setVisible(false)
    else
        self.gf_player[showChair]:getChildByName("Label_XiaZhuNum"):setVisible(true)
        self.gf_player[showChair]:getChildByName("Image_XiaZuBg"):setVisible(true)
        _addScore = app.table:MoneyShowStyle(_pGameScore)
        self.gf_player[showChair]:getChildByName("Label_XiaZhuNum"):setString(_addScore)
    end

    self.gf_player[showChair]:getChildByName("Label_XiaZhuNum"):setString(_addScore)
    self.gf_player[showChair]:getChildByName("Label_GoldNum"):setString(app.table:MoneyShowStyle(player:GetOwnScore()))
end


--退出游戏
function GameGFlower:gfgotoGameChoice(bpay)
    app.table:sendStandup()
    custom.PlatUtil:closeServer(CLIENT_GAME)
    GFlowerLogic.Clear()
    if bpay == nil then
        uiManager:runScene("GameChoice")
    else
        uiManager:runScene("GameChoice",{bpay})
    end
end

-- 筹码 飞入 --
function GameGFlower:CoinFlyAction(chairId, scoreType, coinNum)
    local _player = GFlowerLogic.getInstance()._pChairs[chairId]
    local _resPath = GFlowerConfig.COIN_SPRITE_STR[scoreType]
    local _pos = GFlowerConfig.PLAYER_LOCATION[chairId]

    for i = 1, coinNum do
        local _coinSprite = self:CreateCoin(scoreType)
        _coinSprite:setPosition(_pos.x, _pos.y)
        self._coinParent:addChild(_coinSprite)
        local _pos = GetCoinRandPos()
        _coinSprite:runAction(cc.MoveTo:create(0.2, cc.p(_pos.x, _pos.y)))
        table.insert(self._coinSprite, _coinSprite)
    end
    -- 音效 筹码飞入 --
    self._soundMgr:PlayEffect_CoinFlyIn()
end

-- 筹码 飞出 --
function GameGFlower:CoinFlyOutAction(chairId)
    local _pos = GFlowerConfig.PLAYER_LOCATION[chairId]
    local _delayTime = 0
    local coinAllNum = table.getn(self._coinSprite);
    local unitCoinTime = 2.0/coinAllNum
    for _, _coinSprite in pairs(self._coinSprite) do
        if _coinSprite and not tolua.isnull(_coinSprite) then
            _delayTime = _delayTime + 0.03
            _coinSprite:runAction(cc.Sequence:create(
                cc.DelayTime:create(_delayTime),
                cc.MoveTo:create(unitCoinTime, _pos),
                cc.CallFunc:create(function()
                    _coinSprite:setVisible(false)
                end)
                ))
        end
    end

    -- 音效 筹码飞出 --
    self._soundMgr:PlayEffect_CoinFlyOut()


    if self._harvestMoneyAni then
        self._harvestMoneyAni:removeFromParent()
        self._harvestMoneyAni = nil
    end
    local _logic = GFlowerLogic.getInstance()
    local _winnerChair = _logic._winnerChairId
    if _winnerChair == 1 then
        -- 少：得分<最小单注*50
        -- 中：最小单注*50<=得分<=最小单注*200
        -- 多：得分>最小单注*200
        local function harvestMoneyAnimation( )
            -- body
            self._harvestMoneyAni = ccs.Armature:create("zhajinhua_shouhuo_01")
            self._harvestMoneyAni:setLocalZOrder(GF_ADD_ZORDER)
            local myPlayer = self.layerUI:getChildByName("Image_player_1")
            myPlayer:addChild(self._harvestMoneyAni)

            --local _player = _logic._pChairs[1]
            local _wChairId = _logic._UserName[1].wchairId
            local _gainScore = _logic._GameendInfo.lGameScore[_wChairId + 1]

            --local _gainScore = _player:GetGainScore()
            print("当前的最小注： ".._logic._singleScore)
            print("当前自己得分： ".._gainScore)

            if _gainScore < _logic._singleScore * 50 then
                self._harvestMoneyAni:getAnimation():play("ani_03")
            elseif _logic._singleScore * 50 <= _gainScore and _gainScore < _logic._singleScore * 200 then
                self._harvestMoneyAni:getAnimation():play("ani_02")
            else
                self._harvestMoneyAni:getAnimation():play("ani_01")
            end
            local _pos = {
                x = myPlayer:getPositionX()-130 ,
                y = myPlayer:getPositionY()-40
            }
            self._harvestMoneyAni:setPosition(_pos.x, _pos.y)
        end

        local function scoreUpAnimation( ... )
            -- body
            print("scoreUpAnimation")
            local scoreLabel = self.layerUI:getChildByName("winScore")
            if scoreLabel == nil then
                print("scoreLabel is nil")
            end
            scoreLabel:setVisible(true);
            scoreLabel:setScale(2.0);
            scoreLabel:setLocalZOrder(GF_ADD_ZORDER*2+1)
            -- local _player = _logic._pChairs[1]
            -- local _gainScore = _player:GetGainScore()
            local _wChairId = _logic._pChairs[1]:GetwChairId()
            local _gainScore = _logic._GameendInfo.lGameScore[_wChairId + 1]
            scoreLabel:setString("+"..(_gainScore/100.0))
            scoreLabel:runAction(cc.MoveBy:create(1.0, cc.p(0 , 40)))
        end
        local function scoreLabelMiss( ... )
            -- body
            print("scoreLabelMiss")
            local scoreLabel = self.layerUI:getChildByName("winScore")
            scoreLabel:setVisible(false);
        end
        self:runAction(transition.sequence({
            cc.CallFunc:create(harvestMoneyAnimation),
            cc.CallFunc:create(scoreUpAnimation),
            cc.DelayTime:create(1),
            cc.CallFunc:create(scoreLabelMiss),
            cc.DelayTime:create(1),
        }))
        _delayTime = _delayTime + 4 - unitCoinTime*0.03
    end

    -- 结算界面 --
    self.layerUI:runAction(cc.Sequence:create(
        cc.DelayTime:create(_delayTime + 0.2),
        cc.CallFunc:create(handler(self, self.ShowResultPanel))
        ))
end

-- 结算界面 --
function GameGFlower:ShowResultPanel()
    local gflogic = GFlowerLogic.getInstance()
    -- 判断金币 --
    if not gflogic._pChairs[1]:ScoreEnough() then
        self:tipQueqian(5)
    end

    -- 美女待机 --
    self._aniGirl:getAnimation():play("stay")

    -- 结算界面
    local _resultPanel = self._resultPanel
    _resultPanel:setVisible(true)

    -- 开始按钮 隐藏 --
    self:HideStartButton()

    -- 赢家动画 --
    self.Ani_WinPlayer:setVisible(false)
    if self._resultWinAni then
        self._resultWinAni:removeFromParent()
        self._resultWinAni = nil
    end
    -- 处理自己被踢
    if gflogic._isMissed == true then
        _resultPanel:getChildByName("btn_ready"):setVisible(false)
        _resultPanel:getChildByName("btn_huanzhuo"):setVisible(false)
    end
    --local _playerMySelf = gflogic._pChairs[1]
    local _imageSelfLight = _resultPanel:getChildByName("Image_Light")
    local _imageSelfArrow = _resultPanel:getChildByName("Image_Self")
    local _imageSelfNameBg = ccui.Helper:seekWidgetByName(_resultPanel, "Name_bg")
    local _playerIndex = {1, 2, 3, 4, 5}

    if gflogic._UserName[1] then
        _playerIndex = {3, 2, 4, 1, 5}
        _imageSelfLight:setVisible(true)
        _imageSelfArrow:setVisible(true)
        _imageSelfNameBg:setVisible(true)
        --音效 结果 --
        self._soundMgr:PlayEffect_Result(gflogic._winnerChairId)
    else
        _imageSelfLight:setVisible(false)
        _imageSelfArrow:setVisible(false)
        _imageSelfNameBg:setVisible(false)
    end

    local _index = 0
    local gf_caozuo_status = gflogic:GetPlayerCaozuo()
    local _gameendinfo = gflogic._GameendInfo

    for k,v in pairs(gflogic._UserName) do

    end
    --dump(gflogic._UserName, "-----------------")
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self:CloseDojishi(i)
        local _player = GFlowerLogic.getInstance()._pChairs[i]
        if gflogic._UserName[i] then
            _index = _index + 1
            -- dump("chairId.." .. i .. "..status.." .. _player:GetGameStatus())
            local _playerParent = _resultPanel:getChildByName("player" .. _playerIndex[_index])
            local _playerInfo = _playerParent:getChildByName("Panel_Player")
            local _playerNull = _playerParent:getChildByName("Image_null")
            _playerInfo:setVisible(true)
            _playerNull:setVisible(false)
            -- 头像
            local _headIcon = _playerInfo:getChildByName("headicon")
            _headIcon:loadTexture(gflogic._UserName[i].szHeadIcon)
            -- 昵称
            local _nickName = _playerInfo:getChildByName("name")
            _nickName:setString(gflogic._UserName[i].szNickName)
            -- 筹码
            local _score = _playerInfo:getChildByName("Image_126"):getChildByName("icon")
            local _winerPanel = _playerInfo:getChildByName("Image_winer")
            local _wChairId = gflogic._UserName[i].wchairId
            local _gainScore = _gameendinfo.lGameScore[_wChairId + 1]
            if _gainScore < 0 then
                _score:setColor(cc.c3b(251, 39, 43))
                _score:setString(app.table:MoneyShowStyle(_gainScore))
                _winerPanel:setVisible(false)
                _playerInfo:getChildByName("Image_126"):setVisible(true)
            else
                -- 结算界面 赢家动画 --
                self._resultWinAni = ccs.Armature:create("bb_zjh_win_eff")
                self._resultWinAni:setLocalZOrder(GF_ADD_ZORDER)
                _resultPanel:addChild(self._resultWinAni)
                self._resultWinAni:getAnimation():play("ani_04")
                local _pos = {
                    x = _playerParent:getPositionX(),
                    y = _playerParent:getPositionY() + 210
                }
                self._resultWinAni:setPosition(_pos.x, _pos.y)

                _score:setColor(cc.c3b(255, 165, 0))
                _score:setString("+" .. _gainScore)
                _winerPanel:setVisible(true)
                _playerInfo:getChildByName("Image_126"):setVisible(false)
                _winerPanel:getChildByName("icon"):setString("+" ..
                    app.table:MoneyShowStyle(_gainScore))
                _winerPanel:getChildByName("tax"):setString("-" ..
                    app.table:MoneyShowStyle(GFlowerLogic.getInstance()._taxScore))

            end

            -- 卡牌 --
            local gf_caozuo = _playerInfo:getChildByName("Image_caozuo")
            if gf_caozuo_status[i] == 0 or i == 1 or i == self._otherPlayercard or _gainScore > 0 then
                gf_caozuo:setVisible(false)
                if i == 1 or i == self._otherPlayercard or _gainScore > 0 then
                    --local gf_carddata = _player:GetPlayerCard()
                    --dump(gf_carddata)
                    for j = 1, GFlowerConfig.CARD_COUNT do
                        local gf_carddata = _gameendinfo.cbCardData[_wChairId * GFlowerConfig.CARD_COUNT + j]
                        local _card = _playerInfo:getChildByName("poker" .. j)
                        _card:loadTexture("NNPoker/poker_"..gf_carddata..".png")
                    end
                end
                --if i == 1 then
                    if gf_caozuo_status[i] == 1 then
                        gf_caozuo:setVisible(true)
                        gf_caozuo:loadTexture("GameGFlower/zjh_wanjia_tt.png")
                    elseif gf_caozuo_status[i] == 2 then
                        gf_caozuo:setVisible(true)
                        gf_caozuo:loadTexture("GameGFlower/zjh_wanjia_qp.png")
                    end
                --end
            else
                gf_caozuo:setVisible(true)
                for j = 1, GFlowerConfig.CARD_COUNT do
                    local _card = _playerInfo:getChildByName("poker" .. j)
                    _card:loadTexture("NNPoker/poker_back.png")
                end
                if gf_caozuo_status[i] == 1 then
                    gf_caozuo:loadTexture("GameGFlower/zjh_wanjia_tt.png")
                else
                    gf_caozuo:loadTexture("GameGFlower/zjh_wanjia_qp.png")
                end
            end
            for k,v in pairs(self._allcomparechairs) do
                if v == i then
                    --local gf_carddata = _player:GetPlayerCard()
                    for j = 1, GFlowerConfig.CARD_COUNT do
                        local gf_carddata = _gameendinfo.cbCardData[_wChairId * GFlowerConfig.CARD_COUNT + j]
                        local _card = _playerInfo:getChildByName("poker" .. j)
                        _card:loadTexture("NNPoker/poker_"..gf_carddata..".png")
                    end
                end
            end
        else
            local _backIndex = GFlowerConfig.CHAIR_COUNT - i + _index + 1
            local _playerParent = _resultPanel:getChildByName("player" .. _playerIndex[_backIndex])
            local _playerInfo = _playerParent:getChildByName("Panel_Player")
            local _playerNull =_playerParent:getChildByName("Image_null")
            _playerInfo:setVisible(false)
            _playerNull:setVisible(true)
        end
    end
    -- 准备倒计时 --
    self:CheckReadyTime()

    -- 桌面数据 还原 --
    self:ResetDesk()

end

--服务器T掉了玩家 提示缺钱
function GameGFlower:tipQueqian(timenum)
    self._isticu = true
    self:runAction(transition.sequence({
            cc.DelayTime:create(timenum),
            cc.CallFunc:create(function()
                self:queQian()
            end)
        }))
end

--显示缺钱提示
function GameGFlower:queQian()
    if self:getChildByTag(10003) then
        return
    end
    local tipBox = app.hall.BombBox:CreatePayAndShow(true,app.hallLogic._meRoomentersore.lMinEnterScore)
    tipBox:setTag(10003)
    --self:addChild(tipBox, 10001)
end

-- 走马灯 --
function GameGFlower:LanternAction()
    local _lanternPanel = self.layerUI:getChildByName("Image_TextBg"):getChildByName("Panel_Zoumadeng")
    local _lanternLabel = _lanternPanel:getChildByName("Label_Text")
    _lanternLabel:setString("")
    local _speed = 100
    local _moveDistance = 500
    local _firstEnter = false
    local _lanternLen = 0
    local _logic = GFlowerLogic.getInstance()
    local function loopCallFunc()
        local _lanternStr = _logic._gLanterns[1]
        if _lanternStr then
            _lanternLabel:setString(_lanternStr)
            local _length = _lanternLabel:getContentSize().width
            _lanternLen = _moveDistance + _length
            _lanternLabel:setPositionX(_moveDistance)
            table.remove(_logic._gLanterns, 1)
        end

        local callfunc = cc.CallFunc:create(loopCallFunc)
        _lanternLabel:runAction(cc.Sequence:create(
            cc.MoveBy:create(_lanternLen/_speed, cc.p(-_lanternLen, 0)),
            callfunc
            ))
    end
    loopCallFunc()
end



return GameGFlower