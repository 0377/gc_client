--
-- Author: vincent
-- Date: 2016-07-18 11:21:44
--


NNPoker = class("NNPoker", function()
    return cc.Sprite:create()
end)


--构造
function NNPoker:ctor(font, num)
	self:setScale(0.65)
	self._num = num --牌数
	self._font = font --是否是背面false是背面
    self._animation = nil
	self:getCard(font, num)
	--self:addAnimation()

end

--得到牌型
function NNPoker:getCard(font, num)
	if font then
		self:setTexture("NNPoker/poker_"..num..".png")
	else
		self:setTexture("public/poker/poker_back.png")
	end
end

function NNPoker:getCardNum()
    if self._num ~= nil then
        return self._num
    else
        return 1
    end
end

--显示牌型
function NNPoker:showTexture()
    print("self._num = "..self._num)
    if self._num ~= nil then
        self:setTexture(self:getCardShowPath())
    else
        self:setTexture("public/poker/poker_back.png")
    end
end

--翻牌动画
function NNPoker:openAction()
	local time = 0.2
    local function unReversal()
        self:setTexture("NNPoker/poker_"..self._num..".png")
        self:setFlippedX(true)
    end

    local callfunc = cc.CallFunc:create(unReversal)
    self:runAction(cc.Sequence:create(
    	cc.RotateBy:create(time/2, 0, 90), 
    	callfunc, 
    	cc.RotateBy:create(time/2, 0, 90)
    	))
end

function NNPoker:getCardShowPath(issmall)
	local color = math.floor(self._num%4)
	local pointx = math.floor(self._num/4)
	--print("--------------color:"..color.."-------pointx:"..pointx.."------num:"..self._num)
	if pointx >= 14 then
		local tt = 0
	end
	local x = gameBrnn.CardsV[pointx+1]
		
	
	
	local str = "poker_"..string.format("%d",color).."_"..x..".png"

	if self._num == 52 then
		x = 1
		color = 4
	end
	if self._num == 53 then
		x = 2
		color = 4
	end
	if issmall == true then
		
		local num = color*16+pointx+1
		if self._num == 52 then
			num = 78
		end
		if self._num == 53 then
			num = 79
		end
		print("public/poker/smallpoker_"..num..".png")
		return "public/poker/smallpoker_"..num..".png"
	end
	
	return "public/poker/poker_"..string.format("%d",color).."_"..x..".png"
end


--翻牌动画
function NNPoker:openBackAction(isAddAction)
	--[[local time = 0.2
    local function unReversal()
        
		
        self:setTexture(self:getCardShowPath())
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
    end--]]
	if self._animation ~= nil then
		self:flipCardAction()
	end
	

end

--[[function NNPoker:heng()
	self.:setRotation(90)
end--]]

--添加动画
function NNPoker:addAnimation(num)
    local pointTab = {{265, 630}, {315, 255}, {565, 255}, {825, 255}, {1085, 255}}
    --self:setVisible(false)
    local x, y = self:getPosition()
    local size = self:getContentSize()
--    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo( "HeGuan/niuniuxinfanpai/fanpai0.png",
--        "HeGuan/niuniuxinfanpai/fanpai0.plist" ,
--        "HeGuan/niuniuxinfanpai/fanpai.ExportJson" )
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("public/NN/wz_bbnn_fanpai/wz_bbnn_fanpai.ExportJson" )

    self._animation = ccs.Armature:create( "wz_bbnn_fanpai" )
    --self._animation:setPosition(cc.p(pointTab[num][1], pointTab[num][2]))
	self._animation:setPosition(cc.p(x, y))
    self:getParent():addChild(self._animation, 120)
    --self._animation:getBone("niuniufanpaitihuan"):setScale(0.6)
	self._animation:setScale(0.6)
	--self._animation:setRotation(90)
	self._animation:setVisible(false)
    return self._animation
end

--手动看牌动画
function NNPoker:flipCardAction()
    local x, y = self:getPosition()
    --local t_str = "NNPoker/smallpoker_"..self._num..".png"
	local t_str = self:getCardShowPath(true)--"public/poker/smallpoker_22.png"
    local t_str2 = self:getCardShowPath()
    local skin1 = ccs.Skin:create(t_str)
    local skin2 = ccs.Skin:create(t_str2)
	skin1:setRotation(90)
	--skin2:setRotation(90)
	self._animation:setPosition(cc.p(x, y))
    self._animation:getBone("Layer10"):changeDisplayWithIndex(-1, true)
    self._animation:getBone("Layer11"):changeDisplayWithIndex(-1, true)
    self._animation:getBone("Layer10"):addDisplay(skin1, 0)
    self._animation:getBone("Layer11"):addDisplay(skin2, 0)
	
    -- self._animation:getBone("niuniufanpaishuzi"):changeDisplayWithIndex(0, true)
    -- self._animation:getBone("niuniufanpaitihuan"):changeDisplayWithIndex(0, true)

    local seq = transition.sequence({
        cc.CallFunc:create(function()
			self:setVisible(false)
			self._animation:setVisible(true)
            self._animation:getBone("Layer10"):changeDisplayWithIndex(0, true)
            self._animation:getBone("Layer11"):changeDisplayWithIndex(0, true)
			--self._animation:getBone("niuniufanpaishuzi"):setRotation(90)
			--self._animation:getBone("niuniufanpaitihuan"):setRotation(-90)
            --app.musicSound:playSound("FANPAI")
			--self._animation:setRotation(90)
            self._animation:getAnimation():play("ani_01")

			
			
        end),
        cc.DelayTime:create(1.1),
		
		cc.CallFunc:create(function()
			MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/fanpai.mp3")
            
        end),
		cc.DelayTime:create(0.4),
        cc.CallFunc:create(function()
			MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/fanpai1.mp3")
            self:setVisible(true)
            self:setTexture(self:getCardShowPath())
            self:setRotation(0)
            --self:setPosition(cc.p(x - 15, y + 15))
            --self._animation:getAnimation():stop()
			--self._animation
            self._animation:setVisible(false)
			self._animation:removeFromParent()
        end)
        })
    self:runAction(seq)
end

return NNPoker