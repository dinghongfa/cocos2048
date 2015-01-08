local Card = require("app.ui.Card")
local size --舞台尺寸
local cardList = {}  --卡片字典
local totalScore = 0 --当前分数
local scoreLabel = nil -- 分数文本UI
local gameOverLabel = nil -- 游戏结束文本UI
local isPlay = false     -- 是否在游戏中
--touch坐标 在处理方向判断的时候要用到
local BeginPos = {x = 0, y = 0}

local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

function GameScene.create()
    local scene = GameScene.new()
    scene:createLayer()
    return scene
end

function GameScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

-- create layer
function GameScene:createLayer()

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
    local function restartCallBack(tag, sender)
        print("restartCallBack")
        self:resetGame()
    end
    --重新游戏按钮
    local restartItem = cc.MenuItemFont:create("restart");
    restartItem:setColor(cc.c4f(22,100,255,1));
    restartItem:setPosition(VisibleRect:center().x,VisibleRect:bottom().y+100)
    restartItem:registerScriptTapHandler(restartCallBack)
    local restartMenu = cc.Menu:create(restartItem);
    restartMenu:setPosition(0,0)
    self:addChild(restartMenu);
 
    --结束label
    gameOverLabel = LabelUtils:createLabel("Game Over",30)
    gameOverLabel:setColor(cc.c4f(255,0,255,1));
    gameOverLabel:setPosition(VisibleRect:center().x,VisibleRect:center().y)
    gameOverLabel:setVisible(false)
    self:addChild(gameOverLabel);

    --通关label
    local passTheGameLabel = LabelUtils:createLabel("Success!",30)
    passTheGameLabel:setColor(cc.c4f(255,255,0,1));
    passTheGameLabel:setPosition(VisibleRect:center().x,VisibleRect:center().y)
    passTheGameLabel:setVisible(false)
    self:addChild(passTheGameLabel);
    
    -- 触摸事件
    local function onTouchBegan(touch, event)
        BeginPos = touch:getLocation()
        --网上都说这里一定要返回为true才行 具体不是很清楚为什么
        return true
    end
    local function onTouchMoved(touch, event)
    end
    local function onTouchEnd(touch, event)
        local location = touch:getLocation()
        local nMoveY = location.y - BeginPos.y
        --判断触摸的方向 根据坐标来判断
        if (location.x - BeginPos.x > 50) then
            self:rightCombineNumber();
        elseif (location.x - BeginPos.x < -50) then
            self:leftCombineNumber();
        elseif (location.y - BeginPos.y > 50) then
            self:upCombineNumber();
        elseif (location.y - BeginPos.y < -50) then
            self:downCombineNumber();
        end
    end
    --触摸层添加 并且添加触摸事件    
    local layer = cc.Layer:create()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnd,cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    self:addChild(layer,-1)
end

--绘制表格
function GameScene:initGrid()
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
function GameScene:initCard()
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

function GameScene:getRandom(maxSize)
    --这里需要这样写一下 才能让随即数每次都不一样
    math.randomseed(os.time())
    return math.floor(math.random() * maxSize) % maxSize;
end

--向上
function GameScene:upCombineNumber()
    if (isPlay == false) then
        return true
    end

    for x = 0,3 do
        for y = 3,0,-1 do
            for y1 = y-1,0,-1 do
                if (cardList[x..":"..y1]:getData() > 0) then
                    if (cardList[x..":"..y]:getData() <= 0) then
                        cardList[x..":"..y]:setNum(cardList[x..":"..y1]:getData());
                        cardList[x..":"..y1]:setNum(0);
                        y = y+1;
--                        isMove = true;
                    elseif(cardList[x..":"..y]:getData() == cardList[x..":"..y1]:getData()) then
                        cardList[x..":"..y]:setNum(cardList[x..":"..y]:getData() * 2)
                        cardList[x..":"..y1]:setNum(0)
                        totalScore = totalScore+cardList[x..":"..y]:getData()
                    end
                    break
                end
            end
        end
    end
    self:updateNumber()
end

--向下
function GameScene:downCombineNumber()
    if (isPlay == false) then
        return true
    end

    for x = 0,3 do
        for y = 0,3 do
            for y1 = y + 1,3 do
                if (cardList[x..":"..y1]:getData() > 0) then
                    if (cardList[x..":"..y]:getData() <= 0) then
                        cardList[x..":"..y]:setNum(cardList[x..":"..y1]:getData())
                        cardList[x..":"..y1]:setNum(0);
                        y = y-1
                    elseif(cardList[x..":"..y]:getData() == cardList[x..":"..y1]:getData()) then
                        cardList[x..":"..y]:setNum(cardList[x..":"..y]:getData() * 2)
                        cardList[x..":"..y1]:setNum(0);
                        totalScore = totalScore+cardList[x..":"..y]:getData()
                    end
                    break
                end
            end
        end
    end
    self:updateNumber()
end
--向左
function GameScene:leftCombineNumber()
    if (isPlay == false) then
        return true
    end
    
    local card
    local nextCard
    for j = 0,3 do
        for i = 0,3 do
            card = cardList[i..":"..j]
            if(card:getData() ~= 0) then
                local k = i+1
                while(k < 4) do
                    nextCard = cardList[k..":"..j]
                    if (nextCard:getData() ~=0) then
                        if(card:getData() == nextCard:getData()) then
                            card:setNum(card:getData()*2)
                            nextCard:setNum(0)
                            totalScore = totalScore+card:getData()
                        end 
                        k = 4
                        break
                    end   
                    k = k + 1 
                end
            end
        end
    end
    
     for j = 0,3 do
        for i = 0,3 do
            card = cardList[i..":"..j]
            if(card:getData() == 0) then
                local k = i+1
                while(k < 4) do
                    nextCard = cardList[k..":"..j]
                    if (nextCard:getData() ~=0) then
                        card:setNum(nextCard:getData())
                        nextCard:setNum(0)
                        k = 4
                    end   
                    k = k + 1 
                end
            end
        end
    end
    self:updateNumber()
end

--向右
function GameScene:rightCombineNumber()
    if (isPlay == false) then
        return true
    end
    local card
    local nextCard
    for j = 0,3 do
        for i = 3,0,-1 do
            card = cardList[i..":"..j]
            if (card:getData() ~= 0) then
                local k = i - 1
                while(k>=0) do
                    nextCard = cardList[k..":"..j]
                    if (nextCard:getData() ~= 0) then
                        if (card:getData() == nextCard:getData()) then
                            card:setNum(card:getData()*2)
                            nextCard:setNum(0) 
                            totalScore = totalScore+card:getData()
                        end
                        k = -1
                        break
                    end
                    k = k - 1
                end
            end
        end
    end

    for j = 0,3 do
        for i = 3,0,-1 do
            card = cardList[i..":"..j]
            if (card:getData() == 0) then
                local k = i - 1
                while(k>=0) do
                    nextCard = cardList[k..":"..j]
                    if (nextCard:getData() ~= 0) then
                        card:setNum(nextCard:getData())
                        nextCard:setNum(0) 
                        k = -1         
                    end
                    k = k - 1
                end
            end
        end
    end
    self:updateNumber()
end
--更新分数
function GameScene:updateScore()
    scoreLabel:setString("score:"..tostring(totalScore))
end
--重置游戏
function GameScene:resetGame()
    gameOverLabel:setVisible(false)
    isPlay = true
    totalScore = 0
    self:updateScore()
    local random1 = self:getRandom(4);
    local random2 = self:getRandom(4);
    while (random1 == random2) do
        random2 = self:getRandom(4);
    end
    local random11 = self:getRandom(4);
    local random22 = self:getRandom(4);
    
    local oldKey1 = random1..":"..random11
    local oldKey2 = random2..":"..random22
    for key,value in pairs(cardList) do
        value:setNum(0)
        if (key == oldKey1 or key == oldKey2) then
            value:setNum(2)
        end
    end
end
--更新数据监测是否有空格子 有的话 添加一个随机的数字
function GameScene:updateNumber()
    local emptyCellList = {};
    local key
    local card
    local num = 0
    for i = 0,3 do
        for j = 0,3 do
            card = cardList[i..":"..j]
            if (card:getData() ~= 0) then
            
            else
                emptyCellList[num] = card
                num = num+1
            end
        end
    end
    --更新分数
    self:updateScore()
    
    if (num < 1)then
    --失败
        isPlay = false
        gameOverLabel:setVisible(true)
    else
    --还有空余的格子
        local newCard = emptyCellList[self:getRandom(num)]
        newCard:setNum(2)
        newCard:play()
    end
end

return GameScene