local Fishes = requireForGameLuaFile("Fishes")
local FishGameFish = requireForGameLuaFile("FishGameFish")


local TestFishLayer = class("TestFishLayer", function()
    return display.newNode()
end)

function TestFishLayer:ctor()
    local editBoxSize = cc.size(200, 40)
    local lianxiEdit = ccui.EditBox:create(editBoxSize, "hall_res/account/bb_grxx_bdzh_ditiao.png")
    lianxiEdit:setPosition(display.cx, display.cy * 0.15)
    lianxiEdit:setFontSize(64)
    lianxiEdit:setFontColor(cc.c3b(0xFF, 0, 0))
    lianxiEdit:setPlaceholderFontColor(cc.c3b(0xFF, 0xFF, 0xFF))
    lianxiEdit:setPlaceHolder("测试鱼类型ID")
    lianxiEdit:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    lianxiEdit:registerScriptEditBoxHandler(function(type, sender)
        if type == "return" then
            --            self:UpdatePathById(tonumber(sender:getText()))
            local id = tonumber(sender:getText())

            self:UpdateFishById(id)
            sender:setText("鱼类型ID：" .. sender:getText())
        end
    end)
    self:addChild(lianxiEdit, 100)

end

function TestFishLayer:UpdateFishById(nVisualID)
    if self.pFish ~= nil then
        self.pFish:removeSelf()
        self.pFish = nil
    end

    local fishInfo = {
        fish_id = 1,
        type_id = nVisualID,
        path_id = math.random(100),
        create_tick = 0,
        offest_x = 0,
        offest_y = 0,
        dir = 0,
        delay = 0,
        server_tick = 0,
        fish_speed = 500,
        fis_type = 0,
        troop = false,
        refersh_id = 0,
    }


    local fish = FishGameFish:create(fishInfo)

    fish:align(display.CENTER,display.cx,display.cy):addTo(self)

    self.pFish = fish
end

return TestFishLayer