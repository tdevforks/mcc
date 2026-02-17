-- CC:Tweaked script para requisitar design de construção ao OpenRouter

local API_KEY = "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"

if not http then
  error("HTTP desativado (http.enable = false)")
end

local body = {
  model = "google/gemini-2.0-flash-001",
  messages = {
    {
      role = "system",
      content = "Return ONLY valid JSON. No text. No markdown."
    },
    {
      role = "user",
      content = "Say hello in JSON format"
    }
  }
}

local headers = {
  ["Authorization"] = "Bearer " .. API_KEY,
  ["Content-Type"] = "application/json",
  ["User-Agent"] = "CC-Tweaked"
}

print("📡 Enviando request...")

local res = http.post(
  "https://openrouter.ai/api/v1/chat/completions",
  textutils.serializeJSON(body),
  headers
)

if not res then
  error("Falha HTTP")
end

local raw = res.readAll()
local code = res.getResponseCode()
res.close()

if code ~= 200 then
  error("HTTP " .. code .. "\n" .. raw)
end

local parsed = textutils.unserializeJSON(raw)
if not parsed or not parsed.choices then
  error("Resposta inválida")
end

local content = parsed.choices[1].message.content
print("📦 Resposta da IA:")
print(content)

local ok, json = pcall(textutils.unserializeJSON, content)
if not ok then
  error("Conteúdo não é JSON")
end

local f = fs.open("design.json", "w")
f.write(textutils.serializeJSON(json))
f.close()

print("✅ Salvo em design.json")