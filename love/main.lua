io.stdout:setvbuf("no")

local map
local tx, ty = 0, 0

-- Get Advanced Tiled Loader
local ATL = require("modules/AdvTiledLoader") 
local game = {
  balls = 3,
  pad = {
    x = 2,
    y = 300,
    w = 200
  }
}
function game:update(dt)
  if love.keyboard.isDown("left") then self.pad.x = self.pad.x + 250*dt end
  if love.keyboard.isDown("right") then self.pad.x = self.pad.x - 250*dt end 
end

function game:draw()
  self.map:draw()
  self.drawPad()
  self.drawHUD()
end
  
function game:drawHUD()
end
  
function game:drawPad()
end


function love.load()


    --  Set maps/ as the base directory for map loading
    ATL.Loader.path = 'maps/'

    -- Use the loader to load the map
    game.map = ATL.Loader.load("level1.tmx") 

end

function love.update(dt)
  game:update(dt)
end
 
function love.draw()
    -- love.graphics.translate( math.floor(tx), math.floor(ty) )
    
    -- Set the draw range. Setting this will significantly increase drawing performance.
    -- game.map:autoDrawRange( math.floor(tx), math.floor(ty), 1, pad)    
    game:draw()
end