io.stdout:setvbuf("no")
require "splash"
require "ballpart"


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
ball = {
  r = 6,
  a = 10
}

game = {
  balls = 3,
  roundStarted = false,
  timer = 0
}
function game.changeState()
  if state == "splash" then
  
    -- the ball is glued to the pad
    state = "prelaunch"
    ball.pos = math.random(-pad.w, pad.w)
    ball.y=pad.y-ball.r
  elseif state == "prelaunch" then
    state = "play"
  end
end

function getAlphaFromPos(p)
  return math.pi/2 - p*math.pi/pad.w/3
end

function game.startRound()
  local a, s = getAlphaFromPos(ball.pos), 150
  
  print (a, s)
  ball.speedX = s*math.cos(a)
  ball.speedY = s*math.sin(a)
  ballpart.system:start()
  game.roundStarted = true
  game.changeState()
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
    splash.load()
    
    ballpart.load()
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
    local a, s = getAlphaFromPos(ball.x-pad.x), math.sqrt(ball.speedX^2+ball.speedY^2)
  
    print (a, s)
    ball.speedX = s*math.cos(a)
    ball.speedY = -s*math.sin(a)
  end
  
  -- margin collision
  if ball.x-ball.r<0 or ball.x+ball.r>love.graphics.getWidth() then
    ball.speedX = -ball.speedX
  end
  local brick = {}
  -- brick collision
  for x, y, tile in game.map("Bricks"):iterate() do
    -- brick in pixels
    x1 = x*tw
    y1 = y*th
    x2 = (x+1)*tw - 1
    y2 = (y+1)*th - 1    
    -- check if the tile is colidable on lower edge
    if game.map("Bricks"):get(x, y+1) == nil then
      if (ball.y < y2+ ball.r) and (ball.x > x1-ball.r) and ball.x < x2+ball.r then
        ball.speedY = -ball.speedY
        brick.x, brick.y, brick.tile = x, y, tile
        ball.y = y2+ball.r
        collideWithBrick(brick)
      end
    end
    -- check if the tile is colidable on upper edge
    if y > 0 and game.map("Bricks"):get(x, y-1) == nil then
      if (ball.y > y1 - ball.r) and (ball.x > x1-ball.r) and ball.x < x2+ball.r then
        ball.speedY = -ball.speedY
        brick.x, brick.y, brick.tile = x, y, tile
        ball.y = y1-ball.r
        collideWithBrick(brick)
      end
    end

    -- check if the tile is colidable on left edge
   
    if x > 0 and game.map("Bricks"):get(x-1, y) == nil then
      if (ball.x > x1 - ball.r) and (ball.x < x2) and (ball.y > y1-ball.r) and ball.y < y2+ball.r then
        ball.speedX = -ball.speedX
        brick.x, brick.y, brick.tile = x, y, tile
        ball.x = x1-ball.r
        collideWithBrick(brick)
      end
    end

    -- check if the tile is colidable on right edge
    if game.map("Bricks"):get(x+1, y) == nil then
      if (ball.x < x2 + ball.r) and (ball.x > x1) and (ball.y > y1-ball.r) and ball.y < y2+ball.r then
        ball.speedX = -ball.speedX
        brick.x, brick.y, brick.tile = x, y, tile
        ball.x = x2+ball.r
        collideWithBrick(brick)
      end
    end


  end
  
end

function collideWithBrick(b)
  
  game.map("Bricks"):set(b.x, b.y, nil)
  game.map:forceRedraw ()
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
    
    ballpart.update(dt)
    computeCollision()
    ball.x = ball.x + ball.speedX*dt
    ball.y = ball.y + ball.speedY*dt
  end


  if love.keyboard.isDown("left") then pad.x = pad.x - 1000*dt end
  if love.keyboard.isDown("right") then pad.x = pad.x + 1000*dt end 


end

function game:draw()
  self.map:draw()
  ballpart.draw()
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

