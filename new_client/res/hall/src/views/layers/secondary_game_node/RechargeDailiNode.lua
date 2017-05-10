local RechargeDailiNode = class("RechargeDailiNode",ccui.Layout)
function RechargeDailiNode:ctor(dataTab)
	self.infoTab = dataTab
	dump(dataTab)
	local nodeFullPath = CustomHelper.getFullPath("RechargeDailiNode.csb")
	local csNode = cc.CSLoader:createNode(nodeFullPath);
	local itemNode = tolua.cast(CustomHelper.seekNodeByName(csNode, "game_panel"), "ccui.Layout")
	itemNode:retain()
	itemNode:removeFromParent();
	self:setContentSize(itemNode:getContentSize());
	self:addChild(itemNode);
	itemNode:release()
	local name =  tolua.cast(CustomHelper.seekNodeByName(itemNode, "text_name"), "ccui.Text");
	name:setString(self.infoTab.name)
	local btn_recharge = tolua.cast(CustomHelper.seekNodeByName(itemNode, "btn_recharge"), "ccui.Button");
	btn_recharge:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		-- local ContactAgentLayer = requireForGameLuaFile("ContactAgentLayer");
		-- local layer = ContactAgentLayer:create(self.infoTab);
		-- ViewManager.setForceAlertOneView(true)
		-- ViewManager.addChildTo(layer); 
		--点击代理商 唤起QQ
		local  PayHelper = requireForGameLuaFile("PayHelper")
		if PayHelper.copyStrToShearPlate(self,self.infoTab.qq) then
			MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "QQ已复制到剪贴板")
		end
		PayHelper.callQQChat(self.infoTab.qq)
	end);
end


return RechargeDailiNode;