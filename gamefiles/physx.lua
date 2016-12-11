
physx = {}
physx.tiles = {}
physx.exitReached = false
physx.numPortal1 = 0
physx.numPortal2 = 0

local sys = {}

s = 10
c = 11
e = 12
b = 13
d = 14
o = 15
l = 16
r = 17
k = 18

world = love.physics.newWorld(0, 9.16*81, true)
boxnum = 0
checkpointnum = 1

local img = love.graphics.newImage('gfx/particle.png');
bgel = love.graphics.newParticleSystem(img, 32)
bgel:setParticleLifetime(5, 5)
bgel:setLinearAcceleration(-50, -5, 20, -100)
bgel:setColors(0, 130, 255, 20)

local function static(x, y, w, h, c, data, img)
	dead = false
	body = love.physics.newBody(world, x, y, "static")
	shape = love.physics.newRectangleShape(w, h)
	fixture = love.physics.newFixture(body, shape)
	fixture:setFriction(0.5)
	if img then
		img = love.graphics.newImage(img)
	elseif not img then img = nil end
	fixture:setUserData(data)
	table.insert(physx.tiles, {body = body, shape = shape, fixture = fixture, dead = dead, color = c, img = img})
end

local function dynamic(x, y, w, h, c, data, img)
	dead = false
	body = love.physics.newBody(world, x, y, "dynamic")
	shape = love.physics.newRectangleShape(w, h)
	fixture = love.physics.newFixture(body, shape)
	if img then
		img = love.graphics.newImage(img)
	elseif not img then img = nil end
	fixture:setUserData(data)
	table.insert(physx.tiles, {body = body, shape = shape, fixture = fixture, dead = dead, color = c, img = img})
end

local function checkpoint(x, y, w, h, c, data, img)
	dead = false
	body = love.physics.newBody(world, x, y, "static")
	shape = love.physics.newRectangleShape(w, h)
	fixture = love.physics.newFixture(body, shape)
	if img then
		img = love.graphics.newImage(img)
	elseif not img then img = nil end
	fixture:setUserData("checkpoint"..checkpointnum)
	checkpointnum = checkpointnum + 1
	table.insert(physx.tiles, {body = body, shape = shape, fixture = fixture, dead = dead, color = c, img = img})
end

function physx.loadMap(map)
	boxnum = 0
	world:setCallbacks(physx.Bcontact, physx.Econtact)
	for k, v in ipairs(physx.tiles) do
		if not v.dead then
			v.dead = true
			v.body:destroy()
		end
	end
	for k, v in ipairs(sys) do
		v.p:reset()
	end
	for y=1, #map do
		for x=1, #map[y] do
			if map[y][x] == 1 then
				static(x * 25, y * 25 + 20, 25, 25, {100, 100, 100}, "walk0", "gfx/grey brick.png")
			elseif map[y][x] == 2 then
				static(x * 25, y * 25 + 20, 25, 25, {100, 100, 100}, "walk1", "gfx/grey brick.png")
			elseif map[y][x] == 3 then
				static(x * 25, y * 25 + 23, 25, 19, {190, 40, 40}, "lava")
			elseif map[y][x] == 4 then
				dynamic(x * 25, y * 25 + 20, 20, 20, {160, 100, 40}, "box", "gfx/crate.png")
			elseif map[y][x] == 5 then
				static(x * 25, y * 25 + 10, 25, 5, {0, 130, 255}, "gelBounce", "gfx/blue.png")
				static(x * 25, y * 25 + 23, 25, 20, {100, 100, 100}, "walk1", "gfx/grey brick.png")
			elseif map[y][x] == 6 then
				static(x * 25, y * 25 + 10, 25, 5, {255, 130, 0}, "gelSpeed", "gfx/orange.png")
				static(x * 25, y * 25 + 23, 25, 20, {100, 100, 100}, "walk1", "gfx/grey brick.png")
			elseif map[y][x] == 7 then
				static(x * 25, y * 25 + 10, 25, 5, {150, 150, 150}, "platform", "gfx/platform.png")
			elseif map[y][x] == 8 then
				static(x * 25, y * 25 + 20, 15, 25, {150, 150, 150}, "door", "gfx/door.png")
			elseif map[y][x] == 9 then
				static(x * 25, y * 25 + 20, 15, 25, {0, 130, 255, 70}, "glass")
			elseif map[y][x] == s then
				player.setSpawn(x * 25, y * 25 + 20)
				player.respawn()
			elseif map[y][x] == e then
				static(x * 25, y * 25 + 20, 15, 25, {255, 255, 255}, "exit", "gfx/exit.png")
			elseif map[y][x] == c then
				checkpoint(x * 25, y * 25 + 20, 15, 25, {170, 0, 0}, "checkpoint", "gfx/checkpoint.png")
			elseif map[y][x] == b then
				static(x * 25, y * 25 + 25, 20, 5, {190, 40, 40}, "button")
				static(x * 25, y * 25 + 30, 25, 5, {150, 150, 150}, "button_base")
			elseif map[y][x] == o then
				static(x * 25, y * 25 + 10, 15, 5, {190, 40, 40}, "button2")
				static(x * 25, y * 25 + 25, 15, 25, {150, 150, 150}, "button_base")
			elseif map[y][x] == d then
				static(x * 25, y * 25 + 20, 20, 25, {130, 130, 130}, "dispenser")
			elseif map[y][x] == l then
				static(x * 25 - 10, y * 25 + 20, 5, 25, {160, 32, 240}, "wallRun", "gfx/orange.png")
				static(x * 25 + 2, y * 25 + 20, 20, 25, {100, 100, 100}, "walk1", "gfx/grey brick.png")
			elseif map[y][x] == r then
				static(x * 25 + 10, y * 25 + 20, 5, 25, {160, 32, 240}, "wallRun", "gfx/orange.png")
				static(x * 25 - 3, y * 25 + 20, 20, 25, {100, 100, 100}, "walk1", "gfx/grey brick.png")
			elseif map[y][x] == k then
				static(x * 25 - 10, y * 25 + 20, 5, 25, {160, 32, 240}, "wallRun", "gfx/orange.png")
				static(x * 25 + 10, y * 25 + 20, 5, 25, {160, 32, 240}, "wallRun", "gfx/orange.png")
				static(x * 25, y * 25 + 20, 15, 25, {100, 100, 100}, "walk1", "gfx/grey brick.png")
			end
		end
	end
end

function physx.drawMap()
	for k, v in ipairs(sys) do
		love.graphics.draw(v.p, -1, -1);
	end
	for k, v in ipairs(physx.tiles) do
		if not v.dead then
			love.graphics.setColor(v.color)
			--if not v.img then
				love.graphics.polygon("fill", v.body:getWorldPoints(v.shape:getPoints()))
			--[[elseif v.img then
				if v.fixture:getUserData() == "door" then
					if v.open then else
						love.graphics.setColor(255, 255, 255)
						love.graphics.draw(v.img, v.body:getX(), v.body:getY(), v.body:getAngle(), 1, 1, 13, 13, 0, 0)
					end
				elseif v.fixture:getUserData() ~= "door" then
					love.graphics.setColor(255, 255, 255)
					love.graphics.draw(v.img, v.body:getX(), v.body:getY(), v.body:getAngle(), 1, 1, 13, 13, 0, 0)
				end]]
			--end
		end
	end
end

function physx.update(dt)
	for k, v in ipairs(sys) do
		v.p:update(dt)
	end
	world:update(dt)
	if physx.exitReached then
		maps.nextMap()
		physx.loadMap(maps.getMap())
		love.audio.newSource("sound/exit.wav"):play()
		physx.exitReached = false
	end
	if boxnum == 1 then
		for k, v in ipairs(physx.tiles) do
			if not v.dead then
				if v.fixture:getUserData() == "dispenser" then
					dynamic(v.body:getX(), v.body:getY() + 25, 25, 25, {160, 100, 40}, "box", "gfx/crate.png")
					boxnum = 2
				end
			end
		end
	end
end

function physx.Bcontact(a1, a2)
	d1, d2 = a1:getUserData(), a2:getUserData()
	if d1 == "gelBounce" or d2 == "gelBounce" then
		if d2 == "box" then
			a2:getBody():applyLinearImpulse(0, -170)
			local x = love.graphics.newParticleSystem(img, 32)
			x:setParticleLifetime(3, 3)
			x:setLinearAcceleration(-15, -5, 20, -20)
			x:setColors(120, 150, 255, 90)
			x:setPosition(a1:getBody():getX(), a1:getBody():getY() + 15)
			x1, y1 = x:getPosition()
			table.insert(sys, {p=x, x=x1, y=y1})
			x:emit(10)
		elseif d1 == "box" then
			local x = love.graphics.newParticleSystem(img, 32)
			x:setParticleLifetime(1, 3)
			x:setLinearAcceleration(-15, -5, 20, -20)
			x:setColors(120, 150, 255, 90)
			x:setPosition(a1:getBody():getX(), a1:getBody():getY() + 15)
			x1, y1 = x:getPosition()
			table.insert(sys, {p=x, x=x1, y=y1})
			x:emit(10)
			a1:getBody():applyLinearImpulse(0, -170)
		end
	end
	if d1 == "player" or d2 == "player" then
		if d1 == "walk0" or d2 == "walk0" then
			player.jumping = true
		else player.jumping = false end
		if d1 == "glass" or d2 == "glass" then
			player.jumping = true
		end
		if d1 == "gelBounce" or d2 == "gelBounce" then
			local x = love.graphics.newParticleSystem(img, 32)
			x:setParticleLifetime(3, 3)
			x:setLinearAcceleration(-15, -5, 20, -20)
			x:setColors(120, 150, 255, 90)
			if d1 == "gelBounce" then
				x:setPosition(a1:getBody():getX(), a1:getBody():getY() + 15)
			elseif d2 == "gelBounce" then
				x:setPosition(a2:getBody():getX(), a2:getBody():getY() + 15)
			end
			x1, y1 = x:getPosition()
			table.insert(sys, {p=x, x=x1, y=y1})
			x:emit(10)
			player.jumpForce = 210
		end
		if d1 == "gelSpeed" or d2 == "gelSpeed" then
			local x = love.graphics.newParticleSystem(img, 32)
			x:setParticleLifetime(3, 3)
			x:setLinearAcceleration(-15, -5, 20, -20)
			x:setColors(255, 130, 0, 50)
			if d1 == "gelSpeed" then
				x:setPosition(a1:getBody():getX(), a1:getBody():getY() + 15)
			elseif d2 == "gelSpeed" then
				x:setPosition(a2:getBody():getX(), a2:getBody():getY() + 15)
			end
			x1, y1 = x:getPosition()
			table.insert(sys, {p=x, x=x1, y=y1})
			x:emit(10)
			player.moveSpeed = 510
			player.maxVelocity = 320
		end
		if d1 == "lava" or d2 == "lava" then
			player.jumping = false
			player.dead = true
		end
		if d1 == "exit" or d2 == "exit" then
			physx.exitReached = true
			player.jumping = false
		end
		if d1 == "button2" or d2 == "button2" then
			player.jumping = false
			for k, v in ipairs(physx.tiles) do
				if not v.dead then
					if v.fixture:getUserData() == "dispenser" then
						if boxnum == 2 then else boxnum = 1 end
					end
				end
			end
		end
	end
	if d1 == "box" or d2 == "box" then
		if d1 == "button" or d2 == "button" then
			love.audio.newSource("sound/button.wav"):play()
			for k, v in ipairs(physx.tiles) do
				if not v.dead then
					if v.fixture:getUserData() == "door" then
						v.open = true
						v.color = {150, 150, 150, 0}
						v.fixture:setMask(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
					end
				end
			end
		end
	end
	if d1 == "player" and d2:utf8sub(1, -2) == "checkpoint" then
		for k, v in ipairs(physx.tiles) do
			if not v.dead then
				if v.fixture:getUserData() == a2:getUserData() then
					v.color = {0, 170, 0, 90}
					v.fixture:setMask(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
					player.setSpawn(a2:getBody():getX(), a2:getBody():getY())
				end
			end
		end
		--player.setSpawn(a2:getBody():getX(), a2:getBody():getY())
	elseif d2 == "player" and d1:utf8sub(1, -2) == "checkpoint" then
		for k, v in ipairs(physx.tiles) do
			if not v.dead then
				if v.fixture:getUserData() == a1:getUserData() then
					v.color = {0, 170, 0, 90}
					v.fixture:setMask(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
					player.setSpawn(a2:getBody():getX(), a2:getBody():getY())
				end
			end
		end
	end
end

function physx.Econtact(a1, a2)
	d1, d2 = a1:getUserData(), a2:getUserData()
	if d1 == "player" or d2 == "player" then
		if d1 == "gelBounce" or d2 == "gelBounce" then
			player.jumpForce = 120
		end
		if d1 == "gelSpeed" or d2 == "gelSpeed" then
			player.moveSpeed = 350
			player.maxVelocity = 200
		end
		if d1 == "glass" or d2 == "glass" then
			player.jumping = true
		end
	end
	--[[if d1 == "box" or d2 == "box" then
		if d1 == "button" or d2 == "button" then
			for k, v in ipairs(physx.tiles) do
				if not v.dead then
					if v.fixture:getUserData() == "door" then
						v.open = false
						v.color = {150, 150, 150, 255}
						v.fixture:setMask()
					end
				end
			end
		end
	end]]
end
