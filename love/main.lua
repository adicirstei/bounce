io.stdout:setvbuf("no")


local tx, ty = 0, 0
local tiles = {}
-- Get Advanced Tiled Loader
local ATL = require("modules/AdvTiledLoader") 
local pad = {
  x = 200,
  y = 720-16,
  w = 64, 
  h = 16
}
local ball = {
  r = 6
}

ball.pos = math.random(-pad.w, pad.w)

ball.y=pad.y-ball.r

local game = {
  balls = 3,
  roundStarted = false,
  timer = 0
}

function game.startRound()
  
  
  local s = 100;

  ball.speedX = 0
  ball.speedY = -100
  
  game.roundStarted = true
end

function love.load()
    --  Set maps/ as the base directory for map loading
    ATL.Loader.path = 'maps/'

    -- Use the loader to load the map
    game.map = ATL.Loader.load("level1.tmx") 
    game.map("Bricks"):set(0,0,game.map("Bricks")(1, 0))
    
    pad.left = love.graphics.newImage("pad-left.png")
    pad.right = love.graphics.newImage("pad-right.png")
    pad.center = love.graphics.newImage("pad-center.png")
    
    ball.img = love.graphics.newImage("solid-ball.png")
    
    for _, tile in pairs(game.map.tiles) do
      if tile.properties.type then
        tiles[tile.properties.type] = tile
      end
    end
end

function love.mousepressed( x, y, button )
  if not game.roundStarted then 
    game.startRound()
  else
    print(game.map("Bricks")(1,1), game.map("Bricks")(1, 0))
    game.map("Bricks"):set(1,1,nil)
    game.map:forceRedraw ()
    print(game.map("Bricks")(1,1))
  end
end


function game:update(dt)

  pad.x = love.mouse.getX()

  if not game.roundStarted then 
    ball.x = pad.x + ball.pos
  else
    ball.x = ball.x + ball.speedX*dt
    ball.y = ball.y + ball.speedY*dt
  end


  if love.keyboard.isDown("left") then pad.x = pad.x - 1000*dt end
  if love.keyboard.isDown("right") then pad.x = pad.x + 1000*dt end 


end

function game:draw()
  self.map:draw()
  self.drawBall()
  self.drawPad()
  self.drawHUD()
end
  
function game:drawHUD()
  love.graphics.print("FPS:"..love.timer.getFPS().." pos: "..ball.pos.." padw: "..pad.w, 0,0)
end
  
function game:drawPad()
  love.graphics.setColor(255, 255, 255, 255)
  --love.graphics.rectangle("fill", pad.x - pad.w, pad.y, pad.w*2, pad.h)
  local widthscale = (pad.w * 2-32)/16
  love.graphics.draw(pad.center, pad.x-pad.w+16, pad.y, 0, widthscale, 1)
  love.graphics.draw(pad.left, pad.x-pad.w, pad.y)
  love.graphics.draw(pad.right, pad.x+pad.w-16, pad.y)
end

function game:drawBall()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(ball.img, ball.x-ball.r, ball.y-ball.r)
  
  -- love.graphics.circle("fill", ball.x, ball.y, ball.r, 16)
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

