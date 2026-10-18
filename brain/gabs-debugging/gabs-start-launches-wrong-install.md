---
name: gabs-start-launches-wrong-install
description: A GABS games_start pointed at an obsolete install produced a phantom "crash on save load" defect; the MCP server caches config at startup, and a pinned port means no bridge.json is written
type: lesson
topic: gabs-debugging
tags: [gabs, games_start, config, bridge.json, phantom-defect]
sources: [memory/gabs-start-launches-wrong-install.md]
updated: 2026-10-18
---

# games_start can launch the wrong install

`~/.gabs/config.json` pointed `games_start` at an older (v1.3) install's launcher instead of the live 1.4.7 install. Corrected 2026-08-12. A playtester agent called `games_kill` + `games_start`, silently got the old executable, watched it access-violate loading 1.4.7-era saves, and filed a bogus "Critical: game crashes ~2 s after any save load". The Windows Event Log naming the faulting binary's path is the tell.

**How to apply:**
- The GABS MCP server reads `config.json` **once at startup**; editing mid-session does nothing. Restart the MCP server or launch manually.
- Manual launch: run the live install's own `Modules\Bannerlord.GABS\launch-bannerlord.ps1` (it sets the GABP env and includes ButterLib+UIExtenderEx+MBOptionScreen; see [[gabs-on-1-4-7]]).
- With the port pinned via env, the mod does **not** write `bridge.json`. Write it by hand (`{"port":<port>,"token":"<GABP_TOKEN>","gameId":"bannerlord"}`) or `games_connect` chases a stale port.
- Before trusting any crash report confirm which install is live: `Get-Process Bannerlord | Select Id,Path`.
- A launch profile that sets no GABP env (e.g. a plain Standalone one) can never connect.

Related: [[bannerlord-live-version]]
