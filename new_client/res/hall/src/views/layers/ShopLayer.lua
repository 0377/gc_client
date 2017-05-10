local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local ShopLayer = class("ShopLayer",CustomBaseView)
function ShopLayer:ctor()
    self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("ShopLayerCCS.csb"));
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Widget");
  
	local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"close_btn"),"ccui.Button");
	closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    	self:closeView();
    end)
	
	self:initBtnListener()	
	ShopLayer.super.ctor(self)
    CustomHelper.addAlertAppearAnim(self.alertView)
end

function ShopLayer:initBtnListener()
	
	local function btnClick(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            sender:runAction(cc.ScaleTo:create(0.05,1.05))
        elseif eventType == ccui.TouchEventType.moved then
     
        elseif eventType == ccui.TouchEventType.ended then
			GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
			sender:runAction(cc.ScaleTo:create(0.05,1))
			self:buyCoin(sender:getTag());
        elseif eventType == ccui.TouchEventType.canceled then
            sender:runAction(cc.ScaleTo:create(0.05,1))
        end
	end 

	local btn_6 = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_6"),"ccui.Button");
	btn_6:setTag(1)
	btn_6:addTouchEventListener(btnClick);
	
	
	local btn_12 = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_12"),"ccui.Button");
	btn_12:setTag(2)
	btn_12:addTouchEventListener(btnClick);
	
	local btn_30 = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_30"),"ccui.Button");
	btn_30:setTag(3)
	btn_30:addTouchEventListener(btnClick);
	
	local btn_60 = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_60"),"ccui.Button");
	btn_60:setTag(4)
	btn_60:addTouchEventListener(btnClick);
	
	local btn_128 = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_128"),"ccui.Button");
	btn_128:setTag(5)
	btn_128:addTouchEventListener(btnClick);
	
	local btn_328 = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_328"),"ccui.Button");
	btn_328:setTag(6)
	btn_328:addTouchEventListener(btnClick);
	
	local btn_618 = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_618"),"ccui.Button");
	btn_618:setTag(7)
	btn_618:addTouchEventListener(btnClick);
end



function ShopLayer:buyCoin(value)
	print("buyCoin:",value)
	local StoreConfig = requireForGameLuaFile("StoreConfig")
	local item = StoreConfig.getItemsConfigById(value)
	local PayHelper = requireForGameLuaFile("PayHelper")
	PayHelper.createOrder(item,StoreConfig.PAY_TYPE.IOSPAY)
end

function ShopLayer:closeView()
	CustomHelper.addCloseAnimForAlertView(
		self.alertView,
		function()
			self:removeSelf();
	end)
end
return ShopLayer;