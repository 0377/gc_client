MyToastLayer = class("MyToastLayer",cc.Node)
--1，要添加的对象，2文字，3持续时间
function MyToastLayer:ctor(parentLayer,text,num)
    self._uiLayer = cc.Layer:create()
    self:addChild(self._uiLayer)
    self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("MyToastLayerCCS.csb"));
    self._uiLayer:addChild(self.csNode)
    
    self.tipPanel= CustomHelper.seekNodeByName(self.csNode, "tip_panel");
    local t_text= CustomHelper.seekNodeByName(self.csNode, "tip_text")
    t_text:setString(text)

    --self._bg:setTextureRect(t_text:getTextureRect())--getContentSize()

    parentLayer:addChild(self,1000)


    local function unReversal1()
        self:removeFromParent()
    end


    local callfunc1 = cc.CallFunc:create(unReversal1)
    if num == nil or num == 0 then
        self.tipPanel:runAction(cc.Sequence:create(cc.MoveBy:create(1.2,cc.p(0,500)),cc.DelayTime:create(1.0),cc.FadeOut:create(0.7),callfunc1))
    else
        self.tipPanel:runAction(cc.Sequence:create(cc.MoveBy:create(1.2,cc.p(0,500)),cc.DelayTime:create(1.0),cc.FadeOut:create(num),callfunc1))
    end
end
return MyToastLayer

