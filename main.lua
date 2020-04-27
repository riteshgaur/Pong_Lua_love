
WINDOWS_WIDTH=1200
WINDOWS_HEIGHT = 720

v_width = 432
v_height = 243
push = require 'push'

function love.load()
love.graphics.setDefaultFilter('nearest', 'nearest')
 smallFont = love.graphics.newFont('04B_03__.TTF', 20)
 scoreFont = love.graphics.newFont('04B_03__.TTF', 80)
 
player1 = 0;
player2 = 0;

player1Y = 30
player2Y = v_height - 40



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


function love.update(dt)
if love.keyboard.isDown('w') then

elseif love.keyboard.isDown('s') then
end
if love.keyboard.isDown('up') then
elseif love.keyboard.isDown('down') then
end

end




function love.draw()
    push:apply('start')

    love.graphics.clear(40/255,45/255,52/255,255/255)
    --ball
    love.graphics.rectangle('fill', v_width/2-2,v_height/2-2, 5,5)
    
    --left bar
    love.graphics.rectangle('fill', 5,player1Y,5,20)
    -- right bar
    love.graphics.rectangle('fill', v_width -10,player2Y,5,20) 

    love.graphics.printf('Hello World', 0, 20,v_width,'center')
    love.graphics.setFont(smallFont)
    love.graphics.print(player1, v_width/2 -50,v_height/3)
    love.graphics.print(player2,v_width/2 + 50,v_height/3)

    push:apply('end')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
        --love.sound.beep()
    end
end
