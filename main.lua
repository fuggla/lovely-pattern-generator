local log = require "lib.log"
local moonshine = require 'lib.moonshine'
local draw = {}
local gen = {}

function love.load()
  -- shape types
  CIRCLE = 1
  RECTANGLE = 2
  RANDOM = 1
  CENTER = 2

  -- Generator setup
  rng = love.math.newRandomGenerator()
  rng:setSeed(os.time())
  local started = os.time()
  log.info("Generation: Started", started)
  log.info("seed:", rng:getSeed())

  -- Background grayscale
  local bg = gen.color(255)
  love.graphics.setBackgroundColor(bg ,bg ,bg)

 -- Base values
  local base = gen.base("random")
  shape = base.shape

  -- Generate shapes using base values
  shapes = gen.shapes(base)

  -- Setup post-processing
  effect = gen.effect(18)

  -- We're done here
  log.info("shape:", base.shape)
  log.info("amount:", base.amount)
  log.info("size:", base.size.min, ">", base.size.max)
  log.info("color:", base.color.r, base.color.g, base.color.b)
  local completed = os.time() - started
  log.info("Generation: Completed in ", completed + 1, "second(s)")
  print("---")
end

function love.draw()
  if effect then
    effect(function()
      if shape == CIRCLE then
        draw.circles()
      elseif shape == RECTANGLE then
        draw.rectangles()
      end
    end)
  else
      if shape == CIRCLE then
      draw.circles()
    elseif shape == RECTANGLE then
      draw.rectangles()
    end
  end
end

function draw.circles()
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

function draw.rectangles()
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
function gen.color(min, max)
  if not max then
    max = min
    min = 0
  end
  return rng:random(min, max) / 255
end

-- Generate base values for shape generation
function gen.base(name)
  local base = {}
  if name == "random" then
    base = {
      shape = rng:random(1, 2),
      amount = rng:random(1, 512),
      size = {
        min = 0,
        max = rng:random(1, 128)
      },
      color = {
        r = rng:random(0, 255),
        g = rng:random(0, 255),
        b = rng:random(0, 255)
      }
    }
    -- Since we now have a max size we can generate a min size
    base.size.min = rng:random(1, base.size.max)
  end
  return base
end

-- Generate shapes using table of base values
function gen.shapes(base)
  local shapes = {}
  local window = {}
  local spread = rng:random(1, 2)
  log.info("spread:", spread)

  -- Shapes a spread out in a random fashion
  window.w, window.h = love.graphics.getDimensions()
  if spread == RANDOM then
    for i=1, base.amount, 1 do
      shapes[#shapes+1] = {
        x = rng:random(0, window.w),
        y = rng:random(0, window.h),
        r = rng:random(base.size.min, base.size.max),
        w = rng:random(base.size.min, base.size.max),
        h = rng:random(base.size.min, base.size.max),
        color = {
          gen.color(base.color.r),
          gen.color(base.color.g),
          gen.color(base.color.b)
        }
      }
    end
  elseif spread == CENTER then
    local center = rng:random(5, 50) / 100
    log.info("center:", center * 100 .. "%")
    for i=1, base.amount, 1 do
      shapes[#shapes+1] = {
        x = rng:random(window.w * center, window.w * (1 - center)),
        y = rng:random(window.h * center, window.h * (1 - center)),
        r = rng:random(base.size.min, base.size.max),
        w = rng:random(base.size.min, base.size.max),
        h = rng:random(base.size.min, base.size.max),
        color = {
          gen.color(base.color.r),
          gen.color(base.color.g),
          gen.color(base.color.b)
        }
      }
    end
  end
  return shapes
end

function gen.effect(chance)
  local effect = false
  local name = "none"
  chance = rng:random(chance)
  if chance == 1 then
    effect = moonshine(moonshine.effects.desaturate)
    name = "desaturate"
  elseif chance == 2 then
    effect = moonshine(moonshine.effects.glow)
    name = "glow"
  elseif chance == 3 then
    effect = moonshine(moonshine.effects.godsray)
    name = "godsray"
  elseif chance == 4 then
    effect = moonshine(moonshine.effects.vignette)
    name = "vignette"
  end
  log.info("effect:", name)
  return effect
end