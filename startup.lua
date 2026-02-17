local URL = "https://raw.githubusercontent.com/tdevforks/mcc/main/main.lua"
local FILE = "main.lua"

print("🔄 Atualizando...")

if fs.exists(FILE) then
    fs.delete(FILE)
end

local res = http.get(URL)
if not res then
    print("❌ Falha de rede")
    return
end

local f = fs.open(FILE, "w")
f.write(res.readAll())
f.close()
res.close()

print("✅ Atualizado")
sleep(0.5)

shell.run(FILE)
