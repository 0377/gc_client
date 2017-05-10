local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local RechargeWxLayer = class("RechargeWxLayer", CustomBaseView)
local StoreConfig = requireForGameLuaFile("StoreConfig")
function RechargeWxLayer:ctor()
	self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("RechargeWxLayerCCS.csb"));
    self:addChild(self.csNode);
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	self.moneyText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "money_text"), "ccui.Text");
	self.bankText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bank_text"), "ccui.Text");
	self:initInputCommponent()
	self:showMoneyInfoView();
	
    self.qrczBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_qrcz"), "ccui.Button");
	self.qrczBtn:addClickEventListener(function()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		 self:recharge()
	end);
	
	-- 清零
	local setZeroBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Set_Zero"), "ccui.Button")
	setZeroBtn:addClickEventListener(function ()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:_setZero()
	end)

	self:_initCoinBtns()

	RechargeWxLayer.super.ctor(self);
end

function RechargeWxLayer:initInputCommponent()
	local inputBgView = CustomHelper.seekNodeByName(self.csNode, "will_recharge_value_input_bg")
	local editBoxBgFileName = "baobo_popupview_changtiao"
	local editBoxSize = inputBgView:getContentSize();
  
	self.rechargeValueTF = ccui.EditBox:create(editBoxSize,editBoxBgFileName)
    self.rechargeValueTF:setPosition(cc.p(inputBgView:getPositionX(),inputBgView:getPositionY()))
    self.rechargeValueTF:setAnchorPoint(inputBgView:getAnchorPoint())
    self.rechargeValueTF:setFontName("Helvetica-Bold")
    self.rechargeValueTF:setFontSize(36)
    self.rechargeValueTF:setFontColor(cc.c3b(255,255,255))
    self.rechargeValueTF:setPlaceHolder("请输入充值金额")
    self.rechargeValueTF:setPlaceholderFontColor(cc.c3b(114, 130, 138))
    self.rechargeValueTF:setPlaceholderFontSize(36)
    self.rechargeValueTF:setMaxLength(16)
    self.rechargeValueTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    self.rechargeValueTF:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC);
    self.rechargeValueTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    inputBgView:getParent():addChild(self.rechargeValueTF)

end

function RechargeWxLayer:_initCoinBtns()
	local coinValues = {10, 50, 100, 500, 1000}

	for i = 1, 5 do
		local coinBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, string.format("Button_Coin_%d", i)), "ccui.Button")
		coinBtn:addClickEventListener(function ()
			GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
			self:_addCoin(coinValues[i])
		end)
	end
end

function RechargeWxLayer:recharge()

	local str = self.rechargeValueTF:getText()
	
	local value = tonumber(str)
	if not value then
		MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "充值金额只能是大于或等于10的整数。")
		return
	end

	if string.sub(str,1,1) == "0" then 
		MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "充值金额只能是大于或等于10的整数。")
		return
	end
	
	if value < 10 or math.floor(value)<value then
		MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "充值金额只能是大于或等于10的整数。")
		return
	end
	CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("rchargeTip"),self.parent,0);
	local item = { ["good_id"] = "good_id" ,["goods_desc"] = "微信充值",  ["price"] = value}
	local PayHelper = requireForGameLuaFile("PayHelper")
	PayHelper.createOrder(item,StoreConfig.PAY_TYPE.WEIXINPAY)
end


function RechargeWxLayer:showMoneyInfoView()
	local moneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getMoney())
	self.moneyText:setString(moneyStr)

	local bankMoneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getBank());
	self.bankText:setString(bankMoneyStr)

	

end


function RechargeWxLayer:registerNotification()
	---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
	RechargeWxLayer.super.registerNotification(self);
	
end

function RechargeWxLayer:receiveRefreshPlayerInfoNotify()
	self:showMoneyInfoView()
end

--收到服务器处理成功通知函数
function RechargeWxLayer:receiveServerResponseSuccessEvent(event)
	print("RechargeWxLayer:微信充值 到账 刷新金币")
    RechargeWxLayer.super.receiveServerResponseSuccessEvent(self,event)
end

function RechargeWxLayer:_setZero()
	self.rechargeValueTF:setText("")
end

function RechargeWxLayer:_addCoin(addValue)
	local value = CustomHelper.tonumber(self.rechargeValueTF:getText())
	self.rechargeValueTF:setText(tostring(value + addValue))
end

return RechargeWxLayer;