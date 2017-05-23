
BrnnGameTips = class("BrnnGameTips", function()
    return display.newLayer()
end)

function BrnnGameTips:ctor()
    local CCSLuaNode =  requireForGameLuaFile("GuiZeCCS")
    self._uiLayer = CCSLuaNode:create().root; 

    self:addChild(self._uiLayer)


    self._gameBG= tolua.cast(CustomHelper.seekNodeByName(self._uiLayer,"guiZheJieMianImg"), "ccui.ImageView")--- layer:getChildByName("guiZheJieMianImg")
    --self._gameBG:setTouchEnabled(true)
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self._uiLayer, "closeBtn"), "ccui.Button")
    closeBtn:addClickEventListener(function (  )
        -- body
        self:dismiss()
    end)

    local function closeCallBack(sender, type)
        if type == ccui.TouchEventType.ended then
            
        end
    end
	
	--
	--self.brnnGameManager.gameDetailInfoTab["second_game_type"]

    --self._uiLayer:setTouchEnabled(true)
     --self._uiLayer:addTouchEventListener(closeCallBack)

    self._bgPosX = self._gameBG:getPositionX()
    self._bgPosY = self._gameBG:getPositionY()

    self._gameBG:setPositionY(2000)
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
    self._gameBG:runAction(cc.Sequence:create(cc.MoveBy:create(0.6,{['x']=0, ['y']=2000}), cc.CallFunc:create(function()
        self:removeFromParent()
    end)))
end

function BrnnGameTips:show(playerLabel,bankerLabel,shuishouLabel,numZ,numD,numN,numX,numB)
    self._gameBG:runAction(cc.Sequence:create(cc.MoveTo:create(0.6, {['x']=self._bgPosX, ['y']=self._bgPosY}),
        cc.MoveBy:create(0.05, {['x']=0, ['y']=20}), cc.MoveBy:create(0.04, {['x']=0, ['y']=-20})))
end


return BrnnGameTips