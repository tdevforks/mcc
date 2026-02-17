-- =========================
-- ESPIRAL 3D - TURTLE
-- Usa apenas o slot 1
-- =========================

local HEIGHT = 12      -- altura da espiral
local STEP = 1         -- blocos por passo

turtle.select(1)

local function place()
  while not turtle.placeDown() do
    turtle.digDown()
    sleep(0.2)
  end
end

print("🌀 Construindo espiral 3D...")

for y = 1, HEIGHT do
  place()

  turtle.forward()
  turtle.turnRight()

  if y % 2 == 0 then
    turtle.forward()
  end

  turtle.up()
end

print("✅ Espiral concluída")
