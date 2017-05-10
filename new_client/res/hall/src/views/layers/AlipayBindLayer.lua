local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local AlipayBindLayer = class("AlipayBindLayer",CustomBaseView);
function AlipayBindLayer:ctor()
    self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("AlipayBindLayerCCS.csb"));
    self:addChild(self.csNode);
    self.goEnsureBindBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alipay_bind_btn"), "ccui.Button");
    self.goEnsureBindBtn:addClickEventListener(function()
    	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:clickConfirmBtn();
    end);   
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();                                                                                                         
    self:initView()
    self:receiveRefreshPlayerInfoNotify();
    AlipayBindLayer.super.ctor(self)
end
function AlipayBindLayer:initView()
    self.bindTipView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bind_tip_view"), "ccui.Widget");

	local editBoxBgFileName = "hall_res/account/bb_grxx_KK.png"
	local nameEditBoxBgNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alipay_name_bg"), "ccui.ImageView");
	nameEditBoxBgNode:setVisible(false);
    local alipayNameEditBox = ccui.EditBox:create(nameEditBoxBgNode:getContentSize(),CustomHelper.getFullPath(editBoxBgFileName))
    alipayNameEditBox:setPosition(nameEditBoxBgNode:getPosition())
    alipayNameEditBox:setAnchorPoint(nameEditBoxBgNode:getAnchorPoint())
    alipayNameEditBox:setFontName("Helvetica-Bold")
    alipayNameEditBox:setFontSize(36)
    alipayNameEditBox:setFontColor(cc.c3b(255, 255, 255))
    alipayNameEditBox:setPlaceHolder("请输入支付宝姓名")
    alipayNameEditBox:setPlaceholderFontColor(cc.c3b(0xad,0xad,0xad))
    alipayNameEditBox:setPlaceholderFontSize(36)
    alipayNameEditBox:setMaxLength(30)
    alipayNameEditBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    alipayNameEditBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    alipayNameEditBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    nameEditBoxBgNode:getParent():addChild(alipayNameEditBox, 100)
    -- if args.data and args.data.FullName then
    --     editBox:setText(args.data.FullName)
    --     editBox:setTouchEnabled(true)
    -- end
    local accountEditBoxBgNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alipay_account_bg"), "ccui.ImageView");
    accountEditBoxBgNode:setVisible(false)
    local accountEditBox = ccui.EditBox:create(accountEditBoxBgNode:getContentSize(),CustomHelper.getFullPath(editBoxBgFileName))
    accountEditBox:setPosition(accountEditBoxBgNode:getPosition())
    accountEditBox:setAnchorPoint(accountEditBoxBgNode:getAnchorPoint());
    accountEditBox:setFontName("Helvetica-Bold")
    accountEditBox:setFontSize(36)
    accountEditBox:setFontColor(cc.c3b(255, 255, 255))
    accountEditBox:setPlaceHolder("请输入支付宝帐号")
    accountEditBox:setPlaceholderFontColor(cc.c3b(0xad,0xad,0xad))
    accountEditBox:setPlaceholderFontSize(36)
    accountEditBox:setMaxLength(30)
    accountEditBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    accountEditBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    accountEditBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    accountEditBoxBgNode:getParent():addChild(accountEditBox, 100)

    self.accountEditBox = accountEditBox
    self.nameEditBox = alipayNameEditBox
end
--在收到玩家信息变化通知时触发
function AlipayBindLayer:receiveRefreshPlayerInfoNotify()
    local alipayAccount = self.myPlayerInfo:getAlipayAccount();
    if alipayAccount ~= nil then
        --todo
        self.goEnsureBindBtn:setVisible(false);
        self.bindTipView:setVisible(false)
        self.accountEditBox:setTouchEnabled(false)
        self.nameEditBox:setTouchEnabled(false)
        local alipayName = self.myPlayerInfo:getAlipayName(); 
        self.nameEditBox:setText(alipayName);

        -- local alipayAccountLeg
        -- for i=1,alipayNameLen -1 do
        --     showAlipayName = myLua.LuaBridgeUtils:replaceUTF8String(showAlipayName,i,"*");
        -- end

        self.accountEditBox:setText(alipayAccount);
    else
        self.goEnsureBindBtn:setVisible(true)
        self.bindTipView:setVisible(true)
        self.accountEditBox:setTouchEnabled(true)
        self.nameEditBox:setTouchEnabled(true)
    end
end
function AlipayBindLayer:clickConfirmBtn()
	local accountStr = self.accountEditBox:getText()
    local nameStr = self.nameEditBox:getText()
    local errorStr = nil;
    --支付宝姓名：长度30个字符。可以输入数字，英文，汉字。
    if errorStr == nil and (not nameStr or nameStr == "") then
    	--todo
    	errorStr = "支付宝姓名不能为空！"
    end
    local isChineseFormat = CustomHelper.checkIsChineseText(nameStr)-- myLua.LuaBridgeUtils:checkIsChineseFormatWithStr(nameStr);
    if errorStr == nil and not isChineseFormat then
        --todo
        errorStr = "支付宝姓名为中文格式！"
    end
    --支付宝账号：长度30个字符。可以输入数字和英文。无法输入汉字。
    local len = CustomHelper.getCharacterCountInUTF8String(accountStr);
    local isEmailFormat = CustomHelper.checkIsEmailFormat(accountStr);
    local phoneErrorStr = CustomHelper.isPhoneNumberLegal(accountStr);
    if errorStr == nil and ( not accountStr or accountStr == "") then
        --todo
        errorStr = "支付宝账号不能为空"
    end
    if errorStr == nil and not(isEmailFormat == true or phoneErrorStr == nil) then
        --todo
        errorStr = "支付宝账号为手机号或者邮箱格式"
    end
    if errorStr ~= nil then
    	--todo
    	MyToastLayer.new(cc.Director:getInstance():getRunningScene(), errorStr)
    	return;
    else
    	--弹出再次确认界面
        ViewManager.setForceAlertOneView(true);
    	ViewManager.alertAlipayBindAgainEnsureLayer(nameStr,accountStr)
    end
end
return AlipayBindLayer;