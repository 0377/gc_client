
-- JdnnGameTalk = class("JdnnGameTalk", function()
--     return display.newLayer()
-- end)

-- local messages = {
-- 	[1] = "在等什么，快下注吧",
-- 	[2] = "各位爷，让看看牌再加钱吧",
-- 	[3] = "莫偷鸡！偷鸡必抓鸡",
-- 	[4] = "冲动是魔鬼，冷静",
-- 	[5] = "很高兴和大家一起打牌",
-- 	[6] = "赢钱了别走，再来再来",
-- 	[7] = "这牌打得不错啊",
-- 	[8] = "我加注了，有胆就跟吧",
-- 	[9] = "人生如戏，全靠演技"
-- }


-- function JdnnGameTalk:ctor(talkSendFunc)

--     local csNodePath = CustomHelper.getFullPath("jdnn_quicktalk.csb")
--     self._uiLayer = cc.CSLoader:createNode(csNodePath)
--     self:addChild(self._uiLayer)


--     --self._gameBG= tolua.cast(CustomHelper.seekNodeByName(self._uiLayer,"guiZheJieMianImg"), "ccui.ImageView")--- layer:getChildByName("guiZheJieMianImg")
--     --self._gameBG:setTouchEnabled(true)
--     --local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self._uiLayer, "closeBtn"), "ccui.Button")
--     --self._uiLayer:addClickEventListener(function (  )
--     --    -- body
--     --    self:dismiss()
--     --end)

--     local function closeCallBack(sender, type)
--         if type == ccui.TouchEventType.ended then
            
--         end
--     end

--     --self._uiLayer:setTouchEnabled(true)
--      --self._uiLayer:addTouchEventListener(closeCallBack)

--     self._bgPosX = self._uiLayer:getPositionX()
--     self._bgPosY = self._uiLayer:getPositionY()

--     self._uiLayer:setPositionY(2000)
--     self:show()
	
-- 	--
-- 	--
-- 	self._uiLayer:getChildByName("Image_4"):getChildByName("Button_close"):addClickEventListener(function (sender, eventType)
-- 		if eventType == ccui.TouchEventType.ended then
-- 			self:dismiss()
-- 		end
--     end)
	
-- 	--
-- 	local list = self._uiLayer:getChildByName("Image_4"):getChildByName("ListView_1")
-- 	list:removeAllItems()
-- 	for k,v in ipairs(messages) do
-- 		local node1 = self._uiLayer:getChildByName("Image_4"):getChildByName("Panel_words"):clone()
-- 		list:pushBackCustomItem(node1)
		
-- 		node1:getChildByName("Text_1"):setString(v)
-- 		node1:getChildByName("Button_2"):addClickEventListener(function (sender, eventType)
-- 			if eventType == ccui.TouchEventType.ended then
				
-- 				if talkSendFunc ~= nil then
-- 					talkSendFunc{k,v}
-- 				end
				
-- 				self:dismiss()
-- 			end
-- 		end)
-- 	end
	
-- end

-- function JdnnGameTalk:dismiss(data)
--     self._uiLayer:stopAllActions()
--     self._uiLayer:runAction(cc.Sequence:create(cc.MoveBy:create(0.6,{['x']=0, ['y']=2000}), cc.CallFunc:create(function()
--         self:removeFromParent()
--     end)))
-- end

-- function JdnnGameTalk:show(playerLabel,bankerLabel,shuishouLabel,numZ,numD,numN,numX,numB)
--     self._uiLayer:runAction(cc.Sequence:create(cc.MoveTo:create(0.6, {['x']=self._bgPosX, ['y']=self._bgPosY}),
--         cc.MoveBy:create(0.05, {['x']=0, ['y']=20}), cc.MoveBy:create(0.04, {['x']=0, ['y']=-20})))
-- end


-- return JdnnGameTalk