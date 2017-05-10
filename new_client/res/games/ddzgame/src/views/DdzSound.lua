local scheduler = cc.Director:getInstance():getScheduler()--requireForGameLuaFile("framework.scheduler")
local DdzRules = import(".DdzRules")
local DdzSound = class("DdzSound")
effect = CustomHelper.getFullPath("sound/ddz_eff_fapai.mp3");
function DdzSound:ctor()
    self:Init()

    self._index = 1
end

function DdzSound:Init()
    self._bgms = {
        "ddzBGM.mp3",
    }

    self._effects = {
        "ddz_eff_fapai.mp3",
        "ddz_eff_feiji.mp3",
        "ddz_eff_huojian.mp3",
        "ddz_eff_shuangshun.mp3",
        "ddz_eff_shunzi.mp3",
        "ddz_eff_zhadan.mp3",
        "ddz_man_1fen.mp3",
        "ddz_man_2fen.mp3",
        "ddz_man_3fen.mp3",
        "ddz_man_yuyin1.mp3",
        "ddz_man_yuyin2.mp3",
        "ddz_man_yuyin3.mp3",
        "ddz_man_yuyin4.mp3",
        "ddz_man_yuyin5.mp3",
        "ddz_man_yuyin6.mp3",
        "ddz_woman_1fen.mp3",
        "ddz_woman_2fen.mp3",
        "ddz_woman_3fen.mp3",
        "ddz_woman_yuyin1.mp3",
        "ddz_woman_yuyin2.mp3",
        "ddz_woman_yuyin3.mp3",
        "ddz_woman_yuyin4.mp3",
        "ddz_woman_yuyin5.mp3",
        "Man_1.mp3",
        "Man_10.mp3",
        "Man_11.mp3",
        "Man_12.mp3",
        "Man_13.mp3",
        "Man_14.mp3",
        "Man_15.mp3",
        "Man_2.mp3",
        "Man_3.mp3",
        "Man_4.mp3",
        "Man_5.mp3",
        "Man_6.mp3",
        "Man_7.mp3",
        "Man_8.mp3",
        "Man_9.mp3",
        "Man_baojing1.mp3",
        "Man_baojing2.mp3",
        "Man_buyao1.mp3",
        "Man_buyao2.mp3",
        "Man_buyao3.mp3",
        "Man_buyao4.mp3",
        "Man_dani1.mp3",
        "Man_dani2.mp3",
        "Man_dani3.mp3",
        "Man_dui1.mp3",
        "Man_dui10.mp3",
        "Man_dui11.mp3",
        "Man_dui12.mp3",
        "Man_dui13.mp3",
        "Man_dui2.mp3",
        "Man_dui3.mp3",
        "Man_dui4.mp3",
        "Man_dui5.mp3",
        "Man_dui6.mp3",
        "Man_dui7.mp3",
        "Man_dui8.mp3",
        "Man_dui9.mp3",
        "Man_feiji.mp3",
        "Man_liandui.mp3",
        "Man_NoOrder.mp3",
        "Man_sandaiyi.mp3",
        "Man_sandaiyidui.mp3",
        "Man_shunzi.mp3",
        "Man_sidaier.mp3",
        "Man_sidailiangdui.mp3",
        "Man_tuple1.mp3",
        "Man_tuple10.mp3",
        "Man_tuple11.mp3",
        "Man_tuple12.mp3",
        "Man_tuple13.mp3",
        "Man_tuple2.mp3",
        "Man_tuple3.mp3",
        "Man_tuple4.mp3",
        "Man_tuple5.mp3",
        "Man_tuple6.mp3",
        "Man_tuple7.mp3",
        "Man_tuple8.mp3",
        "Man_tuple9.mp3",
        "Man_wangzha.mp3",
        "Man_zhadan.mp3",
        "Man_bujiabei.mp3",
        "Man_jiabei.mp3",
        "Special_Leave.mp3",
        "Woman_1.mp3",
        "Woman_10.mp3",
        "Woman_11.mp3",
        "Woman_12.mp3",
        "Woman_13.mp3",
        "Woman_14.mp3",
        "Woman_15.mp3",
        "Woman_2.mp3",
        "Woman_3.mp3",
        "Woman_4.mp3",
        "Woman_5.mp3",
        "Woman_6.mp3",
        "Woman_7.mp3",
        "Woman_8.mp3",
        "Woman_9.mp3",
        "Woman_baojing1.mp3",
        "Woman_baojing2.mp3",
        "Woman_bujiabei.mp3",
        "Woman_buyao1.mp3",
        "Woman_buyao2.mp3",
        "Woman_buyao3.mp3",
        "Woman_buyao4.mp3",
        "Woman_dani1.mp3",
        "Woman_dani2.mp3",
        "Woman_dani3.mp3",
        "Woman_dui1.mp3",
        "Woman_dui10.mp3",
        "Woman_dui11.mp3",
        "Woman_dui12.mp3",
        "Woman_dui13.mp3",
        "Woman_dui2.mp3",
        "Woman_dui3.mp3",
        "Woman_dui4.mp3",
        "Woman_dui5.mp3",
        "Woman_dui6.mp3",
        "Woman_dui7.mp3",
        "Woman_dui8.mp3",
        "Woman_dui9.mp3",
        "Woman_feiji.mp3",
        "Woman_bujiabei.mp3",
        "Woman_jiabei.mp3",
        "Woman_liandui.mp3",
        "Woman_NoOrder.mp3",
        "Woman_sandaiyi.mp3",
        "Woman_sandaiyidui.mp3",
        "Woman_shunzi.mp3",
        "Woman_sidaier.mp3",
        "Woman_sidailiangdui.mp3",
        "Woman_tuple1.mp3",
        "Woman_tuple10.mp3",
        "Woman_tuple11.mp3",
        "Woman_tuple12.mp3",
        "Woman_tuple13.mp3",
        "Woman_tuple2.mp3",
        "Woman_tuple3.mp3",
        "Woman_tuple4.mp3",
        "Woman_tuple5.mp3",
        "Woman_tuple6.mp3",
        "Woman_tuple7.mp3",
        "Woman_tuple8.mp3",
        "Woman_tuple9.mp3",
        "Woman_wangzha.mp3",
        "Woman_zhadan.mp3",
    }


    MusicAndSoundManager:getInstance():addSound("NaoZhongZou", "HallSound/NaoZhongZou.mp3")


    for _, v in pairs(self._bgms) do
        MusicAndSoundManager:getInstance():addMusic(v, "sound/" .. v)
    end
    for _, v in pairs(self._effects) do
        MusicAndSoundManager:getInstance():addSound(v, "sound/" .. v)
    end
end

function DdzSound:Clear() end

function DdzSound:PlayBgm(index)
    index = index or self._index
    if not self._bgms[index] then
        index = 1
    end
    self._index = index


    local bgm = self._bgms[index] or self._bgms[1]
    MusicAndSoundManager:getInstance():playMusicWithFile("sound/"..bgm, true)
end


function DdzSound:PlayEffect_fapai()
    cc.SimpleAudioEngine:getInstance():playEffect(effect,false)
    --MusicAndSoundManager:getInstance():playSound(effect)
end

--- @type 1 飞机
--- 2 火箭
--- 3 双顺
--- 4 顺子
--- 5 炸弹
function DdzSound:PlayEffect_cardEff(type)
    local cardEff = {
        "ddz_eff_feiji.mp3",
        "ddz_eff_huojian.mp3",
        "ddz_eff_shuangshun.mp3",
        "ddz_eff_shunzi.mp3",
        "ddz_eff_zhadan.mp3",
    }

    MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..cardEff[type])
end

function DdzSound:PlayEffect_playerSound(isMan, effect)
    if isMan then
        local config = {
            ["1fen"] = "ddz_man_1fen.mp3",
            ["2fen"] = "ddz_man_2fen.mp3",
            ["3fen"] = "ddz_man_3fen.mp3",

            ["bujiao"] = "Man_NoOrder.mp3",


            [""] = "ddz_man_yuyin1.mp3",
            [""] = "ddz_man_yuyin2.mp3",
            [""] = "ddz_man_yuyin3.mp3",
            [""] = "ddz_man_yuyin4.mp3",
            [""] = "ddz_man_yuyin5.mp3",
            ["win"] = "ddz_man_yuyin6.mp3",
        }
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..config[effect])
    else
        local config = {
            ["1fen"] = "ddz_woman_1fen.mp3",
            ["2fen"] = "ddz_woman_2fen.mp3",

            ["3fen"] = "ddz_woman_3fen.mp3",
            ["bujiao"] = "Woman_NoOrder.mp3",


            [""] = "ddz_woman_yuyin1.mp3",
            [""] = "ddz_woman_yuyin2.mp3",
            [""] = "ddz_woman_yuyin3.mp3",
            [""] = "ddz_woman_yuyin4.mp3",
            [""] = "ddz_woman_yuyin5.mp3",
            ["win"] = "ddz_woman_win.mp3",
        }
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..config[effect])
    end
end

function DdzSound:PlayerEffect_cardSound(isMan, cards, lastCards, leftCardNum, faterkey)
    --print("444444:",cards)
    --print("55555", lastCards)
    --print("leftCardNum", leftCardNum);
    --print("faterkey",faterkey)
    if cards == nil then
        local randomKey = faterkey % 4 + 1
        MusicAndSoundManager:getInstance():playerSoundWithFile("sound/".. (isMan and ("Man_buyao" .. randomKey .. ".mp3") or ("Woman_buyao" .. randomKey .. ".mp3")))
        local manConfig = { "不要", "PASS", "过", "要不起" }
        local womanConfig = { "不要", "过", "PASS", "要不起" }

        return isMan and manConfig[randomKey] or womanConfig[randomKey]
    else
        local cardType = DdzRules.GetCardType(cards)
        dump(cardType,"cardType");
        local cardValue =  DdzRules.GetCardSoundValue(cardType.value)

        if lastCards and (cardType.type == DdzRules.CT_SINGLE or cardType.type == DdzRules.CT_DOUBLE or cardType.type == DdzRules.CT_THREE)
                and cardValue ~= 14 and cardValue ~= 15
        then
            local randomKey = faterkey % 3 + 1
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/".. (isMan and ("Man_dani" .. randomKey .. ".mp3") or ("Woman_dani" .. randomKey .. ".mp3")))
            return
        end

        if cardType.type == DdzRules.CT_SINGLE then
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and ("Man_" .. cardValue .. ".mp3") or ("Woman_" .. cardValue .. ".mp3")))
        elseif cardType.type == DdzRules.CT_DOUBLE then
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and ("Man_dui" .. cardValue .. ".mp3") or ("Woman_dui" .. cardValue .. ".mp3")))
        elseif cardType.type == DdzRules.CT_THREE then
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and ("Man_tuple" .. cardValue .. ".mp3") or ("Woman_tuple" .. cardValue .. ".mp3")))
        elseif cardType.type == DdzRules.CT_SINGLE_LINE then
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_shunzi.mp3" or "Woman_shunzi.mp3"))
        elseif cardType.type == DdzRules.CT_DOUBLE_LINE then
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_liandui.mp3" or "Woman_liandui.mp3"))
        elseif cardType.type == DdzRules.CT_THREE_LINE then
            if cardType.count > 1 then
                MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_feiji.mp3" or "Woman_feiji.mp3"))
            else
                MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and ("Man_tuple" .. cardValue .. ".mp3") or ("Woman_tuple" .. cardValue .. ".mp3")))
            end
        elseif cardType.type == DdzRules.CT_THREE_TAKE_ONE then
            if cardType.count > 1 then
                MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_feiji.mp3" or "Woman_feiji.mp3"))
            else
                MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_sandaiyi.mp3" or "Woman_sandaiyi.mp3"))
            end
        elseif cardType.type == DdzRules.CT_THREE_TAKE_TWO then
            if cardType.count > 1 then
                MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_feiji.mp3" or "Woman_feiji.mp3"))
            else
                MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_sandaiyidui.mp3" or "Woman_sandaiyidui.mp3"))
            end
        elseif cardType.type == DdzRules.CT_FOUR_TAKE_ONE then
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_sidaier.mp3" or "Woman_sidaier.mp3"))
        elseif cardType.type == DdzRules.CT_FOUR_TAKE_TWO then
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_sidailiangdui.mp3" or "Woman_sidailiangdui.mp3"))
        elseif cardType.type == DdzRules.CT_BOMB_CARD then
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_zhadan.mp3" or "Woman_zhadan.mp3"))
        elseif cardType.type == DdzRules.CT_MISSILE_CARD then
            MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_wangzha.mp3" or "Woman_wangzha.mp3"))
        end

        -- scheduler.performWithDelayGlobal(function()
        --     if leftCardNum == 2 then
        --         MusicAndSoundManager:getInstance():playSound(isMan and "Man_baojing2.mp3" or "Woman_baojing2.mp3")
        --     elseif leftCardNum == 1 then
        --         MusicAndSoundManager:getInstance():playSound(isMan and "Man_baojing1.mp3" or "Woman_baojing1.mp3")
        --     end
        -- end,1)
        --self.OutCardScheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(dt)
            if leftCardNum == 2 then
                print("保教-----2")
                MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_baojing2.mp3" or "Woman_baojing2.mp3"))
            elseif leftCardNum == 1 then
                print("保教-----1")
                MusicAndSoundManager:getInstance():playerSoundWithFile("sound/"..(isMan and "Man_baojing1.mp3" or "Woman_baojing1.mp3"))
            end

            -- if self.OutCardScheduler then
            --     cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.OutCardScheduler)   
            --     self.OutCardScheduler = nil
            -- end
        --end, 1, false);
    end
end
--加倍音效
function DdzSound:PlayerEffect_Double(isMan,isDouble)
	--Man_jiabei
	--Man_bujiabei
	--Woman_bujiabei
	--Woman_jiabei
	local soundName = string.format("sound/%s_%s.mp3",isMan and "Man" or "Woman", isDouble and "jiabei" or "bujiabei")
	--sslog("加倍情况",soundName)
	MusicAndSoundManager:getInstance():playerSoundWithFile(soundName)
end
return DdzSound