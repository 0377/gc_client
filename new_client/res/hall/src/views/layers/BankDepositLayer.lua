local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local BankDepositLayer = class("BankDepositLayer", CustomBaseView)
function BankDepositLayer:ctor()
	self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("BankDepositLayerCCS.csb"));
    self:addChild(self.csNode);
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	self.moneyText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "money_text"), "ccui.TextAtlas");
	self.bankText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bank_text"), "ccui.TextAtlas");
	self.willDepositValueText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "will_deposit_value_text"), "ccui.Text");


	local editBoxBgFileName = "nil.png"
    local depositNumEditBoxBogNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_13"), "ccui.ImageView");
    self.depositNumTF = ccui.EditBox:create(depositNumEditBoxBogNode:getContentSize(),editBoxBgFileName)
    self.depositNumTF:setPosition(cc.p(depositNumEditBoxBogNode:getPositionX()+5,depositNumEditBoxBogNode:getPositionY()))
    self.depositNumTF:setAnchorPoint(depositNumEditBoxBogNode:getAnchorPoint())
    self.depositNumTF:setFontName("Helvetica-Bold")
    self.depositNumTF:setFontSize(30)
    self.depositNumTF:setFontColor(cc.c3b(255,255,255))
    self.depositNumTF:setPlaceHolder("请输入存入金额")
    self.depositNumTF:setPlaceholderFontColor(cc.c3b(103,95,96))
    self.depositNumTF:setPlaceholderFontSize(30)
    self.depositNumTF:setMaxLength(16)
    self.depositNumTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    self.depositNumTF:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.depositNumTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    depositNumEditBoxBogNode:getParent():addChild(self.depositNumTF)
    	
    self.depositNumTF:registerScriptEditBoxHandler(function(eventType)

		if eventType == "changed" then
	
		elseif eventType == "ended" then
			-- MyToastLayer.new(cc.Director:getInstance():getRunningScene(),"金币余额不足，无法添加")
		elseif eventType == "return" then
			local valueStr = self.depositNumTF:getText();
			print("valueStr:",valueStr)
			local value = CustomHelper.tonumber(valueStr)
			local addValue = value
			local realAddValue = addValue * CustomHelper.goldToMoneyRate()

			if self.tempMoney >= realAddValue then
				--todo
				self.willDepositValue = realAddValue

			else
				self.willDepositValue = self.tempMoney	
				--MyToastLayer.new(cc.Director:getInstance():getRunningScene(),"金币余额不足，无法添加")
			end
			self:showMoneyInfoView();


			self:checkBankGold()
		end
	end)

	self:resetTempMondAndBank();
	local moneyStr = CustomHelper.moneyShowStyleNone(self.tempMoney - self.willDepositValue)
	moneyStr = string.gsub(moneyStr, "%.", "/")
	self.moneyText:setString(moneyStr)
	local bankMoneyStr = CustomHelper.moneyShowStyleNone(self.tempBank);
	bankMoneyStr = string.gsub(bankMoneyStr, "%.", "/")
	self.bankText:setString(bankMoneyStr)

    self:initView();
	BankDepositLayer.super.ctor(self);
end
function BankDepositLayer:initView()
	--
	local addNumArray = {10,100,1000,10000}
	for i=1,4 do
		local tempAddBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,string.format("add_btn_%d",i)), "ccui.Button")
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
		self:showMoneyInfoView();

		self:checkBankGold()
	end);
	self.depositBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "deposit_btn"), "ccui.Button");
	self.depositBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:sendDepositMoneyMsg()
	end);
	self:checkBankGold()
end


function BankDepositLayer:checkBankGold()
	-- body

	local addNumArray = {10,100,1000,10000}
	for i=1,4 do
		local tempAddBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,string.format("add_btn_%d",i)), "ccui.Button")

		local valueStr = self.depositNumTF:getText();
		local money = CustomHelper.tonumber(valueStr);

		local t1 = CustomHelper.goldToMoneyRate()

		local m1 = (self.myPlayerInfo:getMoney()/CustomHelper.goldToMoneyRate()-money) - addNumArray[i]
		--print("m1:"..m1.."money:"..money.."array:",addNumArray[i].."rate:"..CustomHelper.goldToMoneyRate())
		if m1 >= 0 then
				tempAddBtn:setEnabled(true)
		else
				tempAddBtn:setEnabled(false)
		end
	end

end






function BankDepositLayer:resetTempMondAndBank()
	self.tempMoney = self.myPlayerInfo:getMoney();
	self.tempBank = self.myPlayerInfo:getBank()
	self.willDepositValue = 0;
end
function BankDepositLayer:showMoneyInfoView()
	local moneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getMoney());--CustomHelper.moneyShowStyleNone(self.tempMoney - self.willDepositValue)
	moneyStr = string.gsub(moneyStr, "%.", "/")
	self.moneyText:setString(moneyStr)


	local bankMoneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getBank());
	bankMoneyStr = string.gsub(bankMoneyStr, "%.", "/")
	self.bankText:setString(bankMoneyStr)

	self.depositNumTF:setText(self.willDepositValue/CustomHelper.goldToMoneyRate())
	--self.willDepositValueText:setString(CustomHelper.moneyShowStyleNone(self.willDepositValue))

end
function BankDepositLayer:clickOneAddbtn(btn)
	local addValue = btn.addValue;
	local realAddValue = addValue * CustomHelper.goldToMoneyRate()
	if self.tempMoney >= self.willDepositValue + realAddValue then
		--todo
		self.willDepositValue = self.willDepositValue + realAddValue
	else
		self.willDepositValue = self.tempMoney
		MyToastLayer.new(cc.Director:getInstance():getRunningScene(),"金币余额不足，无法添加")
	end
	self:showMoneyInfoView();
end
--发送存钱消息
function BankDepositLayer:sendDepositMoneyMsg()
	--检测是否有未完成游戏，如有，则不能存钱
    local gamingInfoTab = self.myPlayerInfo:getGamingInfoTab()
    if gamingInfoTab ~= nil then
    	self.gamingTipLayer = CustomHelper.showAlertView(
	        "您正处于游戏中，无法进行此项操作",
	        false,
	        true,
			function()
				self.gamingTipLayer:removeSelf();
				self.gamingTipLayer = nil;
			end,
			function()			
				self.gamingTipLayer:removeSelf();
				self.gamingTipLayer = nil;
			end
	    )
    	return;
    end

	if self.willDepositValue == 0 then
		--todo
		return MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "请输入需要存入的金额")
	end
	if self.willDepositValue > self.tempMoney then
		return MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "存入金额,超出金币上限")
		--todo
	end
	self.depositBtn:setEnabled(false)
	local info = {};
	info.money = self.willDepositValue;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CS_BankDeposit,info)
end
function BankDepositLayer:registerNotification()
	---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
	self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_BankDeposit);
	self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_BankDeposit);
	self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_Gamefinish);
	BankDepositLayer.super.registerNotification(self);
end
--消息发送失败
function BankDepositLayer:receiveMsgRequestErrorEvent(event)
    self.depositBtn:setEnabled(true)
    BankDepositLayer.super.receiveMsgRequestErrorEvent(self,event)
end
--收到服务器返回的失败的通知，如登录失败，密码错误
function BankDepositLayer:receiveServerResponseErrorEvent(event)
    --print("BankDepositLayer:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local ret = userInfo["ret"] or userInfo["result"]; 
    if msgName == HallMsgManager.MsgName.SC_BankDeposit then
        --todo
		self.depositBtn:setEnabled(true)
    end
    BankDepositLayer.super.receiveServerResponseErrorEvent(self,event)
end

--收到服务器处理成功通知函数
function BankDepositLayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_BankDeposit then
    	--todo
    	self.depositBtn:setEnabled(true)
		self:resetTempMondAndBank();
		self:showMoneyInfoView();
		local resultStr = CustomHelper.moneyShowStyleNone(userInfo.money)
		MyToastLayer.new(cc.Director:getInstance():getRunningScene(), string.format("成功存入"..resultStr))


		self:checkBankGold()


    elseif msgName == HallMsgManager.MsgName.SC_Gamefinish then --关闭提示框
        --todo
        -- print("12312312311111111111111111111111")
        if self.gamingTipLayer then
            --todo
            -- print("123123123123123123")
            self.gamingTipLayer:removeSelf();
            self.gamingTipLayer = nil;
        end
    end
    BankDepositLayer.super.receiveServerResponseSuccessEvent(self,event)
end
return BankDepositLayer;