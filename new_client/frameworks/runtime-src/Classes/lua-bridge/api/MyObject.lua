
--------------------------------
-- @module MyObject
-- @extend Ref
-- @parent_module game.fishgame2d

--------------------------------
-- 
-- @function [parent=#MyObject] SetMoveCompent 
-- @param self
-- @param #game.fishgame2d::MoveCompent 
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetOwner 
-- @param self
-- @return fishgame2d::MyObject#fishgame2d::MyObject ret (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] SetOwner 
-- @param self
-- @param #game.fishgame2d::MyObject p
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] OnMoveEnd 
-- @param self
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetMoveCompent 
-- @param self
-- @return fishgame2d::MoveCompent#fishgame2d::MoveCompent ret (return value: game.fishgame2d::MoveCompent)
        
--------------------------------
-- 
-- @function [parent=#MyObject] SetId 
-- @param self
-- @param #unsigned long newId
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] OnClear 
-- @param self
-- @param #bool 
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] SetManager 
-- @param self
-- @param #game.fishgame2d::FishObjectManager manager
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetTypeID 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#MyObject] AddEffect 
-- @param self
-- @param #game.fishgame2d::Effect 
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetTarget 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#MyObject] SetTypeID 
-- @param self
-- @param #int typeId
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetDirection 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- 
-- @function [parent=#MyObject] SetState 
-- @param self
-- @param #int 
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] SetDirection 
-- @param self
-- @param #float dir
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] Clear 
-- @param self
-- @param #bool 
-- @param #bool noCleanNode
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetId 
-- @param self
-- @return unsigned long#unsigned long ret (return value: unsigned long)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetManager 
-- @param self
-- @return fishgame2d::FishObjectManager#fishgame2d::FishObjectManager ret (return value: game.fishgame2d::FishObjectManager)
        
--------------------------------
-- 
-- @function [parent=#MyObject] AddBuff 
-- @param self
-- @param #int buffType
-- @param #float buffParam
-- @param #float buffTime
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetState 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#MyObject] ExecuteEffects 
-- @param self
-- @param #game.fishgame2d::MyObject pTarget
-- @param #array_table list
-- @param #bool bPretreating
-- @return array_table#array_table ret (return value: array_table)
        
--------------------------------
-- 
-- @function [parent=#MyObject] SetTarget 
-- @param self
-- @param #int i
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
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
-- @function [parent=#MyObject] SetPosition 
-- @param self
-- @param #float x
-- @param #float y
-- @return fishgame2d::MyObject#fishgame2d::MyObject self (return value: game.fishgame2d::MyObject)
        
--------------------------------
-- 
-- @function [parent=#MyObject] InSideScreen 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#MyObject] GetPosition 
-- @param self
-- @return vec2_table#vec2_table ret (return value: vec2_table)
        
return nil
