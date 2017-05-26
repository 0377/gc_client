
local PrivateRoomModel = class("PrivateRoomModel")

local instance
function PrivateRoomModel:getInstance()
	-- print("[PrivateRoomModel] getInstance")
	if instance == nil then 
		instance = PrivateRoomModel:create()
	end
	return instance
end

PrivateRoomModel.MoneyNotEnoughType = 
    {
        ["NONE"] = 0,
        ["CREATE_PRIVATE_ROOM_ALL"] = 16,		
		["CREATE_PRIVATE_ROOM_BANK"] = 17,		
		["CREATE_PRIVATE_ROOM_MONEY"] = 18,		
        ["JOIN_PRIVATE_ROOM_ALL"] = 19,
        ["JOIN_PRIVATE_ROOM_BANK"] = 20,
        ["JOIN_PRIVATE_ROOM_MONEY"] = 21
    }

PrivateRoomModel.OperateType = 
	{
		["NONE"] = 0,
		["ENTER_PRIVATE_ROOM"] = 1,
		["CREATE_PRIVATE_ROOM"] = 2
	}

function PrivateRoomModel:ctor()
	-- print("[PrivateRoomModel] ctor")
	self._data = {}

	self._data.info = {}

	self._data.gameIdInfo = 
	{
		[HallGameConfig.game.ID_DDZGame] = {["img"] = "hall_res/private_game_room/bb_srfj_xzyx_ddz.png"},
		[HallGameConfig.game.ID_FISHGAME] = {["img"] = "hall_res/private_game_room/bb_srfj_xzyx_lkpy.png"},
		[HallGameConfig.game.ID_GFLOWER] = {["img"] = "hall_res/private_game_room/bb_srfj_xzyx_zjh.png"},
		[HallGameConfig.game.ID_BRNNGame] = {["img"] = "hall_res/private_game_room/bb_srfj_xzyx_brnn.png"},
		[HallGameConfig.game.ID_DZPKGame] = {["img"] = "hall_res/private_game_room/bb_srfj_xzyx_dzpk.png"},
		[HallGameConfig.game.ID_LHJGame] = {["img"] = "hall_res/private_game_room/bb_srfj_xzyx_lhj.png"},
		[HallGameConfig.game.ID_TMJGame] = {["img"] = "hall_res/private_game_room/bb_srfj_xzyx_ermj.png"},
	}

	self._data.gtype = 0
	self._data.playerNum = 0
	self._data.betMin = 0
end

function PrivateRoomModel:cleanUp()
	instance = nil
end

function PrivateRoomModel:setInfo(data)
	self._data.info = data or {}
	self:createDefaultGtype()
end

function PrivateRoomModel:getInfo()
	return self._data.info
end

function PrivateRoomModel:getImgByGtype(gtype)
	-- print("[PrivateRoomModel] getImgByGtype:%d", gtype)
	if self._data.gameIdInfo[gtype] ~= nil then
		return self._data.gameIdInfo[gtype]["img"]
	end
	return ""
end

function PrivateRoomModel:createDefaultGtype()
	for _, v in ipairs(self._data.info) do
		self:setSelectedGtype(v["first_game_type"])
		self:setSelectedPlayerNum(v["table_count"][1])
		self:setSelectedBetMin(v["cell_money"][1])
		break
	end
end

function PrivateRoomModel:getSelectedGtype()
	-- print("[PrivateRoomModel] getSelectedGtype gtype:%d", self._data.gtype)
	return self._data.gtype
end

function PrivateRoomModel:setSelectedGtype(gtype)
	self._data.gtype = gtype
	-- print("[PrivateRoomModel] setSelectedGtype gtype:%d", self._data.gtype)
	for _, v in ipairs(self._data.info) do
		if v["first_game_type"] == gtype then
			self:setSelectedPlayerNum(v["table_count"][1])
			self:setSelectedBetMin(v["cell_money"][1])
		end
	end
end

function PrivateRoomModel:getSelectedPlayerNum()
	return self._data.playerNum
end

function PrivateRoomModel:setSelectedPlayerNum(num)
	self._data.playerNum = num
end

function PrivateRoomModel:getSelectedBetMin()
	return self._data.betMin
end

function PrivateRoomModel:setSelectedBetMin(betMin)
	self._data.betMin = betMin
end

function PrivateRoomModel:getBetMinIndex(gtype, betMin)
	local data = self:getInfoByGtype(gtype)
	for i, v in ipairs(data["cell_money"]) do
		if v == betMin then
			return i
		end
	end
end

function PrivateRoomModel:getInfoByGtype(gtype)
	for _, v in ipairs(self._data.info) do
		if v["first_game_type"] == gtype then
			return v
		end
	end
end

return PrivateRoomModel