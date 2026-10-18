---
name: campaign-menu-without-wait-zeroes-ai-dt
description: In vanilla Campaign.Tick a game menu with !IsWaitActive sets _dt = 0 before TickPartialHourlyAi - the calendar keeps running but no party thinks, so armies abandon sieges and hold; park observers in a wait menu
type: lesson
topic: campaign-ai
tags: [campaign-tick, menu, wait, dt, ai-freeze, playtest]
sources: [memory/playtester-campaign-idle-rules.md]
updated: 2026-10-18
---

# A non-wait settlement menu freezes the AI world

In vanilla `Campaign.Tick`, a menu with `!IsWaitActive` sets `_dt = 0` just before `TickPartialHourlyAi`. The calendar and daily/hourly events and spawns keep running at speed 3, but **no party in the world thinks again**: armies abandon sieges and sit in Hold. Standing in a plain settlement menu (menuId `town`) is worse than pausing. Select the wait item (`town_wait`); read the current menuId with `menu.get_current` (structuredContent).

Also: bandit encounters on the open map block the campaign.

**Observation-run rules** (each poll): the player rests inside a friendly town in the wait menu; if on the open map, move to the nearest friendly town that allows waiting; check the game is at speed 4 and unpaused (`set_time_speed 4` with unpause); if in a settlement but not passing time, select wait or go to one that allows it.

