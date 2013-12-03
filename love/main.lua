io.stdout:setvbuf("no")
require "splash"

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
  r = 6,
  a = 1
}

ball.pos = math.random(-pad.w, pad.w)

ball.y=pad.y-ball.r

game = {
  balls = 3,
  roundStarted = false,
  timer = 0
}
function game.changeState()
  if state == "splash" then
    state = "prelaunch"
  end
end


function game.startRound()
  
  
  local s = 100;

  ball.speedX = 50
  ball.speedY = -100
  
  game.roundStarted = true
end

function love.load()
    --  Set maps/ as the base directory for map loading
    ATL.Loader.path = 'maps/'

    -- Use the loader to load the map
    game.map = ATL.Loader.load("level.tmx") 
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
    splash.load()
end

function love.mousepressed( x, y, button )
  if not game.roundStarted then 
    game.startRound()
  else

    game.map("Bricks"):set(0,0,nil)    -- row, column, tile
    game.map("Bricks"):set(0,2,nil)
    
    game.map:forceRedraw ()

  end
end

function computeCollision()
  local x1, y1, x2, y2
  local tw, th = game.map.tileWidth, game.map.tileHeight
  
  -- check the margins and pad first
  if (ball.x > pad.x-pad.w and ball.x<pad.x+pad.w and ball.y+ball.r > pad.y) or (ball.y-ball.r<0) then
    -- new speed based on the place it hits the pad
    
    ball.speedY = -ball.speedY
  end
  
  if ball.x-ball.r<0 or ball.x+ball.r>love.graphics.getWidth() then
    ball.speedX = -ball.speedX
  end
  
  
  for x, y, tile in game.map("Bricks"):iterate() do
    -- brick in pixels
    x1 = x*tw
    y1 = y*th
    
    x2 = (x+1)*tw - 1
    y2 = (y+1)*th - 1
    
    -- lower edge
    if (ball.y < y2+ ball.r) and (ball.x > x1-ball.r) and ball.x < x2+ball.r then
      game.map("Bricks"):set(x, y, nil)
      game.map:forceRedraw ()
      ball.speedY = -ball.speedY
      
    end
    --print(x, y, tile.properties.type)
  end
  
end


function game:update(dt)

  pad.x = love.mouse.getX()
  
  if not game.roundStarted then 
    ball.x = pad.x + ball.pos
  else
    if ball.speedX<0 then
      ball.speedX = ball.speedX - ball.a*dt
    else
      ball.speedX = ball.speedX + ball.a*dt
    end
    if ball.speedY < 0 then
      ball.speedY = ball.speedY - ball.a*dt
    else
      ball.speedY = ball.speedY + ball.a*dt
    end
    computeCollision()
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

function love.keypressed(key)
  if state=="splash" then 
    splash.keypressed(key)
  end
end

function love.focus(f)
  if not f then splash.load() end
end


function printMap()
  for x, y, tile in game.map("Bricks"):iterate() do
    print(x, y, tile.properties.type)
  end

end


function love.update(dt)
  if state=="splash" then return end
  if love.keyboard.isDown("d") then 
    printMap()
  
  end
  
  
  game:update(dt)
end
 
function love.draw()
    -- love.graphics.translate( math.floor(tx), math.floor(ty) )
    
    -- Set the draw range. Setting this will significantly increase drawing performance.
    -- game.map:autoDrawRange( math.floor(tx), math.floor(ty), 1, pad) 
    if state == "splash" then 
      splash.draw()
    else
      game:draw()
    end
end

