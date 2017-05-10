
MusicAndSoundManager = class("MusicAndSoundManager")
function MusicAndSoundManager:getInstance()
    return GameManager:getInstance():getMusicAndSoundManager();
end

function MusicAndSoundManager:ctor()
	self:reset()
end

function MusicAndSoundManager:reset()
	self._musics = {}
    self._sounds = {}
end

function MusicAndSoundManager:addMusic(key, musicFile)
	self._musics[key] = musicFile
end

function MusicAndSoundManager:addSound(key, soundFile)
	self._sounds[key] = soundFile
end
function MusicAndSoundManager:playMusicWithFile(file,loop)
    self:stopMusic()
    if self:getMusicSwitch() == false then
        return
    end
    if loop == nil then
        --todo
        loop = true
    end
    local fullPath = CustomHelper.getFullPath(file);
    --print("fullPath---:",fullPath,"名字：",file);
    return cc.SimpleAudioEngine:getInstance():playMusic(fullPath,loop);
end
function MusicAndSoundManager:playMusic(key, bLoop)
    print("'MusicAndSoundManager:playMusic' is deprecated,please use 'MusicAndSoundManager:playMusicWithFile'")
    if not self._musics[key] then
    	return
    end
    self:stopMusic()
    return self:playMusicWithFile(self._musics[key],bLoop);
end
function MusicAndSoundManager:playerSoundWithFile(file)
    if self:getSoundSwitch() == false then
        return
    end

    --local fullPath = CustomHelper.getFullPath(file);
    --print("fullPath:---",file)
    return cc.SimpleAudioEngine:getInstance():playEffect(file,false)
end
function MusicAndSoundManager:playSound(key)
    --print("'MusicAndSoundManager:playSound' is deprecated,please use 'MusicAndSoundManager:playerSoundWithFile'")
    if not self._sounds[key] then
    	return
    end
    print("333333333333")
    return self:playerSoundWithFile(self._sounds[key])
end

function MusicAndSoundManager:stopMusic()
	cc.SimpleAudioEngine:getInstance():stopMusic()
end

function MusicAndSoundManager:pauseMusic()
	cc.SimpleAudioEngine:getInstance():pauseMusic()
end

function MusicAndSoundManager:resumeMusic()
	cc.SimpleAudioEngine:getInstance():resumeMusic()
end

function MusicAndSoundManager:setBackgroundMusicVolume(a_value)
    cc.SimpleAudioEngine:getInstance():setMusicVolume(a_value)
end

function MusicAndSoundManager:setEffectsVolume(a_value)
    cc.SimpleAudioEngine:getInstance():setEffectsVolume(a_value)
end

function MusicAndSoundManager:stopAllSound()
    cc.SimpleAudioEngine:getInstance():stopAllEffects()
end

function MusicAndSoundManager:stopSound( a_value )
    cc.SimpleAudioEngine:getInstance():stopEffect(a_value)
end
--得到音乐开关状态
function MusicAndSoundManager:getMusicSwitch()
    return cc.UserDefault:getInstance():getBoolForKey("music_switch", true)
end
--设置音乐开关
function MusicAndSoundManager:setMusicSwitch(open)
    cc.UserDefault:getInstance():setBoolForKey("music_switch", open)
end
--得到音效开关
function MusicAndSoundManager:getSoundSwitch()
    return cc.UserDefault:getInstance():getBoolForKey("sound_switch", true)
end
--设置音效开关
function MusicAndSoundManager:setSoundSwitch(open)
    cc.UserDefault:getInstance():setBoolForKey("sound_switch", open)
end

-- 从内存中释放音效
function MusicAndSoundManager:unloadHallSound()
    if HallSoundConfig and HallSoundConfig.Sounds then
        for k, v in pairs(HallSoundConfig.Sounds) do
            -- print("[MusicAndSoundManager] unloadHallSound name:%s", v)
            audio.unloadSound(v)
        end
    end
end

-- TODO:暂没找到从内存中释放音乐的办法

return MusicAndSoundManager;