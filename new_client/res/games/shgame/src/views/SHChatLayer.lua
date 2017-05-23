-------------------------------------------------------------------------
-- Desc:    二人梭哈牌快捷聊天界面
-- Author:  zengzx
-- Date:    2017.5.17
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHChatLayer = class("SHChatLayer",requireForGameLuaFile("SHPopBaseLayer"))
local SHConfig = import("..cfg.SHConfig")
local SHHelper = import("..cfg.SHHelper")

local SHChatLayerNode = requireForGameLuaFile("SHChatLayerCCS")
local SHChatItemNode = requireForGameLuaFile("SHChatItemNodeCCS")
function SHChatLayer:ctor()
	SHChatLayer.super.ctor(self)
	self:setName("SHChatLayer")
	self:initView()
end
function SHChatLayer:initView()
	local node = SHChatLayerNode:create()
	self:addChild(node.root)
	
	self:initChatUI(CustomHelper.seekNodeByName(node.root,"Panel_chat"))
	self:initCHatData()
	local Image_bg = CustomHelper.seekNodeByName(node.root,"Image_bg")
	self:popIn(Image_bg,SHConfig.Pop_Dir.Left)
	
end

function SHChatLayer:initChatUI(chatPanel)
	local size = chatPanel:getContentSize()
	self.tableView = cc.TableView:create(size)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setPosition(cc.p(0,0))
    self.tableView:setDelegate()
	self.tableView:addTo(chatPanel)
	self.tableView:setVerticalFillOrder(0) --竖直方向 填充顺序 从上到下
    self.tableView:registerScriptHandler(handler(self,self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(handler(self,self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(handler(self,self.tableCellTouched),cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(handler(self,self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(handler(self,self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	
end

function SHChatLayer:initCHatData()
	local chatStrs = SHi18nUtils:getInstance():get('str_chat')
	if chatStrs then
		self.chatCount = table.nums(chatStrs)
		self.charData = CustomHelper.copyTab(chatStrs)
	end
	
	self.tableView:reloadData()
end
--发送聊天信息
function SHChatLayer:checkToSend(data)
	sslog(self.logTag,"发送聊天内容:"..tostring(data))
	SHGameManager:getInstance():sendChatMsg(data)
end

function SHChatLayer:numberOfCellsInTableView(view)
	
	return self.chatCount
end

function SHChatLayer:scrollViewDidScroll(view)

	
end

function SHChatLayer:scrollViewDidZoom(view)

end
function SHChatLayer:tableCellTouched(view,cell)
	
	SHConfig.playButtonSound()
	local tag = cell:getTag()
	local data = self.charData[tostring(tag+1)]
	if data then
		--RoomChatManager:playCharecter("1",data,{position=cc.p(400,400)})
		self:checkToSend(data)
		self:close() -- 发送完就关闭
	end
end

function SHChatLayer:cellSizeForTable(view,idx)
	return 660.00,42.00 + 20
end
function SHChatLayer:createChatNode(view,cell,idx)
	local charNode = SHChatItemNode:create().root
	--signNode:setAnchorPoint(0.5,0.5)

	charNode:setPositionX(0)
	charNode:setPositionY(0)
	charNode:setName("SHChatItemNode")
	charNode:setTag(idx)
	return charNode
end


function SHChatLayer:tableCellAtIndex(view,idx)
	
    local cell = view:dequeueCell()
	local ritem = nil
    if nil == cell then
        cell = cc.TableViewCell:new()
		ritem = self:createChatNode(view,cell,idx)		
		cell:addChild(ritem)
	else
		ritem = cell:getChildByName("SHChatItemNode")
    end
	cell:setTag(idx)
	ritem:setTag(idx)
	local textContent = CustomHelper.seekNodeByName(ritem,"Text_content")
	local data = self.charData[tostring(idx+1)]
	textContent:setString(data or "")

    return cell
end



function SHChatLayer:onEnter()
	if SHChatLayer.super.onEnter then
		SHChatLayer.super.onEnter(self)
	end
	
end
function SHChatLayer:onExit()
	if SHChatLayer.super.onExit then
		SHChatLayer.super.onExit(self)
	end
	SHHelper.removeAll(self.charData)
	self.chatCount = nil
end


return SHChatLayer