local FishGameXMLConfigManager = requireForGameLuaFile("FishGameXMLConfigManager")

local FishGameCannon = class("FishGameCannon",function()
    return display.newNode()
end)

function FishGameCannon:ctor(chairId,conf)
    self._chairId = chairId
    self._conf = conf
end

function FishGameCannon:getCannonPosition()
    return self._conf.pos
end

function FishGameCannon:updateCannon(cannonSet, cannonType, cannonMul)
    self:removeAllChildren()

    local cannonSet = FishGameXMLConfigManager:getInstance()._cannonSetVector[cannonSet]
    local cannon = cannonSet.Sets[cannonType]


    local armature = ccs.Armature:create(cannon.Cannon.szResourceName)
    armature:getAnimation():play(cannon.Cannon.Name)
    armature:setScale(0.2)
    armature:runAction(cc.ScaleTo:create(0.2,1))
    self:addChild(armature)

    local effectWeaponReplace = ccs.Armature:create("effect_weapons_replace")
    effectWeaponReplace:getAnimation():play("effect_weapons_replace_animation")
    self:addChild(effectWeaponReplace)
    effectWeaponReplace:runAction(transition.sequence({
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function(sender)
            sender:removeSelf()
        end)
    }))


    self.armature = armature
    self._cannon = cannon.Cannon
end

function FishGameCannon:_doAction_Fire()
    if tolua.isnull(self.armature) then return end

    self.armature:getAnimation():play(self._cannon.Move)

end

return FishGameCannon