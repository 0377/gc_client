
-- PS:之前做的分页加载并没有达到分页加载的目的，还是全部数据拉取完了再展示的。现在改成直接拉取最大50条。如果需要真正做成分页的，后续再优化成真正分页的。
-- PS:限制条数50,目前请求PHP第一页就是最新的50条

local FeedbackHelper = requireForGameLuaFile("FeedbackHelper")
local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local FeedbackLayerNew = class("FeedbackLayerNew", CustomBaseView)

local CONTENT_SIZE_WIDTH = 400
local CONTENT_FONT_SIZE = 28

local MAX_FEEDBACK_NUM = 50

-- 内容类型枚举
local ContentType = 
    {
        ["PLAYER"] = 1,
        ["SYSTEM"] = 2,
        ["DATE"]   = 3
    }

function FeedbackLayerNew:ctor(args)
    self:_initData()

    self:onCreateContent()

    FeedbackLayerNew.super.ctor(self)
    CustomHelper.addWholeScrennAnim(self)
end

function FeedbackLayerNew:onEnter()
    -- self:addCustomEventListener("kNotifyName_RefreshFeedbackReaded", handler(self, self._onEvent_refreshFeedbackReaded))
    -- PS:不够好，没有区分新信息类型
    self:addCustomEventListener("kNotifyName_ReceiveNewMsg", handler(self, self._onEvent_refreshFeedbackReaded))
    self:_onEvent_refreshFeedbackReaded()
end

function FeedbackLayerNew:onExit()
    self:removeAllEventListeners()
    -- 不太明白这个写法...
    FeedbackHelper.queryFeedbackStatus()
    FeedbackHelper.clearQueryCallback()
    FeedbackLayerNew.super.onExit(self)
end

function FeedbackLayerNew:_onEvent_refreshFeedbackReaded()
    self:requestPageData()
end

function FeedbackLayerNew:registerNotification()
    FeedbackLayerNew.super.registerNotification(self)
end

function FeedbackLayerNew:receiveServerResponseSuccessEvent(event)
    
end

function FeedbackLayerNew:_initData()
    self._data = {}
    self._feedbackInfo = GameManager:getInstance():getHallManager():getPlayerInfo():getFeedbackInfo()
end

function FeedbackLayerNew:onCreateContent()
    local CCSLuaNode =  requireForGameLuaFile("FeedbackLayerNewCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode)

    local background = self.csNode:getChildByName("background")
    background:setTouchEnabled(true)
    self.background = background

    ViewManager.initPublicTopInfoLayer(self, "hall_res/customer_service/bb_kf_bt.png")

    -- local btn_close = background:getChildByName("btn_close")
    -- btn_close:addClickEventListener(handler(self, self._onBtnClicked_close)) 

    -- 提交反馈 --
    local panel_submit = background:getChildByName("panel_submit")
    self.panel_submit = panel_submit

    local btn_submit = panel_submit:getChildByName("btn_submit")
    btn_submit:addTouchEventListener(handler(self, self._onBtnTouched_submitFeedback))

    local bg_editbox = panel_submit:getChildByName("bg_editbox")
    local textfield = bg_editbox:getChildByName("textfield"):hide()
    self.textfield = textfield

    local bgFileName = "bank_file"
    self.editboxFeedback = ccui.EditBox:create(textfield:getContentSize(),bgFileName)
    self.editboxFeedback:setPosition(textfield:getPosition())
    self.editboxFeedback:setAnchorPoint(textfield:getAnchorPoint())
    self.editboxFeedback:setFontName("Helvetica-Bold")
    self.editboxFeedback:setFontSize(30)
    self.editboxFeedback:setFontColor(cc.c3b(255, 255, 255))
    self.editboxFeedback:setPlaceHolder("在此输入反馈内容，最多50字")
    self.editboxFeedback:setPlaceholderFontColor(cc.c3b(103, 95, 96))
    self.editboxFeedback:setPlaceholderFontSize(30)
    self.editboxFeedback:setMaxLength(50)
    self.editboxFeedback:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.editboxFeedback:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self.editboxFeedback:addTo(bg_editbox)

    -- 查看回复 --
    local panel_reply = background:getChildByName("panel_reply")
    self.panel_reply = panel_reply
    local scrollview = panel_reply:getChildByName("scrollview")
    local scrollviewCell = panel_reply:getChildByName("scrollviewCell"):hide()
    scrollview:addEventListener(handler(self, self._onEventScroll))
    self._scrollview = scrollview
    self._scrollviewCell = scrollviewCell
    self._scrollviewCellSys = panel_reply:getChildByName("scrollviewCellSys"):hide()
    self._scrollviewCellDate = panel_reply:getChildByName("scrollviewCellDate"):hide()

    -- 无反馈消息提示
    self._emptyPrompt = panel_reply:getChildByName("Text_Empty_Prompt")

    self._usingCells = {}
    self._cachCells = 
    {
        [ContentType.PLAYER] = {},
        [ContentType.SYSTEM] = {},
        [ContentType.DATE]   = {}
    }

    local labelTemp = cc.Label:create():addTo(panel_reply):hide()
    labelTemp:setSystemFontSize(CONTENT_FONT_SIZE)
    labelTemp:setDimensions(CONTENT_SIZE_WIDTH, 0)
    self.labelTemp = labelTemp
end

function FeedbackLayerNew:_onBtnClicked_close(sender, eventType)
    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    self:removeSelf()
end

function FeedbackLayerNew:_onBtnTouched_submitFeedback(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        sender:getChildByName("Image_Submit_Normal"):setVisible(false)
        -- sender:getChildByName("Image_Submit_Selected"):setVisible(true)
        sender:getChildByName("Image_Submit_Selected"):setVisible(false)

        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        -- sender:getChildByName("Image_Submit_Normal"):setVisible(true)
        sender:getChildByName("Image_Submit_Normal"):setVisible(false)
        sender:getChildByName("Image_Submit_Selected"):setVisible(false)

        local content = self.editboxFeedback:getText()
        FeedbackHelper.submitFeedback(FeedbackHelper.CONFIG_FEEDBACK_CAT["提建议"],content,function(xhr,isSuccess)
            local responseStr = xhr.response
            if isSuccess then
                local data = json.decode(responseStr)
                if data and data.status == 1 then
                    self.textfield:setString("")
                    self.editboxFeedback:setText("")
                    MyToastLayer.new(self, data.message)

                    self:requestPageData()
                else
                    MyToastLayer.new(self, data.message)
                end
            else
               MyToastLayer.new(self,"提交失败,请重试")
            end
        end)
    end
end

function FeedbackLayerNew:_onEventScroll(sender, type)
    local container = self._scrollview:getInnerContainer()
    local viewSize = self._scrollview:getContentSize()

    local x, y = container:getPosition()

    local viewRect = cc.rect(-x, -y, viewSize.width, viewSize.height)
    if self._cellData == nil or table.nums(self._cellData) == 0 then
        --todo
        return;
    end
    for k, v in ipairs(self._cellData) do
        local cellRect = v.rect

        if cc.rectIntersectsRect(cellRect, viewRect) then
            local cell = self._usingCells[k]
            if cell == nil then
                cell = self:_onCellAtIndex(v)
                if cell then
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
                table.insert(self._cachCells[cell:getTag()], cell)
            end
            self._usingCells[k] = nil
        end
    end
end

function FeedbackLayerNew:_onCellAtIndex(data)
    local cell
    local contentType = self:_getContentTypeByFid(data["data"]["f_id"])
    if #self._cachCells[contentType] > 0 then
        cell = table.remove(self._cachCells[contentType], 1)
    else
        cell = self:_onCreateCell(data)
        self._scrollview:addChild(cell)
    end

    local temp = data.data
    cell:setVisible(true)
    if (self:_getContentTypeByFid(temp["f_id"]) ~= ContentType.DATE) then
        cell.label_content:setString(temp.content)
        local labelSize = cell.label_content:getContentSize()
        cell.bg_content:setContentSize(cc.size(labelSize.width + 30, labelSize.height + 20))
        if (self:_getContentTypeByFid(temp["f_id"]) == ContentType.SYSTEM) then
            cell.bg_content:align(display.LEFT_TOP, 80, data.rect.height)
            cell.imageHead:align(display.LEFT_TOP, 0, data.rect.height)
            cell.imageHeadBg1:align(display.LEFT_TOP, 0, data.rect.height)
            cell.imageHeadBg2:align(display.LEFT_TOP, 0, data.rect.height)
            cell.label_content:align(display.LEFT_TOP, 80 + 20, data.rect.height - 10)
        elseif (self:_getContentTypeByFid(temp["f_id"]) == ContentType.PLAYER) then
            cell.bg_content:align(display.LEFT_TOP, 0, data.rect.height)
            cell.imageHead:align(display.LEFT_TOP, 450, data.rect.height)
            cell.imageHeadBg1:align(display.LEFT_TOP, 450, data.rect.height)
            cell.imageHeadBg2:align(display.LEFT_TOP, 450, data.rect.height)
            cell.label_content:align(display.LEFT_TOP, 0 + 10, data.rect.height - 10)
        end

        if (self:_getContentTypeByFid(temp["f_id"]) == ContentType.PLAYER) then
            local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
            cell.imageHead:loadTexture(myPlayerInfo:getSquareHeadIconPath())
        end
    else
        cell.dateText:setString(temp["created_at"])
    end

    return cell
end

function FeedbackLayerNew:_onCreateCell(data)
    local cell = nil
    if (self:_getContentTypeByFid(data["data"]["f_id"]) == ContentType.PLAYER) then
        cell = self._scrollviewCell:clone():show()
    elseif (self:_getContentTypeByFid(data["data"]["f_id"]) == ContentType.SYSTEM) then
        cell = self._scrollviewCellSys:clone():show()
    else
        cell = self._scrollviewCellDate:clone():show()
    end
    cell:setTag(self:_getContentTypeByFid(data["data"]["f_id"]))

    cell.bg_content = cell:getChildByName("bg_content")
    cell.imageHead = cell:getChildByName("Image_Cell_Head")
    cell.imageHeadBg1 = cell:getChildByName("Image_Cell_Head_Bg_1")
    cell.imageHeadBg2 = cell:getChildByName("Image_Cell_Head_Bg_2")
    cell.dateText = cell:getChildByName("Text_Date")

    local label_content = cc.Label:create()
    label_content:setSystemFontSize(CONTENT_FONT_SIZE)
    label_content:setTextColor(cc.c3b(0, 0, 0))
    label_content:setDimensions(CONTENT_SIZE_WIDTH, 0)
    label_content:align(display.RIGHT_CENTER, - 10, 0):addTo(cell)
    cell.label_content = label_content

    return cell
end

function FeedbackLayerNew:requestPageData()
    local curPage = self._feedbackInfo:getCurentPage()
    FeedbackHelper.queryFeedback(curPage, handler(self, self.updateReplay))
end

function FeedbackLayerNew:updateReplay()
    local data = self._feedbackInfo:getDatas()
    if (table.getn(data) > 0) then
        self._emptyPrompt:setVisible(false)

        -- dump(data)
        data = self._feedbackInfo:insertDateData(data)
        self._feedbackInfo:insertDateData(data)
        local hasMore = self._feedbackInfo:hasMore()

        for k, v in pairs(self._usingCells) do
            v:setVisible(false)
            table.insert(self._cachCells[v:getTag()], v)
        end
        self._usingCells = {}

        local cellIntervalY = 10
        local width = self._scrollview:getContentSize().width
        local height = 0

        local rects = {}
        for k, v in ipairs(data) do
            local tmpX = 0 + 20
            local _height = 0
            if (self:_getContentTypeByFid(v.f_id) == ContentType.PLAYER) then 
                tmpX = 640 - 20
                self.labelTemp:setString(v.content)
                _height = self.labelTemp:getContentSize().height + 20
            elseif (self:_getContentTypeByFid(v.f_id) == ContentType.SYSTEM) then 
                self.labelTemp:setString(v.content)
                _height = self.labelTemp:getContentSize().height + 20
            elseif (self:_getContentTypeByFid(v.f_id) == ContentType.DATE) then
                _height = 60
            end
            table.insert(rects, {
                rect = cc.rect(tmpX, height, width, _height),
                data = v,
                isLoading = hasMore,
            })

            height = height + _height + cellIntervalY
        end
        -- 这样子多了一个cellIntervalY，要减去
        height = height - cellIntervalY
        
        height = math.max(height, self._scrollview:getContentSize().height)

        for _, v in ipairs(rects) do
            -- v.rect.y = height - v.rect.y - v.rect.height - cellIntervalY
            v.rect.y = height - v.rect.y - v.rect.height
        end

        self._cellData = rects

        self._scrollview:setInnerContainerSize(cc.size(self._scrollview:getContentSize().width, height))
        self:_onEventScroll(self._scrollview)

        -- 跳转到最底层
        self._scrollview:jumpToBottom()
    else
        self._emptyPrompt:setVisible(true)
    end
end

function FeedbackLayerNew:_getContentTypeByFid(fid)
    if fid == 0 then
        return ContentType.PLAYER
    elseif fid > 0 then
        return ContentType.SYSTEM
    else
        return ContentType.DATE
    end
end

return FeedbackLayerNew