local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local NoticeLayer = class("NoticeLayer", CustomBaseView);
function NoticeLayer:ctor()
    NoticeLayer.super.ctor(self)
    self:setCascadeOpacityEnabled(true)
    local CCSLuaNode =  requireForGameLuaFile("NoticeLayerCCS")
    self._ui = CCSLuaNode:create().root:addTo(self)


    local background = tolua.cast(CustomHelper.seekNodeByName(self._ui, "background"), "ccui.Widget")
    background:setTouchEnabled(true)
    self._background_Pos = { background:getPosition() }
    self.background = background

    local btn_close = background:getChildByName("btn_close")
    local btn_confirm = background:getChildByName("btn_confirm")

    btn_close:addTouchEventListener(handler(self, self._onBtnTouched_close))
    btn_confirm:addTouchEventListener(handler(self, self._onBtnTouched_close))

    local scrollviewCell = background:getChildByName("scrollviewCell"):hide()
    self.scrollviewCell = scrollviewCell

    self.scrollview = background:getChildByName("scrollview")

    self.scrollview:addEventListener(handler(self, self._onEvent_scrollview))


    local loadingbar = background:getChildByName("loadingbar")
    loadingbar:setVisible(false)
    loadingbar:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 180)))
    self._loadingBar = loadingbar

    self._labelTip = background:getChildByName("label_tip"):hide()
end

function NoticeLayer:onEnter()
    self:addCustomEventListener("kNotifyName_RefreshMessageData", handler(self, self._onEvent_refreshMessageData))

    CustomHelper.addAlertAppearAnim(self.background);

    self:_onEvent_scrollview(self.scrollview, 4)
    self:setVisible(true)
    self:setPosition(0, 0)
    self:UpdateContent()
end

function NoticeLayer:onExit()
    self:removeAllEventListeners()
end

function NoticeLayer:onCleanup()
end

function NoticeLayer:onLoading()
    self._loadingBar:setVisible(true)
    self.scrollview:setVisible(false)
end

function NoticeLayer:onLoadingEnd(bSucess, result)
    if bSucess then
        self._loadingBar:setVisible(false)
        self.scrollview:setVisible(true)
    else
        self._loadingBar:setVisible(false)
        self.scrollview:setVisible(true)
    end
end

function NoticeLayer:onShown()
end

function NoticeLayer:_onBtnTouched_cell(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        sender.bExpand = not sender.bExpand

        -- 如果点开了，并且未读,标记已读 --
        if sender.bExpand and sender.data and not sender.data.extra.Readed then
            local msgMng = GameManager:getInstance():getHallManager():getHallMsgManager()
            sender.data.extra.Readed = true
            sender.data.readed = true

            msgMng:sendSetMsgReadFlag(sender.data.extra)
        end

        self._selectedCell = sender
        self:updateView()
    end
end

function NoticeLayer:_onBtnTouched_close(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        self:removeSelf()
    end
end

function NoticeLayer:_onEvent_scrollview(sender, type)
end

function NoticeLayer:_onEvent_refreshMessageData()
    self:UpdateContent()
end

function NoticeLayer:createCell(width, data)
    local cell = self.scrollviewCell:clone():show()
    local bg_title = cell:getChildByName("bg_title")
    local label_tittle = bg_title:getChildByName("label_tittle")
    local label_time = bg_title:getChildByName("label_time")
    local btn_up = bg_title:getChildByName("btn_up")
    local btn_down = bg_title:getChildByName("btn_down")
    local bg_content = cell:getChildByName("bg_content")
    local label_content = CustomHelper.seekNodeByName(bg_content, "label_content")
    local icon_dot = cell:getChildByName("icon_dot")

    cell:addTouchEventListener(handler(self, self._onBtnTouched_cell))
    btn_up:addTouchEventListener(function(sender, eventType) self:_onBtnTouched_cell(cell, eventType) end)
    btn_down:addTouchEventListener(function(sender, eventType) self:_onBtnTouched_cell(cell, eventType) end)

    cell.bg_title = bg_title
    cell.bg_content = bg_content
    cell.label_tittle = label_tittle
    cell.label_time = label_time
    cell.btn_up = btn_up
    cell.btn_down = btn_down
    cell.label_content = label_content
    cell.icon_dot = icon_dot

    label_tittle:setString(data.title)
    label_time:setString(data.time)

    label_content:setTextAreaSize(cc.size(label_content:getParent():getContentSize().width, 0));
    label_content:ignoreContentAdaptWithSize(true) 
    label_content:setString(data.content)

    -- local richText = myLua.LuaBridgeUtils:createHLCustomRichTextWithNode(data.content,label_content,0);
    -- if label_content:getParent():getChildByName(richText:getName()) then
    --     --todo
    --     --print("delete skill description richtext");
    --     label_content:getParent():removeChildByName(richText:getName(), true);
    -- end
    -- richText:formatText();
    -- richText:setPosition(cc.p(richText:getPositionX() + 3,richText:getPositionY()))
    -- richText:setVisible(true)
    -- label_content:getParent():addChild(richText)

    cell:setAnchorPoint(display.LEFT_BOTTOM)

    cell.data = data
    return cell
end

function NoticeLayer:updateCell(cell, data)
    if cell.bExpand then
        local width = cell:getContentSize().width

        local sizeTitle = cell.bg_title:getContentSize()
        local sizeContent = cell.bg_content:getContentSize()
        local height = sizeTitle.height + sizeContent.height
        cell:setContentSize(width, height)

        cell.bg_content:move(width / 2, cell.bg_content:getContentSize().height / 2)
        cell.bg_title:move(width / 2, cell.bg_content:getContentSize().height + cell.bg_title:getContentSize().height / 2)
        cell.icon_dot:move(width - 15, height - 15)
        cell.icon_dot:hide()


        cell.bg_content:setVisible(true)
        cell.btn_up:setVisible(false)
        cell.btn_down:setVisible(true)
    else
        local width = cell:getContentSize().width
        local height = cell.bg_title:getContentSize().height

        cell:setContentSize(width, height)

        cell.bg_content:setVisible(false)
        cell.bg_title:move(width / 2, height / 2)
        cell.icon_dot:move(width - 15, height - 15)
        cell.icon_dot:setVisible(not data.readed)

        cell.btn_up:setVisible(true)
        cell.btn_down:setVisible(false)
    end
end

function NoticeLayer:updateView()
    self._labelTip:setVisible(#self._data == 0)

    local size = self.scrollview:getContentSize()
    local width = size.width
    local height = 0

    for _, v in ipairs(self._data) do
        if not v.node then
            v.node = self:createCell(width - 50, v.data)
            self.scrollview:addChild(v.node)
        end

        self:updateCell(v.node, v.data)
        -- v.node:move(0, height)
        v.height = v.node:getContentSize().height

        height = height + v.height + 10
    end
    height = math.max(height, size.height)

    local _height = height
    for k, v in ipairs(self._data) do
        -- local v = self._data[#self._data - k + 1]
        v.node:move(0, _height - v.height - 10)
        _height = _height - v.height - 10
    end


    self.scrollview:setInnerContainerSize(cc.size(width, height))

    -- 位置智能偏移 --
    if self._selectedCell then
        local container = self.scrollview:getInnerContainer()
        local viewSize = self.scrollview:getContentSize()
        local x, y = container:getPosition()
        local viewRect = cc.rect(-x, -y, viewSize.width, viewSize.height)

        local a = self._selectedCell
        local left = math.round(a:getPositionX() - a:getAnchorPoint().x * a:getContentSize().width * a:getScaleX())
        local bottom = math.round(a:getPositionY() - a:getAnchorPoint().y * a:getContentSize().height * a:getScaleY())
        local cellRect = cc.rect(left, bottom, a:getContentSize().width, a:getContentSize().height)

        -- 如果CELL完全是VIEW内
        if viewRect.x <= cellRect.x
                and viewRect.y <= cellRect.y
                and viewRect.x + viewRect.width >= cellRect.x + cellRect.width
                and viewRect.y + viewRect.height >= cellRect.y + cellRect.height
        then
            -- 不管
        else

            if viewRect.y - cellRect.y > viewRect.y + viewRect.height - (cellRect.y + cellRect.height) then
                -- 离顶部近
                local y = -cellRect.y + viewSize.height
                container:setPositionY(y)
            else
                local y = -cellRect.y
                container:setPositionY(y)
            end
        end
    end
    self:_onEvent_scrollview(self.scrollview, 4)
end

function NoticeLayer:UpdateContent()
    local playInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    local messageInfo = playInfo:getMessageInfo()

    local message, loaded = messageInfo:getDataByType(messageInfo.MSG_TYPE.NOTICE)
    if not loaded then
        -- self:onLoading()
        self:onLoadingEnd()
    else
        self:onLoadingEnd()
    end


    local timeNow =  GameManager:getInstance():getHallManager():getHallDataManager():getServerTime()
    local timeNow = socket.gettime()

    local content = {}
    message = message or {}
    for _, v in ipairs(message) do
        if timeNow > v.StartTime and timeNow < v.EndTime then
            local leftTime = math.max(v.EndTime - os.time(), 1)
            local leftDay = math.ceil(leftTime / 86400)

            local textTitle,textContent = "标题","内容"
            if v._Content and type(v._Content) == "table" then
                textTitle = v._Content.title and type(v._Content.title) == "string" and string.urldecode(v._Content.title) or "标题"
                textContent = v._Content.content and type(v._Content.content) == "string" and string.urldecode(v._Content.content) or "内容"
            end

            table.insert(content, {
                title = textTitle,
                content = textContent,
                time = string.format("%d天后删除", leftDay),
                readed = v.Readed,
                extra = v,
            })
        end
    end


    --     content = {
    --         {
    --             title = "问：您们的网站携带病毒吗？",
    --             content = "答：我们是正规的公司网站平台。我们的平台通过360权威认证，不携带任何的病毒，请您放心下载。",
    --         },
    --         {
    --             title = "问：锁定机器后无法登录怎么办？",
    --             content = "答：应回到原锁定的机器重新登陆解锁或联系网站客服进行解锁。",
    --         },
    --         {
    --             title = "问：我充值了为什么没有金币？",
    --             content = "答：请您联系客服提供游戏、账号或充值订单号查询。（支付成功后，会自动返回官网，如果没有跳转或是弹出充值成功的页面，请您不要关闭充值窗口）",
    --         }, {
    --             title = "问：金币是否有有效期？",
    --             content = "答：金币可以永久使用。",
    --         }, {
    --             title = "问：登录密码或安保险箱密码忘记了怎么办？",
    --             content = "答：您可以点击大厅登录窗口右侧的[找回密码]，然后根据提示找回登录密码，或者联系客服提供您注册时的身份证等资料找回。 ",
    --         },
    --         {
    --             title = "问：深海捕鱼中鱼打死概率状态如何判断？",
    --             content = "答：在深海捕鱼游戏中，鱼是有生命值的，越大的鱼生命值越大，子弹在爆炸的时候，光圈范围内的鱼平摊到您子弹发射的伤害。相应的，鱼也有闪避值，有几率闪躲伤害。另外，子弹有一定机率的暴击伤害，有几率触发子弹多倍威力伤害。建议您也可以再到游戏中体验试试看。",
    --         },
    --         {
    --             title = "问：为什么充值时点击立即充值没有反应？",
    --             content = "答：这一般是由于浏览器版本过低或自身系统存在病毒与网络状况不良所导致。您可以使用最新的IE浏览器版本，尝试查杀病毒，并且临时允许弹出窗口，清除IE缓存，还原IE高级设置，恢复默认级别等操作。",
    --         },
    --     }

    self.scrollview:removeAllChildren()

    self._data = {}
    for _, v in ipairs(content or {}) do
        table.insert(self._data, {
            data = v,
            node = nil,
        })
    end

    self._selectedCell = nil;
    self:updateView()
end

return NoticeLayer