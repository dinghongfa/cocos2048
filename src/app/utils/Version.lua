Version = class("Version")
Version.__index = Version


Version.COLOR = {
    cc.c3b(255, 255, 255),cc.c3b(238, 228, 218), cc.c3b(237, 224, 200), cc.c3b(242, 177, 121),
    cc.c3b(245, 149, 99), cc.c3b(246, 124, 95), cc.c3b(246, 94, 59),cc.c3b(237, 207, 114),
    cc.c3b(237, 207, 114), cc.c3b(237, 207, 114), cc.c3b(237, 207, 114),cc.c3b(237, 207, 114),
    cc.c3b(237, 207, 114), cc.c3b(237, 207, 114), cc.c3b(237, 207, 114),cc.c3b(237, 207, 114),
    cc.c3b(237, 207, 114)
}

Version.SCORES = {0, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048}

function Version:getColor(index)
    return self.COLOR(index)
end
function Version:getScore(index)
    return self.SCORES(index)
end