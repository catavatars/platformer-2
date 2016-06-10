
local player = {}
player.spawnpoint = {x = 0, y = 0}
player.img = love.graphics.newImage('gfx/character.png')
player.body = love.physics.newBody(world, player.spawnpoint.x, player.spawnpoint.y, "dynamic")
player.shape = love.physics.newRectangleShape(20, 20)
player.fixture = love.physics.newFixture(player.body, player.shape)
player.fixture:setUserData("player")
player.fixture:setFriction(1)
--player.body:setFixedRotation(true)
player.moveSpeed = 350
player.jumpForce = 120
player.jumping = false
player.maxVelocity = 200
player.dead = false

function player.setSpawn(x, y)
	player.spawnpoint = {x = x, y = y}
end

function player.respawn()
	player.body:setLinearVelocity(0, 0)
	player.body:setPosition(player.spawnpoint.x, player.spawnpoint.y)
end

function player.getSpawnX()
	return player.spawnpoint.x
end

function player.getSpawnY()
	return player.spawnpoint.y
end

function player.update(dt)
	lk = love.keyboard
	player.body:applyLinearImpulse(0, -0.009)
	if lk.isDown("left") then
		player.body:applyForce(-player.moveSpeed, 0)
	elseif lk.isDown("right") then
		player.body:applyForce(player.moveSpeed, 0)
	end
	if player.dead then
		player.dead = false
		player.respawn()
		love.audio.newSource("sound/died.wav"):play()
	end
	xN, yN = player.body:getLinearVelocity()
	if player.body:getLinearVelocity() >= player.maxVelocity then
		player.body:setLinearVelocity(player.maxVelocity, yN)
	elseif player.body:getLinearVelocity() <= -player.maxVelocity then
		player.body:setLinearVelocity(-player.maxVelocity, yN)
	end
	camera:setPosition(math.floor(player.body:getX()) - love.graphics.getWidth() / 2, math.floor(player.body:getY()) - love.graphics.getHeight() / 2)
end

function player.draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(player.img, player.body:getX(), player.body:getY(), player.body:getAngle(), 1, 1, player.img:getWidth()/2, player.img:getHeight()/2)
  love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))
end

function player.keypressed(k)
	if k == "space" and player.jumping == false then
		player.body:applyLinearImpulse(0, -player.jumpForce)
		player.jumping = true
		love.audio.newSource("sound/jump.wav"):play()
	end
end

return player
