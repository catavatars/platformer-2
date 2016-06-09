
function love.errhand(msg)
    if love.audio then love.audio.stop() end
    love.graphics.reset()
    love.graphics.setBackgroundColor(100, 180, 255)
    local function draw()
        love.graphics.clear()
        love.graphics.setFont(love.graphics.newFont(13))
        love.graphics.print(msg, math.floor((love.graphics.getWidth() / 2) - (math.floor(love.graphics.newFont(14):getWidth(msg) / 2))), 230)
        love.graphics.setFont(love.graphics.newFont(25))
        love.graphics.print("error", (love.graphics.getWidth() / 2) - (love.graphics.newFont(25):getWidth("error") / 2), 130)
        love.graphics.setFont(love.graphics.newFont(15))
        love.graphics.print("u dun goofed", (love.graphics.getWidth() / 2) - (love.graphics.newFont(15):getWidth("u dun goofed") / 2), 160)
        love.graphics.present()
    end
    while true do
        love.event.pump()
        for e, a, b, c in love.event.poll() do
            if e == "quit" then return end
            if e == "keypressed" and a == "escape" then return end
        end
        draw()
        if love.timer then
            love.timer.sleep(0.1)
        end
    end
end
