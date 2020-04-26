
WINDOWS_WIDTH=1200
WINDOWS_HEIGHT = 720

v_width = 432
v_height = 243
push = require 'push'

function love.load()
love.graphics.setDefaultFilter('nearest', 'nearest')
    push: setupScreen(v_width,v_height,WINDOWS_WIDTH,WINDOWS_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable= false

    })

-- love.window.setMode(WINDOWS_WIDTH,WINDOWS_HEIGHT,{
--     fullscreen = false,
--     vsync = true,
--     resizable= false
-- })
end

function love.draw()
    push:apply('start')

    love.graphics.printf('Hello World', 0, v_height/2 -6,v_width,'center')

    push:apply('end')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
        --love.sound.beep()
    end
end
