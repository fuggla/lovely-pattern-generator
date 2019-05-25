log = require "lib.log"

function love.load()
  CIRCLE = 1
  RECTANGLE = 2

  rng = love.math.newRandomGenerator()
  rng:setSeed(os.time())
  local started = os.time()
  log.info("Generation: Started", started)
  log.info("seed:", rng:getSeed())

  pattern = {
    shape = rng:random(1, 2),
    amount = rng:random(1, 256),
    radius = rng:random(1, 64),
    width = rng:random(1, 64),
    height = rng:random(1, 64)
  }
  width, height = love.graphics.getDimensions()

  shapes = {}
  for i=1, pattern.amount, 1 do
    shapes[#shapes+1] = {
      x = rng:random(0, width),
      y = rng:random(0, height),
      r = rng:random(1, pattern.radius),
      w = rng:random(1, pattern.radius),
      h = rng:random(1, pattern.radius)
    }
  end

  log.info("shape: " .. pattern.shape)
  log.info("amount: " .. pattern.amount)
  log.info("radius: " .. pattern.radius)
  local completed = os.time() - started
  log.info("Generation: Completed in " .. completed + 1 .. " second(s)")
  print("---")
end

function love.draw()
  if pattern.shape == CIRCLE then
    circles()
  elseif pattern.shape == RECTANGLE then
    rectangles()
  end
end

function circles()
  for k, s in ipairs(shapes) do
    love.graphics.circle(
        "fill",
        s.x,
        s.y,
        s.r
    )
  end
end

function rectangles()
  for k, s in ipairs(shapes) do
    love.graphics.rectangle(
        "fill",
        s.x,
        s.y,
        s.w,
        s.h
    )
  end
end

function love.keypressed(key)
   if key == "escape" or key == "q" then
      love.event.quit()
    elseif key == "r" then
      love.load()
   end
end