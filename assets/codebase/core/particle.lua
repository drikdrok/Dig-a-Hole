particle = class("particle")

local particles = {}

local sprites = {
    love.graphics.newImage("assets/gfx/sprites/stoneParticle1.png"),
}


function particle:initialize(x, y)
    self.x = x
    self.y = y

    self.yvel = math.random(-100, 50)
    self.xvel = math.random(-100, 100)

    self.rotation = 0
    self.rotDir = math.random(-1, 1)
    self.rotSpeed = math.random(0, math.pi)

    self.image = sprites[math.random(1, #sprites)]

    self.age = 0

    self.id = #particles + 1

    table.insert(particles, self)
end

function particle:update(dt)
    self.age = self.age + dt

    self.x = self.x + self.xvel * dt

    self.yvel = self.yvel + game.gravity/4 * dt
    self.y = self.y + self.yvel * dt 

    self.rotation = self.rotation + self.rotSpeed * self.rotDir * dt 

    if self.age >= 5 then
        particles[self.id] = nil
    end

end

function particle:draw()
   love.graphics.draw(self.image, self.x, self.y, self.rotation)
end

function updateparticles(dt)
    for i,v in pairs(particles) do
        v:update(dt)
    end
end

function drawparticles()
    for i,v in pairs(particles) do
        v:draw()
    end
end