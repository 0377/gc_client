
VersionModel = class("VersionModel")

local instance
function VersionModel:getInstance()
	if instance == nil then 
		instance = VersionModel.new()
	end
	return instance
end

function VersionModel:cleanUp()
	instance = nil
end

function VersionModel:ctor()
	self._data = CustomHelper.createJsonTabWithFilePath(cc.FileUtils:getInstance():fullPathForFilename(VersionManager.kSaveClientConstFileName))
end

function VersionModel:getFrameResVersion()
	local version = "1.0.0"
	if self._data and 
		self._data["frame_download_info"] and 
		self._data["frame_download_info"]["frame_res.zip"] and 
		self._data["frame_download_info"]["frame_res.zip"]["version"] then
		version =  self._data["frame_download_info"]["frame_res.zip"]["version"]
	end

	if  type(version) ~= "string" then
		version = "1.0.0"
	end

	return version
end

function VersionModel:getFrameSrcVersion()
	local version = "1.0.0"
	if self._data and 
		self._data["frame_download_info"] and 
		self._data["frame_download_info"]["frame_src.zip"] and 
		self._data["frame_download_info"]["frame_src.zip"]["version"] then
		version =  self._data["frame_download_info"]["frame_src.zip"]["version"]
	end

	if  type(version) ~= "string" then
		version = "1.0.0"
	end

	return version
end

function VersionModel:getHallResVersion()
	local version = "1.0.0"
	if self._data and 
		self._data["hall_download_info"] and 
		self._data["hall_download_info"]["hall_res.zip"] and 
		self._data["hall_download_info"]["hall_res.zip"]["version"] then
		version =  self._data["hall_download_info"]["hall_res.zip"]["version"]
	end

	if  type(version) ~= "string" then
		version = "1.0.0"
	end

	return version
end

function VersionModel:getHallSrcVersion()
	local version = "1.0.0"
	if self._data and 
		self._data["hall_download_info"] and 
		self._data["hall_download_info"]["hall_src.zip"] and 
		self._data["hall_download_info"]["hall_src.zip"]["version"] then
		version =  self._data["hall_download_info"]["hall_src.zip"]["version"]
	end

	if  type(version) ~= "string" then
		version = "1.0.0"
	end

	return version
end

function VersionModel:getGameResVersion(gameId)
	local version = "1.0.0"
	if self._data and 
		self._data["games_download_info"] and 
		self._data["games_download_info"][tostring(gameId)] then
		for k, v in pairs(self._data["games_download_info"][tostring(gameId)]) do
			if string.find(k, "res.zip") ~= nil then
				version = v["version"]
			end
		end
	end

	if  type(version) ~= "string" then
		version = "1.0.0"
	end

	return version
end

function VersionModel:getGameSrcVersion(gameId)
	local version = "1.0.0"
	if self._data and 
		self._data["games_download_info"] and 
		self._data["games_download_info"][tostring(gameId)] then
		for k, v in pairs(self._data["games_download_info"][tostring(gameId)]) do
			if string.find(k, "src.zip") ~= nil then
				version = v["version"]
			end
		end
	end

	if  type(version) ~= "string" then
		version = "1.0.0"
	end

	return version
end

function VersionModel:getVerionStr()
	return "v4"
end

return VersionModel