-------------------------------------------------------------------------
-- Desc:    二人梭哈游戏数据管理器私人房
-- Author:  zengzx
-- Date:    2017.5.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHGameDataPrivateManager = class("SHGameDataPrivateManager",requireForGameLuaFile("SHGameDataBaseManager"))


function SHGameDataPrivateManager:ctor()
	SHGameDataPrivateManager.super.ctor(self)
end

return SHGameDataPrivateManager