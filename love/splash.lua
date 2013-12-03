splash = {}

function splash.load()
  state = "splash"
  splash.img = love.graphics.newImage("splash.png")
  
end

function splash.draw()
  
  
  love.graphics.setColor(7,25,86)
  love.graphics.rectangle("fill", 0,0, 960, 720)
  love.graphics.setColor(255,255,255)
  love.graphics.draw(splash.img, 200,0)
  love.graphics.setColor(237,234,94)
  love.graphics.print("Press any key to start", 100, 500)
end

function splash.keypressed(key)
  game.changeState()
end