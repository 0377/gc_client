--local app = test.__god_obj


local GFlowerSound = class("GFlowerSound")

-- 背景音乐 --
GFlowerSound.BGMS = {
    GFLOWER_BGM_1 = "bg_music.mp3"
}

-- 音效 --
GFlowerSound.EFFECTS = {
    GF_BUTTON_CLICK = "button.mp3",
    --
    GF_DEALER_SEND = "dealer_send_card.mp3",
    GF_DEALER_ADD_SCORE = "dealer_add_score.mp3",
    GF_DEALER_ALL_READY = "dealer_all_ready.mp3",
    --
    GF_SEND_CARD = "",
    GF_CARD_SINGLE = "",
    GF_CARD_DOUBLE = "type_double.mp3",
    GF_CARD_SHUN_ZI = "type_shunjin.mp3",
    GF_CARD_JIN_HUA = "type_jinhua.mp3",
    GF_CARD_SHUN_JIN = "type_shunjin.mp3",
    GF_CARD_BAO_ZI_MAN = "type_baozi_man.mp3",
    GF_CARD_BAO_ZI_WOMAN = "type_baozi_woman.mp3",
    GF_CARD_SPECIAL = "",
    --
    GF_CARD_TYPE = "card_type.mp3",
    GF_ELECTRIC = "electric.mp3",
    GF_COIN_FLY_OUT = "coin_fly_out.mp3",
    GF_COIN_FLY_IN = "add_score.mp3",
    GF_WIN = "win.mp3",
    GF_LOSE = "lose.mp3",
    GF_ALL_READY = "all_ready.mp3",
    --
    GF_MAN_ALL_IN = "male/allin.mp3",
    GF_MAN_BI_PAI = "male/bipai.mp3",
    GF_MAN_GIVE_UP = "male/fangqi.mp3",
    GF_MAN_FOLLOW = {
        "male/genzhu1.mp3",
        "male/genzhu2.mp3",
        "male/genzhu3.mp3",
    },
    GF_MAN_ADD_SCORE = {
        "male/jiazhu1.mp3",
        "male/jiazhu2.mp3",
        "male/jiazhu3.mp3",
        "male/jiazhu4.mp3",
    },
    GF_MAN_LOOK_CARD = "male/kanpai.mp3",
    --
    GF_GIRL_ALL_IN = "female/allin.mp3",
    GF_GIRL_BI_PAI = "female/bipai.mp3",
    GF_GIRL_GIVE_UP = "female/fangqi.mp3",
    GF_GIRL_FOLLOW = {
        "female/genzhu1.mp3",
        "female/genzhu2.mp3",
        "female/genzhu3.mp3",
    },
    GF_GIRL_ADD_SCORE = {
        "female/jiazhu1.mp3",
        "female/jiazhu2.mp3",
        "female/jiazhu3.mp3",
        "female/jiazhu4.mp3",
    },
    GF_GIRL_LOOK_CARD = "female/kanpai.mp3",
}

GFlowerSound.PlayerAction = {
    ALL_IN = 0,
    BI_PAI = 0,
    GIVE_UP = 0,
    FOLLOW = 0,
    ADD_SCORE = 0,
    LOOK_CARD = 0,
}

function GFlowerSound:ctor()
    self:Init()
    self._index = 1
end

function GFlowerSound:Init()
    self._musicOpen = true
    self._soundOpen = true
    for k, v in pairs(self.BGMS) do
        --MusicAndSoundManager:getInstance():addMusic(k, "GameGFlower/sound/" .. v)
        MusicAndSoundManager:getInstance():addMusic(v, "sound/" .. v)
    end
    for k, v in pairs(self.EFFECTS) do
        if type(v) == "table" then
            for kk, vv in pairs(v) do
                MusicAndSoundManager:getInstance():addSound(k .. kk, "GameGFlower/sound/" .. vv)
            end
        else
            MusicAndSoundManager:getInstance():addSound(k, "GameGFlower/sound/" .. v)
        end
    end
end

function GFlowerSound:setMusic(v)
    self._musicOpen = v
    if self._musicOpen == true then
        local bgm = self.BGMS["GFLOWER_BGM_" .. self._index]
        --print("播放背景音乐---------"..bgm)
        MusicAndSoundManager:getInstance():playMusicWithFile("sound/"..bgm, true)
    else
        MusicAndSoundManager:getInstance():stopMusic()
    end
end

function GFlowerSound:setSound(v)
    self._soundOpen = v
end

function GFlowerSound:getMusic()
    return self._musicOpen
end

function GFlowerSound:getSound()
    return self._soundOpen
end

-- 背景音乐 --
function GFlowerSound:PlayBgm(index)
    -- index = index or self._index
    -- self._index = index

    -- local _bgm = "GFLOWER_BGM_" .. index
    -- MusicAndSoundManager:getInstance():playMusicWithFile("sound/".._bgm, true)
    -- print("播放背景音乐---------")
    if self._musicOpen == true then
        index = index or self._index
        if not self.BGMS[index] then
            index = 1
        end
        self._index = index


        local bgm = self.BGMS["GFLOWER_BGM_" .. index]
        --print("播放背景音乐---------"..bgm)
        MusicAndSoundManager:getInstance():playMusicWithFile("sound/"..bgm, true)
    end
end

-- 发牌 --
function GFlowerSound:PlayEffect_SendCard()
    if self._soundOpen == true then
        local _sendCard = self.EFFECTS["GF_DEALER_SEND"]
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/".._sendCard)
    end
end

-- 请下注 --
function GFlowerSound:PlayEffect_ToAdd()
    if self._soundOpen == true then
        local _sound = self.EFFECTS["GF_DEALER_ADD_SCORE"]
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/".._sound)
    end
end

-- 牌型 --
function GFlowerSound:PlayEffect_CardType(isMan, cardType)
    if self._soundOpen == true then
        local _cardEff = {
            -- [GFlowerConfig.CARD_TYPE.CT_SINGLE] = "GF_CARD_SINGLE",
            [GFlowerConfig.CARD_TYPE.CT_DOUBLE] = "GF_CARD_DOUBLE",
            [GFlowerConfig.CARD_TYPE.CT_SHUN_ZI] = "GF_CARD_SHUN_ZI",
            [GFlowerConfig.CARD_TYPE.CT_JIN_HUA] = "GF_CARD_JIN_HUA",
            [GFlowerConfig.CARD_TYPE.CT_SHUN_JIN] = "GF_CARD_SHUN_JIN",
            -- [GFlowerConfig.CARD_TYPE.CT_BAO_ZI] = "GF_CARD_BAO_ZI",
            -- [GFlowerConfig.CARD_TYPE.CT_SPECIAL] = "GF_CARD_SPECIAL",
        }
        if cardType == GFlowerConfig.CARD_TYPE.CT_BAO_ZI then
            if isMan then
                _cardEff[GFlowerConfig.CARD_TYPE.CT_BAO_ZI] = "GF_CARD_BAO_ZI_MAN"
            else
                _cardEff[GFlowerConfig.CARD_TYPE.CT_BAO_ZI] = "GF_CARD_BAO_ZI_WOMAN"
            end
        end
        if _cardEff[cardType] then
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..self.EFFECTS[_cardEff[cardType]])
        end
    end
end

-- 按钮点击 --
function GFlowerSound:PlayerEffect_Click()
    if self._soundOpen == true then 
        local _click = self.EFFECTS["GF_BUTTON_CLICK"]
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/".._click)
    end
end

-- 比牌音效 --
function GFlowerSound:PlayEffect_Compare()
    if self._soundOpen == true then
        local _electric = self.EFFECTS["GF_ELECTRIC"]
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/".._electric)
    end
end

-- 筹码飞出 --
function GFlowerSound:PlayEffect_CoinFlyOut()
    if self._soundOpen == true then
        local _coinFlyOut = self.EFFECTS["GF_COIN_FLY_OUT"]
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/".._coinFlyOut)
    end
end

-- 加注 --
function GFlowerSound:PlayEffect_CoinFlyIn()
    if self._soundOpen == true then
        local _coinFlyIn = self.EFFECTS["GF_COIN_FLY_IN"]
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/".._coinFlyIn)
    end
end

-- 玩家音效 --
function GFlowerSound:PlayEffect_PlayerSound(isMan, effect)
    if self._soundOpen == true then
        if isMan then
            self.PlayerAction.ALL_IN = "GF_MAN_ALL_IN"
            self.PlayerAction.BI_PAI = "GF_MAN_BI_PAI"
            self.PlayerAction.GIVE_UP = "GF_MAN_GIVE_UP"
            self.PlayerAction.FOLLOW = "GF_MAN_FOLLOW"
            self.PlayerAction.ADD_SCORE = "GF_MAN_ADD_SCORE"
            self.PlayerAction.LOOK_CARD = "GF_MAN_LOOK_CARD"
        else
            self.PlayerAction.ALL_IN = "GF_GIRL_ALL_IN"
            self.PlayerAction.BI_PAI = "GF_GIRL_BI_PAI"
            self.PlayerAction.GIVE_UP = "GF_GIRL_GIVE_UP"
            self.PlayerAction.FOLLOW = "GF_GIRL_FOLLOW"
            self.PlayerAction.ADD_SCORE = "GF_GIRL_ADD_SCORE"
            self.PlayerAction.LOOK_CARD = "GF_GIRL_LOOK_CARD"
        end

        local _sound = nil
        if effect == "FOLLOW" or effect == "ADD_SCORE" then
            local _index = math.random(1, #self.EFFECTS[self.PlayerAction[effect]])
            _sound = self.PlayerAction[effect] --.. _index
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..self.EFFECTS[_sound][_index])
        else
            _sound = self.PlayerAction[effect]
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..self.EFFECTS[_sound])
        end
    end
end

-- 胜利 --
function GFlowerSound:PlayEffect_Result(isWin)
    if self._soundOpen == true then
        local _result = nil
        if isWin then
            _result = "GF_WIN"
        else
            _result = "GF_LOSE"
        end
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..self.EFFECTS[_result])
    end
end

-- 催促 --
function GFlowerSound:PlayEffect_AllReady()
    if self._soundOpen == true then
        local _allReady = "GF_DEALER_ALL_READY"
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..self.EFFECTS[_allReady])
    end
end

return GFlowerSound