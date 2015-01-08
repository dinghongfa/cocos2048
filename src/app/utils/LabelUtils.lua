LabelUtils = class("LabelUtils")
LabelUtils.__index = LabelUtils

local winSize = cc.Director:getInstance():getVisibleSize()

local ttfConfig = {} -- 字体配置表
ttfConfig.fontFilePath = "fonts/arial.ttf" -- 字体路径
ttfConfig.fontSize     = 24  -- 字体大小

function LabelUtils:createLabel(value,fontSize)
    if(fontSize ~= nil) then
    ttfConfig.fontSize = fontSize
    end
    local title = cc.Label:createWithTTF(ttfConfig, value, cc.TEXT_ALIGNMENT_CENTER, winSize.width)
    return title
end