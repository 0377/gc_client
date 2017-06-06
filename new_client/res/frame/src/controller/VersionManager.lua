VersionManager = class("VersionManager");
--是否检测有新版本
VersionManager.IsNeedCheckConstInfo		= 	false --用于控制是否需要从服务器获取的最新配置
VersionManager.IsNeedCheckNewVersion	=  	false --用于控制是否有资源包下载
VersionManager.IsNeedUpdateConstInfo 	= 	false


VersionManager.kSaveClientConstFileName	=	"client_const.json"
VersionManager.kFrameInfoKey			=   "frame_info"

VersionManager.kClientInfo 				= 	"client_info"
VersionManager.kClientChannel			=	"channel"
VersionManager.kServerURL				=	"server_urls"
VersionManager.kIsMustUpdate			=	"is_must_update"

VersionManager.kHallInfo				=	"hall_info"
VersionManager.kFrameVersionInfo		=	"frame_download_info"
VersionManager.kHallVersionInfo			=	"hall_download_info"
VersionManager.kGamesVersionInfo		=	"games_download_info"

VersionManager.kVersion					=	"version"		

VersionManager.kNotifyName_OneGameDownloadFinished = "kNotifyName_OneGameDownloadFinished"
VersionManager.kNotifyName_OneGameDownloadError    = "kNotifyName_OneGameDownloadError"

--需要更新的状态
VersionManager.UpdateStatus = {
	Must    					= 			"must",
	Need    					= 			"need",
	NotNeed 					= 			"not_need"
}	
-- VersionManager.UpdateRootDirName		=	"download_res"
function VersionManager:ctor()
	self:_refreshOnlineInfo()
	--取本地客户端信息，始终取res目录下
	local resConstPath = cc.FileUtils:getInstance():fullPathForFilename("res/"..VersionManager.kSaveClientConstFileName);
	local resConstTab = CustomHelper.createJsonTabWithFilePath(resConstPath)
	--客户端基本信息
	self.clientInfoTab = resConstTab[VersionManager.kClientInfo];
	--得到clientConst.json的路径，优先读取下载路径下的文件
	local clientConstPath = cc.FileUtils:getInstance():fullPathForFilename(VersionManager.kSaveClientConstFileName);
	local localConstTab = CustomHelper.createJsonTabWithFilePath(clientConstPath)
	CustomHelper.addSetterAndGetterMethod(self,"clientConstTab",localConstTab);--
	CustomHelper.addSetterAndGetterMethod(self,"serverConstTab",nil);
	--常量保存的路径
	self.saveClientConstPath = cc.FileUtils:getInstance():getWritablePath() ..VersionManager.kSaveClientConstFileName;
	self.maxRetryTimes = 1;
	self.retryTimes = 1;
	self.configUrlIndex = 1;--配置服务器索引
end

-- 作用：保证打出的线上包相关配置正确
function VersionManager:_refreshOnlineInfo()
	if self.clientInfoTab then
		local enableOnline = self.clientInfoTab["enable_online"]
		if enableOnline then
			DEBUG = 0

			VersionManager.IsNeedCheckConstInfo		= 	true 
			VersionManager.IsNeedCheckNewVersion	=  	true
			VersionManager.IsNeedUpdateConstInfo 	= 	true
		end
	end
end

function VersionManager:reset()
	self.retryTimes = 1;
	self.configUrlIndex = 1;--配置服务器索引
end
function VersionManager:getVersionStr()
	return self.clientInfoTab[VersionManager.kVersion];
end
function VersionManager:getChannelName()
	return self.clientInfoTab[VersionManager.kClientChannel]
end
function VersionManager:getServerURL()
	--获取当前地址
	local serverUrls = self.clientInfoTab[VersionManager.kServerURL];
	local url = serverUrls[self.configUrlIndex];
	self.configUrlIndex = self.configUrlIndex + 1
	return  url;
end
function  VersionManager:getNewestClientConstTabFromServer(callback)
	if VersionManager.IsNeedCheckConstInfo == false then
		--todo
		self.serverConstTab = CustomHelper.copyTab(self.clientConstTab);
		callback(nil,true);
		return;
	end
	--刷新常量
	self:refreshClientConstConfig(callback);
end
function  VersionManager:refreshClientConstConfig(callback)
	local serverURL =  self:getServerURL();
	-- print("serverURL:"..serverURL)
	local parameterTab = {};
	parameterTab.version = self:getVersionStr();
	parameterTab.channel = self:getChannelName();
	-- parameterTab.plattype = DeviceUtils.getDevicePlatform()
	dump(parameterTab, "parameterTab", nesting)
	local networkManager = GameManager:getInstance():getNetworkManager();

	self.versionCallback = function(xhr,isSuccess)
        if isSuccess then -- 成功
        	local responseStr = xhr.response;
            self.serverConstTab = CustomHelper.getJsonTabWithJsonStr(responseStr);
            if VersionManager.IsNeedUpdateConstInfo == true then
            	--todo
                local needSaveConstTab = CustomHelper.copyTab(self.serverConstTab);
	            --更新除下载配置外所有其他到本地配置 ，下载配置在下载完成的时候才保存
	            needSaveConstTab[VersionManager.kFrameVersionInfo] = nil;
	            needSaveConstTab[VersionManager.kHallVersionInfo] = nil;
				needSaveConstTab[VersionManager.kGamesVersionInfo] = nil;
				--dump(needSaveConstTab, "needSaveConstTab", nesting)
				--保存除了client_info之外的信息
				needSaveConstTab[VersionManager.kClientInfo] = nil;
				self.clientConstTab[VersionManager.kClientInfo] = nil;
				CustomHelper.updateJsonTab(self.clientConstTab,needSaveConstTab);
				self:saveConstTabToFile();
            end
            self:reset()
            if table.nums(self.serverConstTab) == 0 then
            	--todo
            	callback(xhr,false);
            else
            	callback(xhr,isSuccess);
            end
            --dump(self.serverConstTab,"self.serverConstTab",1000)
            
        else
        	--每个url重连几次
            if self.retryTimes < self.maxRetryTimes then -- 重连
            	--todo
            	print("retryTimes <= maxRetryTimes")
            	self.retryTimes = self.retryTimes + 1
            	networkManager:sendHttpRequest(serverURL,parameterTab,self.versionCallback,"POST");
            else
            	--切换下一个备用的url地址
            	serverURL = self:getServerURL();
            	print("retry next url:",serverURL)
            	if serverURL ~= nil then
            		--todo
					self.retryTimes = 1;
            		networkManager:sendHttpRequest(serverURL,parameterTab,self.versionCallback,"POST");
            	else
            		self:reset()
            		callback(xhr,isSuccess);	
            	end
            end
        end
	end
	print("get config from url:",serverURL)
	networkManager:sendHttpRequest(serverURL,parameterTab,self.versionCallback,"POST");	
end
--得到服务器配置的大厅信息
function VersionManager:getHallInfoConfigTab()
	return self.clientConstTab[VersionManager.kHallInfo];
end

function VersionManager:getDownloadNewClientUrl()
	-- dump(self.serverConstTab[VersionManager.kClientInfo])
	if self.serverConstTab[VersionManager.kClientInfo] and self.serverConstTab[VersionManager.kClientInfo]["update_url"]  then
		return self.serverConstTab[VersionManager.kClientInfo]["update_url"]
	end
	return nil
end

--检测是否需要更新客户端
function VersionManager:checkIsUpdateClient()
	local serverClientInfo = self.serverConstTab[VersionManager.kClientInfo]
	if VersionManager.IsNeedCheckNewVersion == false or serverClientInfo == nil then
		--todo
		return VersionManager.UpdateStatus_NotNeed;
	end
	local clientVer = self:getVersionStr();
	local serverVer = serverClientInfo[VersionManager.kVersion];
	if clientVer ~= serverVer then
		-- --todo
		-- if serverClientInfo[VersionManager.kIsMustUpdate] == true then
		-- 	--todo
		-- 可以强制更新时，删除可选目录下client_const
		self:deleteClientConstFile()

			return VersionManager.UpdateStatus.Must;
		-- end
		-- return VersionManager.UpdateStatus.Need;
	end
	return VersionManager.UpdateStatus.NotNeed;
end
function VersionManager:isExaminState()
	local rechargeType =  self.clientConstTab["hall_info"]["config"]["recharge_types"];
	if rechargeType and device.platform == "ios" and rechargeType.iospay then
		return true;
	end
    return  false; 
end

function VersionManager:getNeedUpdateInfoTab(oldDownloadInfoTab,newDownloadInfoTab,relativePath)
	-- dump(oldDownloadInfoTab, "oldDownloadInfoTab", nesting)
	-- dump(newDownloadInfoTab, "newDownloadInfoTab", nesting)
	if self:isExaminState() then --如果在審核狀態，則直接返回，不進行更新
		--todo
		return nil;
	end
	local needUpdateTab = nil;
	if newDownloadInfoTab ~= nil then
		--todo
		for k,oneNewDownloadTab in pairs(newDownloadInfoTab) do
			if 
				oldDownloadInfoTab == nil or
				oldDownloadInfoTab[k] == nil or
			 	oneNewDownloadTab[VersionManager.kVersion] ~= oldDownloadInfoTab[k][VersionManager.kVersion] 
			then
				--todo
				local needDownloadVersionInfoTab = CustomHelper.copyTab(oneNewDownloadTab)
				if relativePath == nil then
					--todo
					relativePath = ""
				end
				needDownloadVersionInfoTab["storage_path"] = cc.FileUtils:getInstance():getWritablePath()..relativePath..k
				needDownloadVersionInfoTab["file_name"] = k
				if needUpdateTab == nil then
					--todo
					needUpdateTab = {};
				end
				table.insert(needUpdateTab,needDownloadVersionInfoTab)
			end
		end
	end
	return needUpdateTab;
end
--得到进入大厅之前需要的更新
function VersionManager:getNeedUpdateBeforeEnterHall()
	local needUpdateTab = self:getNeedUpdateInfoTabForHall();
	local needUpdateFrameTab = self:getNeedUpdateInfoTabForFrame();
	--大厅资源和frame资源整合在一起更新
	if needUpdateFrameTab ~= nil then
		--todo
		if needUpdateTab == nil then
			--todo
			needUpdateTab = {}
		end
		for i,v in ipairs(needUpdateFrameTab) do
			table.insert(needUpdateTab,v)
		end
	end
	return needUpdateTab;
end
--得到更新大厅的相关
function VersionManager:getNeedUpdateInfoTabForHall()
	if VersionManager.IsNeedCheckNewVersion == false then
		--todo
		return nil
	end
	--得到大厅需要更新的信息
	local clientHallDownInfo = self.clientConstTab[VersionManager.kHallVersionInfo];
	local serverHallDownInfo = self.serverConstTab[VersionManager.kHallVersionInfo];
	local needUpdateHallTab = self:getNeedUpdateInfoTab(clientHallDownInfo,serverHallDownInfo);
	return needUpdateHallTab;
end
--检测是否需要更新frame资源
function VersionManager:getNeedUpdateInfoTabForFrame()
	if VersionManager.IsNeedCheckNewVersion == false then
		--todo
		return nil
	end
	local clientFrameDownloadInfo = self.clientConstTab[VersionManager.kFrameVersionInfo];
	local serverFrameDownloadInfo = self.serverConstTab[VersionManager.kFrameVersionInfo];
	local needUpdateTab = self:getNeedUpdateInfoTab(clientFrameDownloadInfo,serverFrameDownloadInfo);
	self.isNeedRestartGame = false;
	if needUpdateTab ~= nil and table.nums(needUpdateTab) > 0 then
		--todo
		self.isNeedRestartGame = true;
	end
	return needUpdateTab;
end
--检测是否需要重启游戏
function VersionManager:checkIsNeedRestartGame()
	-- print("self.isNeedRestartGame:",self.isNeedRestartGame)
	return self.isNeedRestartGame;
end
--本地持久化常量文件
function VersionManager:saveConstTabToFile()
	local jsonStr = CustomHelper.getJsonStrWithJsonTab(self.clientConstTab);
	CustomHelper.writeStringToFile(jsonStr,self.saveClientConstPath)
end

function VersionManager:deleteClientConstFile()
	cc.FileUtils:getInstance():removeFile(self.saveClientConstPath)
end

--将本地大厅版本信息更新为最新的
function VersionManager:saveConstTabWhenDownloadFinishedBeforeEnterHall()
	--更新本地大厅和frame版本信息
	dump(self.clientConstTab, "self.clientConstTab", nesting)
	dump(value, desciption, nesting)
	if self.clientConstTab[VersionManager.kFrameVersionInfo] == nil then
		--todo
		self.clientConstTab[VersionManager.kFrameVersionInfo] = {};
	end
	if self.clientConstTab[VersionManager.kHallVersionInfo] == nil then
		--todo
		self.clientConstTab[VersionManager.kHallVersionInfo] = {};
	end
	CustomHelper.updateJsonTab(self.clientConstTab[VersionManager.kFrameVersionInfo],self.serverConstTab[VersionManager.kFrameVersionInfo])
	CustomHelper.updateJsonTab(self.clientConstTab[VersionManager.kHallVersionInfo],self.serverConstTab[VersionManager.kHallVersionInfo])
	-- dump(self.clientConstTab, "self.clientConstTab", nesting)
	--保存到文件
	self:saveConstTabToFile();
	--重新加载资源
	reloadGameLuaFiles();
end
--得到某个游戏是否需要更新的信息
function VersionManager:getNeedUpdateInfoTabForOneGame(gameID)
	-- body
	local gameIDKey = tostring(gameID);
	-- local localGame
	local clientGamesVersionInfo = self.clientConstTab[VersionManager.kGamesVersionInfo];
	local serverGamesVersionInfo = self.serverConstTab[VersionManager.kGamesVersionInfo];
	--
	local needUpdateTab = nil;
	if serverGamesVersionInfo ~= nil then
		--todo
		local clientGameVesionInfo = nil;
		if clientGamesVersionInfo then
			--todo
			clientGameVesionInfo = clientGamesVersionInfo[gameIDKey];
		end	
		local serverGameVersionInfo = serverGamesVersionInfo[gameIDKey];
		-- dump(clientGameVesionInfo, "clientGameVesionInfo", nesting)
		-- dump(serverGameVersionInfo, "serverGameVersionInfo", nesting)
		 needUpdateTab = self:getNeedUpdateInfoTab(clientGameVesionInfo,serverGameVersionInfo,"games/");
	end
	
	
	return needUpdateTab;
end
--下载某个游戏资源包
function VersionManager:startDownloadOneGameResZipPackage(gameID,needUpdateInfoTab,downloadGroupKey)
	return GameManager:getInstance():getDownloaderManager():startDownLoad(
			needUpdateInfoTab,
			function(groupKey)
				--下载成功后，保存本地常量
				self:saveConstTabWhenDownloadFinishedOneGame(gameID);
				print("VersionManager: save  saveConstTabWhenDownloadFinishedOneGame")
				--重新加载lua文件
				reloadGameLuaFiles()
				--发送下载完成通知
				 local event = cc.EventCustom:new(VersionManager.kNotifyName_OneGameDownloadFinished)
				 local userInfo = {};
				 userInfo["group_key"] = groupKey
    			 event.userInfo = userInfo--string.format("%d",count2)
    			 cc.Director:getInstance():getEventDispatcher():dispatchEvent(event);
			end,
			function(asset,errorStr)
				local event = cc.EventCustom:new(VersionManager.kNotifyName_OneGameDownloadError);
				local userInfo = {};
				userInfo["asset"] = asset;
				userInfo["errorStr"] = errorStr;
				event.userInfo = userInfo;
				cc.Director:getInstance():getEventDispatcher():dispatchEvent(event);
			end,
			downloadGroupKey
	);
end
--某个游戏下载完成
function VersionManager:saveConstTabWhenDownloadFinishedOneGame(gameID)
	local gameIDKey = tostring(gameID);
	local serverGameVersionInfo = self.serverConstTab[VersionManager.kGamesVersionInfo][gameIDKey];
	if self.clientConstTab[VersionManager.kGamesVersionInfo] == nil then
		--todo
		self.clientConstTab[VersionManager.kGamesVersionInfo] = {};
	end
	if self.clientConstTab[VersionManager.kGamesVersionInfo][gameIDKey] == nil then
		--todo
		self.clientConstTab[VersionManager.kGamesVersionInfo][gameIDKey] = {};
	end
	CustomHelper.updateJsonTab(self.clientConstTab[VersionManager.kGamesVersionInfo][gameIDKey],serverGameVersionInfo)
	--保存到文件
	self:saveConstTabToFile();
end
