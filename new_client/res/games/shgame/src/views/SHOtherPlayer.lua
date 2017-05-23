local SHOtherPlayer = class("SHOtherPlayer",requireForGameLuaFile("SHPlayer"))
local SHHelper = import("..cfg.SHHelper")
local SHConfig = import("..cfg.SHConfig")
local HeadNodeCCS = requireForGameLuaFile("SHHeadNode_2")
function SHOtherPlayer:ctor(pinfo)
	SHOtherPlayer.super.ctor(self,pinfo)
	self.pType = SHConfig.PlayerType.Type_Opposite --玩家类型
end
function SHOtherPlayer:initHead(HeadNode)
	SHOtherPlayer.super.initHead(self,HeadNode)
	
end

--播放聊天内容动画
function SHOtherPlayer:showChatAnim(data)
	SHOtherPlayer.super.showChatAnim(self,data)
	local animData = { content = data }
	--parentNode --动画播放的父节点
	--position or cc.p(0,0) --动画播放的位置
	--zorder or 10 --动画的层级
	--flippedX or false --是否X轴反转
	--flippedY or false --是否X轴反转
	local pNode = CustomHelper.seekNodeByName(self.headNode,"Image_bg")
	local pSize = pNode:getContentSize()
	local playerData = {
		parentNode = pNode, 
		position = cc.p(pSize.width/2,pSize.height),
		zorder = 1,
		
		}
	self.chatAnimator = ChatAnimatorFactory.createAnimator(SHConfig.animatorType.Character,animData,playerData)
end

--播放牌型动画
--@param showDatas 传入的牌的数据集合 不传入的时候使用手上的牌进行播放
function SHOtherPlayer:showCardType(showDatas)
	--显示我手牌，把底牌亮出来
	local cardInfo = showDatas[1] --第一张牌
	local SHCardInfo = self.cards[1] --第一张牌
	local SHCard = SHCardInfo.node --第一张牌
	if SHCard then
		SHCard:init( { state =SHConfig.CardState.State_Normal,val = cardInfo.val,col = cardInfo.col } )
	end
	SHOtherPlayer.super.showCardType(self,showDatas)
end
--播放翻转牌的动画 视情况而定
function SHOtherPlayer:runOpenCardAnim(createTag)
	self.cards = self.cards or {}
	if table.nums(self.cards) > 0 then
		local SHCard = self.cards[#self.cards].node
		if createTag then
			if table.nums(self.cards)==1 then --第一张牌 不翻转
				SHCard.mState = SHConfig.CardState.State_None
				SHCard:showBack()
			else
				SHCard.mState = SHConfig.CardState.State_Normal
				SHCard:showFront(false)
			end
		else
			if table.nums(self.cards)==1 then --第一张牌 不翻转
				SHCard:changeState(SHConfig.CardState.State_None)
			else
				SHCard:changeState(SHConfig.CardState.State_Normal)
			end
		end
	end
end

function SHOtherPlayer:getOneCard(cardInfo)
	if cardInfo then
		cardInfo.state = SHConfig.CardState.State_None
	end
	SHOtherPlayer.super.getOneCard(self,cardInfo)
	
end
--弃牌
function SHOtherPlayer:fallCard(cardInfo)
	self:playOperationAnim(SHConfig.CardOperation.Fall,-20)
	SHOtherPlayer.super.fallCard(self,cardInfo)
end
--跟注
function SHOtherPlayer:callCard(cardInfo)
	local oldBet = self.gamebet
	self:playOperationAnim(SHConfig.CardOperation.Call,-20)
	SHOtherPlayer.super.callCard(self,cardInfo)
	local diff = self.gamebet - oldBet
	self.gold = self.gold - diff*100
	self:setHeadInfo({ gold = self.gold })
end
--加注
function SHOtherPlayer:raiseCard(cardInfo)
	--todo
	local oldBet = self.gamebet
	self:playOperationAnim(SHConfig.CardOperation.Raise,-20)
	SHOtherPlayer.super.raiseCard(self,cardInfo)
	local diff = self.gamebet - oldBet
	self.gold = self.gold - diff*100
	self:setHeadInfo({ gold = self.gold })
end
--梭哈
function SHOtherPlayer:showHandCard(cardInfo)
	--todo
	local oldBet = self.gamebet
	self:playOperationAnim(SHConfig.CardOperation.ShowHand,-20)
	SHOtherPlayer.super.showHandCard(self,cardInfo)
	local diff = self.gamebet - oldBet
	self.gold = self.gold - diff*100
	self:setHeadInfo({ gold = self.gold })
end
--过牌
function SHOtherPlayer:passCard(cardInfo)
	--todo
	self:playOperationAnim(SHConfig.CardOperation.Pass,-20)
	SHOtherPlayer.super.passCard(self,cardInfo)
end

return SHOtherPlayer