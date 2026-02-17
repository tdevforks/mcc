-- CC:Tweaked script para requisitar design de construção ao OpenRouter

local OPENROUTER_API_KEY = "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" -- coloque sua key aqui

if not http then
  error("HTTP API desativada (http.enable = false)")
end

local request_body = {
  model = "google/gemini-2.0-flash-001",
  messages = {
    {
      role = "system",
      content = table.concat({
        "You are a system that designs Minecraft Turtle constructions.",
        "",
        "RULES (MANDATORY):",
        "- Output ONLY valid JSON",
        "- Do NOT include explanations",
        "- Do NOT include markdown",
        "- Do NOT include comments",
        "- Do NOT include extra keys",
        "- The response MUST strictly follow the JSON PATTERN below",
        "- All arrays must be rectangular",
        "- All values must be integers or strings as defined",
        "",
        "PATTERN:",
        "{",
        '  "metadata": {',
        '    "name": "string",',
        '    "author": "string",',
        '    "size": { "x": number, "y": number, "z": number },',
        '    "origin": "center",',
        '    "layers": number',
        "  },",
        '  "palette": {',
        '    "0": "minecraft:air",',
        '    "1": "minecraft:stone",',
        '    "2": "minecraft:glass",',
        '    "3": "minecraft:glowstone"',
        "  },",
        '  "build": [',
        "    {",
        '      "y": number,',
        '      "rows": [[0,1,2,3]]',
        "    }",
        "  ]",
        "}",
        "",
        "CONSTRAINTS:",
        "- Max size: 9x9x9",
        "- Build must be symmetric and visually impressive",
        "- Build must be constructible layer-by-layer along Y axis",
        "- Use glowstone sparingly for highlights only"
      }, "\n")
    },
    {
      role = "user",
      content = "Design a futuristic 3D geometric symbol suitable as a tech logo. Clean, hollow, symmetric, visually impressive when built step by step."
    }
  }
}

local request_json = textutils.serializeJSON(request_body)

local headers = {
  ["Authorization"] = "Bearer " .. OPENROUTER_API_KEY,
  ["Content-Type"]  = "application/json",
  ["User-Agent"]    = "CC-Tweaked-Turtle/1.0"
}

print("📡 Enviando requisição ao OpenRouter...")

local ok, response = pcall(http.post,
  "https://openrouter.ai/api/v1/chat/completions",
  request_json,
  headers
)

if not ok or not response then
  error("Falha na requisição HTTP")
end

local response_text = response.readAll()
local status = response.getResponseCode()
response.close()

if status ~= 200 then
  error("Erro HTTP " .. status .. "\n" .. response_text)
end

local response_json = textutils.unserializeJSON(response_text)
if not response_json
  or not response_json.choices
  or not response_json.choices[1]
  or not response_json.choices[1].message
  or type(response_json.choices[1].message.content) ~= "string"
then
  error("Resposta inválida do OpenRouter")
end

local design_text = response_json.choices[1].message.content
print("📦 Design recebido da IA")

-- Tenta parsear o JSON do design
local success, design_json = pcall(textutils.unserializeJSON, design_text)
if not success or type(design_json) ~= "table" then
  error("Design retornado não é JSON válido")
end

-- Salva o blueprint
local f = fs.open("design.json", "w")
f.write(textutils.serializeJSON(design_json))
f.close()

print("✅ Blueprint salvo em design.json")
print("🏗️ Pronto para construção")
