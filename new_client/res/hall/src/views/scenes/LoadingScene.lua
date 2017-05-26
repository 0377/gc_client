local LoadingScene = class("LoadingScene", cc.load("mvc").ViewBase)

LoadingScene._TipsTab = {
    [1] = "运气不佳时，试试等一会儿再下注。",
    [2] = "下注前记得看一看记录，研究走势哦。",
    [3] = "下注稳、准、狠，赢的快、多、爽。",
    [4] = "玩游戏不仅靠运气，也靠好心态。",
    [5] = "大注大赢，小注小赢，不下注伤身。",
    [6] = "一炮富，一注富，一把牌也能富。",
    [7] = "想赢更多么？试一试加大下注吧。",
    [8] = "敢拼才会赢，敢下才会赢更多。"
}

function LoadingScene:ctor(needLoadResArray,finishCallback, infoTab)
    local CCSLuaNode =  requireForGameLuaFile("LoadingLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    --增加提示动画
    local helpTipText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "tips_text"), "ccui.Text");
    helpTipText:setString("小贴士：" .. LoadingScene._TipsTab[math.random(1, #LoadingScene._TipsTab)])
    self.progressBarNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "progress_bar"), "ccui.LoadingBar");
    --进度条箭头端动画
    self.progressArrow = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "progress_arrow"), "ccui.ImageView");
    --预加载资源的序列号
    self.preLoadResIndex = 0;
    self.needLoadResArray = needLoadResArray;
    self.finishCallback = finishCallback;
    self.maxNeedPreloadResNum = #needLoadResArray;
    LoadingScene.super.ctor(self)
    dump(needLoadResArray, "needLoadResArray", nesting)
    self:showProgressPercent(0)

    -- verion
    if (infoTab and infoTab["id"] and infoTab["id"] > 0) then
    	self._versionStr = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_Version"), "ccui.Text")
    	self._versionStr:setString(string.format("version:%s/%s", VersionModel:getInstance():getGameResVersion(infoTab["id"]), VersionModel:getInstance():getGameSrcVersion(infoTab["id"])))
    end
end
function LoadingScene:onEnter()
	--print("LoadingScene:onEnter()")
end
function LoadingScene:onExit()
	--print("LoadingScene:onExit()")
	---释放掉
	if self._scheduler~=nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)   
        self._scheduler = nil
    end
end
function LoadingScene:onEnterTransitionFinish()
	--print("LoadingScene:onEnterTransitionFinish()")
	CustomHelper.cleanMemeryCache();
	local seq = cc.Sequence:create(cc.DelayTime:create(0.01),cc.CallFunc:create(function()
		self:preLoadRes()
	end));
	---如果6秒没加载完成 就直接跳过
	self._scheduler =  CustomHelper.performWithDelayGlobal(function (dt)
		self:showProgressPercent(100);
		if self._scheduler~=nil then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)   
        	self._scheduler = nil
		end
	end,6,false)
	self:runAction(seq)
end
function LoadingScene:preLoadRes()
	local percent = 0;
	local nextIndex = self.preLoadResIndex + 1;
	if self.needLoadResArray and table.nums(self.needLoadResArray) > 0 and nextIndex <= self.maxNeedPreloadResNum then
		--todo
		local resPath = self.needLoadResArray[self.preLoadResIndex]
		local  textureCache = cc.Director:getInstance():getTextureCache();
		local resPath = self.needLoadResArray[nextIndex]
		--print("resPath:",resPath)
		if resPath ~= "" then
			--todo
			if string.find(resPath,".ExportJson") then
				--todo
				--print("resPath:ExportJson:",resPath)
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(resPath,function()
					self.preLoadResIndex = self.preLoadResIndex + 1;
					self:preLoadRes();
				end)
			else
			    --print("png path:",resPath)
				textureCache:addImageAsync(resPath,function(texture)
					self.preLoadResIndex = self.preLoadResIndex + 1;
					self:preLoadRes();
				end)
			end
		else
			self.preLoadResIndex = self.preLoadResIndex + 1;
			self:preLoadRes();
		end
		--
		percent = self.preLoadResIndex/(self.maxNeedPreloadResNum*1.0) * 100
	else -- 直接加载完成
		percent = 100;
	end
	self:showProgressPercent(percent);
end
function LoadingScene:showProgressPercent(percent)
	-- print("LoadingScene:showProgressPercent:",percent)
	self.progressBarNode:setPercent(percent);
	
	self.progressArrow:setScaleX(math.min(1,self.progressBarNode:getContentSize().width * percent / 100 /self.progressArrow:getContentSize().width ))
	self.progressArrow:setPositionX(math.min(self.progressBarNode:getContentSize().width * percent / 100 + 22 ,self.progressBarNode:getContentSize().width))
	self.progressArrow:setVisible(self.progressArrow:getPositionX() > 55)




	if percent >= 100 and self.isFinish == nil then
		--todo
		self.isFinish = true
		local seq = cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(function()
			self.finishCallback();
		end));
		self:runAction(seq)
	end
end

function LoadingScene:showVersion(resVersion, srcVersion)
	self._versionStr:setString(string.format("version:%s/%s", resVersion, srcVersion))
end

return LoadingScene