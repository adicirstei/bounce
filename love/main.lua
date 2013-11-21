local map
local tx, ty = 0, 0

function love.load()
    -- Get Advanced Tiled Loader
    local ATL = require("modules/AdvTiledLoader") 

    --  Set maps/ as the base directory for map loading
    ATL.Loader.path = 'maps/'

    -- Use the loader to load the map
    map = ATL.Loader.load("desert.tmx") 

end

function love.update(dt)
    if love.keyboard.isDown("up") then ty = ty + 250*dt end
    if love.keyboard.isDown("down") then ty = ty - 250*dt end
    if love.keyboard.isDown("left") then tx = tx + 250*dt end
    if love.keyboard.isDown("right") then tx = tx - 250*dt end 
end
 
function love.draw()
    love.graphics.translate( math.floor(tx), math.floor(ty) )
    
    -- Set the draw range. Setting this will significantly increase drawing performance.
    map:autoDrawRange( math.floor(tx), math.floor(ty), 1, pad)    
    map:draw()
end