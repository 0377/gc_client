local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local PrivacyPolicyLayer = class("PrivacyPolicyLayer",CustomBaseView)
function PrivacyPolicyLayer:ctor()
    self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("PrivacyPolicyLayerCCS.csb"));
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget");
  
	local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"agree_btn"),"ccui.Button");
	closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    	self:closeView();
    end)

    PrivacyPolicyLayer.super.ctor(self)
    CustomHelper.addAlertAppearAnim(self.alertView)
end

function PrivacyPolicyLayer:closeView()
    GameManager:getInstance():getHallManager():getHallDataManager():savaShowPrivacy(true)
	CustomHelper.addCloseAnimForAlertView(
		self.alertView,
		function()
			self:removeSelf();
	end)
end
return PrivacyPolicyLayer;