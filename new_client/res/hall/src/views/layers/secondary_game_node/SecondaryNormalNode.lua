
--[[
	通用 二级选择界面
]]
local SecondaryBaseNode = requireForGameLuaFile("secondary_game_node.SecondaryBaseNode")
local SecondaryNormalNode = class("SecondaryFishNode",SecondaryBaseNode)
function SecondaryNormalNode:ctor()
	-- local nodeFullPath = CustomHelper.getFullPath("SecondaryNormalNodeCCS.csb")
	-- -- print("nodeFullPath:",nodeFullPath)
	-- local csNode = cc.CSLoader:createNode(nodeFullPath);
	local CCSLuaNode =  requireForGameLuaFile("SecondaryNormalNodeCCS") 
	self.csNode = CCSLuaNode:create().root;
	self.itemNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "game_panel"), "ccui.Layout")
	self.itemNode:retain()
	self.itemNode:removeFromParent();
	self:setContentSize(self.itemNode:getContentSize());
	self:addChild(self.itemNode);
	self.itemNode:release()
	SecondaryNormalNode.super.ctor(self)
end

function SecondaryNormalNode:initViewData(secondRoomInfoTab)
	SecondaryNormalNode.super.initViewData(self,secondRoomInfoTab)
	
	local iconView = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "icon_view"), "ccui.ImageView");
	iconView:ignoreContentAdaptWithSize(true);
	iconView:loadTexture(CustomHelper.getFullPath(self.secondRoomInfoTab[HallGameConfig.SecondRoomIconKey]))
	-- if canSelected then
		-- selectBtn:setName("aaaaaaaaaaaaaaaaaaaaaaaaaa")
		-- ccui.TouchEventType =
		-- {
		--     began = 0,
		--     moved = 1,
		--     ended = 2,
		--     canceled = 3,
		-- }
		-- selectBtn:addClickEventListener(function ()
		-- 	print("click one game second node")
		-- 	clickCallback(selectBtn);
		-- end)
	-- end
	--显示底注 和 入场
	local  minMoneyLimitText = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "min_money_limit"), "ccui.Text");
	-- 20.34 string 为 20/34	
	local minMoneyLimitString = CustomHelper.moneyShowStyleAB(self.secondRoomInfoTab[HallGameConfig.SecondRoomMinMoneyLimitKey])
	-- minMoneyLimitString = string.gsub(minMoneyLimitString, "%.", "/")
	minMoneyLimitText:setString(minMoneyLimitString.."入局")
	--底注
	local minJettonLimitText = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "min_jetton_limit"), "ccui.TextAtlas");
	local minJettonLimitString = CustomHelper.moneyShowStyleNone(self.secondRoomInfoTab[HallGameConfig.SecondRoomMinJettonLimitKey])
	minJettonLimitString = string.gsub(minJettonLimitString, "%.", "/")
	-- print("minJettonLimitString---",minJettonLimitString)
	minJettonLimitText:setString(minJettonLimitString)
	local onlineNumText = tolua.cast(CustomHelper.seekNodeByName(self.itemNode, "online_num_text"), "ccui.Text");
	onlineNumText:setString(string.format("在线:%d",math.random(300,1000)))
end
return SecondaryNormalNode;
