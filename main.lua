-- CC:Tweaked script para requisitar design de construção ao OpenRouter
local OPENROUTER_API_KEY = "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"

local SYSTEM_PROMPT = [[You are a system that designs Minecraft Turtle constructions.

RULES (MANDATORY):
- Output ONLY valid JSON
- Do NOT include explanations
- Do NOT include markdown
- Do NOT include comments
- Do NOT include extra keys
- The response MUST strictly follow the JSON PATTERN below
- All arrays must be rectangular
- All values must be integers or strings as defined

PATTERN:
{
  "metadata": {
    "name": "string",
    "author": "string",
    "size": { "x": number, "y": number, "z": number },
    "origin": "center",
    "layers": number
  },
  "palette": {
    "0": "minecraft:air",
    "1": "minecraft:stone",
    "2": "minecraft:glass",
    "3": "minecraft:glowstone"
  },
  "build": [
    {
      "y": number,
      "rows": [
        [0,1,2,3]
      ]
    }
  ]
}

CONSTRAINTS:
- Max size: 9x9x9
- Build must be symmetric and visually impressive
- Build must be constructible layer-by-layer along Y axis
- Use glowstone sparingly for highlights only
]]

local USER_PROMPT = "Design a futuristic 3D geometric symbol suitable as a tech logo. Clean, hollow, symmetric, visually impressive when built step by step."

local request_body = {
  model = "google/gemini-2.0-flash-001",
  messages = {
    {
      role = "system",
      content = SYSTEM_PROMPT
    },
    {
      role = "user",
      content = USER_PROMPT
    }
  }
}
local request_json = textutils.serialiseJSON(request_body)

local headers = {
  ["Authorization"] = "Bearer " .. OPENROUTER_API_KEY,
  ["Content-Type"] = "application/json"
}

-- Requisição HTTP
print("Enviando requisição ao OpenRouter...")
local response = http.post(
  "https://openrouter.ai/api/v1/chat/completions",
  request_json,
  headers
)

if response then
  local response_text = response.readAll()
  response.close()
  
  local response_json = textutils.unserialiseJSON(response_text)
  
  if response_json and response_json.choices and response_json.choices[1] then
    local design = response_json.choices[1].message.content
    print("\nDesign recebido:")
    print(design)
    
    -- Tenta decodificar o design como JSON
    local success, design_json = pcall(textutils.unserialiseJSON, design)
    if success then
      print("\nDesign parseado com sucesso!")
      -- Salva em arquivo
      local f = fs.open("design.json", "w")
      f.write(textutils.serialiseJSON(design_json))
      f.close()
      print("Salvo em design.json")
    else
      print("Aviso: Design não é JSON válido")
    end
  else
    print("Erro: Resposta inválida")
    print(response_text)
  end
else
  print("Erro: Falha na requisição HTTP")
end