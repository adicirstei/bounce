local map

function love.load()
    -- Get Advanced Tiled Loader
    local ATL = require("modules/AdvTiledLoader") 

    --  Set maps/ as the base directory for map loading
    ATL.Loader.path = 'maps/'

    -- Use the loader to load the map
    map = ATL.Loader.load("desert.tmx") 

end

function love.update(dt)
 
end
 
function love.draw()
    map:draw()
end