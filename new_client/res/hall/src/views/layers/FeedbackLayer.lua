local FeedbackHelper = requireForGameLuaFile("FeedbackHelper")
local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local FeedbackLayer = class("FeedbackLayer",CustomBaseView);



function FeedbackLayer:ctor(args)
    args = args or {}
    self._config = args.config
    self._data = args.data
    self._type = args.type
    self._select = 0
    self._replyData = {}
    self._replyRequestIndex = 0
    self._replyIndex = 0
    self._curIndex = 0
    self._replyDataHasMore = false

    self._feedbackInfo = GameManager:getInstance():getHallManager():getPlayerInfo():getFeedbackInfo()

    self:onCreateContent()
    --- 添加监听事件

    FeedbackLayer.super.ctor(self)
    CustomHelper.addWholeScrennAnim(self);
end

function FeedbackLayer:registerNotification()
    FeedbackLayer.super.registerNotification(self)
end

function FeedbackLayer:receiveServerResponseSuccessEvent(event)
    local msgName = event.userInfo.msgName
    dump(msgName)
    if msgName == "" then

    end
end

function FeedbackLayer:onCreateContent()
    local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("FeedbackLayer.csb");
    self._ui = cc.CSLoader:createNode(csNodePath):addTo(self)
    -- self._ui:setTouchEnabled(false)

    local background = self._ui:getChildByName("background")
    background:setTouchEnabled(true)
    self.background = background

    local btn_close = background:getChildByName("btn_close")
    btn_close:addClickEventListener(handler(self, self._onBtnClicked_close))

    -- 提交反馈 --
    local panel_submit = background:getChildByName("panel_submit")
    self.panel_submit = panel_submit

    -- tab btns --
    local tabBtns = {
        { name = "btn_check_1", type = "提建议" },
        { name = "btn_check_2", type = "提BUG" },
        { name = "btn_check_3", type = "充值问题" },
        { name = "btn_check_4", type = "咨询其他" },
    }

    local btns = {}
    for _, v in ipairs(tabBtns) do
        local btn = panel_submit:getChildByName(v.name)
        btn:addClickEventListener(function(sender)
                --todo
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            self:_clickOneCheckBox(btn)
        end)
        btn.type = v.type
        table.insert(btns, btn)
    end
    self.btn_checkCat = btns
    self:_clickOneCheckBox(btns[1])

    local btn_submit = panel_submit:getChildByName("btn_submit")
    btn_submit:addTouchEventListener(handler(self, self._onBtnTouched_submitFeedback))

    local bg_editbox = panel_submit:getChildByName("bg_editbox")
    local textfield = bg_editbox:getChildByName("textfield"):hide()
    self.textfield = textfield

    --todo
    local bgFileName = "bank_file"
    self.editboxFeedback = ccui.EditBox:create(textfield:getContentSize(),bgFileName)
    self.editboxFeedback:setPosition(textfield:getPosition())
    self.editboxFeedback:setAnchorPoint(textfield:getAnchorPoint())
    self.editboxFeedback:setFontName("Helvetica-Bold")
    self.editboxFeedback:setFontSize(30)
    self.editboxFeedback:setFontColor(cc.c3b(255, 255, 255))
    self.editboxFeedback:setPlaceHolder("请输入你要反馈的内容！")
    self.editboxFeedback:setPlaceholderFontColor(cc.c3b(103, 95, 96))
    self.editboxFeedback:setPlaceholderFontSize(30)
    self.editboxFeedback:setMaxLength(100)
    self.editboxFeedback:setInputMode(cc.EDITBOX_INPUT_MODE_ANY);
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

    self._usingCells = {}
    self._cachCells = {}

	local sliderbar = panel_reply:getChildByName("Slider_bar")
	self._sliderbar = sliderbar
	self._sliderRange = {max = 90,min = 10} --手动设置滑块的阈值

	self._sliderbar:addEventListener(handler(self,self._onSliderBarChanged))
    local labelTemp = cc.Label:create():addTo(panel_reply):hide()
    labelTemp:setSystemFontSize(30)
    labelTemp:setDimensions(780, 0)
    self.labelTemp = labelTemp

    -- tab btns --
    local tabBtns = {
        "btn_submitFeedback",
        "btn_checkReply",
    }
    local btns = {}
    for _, v in ipairs(tabBtns) do
        local btn = background:getChildByName(v)
        btn:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            self:_clickOneSelectdBtn(btn)
        end)
        table.insert(btns, btn)
    end
    self.btn_tabs = btns
    self:_clickOneSelectdBtn(btns[1])

    self.icon_point = btns[2]:getChildByName("icon_point")

    self:_onEvent_refreshFeedbackReaded()
end

function FeedbackLayer:onEnter()
    self:addCustomEventListener("kNotifyName_RefreshFeedbackReaded", handler(self, self._onEvent_refreshFeedbackReaded))
    self:_onEvent_refreshFeedbackReaded()
end

function FeedbackLayer:onExit()
    self:removeAllEventListeners()
    FeedbackHelper.queryFeedbackStatus()
	FeedbackHelper.clearQueryCallback()
    FeedbackLayer.super.onExit(self)
end

function FeedbackLayer:_onBtnClicked_close(sender, eventType)
    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    self:removeSelf()
end

function FeedbackLayer:_clickOneSelectdBtn(sender)
    for _, v in ipairs(self.btn_tabs) do
        v:setBright(sender ~= v)
    end

    self.panel_submit:setVisible(false)
    self.panel_reply:setVisible(false)

    local name = sender:getName()
    if name == "btn_submitFeedback" then
        self.panel_submit:setVisible(true)
    elseif name == "btn_checkReply" then
        self.panel_reply:setVisible(true)

        self._replyIndex =  self._curIndex + 1
        self:requestPageData()
        self:updateReplay()
    end
end

function FeedbackLayer:_clickOneCheckBox(btn)
    for i,tempBtn in ipairs(self.btn_checkCat) do
        local iconCheckView = CustomHelper.seekNodeByName(tempBtn, "icon_check")
        tempBtn.iconCheckView = iconCheckView
        iconCheckView:setVisible(btn == tempBtn)
    end
end

function FeedbackLayer:_onBtnTouched_submitFeedback(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        -- local content = self.textfield:getString()
        local content = self.editboxFeedback:getText()
        local type = nil
        for _, v in ipairs(self.btn_checkCat) do
            local iconCheckView = v.iconCheckView
            if iconCheckView:isVisible() then
                type = v.type
                break
            end
        end
        FeedbackHelper.submitFeedback(FeedbackHelper.CONFIG_FEEDBACK_CAT[type],content,function(xhr,isSuccess)
            local responseStr = xhr.response
            if isSuccess then
                local data = json.decode(responseStr)
                dump(data, "data", nesting)
                if data and data.status == 1 then
                    dump(value, desciption, nesting)
                    self.textfield:setString("")
                    self.editboxFeedback:setText("")
                    MyToastLayer.new(self, data.message)
                else
                    MyToastLayer.new(self, data.message)
                end
            else
               MyToastLayer.new(self,"提交失败,请重试")
            end
        end)
    end
end
function FeedbackLayer:_onSliderBarChanged(sender,eventType)
	if eventType == ccui.SliderEventType.percentChanged then
		local curPercent = math.max(sender:getPercent(),self._sliderRange.min)
		curPercent = math.min(curPercent,self._sliderRange.max)
		sender:setPercent(curPercent)
		self:changeScollPercent(sender:getPercent())
	elseif eventType == ccui.SliderEventType.slideBallDown then
		
		self.touchSlider = true
	elseif eventType == ccui.SliderEventType.slideBallUp then
		self:changeScollPercent(sender:getPercent())
		self.touchSlider = false
		
	elseif eventType == ccui.SliderEventType.slideBallCancel then
		self.touchSlider = false
	end
end
--通过滑动快设置滑动区域的偏移位置
function FeedbackLayer:changeScollPercent(percent)
	percent = (percent - self._sliderRange.min)/(self._sliderRange.max - self._sliderRange.min)
	self._scrollview:jumpToPercentVertical(100-percent*100)
	--print("set scrollview percent",percent*100)
end
--通过滑动区域改变滑动块的百分比
function FeedbackLayer:changeSliderPercent()
	if not self.touchSlider then --只有不是触摸滑动快的时候才会设置
		local innerSize = self._scrollview:getInnerContainerSize()
		local innerPos = self._scrollview:getInnerContainerPosition()
		local viewSize = self._scrollview:getContentSize()
		innerPos.y = math.min(0,innerPos.y)
		if innerSize.height ~= viewSize.height then
			local percent = math.abs(innerPos.y) / (innerSize.height - viewSize.height)
			percent = math.max(percent,0)
			percent = math.min(percent,1.0)
			percent = self._sliderRange.min + (self._sliderRange.max - self._sliderRange.min)*percent
			self._sliderbar:setPercent(percent)
		end
	end

end
function FeedbackLayer:_onEventScroll(sender, type)
    local container = self._scrollview:getInnerContainer()
    local viewSize = self._scrollview:getContentSize()

    local x, y = container:getPosition()

    local viewRect = cc.rect(-x, -y, viewSize.width, viewSize.height)
	self:changeSliderPercent()
    -- cells --
    -- dump(self._cellData)
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
                table.insert(self._cachCells, cell)
            end
            self._usingCells[k] = nil
        end
    end
end

function FeedbackLayer:_onCellAtIndex(data)
    local cell
    if #self._cachCells > 0 then
        cell = table.remove(self._cachCells, 1)
    else
        cell = self:_onCreateCell(data)
        self._scrollview:addChild(cell)
    end

    local temp = data.data

    if data.isLoading then
        cell:setVisible(false)
        self:requestPageData()
    else
        --            "id": 2,
        --            "f_id": 0,      此字段大于0则为官方回复，等于0则是玩家反馈
        --            "username": "大神",
        --            "account": "18190909883",
        --            "is_read": 0,    0未读  1已读
        --            "type": "充值问题",
        --            "content": "充值失败了啊啊啊啊",
        --            "created_at": "2017-01-12 09:19:01"

        cell:setVisible(true)

        cell.bg_content:align(display.RIGHT_TOP, data.rect.width - 50 + 24, data.rect.height)
        cell.bg_content:setContentSize(cell.bg_content:getContentSize().width, data.rect.height)


        cell.label_content:setString(temp.content)
        cell.label_content:align(display.LEFT_TOP, 10, data.rect.height - 10)


        local iconNewVisible = false
        local title
        if temp.f_id ~= 0 then
            title = "官方回复:"
            cell.label_title:setColor(cc.c3b(0xFF, 0xC5, 0x49))

            iconNewVisible = temp.is_read == 0
        else
            cell.label_title:setColor(cc.c3b(0xFF, 0xFF, 0xFF))
            -- for k, v in pairs(FeedbackHelper.CONFIG_FEEDBACK_CAT) do
            --     if v == temp.type then
            --         title = k .. ":"
            --         break
            --     end
            -- end
            title = temp.type .. ":"
            iconNewVisible = false
        end
        if iconNewVisible then
            cell.icon_new:setPositionY(data.rect.height - 20)
            cell.label_title:setPositionY(data.rect.height - 60 - 6)
            cell.icon_new:setVisible(true)
        else
            cell.label_title:setPositionY(data.rect.height - 20 - 6)
            cell.icon_new:setVisible(false)
        end

        cell.label_title:setString(title)
    end

    return cell
end

function FeedbackLayer:_onCreateCell(data)
    local cell = self._scrollviewCell:clone():show()

    cell.bg_content = cell:getChildByName("bg_content")
    cell.label_title = cell:getChildByName("label_title")
    cell.icon_new = cell:getChildByName("icon_new")

    local label_content = cc.Label:create()
    label_content:setSystemFontSize(30)
    label_content:setDimensions(cell.bg_content:getContentSize().width - 14, 0)
    label_content:align(display.RIGHT_CENTER, - 10, 120):addTo(cell.bg_content)

    cell.label_content = label_content

    return cell
end

function FeedbackLayer:requestPageData()
    local curPage = self._feedbackInfo:getCurentPage()
    FeedbackHelper.queryFeedback(curPage,handler(self,self.updateReplay))
end

function FeedbackLayer:updateReplay()
    -- local data = self._feedbackInfo or {
    --     { type = 0, category = 1, content = "希望以后as打算带饭龙胆发送\nasdfasfd\ndfdfd\ndsfs\nxcvxcv\nertert\nhgfhfgh" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    --     { type = 1, category = 1, content = "希望以后as打算带饭龙胆发送" },
    -- }

    local data = self._feedbackInfo:getDatas()
    local hasMore = self._feedbackInfo:hasMore()
-- dump(data)
-- dump(hasMore)
    for k, v in pairs(self._usingCells) do
        v:setVisible(false)
        table.insert(self._cachCells, v)
    end
    self._usingCells = {}

    local row = #data

    local cellIntervalY = 10

    local width = self._scrollview:getContentSize().width
    local height = 0

    local rects = {}
    for k, v in ipairs(data) do
--    for i=1,#data do
--        local v = data[#data - i + 1]
        self.labelTemp:setString(v.content)
        local _height = math.max(self.labelTemp:getContentSize().height + 30, 168)
        table.insert(rects, {
            rect = cc.rect(0, height, width, _height),
            data = v,
            isLoading = hasMore,
        })

        height = height + _height + cellIntervalY
    end

    -- 如果还有更多的数据 --
    if self._replyDataHasMore then
        local _height = 10
        table.insert(rects, {
            rect = cc.rect(0, height, width, _height),
            data = nil,
            isLoading = true,
        })
        height = height + _height + cellIntervalY
    end
	
	self._sliderbar:setVisible(row>0)
	--self._scrollview:setTouchEnabled(height>self._scrollview:getContentSize().height)
	self._scrollview:setScrollBarEnabled(false)
	
    height = math.max(height, self._scrollview:getContentSize().height)

    for _, v in ipairs(rects) do
        v.rect.y = height - v.rect.y - v.rect.height - cellIntervalY
    end

    self._cellData = rects

    self._scrollview:setInnerContainerSize(cc.size(self._scrollview:getContentSize().width, height))
    self:_onEventScroll(self._scrollview)
end

function FeedbackLayer:_onEvent_refreshFeedbackReaded()
    local count = self._feedbackInfo:getUnreadMessageCount()
    local icon_point = self.icon_point

    icon_point:setVisible(count > 0)

    local labelCount = icon_point:getChildByName("label_count")
    labelCount:setString(count < 99 and count or 99)
    labelCount:setPosition(icon_point:getContentSize().width / 2, icon_point:getContentSize().height / 2)
end

return FeedbackLayer