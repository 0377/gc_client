
--------------------------------
-- @module NetworkManager
-- @extend Node
-- @parent_module myLua

--------------------------------
-- 
-- @function [parent=#NetworkManager] disconnect 
-- @param self
-- @param #int connectionID
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#NetworkManager] sendTCPMsg 
-- @param self
-- @param #int connectionID
-- @param #int msgID
-- @param #string msgPbBufferStr
-- @return NetworkManager#NetworkManager self (return value: NetworkManager)
        
--------------------------------
-- 
-- @function [parent=#NetworkManager] getTCPConnectionStatus 
-- @param self
-- @param #int connectionID
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#NetworkManager] init 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#NetworkManager] connectTCPSocket 
-- @param self
-- @param #string addr
-- @param #string port
-- @param #int connctionID
-- @param #float timeout
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#NetworkManager] create 
-- @param self
-- @return NetworkManager#NetworkManager ret (return value: NetworkManager)
        
--------------------------------
-- 
-- @function [parent=#NetworkManager] NetworkManager 
-- @param self
-- @return NetworkManager#NetworkManager self (return value: NetworkManager)
        
return nil
