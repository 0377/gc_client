local TipLayer = class("TipLayer", cc.Node);
FrameSound_Btn = "sound/frame_btn.mp3"
function TipLayer:ctor()
	local CCSLuaNode =  requireForGameLuaFile("TipLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Layout");
    self.contentTextNode = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "contentTextNode"), "ccui.Text");
    self.confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "confirmBtn"), "ccui.Button");
    self.cancelBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "cancelBtn"), "ccui.Button");
    self.orginConfirmPos = cc.p(self.confirmBtn:getPositionX(),self.confirmBtn:getPositionY());
    self.orginCancelPos = cc.p(self.cancelBtn:getPositionX(),self.cancelBtn:getPositionY());
    self.closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "close_btn"), "ccui.Button");
end
function TipLayer:getCloseBtn()
	return self.closeBtn;
end

function TipLayer:showLackMoneyAlertView(content,cancelBtnStr,confirmBtnStr,cancelCallbackFunc,confirmCallbackFunc,closeCallbackFunc)

	local richText = myLua.LuaBridgeUtils:createHLCustomRichTextWithNode(content,self.contentTextNode,1,1);
    if self.contentTextNode:getParent():getChildByName(richText:getName()) then
        --todo
        --print("delete skill description richtext");
        self.contentTextNode:getParent():removeChildByName(richText:getName(), true);
    end
    richText:formatText();
    richText:setVisible(true)
    self.contentTextNode:getParent():addChild(richText)
	-- self.contentTextNode:setString(content);


	if cancelCallbackFunc == nil then
		--todo
		cancelCallbackFunc = function()
			self:removeSelf();
		end
	end

	if closeCallbackFunc == nil then
		closeCallbackFunc = cancelCallbackFunc
	end

	self.cancelBtn:setVisible(false);
	self.confirmBtn:setVisible(false);

	if cancelBtnStr and confirmBtnStr then

		self.cancelBtn:setVisible(true);
		self.confirmBtn:setVisible(true);
		self.confirmBtn:setPosition(self.orginConfirmPos);
		self.cancelBtn:setPosition(self.orginCancelPos);
	elseif cancelBtnStr then
			--todo
		self.cancelBtn:setVisible(true);
		self.cancelBtn:setPosition(cc.p(self.cancelBtn:getParent():getContentSize().width/2,self.orginCancelPos.y));
	elseif confirmBtnStr then
		--todo
		self.confirmBtn:setVisible(true);
		self.confirmBtn:setPosition(cc.p(self.cancelBtn:getParent():getContentSize().width/2,self.orginCancelPos.y));
	end


	local function  setBtnTexture( btn,btnTag,callBackFunc )
		if btnTag == nil then return end 
		if btnTag == "cancal" then
			-- btn:loadTextures("","","")
		elseif btnTag == "bank" then
			
			btn:loadTextures("hall_res/tishi/bb_xszd_qyh.png","hall_res/tishi/bb_xszd_qyh1.png","hall_res/tishi/bb_xszd_qyh1.png")
			btn:ignoreContentAdaptWithSize(true)
			local normalSize = btn:getRendererNormal():getOriginalSize();
			btn:setContentSize(cc.size(normalSize.width,normalSize.height))
		elseif  btnTag == "story" then
			btn:ignoreContentAdaptWithSize(true)
			btn:loadTextures("hall_res/tishi/bb_xszd_qcz.png","hall_res/tishi/bb_xszd_qcz1.png","hall_res/tishi/bb_xszd_qcz1.png")
			local normalSize = btn:getRendererNormal():getOriginalSize();
			btn:setContentSize(cc.size(normalSize.width,normalSize.height))
		elseif btnTag == "canfirm" then


		end
		btn:addClickEventListener(function(sender)
			GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
			callBackFunc(self);
		end);
	end

	

	setBtnTexture( self.cancelBtn,cancelBtnStr,cancelCallbackFunc )
	setBtnTexture( self.confirmBtn,confirmBtnStr,confirmCallbackFunc)
	self.closeBtn:addClickEventListener(function(sender)
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
		closeCallbackFunc(self);
	end);
	CustomHelper.addAlertAppearAnim(self.alertView)
end






function TipLayer:showAlertView(content,showCancelBtn,showConfirmBtn,cancelCallbackFunc,confirmCallbackFunc)
    local richText = myLua.LuaBridgeUtils:createHLCustomRichTextWithNode(content,self.contentTextNode,1,1);
    if self.contentTextNode:getParent():getChildByName(richText:getName()) then
        --todo
        --print("delete skill description richtext");
        self.contentTextNode:getParent():removeChildByName(richText:getName(), true);
    end
    richText:formatText();
    richText:setVisible(true)
    self.contentTextNode:getParent():addChild(richText)
	-- self.contentTextNode:setString(content);

	self.cancelBtn:setVisible(false);
	self.confirmBtn:setVisible(false);
	if showCancelBtn == nil then
		--todo
		showCancelBtn = false
	end
	if showConfirmBtn == nil then
		--todo
		showConfirmBtn = true
	end
	if showCancelBtn and showConfirmBtn then
		--todo
		self.cancelBtn:setVisible(true);
		self.confirmBtn:setVisible(true);
		self.confirmBtn:setPosition(self.orginConfirmPos);
		self.cancelBtn:setPosition(self.orginCancelPos);
	elseif showCancelBtn then
			--todo
		self.cancelBtn:setVisible(true);
		self.cancelBtn:setPosition(cc.p(self.cancelBtn:getParent():getContentSize().width/2,self.orginCancelPos.y));
	elseif showConfirmBtn then
		--todo
		self.confirmBtn:setVisible(true);
		self.confirmBtn:setPosition(cc.p(self.cancelBtn:getParent():getContentSize().width/2,self.orginCancelPos.y));
	end

	if confirmCallbackFunc == nil then
		--todo
		confirmCallbackFunc = function()
			self:removeSelf();
		end
	end
	if cancelCallbackFunc == nil then
		--todo
		cancelCallbackFunc = function()
			self:removeSelf();
		end
	end
	self.confirmBtn:addClickEventListener(function(sender)
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
		confirmCallbackFunc(self);
	end);
	self.closeBtn:addClickEventListener(function(sender)
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
		cancelCallbackFunc(self);
	end);
	self.cancelBtn:addClickEventListener(function(sender)
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
		cancelCallbackFunc(self);
	end);

	CustomHelper.addAlertAppearAnim(self.alertView)
end
function TipLayer:addClickCancelBtnLinistener(cancelCallbackFunc)
	self.cancelBtn:addClickEventListener(function(sender)
		cancelCallbackFunc(self);
	end);
end
return TipLayer;