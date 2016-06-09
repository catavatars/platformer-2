

anim = {}

function anim.new(imgtable, time, loop)
	local anim1 = {}
	anim1.img = imgtable
	anim1.elapsed = 0
	anim1.curImage = 1
	anim1.time = time
	if loop then
		anim1.loop = true
		anim1.loopDone = false
	end
	function anim1:draw(x, y)
		love.graphcis.setColor(255, 255, 255)
		love.graphics.draw(anim1.img[anim1.curImage], x, y, 0, 1)
	end
	function anim1:update(dt)
		anim1.elapsed = anim1.elapsed + 0.8 * dt
		if math.floor(elapsed) == anim1.time then
			if anim1.loop then
				if not anim1.loopDone then
					if anim1.curImage ~= #anim1.img then
						anim1.curImage = anim1.curImage + 1
					else anim1.loopDone = true end
					anim1.elapsed = 0
				elseif anim1.loopDone then
					if anim1.curImage ~= 1 then
						anim1.curImage = anim1.curImage - 1
					else anim1.loopDone = false
					anim1.elapsed = 0
				end
			elseif not anim1.loop then
				if anim1.curImage ~= #anim1.img then
					anim1.curImage = anim1.curImage + 1
				else end
				elapsed = 0
			end
		end
	end
	return anim1
end