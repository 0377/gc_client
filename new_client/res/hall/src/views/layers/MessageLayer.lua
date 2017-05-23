--requireForGameLuaFile("cocos-ext.init")

local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local MessageLayer = class("MessageLayer", CustomBaseView);

function MessageLayer:ctor()
    MessageLayer.super.ctor(self)
    self:onCreateContent()
    CustomHelper.addAlertAppearAnim(self.background)

    self._usingCells = {}
    self._cachCells = {}

--    local text = [[
--    <font color="#FFFF">您的充值订单3216465321654</font><br/>
--    <font color="#00FF00"> 充值10.00元</font><br/>
--    <font color="#FFFFFF">已经</font><font color="#FFFF00">充值成功</font>
--    ]]
--
--    ccui.RichText:createWithXML(text,{
--        KEY_FONT_SIZE = 30,
--        KEY_VERTICAL_SPACE = 0.5,
--    })
--    :addTo(self):align(display.CENTER,display.cx,display.cy)
end

function MessageLayer:onEnter()
    self:addCustomEventListener("kNotifyName_RefreshMessageData", handler(self, self._onEvent_refreshMessageData))

    self:UpdateContent()
end

function MessageLayer:onExit()
    self:removeAllEventListeners()
end

function MessageLayer:onCleanup()
end

function MessageLayer:onCreateContent()
    local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("MessageLayer.csb");
    local CCSLuaNode =  requireForGameLuaFile("MessageLayerCCS")
    self._ui = CCSLuaNode:create().root:addTo(self);
    local background = self._ui:getChildByName("background")
    background:setTouchEnabled(true)
    self._background_Pos = { background:getPosition() }
    self.background = background

    local btn_close = background:getChildByName("btn_close")
    local btn_confirm = background:getChildByName("btn_confirm")

    btn_close:addTouchEventListener(handler(self, self._onBtnTouched_close))
    btn_confirm:addTouchEventListener(handler(self, self._onBtnTouched_close))

    local scrollviewCell = background:getChildByName("scrollviewCell"):hide()
    scrollviewCell:addTouchEventListener(handler(self, self._onBtnTouched_cell))
    scrollviewCell:setTouchEnabled(true)
    self._scrollviewCell = scrollviewCell

    self._scrollview = background:getChildByName("scrollview")
    self._scrollview:setContentSize(self._scrollview:getContentSize().width + 5, self._scrollview:getContentSize().height)

    self._scrollview:addEventListener(handler(self, self._onEvent_scrollview))


    local loadingbar = background:getChildByName("loadingbar")
    loadingbar:setVisible(false)
    loadingbar:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 180)))
    self._loadingBar = loadingbar

    self._labelTip = background:getChildByName("label_tip"):hide()
end

function MessageLayer:onLoading()
    self._loadingBar:setVisible(true)
end

function MessageLayer:onLoadingEnd()
    self._loadingBar:setVisible(false)
end

--- 元素点击事件
function MessageLayer:_onBtnTouched_cell(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        dump(sender._data)

        local msgMng = GameManager:getInstance():getHallManager():getHallMsgManager()
        sender._data.Readed = true
        msgMng:sendSetMsgReadFlag( sender._data)

        self:updateCell(sender,sender._data)

        -- TODO 添加弹出消息界面

        local MessageTipLayer = requireForGameLuaFile("MessageTipLayer")
        MessageTipLayer:createWithMessage(sender._data)
    end
end

--- 关闭按钮
function MessageLayer:_onBtnTouched_close(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        self:removeSelf()
    end
end

function MessageLayer:_onEvent_scrollview(sender, type)
    -- 更新滑动层 --
    local container = self._scrollview:getInnerContainer()
    local viewSize = self._scrollview:getContentSize()

    local x, y = container:getPosition()

    local viewRect = cc.rect(-x, -y, viewSize.width, viewSize.height)

    -- cells --
    for k, v in ipairs(self._cellData or {}) do
        local cellRect = v.rect

        if cc.rectIntersectsRect(cellRect, viewRect) then
            local cell = self._usingCells[k]
            if cell == nil then
                cell = self:cellAtIndex(v)
                if cell then
                    cell:setVisible(true)
                    cell:setAnchorPoint(display.LEFT_BOTTOM)
                    cell:setPosition(cellRect.x, cellRect.y)
                    self._usingCells[k] = cell
                end
            end
        else
            -- 没有在显示区域内,回收 --
            local cell = self._usingCells[k]
            if cell then
                cell:setVisible(false)
                table.insert(self._cachCells, cell)
            end
            self._usingCells[k] = nil
        end
    end
end

function MessageLayer:_onEvent_refreshMessageData(data)
    self:UpdateContent()
end


function MessageLayer:cellAtIndex(data)
    local cell
    if #self._cachCells > 0 then
        cell = table.remove(self._cachCells, 1)

        self:updateCell(cell, data.data)
    else
        cell = self._scrollviewCell:clone()

        self:updateCell(cell, data.data)
        self._scrollview:addChild(cell)
    end
    return cell
end

function MessageLayer:updateCell(cell, data)
    cell._data = data

    local label_title = cell:getChildByName("label_title")
    local label_time = cell:getChildByName("label_time")
    local icon_dot = cell:getChildByName("icon_dot")


    local leftTime = math.max(data.EndTime - os.time(), 1)
    local leftDay = math.ceil(leftTime / 86400)

    label_time:setString( string.format("%d天后删除", leftDay))

    local playInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    local messageInfo = playInfo:getMessageInfo()
    local content = messageInfo:parseMessageBrief(data)
    label_title:setString(content)
    icon_dot:setVisible(not data.Readed)
end

function MessageLayer:UpdateContent(content)
    local playInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    local messageInfo = playInfo:getMessageInfo()

    local content, loaded = messageInfo:getDataByType(messageInfo.MSG_TYPE.MESSAGE)

    -- if loaded or (table.getn(content) == 0) then
    --     self:onLoadingEnd()
    -- else
    --     self:onLoading()
    -- end

    -- TODO:loaded状态不正确，看了下逻辑挺杂的，先不转圈圈
    self:onLoadingEnd() 

    content = content or {}
    dump(#content)

    self._data = content

    for k, v in pairs(self._usingCells) do
        v:setVisible(false)
        table.insert(self._cachCells, v)
    end
    self._usingCells = {}

    if #self._data == 0 then
        self._labelTip:setVisible(true)
        self._scrollview:setVisible(false)
        return
    else
        self._labelTip:setVisible(false)
        self._scrollview:setVisible(true)
    end

    local row = #self._data

    local scrollviewSize = self._scrollview:getContentSize()
    local cellWidth = scrollviewSize.width
    local cellHeight = 70

    local height = cellHeight * row
    local offset = 0
    if height < scrollviewSize.height then
        offset = scrollviewSize.height - height
        height = scrollviewSize.height
    end

    local rects = {}
    for k, v in ipairs(self._data) do
        local _y = row - k

        table.insert(rects, {
            rect = cc.rect(0, _y * cellHeight + offset, cellWidth, cellHeight),
            data = v,
        })
    end

    self._cellData = rects
    self._cellWidth = cellWidth
    self._cellHeight = cellHeight

    self._scrollview:setInnerContainerSize(cc.size(scrollviewSize.width, height))

    self:_onEvent_scrollview(self._scrollview, 4)
end

return MessageLayer