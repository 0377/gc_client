local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local AlipayBindInfoLayer = class("AlipayBindInfoLayer", CustomBaseView)
function AlipayBindInfoLayer:ctor()
    self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("AlipayBindInfoLayerCCS.csb"));
    self:addChild(self.csNode);
    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget");
    CustomHelper.addAlertAppearAnim(alertPanel);
    self:showView();
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "close_btn"), "ccui.Button");
    closeBtn:addClickEventListener(function()
    	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:removeSelf()
    end);
    local confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "confirm_btn"), "ccui.Button");
    confirmBtn:addClickEventListener(function()
    	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:removeSelf()
    end);
	AlipayBindInfoLayer.super.ctor(self)
end



function AlipayBindInfoLayer:showView()
	local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
	local phoneNumText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "phone_num_text"), "ccui.Text");
	if self.bindPhoneNumBtn == nil then
		--todo
	    self.bindPhoneNumBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bind_phone_num_btn"), "ccui.Button");
		self.bindPhoneNumBtn:addClickEventListener(function()
			GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
			ViewManager.alertAccountBindLayer();
		end);
	end
	self.bindPhoneNumBtn:setVisible(false)
	if myPlayerInfo:getIsGuest() == true then --
		--todo
		phoneNumText:setString("未绑定手机号");
		phoneNumText:setColor(cc.c3b(0xFF, 0xEB, 0xBC))
		self.bindPhoneNumBtn:setVisible(true);
	else
		phoneNumText:setString(myPlayerInfo:getAccount())
		phoneNumText:setColor(cc.c3b(0xFF, 0xFF, 0xFF))
	end
	--判断是否绑定了支付宝
	if self.alipayAccountText == nil then
		--todo
		self.alipayAccountText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alipay_account_text"), "ccui.Text");
	end
	if self.bindAlipayBtn == nil then
		--todo
		self.bindAlipayBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bind_alipay_btn"), "ccui.Button");
		self.bindAlipayBtn:addClickEventListener(function()
			GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
			self:clickBindAlipayBtn();
		end);
	end
	self.bindAlipayBtn:setVisible(false);
	if myPlayerInfo:getIsBindAlipay() == true then
		--todo
		self.alipayAccountText:setString(myPlayerInfo:getAlipayAccount());
		self.alipayAccountText:setColor(cc.c3b(0xFF, 0xFF, 0xFF))
	else
		self.bindAlipayBtn:setVisible(true);
	    self.alipayAccountText:setColor(cc.c3b(0xFF, 0xEB, 0xBC))
	    self.alipayAccountText:setString("未绑定支付宝")
	end
end
function AlipayBindInfoLayer:clickBindAlipayBtn()
	ViewManager.alertAlipayBindLayer();
end
return AlipayBindInfoLayer;