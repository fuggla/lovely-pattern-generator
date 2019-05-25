log = require "lib.log"

function love.load()
  -- shape types
  CIRCLE = 1
  RECTANGLE = 2

  -- Generator setup
  rng = love.math.newRandomGenerator()
  rng:setSeed(os.time())
  local started = os.time()
  log.info("Generation: Started", started)
  log.info("seed:", rng:getSeed())

 -- Pattern base values
  pattern = {
    shape = rng:random(1, 2),
    amount = rng:random(1, 512),
    size = {
      min = 0,
      max = rng:random(1, 128)
    }
  }
  -- Since we now have a max size we can generate a min size
  pattern.size.min = rng:random(1, pattern.size.max)

  -- color base values
  color = {
    r = rng:random(0, 255),
    g = rng:random(0, 255),
    b = rng:random(0, 255)
  }

  -- Background grayscale
  bg = genColor(255)
  love.graphics.setBackgroundColor(bg ,bg ,bg)

  -- Pattern generation
  width, height = love.graphics.getDimensions()
  shapes = {}
  for i=1, pattern.amount, 1 do
    shapes[#shapes+1] = {
      x = rng:random(0, width),
      y = rng:random(0, height),
      r = rng:random(pattern.size.min, pattern.size.max),
      w = rng:random(pattern.size.min, pattern.size.max),
      h = rng:random(pattern.size.min, pattern.size.max),
      color = {
        genColor(255),
        genColor(255),
        genColor(255)
      }
    }
  end

  -- We're done here
  log.info("shape:", pattern.shape)
  log.info("amount:", pattern.amount)
  log.info("size:", pattern.size.min, ">", pattern.size.max)
  log.info("color:", color.r, color.g, color.b)
  local completed = os.time() - started
  log.info("Generation: Completed in ", completed + 1, "second(s)")
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
    love.graphics.setColor(s.color)
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
    love.graphics.setColor(s.color)
    love.graphics.rectangle(
        "fill",
        s.x - s.w / 2,
        s.y - s.h / 2,
        s.w,
        s.h
    )
  end
end

function love.keypressed(key)
   if key == "escape" or key == "q" then
      love.event.quit()
    elseif key == "r"  or key == "f5" then
      love.load()
   end
end

-- Generate an 8bit color
-- return it in löve color space
function genColor(max, min)
  min = min or 0
  return rng:random(min, max) / 255
end