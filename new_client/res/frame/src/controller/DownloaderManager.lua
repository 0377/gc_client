DownloaderManager = class("DownloaderManager")
DownloaderManager.kTotalSize 			= "kTotalSize"
DownloaderManager.kTotalDownloadSize 	= "kTotalDownloadSize"
DownloaderManager.kAssetArray			= "assetArray"
DownloaderManager.kFinishCallback		= "finisehdCallback"
DownloaderManager.kErrorCallback		= "errorCallback"
DownloaderManager.kRetryMaxTimes		= 3;--重试次数，超过次数仍未成功，则返回错误异常
function DownloaderManager:ctor()
	self.downloader = myLua.MyDownloader:create();
	self.downloader:retain();
	self.downloader:addProgressCallback(function(asset,total,download)
		self:onProgress(asset,total,download);
	end);
	self.downloader:addFinishedCallback(function(asset)
		self:onDownloadFinished(asset);
	end);
	self.downloader:addErrorCallback(function(asset,error)
		print("download error url:",asset:getSrcUrl(),",error:",error);
		self:onDownloadError(asset,error);
	end);
	self.downloadGroupMap = {};
	self.groupIndex = 1;
end
function DownloaderManager:destory()
	self.downloader:reset();
	self.downloader:release();
	self.downloader = nil;
end
--准备下载
function DownloaderManager:startDownLoad(needDownloadInfoTab,finisehdCallback,errorCallback,groupKey)
	if groupKey == nil then
		--todo
		self.groupIndex = self.groupIndex + 1;
		groupKey = tostring(self.groupIndex);
	end
	local assetArray = {};
	local totalSize = 0;
	for i,v in ipairs(needDownloadInfoTab) do
		local asset = myLua.MyAsset:create();
		asset:retain();
		local fileName = v["file_name"];
		local downloadURL = v["update_url"];
		asset:setSrcUrl(downloadURL);
		asset:setStoragePath(v["storage_path"]);
		asset:setCustomId(groupKey..downloadURL);
		asset:setDownloadeTimes(0);
		asset:setGroup(groupKey);
		asset.download = 0;
		asset.fileName = fileName;
		asset.md5 = v["md5"];
		totalSize = totalSize + v["size"];
		table.insert(assetArray,asset);
		dump(v, "v = ", nesting);
	end

	local groupInfoTab = {};
	self.downloadGroupMap[groupKey] = groupInfoTab
	groupInfoTab[DownloaderManager.kAssetArray] = assetArray;
	groupInfoTab[DownloaderManager.kTotalSize] = totalSize;
	groupInfoTab[DownloaderManager.kTotalDownloadSize] = 0;
	groupInfoTab[DownloaderManager.kFinishCallback] = finisehdCallback;
	groupInfoTab[DownloaderManager.kErrorCallback] = errorCallback;
	-- groupInfoTab["callback"] = callback
	if table.nums(assetArray) > 0 then
		--todo
		local asset = assetArray[1];
		self:startDownloadWithAsset(asset);
	end
	return groupKey;
end
--清除数据
function DownloaderManager:cleanDonwloadInfoDataWithGroupKey(groupKey)
	local groupInfoTab = self.downloadGroupMap[groupKey];
	if groupInfoTab then
		local assetArray = groupInfoTab[DownloaderManager.kAssetArray];
		while table.nums(assetArray) > 0 do
			--todo
			local asset = assetArray[1];
			CustomHelper.removeItem(assetArray,asset);
			asset:release();
		end
	end
end
function DownloaderManager:startDownloadWithAsset(asset)
	print("DownloaderManager:startDownloadWithAsset")
	asset:setDownloadeTimes(asset:getDownloadeTimes() + 1);
	self.downloader:startDownload(asset);
end
--下载进度
function DownloaderManager:onProgress(asset,total,download)
	-- print("asset:",asset:getCustomId(),"total:",total,",download:",download,",group:",asset:getGroup(),",asset download:",asset.download)
	local groupKey = asset:getGroup();
	local groupInfoTab = self.downloadGroupMap[groupKey];
	-- dump(self.downloadGroupMap, "self.downloadGroupMap", nesting)
	--更新该组进度
	if groupInfoTab then
		groupInfoTab[DownloaderManager.kTotalDownloadSize] = groupInfoTab[DownloaderManager.kTotalDownloadSize] - asset.download + download;
		asset.download = download;
		self.downloadGroupMap[groupKey] = groupInfoTab
	end
end
---某个文件下载完成
function DownloaderManager:onDownloadFinished(asset)
	local groupKey = asset:getGroup();
	local groupInfoTab = self.downloadGroupMap[groupKey];
	local fileMD5Str = string.upper(CustomHelper.md5File(asset:getStoragePath()));
	if groupInfoTab then
		--todo
		local assetArray = groupInfoTab[DownloaderManager.kAssetArray];
		--判断md5是否一致
		local md5Str = string.upper(asset.md5);
		print("fileMD5Str:",fileMD5Str,",serverMD5:",md5Str)
		if md5Str ~= nil and md5Str == fileMD5Str then
			--todo
			--下载成功 --判断是否需要解压
			local fileName = asset.fileName
			if string.find(fileName,".zip") ~= nil then
				--todo
				--解压
				local storePath = asset:getStoragePath();
				asset.decompressTime = 1;
				print("start decompress   fileName:",storePath)
				local decompressCallback = function(status,percent)
			    	if status == "succeed" and  asset.isDecompressFinished == nil then --防止进入两次
			    		asset.isDecompressFinished = true;
			    		cc.FileUtils:getInstance():removeFile(storePath);
			    		print("end decompress fileName:",fileName)
			    		self:checkIsNeedContinueDownload(asset);
			    	elseif status == "failed" then -- 解压失败，重新在解压一次
			    		--todo
			    		if asset.decompressTime > 3 then
			    			--todo
			    			self:onDownloadError(asset,"文件异常，请重新下载");
			    		else
			    			myLua.LuaBridgeUtils:decompressAsync(
								storePath,
								decompressCallback
							)
							asset.decompressTime = asset.decompressTime + 1;
			    		end
			    	end
				end
				myLua.LuaBridgeUtils:decompressAsync(
					storePath,
					decompressCallback
				);
			else
				self:checkIsNeedContinueDownload(asset);
			end
		else --下载的文件有错
			local errorStr = "download file md5 is not equal to server md5";
			print(errorStr)
			if asset:getDownloadeTimes() >= DownloaderManager.kRetryMaxTimes then
				--todo
				self:onDownloadError(asset,errorStr);
			else -- 继续重试
				self:startDownloadWithAsset(asset);
			end
		end
	end
end
function DownloaderManager:checkIsNeedContinueDownload(asset)
	local groupKey = asset:getGroup();
	local groupInfoTab = self.downloadGroupMap[groupKey];
	local fileMD5Str = string.upper(CustomHelper.md5File(asset:getStoragePath()));
	if groupInfoTab then
		--todo
		local assetArray = groupInfoTab[DownloaderManager.kAssetArray];
		CustomHelper.removeItem(assetArray,asset)
		if table.nums(assetArray) >0 then --还有文件没有下载，继续下载
			local nextAsset = assetArray[1];
			self.downloader:startDownload(nextAsset);
		--todo
		else--所有文件下载完成
			local finishdCallback = groupInfoTab[DownloaderManager.kFinishCallback];
			if finishdCallback then
				--todo
				finishdCallback(asset:getGroup())
			end
			self.downloadGroupMap[groupKey] = nil;
		end
	end
	print("groupKey:",groupKey,"assetName:",asset:getCustomId())
	asset:release();
end
--回调错误异常捕获函数
function DownloaderManager:onDownloadError(asset,errorStr)
	local groupKey = asset:getGroup();
	local groupInfoTab = self.downloadGroupMap[groupKey];
	if groupInfoTab then
		local errorCallback = groupInfoTab[DownloaderManager.kErrorCallback];
		if errorCallback then
			--todo
			errorCallback(asset,errorStr);
		end
	end
end
function DownloaderManager:getDownloadInfoWithGroupKey(groupKey)
	local groupInfoTab = self.downloadGroupMap[groupKey];
	return groupInfoTab
end
function DownloaderManager:reset()
	-- self.downloader:reset()
end
return DownloaderManager;