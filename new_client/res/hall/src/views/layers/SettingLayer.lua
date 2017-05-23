local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local SettingLayer = class("SettingLayer", CustomBaseView)

function SettingLayer:ctor(exitCallback)
    -- local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("SettingLayerCCS.csb");
    -- self.csNode = cc.CSLoader:createNode(csNodePath);
    local CCSLuaNode =  requireForGameLuaFile("SettingLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Widget");
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "close_btn"), "ccui.Button");
    closeBtn:addClickEventListener(function(sender)
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        self:removeSelf();
    end);
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
    --显示玩家信息
    self:showPlayerInfoView();
    local accountExitBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "switch_acount_btn"), "ccui.Button");
    accountExitBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        self:clickAccountExitBtn()
    end);
    --音乐开关按钮
    self.musicSwitchBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "music_switch_btn"), "ccui.Button");
    self.musicSwitchBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        local musicSwitch = not GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
        GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch(musicSwitch)
        if musicSwitch == true then
            --todo
            GameManager:getInstance():getMusicAndSoundManager():playMusicWithFile(HallSoundConfig.BgMusic.Hall)
        else
            GameManager:getInstance():getMusicAndSoundManager():stopMusic()
        end
        self:showMusicAndSoundInfoView();
    end);
    --音效开关
    self.soundSwitchBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "sound_switch_btn"), "ccui.Button");
    self.soundSwitchBtn:addClickEventListener(function()
        local isOpenForSound = not GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
        GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch(isOpenForSound);
        if isOpenForSound == true then
            --todo
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        else
            GameManager:getInstance():getMusicAndSoundManager():stopAllSound();
        end
        self:showMusicAndSoundInfoView();
    end);
    --显示开关状态
    self:showMusicAndSoundInfoView(true);
    SettingLayer.super.ctor(self)

    -- 显示大厅版本号
    local versionStr = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "Text_Version"), "ccui.Text");
    versionStr:setString(string.format("version:%s/%s/%s/%s(%s)",VersionModel:getInstance():getFrameResVersion(), VersionModel:getInstance():getFrameSrcVersion(),
        VersionModel:getInstance():getHallResVersion(), VersionModel:getInstance():getHallSrcVersion(),VersionModel:getInstance():getVerionStr()))
end

function SettingLayer:onEnter()
    CustomHelper.addAlertAppearAnim(self.alertView);
end

--- 退出账号
function SettingLayer:clickAccountExitBtn()
    local runnscene = cc.Director:getInstance():getRunningScene();
    if runnscene.alertLogoutTipView then
        --todo
        runnscene:alertLogoutTipView()
    end
end

--- 显示玩家信息
function SettingLayer:showPlayerInfoView()
    local node_acount = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "node_acount"), "ccui.Text");
    local node_nickname = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "node_nickname"), "ccui.Text");
    node_acount:getChildByName("lbel_value"):setString("" .. self.myPlayerInfo:getGuid());
    node_nickname:getChildByName("lbel_value"):setString("" .. self.myPlayerInfo:getNickName())


    local headParentView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "head_parent_node"), "cc.Node");
    headParentView:removeAllChildren();

    dump(self.myPlayerInfo:getSquareHeadIconPath())
    --	local headSpr = cc.Sprite:create(self.myPlayerInfo:getSquareHeadIconPath());
    local headSpr = display.newSprite(self.myPlayerInfo:getSquareHeadIconPath());
    headSpr:setScale(headParentView:getContentSize().width / headSpr:getContentSize().width);
    --将正方形头像截取圆角
    local clipperNode = cc.ClippingNode:create();
    clipperNode:setStencil(cc.Sprite:create(CustomHelper.getFullPath("hall_res/setting/bb_grxx_txk.png")))
    -- clipperNode:setAlphaThreshold(0.0);
    clipperNode:setScale(0.93)
    clipperNode:addChild(headSpr);
    headParentView:addChild(clipperNode)
    clipperNode:setPosition(cc.p(clipperNode:getParent():getContentSize().width / 2, clipperNode:getParent():getContentSize().height / 2))
end

--- 音乐开关
function SettingLayer:showMusicAndSoundInfoView(binit)
    local pos1, pos2 = cc.p(182, 23), cc.p(58, 23)

    --音乐开关
    local musicSwitchPanel = self.musicSwitchBtn
    local isOpenForMusic = GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
    local icon = musicSwitchPanel:getChildByName("icon")
    if binit then
        icon:setPosition(isOpenForMusic and pos1 or pos2)
    else
        icon:stopAllActions()
        icon:runAction(cc.EaseSineIn:create(cc.MoveTo:create(0.15, isOpenForMusic and pos1 or pos2)))
    end

    --音效开关
    local soundSwitchPanel = self.soundSwitchBtn
    local isOpenForSound = GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch()
    local icon = soundSwitchPanel:getChildByName("icon")
    if binit then
        icon:setPosition(isOpenForSound and pos1 or pos2)
    else
        icon:stopAllActions()
        icon:runAction(cc.EaseSineIn:create(cc.MoveTo:create(0.15, isOpenForSound and pos1 or pos2)))
    end
end

return SettingLayer
