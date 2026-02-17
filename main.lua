-----------------------------
-- CONFIGURAÇÃO DO TEXTO --
-----------------------------

local TEXT = "ALFACE"
local HEIGHT = 5        -- altura das letras
local DEPTH = 2         -- profundidade 3D
local SPACING = 1       -- espaço entre letras
local BLOCK = "minecraft:stone"

-----------------------------
-- FONTE 5x5 SIMPLES ------
-----------------------------

local FONT = {
  A = {
    " 1 ",
    "1 1",
    "111",
    "1 1",
    "1 1",
  },
  L = {
    "1  ",
    "1  ",
    "1  ",
    "1  ",
    "111",
  },
  F = {
    "111",
    "1  ",
    "111",
    "1  ",
    "1  ",
  },
  C = {
    " 11",
    "1  ",
    "1  ",
    "1  ",
    " 11",
  },
  E = {
    "111",
    "1  ",
    "111",
    "1  ",
    "111",
  }
}

-----------------------------
-- FUNÇÕES BÁSICAS --------
-----------------------------

local function place()
  while not turtle.placeDown() do
    turtle.digDown()
    sleep(0.2)
  end
end

local function forward()
  while not turtle.forward() do
    turtle.dig()
    sleep(0.2)
  end
end

-----------------------------
-- CONSTRÓI UMA LETRA -----
-----------------------------

local function buildLetter(pattern)
  for z = 1, DEPTH do
    for y = HEIGHT, 1, -1 do
      local row = pattern[HEIGHT - y + 1]
      for x = 1, #row do
        if row:sub(x, x) == "1" then
          place()
        end
        forward()
      end

      turtle.back()
      turtle.back()
      turtle.back()
      turtle.up()
    end

    for _ = 1, HEIGHT do turtle.down() end
    turtle.turnRight()
    forward()
    turtle.turnLeft()
  end

  turtle.turnLeft()
  for _ = 1, DEPTH do forward() end
  turtle.turnRight()

  for _ = 1, SPACING do forward() end
end

-----------------------------
-- PROGRAMA PRINCIPAL -----
-----------------------------

print("🏗️ Construindo texto 3D:", TEXT)

for i = 1, #TEXT do
  local char = TEXT:sub(i, i)
  local letter = FONT[char]

  if letter then
    buildLetter(letter)
  else
    print("⚠️ Letra não suportada:", char)
    for _ = 1, 4 + SPACING do forward() end
  end
end

print("✅ Texto 3D finalizado")
