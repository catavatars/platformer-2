
local game = {}

function game:load()
  physx.loadMap(maps.getMap())
  player.respawn()
end

function game:draw()
  camera:set()
  player.draw()
  physx.drawMap()
  camera:unset()
end

function game:update(dt)
  player.update(Dt)
  physx.update(dt)
end

function game:keypressed(key)
  player.keypressed(key)
  if key == "q" then
    maps.lastMap()
    boxnum = 0
		physx.loadMap(maps.getMap())
  elseif key == "e" then
    maps.nextMap()
    boxnum = 0
    physx.loadMap(maps.getMap())
  end
  if key == "r" then
    boxnum = 0
    physx.loadMap(maps.getMap())
  end
  if key == "c" then
    player.respawn()
  end
end

return game
