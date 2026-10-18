---
name: gabs-on-1-4-7
description: GABS/GABP works on Bannerlord 1.4.7 with the stock v1.3.13 DLL once MCM and UIExtenderEx are installed and module order is right; old per-version path tables are outdated
type: howto
topic: gabs-debugging
tags: [gabs, gabp, mcm, uiextenderex, module-order, launch]
sources: [memory/gabs-on-1-4-7.md]
updated: 2026-10-18
---

# GABS on 1.4.x

As of 2026-07-20 GABS works on Bannerlord 1.4.7 (War Sails). The stock `Bannerlord.GABS.v1.3.13.dll` runs fine: its ModuleLoader falls back to the latest available implementation when no exact game-version DLL exists. No rebuild needed (full source is in `GABS_EXE`'s module folder on the older install if ever required).

**Why it fails silently without MCM:** `SubModule.StartServer()` references `BridgeSettings.Instance` (MCM `AttributeGlobalSettings`). MCM and UIExtenderEx were absent from the 1.4 install, so the GABP bridge never started.

**How to apply:**
- Copy `Bannerlord.MBOptionScreen` (v5.11.4) and `Bannerlord.UIExtenderEx` (v2.13.2) into the 1.4 install's `Modules\`.
- Launch module order: `Bannerlord.Harmony*Bannerlord.ButterLib*Bannerlord.UIExtenderEx*Bannerlord.MBOptionScreen*Bannerlord.GABS*Native*...`
- The launch profile needs env vars `GABP_SERVER_PORT=<port>`, `GABP_TOKEN=<token>`, `GABS_GAME_ID=bannerlord`, `GABS_BRIDGE_PATH=<home>/.gabs/bannerlord/bridge.json`.
- Any start skill's project_path table that lists only older installs must be pointed at the live install.
- Caveat: a DLL compiled against 1.3.x assemblies: core/party/UI/screenshot tools proven on 1.4.7, but some of the 101 tools may throw at call time on War-Sails-changed APIs. v1.3-era saves can pop module-mismatch inquiries on 1.4.7.

Related: [[gabs-start-launches-wrong-install]], [[bannerlord-live-version]]
