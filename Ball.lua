Ball = Class {}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:reset()
    self.x = v_width / 2 - 2
    self.y = v_height / 2 - 2

    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50) * 1.5
end

function Ball:render()
    --ball
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, 4, 4)

    return true
end

function Ball:collides(box)
   --load sound
    paddel_touch_sound = love.audio.newSource("paddel_touch.wav", "stream")

    if self.x > box.x + box.height or self.x + self.width < box.x then
       
        return false
    end
    if self.y > box.y + box.height or self.y + self.width < box.y then
      
        return false
    end

    -- if collition, play sound, this may not be the best way but let's go with this for now
    love.audio.play(paddel_touch_sound)
    return true
end
