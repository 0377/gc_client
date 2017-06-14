-------------------------------------------------------------------------
-- Desc:    二人梭哈游戏数据管理器普通房
-- Author:  zengzx
-- Date:    2017.5.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHGameDataNormalManager = class("SHGameDataNormalManager",requireForGameLuaFile("SHGameDataBaseManager"))


function SHGameDataNormalManager:ctor()
	SHGameDataNormalManager.super.ctor(self)
end

return SHGameDataNormalManager