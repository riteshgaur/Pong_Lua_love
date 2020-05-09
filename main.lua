-- Code while watching/learning CS50
-- most of the code is retyped from the videos I watched
-- of course, some part of the code has been modified to get things done as I wanted
-- Ritesh Gaur (RG)

-- Thanks Matthias Richter
-- https://github.com/vrld
Class = require "class"

-- Thanks Ulysse Ramage
push = require "push"

--to use Ball and Paddle Class
require "Ball"
require "Paddle"

--window frame of the game display
WINDOWS_WIDTH = 1200
WINDOWS_HEIGHT = 720

--virtual w and h of the game arena
v_width = 432
v_height = 243

--to display score
player1Score = 0
player2Score = 0

--serving player to start
serving_player = math.random(2) == 1 and 1 or 2

-- who wins
winning_player = 0
--game state
gameState = victory

--set winning score, player to reach to this score WINS
winning_score = 10

--ball speed (random so make it FUN)
ballspeed = 1

function love.load()
    --Set title of the window frame
    love.window.setTitle("Pong")
    gameState = "start"

    -- How fast/slow you want Paddles to mode up and down
    PADDLE_SPEED = 250

    -- randomize stuff (kind a)
    math.randomseed(os.time())

    --load an image
    -- RGnR = love.graphics.newImage("RGnR.png")

    --calling the constractors
    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(v_width - 10, v_height - 30, 5, 20)
    ball = Ball(v_width / 2 - 2, v_height / 2 - 2, 4, 4)

    if serving_player == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    -- I have no idea WTF we need this, avoid blur?
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- fonts, making it retro. Same Font: Different size
    smallFont = love.graphics.newFont("04B_03__.TTF", 15)
    scoreFont = love.graphics.newFont("04B_03__.TTF", 40)
    FPSFont = love.graphics.newFont("04B_03__.TTF", 10)

    --setup the winodw frame
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
    --load sounds
    scoreUpdate_sound = love.audio.newSource("wall_touch.wav", "stream")

    win_sound = love.audio.newSource("win.wav", "stream")
end

function love.update(dt)
    paddle1:update(dt)
    paddle2:update(dt)

    if ball:collides(paddle1) then
        ball.dx = -ball.dx * ballspeed
    end
    if ball:collides(paddle2) then
        ball.dx = -ball.dx * ballspeed
    end
    -- top
    if ball.y <= 0 then
        ball.dy = -ball.dy * ballspeed
    end
    --bottom
    if ball.y >= v_height - 4 then
        ball.dy = -ball.dy * ballspeed
        -- up speed after wall hit, 10 seem smother than 15
        ball.y = v_height - 10 * ballspeed
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

        if ball.x >= v_width - 4 then
            love.audio.play(scoreUpdate_sound)
            player1Score = player1Score + 1
            if player1Score >= 3 then
                ballspeed = math.random(3) == 1 and 1 or 2 or 3
            end

            serving_player = 1
            ball:reset()
            ball.dx = -100

            if player1Score == winning_score then
                winning_player = 1
                gameState = "victory"
            else
                gameState = "serve"
            end
        end

        if ball.x <= 0 then
            love.audio.play(scoreUpdate_sound)
            player2Score = player2Score + 1
            if player2Score >= 3 then
                ballspeed = math.random(2) == 1 and 1 or 2
            end

            serving_player = 2
            ball:reset()
            ball.dx = 100

            if player2Score == winning_score then
                winning_player = 2
                gameState = "victory"
            else
                gameState = "serve"
            end
        end
    end
end

function love.draw()
    push:apply("start")

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    if gameState == "start" then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome to Pong!", 100, 10, v_height, "center")
        love.graphics.printf("Press Enter to play", 100, 30, v_height, "center")
    elseif gameState == "serve" then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Player " .. tostring(serving_player) .. "'s turn", 100, 10, v_height, "center")
    elseif gameState == "victory" then
        --show victory msg
        love.graphics.setColor(0, 2, 1, 1)
        love.graphics.printf("Player " .. tostring(winning_player) .. "\n WIN", 100, 80, v_height, "center")

        love.graphics.setFont(smallFont)
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.printf("Press r to Reset", 100, 180, v_height, "center")
        love.graphics.printf("Press q to Quit", 100, 200, v_height, "center")
    -- elseif gameState == "play" then
    -- -- - no ui msg to display
    end

    paddle1:render()
    paddle2:render()
    ball:render()
    --displayFPS..da!
    displayFPS()

    --set and display score
    love.graphics.setColor(1, 1, 0, 1)
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
            gameState = "serve"
        elseif gameState == "victory" then
        elseif gameState == "serve" then
            gameState = "play"
        end
    end
    if key == "r" then
        gameState = "play"
        player1Score = 0
        player2Score = 0
    end
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(FPSFont)

    -- remember .. is to concatinate
    love.graphics.print("RGFPS:" .. tostring(love.timer.getFPS()), v_width /2, v_height - 10)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print("Speed:" .. tostring(ballspeed), v_width / 2.5, v_height - 10)
end
