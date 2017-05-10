local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local InviterInfoLayer = class("InviterInfoLayer",CustomBaseView)


function InviterInfoLayer:ctor(inviterInfo,finishedCallback)
	self.inviterInfo = inviterInfo
	self.finishedCallback = finishedCallback;
    self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("InviterInfoLayer.csb"));
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Widget");
  
	local btn_sure = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_sure"),"ccui.Button");
	btn_sure:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
		self.finishedCallback()
		self:clickSure();
    end)
	
	local btn_cancal = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_cancal"),"ccui.Button");
	btn_cancal:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    	self:closeView();
    end)
	
	InviterInfoLayer.super.ctor(self);
	self:initView()	
    CustomHelper.addAlertAppearAnim(self.alertView)
end

function InviterInfoLayer:initView()
	local inviter_name = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "inviter_name"), "ccui.Text");
	local inviter_id = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "inviter_id"), "ccui.Text");
	local inviter_phone = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "inviter_phone"), "ccui.Text");
	local inviter_qq = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "inviter_qq"), "ccui.Text");
	local inviter_zfb = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "inviter_zfb"), "ccui.Text");
	
	inviter_name:setString("邀请人名称："..self.inviterInfo.alipay_name)
	inviter_id:setString("邀请人ID："..self.inviterInfo.guid)
	inviter_phone:setString("电话："..self.inviterInfo.account)
	--inviter_qq:setString("QQ："..self.inviterInfo.qq)
	inviter_zfb:setString("支付宝："..self.inviterInfo.alipay_account)
end




function InviterInfoLayer:closeView()
	CustomHelper.addCloseAnimForAlertView(
		self.alertView,
		function()
			self:removeSelf();
	end)
end
return InviterInfoLayer