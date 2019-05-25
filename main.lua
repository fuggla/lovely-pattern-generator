function love.load()
  rng = love.math.newRandomGenerator( )
  rng:setSeed(os.time())
  pattern = {
    order = rng:random(1, 1),
    amount = rng:random(1, 100),
    radius = rng:random(1, 100)
  }
  width, height = love.graphics.getDimensions()
  shapes = {}
  for i=1, pattern.amount, 1 do
    shapes[#shapes+1] = {
      x = rng:random(0, width),
      y = rng:random(0, height),
      r = rng:random(1, pattern.radius)
    }
    print(shapes[#shapes].x, shapes[#shapes].y, shapes[#shapes].r)
  end
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