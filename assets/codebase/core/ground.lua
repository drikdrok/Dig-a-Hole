ground = class("ground")

local sprites = {
    stone = love.graphics.newImage("assets/gfx/sprites/stone.png"),
    coal = love.graphics.newImage("assets/gfx/sprites/coal.png"),
    iron = love.graphics.newImage("assets/gfx/sprites/iron.png"),
    gold = love.graphics.newImage("assets/gfx/sprites/gold.png"),
    grass = love.graphics.newImage("assets/gfx/sprites/grass.png"),
    dirt = love.graphics.newImage("assets/gfx/sprites/dirt.png"),
}

local rewards = {
    coal = {5, 10},
    iron = {7, 15},
    gold = {20, 35}
}

function ground:initialize()

    self.width = 61
    self.height = 40

    self.tiles = {}
    self.background = {}

    self:generate()
end


function ground:update(dt)

end

function ground:draw()
    for y,row in pairs(self.tiles) do
        for x, tile in pairs(row) do
            if tile.material == "none"  then
                if self.background[y][x].material ~= "none" then 
                    love.graphics.setColor(0.3, 0.3, 0.3)
                    love.graphics.draw(sprites[self.background[y][x].material], x*16, y*16)
                    love.graphics.setColor(1,1,1)
                end
            else
                love.graphics.draw(sprites[tile.material], x*16, y*16)
            end
        end
    end

    local mouseX, mouseY = camera:mousePosition()
    mouseX = math.floor(mouseX / 16)
    mouseY = math.floor(mouseY / 16)
    love.graphics.setColor(1,1,0)
    love.graphics.setLineWidth(2)
    if mouseY > 0 and mouseY < ground.height and mouseX > 0 and mouseX < ground.width and self.tiles[mouseY][mouseX].material ~= "none" then 
        love.graphics.rectangle("line", mouseX*16, mouseY*16, 16, 16)

        if player.digging then 
            love.graphics.rectangle("fill", mouseX*16, mouseY*16 - 10, player.diggingProgress *16, 2)
        end
    end
    love.graphics.setColor(1,1,1)
end

function ground:dig(x, y)

    if self.tiles[y] and self.tiles[y][x] then 
        local material = self.tiles[y][x].material
        
        if material ~= "none" then 
            collisionWorld:remove(self.tiles[y][x])
            for i = 0, math.random(3, 7) do
                particle:new(x*16, y*16)
            end
        end
        
        if rewards[material] then 
            local x,y = camera:cameraCoords(x*16, y*16)
            local reward = math.random(rewards[material][1], rewards[material][2])
            floatingText:new("$"..reward, x, y)
            player.money = player.money + reward
        end

        self.tiles[y][x].material = "none"

    end
end


function ground:generate()

    self.tiles = {}
    for y = 1, self.height do 
        local row = {}
        local rowBackground = {}
        for x = 1, self.width do
            local material = "stone"
            local background = "stone"

            if y == 1 then 
                material = "grass"
                background = "none"
            elseif y < 4 or (y < 5 and math.random(1, 2) == 1 ) then 
                material = "dirt"
                background = "dirt"
            else
                if math.random(1, 30) == 5 then 
                    local ores = {"iron", "coal", "gold"}
                    material = ores[math.random(1, 3)]
                end
            end

            table.insert(row, {material = material})
            table.insert(rowBackground, {material = background})
        end
        table.insert(self.tiles, row)
        table.insert(self.background, rowBackground)
    end
    
    for y = 1, self.height do 
        for x = 1, self.width do
            collisionWorld:add(self.tiles[y][x], x*16, y*16, 16, 16)
        end
    end

end