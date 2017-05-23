local CustomBaseView = requireForGameLuaFile("CustomBaseView")

local zhaoshang = CustomHelper.getOneHallGameConfigValueWithKey("agents_zhaoshang")

local RechargeDlzsLayer = class("RechargeDlzsLayer", CustomBaseView)
function RechargeDlzsLayer:ctor()
	-- self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("RechargeDlzsLayerCCS.csb"));
	local CCSLuaNode =  requireForGameLuaFile("RechargeDlzsLayerCCS")
	self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
 
    self:initView();
	RechargeDlzsLayer.super.ctor(self);
end
function RechargeDlzsLayer:initView()
	local PayHelper = requireForGameLuaFile("PayHelper")
	if zhaoshang.qq then
		for i=1,4 do
			local text = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "qq_text_"..i), "ccui.Text")
			local button = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_lx_"..i), "ccui.Button")
			local img = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "qq_bg_"..i), "ccui.ImageView")
			if zhaoshang.qq[i] then
			
				text:setString(tostring(zhaoshang.qq[i]));
				button:addClickEventListener(function()
					GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
					if PayHelper.copyStrToShearPlate(self,zhaoshang.qq[i]) then
						MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "QQ已复制到剪贴板")
					end
					PayHelper.callQQChat(zhaoshang.qq[i])
				end);
				
			else
				text:setVisible(false);
				button:setVisible(false);
				img:setVisible(false)
			end
				
		end
	end
	
	if zhaoshang.weixin then
		for i=1,4 do
			local text = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "wx_text_"..i), "ccui.Text")
			local button = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_fz_"..i), "ccui.Button")
			local img = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "wx_bg_"..i), "ccui.ImageView")
			if zhaoshang.weixin[i] then
				text:setString(tostring(zhaoshang.weixin[i]))
				button:addClickEventListener(function()
					GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
					if PayHelper.copyStrToShearPlate(self,zhaoshang.weixin[i]) then
						MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "微信账号已复制到剪贴板")
					end
				end);
				
			else
				text:setVisible(false);
				button:setVisible(false);
				img:setVisible(false)
			end
				
		end
	end
end

return RechargeDlzsLayer;