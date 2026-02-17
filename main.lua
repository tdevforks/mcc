-- CC:Tweaked script para requisitar design de construção ao OpenRouter

local key = "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"

if not http then
  error("HTTP desativado")
end

local body = textutils.serializeJSON({
  model = "google/gemini-2.0-flash-001",
  messages = {
    { role = "user", content = "ping" }
  }
})

local res, err = http.post(
  "https://openrouter.ai/api/v1/chat/completions",
  body,
  {
    ["Authorization"] = "Bearer " .. key,
    ["Content-Type"]  = "application/json",
    ["HTTP-Referer"]  = "http://localhost",
    ["X-Title"]       = "CC-Tweaked Test"
  }
)

if not res then
  error("Falha HTTP: " .. tostring(err))
end

print("Status:", res.getResponseCode())
print(res.readAll())
res.close()