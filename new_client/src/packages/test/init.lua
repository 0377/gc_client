local test = class("test")

test.haha = "hahaha"

function test:bind(tartet)
    dump(tartet)
end

return test