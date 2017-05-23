local CachedNodeManager = class("CachedNodeManager")

function CachedNodeManager:ctor()
    self._cache = {}
    self._runingCount = {}
    self._cacheLimit = {}
end

function CachedNodeManager:initType(type)
    if not self._cache[type] then
        self._cache[type] = {}
    end
    if not self._runingCount[type] then
        self._runingCount[type] = 0
    end
    if not self._cacheLimit[type] then
        self._cacheLimit[type] = 0
    end
end

function CachedNodeManager:setCacheLimit(type,count)
    self:initType(type)
    self._cacheLimit[type] = count
end

function CachedNodeManager:addNode(type, node)
    self:initType(type)
    node.____cache_type = type
    self._runingCount[type] = self._runingCount[type] + 1
end

function CachedNodeManager:getCachedNode(type)
    self:initType(type)

    local node = table.remove(self._cache[type], 1)
    if node then
        self._runingCount[type] = self._runingCount[type] + 1
        node:setVisible(true)
    end

    return node
end

function CachedNodeManager:getRunningCount(type)
    self:initType(type)
    return  self._runingCount[type]
end

function CachedNodeManager:markUnused(node, type)
    local _type = type or node.____cache_type
    if not _type then return end
    local _table = self._cache[_type]
    if not _table then return end

    self._runingCount[_type] = self._runingCount[_type] - 1

    if self._cacheLimit[_type] and #_table > self._cacheLimit[_type] then
        node:removeSelf()
        return
    end

    node:setVisible(false)
    table.insert(_table, node)
end

return CachedNodeManager