local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local ContactAgentLayer = class("ContactAgentLayer",CustomBaseView)
local PayHelper = requireForGameLuaFile("PayHelper")


function ContactAgentLayer:ctor(agentInfo)
	self.agentInfo = agentInfo
    local CCSLuaNode =  requireForGameLuaFile("ContactAgentLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Widget");
  
	local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"close_btn"),"ccui.Button");
	closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    	self:closeView();
    end)
	
	local btn_sure = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_sure"),"ccui.Button");
	btn_sure:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    	self:closeView();
    end)
	ContactAgentLayer.super.ctor(self);
	self:initView()	
    CustomHelper.addAlertAppearAnim(self.alertView)
end

function ContactAgentLayer:initView()
	local qq_text = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "qq_text"), "ccui.Text");
	qq_text:setString(""..self.agentInfo.qq)
	local btn_qq = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_qq_lianxi"), "ccui.Button");
	btn_qq:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		if PayHelper.copyStrToShearPlate(self,self.agentInfo.qq) then
			MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "QQ已复制到剪贴板")
		end
		PayHelper.callQQChat(self.agentInfo.qq)
	end);
	
	
	local wx_text = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "wx_text"), "ccui.Text");
	wx_text:setString(""..self.agentInfo.weixin)
	local btn_wx_copy = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_wx_copy"), "ccui.Button");
	btn_wx_copy:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		if PayHelper.copyStrToShearPlate(self,self.agentInfo.weixin) then
			MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "微信账号已复制到剪贴板")
		end
	end);
	
	local zfb_text = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "zfb_text"), "ccui.Text");
	zfb_text:setString(""..self.agentInfo.zfb)
	local btn_zfb_copy = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_zfb_copy"), "ccui.Button");
	btn_zfb_copy:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		if PayHelper.copyStrToShearPlate(self,self.agentInfo.zfb) then 
			MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "支付宝账号已复制到剪贴板")
		end
	end);
	
	local phone_text = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "phone_text"), "ccui.Text");
	phone_text:setString(""..self.agentInfo.phone)
	local btn_phone_copy = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_phone_copy"), "ccui.Button");
	btn_phone_copy:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		if PayHelper.copyStrToShearPlate(self,self.agentInfo.phone) then
			MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "号码已复制到剪贴板")
		end
	end);
	
end


function ContactAgentLayer:closeView()
	CustomHelper.addCloseAnimForAlertView(
		self.alertView,
		function()
			self:removeSelf();
	end)
end
return ContactAgentLayer;