require "app.utils.LabelUtils"

local Card = require("app.ui.Card")
local size --舞台尺寸
local cardList = {}  --卡片字典
local totalScore = 0 --当前分数
local scoreLabel = nil -- 分数文本UI
local gameOverLabel = nil -- 游戏结束文本UI
local isPlay = false     -- 是否在游戏中
--touch坐标 在处理方向判断的时候要用到
local BeginPos = {x = 0, y = 0}


local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self:createLayer()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
--[[    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)]]
end

function MainScene:createLayer()
    --当前屏幕高度和宽度
    size = cc.Director:getInstance():getVisibleSize()
    --背景色
    local bg = cc.LayerColor:create(cc.c4f(180,170,160,255))
    self:addChild(bg)
    
    --标题label
    local titleLabel = LabelUtils:createLabel("2048",30)
    self:addChild(titleLabel)
    titleLabel:setPosition( cc.p(VisibleRect:center().x, VisibleRect:top().y-30) )
    
    --分数label
    scoreLabel = LabelUtils:createLabel("score:0",30)
    self:addChild(scoreLabel)
    scoreLabel:setPosition( cc.p(VisibleRect:center().x, titleLabel:getPositionY()-30) )
    
    --绘制表格
    self:initGrid()
    
    --初始化卡片
    self:initCard()
    
    --重新游戏事件
    
    --重新游戏按钮
    
    --结束label
    
    --通关label
    
    -- 触摸事件
    
    --触摸层添加 并且添加触摸事件
end

--绘制表格
function MainScene:initGrid()
    local drawBox = cc.Sprite:create()
    --计算一个格子的宽度 目前是屏幕尺寸的80%再取四分之一的宽度
    local oneW = size.width*0.8*0.25
    local draw = cc.DrawNode:create()
    drawBox:setPosition(cc.p(VisibleRect:center().x-oneW*2,VisibleRect:center().y*0.5))
    drawBox:addChild(draw)
    self:addChild(drawBox)
    for index = 0,4 do
        draw:drawSegment(cc.p(index*oneW, 0), cc.p(index*oneW, oneW*4), 1, cc.c4f(255, 255, 255, 1)) --竖线
        draw:drawSegment(cc.p(0, index*oneW), cc.p(oneW*4, index*oneW), 1, cc.c4f(255, 255, 255, 1)) --横线
    end
end
--初始化格子
function MainScene:initCard()
    local random1 = self:getRandom(4);
    local random2 = self:getRandom(4);
    while (random1 == random2) do
        random2 = self:getRandom(4);
    end
    local random11 = self:getRandom(4);
    local random22 = self:getRandom(4);

    --计算一个格子的宽度 目前是屏幕尺寸的80%再取四分之一的宽度
    local oneW = size.width*0.8*0.25
    local key
    for i = 0,3 do
        for j = 0,3 do
            local card = Card:create("0",oneW,oneW,cc.p(i,j))
            local cardX = VisibleRect:center().x-oneW*2 + i * oneW
            local cardY = VisibleRect:center().y*0.5 + j * oneW
            --            card:setAnchorPoint(0.5,0.5)
            card:setPosition(cardX,cardY)
            self:addChild(card)

            if (i == random1 and j == random11) then
                card:setNum("2")
            elseif (i == random2 and j == random22) then
                card:setNum("2")
            else
                card:setNum(0)
            end
            --根据位置保存card对象
            key = i..":"..j
            cardList[key] = card
        end
    end

    isPlay = true
end

function MainScene:getRandom(maxSize)
    --这里需要这样写一下 才能让随即数每次都不一样
    math.randomseed(os.time())
    return math.floor(math.random() * maxSize) % maxSize;
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
