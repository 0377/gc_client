
DzpkGameTips = class("DzpkGameTips", function()
    return display.newLayer()
end)


local instanse = nil
local btns = {
	[1] = {	btnName = "Button_1",wordName = "Image_info1",clickFun = function()
				instanse:setShowIndex(1)
			end},
	[2] = {btnName = "Button_2",wordName = "Image_info2",clickFun = function()
			instanse:setShowIndex(2)
		end}
}

function DzpkGameTips:ctor()

    local csNodePath = CustomHelper.getFullPath("dzpk_paixing.csb")
    self._uiLayer = cc.CSLoader:createNode(csNodePath)
    self:addChild(self._uiLayer)

	instanse = self
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
	
	self:initShowIndex()
	self:setShowIndex(1)
	
    --self._uiLayer:setTouchEnabled(true)
    --self._uiLayer:addTouchEventListener(closeCallBack)

    self._bgPosX = self._uiLayer:getPositionX()
    self._bgPosY = self._uiLayer:getPositionY()

    self._uiLayer:setPositionY(720)
    self:show()
	
end


function DzpkGameTips:initShowIndex()
	for k,v in ipairs(btns) do
		local btn1 = self._uiLayer:getChildByName("Panel_bg"):getChildByName(v.btnName)
		if btn1 ~= nil then
			btn1:addTouchEventListener(function (sender, eventType)
				if eventType == ccui.TouchEventType.ended then
					v.clickFun()
				end
			end)
		end
	end
end

function DzpkGameTips:setShowIndex(index)
	self.showIndex = index
	
	
	for k,v in ipairs(btns) do
		local btn1 = self._uiLayer:getChildByName("Panel_bg"):getChildByName(v.btnName)
		if btn1 ~= nil then
			if k == self.showIndex then
				btn1:setEnabled(false)
			else
				btn1:setEnabled(true)
			end
		end
		
		local words1 = self._uiLayer:getChildByName("Panel_bg"):getChildByName(v.wordName)
		if words1 ~= nil then
			if k == self.showIndex then
				words1:setVisible(true)
			else
				words1:setVisible(false)
			end
		end
	end

end

function DzpkGameTips:dismiss(data)
    self._uiLayer:stopAllActions()
    self._uiLayer:runAction(cc.Sequence:create(cc.MoveBy:create(0.3,{['x']=0, ['y']=720}), cc.CallFunc:create(function()
        self:removeFromParent()
    end)))
end

function DzpkGameTips:show(playerLabel,bankerLabel,shuishouLabel,numZ,numD,numN,numX,numB)
    self._uiLayer:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, {['x']=self._bgPosX, ['y']=self._bgPosY}),
        cc.MoveBy:create(0.05, {['x']=0, ['y']=20}), cc.MoveBy:create(0.04, {['x']=0, ['y']=-20})))
end


return DzpkGameTips