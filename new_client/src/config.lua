
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1280,
    height = 720,
    autoscale = "EXACT_FIT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        -- if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "EXACT_FIT"}
        -- end
    end
}
-- 脚本Log处理配置
_logConfigParam = {
    writeLog = true,             --写log文件 DEBUG >= 2 时会有显示
    dialogLog = true,             --客户端提示出错信息 DEBUG >= 1 时会有显示
    OpenSSdump = true,            --ssdump DEBUG >= 2 时会有显示
    logfileName = 'ssgame.log',   --文件在可写目录
    logfileSize = 1024 * 20,      --log文件最大限制大小 单位K
    -----------------------------------------------------------------------
}