local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local BankTransferAccountsLayer = class("BankTransferAccountsLayer", CustomBaseView)

local transMoneyRate = 0.02

function BankTransferAccountsLayer:ctor()
	self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("BankTransferAccountsLayerCCS.csb"));
    self:addChild(self.csNode);
    self:initView();
	BankTransferAccountsLayer.super.ctor(self);
end
function BankTransferAccountsLayer:initView()
	self.playerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	self.moneyText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "money_text"), "ccui.TextAtlas");
	self.bankText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bank_text"), "ccui.TextAtlas");
	self:showMoneyInfoView();	
	
	self.bankTransferAccountBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"transfer_account_btn"),"ccui.Button");
	self.bankTransferAccountBtn:addClickEventListener(function ()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:clickTranferAccountBtn()
	end);




	self.idtext = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "id_text"), "ccui.TextAtlas");
	self.idtext:setString(GameManager:getInstance():getHallManager():getPlayerInfo():getGuid())


	
	local accountIDEditBoxBgNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "account_id_input_bg"), "ccui.ImageView");
	accountIDEditBoxBgNode:setVisible(false);
	local editBoxBgFileName = "hall_res/bank_new/baobo_popupview_changtiao.png"
	local editBoxSize = accountIDEditBoxBgNode:getContentSize();
    self.accountIDTF = ccui.EditBox:create(editBoxSize,editBoxBgFileName)
    self.accountIDTF:setPosition(cc.p(accountIDEditBoxBgNode:getPositionX(),accountIDEditBoxBgNode:getPositionY()))
    self.accountIDTF:setAnchorPoint(accountIDEditBoxBgNode:getAnchorPoint())
    self.accountIDTF:setFontName("Helvetica-Bold")
    self.accountIDTF:setFontSize(36)
    self.accountIDTF:setFontColor(cc.c3b(255,255,255))
    self.accountIDTF:setPlaceHolder("请输入收账方ID")
    self.accountIDTF:setPlaceholderFontColor(cc.c3b(103,95,96))
    self.accountIDTF:setPlaceholderFontSize(36)
    self.accountIDTF:setMaxLength(16)
    self.accountIDTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    self.accountIDTF:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.accountIDTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    accountIDEditBoxBgNode:getParent():addChild(self.accountIDTF)	

    local tranferNumEditBoxBogNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "tranfer_num_edit_bg"), "ccui.ImageView");
    tranferNumEditBoxBogNode:setVisible(false)
    self.tranferNumTF = ccui.EditBox:create(editBoxSize,editBoxBgFileName)
    self.tranferNumTF:setPosition(cc.p(tranferNumEditBoxBogNode:getPositionX(),tranferNumEditBoxBogNode:getPositionY()))
    self.tranferNumTF:setAnchorPoint(tranferNumEditBoxBogNode:getAnchorPoint())
    self.tranferNumTF:setFontName("Helvetica-Bold")
    self.tranferNumTF:setFontSize(36)
    self.tranferNumTF:setFontColor(cc.c3b(255,255,255))
    self.tranferNumTF:setPlaceHolder("请输入转账金额")
    self.tranferNumTF:setPlaceholderFontColor(cc.c3b(103,95,96))
    self.tranferNumTF:setPlaceholderFontSize(36)
    self.tranferNumTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    self.tranferNumTF:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.tranferNumTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    tranferNumEditBoxBogNode:getParent():addChild(self.tranferNumTF)
    	

    	
    self.tranferNumTF:registerScriptEditBoxHandler(function(eventType)
		if eventType == "return" then
			--todo
			local valueStr = self.tranferNumTF:getText();
			local value = CustomHelper.tonumber(valueStr)
			local allowMaxValue = self.playerInfo:getBank()/CustomHelper.goldToMoneyRate()
			if value*(1+transMoneyRate) >= allowMaxValue then
				--todo
				value = math.floor(allowMaxValue/(1+transMoneyRate));
				self.tranferNumTF:setText(value.."")

				
			end
			self:checkBankGold()
		end
		print("print:",eventType)
	end)



    local addNumArray = {10,100,1000,10000}
	for i=1,4 do
		local tempAddBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,string.format("add_btn_%d",i)), "ccui.Button")
		tempAddBtn.addValue = addNumArray[i]
		tempAddBtn:addClickEventListener(function()
			GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
			--self:clickOneAddbtn(tempAddBtn)

			local valueStr = self.tranferNumTF:getText();
			local money = CustomHelper.tonumber(valueStr);


			self.tranferNumTF:setText(money+tempAddBtn.addValue)

			self:checkBankGold()
		end);
	end
	local resetBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "reset_btn"), "ccui.Button");
	resetBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		--self:resetTempMondAndBank();
		--self:showMoneyInfoView();
		self.tranferNumTF:setText("")
		self:checkBankGold()
	end);

	self:checkBankGold()





end

function BankTransferAccountsLayer:checkBankGold()
	-- body

	local addNumArray = {10,100,1000,10000}
	for i=1,4 do
		local tempAddBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,string.format("add_btn_%d",i)), "ccui.Button")

		local valueStr = self.tranferNumTF:getText();
		local money = CustomHelper.tonumber(valueStr);

		local t1 = CustomHelper.goldToMoneyRate()

		local m1 = (self.playerInfo:getBank()/CustomHelper.goldToMoneyRate()-money*(1+transMoneyRate)) - addNumArray[i]*(1+transMoneyRate)
		print("m1:"..m1.."money*(1+transMoneyRate):"..money*(1+transMoneyRate).."array:",addNumArray[i].."rate:"..CustomHelper.goldToMoneyRate())
		if m1 >= 0 then
				tempAddBtn:setEnabled(true)
		else
				tempAddBtn:setEnabled(false)
		end
	end

end


function BankTransferAccountsLayer:showMoneyInfoView()
	local moneyStr = CustomHelper.moneyShowStyleNone(self.playerInfo:getMoney())
	moneyStr = string.gsub(moneyStr, "%.", "/")
	self.moneyText:setString(moneyStr)
	local bankMoneyStr = CustomHelper.moneyShowStyleNone(self.playerInfo:getBank());
	bankMoneyStr = string.gsub(bankMoneyStr, "%.", "/")
	self.bankText:setString(bankMoneyStr)
end
function BankTransferAccountsLayer:clickTranferAccountBtn()
	local guidStr = self.accountIDTF:getText();
	local valueStr = self.tranferNumTF:getText();
	local errorStr = nil
	local money = CustomHelper.tonumber(valueStr) * CustomHelper.goldToMoneyRate() ;

	local guid = tonumber(guidStr);
	local isNumber = false;
	if guid ~= nil then
	 -- 是数字
	 	isNumber = true;
	end
	print("isNumberFormat:",isNumber)
	if errorStr == nil and (accountIDStr == "" or isNumber == false)  then
		
		errorStr = "收账方ID为数字格式";
	end
	if errorStr == nil and (valueStr == "" )then
		errorStr = "请输入转账金额";
	elseif money*(1+transMoneyRate) > self.playerInfo:getBank() then
		errorStr = "转账金额不能大于银行金额与手续费之和"
	elseif money/CustomHelper.goldToMoneyRate() < 10 then
		errorStr = "转账金额不得少于10元"
	elseif self.playerInfo:getBank()-money*(1+transMoneyRate) + self.playerInfo:getMoney() < 6 * CustomHelper.goldToMoneyRate() then
		errorStr = "携带金币与银行金币之和保底6元"
	end
	if errorStr ~= nil then
		MyToastLayer.new(cc.Director:getInstance():getRunningScene(),errorStr)
		return;
	end


	--[[

// 通过guid转账
message CS_BankTransferByGuid {
	enum MsgID { ID = 2017; }
	optional int32 guid = 1;						// 玩家的guid
	optional int64 money = 2;						// 转账多少钱
}
		
	]]


	local  str1 = "您确认要将%d金转给ID为%s的用户吗?"

	CustomHelper.showAlertView(string.format(str1,CustomHelper.tonumber(valueStr),guidStr),true,true,nil,function( tipLayer )
		-- body
		local info = {};
		info.guid = guid;
		info.money = money
		self.bankTransferAccountBtn:setEnabled(false)
		GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CS_BankTransferByGuid,info)

	end)




	
end
function BankTransferAccountsLayer:registerNotification()
	---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
	self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_BankTransferByGuid)
	self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_BankTransfer);
	BankTransferAccountsLayer.super.registerNotification(self);
end

--消息发送失败
function BankTransferAccountsLayer:receiveMsgRequestErrorEvent(event)
	self.bankTransferAccountBtn:setEnabled(true)
    BankTransferAccountsLayer.super.receiveMsgRequestErrorEvent(self,event)
end
function BankTransferAccountsLayer:receiveServerResponseErrorEvent(event)
    local isCallSuper = true;
    self.bankTransferAccountBtn:setEnabled(true)
    if isCallSuper then
        --todo
        BankTransferAccountsLayer.super.receiveServerResponseErrorEvent(self,event)
    end
end
--收到服务器处理成功通知函数
function BankTransferAccountsLayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_BankTransfer then
    	--todo
    	self.bankTransferAccountBtn:setEnabled(true)
    	self.tranferNumTF:setText("0")
		self:showMoneyInfoView();	
		local resultStr = CustomHelper.moneyShowStyleNone(userInfo.money)
		MyToastLayer.new(cc.Director:getInstance():getRunningScene(), string.format("成功转账"..resultStr))

		self:checkBankGold()
    end
    BankTransferAccountsLayer.super.receiveServerResponseSuccessEvent(self,event)
end
return BankTransferAccountsLayer;