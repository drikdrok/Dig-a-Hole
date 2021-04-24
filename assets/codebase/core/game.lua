game = class("game")

function game:initialize()

    camera = Camera(62*16/2, 0)
    camera.scale = 2.6
    camera.smoother = rubber_band

    collisionWorld = bump.newWorld()

    love.graphics.setBackgroundColor(168 / 255, 231 / 255, 1)

    ground = ground:new()
    player = player:new()

    self.gravity = 2000

    self.fonts = {}

    self:fontSize(12)
end


function game:update(dt)
    ground:update(dt)

    player:update(dt)
    updateFloatingTexts(dt)
    updateDynamites(dt)
    updateExplosions(dt)
    updateparticles(dt)

    if player.y > 100 then 
        camera:lockY(160)
    else
        camera:lockY(0)
    end


end

function game:draw()
    camera:attach()
        ground:draw()
        drawDynamites()
        player:draw()
        drawparticles()
        drawExplosions()
    camera:detach()
    
    drawFloatingTexts()

    love.graphics.setColor(0,0,0)
    self:fontSize(20)
    love.graphics.print("$: "..player.money)
    love.graphics.setColor(1,1,1)

end


function game:keypressed(key)
    player:keypressed(key)

    if key == "r" then 
        collisionWorld = bump.newWorld()
        ground:generate()
        player.y = -100
        collisionWorld:add(player, player.x, player.y, player.width, player.height)
    end
end

function game:fontSize(size)
    if not self.fonts[size] then 
        self.fonts[size] = love.graphics.newFont("assets/gfx/fonts/pixelmix.ttf", size)
    end
    love.graphics.setFont(self.fonts[size])
end

function rubber_band(dx,dy)
    local dt = love.timer.getDelta()
    return dx*dt, dy*dt
end

