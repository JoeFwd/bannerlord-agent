---
name: bannerlord-source-mcp-1_4_6-workaround
description: When several Bannerlord source-search MCP servers (one per game version) are configured but only the oldest registers as a tool, reach the others by POSTing JSON-RPC straight to their port
type: howto
topic: modding-tools-editor
tags: [mcp, source-search, json-rpc, version]
sources: [memory/bannerlord-source-mcp-1_4_6-workaround.md]
updated: 2026-10-18
---

# Reaching the right-version Bannerlord source MCP

Setup seen: three source-search servers in `.mcp.json` (port 5000 = 1.2.12, 5001 = 1.3.15, 5002 = 1.4.6) all reported up by a session-start hook, yet only `mcp__bannerlord-search-1_2_12__*` registered as a tool. A generic `mcp__bannerlord__*` entry in the user-level config also pointed at port 5000, so "the bannerlord MCP" silently meant 1.2.12 - possibly wrong for a mod built against 1.4.6 on a 1.4.8 install.

Workaround: POST JSON-RPC directly (streamable HTTP; replies as `event: message` / `data: {...}` SSE lines):

```powershell
$req = @{jsonrpc="2.0"; id=1; method="tools/call"; params=@{
  name="search_bannerlord_code"
  arguments=@{regexp="..."; contextLines=12; maxResults=20}}} | ConvertTo-Json -Depth 6 -Compress
$r = Invoke-WebRequest -Uri "http://localhost:5002" -Method POST -Body $req `
     -ContentType "application/json" -Headers @{Accept="application/json, text/event-stream"} -UseBasicParsing
(($r.Content -split "`n" | ? {$_ -like "data: *"} | select -First 1) -replace '^data: ','' |
  ConvertFrom-Json).result.content | % { $_.text }
```

`tools/list` works the same way. `get_bannerlord_class_definition` is also available.

Related: [[bannerlord-live-version]]
