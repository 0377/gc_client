
--------------------------------
-- @module MyObject
-- @extend Node
-- @parent_module game.fishgame2d

--------------------------------
-- 
-- @function [parent=#MyObject] setMoveCompent 
-- @param self
-- @param #game.fishgame2d.MoveCompent 
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] getId 
-- @param self
-- @return unsigned long#unsigned long ret (return value: unsigned long)
        
--------------------------------
-- 
-- @function [parent=#MyObject] setTypeId 
-- @param self
-- @param #int typeId
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] OnMoveEnd 
-- @param self
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] OnClear 
-- @param self
-- @param #bool 
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] setState 
-- @param self
-- @param #int 
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] getTypeId 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#MyObject] AddEffect 
-- @param self
-- @param #game.fishgame2d.Effect 
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetTarget 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#MyObject] getMoveCompent 
-- @param self
-- @return MoveCompent#MoveCompent ret (return value: game.fishgame2d.MoveCompent)
        
--------------------------------
-- 
-- @function [parent=#MyObject] getManager 
-- @param self
-- @return FishObjectManager#FishObjectManager ret (return value: game.fishgame2d.FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#MyObject] getState 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#MyObject] Clear 
-- @param self
-- @param #bool 
-- @param #bool noCleanNode
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] AddBuff 
-- @param self
-- @param #int buffType
-- @param #float buffParam
-- @param #float buffTime
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] registerStatusChangedHandler 
-- @param self
-- @param #int 
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] ExecuteEffects 
-- @param self
-- @param #game.fishgame2d.MyObject pTarget
-- @param #array_table list
-- @param #bool bPretreating
-- @return array_table#array_table ret (return value: array_table)
        
--------------------------------
-- 
-- @function [parent=#MyObject] SetTarget 
-- @param self
-- @param #int i
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetType 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#MyObject] OnUpdate 
-- @param self
-- @param #float fdt
-- @param #bool shouldUpdate
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#MyObject] setId 
-- @param self
-- @param #unsigned long newId
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] InSideScreen 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#MyObject] setManager 
-- @param self
-- @param #game.fishgame2d.FishObjectManager manager
-- @return MyObject#MyObject self (return value: game.fishgame2d.MyObject)
        
return nil
