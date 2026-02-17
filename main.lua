OPENROUTER_API_KEY=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

curl https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "google/gemini-2.0-flash-001",
    "messages": [
      {
        "role": "system",
        "content": "You are a system that designs Minecraft Turtle constructions.\n\nRULES (MANDATORY):\n- Output ONLY valid JSON\n- Do NOT include explanations\n- Do NOT include markdown\n- Do NOT include comments\n- Do NOT include extra keys\n- The response MUST strictly follow the JSON PATTERN below\n- All arrays must be rectangular\n- All values must be integers or strings as defined\n\nPATTERN:\n{\n  \"metadata\": {\n    \"name\": \"string\",\n    \"author\": \"string\",\n    \"size\": { \"x\": number, \"y\": number, \"z\": number },\n    \"origin\": \"center\",\n    \"layers\": number\n  },\n  \"palette\": {\n    \"0\": \"minecraft:air\",\n    \"1\": \"minecraft:stone\",\n    \"2\": \"minecraft:glass\",\n    \"3\": \"minecraft:glowstone\"\n  },\n  \"build\": [\n    {\n      \"y\": number,\n      \"rows\": [\n        [0,1,2,3]\n      ]\n    }\n  ]\n}\n\nCONSTRAINTS:\n- Max size: 9x9x9\n- Build must be symmetric and visually impressive\n- Build must be constructible layer-by-layer along Y axis\n- Use glowstone sparingly for highlights only\n"
      },
      {
        "role": "user",
        "content": "Design a futuristic 3D geometric symbol suitable as a tech logo. Clean, hollow, symmetric, visually impressive when built step by step."
      }
    ]
  }'