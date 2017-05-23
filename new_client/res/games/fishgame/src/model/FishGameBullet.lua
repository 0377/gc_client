--
-- Author: yangfan
-- Date: 2017-3-28 
-- 捕鱼游戏 子弹
--

local FishGameBullet = class("FishGameBullet", function()
    return game.fishgame2d.Bullet:create()
end)

function FishGameBullet:ctor(data)
    self:registerStatusChangedHandler(handler(self,self.onStateUpdated))

    self:setId(data.id)
    self:move(data.x_pos,data.y_pos)
    self._isMine = GameManager:getInstance():getHallManager():getSubGameManager():getMyChairId() == data.chair_id

    -- 路径
    local moveCompent = game.fishgame2d.MoveByDirection:create()
    moveCompent:SetRebound(true)
    moveCompent:setSpeed(600)
    moveCompent:SetPosition(data.x_pos,data.y_pos)
    moveCompent:SetDirection(data.direction)

    self:setMoveCompent(moveCompent)


    local serverTime = GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getServerTime()
    self:OnUpdate((serverTime - data.server_tick) / 1000,true)
    self:setState(EOS_LIVE)
end




function FishGameBullet:onStateUpdated(state)
    self:removeAllChildren()

    if state == EOS_LIVE then
        local t_animation = ccs.Armature:create( "bb_likui_pao_bullet" )
        t_animation:getAnimation():play("Bullet_v1")
        self:addChild(t_animation)
    elseif state == EOS_DEAD then
        local t_animation = ccs.Armature:create( "effect_fish_bomb" )
        t_animation:getAnimation():play("effect_fish_bomb_01_ani")
        self:addChild(t_animation)

        t_animation:getAnimation():setMovementEventCallFunc(function(sender, type, id)
            if type == ccs.MovementEventType.start then
            elseif type == ccs.MovementEventType.complete then
                self:setVisible(false)
                self:setState(EOS_DESTORED)
            end
        end)

        -- 播放死亡音乐
--        FishGameManager:getSoundManager():playBulletSound(self:getTypeId())


    elseif state == EOS_DESTORED then
        self:removeSelf()
    end


end

return FishGameBullet
