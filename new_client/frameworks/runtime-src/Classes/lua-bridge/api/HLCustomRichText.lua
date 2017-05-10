
--------------------------------
-- @module HLCustomRichText
-- @extend ScrollView,LableDelegate
-- @parent_module myLua

--------------------------------
-- brief Insert a HLCustomRichText at a given index.<br>
-- param element A HLCustomRichText type.<br>
-- param index A given index.
-- @function [parent=#HLCustomRichText] insertElement 
-- @param self
-- @param #ccui.HLCustomRichElement element
-- @param #int index
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] enableShadow 
-- @param self
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- brief Add a HLCustomRichText at the end of HLCustomRichText.<br>
-- param element A HLCustomRichText instance.
-- @function [parent=#HLCustomRichText] pushBackElement 
-- @param self
-- @param #ccui.HLCustomRichElement element
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] getShowTextStr 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- brief Set vertical space between each HLCustomRichText.<br>
-- param space Point in float.
-- @function [parent=#HLCustomRichText] setVerticalSpace 
-- @param self
-- @param #float space
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] setTextVerticalAlign 
-- @param self
-- @param #int var
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] getTextVerticalAlign 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] setShowTextStr 
-- @param self
-- @param #string var
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] setTextHorizontalAlign 
-- @param self
-- @param #int var
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] formatText 
-- @param self
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] labelClicked 
-- @param self
-- @param #ccui.LinkLabel lab
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] getMaxWidthForAllElement 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- @overload self, ccui.HLCustomRichElement         
-- @overload self, int         
-- @function [parent=#HLCustomRichText] removeElement
-- @param self
-- @param #int index
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)

--------------------------------
-- 
-- @function [parent=#HLCustomRichText] getTextHorizontalAlign 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- brief Create a empty HLCustomRichText.<br>
-- return HLCustomRichText instance.
-- @function [parent=#HLCustomRichText] create 
-- @param self
-- @return HLCustomRichText#HLCustomRichText ret (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] setAnchorPoint 
-- @param self
-- @param #vec2_table pt
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] onEnter 
-- @param self
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] ignoreContentAdaptWithSize 
-- @param self
-- @param #bool ignore
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] getDescription 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] init 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#HLCustomRichText] getVirtualRendererSize 
-- @param self
-- @return size_table#size_table ret (return value: size_table)
        
--------------------------------
-- brief Default constructor.
-- @function [parent=#HLCustomRichText] HLCustomRichText 
-- @param self
-- @return HLCustomRichText#HLCustomRichText self (return value: ccui.HLCustomRichText)
        
return nil
