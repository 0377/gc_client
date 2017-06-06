--
-- Author: vincent
-- Date: 2016-07-18 11:21:44
--


DZPKPoker = class("DZPKPoker", function()
    return cc.Sprite:create()
end)

--[[
0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,	--方块 A - K
0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,	--梅花 A - K
0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,	--红桃 A - K
0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,	--黑桃 A - K
--]]


--构造
function DZPKPoker:ctor(font, num)
	self:setScale(0.65)
	self._num = num --牌数
	self._font = font --是否是背面false是背面
    self._animation = nil
	self:getCard(font, num)

end

function DZPKPoker:getCardPath(issmall)
	if issmall == true then
		return "tt.png"
		--return "public/poker/smallpoker_"..self._num..".png"
	else
		local color = math.floor(self._num/16)
        local pointx = math.floor(self._num%16)
        --print("self._num:",self._num,"pointx:",pointx)
        local x = gameDzpk.CardsV[pointx]
        --print("self._num:",self._num,"pointx:",pointx,"x:",x,"color:",color)
        local str = "public/poker/poker_"..string.format("%d",color).."_"..x..".png"
		return str
	end

end

function DZPKPoker:ShowLight()
	if self.lightSprite == nil then
		self.lightSprite = cc.Sprite:create(CustomHelper.getFullPath("game_res/secondui/dz_pai_guangxiao.png"))
		self.lightSprite:setScale(5/3)
		self:addChild(self.lightSprite,100)
		local size = self:getContentSize()
		self.lightSprite:setPosition(cc.p(size.width/2,size.height/2))
	end
end

function DZPKPoker:HideLight()
	if self.lightSprite ~= nil then
		self.lightSprite:removeFromParent()
		self.lightSprite = nil
		
	end
end

--得到牌型
function DZPKPoker:getCard(font, num)
	if font then
		self:setTexture(self:getCardPath())
	else
		self:setTexture("public/poker/poker_back.png")
	end
end

function DZPKPoker:getCardNum()
    if self._num ~= nil then
        return self._num
    else
        return 1
    end
end

--显示牌型
function DZPKPoker:showTexture()
    print("self._num = "..self._num)
    if self._num ~= nil then
        self:setTexture(self:getCardPath())
    else
        self:setTexture("public/poker/poker_back.png")
    end
end
--[[
--翻牌动画
function DZPKPoker:openAction()
	local time = 0.2
    local function unReversal()
        self:setTexture("DZPKPoker/poker_"..self._num..".png")
        self:setFlippedX(true)
    end

    local callfunc = cc.CallFunc:create(unReversal)
    self:runAction(cc.Sequence:create(
    	cc.RotateBy:create(time/2, 0, 90), 
    	callfunc, 
    	cc.RotateBy:create(time/2, 0, 90)
    	))
end
--]]
--翻牌动画
function DZPKPoker:openBackAction(isAddAction)
	local time = 0.2
    local function unReversal()
		
        self:showTexture()
        self:setFlippedX(true)
    end
    
    if isAddAction == false then
        unReversal()
        self:setFlippedX(false)
    else
        local callfunc = cc.CallFunc:create(unReversal)
        self:runAction(cc.Sequence:create(
            cc.RotateBy:create(time/2, 0, 90), 
            callfunc, 
            cc.RotateBy:create(time/2, 0, 90)
        ))
    end

end
--[[
--添加动画
function DZPKPoker:addAnimation(num)
    local pointTab = {{265, 630}, {315, 255}, {565, 255}, {825, 255}, {1085, 255}}
    self:setVisible(false)
    local x, y = self:getPosition()
    local size = self:getContentSize()
--    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo( "HeGuan/niuniuxinfanpai/fanpai0.png",
--        "HeGuan/niuniuxinfanpai/fanpai0.plist" ,
--        "HeGuan/niuniuxinfanpai/fanpai.ExportJson" )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("public/DZPK/fanpai_blue/fanpai_blue.ExportJson" )

    self._animation = ccs.Armature:create( "fanpai_blue" )
    self._animation:setPosition(cc.p(pointTab[num][1], pointTab[num][2]))
    self:getParent():addChild(self._animation, 120)
    self._animation:getBone("niuniufanpaitihuan"):setScale(0.6)

    return self._animation
end

--手动看牌动画
function DZPKPoker:flipCardAction()
    local x, y = self:getPosition()
    local t_str = "DZPKPoker/smallpoker_"..self._num..".png"
    local t_str2 = "DZPKPoker/poker_"..self._num..".png"
    local skin = ccs.Skin:create(t_str)
    local skin2 = ccs.Skin:create(t_str2)
    self._animation:getBone("niuniufanpaishuzi"):changeDisplayWithIndex(-1, true)
    self._animation:getBone("niuniufanpaitihuan"):changeDisplayWithIndex(-1, true)
    self._animation:getBone("niuniufanpaishuzi"):addDisplay(skin, 0)
    self._animation:getBone("niuniufanpaitihuan"):addDisplay(skin2, 0)
    -- self._animation:getBone("niuniufanpaishuzi"):changeDisplayWithIndex(0, true)
    -- self._animation:getBone("niuniufanpaitihuan"):changeDisplayWithIndex(0, true)

    local seq = transition.sequence({
        cc.CallFunc:create(function()
            self._animation:getBone("niuniufanpaishuzi"):changeDisplayWithIndex(0, true)
            self._animation:getBone("niuniufanpaitihuan"):changeDisplayWithIndex(0, true)
            app.musicSound:playSound("FANPAI")
            self._animation:getAnimation():play("fapaidonghua3")
        end),
        cc.DelayTime:create(1.5),
        cc.CallFunc:create(function()
            self:setVisible(true)
            self:setTexture("DZPKPoker/poker_"..self._num..".png")
            self:setRotation(0)
            self:setPosition(cc.p(x - 15, y + 15))
            self._animation:getAnimation():stop()
            self._animation:setVisible(false)
        end)
        })
    self:runAction(seq)
end--]]

return DZPKPoker