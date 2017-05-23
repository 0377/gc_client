
QznnGameTips = class("QznnGameTips", function()
    return display.newLayer()
end)



function QznnGameTips:ctor()

    local csNodePath = CustomHelper.getFullPath("help.csb")
    self._uiLayer = cc.CSLoader:createNode(csNodePath)
    self:addChild(self._uiLayer)


    --self._gameBG= tolua.cast(CustomHelper.seekNodeByName(self._uiLayer,"guiZheJieMianImg"), "ccui.ImageView")--- layer:getChildByName("guiZheJieMianImg")
    --self._gameBG:setTouchEnabled(true)
    --local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self._uiLayer, "closeBtn"), "ccui.Button")
    self._uiLayer:getChildByName("Panel_bg"):getChildByName("Button_close"):addClickEventListener(function (  )
        -- body
        self:dismiss()
    end)

    local function closeCallBack(sender, type)
        if type == ccui.TouchEventType.ended then
            
        end
    end

    --self._uiLayer:setTouchEnabled(true)
    --self._uiLayer:addTouchEventListener(closeCallBack)

    self._bgPosX = self._uiLayer:getPositionX()
    self._bgPosY = self._uiLayer:getPositionY()

    self._uiLayer:setPositionY(720)
    self:show()
end

function QznnGameTips:dismiss(data)
    self._uiLayer:stopAllActions()
    self._uiLayer:runAction(cc.Sequence:create(cc.MoveBy:create(0.3,{['x']=0, ['y']=720}), cc.CallFunc:create(function()
        self:removeFromParent()
    end)))
end

function QznnGameTips:show()
    self._uiLayer:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, {['x']=self._bgPosX, ['y']=self._bgPosY}),
        cc.MoveBy:create(0.05, {['x']=0, ['y']=20}), cc.MoveBy:create(0.04, {['x']=0, ['y']=-20})))
end


return QznnGameTips