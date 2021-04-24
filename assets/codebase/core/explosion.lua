explosion = class("explosion")

local explosions = {}

local explosionSheet = love.graphics.newImage("assets/gfx/sheets/explosion.png")


function explosion:initialize(x, y)
    self.x = x
    self.y = y

    self.age = 0

    self.id = #explosions + 1

    self.grid = anim8.newGrid(32, 32, 128, 32)
    self.animation = anim8.newAnimation(self.grid("1-4", 1), 0.1)

    table.insert(explosions, self)
end

function explosion:update(dt)
    self.age = self.age + dt

    if self.age >= 0.4 then
        explosions[self.id] = nil
    end

    self.animation:update(dt)
end

function explosion:draw()
   --- love.graphics.draw(explosionSheet, self.x, self.y)
   self.animation:draw(explosionSheet, self.x, self.y, 0, 2)
end

function updateExplosions(dt)
    for i,v in pairs(explosions) do
        v:update(dt)
    end
end

function drawExplosions()
    for i,v in pairs(explosions) do
        v:draw()
    end
end