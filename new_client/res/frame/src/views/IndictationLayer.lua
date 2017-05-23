local IndictationLayer = class("IndictationLayer",cc.Node);
IndictationLayer.instance = nil;
function IndictationLayer:getInstance()
	if IndictationLayer.instance == nil then
		--todo
		IndictationLayer.instance = IndictationLayer:create();
		IndictationLayer.instance:retain();
	end
	return IndictationLayer.instance;
end
function IndictationLayer:ctor()
    local CCSLuaNode =  requireForGameLuaFile("IndicationLayerCCS")
    self.csNode = CCSLuaNode:create().root;

    self.bgView = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"bg_view"),"ccui.Widget")
    self:addChild(self.csNode);
    --旋转图标
    self.indictationNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_1"), "ccui.ImageView");
    self.indictationNodeAc = cc.RotateBy:create(1.0, 360);
    self.indictationNodeAc:retain();
    -- self.indictationNode:runAction();
    --提示内容
    self.tipText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "tipText"), "ccui.Text");
end
--
function IndictationLayer:addIndicationTip(tipStr,parent,delay)
	self.tipText:setString(tipStr);
	if self:getParent() ~= nil then
		--todo
		self:removeSelf();
	end
	if parent == nil then
		--todo
		parent = cc.Director:getInstance():getRunningScene();
	end
	if delay == nil then
		--todo
		delay = 1.0;
	end
	parent:addChild(self,1000);
	--默认隐藏，1s后显示
	self:setVisible(true);
	self.bgView:setVisible(false);
	local ac = cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function()
		-- body
			self.bgView:setVisible(true);
		end)
	);
	self.tipText:setString(tipStr);
	self.indictationNode:stopAllActions();
	self.indictationNode:runAction(cc.RepeatForever:create(self.indictationNodeAc))
	self.bgView:runAction(ac)
end
function IndictationLayer:removeIndicationTip()
	self:setVisible(false);
	self.indictationNode:stopAllActions();
	self.bgView:stopAllActions();
end
return IndictationLayer;