
WINDOWS_WIDTH=1200
WINDOWS_HEIGHT = 720

v_width = 432
v_height = 243
push = require 'push'

function love.load()
math.randomseed(os.time())
RGnR = love.graphics.newImage("RGnR.png")

sound = love.audio.newSource("bck_sound.ogg", "stream")


love.graphics.setDefaultFilter('nearest', 'nearest')
 smallFont = love.graphics.newFont('04B_03__.TTF', 20) --for hello
 scoreFont = love.graphics.newFont('04B_03__.TTF', 40) --for score
 
player1 = 0;
player2 = 0;

player1Y = 30
player2Y = v_height - 40

ball_x = v_width/2-2
ball_y = v_height/2-2

ballDX = math.random(2) == 1 and -100 or 100
ballDY = math.random(-50, 50)


gameState = 'start'



PADDEL_SPEED = 200


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
        player1Y  = math.max(0, player1Y - PADDEL_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y  = math.min(v_height -20, player1Y + PADDEL_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
     player2Y  = math.max(0, player2Y - PADDEL_SPEED * dt)

    elseif love.keyboard.isDown('down') then
        player2Y  = math.min(v_height -20, player2Y + PADDEL_SPEED * dt)
    end


    if gameState == 'play' then
        ball_x = ball_x + ballDX *dt
        ball_y = ball_y + ballDY *dt
        
    end

end






function love.draw()
    
    push:apply('start')

    love.graphics.clear(40/255,45/255,52/255,255/255)

    --ball
    love.graphics.rectangle('fill', ball_x,ball_y, 5,5)
    
    --left bar
    love.graphics.rectangle('fill', 5,player1Y,5,20)
    -- right bar
    love.graphics.rectangle('fill', v_width -10,player2Y,5,20) 
    
    love.graphics.setFont(smallFont) --use small 
    if gameState=='start' then 
        love.graphics.printf('Start', 15, 20,v_width,'center')
        love.graphics.draw(RGnR, 200, 100)
        love.audio.stop()
    elseif gameState == 'play' then
        love.graphics.printf('Play well!', 15, 20,v_width,'center')
        love.audio.play(sound)
    end

  
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1, v_width/2 - 50,v_height/5)
    love.graphics.print(player2,v_width/2 + 50,v_height/5)

    push:apply('end')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
        --love.sound.beep()

    elseif key == 'enter' or key == 'return' then

        if gameState == 'start' then

            gameState = 'play'
         elseif gameState ==  'play' then
            gameState = 'start'
         end

    end  
end
