--卡片
local Card = class("Card",function()
    return cc.Sprite:create()
end)

--构造方法
function Card:ctor()
end

--属性定义
Card.num = 0  -- 数值
Card.numLabel = nil --文字Label

--创建卡片
function Card:create(num,w,h,p)
    local cardBox = Card.new()
    cardBox:setAnchorPoint(0,0)
    cardBox:setContentSize(w,h)
    local bg = cc.LayerColor:create(cc.c4b(255,255,255,100),w,h)

    cardBox.numLabel = LabelUtils:createLabel(num,18)
    cardBox.numLabel:setTextColor(cc.c4b(0,0,0,100))
    cardBox.numLabel:setPosition(bg:getContentSize().width*0.5,bg:getContentSize().height*0.5)
    cardBox:addChild(bg)
    cardBox:addChild(cardBox.numLabel)
    
--    if p then
--        local posLabel = LabelUtils:createLabel(p.x..":"..p.y,12)
--        posLabel:setTextColor(cc.c4b(0,0,0,100))
--        posLabel:setPosition(bg:getContentSize().width - posLabel:getContentSize().width,bg:getContentSize().height - posLabel:getContentSize().height)
    --        cardBox:addChild(posLabel)
    --    end

    return cardBox
end

--修改数字
function Card:setNum(num)
    local n = tonumber(num)
    if (n>0) then
        self.numLabel:setString(num)
        self.num = n
    else
        self.numLabel:setString("")
        self.num = 0
    end
end
function Card:play()
    self.numLabel:runAction(cc.Sequence:create(cc.ScaleTo:create(0, 0.1,0.1), cc.ScaleTo:create(0.5, 1,1)))
end
--获取数字
function Card:getData()
    return self.num
end

return Card


