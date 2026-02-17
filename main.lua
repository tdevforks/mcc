-- CC:Tweaked script para requisitar design de construção ao OpenRouter

local OPENROUTER_API_KEY = "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"

-- Função para debug
local function debug_error(title, details)
  print("\n" .. string.rep("=", 50))
  print("❌ ERRO: " .. title)
  print(string.rep("=", 50))
  if type(details) == "table" then
    for k, v in pairs(details) do
      print("  " .. k .. ": " .. tostring(v))
    end
  else
    print("  " .. tostring(details))
  end
  print(string.rep("=", 50) .. "\n")
end

if not http then
  debug_error("HTTP API", "HTTP não está habilitado (http.enable = false no config)")
  error("HTTP API desativada")
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

if not ok then
  debug_error("Erro ao fazer requisição HTTP", {
    ["mensagem"] = response,
    ["status_ok"] = tostring(ok)
  })
  error("Requisição HTTP falhou")
end

if not response then
  debug_error("Resposta vazia do servidor", {
    ["response_obj"] = tostring(response)
  })
  error("Falha na requisição HTTP")
end

local response_text = response.readAll()
local status = response.getResponseCode()
response.close()

if status ~= 200 then
  debug_error("Erro HTTP do OpenRouter", {
    ["status_code"] = status,
    ["resposta"] = response_text:sub(1, 500) -- primeiros 500 chars
  })
  error("Erro HTTP " .. status)
end

local response_json = textutils.unserializeJSON(response_text)
if not response_json then
  debug_error("Resposta não é JSON válido", {
    ["status"] = status,
    ["resposta_raw"] = response_text:sub(1, 500)
  })
  error("Resposta inválida do OpenRouter")
end

if not response_json.choices or not response_json.choices[1] then
  debug_error("Estrutura de choices inválida", {
    ["keys"] = table.concat(type(response_json) == "table" and not not next or {}, ", "),
    ["response"] = textutils.serializeJSON(response_json):sub(1, 300)
  })
  error("Resposta inválida do OpenRouter")
end

if not response_json.choices[1].message then
  debug_error("Message não encontrada na resposta", {
    ["choice_1_keys"] = textutils.serializeJSON(response_json.choices[1]):sub(1, 300)
  })
  error("Resposta inválida do OpenRouter")
end

if type(response_json.choices[1].message.content) ~= "string" then
  debug_error("Content não é string", {
    ["content_type"] = type(response_json.choices[1].message.content),
    ["content"] = tostring(response_json.choices[1].message.content):sub(1, 300)
  })
  error("Resposta inválida do OpenRouter")
end

local design_text = response_json.choices[1].message.content
print("📦 Design recebido da IA")

-- Tenta parsear o JSON do design
local success, design_json = pcall(textutils.unserializeJSON, design_text)
if not success then
  debug_error("Erro ao parsear design JSON", {
    ["erro"] = tostring(design_json),
    ["design_text_amostra"] = design_text:sub(1, 500)
  })
  error("Design retornado não é JSON válido")
end

if type(design_json) ~= "table" then
  debug_error("Design não é uma tabela", {
    ["tipo"] = type(design_json),
    ["valor"] = tostring(design_json):sub(1, 500)
  })
  error("Design retornado não é JSON válido")
end

-- Salva o blueprint
local f, err = fs.open("design.json", "w")
if not f then
  debug_error("Erro ao abrir arquivo design.json", {
    ["erro"] = tostring(err),
    ["modo"] = "write"
  })
  error("Não foi possível criar design.json")
end

local write_ok, write_err = pcall(f.write, textutils.serializeJSON(design_json))
f.close()

if not write_ok then
  debug_error("Erro ao escrever em design.json", {
    ["erro"] = tostring(write_err)
  })
  error("Erro ao salvar blueprint")
end

print("✅ Blueprint salvo em design.json")
print("🏗️ Pronto para construção")
