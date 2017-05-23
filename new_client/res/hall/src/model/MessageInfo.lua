MessageInfo = class("MessageInfo")
local json = require("cjson");
MessageInfo.MSG_TYPE = {
    NOTICE = 2, -- 公告
    MESSAGE = 1, -- 消息
}

MessageInfo.MESSAGE_TYPE = {
    NONE = 0,
    RECHARGE = 1,       -- 充值
    WITHDRAW = 2,       -- 提现
    SYSTEM = 3,         -- 系统消息
    SPECIFY = 4,        -- 私信
}


-- status  0 失败，1 成功

MessageInfo.CONFIG_MESSAGE_TIP = {
    {
        filter = { content_type = MessageInfo.MESSAGE_TYPE.RECHARGE, status = 1 },
        detail_tip = { args = { "order", "money", }, content = '您的充值订单%s\n充值%s元\n已经<p><color>00FF00</color><key>充值成功</key></p>！' },
        brief = { args = { "money", }, content = '您的充值订单,充值%s元,已经充值成功！' },
    },
    {
        filter = { content_type = MessageInfo.MESSAGE_TYPE.RECHARGE, status = 0 },
        detail_tip = { args = { "order", "money", }, content = '您的充值订单%s\n充值%s元\n<p><color>FF0000</color><key>充值失败</key></p>！<p><color>FFFFFF</color><key>请联系客服</key></p>！' },
        brief = { args = { "money", }, content = '您的充值订单,充值%s元,充值失败！' },
    },
    {
        filter = { content_type = MessageInfo.MESSAGE_TYPE.WITHDRAW, status = 1 },
        detail_tip = { args = { "order", "money", }, content = '您的提现订单%s\n提现%s元\n已经<p><color>00FF00</color><key>提现成功</key></p>！' },
        brief = { args = { "money", }, content = '您的提现订单,提现%s元,已经提现成功！' },
    },
    {
        filter = { content_type = MessageInfo.MESSAGE_TYPE.WITHDRAW, status = 0 },
        detail_tip = { args = { "order", "money", }, content = '您的提现订单%s\n提现%s元\n<p><color>FF0000</color><key>提现失败</key></p>！<p><color>FFFFFF</color><key>请联系客服</key></p>！' },
        brief = { args = { "money", }, content = '您的提现订单,提现%s元,提现失败！' },
    },
    --- 系统消息
    {
        filter = { content_type = MessageInfo.MESSAGE_TYPE.SYSTEM },
        detail_tip = { args = { "content", }, content = '%s' },
        brief = { args = { "title", }, content = '%s' },
    },
    --- 私信
    {
        filter = { content_type = MessageInfo.MESSAGE_TYPE.SPECIFY },
        detail_tip = { args = { "content", }, content = '%s' },
        brief = { args = { "title", }, content = '%s' },
    },
}

function MessageInfo:ctor()
    self:reset()
end

--- 添加数据数组
function MessageInfo:addData(data, bInit)
    if bInit then
        self._dataLoaded = true
    end

    local newTipMsg = nil
    for _, v in ipairs(data or {}) do
        local msg = self:addDataSingle(v)
        if msg then
            if msg.Type == self.MSG_TYPE.MESSAGE then
                print("addNewMessage")
                newTipMsg = msg
            elseif msg.Type == self.MSG_TYPE.NOTICE then
                print("addNewNotice")
                GameManager:getInstance():getHallManager():getHallDataManager():addNewNotice(msg)
            end
        end
    end

    if newTipMsg and newTipMsg.Readed == false then
        -- local runningScene = cc.Director:getInstance():getRunningScene()
        -- if runningScene.__cname == "HallScene" then

        -- else
        --     local MessageTipLayer = requireForGameLuaFile("MessageTipLayer")
        --     MessageTipLayer:createWithMessage()
        -- end
        local MessageTipLayer = requireForGameLuaFile("MessageTipLayer")
        MessageTipLayer:createWithMessage(newTipMsg)
    end
end

--- 添加单个数据
function MessageInfo:addDataSingle(data)
    local message = self:formatData(data)

    if #self._data > 0 then
        local hasSame = false
        for _, v in ipairs(self._data) do
            if v.Id == message.Id and v.Type == message.Type then
                hasSame = true
                break
            end
        end
        if not hasSame then
            table.insert(self._data, message)
        else
            return nil
        end
    else
        table.insert(self._data, message)
    end

    return message
end

--- 格式化数据
function MessageInfo:formatData(data)
    local message = {
        Id = data.id,
        Type = data.msg_type,
        StartTime = data.start_time,
        EndTime = data.end_time,
        Readed = data.is_read == 2,      -- 1 未读 2 已读
        Content = data.content,
        _Content = json.decode(data.content),
    }
    return message
end

function MessageInfo:getData()
    -- 如果已经加载了，并且距离上次加载时间超过5秒 --
    local time = os.clock()
    if not self._dataLoaded  and time - self._lastLoadedTime > 5 then
        self._lastLoadedTime = time
        local msgMng = GameManager:getInstance():getHallManager():getHallMsgManager()
        msgMng:sendQueryPlayerMsgData()
    end

    return self._data, self._dataLoaded
end

--- 通过类型获取消息数据
function MessageInfo:getDataByType(...)
    local types = { ... }
    local result = {}

    local timeNow = socket.gettime()
    local data,loaded = self:getData()

    for _, v in ipairs(data) do
        if timeNow > v.StartTime and timeNow < v.EndTime then
            for __, vv in ipairs(types) do
                if vv == v.Type then
                    table.insert(result, v)
                    break
                end
            end
        end
    end

    return result,loaded
end

function MessageInfo:getUnreadMessageCountBytype(...)
    local types = { ... }
    local count = 0

    local timeNow = socket.gettime()
    local data,loaded = self:getData()
    for _, v in ipairs(data) do
        if timeNow > v.StartTime and timeNow < v.EndTime then
            for __, vv in ipairs(types) do
                if vv == v.Type and not v.Readed then
                    count = count + 1
                    break
                end
            end
        end
    end

    return count
end

--- 通过消息类型，获取是否有未读消息
function MessageInfo:getUnReadedMessageByType(...)
    local types = { ... }
    local readed = false
    local ra

    local timeNow = socket.gettime()
    local data,loaded = self:getData()
    dump(data)
    for _, v in ipairs(data) do
        if timeNow > v.StartTime and timeNow < v.EndTime then
            for __, vv in ipairs(types) do
                if vv == v.Type and not v.Readed then
                    readed = true
                    return readed, loaded
                end
            end
        end
    end

    return readed,loaded
end

--- 初始化
function MessageInfo:reset()
    self._data = {}
    self._dataLoaded = false
    self._lastLoadedTime = 0
end

function MessageInfo:filterMessageConfig(message)
    local _Content = message._Content
    local result = nil
    for _,v in ipairs(self.CONFIG_MESSAGE_TIP) do
        local match = true
        for kk,vv in pairs(v.filter) do
            if vv ~= _Content[kk] then
                match = false
                break
            end
        end
        if match then
            result = v
            break
        end
    end

    return result
end

--- 解析消息详细内容
function MessageInfo:parseMessageDetailTip(message)
    local _Content = message._Content
    local result = self:filterMessageConfig(message)

    local args = {}
    for _,v in ipairs(result.detail_tip.args) do
        table.insert(args,string.urldecode(_Content[v]))
    end

    return string.format(result.detail_tip.content,unpack(args))
end

--- 解析消息简介
function MessageInfo:parseMessageBrief(message)
    local _Content = message._Content
    local result = self:filterMessageConfig(message)

    local args = {}
    for _,v in ipairs(result.brief.args) do
        table.insert(args,string.urldecode(_Content[v]))
    end

    return string.format(result.brief.content,unpack(args))
end

return MessageInfo
