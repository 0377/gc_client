-------------------------------------------------------------------------
-- Desc:    
-- Author:  cruelogre
-- Date:    2017.03.15
-- Last: 
-- Content:  二级界面的通用基类节点
-- Modify:
-- Copyright (c) shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SecondaryBaseNode = class("SecondaryBaseNode",ccui.Layout)

function SecondaryBaseNode:ctor()
	
	--self:initViewData(secondRoomInfoTab,clickCallback)
	-- self:initViewData(secondRoomInfoTab,clickCallback)

end

function SecondaryBaseNode:initViewData(secondRoomInfoTab)
	--todo nothing
	self.secondRoomInfoTab = secondRoomInfoTab
	self.selectBtn = tolua.cast(CustomHelper.seekNodeByName(self, "selected_btn"), "ccui.Button");
	self.selectBtn:setSwallowTouches(false)
end

-- function SecondaryBaseNode:selectNode()
-- 	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
-- 	if self.clickCallback then
-- 		self.clickCallback()
-- 	end
-- end

return SecondaryBaseNode