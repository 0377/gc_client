local BrnnGameTips = class("BrnnGameTips", function()
    return display.newLayer()
end)

function BrnnGameTips:ctor()
    self:onTouch(function(event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            self:dismiss()
        end
    end)
    self:setSwallowsTouches(true)

    self._uiLayer = requireForGameLuaFile("GuiZeCCS"):create().root:addTo(self)

    self._gameBG = tolua.cast(CustomHelper.seekNodeByName(self._uiLayer, "guiZheJieMianImg"), "ccui.ImageView")
    self._gameBG:setTouchEnabled(true)

    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self._uiLayer, "closeBtn"), "ccui.Button")
    closeBtn:addClickEventListener(handler(self,self.dismiss))


    self._bgPosX = self._gameBG:getPositionX()
    self._bgPosY = self._gameBG:getPositionY()

    self._gameBG:setPositionY(display.height + display.cy)
    self:show()
end

local guizeshuom =
{
    [1] = CustomHelper.getFullPath("game_res/big.png"),
    [2] = CustomHelper.getFullPath("game_res/small.png"),
}
function BrnnGameTips:setguizeTexture(secondgameid)
    local node1 = self._uiLayer:getChildByName("Panel_1"):getChildByName("guiZheJieMianImg"):getChildByName("ScrollView_1"):getChildByName("Image_1")

    node1:loadTexture(guizeshuom[secondgameid])
end

function BrnnGameTips:dismiss(data)
    self._gameBG:stopAllActions()
    self._gameBG:runAction(transition.sequence({
        cc.MoveBy:create(0.1, cc.p(0, display.height)),
        cc.CallFunc:create(function()
            self:removeSelf()
        end)
    }))
end

function BrnnGameTips:show(playerLabel, bankerLabel, shuishouLabel, numZ, numD, numN, numX, numB)
    self._gameBG:runAction(transition.sequence({
        cc.MoveTo:create(0.2, cc.p(self._bgPosX, self._bgPosY)),
        cc.MoveBy:create(0.05, cc.p(0, 20)),
        cc.MoveBy:create(0.04, cc.p(0, -20))
    }))
end

return BrnnGameTips