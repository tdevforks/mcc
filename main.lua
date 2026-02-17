local json = require("cjson")
local http = require("socket.http")
local ltn12 = require("ltn12")

local OPENROUTER_API_KEY = "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"

local request_body = {
  model = "google/gemini-2.0-flash-001",
  messages = {
    {
      role = "system",
      content = [[You are a system that designs Minecraft Turtle constructions.

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
- Use glowstone sparingly for highlights only]]
    },
    {
      role = "user",
      content = "Design a futuristic 3D geometric symbol suitable as a tech logo. Clean, hollow, symmetric, visually impressive when built step by step."
    }
  }
}

local response_body = {}
local headers = {
  ["Authorization"] = "Bearer " .. OPENROUTER_API_KEY,
  ["Content-Type"] = "application/json",
  ["Content-Length"] = #json.encode(request_body)
}

local response_code, response_headers, response_status = http.request {
  url = "https://openrouter.ai/api/v1/chat/completions",
  method = "POST",
  headers = headers,
  source = ltn12.source.string(json.encode(request_body)),
  sink = ltn12.sink.table(response_body)
}

if response_code == 200 then
  local response_text = table.concat(response_body)
  local response_json = json.decode(response_text)
  
  if response_json and response_json.choices and response_json.choices[1] then
    local design = response_json.choices[1].message.content
    print("Design Response:")
    print(design)
    
    -- Try to decode the design as JSON if it's valid
    local success, design_json = pcall(json.decode, design)
    if success then
      print("\nParsed Design:")
      print(json.encode(design_json, { indent = true }))
    end
  end
else
  print("Error: HTTP " .. response_code)
  print(table.concat(response_body))
end