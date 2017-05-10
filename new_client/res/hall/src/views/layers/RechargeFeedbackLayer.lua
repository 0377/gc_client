
local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local RechargeFeedbackLayer = class("RechargeFeedbackLayer",CustomBaseView);
local FeedbackHelper = requireForGameLuaFile("FeedbackHelper")
function RechargeFeedbackLayer:ctor()
    self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("RechargeFeedbackLayerCCS.csb"));
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget");                                                                                                
    self:initView()
    RechargeFeedbackLayer.super.ctor(self)


    CustomHelper.addAlertAppearAnim(self.alertView)
end
function RechargeFeedbackLayer:initView()



   self.textfield = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "content_textfiled"), "ccui.Text");

   local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"close_btn"),"ccui.Button");
	closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    	self:closeView();
    end)


    local submit_btn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "submit_btn"), "ccui.Button");
	submit_btn:addTouchEventListener(handler(self, self._onBtnTouched_submitFeedback))

end
function RechargeFeedbackLayer:registerNotification()
    RechargeFeedbackLayer.super.registerNotification(self)
end

function RechargeFeedbackLayer:receiveServerResponseSuccessEvent(event)
    local msgName = event.userInfo.msgName
    dump(msgName)
    if msgName == "" then

    end
end

function RechargeFeedbackLayer:_onBtnTouched_submitFeedback(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        local content = self.textfield:getString()
        if content == "" then
        	MyToastLayer.new(self, "请输入反馈内容")
        	return
        end
        FeedbackHelper.submitFeedback(FeedbackHelper.CONFIG_FEEDBACK_CAT["充值问题"],content,function(xhr,isSuccess)
            if isSuccess then
                local data = json.decode( xhr.response)
                if data and data.status == 1 then
                    self.textfield:setString("")
                    MyToastLayer.new(self, data.message)
                else
                    MyToastLayer.new(self, data.message)
                end
            end
        end)
    end
end

function RechargeFeedbackLayer:closeView()
	CustomHelper.addCloseAnimForAlertView(
		self.alertView,
		function()
			self:removeSelf();
	end)
end

return RechargeFeedbackLayer;