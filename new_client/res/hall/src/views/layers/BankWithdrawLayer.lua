local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local BankWithdrawLayer = class("BankWithdrawLayer", CustomBaseView)
function BankWithdrawLayer:ctor()
    local CCSLuaNode =  requireForGameLuaFile("BankWithdrawLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	self.moneyText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "money_text"), "ccui.TextAtlas");
	self.bankText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bank_text"), "ccui.TextAtlas");
	self.changeValueText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "change_value_text"), "ccui.Text");
	self.changeValueText:setVisible(false)

	local editBoxBgFileName = "nil.png"
    local withdrawNumEditBoxBogNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_13"), "ccui.ImageView");
    self.withdrawNumTF = ccui.EditBox:create(withdrawNumEditBoxBogNode:getContentSize(),editBoxBgFileName)
    self.withdrawNumTF:setPosition(cc.p(withdrawNumEditBoxBogNode:getPositionX()+5,withdrawNumEditBoxBogNode:getPositionY()))
    self.withdrawNumTF:setAnchorPoint(withdrawNumEditBoxBogNode:getAnchorPoint())
    self.withdrawNumTF:setFontName("Helvetica-Bold")
    self.withdrawNumTF:setFontSize(30)
    self.withdrawNumTF:setFontColor(cc.c3b(255,255,255))
    self.withdrawNumTF:setPlaceHolder("请输入取出金额")
    self.withdrawNumTF:setPlaceholderFontColor(cc.c3b(133,125,126))
    self.withdrawNumTF:setPlaceholderFontSize(30)
    self.withdrawNumTF:setMaxLength(16)
    self.withdrawNumTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    self.withdrawNumTF:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.withdrawNumTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    withdrawNumEditBoxBogNode:getParent():addChild(self.withdrawNumTF)
    	
    self.withdrawNumTF:registerScriptEditBoxHandler(function(eventType)
		if eventType == "changed" then

		elseif eventType == "ended" then
		
		elseif eventType == "return" then
		--todo
			local valueStr = self.withdrawNumTF:getText();
			local value = CustomHelper.tonumber(valueStr)
			local addValue = value
			local realAddValue = addValue * CustomHelper.goldToMoneyRate()
			if self.tempBank >=  realAddValue then
				self.changeValue = realAddValue
			else 
				self.changeValue = self.tempBank
				--MyToastLayer.new(cc.Director:getInstance():getRunningScene(),"银行存款不足")
			end
			self:showMoneyInfoView()
			self:checkBankGold()
		end
	end)
	self:resetTempMondAndBank();
    self:initView();
	BankWithdrawLayer.super.ctor(self);

end

function BankWithdrawLayer:initView()
	--
	local addNumArray = {10000,100000,500000,1000000}
	for i=1,4 do
		local tempAddBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,string.format("add_btn_%d",i)), "ccui.Button")
		tempAddBtn:setTitleText("+" .. CustomHelper.moneyShowStyleAB(addNumArray[i] * CustomHelper.goldToMoneyRate()))
		tempAddBtn.addValue = addNumArray[i]
		tempAddBtn:addClickEventListener(function()
			GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
			self:clickOneAddbtn(tempAddBtn)
			self:checkBankGold()
		end);
	end
	local resetBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "reset_btn"), "ccui.Button");
	resetBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:resetTempMondAndBank();
		self:showMoneyInfoView()
		self:checkBankGold()
	end);
	self.withDrawBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "withdraw_btn"), "ccui.Button");
	self.withDrawBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:sendWithdrawMoneyMsg()
	end);
	
	self:checkBankGold()
end



function BankWithdrawLayer:checkBankGold()
	-- body
	local valueStr = self.withdrawNumTF:getText();
	local money = CustomHelper.tonumber(valueStr);
	for i=1,4 do
		local tempAddBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,string.format("add_btn_%d",i)), "ccui.Button")
		local m1 = (self.myPlayerInfo:getBank()/CustomHelper.goldToMoneyRate()-money) - tempAddBtn.addValue
		--print("m1:"..m1.."money:"..money.."array:",addNumArray[i].."rate:"..CustomHelper.goldToMoneyRate())
		if m1 >= 0 then
			tempAddBtn:setEnabled(true)
		else
			tempAddBtn:setEnabled(false)
		end
	end

end
function BankWithdrawLayer:showMoneyInfoView()
	-- local moneyStr = CustomHelper.moneyShowStyleNone(self.tempMoney)
	-- moneyStr = string.gsub(moneyStr, "%.", "/")
	-- self.moneyText:setString(moneyStr)

	-- local bankMoneyStr = CustomHelper.moneyShowStyleNone(self.tempBank);
	-- bankMoneyStr = string.gsub(bankMoneyStr, "%.", "/")
	-- self.bankText:setString(bankMoneyStr)

	--self.changeValueText:setString(CustomHelper.moneyShowStyleNone(self.changeValue))
	self.withdrawNumTF:setText(self.changeValue/CustomHelper.goldToMoneyRate())
end

function BankWithdrawLayer:resetTempMondAndBank()
	self.tempMoney = self.myPlayerInfo:getMoney();
	self.tempBank = self.myPlayerInfo:getBank()
	self.changeValue = 0;
end
function BankWithdrawLayer:clickOneAddbtn(btn)
	local addValue = btn.addValue;
	print("addValue",addValue)
	local realAddValue = addValue * CustomHelper.goldToMoneyRate()
	if self.tempBank >= self.changeValue + realAddValue then
		--todo
		self.changeValue = self.changeValue + realAddValue
	else
		self.changeValue = self.tempBank
		MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "银行存款不足")
	end
	self:showMoneyInfoView()
end
--发送存钱消息
function BankWithdrawLayer:sendWithdrawMoneyMsg()
	if self.changeValue <= 0 then
		--todo
		return MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "请输入需要取出的金额")
	end
	if self.changeValue > self.tempBank then
		--todo
		return MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "取出金额超出银行金额,无法取出")
	end
			
	self.withDrawBtn:setEnabled(false)
	local info = {};
	info.money = self.changeValue;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CS_BankDraw,info)
end
function BankWithdrawLayer:registerNotification()
	---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
	self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_BankDraw);
	self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_BankDraw);
	BankWithdrawLayer.super.registerNotification(self);
end
--消息发送失败
function BankWithdrawLayer:receiveMsgRequestErrorEvent(event)
    self.withDrawBtn:setEnabled(true)
    BankWithdrawLayer.super.receiveMsgRequestErrorEvent(self,event)
end
--收到服务器返回的失败的通知，如登录失败，密码错误
function BankWithdrawLayer:receiveServerResponseErrorEvent(event)
    --print("CustomBaseView:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local ret = userInfo["ret"] or userInfo["result"];
    if msgName == HallMsgManager.MsgName.SC_BankDraw then
        --todo
		self.withDrawBtn:setEnabled(true)
    end
    BankWithdrawLayer.super.receiveServerResponseErrorEvent(self,event)
end
--收到服务器处理成功通知函数
function BankWithdrawLayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_BankDraw then
    	--todo
		self.withDrawBtn:setEnabled(true)
		self:resetTempMondAndBank();
		local resultStr = CustomHelper.moneyShowStyleNone(userInfo.money)
		MyToastLayer.new(cc.Director:getInstance():getRunningScene(), string.format("成功取出"..resultStr))
		self:checkBankGold()
		self:showMoneyInfoView()
    end
    BankWithdrawLayer.super.receiveServerResponseSuccessEvent(self,event)
end


return BankWithdrawLayer;