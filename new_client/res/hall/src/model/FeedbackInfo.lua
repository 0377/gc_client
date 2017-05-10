local FeedbackHelper = requireForGameLuaFile("FeedbackHelper")
FeedbackInfo = class("FeedbackInfo")

function FeedbackInfo:ctor()
    CustomHelper.addSetterAndGetterMethod(self,"unreadMessageCount",0)

    self._pageData = {}
    self._hasMore = true
    self._curPage = 1
end

function FeedbackInfo:getDatas()
    local data = {}
    for page = 1, self._curPage do
        if self._pageData[page] ~= nil then
            for _, v in ipairs(self._pageData[page]) do
                table.insert(data, v)
            end
        end
    end
    return data
end

function FeedbackInfo:insertDateData(data)
    local newData = {}
    for i, v in ipairs(data) do
        local dateData = clone(v)
        dateData["f_id"] = -1
        table.insert(newData, dateData)
        table.insert(newData, v)
    end
    return newData
end

function FeedbackInfo:addData(data,page)
    self._pageData[page] = data
end

function FeedbackInfo:setHasMore(hasMore)
    self._hasMore = hasMore
end

function FeedbackInfo:hasMore()
    return self._hasMore
end

function FeedbackInfo:getCurentPage()
    return self._curPage
end

function FeedbackInfo:setCurentPage(page)
    -- self._curPage = page
    -- 永远为1，因为限制数量50条
    self._curPage = 1
end

function FeedbackInfo:resetCurrentPage()
    self._curPage = 1
end

return FeedbackInfo
