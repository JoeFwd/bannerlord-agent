---
name: coop-server-docker-logs
description: BannerlordCoop dedicated-server logs are Docker json-file logs (UTC, ANSI, wrapped lines) with no Serilog Debug output; convert before grepping
type: reference
topic: coop-multiplayer
tags: [coop, docker, logs, serilog]
sources: [memory/coop-server-docker-logs.md]
updated: 2026-10-18
---

# BannerlordCoop dedicated server logs

A BannerlordCoop dedicated server running in Docker keeps its useful logs as `<container-id>-json.log` files (3-12 MB each). Files named `Coop_server.log` / `coop-server-*.log` copied alongside are empty or hold only the startup banner.

- **Format:** one JSON object per line, `{"log","stream","time"}`; `time` is UTC (convert to the reader's offset).
- **Noise:** ANSI escapes, long messages split across several entries, and about 10k `ASSERT: !IsActive` lines from `MobileParty.cs`.
- **Converting:** a small Python script that strips ANSI and writes `line<TAB>time<TAB>text` makes them greppable.
- **Logged:** pause/time control (`Occupancy pause ownership`), `[BattleMissionLifecycle]`, `[TroopSupply] Built reserve`, `[BattleHost]` and `pulse` lines (timeMode, mapEvents).
- **Missing:** Debug-level messages such as "Rejecting conversation request". `NearbyPartyReinforcer` logs nothing at all, so join decisions cannot be read from these logs.
