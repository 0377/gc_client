
--------------------------------
-- @module FishObjectManager
-- @extend Ref
-- @parent_module game.fishgame2d

--------------------------------
-- 
-- @function [parent=#FishObjectManager] GetPathManager 
-- @param self
-- @return PathManager#PathManager ret (return value: game.fishgame2d.PathManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] FindFish 
-- @param self
-- @param #unsigned long 
-- @return Fish#Fish ret (return value: game.fishgame2d.Fish)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] Init 
-- @param self
-- @param #int 
-- @param #int 
-- @param #string 
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] GetClientHeight 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] IsSwitchingScene 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] MirrowShow 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] FindBullet 
-- @param self
-- @param #unsigned long id
-- @return Bullet#Bullet ret (return value: game.fishgame2d.Bullet)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] SetGameLoaded 
-- @param self
-- @param #bool b
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] AddFishBuff 
-- @param self
-- @param #int buffType
-- @param #float buffParam
-- @param #float buffTime
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] RemoveAllBullets 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] SetSwitchingScene 
-- @param self
-- @param #bool b
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] Clear 
-- @param self
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] IsGameLoaded 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] RemoveAllFishes 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] AddFish 
-- @param self
-- @param #game.fishgame2d.Fish pFish
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] TestHitFish 
-- @param self
-- @param #float x
-- @param #float y
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] ConvertCoord 
-- @param self
-- @param #float 
-- @param #float 
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] GetAllFishes 
-- @param self
-- @return array_table#array_table ret (return value: array_table)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] AddBullet 
-- @param self
-- @param #game.fishgame2d.Bullet pBullet
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] OnUpdate 
-- @param self
-- @param #float dt
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] GetClientWidth 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] ConvertDirection 
-- @param self
-- @param #float 
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] SetMirrowShow 
-- @param self
-- @param #bool 
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] ConvertMirrorCoord 
-- @param self
-- @param #float 
-- @param #float 
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] DestroyInstance 
-- @param self
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] DestoryInstace 
-- @param self
-- @return FishObjectManager#FishObjectManager self (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#FishObjectManager] GetInstance 
-- @param self
-- @return FishObjectManager#FishObjectManager ret (return value: game.fishgame2d.FishObjectManager)
        
return nil
