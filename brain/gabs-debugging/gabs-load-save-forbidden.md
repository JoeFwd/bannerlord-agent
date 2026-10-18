---
name: gabs-load-save-forbidden
description: Never use the GABS core/load_save tool - from a running campaign it hung the loading screen forever; load saves through the in-game Load Game menu
type: lesson
topic: gabs-debugging
tags: [gabs, load_save, saves, loading-screen, hang]
sources: [memory/gabs-load-save-forbidden.md]
updated: 2026-10-18
---

# Do not call `bannerlord.core.load_save`

On 2026-09-29 a `load_save` issued from inside a running campaign hung forever on GameLoadingScreen (log stopped after "Load Container Datas"; GABS kept reporting the stale campaign). The user ruled the tool out.

**How to apply:** load saves via the game's own menu (main menu, Load Game, pick, Load), driven through GABS ui/menu tools or screenshots. This applies to any playtest or fixture step, including instructions handed to a playtester subagent. If a campaign is already running, exit to the main menu first.

Related: [[gabs-on-1-4-7]]
