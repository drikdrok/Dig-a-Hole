love.graphics.setDefaultFilter("nearest", "nearest")
require("assets/codebase/core/require")

math.randomseed(os.time())

function love.load()
    game = game:new()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    if key == "escape" then 
        love.event.quit()
    end
    game:keypressed(key)
end