log = require "lib.log"

function love.load()
  rng = love.math.newRandomGenerator( )
  rng:setSeed(os.time())
  pattern = {
    shape = rng:random(1, 1),
    amount = rng:random(1, 256),
    radius = rng:random(1, 64)
  }
  width, height = love.graphics.getDimensions()
  shapes = {}
  for i=1, pattern.amount, 1 do
    shapes[#shapes+1] = {
      x = rng:random(0, width),
      y = rng:random(0, height),
      r = rng:random(1, pattern.radius)
    }
  end

  log.info("shape: " .. pattern.shape)
  log.info("amount: " .. pattern.amount)
  log.info("radius: " .. pattern.radius)
end

function love.draw()
  for k, s in ipairs(shapes) do
    love.graphics.circle(
        "fill",
        s.x,
        s.y,
        s.r
    )
  end
end