local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local NoticeShowLayer = class("NoticeShowLayer",CustomBaseView)
function NoticeShowLayer:ctor(notice)
    local CCSLuaNode =  requireForGameLuaFile("NoticeShowLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Widget");
  
	local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_close"),"ccui.Button");
	closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    	self:closeView();
    end)
	
	-- local confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_confirm"),"ccui.Button");
	-- confirmBtn:addClickEventListener(function()
 --        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
 --    	self:closeView();
 --    end)
	self:initView(notice)
	NoticeShowLayer.super.ctor(self)
    CustomHelper.addAlertAppearAnim(self.alertView)
    --标记公告已读
    notice.Readed = true
    GameManager:getInstance():getHallManager():getHallMsgManager():sendSetMsgReadFlag(notice)
    local  hallDataManager = GameManager:getInstance():getHallManager():getHallDataManager()
    if notice._Content.content_type and tonumber(notice._Content.content_type) == hallDataManager.NOTICE_TYPE.DAY_NOTICE then --每日公告
		hallDataManager:saveDayNoticeReadTime(notice.Id)
	end

end

function NoticeShowLayer:initView(notice)
	local title = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"title_txt"),"ccui.Text");
	title:setString(CustomHelper.decodeURI(notice._Content.title))
	local content = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"content_txt"),"ccui.Text");
	content:setString(CustomHelper.decodeURI(notice._Content.content))
	content:ignoreContentAdaptWithSize(true); 
	content:setTextAreaSize(cc.size(930, 0)); 
end

function NoticeShowLayer:closeView()
	CustomHelper.addCloseAnimForAlertView(
		self.alertView,
		function()
			self:removeSelf();
	end)
end
return NoticeShowLayer;