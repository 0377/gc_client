--------------------------------------------------------------
-- This file was automatically generated by Cocos Studio.
-- Do not make changes to this file.
-- All changes will be lost.
--------------------------------------------------------------

local luaExtend = require "LuaExtend"

-- using for layout to decrease count of local variables
local layout = nil
local localLuaFile = nil
local innerCSD = nil
local innerProject = nil
local localFrame = nil

local Result = {}
------------------------------------------------------------
-- function call description
-- create function caller should provide a function to 
-- get a callback function in creating scene process.
-- the returned callback function will be registered to 
-- the callback event of the control.
-- the function provider is as below :
-- Callback callBackProvider(luaFileName, node, callbackName)
-- parameter description:
-- luaFileName  : a string, lua file name
-- node         : a Node, event source
-- callbackName : a string, callback function name
-- the return value is a callback function
------------------------------------------------------------
function Result.create(callBackProvider)

local result={}
setmetatable(result, luaExtend)

--Create Layer
local Layer=cc.Node:create()
Layer:setName("Layer")
layout = ccui.LayoutComponent:bindLayoutComponent(Layer)
layout:setSize({width = 1280.0000, height = 720.0000})

--Create Panel_1
local Panel_1 = ccui.Layout:create()
Panel_1:ignoreContentAdaptWithSize(false)
Panel_1:setClippingEnabled(false)
Panel_1:setBackGroundColorType(1)
Panel_1:setBackGroundColor({r = 0, g = 0, b = 0})
Panel_1:setBackGroundColorOpacity(126)
Panel_1:setTouchEnabled(true);
Panel_1:setLayoutComponentEnabled(true)
Panel_1:setName("Panel_1")
Panel_1:setTag(61)
Panel_1:setCascadeColorEnabled(true)
Panel_1:setCascadeOpacityEnabled(true)
Panel_1:setAnchorPoint(0.5000, 0.5000)
Panel_1:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Panel_1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidthEnabled(true)
layout:setPercentHeightEnabled(true)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
Layer:addChild(Panel_1)

--Create alert_panel
local alert_panel = ccui.Layout:create()
alert_panel:ignoreContentAdaptWithSize(false)
alert_panel:setBackGroundImage("hall_res/account/bb_xgmm_d.png",0)
alert_panel:setClippingEnabled(false)
alert_panel:setBackGroundColorOpacity(102)
alert_panel:setTouchEnabled(true);
alert_panel:setLayoutComponentEnabled(true)
alert_panel:setName("alert_panel")
alert_panel:setTag(62)
alert_panel:setCascadeColorEnabled(true)
alert_panel:setCascadeOpacityEnabled(true)
alert_panel:setAnchorPoint(0.5000, 0.5000)
alert_panel:setPosition(642.4320, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(alert_panel)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5019)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9039)
layout:setPercentHeight(0.9278)
layout:setSize({width = 1157.0000, height = 668.0000})
layout:setLeftMargin(63.9320)
layout:setRightMargin(59.0680)
layout:setTopMargin(26.0000)
layout:setBottomMargin(26.0000)
Panel_1:addChild(alert_panel)

--Create Image_1
local Image_1 = ccui.ImageView:create()
Image_1:ignoreContentAdaptWithSize(false)
Image_1:loadTexture("hall_res/account/bb_xgmm_bt.png",0)
Image_1:setLayoutComponentEnabled(true)
Image_1:setName("Image_1")
Image_1:setTag(63)
Image_1:setCascadeColorEnabled(true)
Image_1:setCascadeOpacityEnabled(true)
Image_1:setPosition(578.5000, 611.2806)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_1)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.9151)
layout:setPercentWidth(0.2118)
layout:setPercentHeight(0.0898)
layout:setSize({width = 245.0000, height = 60.0000})
layout:setLeftMargin(456.0000)
layout:setRightMargin(456.0000)
layout:setTopMargin(26.7194)
layout:setBottomMargin(581.2806)
alert_panel:addChild(Image_1)

--Create Text_1
local Text_1 = ccui.Text:create()
Text_1:ignoreContentAdaptWithSize(true)
Text_1:setTextAreaSize({width = 0, height = 0})
Text_1:setFontSize(36)
Text_1:setString([[旧密码]])
Text_1:enableShadow({r = 255, g = 196, b = 74, a = 255}, {width = 0, height = 0}, 0)
Text_1:setLayoutComponentEnabled(true)
Text_1:setName("Text_1")
Text_1:setTag(66)
Text_1:setCascadeColorEnabled(true)
Text_1:setCascadeOpacityEnabled(true)
Text_1:setAnchorPoint(1.0000, 0.5000)
Text_1:setPosition(317.4188, 470.3706)
Text_1:setTextColor({r = 255, g = 196, b = 74})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_1)
layout:setPositionPercentX(0.2743)
layout:setPositionPercentY(0.7041)
layout:setPercentWidth(0.0933)
layout:setPercentHeight(0.0539)
layout:setSize({width = 108.0000, height = 36.0000})
layout:setLeftMargin(209.4188)
layout:setRightMargin(839.5812)
layout:setTopMargin(179.6294)
layout:setBottomMargin(452.3706)
alert_panel:addChild(Text_1)

--Create oldpwd_bg
local oldpwd_bg = ccui.ImageView:create()
oldpwd_bg:ignoreContentAdaptWithSize(false)
oldpwd_bg:loadTexture("hall_res/account/bb_grxx_KK.png",0)
oldpwd_bg:setLayoutComponentEnabled(true)
oldpwd_bg:setName("oldpwd_bg")
oldpwd_bg:setTag(69)
oldpwd_bg:setCascadeColorEnabled(true)
oldpwd_bg:setCascadeOpacityEnabled(true)
oldpwd_bg:setPosition(615.2683, 470.3701)
layout = ccui.LayoutComponent:bindLayoutComponent(oldpwd_bg)
layout:setPositionPercentX(0.5318)
layout:setPositionPercentY(0.7041)
layout:setPercentWidth(0.4313)
layout:setPercentHeight(0.1123)
layout:setSize({width = 499.0000, height = 75.0000})
layout:setLeftMargin(365.7683)
layout:setRightMargin(292.2317)
layout:setTopMargin(160.1299)
layout:setBottomMargin(432.8701)
alert_panel:addChild(oldpwd_bg)

--Create Text_1_0
local Text_1_0 = ccui.Text:create()
Text_1_0:ignoreContentAdaptWithSize(true)
Text_1_0:setTextAreaSize({width = 0, height = 0})
Text_1_0:setFontSize(36)
Text_1_0:setString([[新密码]])
Text_1_0:enableShadow({r = 255, g = 196, b = 74, a = 255}, {width = 0, height = 0}, 0)
Text_1_0:setLayoutComponentEnabled(true)
Text_1_0:setName("Text_1_0")
Text_1_0:setTag(67)
Text_1_0:setCascadeColorEnabled(true)
Text_1_0:setCascadeOpacityEnabled(true)
Text_1_0:setAnchorPoint(1.0000, 0.5000)
Text_1_0:setPosition(317.4188, 362.1853)
Text_1_0:setTextColor({r = 255, g = 196, b = 74})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_1_0)
layout:setPositionPercentX(0.2743)
layout:setPositionPercentY(0.5422)
layout:setPercentWidth(0.0933)
layout:setPercentHeight(0.0539)
layout:setSize({width = 108.0000, height = 36.0000})
layout:setLeftMargin(209.4188)
layout:setRightMargin(839.5812)
layout:setTopMargin(287.8147)
layout:setBottomMargin(344.1853)
alert_panel:addChild(Text_1_0)

--Create newpwd_bg
local newpwd_bg = ccui.ImageView:create()
newpwd_bg:ignoreContentAdaptWithSize(false)
newpwd_bg:loadTexture("hall_res/account/bb_grxx_KK.png",0)
newpwd_bg:setLayoutComponentEnabled(true)
newpwd_bg:setName("newpwd_bg")
newpwd_bg:setTag(70)
newpwd_bg:setCascadeColorEnabled(true)
newpwd_bg:setCascadeOpacityEnabled(true)
newpwd_bg:setPosition(615.2683, 362.1851)
layout = ccui.LayoutComponent:bindLayoutComponent(newpwd_bg)
layout:setPositionPercentX(0.5318)
layout:setPositionPercentY(0.5422)
layout:setPercentWidth(0.4313)
layout:setPercentHeight(0.1123)
layout:setSize({width = 499.0000, height = 75.0000})
layout:setLeftMargin(365.7683)
layout:setRightMargin(292.2317)
layout:setTopMargin(268.3149)
layout:setBottomMargin(324.6851)
alert_panel:addChild(newpwd_bg)

--Create mobile_reset_pwd_btn
local mobile_reset_pwd_btn = ccui.Button:create()
mobile_reset_pwd_btn:ignoreContentAdaptWithSize(false)
mobile_reset_pwd_btn:loadTextureNormal("hall_res/account/bb_lookfor_pw_normal.png",0)
mobile_reset_pwd_btn:loadTexturePressed("hall_res/account/bb_lookfor_pw_pressed.png",0)
mobile_reset_pwd_btn:loadTextureDisabled("hall_res/account/bb_lookfor_pw_pressed.png",0)
mobile_reset_pwd_btn:setTitleFontSize(14)
mobile_reset_pwd_btn:setTitleColor({r = 65, g = 65, b = 70})
mobile_reset_pwd_btn:setScale9Enabled(true)
mobile_reset_pwd_btn:setCapInsets({x = 15, y = 11, width = 98, height = 12})
mobile_reset_pwd_btn:setLayoutComponentEnabled(true)
mobile_reset_pwd_btn:setName("mobile_reset_pwd_btn")
mobile_reset_pwd_btn:setTag(65)
mobile_reset_pwd_btn:setCascadeColorEnabled(true)
mobile_reset_pwd_btn:setCascadeOpacityEnabled(true)
mobile_reset_pwd_btn:setPosition(995.1769, 470.3700)
layout = ccui.LayoutComponent:bindLayoutComponent(mobile_reset_pwd_btn)
layout:setPositionPercentX(0.8601)
layout:setPositionPercentY(0.7041)
layout:setPercentWidth(0.1106)
layout:setPercentHeight(0.0509)
layout:setSize({width = 128.0000, height = 34.0000})
layout:setLeftMargin(931.1769)
layout:setRightMargin(97.8231)
layout:setTopMargin(180.6300)
layout:setBottomMargin(453.3700)
alert_panel:addChild(mobile_reset_pwd_btn)

--Create Text_1_0_0
local Text_1_0_0 = ccui.Text:create()
Text_1_0_0:ignoreContentAdaptWithSize(true)
Text_1_0_0:setTextAreaSize({width = 0, height = 0})
Text_1_0_0:setFontSize(36)
Text_1_0_0:setString([[确认密码]])
Text_1_0_0:enableShadow({r = 255, g = 196, b = 74, a = 255}, {width = 0, height = 0}, 0)
Text_1_0_0:setLayoutComponentEnabled(true)
Text_1_0_0:setName("Text_1_0_0")
Text_1_0_0:setTag(68)
Text_1_0_0:setCascadeColorEnabled(true)
Text_1_0_0:setCascadeOpacityEnabled(true)
Text_1_0_0:setAnchorPoint(1.0000, 0.5000)
Text_1_0_0:setPosition(317.4188, 254.0000)
Text_1_0_0:setTextColor({r = 255, g = 196, b = 74})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_1_0_0)
layout:setPositionPercentX(0.2743)
layout:setPositionPercentY(0.3802)
layout:setPercentWidth(0.1245)
layout:setPercentHeight(0.0539)
layout:setSize({width = 144.0000, height = 36.0000})
layout:setLeftMargin(173.4188)
layout:setRightMargin(839.5812)
layout:setTopMargin(396.0000)
layout:setBottomMargin(236.0000)
alert_panel:addChild(Text_1_0_0)

--Create new_pwd2_bg
local new_pwd2_bg = ccui.ImageView:create()
new_pwd2_bg:ignoreContentAdaptWithSize(false)
new_pwd2_bg:loadTexture("hall_res/account/bb_grxx_KK.png",0)
new_pwd2_bg:setLayoutComponentEnabled(true)
new_pwd2_bg:setName("new_pwd2_bg")
new_pwd2_bg:setTag(71)
new_pwd2_bg:setCascadeColorEnabled(true)
new_pwd2_bg:setCascadeOpacityEnabled(true)
new_pwd2_bg:setPosition(615.2683, 254.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(new_pwd2_bg)
layout:setPositionPercentX(0.5318)
layout:setPositionPercentY(0.3802)
layout:setPercentWidth(0.4313)
layout:setPercentHeight(0.1123)
layout:setSize({width = 499.0000, height = 75.0000})
layout:setLeftMargin(365.7683)
layout:setRightMargin(292.2317)
layout:setTopMargin(376.5000)
layout:setBottomMargin(216.5000)
alert_panel:addChild(new_pwd2_bg)

--Create pwd_modify_btn
local pwd_modify_btn = ccui.Button:create()
pwd_modify_btn:ignoreContentAdaptWithSize(false)
pwd_modify_btn:loadTextureNormal("hall_res/account/bb_grxx_fz_normal.png",0)
pwd_modify_btn:loadTexturePressed("hall_res/account/bb_grxx_fz_pressed.png",0)
pwd_modify_btn:loadTextureDisabled("hall_res/account/bb_grxx_fz_pressed.png",0)
pwd_modify_btn:setTitleFontSize(14)
pwd_modify_btn:setTitleColor({r = 65, g = 65, b = 70})
pwd_modify_btn:setScale9Enabled(true)
pwd_modify_btn:setCapInsets({x = 15, y = 11, width = 257, height = 78})
pwd_modify_btn:setLayoutComponentEnabled(true)
pwd_modify_btn:setName("pwd_modify_btn")
pwd_modify_btn:setTag(72)
pwd_modify_btn:setCascadeColorEnabled(true)
pwd_modify_btn:setCascadeOpacityEnabled(true)
pwd_modify_btn:setPosition(615.0000, 106.2785)
layout = ccui.LayoutComponent:bindLayoutComponent(pwd_modify_btn)
layout:setPositionPercentX(0.5315)
layout:setPositionPercentY(0.1591)
layout:setPercentWidth(0.2481)
layout:setPercentHeight(0.1497)
layout:setSize({width = 287.0000, height = 100.0000})
layout:setLeftMargin(471.5000)
layout:setRightMargin(398.5000)
layout:setTopMargin(511.7215)
layout:setBottomMargin(56.2785)
alert_panel:addChild(pwd_modify_btn)

--Create close_btn
local close_btn = ccui.Button:create()
close_btn:ignoreContentAdaptWithSize(false)
close_btn:loadTextureNormal("hall_res/tongyong/bb_ty_gb.png",0)
close_btn:loadTexturePressed("hall_res/tongyong/bb_ty_gb1.png",0)
close_btn:loadTextureDisabled("hall_res/tongyong/bb_ty_gb1.png",0)
close_btn:setTitleFontSize(14)
close_btn:setTitleColor({r = 65, g = 65, b = 70})
close_btn:setScale9Enabled(true)
close_btn:setCapInsets({x = 15, y = 11, width = 37, height = 46})
close_btn:setLayoutComponentEnabled(true)
close_btn:setName("close_btn")
close_btn:setTag(73)
close_btn:setCascadeColorEnabled(true)
close_btn:setCascadeOpacityEnabled(true)
close_btn:setPosition(1081.3900, 601.2671)
layout = ccui.LayoutComponent:bindLayoutComponent(close_btn)
layout:setPositionPercentX(0.9346)
layout:setPositionPercentY(0.9001)
layout:setPercentWidth(0.0579)
layout:setPercentHeight(0.1018)
layout:setSize({width = 67.0000, height = 68.0000})
layout:setLeftMargin(1047.8900)
layout:setRightMargin(42.1101)
layout:setTopMargin(32.7329)
layout:setBottomMargin(567.2671)
alert_panel:addChild(close_btn)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Layer
return result;
end

return Result
