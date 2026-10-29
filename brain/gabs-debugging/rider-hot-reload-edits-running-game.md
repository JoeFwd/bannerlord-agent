---
name: rider-hot-reload-edits-running-game
description: While Rider debugs Bannerlord, saving a .cs file hot-reloads it into the live game; state built by the old code (static caches, array sizes) then breaks the new code and can crash the session
type: lesson
topic: gabs-debugging
tags: [rider, hot-reload, debugger, crash]
sources: [live session 2026-10-24, DADG ShipSwivelGunCrewMissionLogic]
updated: 2026-10-24
---

# Rider hot-reloads saved edits into the running game

Under a Rider debug session, saving a source file applies the change to the running Bannerlord process. A failed `dotnet build` deploy (the game locks its DLLs) does not mean the game still runs the old code.

Evidence: a reflection cache filled by the old code held 5 `PropertyInfo`s. The edit added a 6th name and a getter that read `[5]`. The getter ran in the live game and threw `IndexOutOfRangeException` in a mission tick. The game exited once the debugger resumed.

**How to apply:**
- While the game runs under Rider, edit only code that is safe against state the old code built, or keep the edit unsaved until the game is closed.
- If a hot-reloaded edit breaks, clear the affected caches by debugger eval before resuming. The exception that is already thrown still unwinds.

A second trap: a breakpoint pause brings Rider to the foreground, so the user's game keystrokes go into the open editor. Check the file for stray characters before the next build.

Related: [[debugger-pause-kills-gabp-game]]
