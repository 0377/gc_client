--[[
	大厅 二级选择界面
	斗地主节点
]]
local SecondaryDZPKNode = class("SecondaryDZPKNode",requireForGameLuaFile("secondary_game_node.SecondaryBaseNode"))
function SecondaryDZPKNode:ctor()
	-- local nodeFullPath = CustomHelper.getFullPath("SecondaryBRNNNodeCCS.csb")
	-- -- print("nodeFullPath:",nodeFullPath)
	-- local csNode = cc.CSLoader:createNode(nodeFullPath);
	local CCSLuaNode =  requireForGameLuaFile("SecondaryDZPKNodeCCS")
	self.csNode = CCSLuaNode:create().root;
	self.itemNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "game_panel"), "ccui.Layout")
	self.itemNode:retain()
	self.itemNode:removeFromParent();
	self:setContentSize(self.itemNode:getContentSize());
	self:addChild(self.itemNode);
	self.itemNode:release()
	SecondaryDZPKNode.super.ctor()
end

function SecondaryDZPKNode:initViewData(secondRoomInfoTab)
	SecondaryDZPKNode.super.initViewData(self,secondRoomInfoTab)
	local iconView = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "icon_view"), "ccui.ImageView");
	iconView:ignoreContentAdaptWithSize(true);
	iconView:loadTexture(CustomHelper.getFullPath(self.secondRoomInfoTab[HallGameConfig.SecondRoomIconKey]))
	
	--显示底注 和 入场
	local  minMoneyLimitText = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "min_money_limit"), "ccui.Text");
	-- 20.34 string 为 20/34	
	local minMoneyLimitString = CustomHelper.moneyShowStyleAB(self.secondRoomInfoTab[HallGameConfig.SecondRoomMinMoneyLimitKey])
	-- minMoneyLimitString = string.gsub(minMoneyLimitString, "%.", "/")
	minMoneyLimitText:setString(minMoneyLimitString.."入局")
	--底注
	local minJettonLimitText = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "min_jetton_limit"), "ccui.TextAtlas");
	local minJettonLimitString = CustomHelper.moneyShowStyleNone(self.secondRoomInfoTab[HallGameConfig.SecondRoomMinJettonLimitKey])
	--minJettonLimitString = string.gsub(minJettonLimitString, "%.", "/")
	-- print("minJettonLimitString---",minJettonLimitString)
	minJettonLimitText:setString(minJettonLimitString)

	local onlineNumText = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "online_num_text"), "ccui.Text");
	onlineNumText:setString(string.format("在线:%d",math.random(300,1000)))
end

return SecondaryDZPKNode;
