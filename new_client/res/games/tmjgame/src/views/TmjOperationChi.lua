-------------------------------------------------------------------------
-- Desc:    二人麻将操作节点 吃节点
-- Author:  zengzx
-- Date:    2017.4.24
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjOperationChi = class("TmjOperationChi",requireForGameLuaFile("TmjOperationWidget"))
local TmjCard = requireForGameLuaFile("TmjCard")
local TmjConfig = import("..cfg.TmjConfig")
function TmjOperationChi:ctor(operationData,chooseFun)
	TmjOperationChi.super.ctor(self,operationData,chooseFun)
end
--@pram operationData 操作数据
--@key orientation 方向  1 横向 horizontal		2 纵向 vertical
--@key data 可操作的数据集合
function TmjOperationChi:initView(operationData)

	local node = requireForGameLuaFile("TmjChiOperationNodeCCS"):create()
	self:addChild(node.root)
	node.root:runAction(node.animation)
	self:setContentSizeForData(node.root,operationData.orientation or 2,table.nums(operationData.data))
	node.animation:play(self:getAnimation(operationData.orientation or 2,table.nums(operationData.data)),true)
	
	CustomHelper.seekNodeByName(node.root,"Image_tag"):addTouchEventListener(handler(self,self.touchListener))
	
	for index,data in pairs(operationData.data) do
		local img = CustomHelper.seekNodeByName(node.root,string.format("Image_%d",index))
		if img then
			img:addTouchEventListener(handler(self,self.touchListener))
			table.sort(data,function (val1,val2)
				return val1 < val2
			end)
			for index2,val in pairs(data) do
				local fnode = CustomHelper.seekNodeByName(img,string.format("FileNode_%d",index2))
				local card = TmjCard:create({val = val })
				card:addTo(fnode:getParent())
				card:setScale(fnode:getScale())
				card:changeState(TmjConfig.CardState.State_Discard)
				
				local cardPos = cc.p(fnode:getPositionX(),fnode:getPositionY())
				card:setCardPosition(cardPos,true)
				fnode:removeFromParent()				
				
			end
		end
	end
	
	
	
end
--根据数据设置尺寸
--@param orientation 方向  1 横向 horizontal		2 纵向 vertical
--@param len 长度
function TmjOperationChi:setContentSizeForData(node,orientation,len)
	local imgTag = CustomHelper.seekNodeByName(node,"Image_tag")
	
	local img = nil
	if orientation==2 then --纵向，只算一个宽度
		img = CustomHelper.seekNodeByName(node,"Image_1")
	else --横向 根据长度
		img = CustomHelper.seekNodeByName(node,string.format("Image_%d",len))
	end
	if img then
		local imgAn = img:getAnchorPoint()
		self.contentSize = cc.size(imgTag:getContentSize().width/2 + img:getPositionX() + (1-imgAn.x)*img:getContentSize().width,
									img:getContentSize().height)
		
	end
end

--根据数据的长度和方向决定动画
--@param orientation 方向  1 横向 horizontal		2 纵向 vertical
--@param len 长度
function TmjOperationChi:getAnimation(orientation,len)
	local animations = {
		[1] = {
			[1] = "animation5",
			[2] = "animation1",
			[3] = "animation0",
		},
		[2] = {
			[1] = "animation4",
			[2] = "animation3",
			[3] = "animation2",
		},
	}
	sslog(self.logTag,"orientation "..orientation.." len "..len)
	return animations[orientation][len]
end

function TmjOperationChi:touchListener(ref,eventType)
	if eventType==ccui.TouchEventType.began then
		TmjConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		local chooseIndex = 1 -- 默认选择第一个
		if ref:getName()=="Image_tag" then --
			chooseIndex = 1 --
		elseif ref:getName()=="Image_1" then
			chooseIndex = 1 -- 
		elseif ref:getName()=="Image_2" then
			chooseIndex = 2 -- 
		elseif ref:getName()=="Image_3" then
			chooseIndex = 3 -- 
		end
		if self.chooseFun then
			self.chooseFun(TmjConfig.cardOperation.Chi,self.operationData.data[chooseIndex])
		end
	end
end

return TmjOperationChi
