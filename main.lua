Class = require "class"
push = require "push"

require "Ball"
require "Paddle"

WINDOWS_WIDTH = 1200
WINDOWS_HEIGHT = 720

v_width = 432
v_height = 243

function love.load()
    love.window.setTitle("Pong")
    gameState = "start"
    PADDLE_SPEED = 200

    -- randomize stuff (kind a)
    math.randomseed(os.time())

    --load an image
    RGnR = love.graphics.newImage("RGnR.png")

    --calling the constractor
    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(v_width - 10, v_height - 30, 5, 20)

    ball = Ball(v_width / 2 - 2, v_height / 2 - 2, 4, 4)

    --load sound
    --sound = love.audio.newSource("bck_sound.ogg", "stream")

    love.graphics.setDefaultFilter("nearest", "nearest")

    smallFont = love.graphics.newFont("04B_03__.TTF", 20) --for hello
    scoreFont = love.graphics.newFont("04B_03__.TTF", 40) --for score
    FPSFont = love.graphics.newFont("04B_03__.TTF", 10) --for score

    player1Y = 30
    player2Y = v_height - 40

    push:setupScreen(
        v_width,
        v_height,
        WINDOWS_WIDTH,
        WINDOWS_HEIGHT,
        {
            fullscreen = false,
            vsync = true,
            resizable = false
        }
    ) 
end

function love.update(dt)
    paddle1:update(dt)
    paddle2:update(dt)

    if ball:collides(paddle1) then
        ball.dx = - ball.x
    end
    if ball:collides(paddle2) then
        ball.dx = - ball.dx
    end

    if ball.y <= 0 then
        ball.dy = - ball.dx
    end

    if ball.y >= v_height - 4 then
        ball.dy = - ball.y
        ball.y = v_height - 4
    end

    if love.keyboard.isDown("w") then
        --player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("s") then
        --player1Y = math.min(v_height - 20, player1Y + PADDLE_SPEED * dt)
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if love.keyboard.isDown("up") then
        -- player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("down") then
        -- player2Y = math.min(v_height - 20, player2Y + PADDLE_SPEED * dt)
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end

    if gameState == "play" then
        ball:update(dt)
    end
end
function love.draw()
    push:apply("start")

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    love.graphics.setFont(smallFont) --use small
    if gameState == "start" then
        love.graphics.printf("Start", 15, 20, v_width, "center")
        love.graphics.draw(RGnR, 200, 100)
       -- love.audio.stop()
    elseif gameState == "play" then
        love.graphics.printf("Play well!", 15, 20, v_width, "center")
       -- love.audio.play(sound)
    end

    paddle1:render()
    paddle2:render()
    ball:render()
    displayFPS()

    --left bar
    -- love.graphics.rectangle('fill', 5,player1Y,5,20)
    -- right bar
    -- love.graphics.rectangle('fill', v_width -10,player2Y,5,20)

    love.graphics.setFont(scoreFont)
    love.graphics.print(paddle1, v_width / 2 - 50, v_height / 5)
    love.graphics.print(paddle2, v_width / 2 + 50, v_height / 5)

    push:apply("end")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
            gameState = "play"
        elseif gameState == "play" then
            gameState = "start"
            -- ball_x = v_width / 2 - 2
            -- ball_y = v_height / 2 - 2
            ball:reset()
        end
    end
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(FPSFont)
    love.graphics.print("FPS:" .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end
