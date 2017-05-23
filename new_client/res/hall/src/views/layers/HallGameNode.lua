local HallGameNode = class("HallGameNode",ccui.Widget)
local scheduler = cc.Director:getInstance():getScheduler()
HallGameNode.Status =
{
	Normal 				= 1,
	NeedUpdate    		= 2,
	Updating 			= 3
}
function HallGameNode:ctor(csNode,infoTab)
	self:setContentSize(cc.size(csNode:getContentSize().width, csNode:getContentSize().height));
	self:addChild(csNode);
	csNode:setAnchorPoint(cc.p(0,0))
	csNode:setPosition(cc.p(0,0))
	local amartureNode = CustomHelper.seekNodeByName(csNode, "download_finish_anim");
	self:showInfoWithOneGameItemNode(infoTab);
	self.selectBtn = tolua.cast(CustomHelper.seekNodeByName(self, "selectBtn"), "ccui.Button");
	--添加游戏选择框
	self.selectBtn:setSwallowTouches(false)
	--print("HallGameNode:ctor")
	self:setEnabled(true);
	self:enableNodeEvents();
	-- HallGameNode.super.ctor(self)
end
function HallGameNode:onEnter()

end
function HallGameNode:onExit()
	self:stopDownloadScheduler()
    print("self.downloaderGroupKey:",self.downloaderGroupKey)
    -- HallGameNode.super.onExit();
end
--停止下载进度的计时器
function HallGameNode:stopDownloadScheduler()
	if self.gamesDownloadProgressScheduler ~= nil then
    	--todo
    	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.gamesDownloadProgressScheduler);
    end
	self.gamesDownloadProgressScheduler = nil	
end
--现在游戏节点信息
--@param canSelected 是否能够设置选择框的触摸
function HallGameNode:showInfoWithOneGameItemNode(infoTab)
	self.infoTab = infoTab
	self:stopDownloadScheduler() --每次进来时应该停止计时器
	local limitMoneyText = tolua.cast(CustomHelper.seekNodeByName(self, "limit_money_text"), "ccui.Text");
	--dump(infoTab, "infoTab", 100)
	--得到所有房间中最小的入场金币限制
	local minMoneyLimit = 999999;
	local allRoomInfoTab = infoTab[HallGameConfig.SecondRoomKey];
	if allRoomInfoTab then
		--todo
		for i,v in ipairs(allRoomInfoTab) do
			local tempMinMoneyLimit = CustomHelper.tonumber(v[HallGameConfig.SecondRoomMinMoneyLimitKey]);
			if tempMinMoneyLimit < minMoneyLimit then
				--todo
				minMoneyLimit = tempMinMoneyLimit;
			end
		end
	end
	local minMoneyLimitString = CustomHelper.moneyShowStyleNone(minMoneyLimit);
	limitMoneyText:setString(minMoneyLimitString);
	--显示对应信息
	local iconParentNode = tolua.cast(CustomHelper.seekNodeByName(self,"iconParentNode"), "ccui.ImageView");
	local gameID = infoTab[HallGameConfig.GameIDKey];
	self.gameID = gameID;
	--处理itemNode状态
	self.needUpdateInfoTab = GameManager:getInstance():getVersionManager():getNeedUpdateInfoTabForOneGame(gameID);
	-- dump(itemNode.needUpdateInfoTab, "itemNode.needUpdateInfoTab", nesting)
	--添加icon
	local iconName = infoTab[HallGameConfig.GameIconKey]
	local iconNode = tolua.cast(CustomHelper.seekNodeByName(self,"iconNode"), "ccui.ImageView");
	iconNode:ignoreContentAdaptWithSize(true);
	iconNode:loadTexture(CustomHelper.getFullPath(iconName));
	iconNode:setVisible(true);
	-- iconNode:runAction(
	-- 	cc.RepeatForever:create(
	-- 		cc.Sequence:create(
	-- 			cc.FadeTo:create(0.3, 125),
	-- 			-- cc.DelayTime:create(1.2),
	-- 			cc.FadeTo:create(0.3, 255)
	-- 			-- cc.DelayTime:create(1.2)
	-- 		)
	-- 	)
	-- )
	-- CustomHelper.changeNodeToGray(iconNode);
	self.downloadProgressPanel = tolua.cast(CustomHelper.seekNodeByName(self, "download_progress_panel"), "ccui.Button");
	self.downloadProgressPanel:setVisible(false);
	--
	if self.downloadProgressBar == nil then
		--todo
		local progressBarParentNode = tolua.cast(CustomHelper.seekNodeByName(self, "progress_bar_parent"), "ccui.Widget");
		local progressSpr = cc.Sprite:create(CustomHelper.getFullPath("hall_res/hall/bb_dating_download_jindutiao2.png"));
		self.downloadProgressBar = cc.ProgressTimer:create(progressSpr)
		self.downloadProgressBar:setReverseProgress(false)--顺时针
		self.downloadProgressBar:setType(0)
		self.downloadProgressBar:setMidpoint(cc.p(0.5,0.5))
		progressBarParentNode:addChild(self.downloadProgressBar)
		self.downloadProgressBar:setPosition(cc.p(self.downloadProgressBar:getParent():getContentSize().width/2,self.downloadProgressBar:getParent():getContentSize().height/2));
		self.downloadProgressBar:setAnchorPoint(cc.p(0.5,0.5));
		-- self.downloadProgressBar = tolua.cast(CustomHelper.seekNodeByName(self.downloadProgressPanel, "download_progress_bar"), "ccui.LoadingBar")
	end
	if self.progressPercentText == nil then
		--todo
		self.progressPercentText = tolua.cast(CustomHelper.seekNodeByName(self, "download_percent_text"), "ccui.Text");
		self.progressPercentText:setString("0%%")
	end
	--生成下载key
	self.downloaderGroupKey = "download_game_id_"..self.gameID
	local finishListener = cc.EventListenerCustom:create(VersionManager.kNotifyName_OneGameDownloadFinished,function(event)
		local groupKey = event.userInfo["group_key"]
		if groupKey == self.downloaderGroupKey then
			--todo
			--骨骼动画播放
			-- if self.armature == nil then
			-- --todo
			-- 	animInfoStr = "hall_res/anim/hall_xzcg_eff/hall_xzcg_eff.ExportJson#ani_01"
			-- 	local animInfoArray = string.split(animInfoStr,"#");
			-- 	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(animInfoArray[1])
			-- 	local armature = ccs.Armature:create("hall_xzcg_eff")
			-- 	-- armature:setLocalZOrder(1000000)
			--     iconParentNode:addChild(armature);
			--     armature:align(display.CENTER, armature:getParent():getContentSize().width/2,armature:getParent():getContentSize().height / 2 + 105)
			--     self.armature = armature;
			-- end
		    -- self.armature:getAnimation():play("ani_01")
	        local seq = cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(function()
				--保存本地常量
				self.status = HallGameNode.Status.Normal;
				self:updateItemNodeStatus();
			end))
			self:runAction(seq)
		end
    end);
	local errorListener = cc.EventListenerCustom:create(VersionManager.kNotifyName_OneGameDownloadError,function(event)
		local userInfo = event.userInfo;
		local asset = userInfo["asset"];

		local groupKey = asset:getGroup();
		if groupKey == self.downloaderGroupKey then
			--todo
			local errorStr = userInfo["errorStr"];
			local errorStr = "下载异常,是否重试"
			CustomHelper.showAlertView(
				errorStr,
				true,
				true,
				function(tipLayer)
					--还原状态
					self.status = HallGameNode.Status.NeedUpdate;
					self:updateItemNodeStatus();
					tipLayer:removeSelf();
			 	end,
			 	function(tipLayer)
					GameManager:getInstance():getDownloaderManager():startDownloadWithAsset(asset);
					tipLayer:removeSelf();
				end
			)
		end
	end)
	self.eventDispatcher = cc.Director:getInstance():getEventDispatcher();
	self.eventDispatcher:addEventListenerWithSceneGraphPriority(finishListener,self);
	self.eventDispatcher:addEventListenerWithSceneGraphPriority(errorListener,self);
	--dump(self.needUpdateInfoTab)
	if self.needUpdateInfoTab == nil or table.nums(self.needUpdateInfoTab) == 0 then
		--todo
		self.status = HallGameNode.Status.Normal;
	else
		--todo
		--需要更新
		self.status = HallGameNode.Status.NeedUpdate
		--生成下载的 downloadGroupID
		--判断 后台是否正在更新
		local downloadInfo = GameManager:getInstance():getDownloaderManager():getDownloadInfoWithGroupKey(self.downloaderGroupKey);
		if downloadInfo then -- 正在下载,显示下载地进度
			--todo
			self:startPercentSchedule();
		end
	end
	self:updateItemNodeStatus();
end
function HallGameNode:touchGameNode()
	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
	self:clickOneGameBtn()
end

--开启定时器
function HallGameNode:startPercentSchedule()
	if self.gamesDownloadProgressScheduler == nil then
		--todo
		self.gamesDownloadProgressScheduler = scheduler:scheduleScriptFunc(function(dt)
			self:updateDownLoadProgressForGamesDownload(dt)
		end, 0.1, false);
	end
	self.status = HallGameNode.Status.Updating;
	self:updateItemNodeStatus();
end
function HallGameNode:updateItemNodeStatus()
	local status = self.status;
	--正常面板
	local normalPanel = tolua.cast(CustomHelper.seekNodeByName(self, "normal_panel"), "ccui.Widget");
	--有更新面板
	local needUpdatePanel = tolua.cast(CustomHelper.seekNodeByName(self,"need_update_panel"), "ccui.Widget");
	if status == HallGameNode.Status.NeedUpdate or status == HallGameNode.Status.Updating then
		--todo
		normalPanel:setVisible(false);
		needUpdatePanel:setVisible(true);
		if status == HallGameNode.Status.NeedUpdate then
			--todo
			self.downloadProgressPanel:setVisible(false)
			self.downloadProgressBar:setPercentage(0)
			self.progressPercentText:setVisible(false)
		elseif status == HallGameNode.Status.Updating then --正在更新
			--todo
			self.downloadProgressPanel:setVisible(true)
			self.downloadProgressBar:setPercentage(0)
			self.progressPercentText:setVisible(true)
		end
	else -- 
		normalPanel:setVisible(true);
		needUpdatePanel:setVisible(false);
	end
end
function HallGameNode:clickOneGameBtn()
	if self.status == HallGameNode.Status.Normal then
		--todo
		ViewManager.enterSecondarySelctedLayer(self.gameID);
	elseif self.status == HallGameNode.Status.NeedUpdate then
		--todo
		self:startPercentSchedule();
		--开始下载
		GameManager:getInstance():getVersionManager():startDownloadOneGameResZipPackage(
			self.gameID,
			self.needUpdateInfoTab,
			self.downloaderGroupKey
			);
		-- table.insert(self.allDownloadGameNodeTab,itemNode);
	elseif self.status == HallGameNode.Status.Updating then
		--todo
		local path = cc.FileUtils:getInstance():getWritablePath()
		print("游戏正在更新中!")
	end
end
--下载进度条
function HallGameNode:updateDownLoadProgressForGamesDownload(dt)
	if self.downloaderGroupKey then
				--todo
		local downloadInfo = GameManager:getInstance():getDownloaderManager():getDownloadInfoWithGroupKey(self.downloaderGroupKey);
		-- dump(downloadInfo, "LaunchScene downloadInfo ", nesting)
		if downloadInfo == nil then
			--todo
			return
		end
		local mPer = 1024 * 1024;
		local totalSize = tonumber(downloadInfo[DownloaderManager.kTotalSize])/mPer;
		local totalDownloadSize = tonumber(downloadInfo[DownloaderManager.kTotalDownloadSize])/mPer;
		local percent = totalDownloadSize/totalSize * 100;
		self.downloadProgressBar:setPercentage(percent);
		self.progressPercentText:setString(string.format("%d%%", percent));
	end
end
return HallGameNode;