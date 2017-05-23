
-- BrnnGameEnd = class("BrnnGameEnd", function()
--     return display.newLayer()
-- end)

-- function BrnnGameEnd:ctor()

--     local csNodePath = CustomHelper.getFullPath("JieSuan.csb")
--     self._uiLayer = cc.CSLoader:createNode(csNodePath)
--     self:addChild(self._uiLayer)

--     self._gameEndBG = tolua.cast(CustomHelper.seekNodeByName(self._uiLayer, "jiesuan"), "ccui.ImageView") --self._uiLayer:getChildByName("jiesuan")
--     print("self._gameEndBG:",self._gameEndBG)

--     self._donghuaPanel = tolua.cast(CustomHelper.seekNodeByName(self._gameEndBG, "donghuaPanel"), "ccui.Layout") --self._gameEndBG:getChildByName("donghuaPanel")

--     self.closeBtn = tolua.cast(CustomHelper.seekNodeByName(self._uiLayer, "closeBtn"), "ccui.Button")
--     self.closeBtn:addClickEventListener(function ()
--         -- body
--          self:dismiss()
--     end)

--     local function closeCallBack(sender, type)
--         if type == ccui.TouchEventType.ended then
--             self:dismiss()
--         end
--     end
    

    
--     -- --继续按钮
--     -- self._gameEndBG:getChildByName("jixuBtn"):addTouchEventListener(closeCallBack)
--     -- layer:setTouchEnabled(true)
--     -- layer:addTouchEventListener(closeCallBack)
    
--     -- self._bgPosX = self._gameEndBG:getPositionX()
--     -- self._bgPosY = self._gameEndBG:getPositionY()
    
--     -- self._gameEndBG:setPositionY(2000)
--     -- self._show = false

--     -- local str_time = 5
--     -- local function step()
--     --     str_time = str_time-1    
--     --     if str_time <= 0 then
--     --         self:dismiss()
--     --     end
--     -- end 
--     -- local seq = transition.sequence({
--     --     cc.DelayTime:create(1),
--     --     cc.CallFunc:create(step)
--     --     })
--     -- self._gameEndBG:runAction(cc.RepeatForever:create(seq))
-- end

-- function BrnnGameEnd:dismiss(data)
--     -- if self._show == false then
--     --     return
--     -- end
--     self:removeFromParent()
--     -- self._gameEndBG:stopAllActions()
--     -- self._gameEndBG:runAction(cc.Sequence:create(cc.MoveBy:create(0.6,{['x']=0, ['y']=2000}), cc.CallFunc:create(function()
--     --     self:removeFromParent()
--     -- end)))
-- end

-- function BrnnGameEnd:show(playerLabel)

-- -- "chair_id"   = 352
-- -- [LUA-print] -             "earn_score" = 1000
-- -- [LUA-print] -             "pay_score"  = 100
-- -- [LUA-print] -             "system_tax" = 100
--     ---自己

--     local wanjiaLabel = tolua.cast(CustomHelper.seekNodeByName(self._gameEndBG, "wanjiaLabel1"), "ccui.Text");
--     wanjiaLabel:setString(playerLabel["earn_score"] or 0)

--     local zhuangjiaLabel = tolua.cast(CustomHelper.seekNodeByName(self._gameEndBG, "zhuangjiaLabel1"), "ccui.Text");
--     zhuangjiaLabel:setString(playerLabel["banker_score"] or 0)

--     local suishouLabel = tolua.cast(CustomHelper.seekNodeByName(self._gameEndBG, "suishouLabel1"), "ccui.Text");
--     suishouLabel:setString(playerLabel["system_tax"] or 0)


--     ---local function showDetail()
--     --     local pLab=self._gameEndBG:getChildByName("wanjiaLabel")
--     --     local BLab=self._gameEndBG:getChildByName("zhuangjiaLabel")
--     --     local SLab=self._gameEndBG:getChildByName("suishouLabel")

--     --     if playerLabel<0 then
--     --         playerLabel=playerLabel*(-1)
--     --         pLab:getChildByName("fuhao"):setVisible(true)
--     --     else
--     --         pLab:getChildByName("fuhao"):setVisible(false)
--     --     end
--     --     if bankerLabel<0 then
--     --         bankerLabel=bankerLabel*(-1)
--     --         BLab:getChildByName("fuhao"):setVisible(true)
--     --     else
--     --         BLab:getChildByName("fuhao"):setVisible(false)
--     --     end
--     --     if shuishouLabel<0 then
--     --         shuishouLabel=shuishouLabel*(-1)
--     --         SLab:getChildByName("fuhao"):setVisible(true)
--     --     else
--     --         SLab:getChildByName("fuhao"):setVisible(false)
--     --     end

--     --     pLab:setString(playerLabel)
--     --     BLab:setString(app.table:MoneyShowStyle(bankerLabel))
--     --    -- SLab:setString(shuishouLabel)
--     --     ----------------------播放动画
--     --     ccs.ArmatureDataManager:getInstance():addArmatureFileInfo( "GameBrnn/niuniuyinzhang/niuniuyinzhang0.png",
--     --         "GameBrnn/niuniuyinzhang/niuniuyinzhang0.plist",
--     --         "GameBrnn/niuniuyinzhang/niuniuyinzhang.ExportJson" )  

--     --     for i=1, 5 do           
--     --         local t_animation = ccs.Armature:create( "niuniuyinzhang" ) 
--     --         local defen=0
--     --         --播放动画坐标 
--     --         local tmpPosY = 430
--     --         if i==1 then
--     --             t_animation:setPosition(cc.p(340, tmpPosY))
--     --             defen=numD
--     --         elseif i==2 then
--     --             t_animation:setPosition(cc.p(515, tmpPosY))
--     --             defen=numN
--     --         elseif i==3 then
--     --             t_animation:setPosition(cc.p(855, tmpPosY))
--     --             defen=numX
--     --         elseif i==4 then
--     --             t_animation:setPosition(cc.p(1050, tmpPosY))
--     --             defen=numB
--     --         elseif i==5 then
--     --             t_animation:setPosition(cc.p(700, tmpPosY))
--     --             defen=numZ
--     --         end                              
--     --         self._donghuaPanel:addChild(t_animation)

--     --         --替换图片
--     --         local t_str = ""  

--     --         if defen>=3 and defen<=11 then
--     --             local shu=defen-2
--     --             t_str = "GameBrnn/".."niu"..shu..".png"        
--     --         elseif defen == 1 then
--     --             t_str = "GameBrnn/".."niu0"..".png"
--     --         elseif defen>=12 and defen<=14 then
--     --             t_str = "GameBrnn/".."niuniu"..".png"
--     --         elseif defen==15 then
--     --             t_str = "GameBrnn/".."yinNiu"..".png"
--     --         elseif defen==16 then
--     --             t_str = "GameBrnn/".."jinNiu"..".png"
--     --         elseif defen==17 then
--     --             t_str = "GameBrnn/".."zhaDan"..".png"
--     --         end   

--     --         local skin = ccs.Skin:create(t_str)
--     --         t_animation:getBone("niuniuyinzhang1"):addDisplay(skin, 0)
--     --         t_animation:getBone("niuniuyinzhang1"):changeDisplayWithIndex(0, true)
--     --         t_animation:setVisible(false)
--     --         t_animation:setScale(0.6)
--     --         --播放动画
--     --         local function removeEnemy(node, tab)
--     --             t_animation:setVisible(true)
--     --             t_animation:getAnimation():play("niuniuyinzhangdonghua1")
--     --         end
--     --         --播放声音
--     --         local function removeEnemy2(node, tab)
--     --             app.musicSound:playSound(GAIZHANG)
--     --         end
--     --         local callfunc = cc.CallFunc:create(removeEnemy)
--     --         local callfunc2 = cc.CallFunc:create(removeEnemy2)
--     --         --播放动画时间
--     --         local time=(i-1)*0.5+0.2
--     --         self:runAction(cc.Sequence:create(cc.MoveBy:create(time,cc.p(0,0)),callfunc,cc.MoveBy:create(0.15,cc.p(0,0)),callfunc2))
--     --     end
--     -- end
    
--     -- self._gameEndBG:runAction(cc.Sequence:create(cc.MoveTo:create(0.6, {['x']=self._bgPosX, ['y']=self._bgPosY}),
--     --     cc.MoveBy:create(0.05, {['x']=0, ['y']=20}), cc.MoveBy:create(0.04, {['x']=0, ['y']=-20}), cc.CallFunc:create(showDetail), cc.CallFunc:create(function() 
--     --         self._show = true
--     --     end)))
-- end


-- return BrnnGameEnd