if not http then
  error("HTTP API desativada no servidor")
end

local domains = {
  -- clássicos do CC
  "https://pastebin.com",
  "https://raw.githubusercontent.com",
  "https://github.com",
  "https://api.github.com",

  -- genéricos
  "https://example.com",
  "https://httpbin.org",

  -- cloud / apis comuns
  "https://jsonplaceholder.typicode.com",
  "https://api.ipify.org",

  -- IA / APIs modernas (normalmente BLOQUEADAS)
  "https://openrouter.ai",
  "https://api.openai.com",
  "https://generativelanguage.googleapis.com",

  -- outros
  "https://thomasdev.xyz",
  "https://cdn.jsdelivr.net",
  "https://unpkg.com",
  "https://paste.ee",
  "https://gist.githubusercontent.com"
}

print("🔎 Testando domínios HTTP permitidos\n")

for _, url in ipairs(domains) do
  local ok, err = http.checkURL(url)

  if ok then
    print("✅ PERMITIDO  ", url)
  else
    print("❌ BLOQUEADO  ", url)
    if err then
      print("   ↳ motivo:", err)
    end
  end

  sleep(0.2) -- evita spam
end

print("\n🏁 Teste finalizado")
