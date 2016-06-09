
require('require')

function love.load()
	camera:setBounds(0, 0, 0, 0)
	states.newState("game", game)
	states.setState("game")
	states.load("game")
	love.graphics.setBackgroundColor(100, 180, 255)
	love.window.setMode(670, 470, {vsync = false})
	love.graphics.setDefaultFilter('nearest', 'nearest')
end

function love.draw()
	states.draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(love.timer.getFPS(), math.floor(camera._x) + 10, 10)
end

function love.update(dt)
	states.update(dt)
end

function love.keypressed(k)
	states.keypressed(k)
end

function love.mousepressed(x, y, button)
	states.mousepressed(x, y, button)
end
