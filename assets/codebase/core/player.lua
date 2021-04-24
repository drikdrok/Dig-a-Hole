player = class("player")

local playerSheet = love.graphics.newImage("assets/gfx/sheets/playerSheet.png")


function playerFilter(item, other)
    if other.type == "dynamite" then 
        return nil
    end

    return "slide"
end

function player:initialize()
    self.x = 500
    self.y = -300
    self.width = 16
    self.height = 30

    self.speed = 200

    self.yvel = 0


    self.canJump = false

    self.digging = false
    self.diggingTileX = 1
    self.diggingTileY = 1
    self.diggingProgress = 0

    self.type = "player"


    self.grids = {
        walking = anim8.newGrid(20, 23, playerSheet:getWidth(), playerSheet:getHeight()),
        digging = anim8.newGrid(18, 23, playerSheet:getWidth(), playerSheet:getHeight())
    }

    self.animations = {
        walkingRight = anim8.newAnimation(self.grids.walking("1-4", 1), 0.2),
        walkingLeft = anim8.newAnimation(self.grids.walking("1-4", 2), 0.2),
        standingRight = anim8.newAnimation(self.grids.walking("5-5", 1), 0.2),
        standingLeft = anim8.newAnimation(self.grids.walking("5-5", 2), 0.2),
        diggingRight = anim8.newAnimation(self.grids.digging("1-2", 3), 0.2),
        diggingLeft = anim8.newAnimation(self.grids.digging("1-2", 4), 0.2),
    }

    self.currentAnimation = "walkingRight"


    self.stats = {
        dirt = 0,
        stone = 0,
        iron = 0,
        coal = 0,
        gold = 0,
    }


    self.money = 0


    collisionWorld:add(self, self.x, self.y, self.width, self.height)

end

function player:update(dt)
    local xDir
    self.currentAnimation = self.currentAnimation:gsub("walking", "standing"):gsub("digging", "standing")
    if love.keyboard.isDown("a") then 
        self.x = self.x - self.speed * dt
        self.currentAnimation = "walkingLeft"
        xDir = -1
    end
    if love.keyboard.isDown("d") then 
        self.x = self.x + self.speed * dt
        self.currentAnimation = "walkingRight"
        xDir = 1
    end

    self.yvel = self.yvel + game.gravity * dt
    self.y = self.y + self.yvel * dt

    self.x, self.y, cols, len = collisionWorld:move(self, self.x, self.y, playerFilter)
    for i,v in pairs(cols) do
        if v.normal.y == -1 then 
            self.canJump = true
            self.yvel = 0
        elseif v.normal.y == 1 then 
            self.yvel = 0
        end
    end

    if len == 0 then 
        self.canJump = false
    end

    self:dig(dt)

    local mouseX, mouseY = camera:mousePosition()

    if self.digging then 
        if mouseX > self.x then 
            self.currentAnimation = "diggingRight"
        else
            self.currentAnimation = "diggingLeft"
        end
    end

    self.animations[self.currentAnimation]:update(dt)
end

function player:draw()
    local offset = 0
    if self.currentAnimation:find("Left") then -- dirty hack
        offset = -11
    end
    self.animations[self.currentAnimation]:draw(playerSheet, self.x + offset, self.y-3, 0, 1.5)
end

function player:keypressed(key)
    if key == "space" and self.canJump then 
        self.yvel = -500
        self.canJump = false
    end

    if key == "q" then 
        dynamite:new(self.x, self.y)
    end
end


function player:dig(dt)
    local mouseX, mouseY = camera:mousePosition()
    mouseX = math.floor(mouseX / 16)
    mouseY = math.floor(mouseY / 16)

    
    if love.mouse.isDown(1) then 
        if mouseY > 0 and mouseY < ground.height and mouseX > 0 and mouseX < ground.width then
        local material = ground.tiles[mouseY][mouseX].material
           if self.digging then 
                if mouseX ~= self.diggingTileX or mouseY ~= self.diggingTileY then -- Mouse move off digging tile
                    self.diggingProgress = 0
                    self.diggingTileX = mouseX
                    self.diggingTileY = mouseY
                end
                self.diggingProgress = self.diggingProgress + 10*dt

                if self.diggingProgress >= 1 and material ~= "none" then -- Digging done
                   ground:dig(mouseX, mouseY)
                    
                    self.digging = false
                    self.diggingProgress = 0
                    
                 
                end
            else
                if material ~= "none" then 
                    self.digging = true
                    self.diggingTileX = mouseX
                    self.diggingTileY = mouseY
                end
            end
        end
    else
        self.digging = false
    end
end
