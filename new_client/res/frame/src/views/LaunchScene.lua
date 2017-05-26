-- local LaunchScene = class(LaunchScene, cc.load("mvc").ViewBase)
local LaunchScene = class("LaunchScene", cc.Scene)
local scheduler = cc.Director:getInstance():getScheduler()
function LaunchScene:ctor()
	local CCSLuaNode =  requireForGameLuaFile("LaunchSceneCCS")
    self.csNode = CCSLuaNode:create().root;
    -- dump(self.csNode, "self.csNode", nesting)
    self:addChild(self.csNode);
    self.progressTipText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "progress_text"), "ccui.Text");
    self.progressTipText:setVisible(true)
    self.tipText = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"tip_text"),"ccui.Text");
    --进度条
    self.progressBarNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "download_progress_bar"), "ccui.LoadingBar");
    
    self.progressArrow = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "progress_arrow"), "ccui.ImageView");
    -- self.progressArrowView:setVisible(false)
	

 --    	--增加骨骼动画
	-- local fullPath = CustomHelper.getFullPath("anim/kog_loadingani/kog_loadingani.ExportJson")
 --    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fullPath);
 --    self._armaturet = ccs.Armature:create("kog_loadingani")
 --    self._armaturet:setScale(0.8)
 --    self._armaturet:getAnimation():play("ani_01")
 --    local winSize = CustomHelper.getWinSize();
 --    self._armaturet:setPosition(cc.p(winSize.width/2,winSize.height * 0.55))
 --    self:addChild(self._armaturet, 13)
 --    --进度条箭头端动画
 --    self._progresscoin = ccs.Armature:create("kog_loadingani")
 --    self._progresscoin:getAnimation():play("ani_02")
 --    self.progressBarNode:addChild(self._progresscoin)
    self:showProgressBarPercent(0)
	--获取服务器配置信息
	-- self:getServerConfig();
	
	self:enableNodeEvents()
end

function LaunchScene:onEnter(  )
	self:getServerConfig()
end
--检测是否需要更新
function LaunchScene:getServerConfig()
	self.tipText:setString("正在更新配置...")
	--根据版本号和渠道号，从服务器获取最新配置
	local callback = function(xhr,isSuccess)
		CustomHelper.removeIndicationTip()
		if isSuccess then
			--todo
			--检测是否有更新
			self:checkIsNeedUpdateClient();
		else -- 异常获取失败
			--todo	
			self.tipLayer = CustomHelper.showAlertView(
				"无法连接服务,是否重试",
				false,
				true,
				function()
					self:getServerConfig();
					self.tipLayer:removeSelf();
				end,
				function()
					self:getServerConfig();
					self.tipLayer:removeSelf();
				end
			);
		    self.tipLayer:getCloseBtn():setVisible(false)
		end
	end
	GameManager:getInstance():getServerConfig(callback);
end
function LaunchScene:checkIsNeedUpdateClient()
	-- local isNeedUpdated = GameManager:
	print("checkIsNeedUpdateClient")
	local updateStatus =  GameManager:getInstance():getVersionManager():checkIsUpdateClient()
	if updateStatus == VersionManager.UpdateStatus.Must then --强制更新
		--todo
		print("强制更新:",updateStatus)
		self._newClientTipLayer = CustomHelper.showAlertView(
			"客户端有新版本，前往更新",
			false,
			true,
			function()
				--self._newClientTipLayer:removeSelf()
			end,
			function()
				
				local url = GameManager:getInstance():getVersionManager():getDownloadNewClientUrl()
				print("[LaunchScene] url:%s", url)
				if url then
					cc.Application:getInstance():openURL(url)
				end

				--self._newClientTipLayer:removeSelf()
			end
		);
	    self._newClientTipLayer:getCloseBtn():setVisible(false)
		return;
	-- elseif updateStatus == VersionManager.UpdateStatus.Need then -- 有更新，但不强制
	-- 		--todo
	-- 	print("有更新，但不强制")
	else -- 不需要更新
		self:checkIsNeedUpdateBeforeEnterHall();
	end
	-- self:checkIsNeedUpdateBeforeEnterHall();
end
function LaunchScene:onExit()
	print("LaunchScene:onExit()")
	CustomHelper.unscheduleGlobal(self.schedulerEntry)
    if cc.Director:getInstance():isPaused() then
        cc.Director:getInstance():resume()
    end
	--清除下载数据
	GameManager:getInstance():getDownloaderManager():cleanDonwloadInfoDataWithGroupKey(self.downloaderGroupIndex);
	-- LaunchScene.super.onExit(self);
end
--检测是否需要更新大厅资源
function LaunchScene:checkIsNeedUpdateBeforeEnterHall()
	local needUpdateInfoTabForHall = GameManager:getInstance():getVersionManager():getNeedUpdateBeforeEnterHall();
	-- dump(needUpdateInfoTabForHall, "needUpdateInfoTabForHall", nesting)
	if needUpdateInfoTabForHall ~= nil and table.nums(needUpdateInfoTabForHall) > 0 then -- 需要更新
		--todo
		print("大厅有更新")
		self:updateDownLoadProgress();
		--添加定时器
		if self.schedulerEntry == nil then
			--todo
			self.schedulerEntry = scheduler:scheduleScriptFunc(function(dt)
				self:updateDownLoadProgress(dt)
			end, 0.1, false);
		end
		self.downloaderGroupIndex = GameManager:getInstance():getDownloaderManager():startDownLoad(
			needUpdateInfoTabForHall,
			function(groupIndex) --下载完成函数
				local seq = cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(function()
					--保存本地常量
					local versionManager = GameManager:getInstance():getVersionManager()
					
					dump(versionManager, "versionManager", nesting)
					-- print("before save const for download finish frame:",isNeedRestartGame)
					versionManager:saveConstTabWhenDownloadFinishedBeforeEnterHall();
					--判断是否需要重启游戏
					local isNeedRestartGame = versionManager:checkIsNeedRestartGame();
					print("isNeedRestartGame2:",isNeedRestartGame)
					if isNeedRestartGame == true then
						--todo
						print("ready hot restart game")
						restartGame()
					else
						print("after save const for download finish frame")
						--调用大厅下载完成
						self:callbackWhenAllDataAndResourceUpdated();
					end
					-- end
				end))
				self:runAction(seq)
			end,
			function(asset,errorStr) --下载出错处理函数
				print("download error:",errorStr)
				local errorStr = "下载异常,是否重试"
				local downloadErrorTipLayer =  CustomHelper.showAlertView(errorStr,
					false,
					true,
					nil,
					function(tipLayer)
						GameManager:getInstance():getDownloaderManager():startDownloadWithAsset(asset);
						tipLayer:removeSelf();
					end
				);
				downloadErrorTipLayer:getCloseBtn():setVisible(false);
			end
		);
		--从服务器开始下载
		dump(needUpdateInfoTabForHall, "needUpdateInfoTabForHall", 1000)
	else
		self.progressTipText:setString("")
		self:showProgressBarPercent(100)
		self.progressBarNode:runAction(
			cc.Sequence:create(
				cc.DelayTime:create(0.1),
				cc.CallFunc:create(function()
					self:callbackWhenAllDataAndResourceUpdated();
				end)
			)
		);
	end
end
function LaunchScene:callbackWhenAllDataAndResourceUpdated()
	GameManager:getInstance():callbackWhenHallVersionDownloadFinished();
end
--更新下载进度
function LaunchScene:updateDownLoadProgress(dt)
	local downloadInfo = GameManager:getInstance():getDownloaderManager():getDownloadInfoWithGroupKey(self.downloaderGroupIndex);
	-- dump(downloadInfo, "LaunchScene downloadInfo ", nesting)
	if downloadInfo == nil then
		--todo
		return
	end
	local mPer = 1024 * 1024;
	local totalSize = tonumber(downloadInfo[DownloaderManager.kTotalSize])/mPer;
	local totalDownloadSize = tonumber(downloadInfo[DownloaderManager.kTotalDownloadSize])/mPer;
	local percent = totalDownloadSize/totalSize * 100;
	self.progressTipText:setString(string.format("正在下载%.2f%%(%.2fM/%.2fM)",percent,totalDownloadSize,totalSize))
	self:showProgressBarPercent(percent)
end
function LaunchScene:showProgressBarPercent(percent)
	self.tipText:setString("正在更新资源...")
	self.progressBarNode:setPercent(percent)


	self.progressArrow:setScaleX(math.min(1,self.progressBarNode:getContentSize().width * percent / 100 /self.progressArrow:getContentSize().width ))
	self.progressArrow:setPositionX(math.min(self.progressBarNode:getContentSize().width * percent / 100 + 22 ,self.progressBarNode:getContentSize().width))
	self.progressArrow:setVisible(self.progressArrow:getPositionX() > 55)


	-- print("posX:",posX)
	-- dump(self.progressArrow)
	-- self.progressArrowView:setPosition(cc.p(self.progressBarNode:getContentSize().width * (self.progressBarNode:getPercent() / 100),
 --            self.progressArrowView:getParent():getContentSize().height / 2))
	-- self._progresscoin:setPosition(cc.p(self.progressBarNode:getContentSize().width * (self.progressBarNode:getPercent() / 100) - 43 ,self.progressBarNode:getContentSize().height / 2))


end
return LaunchScene;
