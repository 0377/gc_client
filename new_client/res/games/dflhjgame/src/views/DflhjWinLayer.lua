local DflhjWinLayer = class("DflhjWinLayer", function()
    return display.newLayer()
end)



local function thousandBitSeparator( num )
    local numstr = tostring(num)
    local tbl = {}
    local index = string.len(numstr)
    index = index -3
    while index > 0 do
        table.insert(tbl,1,string.sub(numstr,index +1,index+3))
        numstr = string.sub(numstr,0,index)
        index = index -3
    end 
    table.insert(tbl,1,numstr)
    local var = ""
 
    for i,v in ipairs(tbl) do
        var = var ..v .. (i == #tbl and "" or "/") 
    end
   
   return var
end


function DflhjWinLayer:ctor(winnum)

    self.winnum = winnum
    local CCSLuaNode =  requireForGameLuaFile("DflhjWinLayerCCS")
    self.csNode = CCSLuaNode:create().root;
   
    self:addChild(self.csNode);
    self.animBg = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "dfdc_win_eff"),"ccs.Armature")
    self.animGb = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "zj_jinbiyu"),"ccs.Armature")
    local labelWinNUm = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "label_winnum"), "ccui.TextAtlas");
    local btnWin = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_win"),"ccui.Button")
    btnWin:setVisible(false)
    btnWin:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        self:removeFromParent()
    end) 

    if winnum > 1000 then
        btnWin:loadTextures("win_layout/an_d-win.png","win_layout/an_d-win2.png","win_layout/an_d-win2.png")
        btnWin:setContentSize(cc.size(345,77))
        labelWinNUm:setString(thousandBitSeparator(winnum))
    else
        btnWin:loadTextures("win_layout/an-win.png","win_layout/an-win2.png","win_layout/an-win2.png")
        btnWin:setContentSize(cc.size(312,74))
        labelWinNUm:setString(thousandBitSeparator(winnum))
    end

    self.animBg:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
        if _type == ccs.MovementEventType.start then
        elseif _type == ccs.MovementEventType.complete then
            if id == "ani_01" then
                -- sender:getAnimation():play("ani_02,-1,1")
                self.animGb:getAnimation():play("ani_01")
                self.animGb:setVisible(true)
            elseif id == "ani_02" then
               
            elseif id == "ani_03" then
                -- sender:getAnimation():play("ani_04,-1,1")
                self.animGb:getAnimation():play("ani_01")
                self.animGb:setVisible(true)
            elseif id == "ani_04" then
                
            end

        elseif _type == 2 then
        end
    end)


    self.animGb:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
        if _type == ccs.MovementEventType.start then
        elseif _type == ccs.MovementEventType.complete then
            if id == "ani_01" then
               btnWin:setVisible(true)
            end

        elseif _type == 2 then
        end
    end)
	
	 self:startAnim()
end



function DflhjWinLayer:startAnim(  )
     self.animBg:setVisible(true)
    if self.winnum > 1000 then
        self.animBg:getAnimation():play("ani_01")
    else
        self.animBg:getAnimation():play("ani_03")
    end
   
end

return DflhjWinLayer

