local FishSound = requireForGameLuaFile("FishSound")

local FishSoundManager = class("FishSoundManager")

local GameEffect = {
    CANNON_SWITCH = 0,
    CASTING_NORMAL = 1,
    CASTING_ION = 2,
    CATCH = 3,
    CATCH1 = 4,
    CATCH2 = 5,
    FIRE = 6,
    IONFIRE = 7,
    INSERT = 8,
    AWARD = 9,
    BIGAWARD = 10,
    ROTARYTURN = 11,
    BINGO = 12,
    BINGO2 = 13,
    WAVE = 14,
    GAME_EFFECT_COUNT = 15,
    EFFECT_BULLET_BOMB = 19,
    BOMB_LASER = 16,
    BOMB_ELECTRIC = 17,
    BOMB_ELECTRIC = 17,
    EFFECT_PARTICAL_BIG_BOMB = 20,
    EFFECT_PARTICAL_BIG_FIREWORKS = 21,
    EFFECT_PARTICAL_FIREWORKS = 22,
    BUTTON_CLICK = 18,
};

local SoundPriority = {
    ["HIT"] = 0,
    ["Fish"] = 1,
    ["ATHER"] = 2,
    ["ATHER_II"] = 3,
    ["WAVE"] = 4,
    ["BUTTON"] = 5,
}


local SoundConfig = {
    ["Net0.mp3"] = { time = 0.1, occupationTime = 0, priority = SoundPriority.HIT },
    ["Net1.mp3"] = { time = 0.1, occupationTime = 0, priority = SoundPriority.HIT },
    ["Fire.mp3"] = { time = 0.2, occupationTime = 0.2, priority = SoundPriority.HIT },
    ["GunFire0.mp3"] = { time = 0.1, occupationTime = 0, priority = SoundPriority.ATHER },
    ["GunFire1.mp3"] = { time = 0.1, occupationTime = 0, priority = SoundPriority.ATHER },
    ["ChangeScore.mp3"] = { time = 0.2, occupationTime = 0, priority = SoundPriority.ATHER },
    ["MakeUP.mp3"] = { time = 0.5, occupationTime = 0, priority = SoundPriority.ATHER },
    ["ChangeType.mp3"] = { time = 0.1, occupationTime = 0, priority = SoundPriority.ATHER },
    ["award.mp3"] = { time = 0.8, occupationTime = 0.5, priority = SoundPriority.ATHER },
    ["bigAward.mp3"] = { time = 4, occupationTime = 4, priority = SoundPriority.ATHER_II },
    ["rotaryturn.mp3"] = { time = 0.1, occupationTime = 0, priority = SoundPriority.ATHER },
    ["CJ.mp3"] = { time = 5, occupationTime = 5, priority = SoundPriority.ATHER_II },
    ["TNNFDCLNV.mp3"] = { time = 2, occupationTime = 1, priority = SoundPriority.ATHER },
    ["surf.mp3"] = { time = 7, occupationTime = 7, priority = SoundPriority.WAVE },
    ["HaiLang.mp3"] = { time = 7, occupationTime = 7, priority = SoundPriority.WAVE },
    ["Fisha0.mp3"] = { time = 2, occupationTime = 1.8, priority = SoundPriority.Fish },
    ["Fisha1.mp3"] = { time = 2, occupationTime = 1.8, priority = SoundPriority.Fish },
    ["Fisha2.mp3"] = { time = 2, occupationTime = 1.8, priority = SoundPriority.Fish },
    ["Fisha3.mp3"] = { time = 1, occupationTime = 1, priority = SoundPriority.Fish },
    ["Fisha4.mp3"] = { time = 4, occupationTime = 3.8, priority = SoundPriority.Fish },
    ["Fisha5.mp3"] = { time = 3, occupationTime = 2.8, priority = SoundPriority.Fish },
    ["Fisha6.mp3"] = { time = 3, occupationTime = 2.8, priority = SoundPriority.Fish },
    ["Fisha7.mp3"] = { time = 2, occupationTime = 1.8, priority = SoundPriority.Fish },
    ["Fisha8.mp3"] = { time = 2, occupationTime = 1.8, priority = SoundPriority.Fish },
    ["Fisha9.mp3"] = { time = 1, occupationTime = 1, priority = SoundPriority.Fish },
    ["Fisha10.mp3"] = { time = 2, occupationTime = 1.8, priority = SoundPriority.Fish },
    ["Fisha11.mp3"] = { time = 1, occupationTime = 1, priority = SoundPriority.Fish },
    ["Fisha12.mp3"] = { time = 1, occupationTime = 1, priority = SoundPriority.Fish },
    ["Fisha13.mp3"] = { time = 2, occupationTime = 1.8, priority = SoundPriority.Fish },
    ["Fisha14.mp3"] = { time = 2, occupationTime = 1.8, priority = SoundPriority.Fish },
    ["Fisha15.mp3"] = { time = 2, occupationTime = 1.8, priority = SoundPriority.Fish },
    ["Fisha16.mp3"] = { time = 2, occupationTime = 1.8, priority = SoundPriority.Fish },
    ["Fisha17.mp3"] = { time = 1, occupationTime = 1, priority = SoundPriority.Fish },
    ["Hit0.mp3"] = { time = 0.1, occupationTime = 0, priority = SoundPriority.HIT },
    ["Hit1.mp3"] = { time = 0.1, occupationTime = 0, priority = SoundPriority.HIT },
    ["Hit2.mp3"] = { time = 1.5, occupationTime = 1, priority = SoundPriority.HIT },
    ["laser.mp3"] = { time = 0.4, occupationTime = 0, priority = SoundPriority.ATHER_II },
    ["electric.mp3"] = { time = 0.4, occupationTime = 0, priority = SoundPriority.ATHER_II },
    ["BigBang.mp3"] = { time = 1, occupationTime = 1, priority = SoundPriority.ATHER_II },
    ["Bigfireworks.mp3"] = { time = 1, occupationTime = 1, priority = SoundPriority.ATHER_II },
    ["fireworks.mp3"] = { time = 0.9, occupationTime = 0.5, priority = SoundPriority.ATHER_II },
    ["click.mp3"] = { time = 0.0, occupationTime = 0.0, priority = SoundPriority.BUTTON },
}


local Config_BGM = {
    "sound/bgm/bgm1.mp3",
    "sound/bgm/bgm2.mp3",
    "sound/bgm/bgm3.mp3",
    "sound/bgm/bgm4.mp3",
}

local Config_fish_sound = {
    ["effect_fish1_1"] = "Fisha1.mp3",
    ["effect_fish2_1"] = "Fisha2.mp3",
    ["effect_fish3_1"] = "Fisha3.mp3",
    ["effect_fish4_1"] = "Fisha4.mp3",
    ["effect_fish5_1"] = "Fisha5.mp3",
    ["effect_fish6_1"] = "Fisha6.mp3",
    ["effect_fish7_1"] = "Fisha7.mp3",
    ["effect_fish8_1"] = "Fisha8.mp3",
    ["effect_fish9_1"] = "Fisha9.mp3",
    ["effect_fish10_1"] = "Fisha10.mp3",
    ["effect_fish11_1"] = "Fisha11.mp3",
    ["effect_fish12_1"] = "Fisha12.mp3",
    ["effect_fish13_1"] = "Fisha13.mp3",
    ["effect_fish14_1"] = "Fisha14.mp3",
    ["effect_fish15_1"] = "Fisha15.mp3",
    ["effect_fish16_1"] = "Fisha16.mp3",
    ["effect_fish17_1"] = "Fisha17.mp3",
    ["effect_fish18_1"] = "Fisha0.mp3",
}

function FishSoundManager:ctor()
    self._soundMng = GameManager:getInstance():getMusicAndSoundManager()
    self.m_soundCategory = {}
    self._bgmId = 1
end

--- 播放背景音乐
function FishSoundManager:playBGM(id, bInit)
    id = id or self._bgmId
    local bgm = Config_BGM[(id - 1) % #Config_BGM + 1]

    if bInit then
        self._soundMng:playMusicWithFile(bgm)
    else
        self._soundMng:playMusicWithFile("sound/bgm/bgm_wave.mp3")

        CustomHelper.performWithDelayGlobal(function()
            self._soundMng:playMusicWithFile(bgm)
        end, 7, false)
    end
end

function FishSoundManager:playFishSound(typeId)
    local soundConf = FishSound[typeId]

    if not soundConf then return end
    local soundFile = Config_fish_sound[soundConf.sound]

    if not soundFile then return end
    self:playEffect(soundFile)
end

function FishSoundManager:playBulletSound()


end

function FishSoundManager:playEffect(file)
    local soundConfig = SoundConfig[file]

    if not soundConfig then return end

    self.m_soundCategory[soundConfig.priority] = self.m_soundCategory[soundConfig.priority] or {
        time = 0,
        last_sound = nil,
    }

    local time = socket.gettime()
    local category = self.m_soundCategory[soundConfig.priority]
    if category.last_sound then
        local old = SoundConfig[category.last_sound]
        if time - category.time < old.time then
            return
        end
    end
    category.time = time
    category.last_sound = file


    self._soundMng:playerSoundWithFile("sound/effect/" .. file)
end


function FishSoundManager:playEffect_buttonClick()

end


return FishSoundManager