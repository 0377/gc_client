
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"

local function main()
    require("app.MyApp"):create()
end
InitSearchPaths = cc.FileUtils:getInstance():getSearchPaths();
local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end

if DEBUG >=2 then
    print=release_print
else
	print = function()
	
	end
end


