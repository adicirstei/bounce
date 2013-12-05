ballpart = {}
systems = {}
current = 1

direction=0

function ballpart.load()

	part1 = love.graphics.newImage("part1.png");
	
	local p = love.graphics.newParticleSystem(part1, 1000)
	p:setEmissionRate(1000)
	p:setSpeed(300, 400)
	--p:setSize(2, 1)
	p:setColors(220, 105, 20, 255, 194, 30, 18, 0)
	p:setPosition(400, 300)
	p:setLifetime(-1)
	p:setParticleLife(0.3)
	p:setDirection(0)
	p:setSpread(math.pi*2)
	p:setTangentialAcceleration(1000)
	p:setRadialAcceleration(-2000)
	p:stop()
	table.insert(systems, p)
  ballpart.system = systems[current]

end

function ballpart.update(dt)
  ballpart.system:setPosition(ball.x, ball.y)
  --ballpart.system:start()
  ballpart.system:update(dt)
end

function ballpart.draw()
  love.graphics.setColorMode("modulate")
  love.graphics.setBlendMode("additive")
  love.graphics.draw(ballpart.system, 0, 0)
end
