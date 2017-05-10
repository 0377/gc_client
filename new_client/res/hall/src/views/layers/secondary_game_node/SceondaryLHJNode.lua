--[[
	大厅 二级选择界面
	诈金花节点
]]
local SceondaryLHJNode = class("SceondaryLHJNode",requireForGameLuaFile("secondary_game_node.SecondaryBaseNode"))
function SceondaryLHJNode:ctor()
	
	local nodeFullPath = CustomHelper.getFullPath("SecondaryLHJNodeCCS.csb")
	--print("nodeFullPath:",nodeFullPath)
	local csNode = cc.CSLoader:createNode(nodeFullPath);
	self.itemNode = tolua.cast(CustomHelper.seekNodeByName(csNode, "game_panel"), "ccui.Layout")
	self.itemNode:retain()
	self.itemNode:removeFromParent();
	self:setContentSize(self.itemNode:getContentSize());
	self:addChild(self.itemNode);
	self.itemNode:release()
	SceondaryLHJNode.super.ctor()

end
function SceondaryLHJNode:initViewData(secondRoomInfoTab,clickCallback,canSelected)	
	if not SceondaryLHJNode.super.initViewData(self,secondRoomInfoTab,clickCallback,canSelected) then
		return false
	end
	
	local iconView = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "icon_view"), "ccui.ImageView");
	iconView:ignoreContentAdaptWithSize(true);
	iconView:loadTexture(CustomHelper.getFullPath(self.secondRoomInfoTab[HallGameConfig.SecondRoomIconKey]))
	local selectBtn = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "selected_btn"), "ccui.Button");
	selectBtn:setSwallowTouches(false)
	if canSelected then
		selectBtn:addClickEventListener(handler(self,self.selectNode))
	end
	local roomEffectInfoStr = self.secondRoomInfoTab[HallGameConfig.SecondRoomIconEffectKey]
	local roomEffectArray = string.split(roomEffectInfoStr, "#");
	if #roomEffectArray >= 2 then
		--todo
		--添加骨骼动画
    	local armature = ccs.Armature:create(roomEffectArray[1])
    	armature:getAnimation():play(roomEffectArray[2])
    	self.itemNode:addChild(armature)
   		armature:align(display.CENTER, armature:getParent():getContentSize().width/2 - 3, armature:getParent():getContentSize().height/2 + 15)
	end
	--显示底注 和 入场
	local  minMoneyLimitText = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "min_money_limit"), "ccui.TextAtlas");
	-- 20.34 string 为 20/34	
	local minMoneyLimitString = CustomHelper.moneyShowStyleNone(self.secondRoomInfoTab[HallGameConfig.SecondRoomMinMoneyLimitKey])
	minMoneyLimitString = string.gsub(minMoneyLimitString, "%.", "/")
	minMoneyLimitText:setString(minMoneyLimitString)
	--底注
	local minJettonLimitText = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "min_jetton_limit"), "ccui.TextAtlas");
	local minJettonLimitString = CustomHelper.moneyShowStyleNone(self.secondRoomInfoTab[HallGameConfig.SecondRoomMinJettonLimitKey])
	minJettonLimitString = string.gsub(minJettonLimitString, "%.", "/")
	--print("minJettonLimitString---",minJettonLimitString)
	minJettonLimitText:setString(minJettonLimitString)
end

return SceondaryLHJNode;
