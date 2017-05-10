local DdzPoker = class("DdzPoker", function()
    return ccui.Widget:new()
end)

DdzPoker.WIDTH = 180
DdzPoker.HEIGHT = 232

--- @isFront 正反
--- @point 点数
--- @paibei 牌的背景图片
function DdzPoker:ctor(isFront, point)
    -- self:setTouchEnabled(true)
    -- self:setSwallowTouches(false)
    -- self:addTouchEventListener(handler(self, self._onTouched))
    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setContentSize(DdzPoker.WIDTH, DdzPoker.HEIGHT)

    -- 牌面点数 --
    self._point = nil

    self._x = 0
    self._y = 0
    self._isSelected = false

    self._uiFrame =  cc.Sprite:create():align(display.CENTER, DdzPoker.WIDTH / 2, DdzPoker.HEIGHT / 2):addTo(self)

    self:setContent(isFront, point)
end

function DdzPoker:_onTouched(sender, eventType)
    
    if eventType == ccui.TouchEventType.began then
        --print("3434--=====")
        return true
    elseif eventType == ccui.TouchEventType.moved then
        --print("33333--=====")
    elseif eventType == ccui.TouchEventType.ended then
        --print("44444--=====")
    end
end

function DdzPoker:pos(x, y)
    self._x = x
    self._y = y

    self:setPosition(cc.p(x+640, y + (self._isSelected and 30 or 0)))

    return self
end

function DdzPoker:SetTouchDelegate(_handler)
    -- self:setTouchEnabled(_handler ~= nil)
    -- self._handler = _handler

    -- return self
end

function DdzPoker:GetPoint()
    return self._point
end

function DdzPoker:SetSelected(selected)
    self._isSelected = selected
    self:setPosition(cc.p(self._x+640, self._y + (self._isSelected and 30 or 0)))
end

function DdzPoker:IsSelected()
    return self._isSelected
end

function DdzPoker:setFront(isFront)
    self._isFront = isFront
    ---print("UpdateContent:-------------111111")
    self:UpdateContent()
end

function DdzPoker:setContent(isFront, point)
    self._isFront = isFront
    self._point = point
    ---print("UpdateContent:-------------2222222",isFront)
    self:UpdateContent()
end

--将扑克翻转 time翻转用的时间
function DdzPoker:reversal(time, point)
    self._point = point
   
    self._uiFrame:runAction(transition.sequence({
        cc.RotateTo:create(time / 2, 0, 90),
        cc.CallFunc:create(function()
            self._isFront = not self._isFront
            self:UpdateContent()
        end),
        cc.RotateTo:create(time / 2, 0, 0)
    }))
end

function DdzPoker:StopReversal()
    self._uiFrame:stopAllActions()
    self._uiFrame:runAction(cc.RotateTo:create(0, 0, 0))
end

function DdzPoker:UpdateContent()
    if self._isFront then ---0方块 1梅花 2红桃 3黑桃
        local point = math.floor(self._point/4);
        local colorNum = math.floor(self._point%4)
        if self._point == 52 then
            point = 1
            colorNum = 4
        end
        if self._point == 53 then
            point = 2
            colorNum = 4
        end
        self._uiFrame:setTexture("public/poker/poker_"..string.format("%d", colorNum).."_"..string.format("%d", point)..".png")

    else
        self._uiFrame:setTexture("public/poker/poker_back.png")
    end
end

return DdzPoker
