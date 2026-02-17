-------------------
-- CONFIGURAÇÃO --
-------------------

local TEXT = "ALFACE"
local DEPTH = 2
local SPACING = 1
local BLOCK_SLOT = 1

-------------------
-- FONTE 5x5 -----
-------------------

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

-------------------
-- HELPERS ------
-------------------

turtle.select(BLOCK_SLOT)

local function place()
  while not turtle.place() do
    turtle.dig()
    sleep(0.1)
  end
end

local function forward()
  while not turtle.forward() do
    turtle.dig()
    sleep(0.1)
  end
end

-------------------
-- LETRA --------
-------------------

local function buildLetter(pattern)
  for z = 1, DEPTH do
    for y = 1, #pattern do
      local row = pattern[y]
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

    for _ = 1, #pattern do turtle.down() end
    turtle.turnRight()
    forward()
    turtle.turnLeft()
  end

  turtle.turnLeft()
  for _ = 1, DEPTH do forward() end
  turtle.turnRight()

  for _ = 1, SPACING do forward() end
end

-------------------
-- MAIN ----------
-------------------

print("🏗️ Construindo texto 3D:", TEXT)

for i = 1, #TEXT do
  local c = TEXT:sub(i, i)
  local letter = FONT[c]

  if letter then
    buildLetter(letter)
  else
    print("Letra não suportada:", c)
    forward()
  end
end

print("✅ Finalizado")
