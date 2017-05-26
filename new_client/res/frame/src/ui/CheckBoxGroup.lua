
local CheckBoxGroup = class("CheckBoxGroup")

function CheckBoxGroup:ctor()
    self._data = {}
    self._data.checkBox = {}
    self._data.index = 0
end

function CheckBoxGroup:addCheckBox(cb)
    table.insert(self._data.checkBox, cb)
    dump(self._data.checkBox)
end

function CheckBoxGroup:setSelectedIndex(index)
    if index >= 1 and index <= table.getn(self._data.checkBox) then
        self._data.index = index
        for i, v in ipairs(self._data.checkBox) do
            if self._data.index == i then
                v:setTouchEnabled(false)
                v:setSelected(true)
            else
                v:setTouchEnabled(true)
                v:setSelected(false)
            end
        end
    end
end

return CheckBoxGroup