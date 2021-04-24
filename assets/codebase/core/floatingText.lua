floatingText = class("floatingText")

local texts = {}


function floatingText:initialize(text, x, y)
    self.text = text
    self.x = x
    self.y = y

    self.speed = 20
    self.age = 0
    self.id = #texts + 1
    table.insert(texts, self)
end

function floatingText:update(dt)
    self.y = self.y - self.speed * dt

    self.age = self.age + dt
    if self.age > 1.5 then 
        texts[self.id] = nil
    end
end

function floatingText:draw()

    local alpha = 1
    if self.age > 0.5 then 
        alpha = 1 - self.age + 0.5
    end

    love.graphics.setColor(1,1,1,alpha)

    game:fontSize(20)
    love.graphics.print(self.text, self.x, self.y)
    love.graphics.setColor(1,1,1)
end

function updateFloatingTexts(dt)
    for i,v in pairs(texts) do
        v:update(dt)
    end
end

function drawFloatingTexts()
    for i,v in pairs(texts) do
        v:draw()
    end
end