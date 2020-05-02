Class = require "class"
push = require "push"

require "Ball"
require "Paddle"

WINDOWS_WIDTH = 1200
WINDOWS_HEIGHT = 720

v_width = 432
v_height = 243

player1Score = 0
player2Score = 0

function love.load()
    love.window.setTitle("Pong")
    gameState = "start"
    PADDLE_SPEED = 250

    -- randomize stuff (kind a)
    math.randomseed(os.time())

    --load an image
    -- RGnR = love.graphics.newImage("RGnR.png")

    --calling the constractor
    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(v_width - 10, v_height - 30, 5, 20)

    ball = Ball(v_width / 2 - 2, v_height / 2 - 2, 4, 4)

    love.graphics.setDefaultFilter("nearest", "nearest")

    smallFont = love.graphics.newFont("04B_03__.TTF", 20) --for hello
    scoreFont = love.graphics.newFont("04B_03__.TTF", 40) --for score
    FPSFont = love.graphics.newFont("04B_03__.TTF", 10) --for score

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
    --load sound
    scoreUpdate_sound = love.audio.newSource("wall_touch.wav", "stream")
end

function love.update(dt)
    paddle1:update(dt)
    paddle2:update(dt)

    if ball:collides(paddle1) then
        ball.dx = -ball.x *0.5
    end
    if ball:collides(paddle2) then
        ball.dx = -ball.dx *1
    end

    if ball.y <= 0 then
        ball.dy = -ball.dx
    end

    if ball.y >= v_height - 2 then
        ball.dx = -ball.x 
        ball.y = v_height

    end

    if love.keyboard.isDown("w") then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("s") then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if love.keyboard.isDown("up") then
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("down") then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end

    if gameState == "play" then
        ball:update(dt)

        if ball.x <= 0 then
            love.audio.play(scoreUpdate_sound)
            player2Score = player2Score + 1
            ball:reset()
            gameState = "start"
        end

        if ball.x >= v_width - 4 then
            love.audio.play(scoreUpdate_sound)
            player1Score = player1Score + 1
            ball:reset()
            gameState = "start"
        end
    end
end


function love.draw()
    push:apply("start")

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    love.graphics.setFont(smallFont) 

    paddle1:render()
    paddle2:render()
    ball:render()
    displayFPS()

    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), v_width / 2 - 50, v_height / 5)
    love.graphics.print(tostring(player2Score), v_width / 2 + 50, v_height / 5)

    push:apply("end")
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
            gameState = "play"
        end
    end
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(FPSFont)
    -- remember .. is to concatinate
    love.graphics.print("FPS:" .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end
