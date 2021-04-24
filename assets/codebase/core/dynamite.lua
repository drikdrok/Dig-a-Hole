dynamite = class("dynamite")
 dynamites = {}

local dynamiteSprite = love.graphics.newImage("assets/gfx/sprites/dynamite.png")


function dynamiteFilter(item, other)
    if other.type == "player" then 
        return nil
    end

    return "slide"
end

function dynamite:initialize(x, y)
    self.x = x
    self.y = y
    self.width = 7
    self.height = 18

    self.yvel = 0

    self.type = "dynamite"

    self.age = 0

    self.id = #dynamites + 1
    collisionWorld:add(self, self.x, self.y, self.width, self.height)
    table.insert(dynamites, self)
end

function dynamite:update(dt)
    self.age = self.age + dt

    self.yvel = self.yvel + game.gravity * dt
    self.y = self.y + self.yvel * dt

    self.x, self.y, cols, len = collisionWorld:move(self, self.x, self.y, dynamiteFilter)

    for i,v in pairs(cols) do
        if v.normal.y == -1 then 
            self.yvel = 0
        end
    end

    if self.age > 2 then  -- Explode
        explosion:new(self.x - 32, self.y - 16)
        dynamites[self.id] = nil

        for x = -4, 4 do
            for y = math.ceil(-5*math.cos(x/4)), math.ceil(5*math.cos(x/4)) do
                ground:dig(math.floor(self.x / 16 ) + x, math.floor(self.y / 16) + y)
            end
        end
    end

end

function dynamite:draw()
    love.graphics.draw(dynamiteSprite, self.x, self.y)
end

function updateDynamites(dt)
    for i,v in pairs(dynamites) do
        v:update(dt)
    end
end

function drawDynamites()
    for i,v in pairs(dynamites) do
        v:draw()
    end
end