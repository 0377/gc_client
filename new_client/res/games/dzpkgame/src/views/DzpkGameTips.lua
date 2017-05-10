
DzpkGameTips = class("DzpkGameTips", function()
    return display.newLayer()
end)

function DzpkGameTips:ctor()

    local csNodePath = CustomHelper.getFullPath("dzpk_paixing.csb")
    self._uiLayer = cc.CSLoader:createNode(csNodePath)
    self:addChild(self._uiLayer)


    --self._gameBG= tolua.cast(CustomHelper.seekNodeByName(self._uiLayer,"guiZheJieMianImg"), "ccui.ImageView")--- layer:getChildByName("guiZheJieMianImg")
    --self._gameBG:setTouchEnabled(true)
    --local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self._uiLayer, "closeBtn"), "ccui.Button")
    self._uiLayer:getChildByName("Panel_bg"):addClickEventListener(function (  )
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

    self._uiLayer:setPositionY(2000)
    self:show()
end

function DzpkGameTips:dismiss(data)
    self._uiLayer:stopAllActions()
    self._uiLayer:runAction(cc.Sequence:create(cc.MoveBy:create(0.6,{['x']=0, ['y']=2000}), cc.CallFunc:create(function()
        self:removeFromParent()
    end)))
end

function DzpkGameTips:show(playerLabel,bankerLabel,shuishouLabel,numZ,numD,numN,numX,numB)
    self._uiLayer:runAction(cc.Sequence:create(cc.MoveTo:create(0.6, {['x']=self._bgPosX, ['y']=self._bgPosY}),
        cc.MoveBy:create(0.05, {['x']=0, ['y']=20}), cc.MoveBy:create(0.04, {['x']=0, ['y']=-20})))
end


return DzpkGameTips