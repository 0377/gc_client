--
-- Author: vincent
-- Date: 2016-08-09 14:00:38
--

GFlowerPoker = class("GFlowerPoker", function()
    return ccui.Widget:new()
end)

GFlowerPoker._uiFrame=nil      --图片
GFlowerPoker._isFront=nil      --正反(true正面，false反面)
GFlowerPoker._point=nil        --点数(1-13花色，14小王，15大王)
GFlowerPoker._pokername = nil
GFlowerPoker._invalid = false

--参数一，正反，参数二，花色，参数三，点数
function GFlowerPoker:ctor(isFront, num)
    self._uiFrame = cc.Sprite:create()
    self:addChild(self._uiFrame)
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo( "games/gflower/res/anim/bb_zjh_fanpai/bb_zjh_fanpai0.png",
    --     "games/gflower/res/anim/bb_zjh_fanpai/bb_zjh_fanpai0.plist" ,
    --     "games/gflower/res/anim/bb_zjh_fanpai/bb_zjh_fanpai.ExportJson" )
    self._animation = ccs.Armature:create( "dkj_fanpai_eff" )
    self._animation:setVisible(false)
    self._animation:setScale(112/96)
    self._animation:setPosition(cc.p(-4,-57))
    self:addChild(self._animation)
    self:setContent(isFront, num, false)
end

--参数一，正反，参数二，花色，参数三，点数
function GFlowerPoker:setContent(isFront, num, needReversal)
    self._isFront = isFront
    self._point = num

    --if not self._point or self._point == 0 then
    if isFront == false or not self._point or self._point == -1 then
        --self._pokername = GFlowerConfig.POKER.BACK_NORMAL
        self._uiFrame:setTexture(self._pokername)
    else
        self._pokername = "games/gflower/res/gpoker/poker_" .. self._point .. ".png"
        self._uiFrame:setTexture(self._pokername)

        if needReversal == true then
            self:OpenAction()
        end
    end

    self._uiFrame:setScale(GFlowerConfig.CARD_STAY_SCALE_OTHER)
end

--设置是否可用
function GFlowerPoker:setInvalid(isInvalid)
    self._invalid = isInvalid
    if isInvalid then
        self._pokername = GFlowerConfig.POKER.BACK_INVALID
    else
        self._pokername = GFlowerConfig.POKER.BACK_NORMAL
    end

    self._uiFrame:setTexture(self._pokername)
    self._uiFrame:setScale(GFlowerConfig.CARD_STAY_SCALE_OTHER)
end

-- 翻牌 --
function GFlowerPoker:OpenAction()
    self._uiFrame:setFlippedX(false)
    self._uiFrame:setRotationSkewX(0)
    self._uiFrame:setRotationSkewY(0)
    local time = 0.2
    local function unReversal()
        self._uiFrame:setTexture(self._pokername)
        self._uiFrame:setFlippedX(true)
    end

    local function setPoint()
        self._uiFrame:setTexture("games/gflower/res/gpoker/poker_"..self._point..".png")
    end

    self._uiFrame:runAction(cc.Sequence:create(
        cc.RotateBy:create(time/2, 0, 90),
        cc.CallFunc:create(unReversal),
        cc.RotateBy:create(time/2, 0, 90),
        cc.DelayTime:create(2.0),
        cc.CallFunc:create(setPoint)
        ))
end

-- 翻牌动画 --
function GFlowerPoker:fanpaianimate(aniname,localzorder,cardcount,argsment)
    self._animation:setVisible(true)
    self._uiFrame:setVisible(false)
    --self._point = 18
    local t_str = ""
    local t_str2 = ""
    t_str = "games/gflower/res/gpoker/smallpoker_"..self._point..".png"
    t_str2 = "games/gflower/res/gpoker/poker_"..self._point..".png"
    -- if self._point>=14 then
    --     t_str2 = "poker/".."w"..self._point..".png"
    -- else
    --     t_str2 = "poker/"..self._color..self._point..".png"
    -- end
    local skin = ccs.Skin:create(t_str)
    local skin2 = ccs.Skin:create(t_str2)
    if aniname == "ani_01" then
        self._animation:setPosition(cc.p(-6,-60))
    else
        self._animation:setPosition(cc.p(-4,-57))
    end

    self._animation:getBone("fanpaixiao"):addDisplay(skin, 0)
    self._animation:getBone("Layer3"):addDisplay(skin2, 0)

    self._animation:getBone("fanpaixiao"):changeDisplayWithIndex(0, true)
    self._animation:getBone("Layer3"):changeDisplayWithIndex(0, true)

    self._animation:getAnimation():stop()
    self._animation:getAnimation():play(aniname)
    self._animation:getAnimation():setMovementEventCallFunc(function(sender, type)
            if type == ccs.MovementEventType.complete then
                sender:setLocalZOrder(localzorder)
                self._uiFrame:setTexture(t_str2)
                if cardcount == 3 then
                    --显示牌型动画
                    argsment[1]:CardTypeAnimation(argsment[3],0,argsment[2])
                end
            end
        end)
end

-- 还原牌 --
-- 翻牌 --
function GFlowerPoker:resetUI()
    self._animation:setVisible(false)
    self._uiFrame:setVisible(true)
    self._uiFrame:setRotation(0)
    self:setRotation(0)
end


return GFlowerPoker
