---
name: siegeweapon-forceduse-steals-crew
description: SiegeWeapon.OnInit sets ForcedUse=true, so vanilla keeps enlisting the NEAREST formation onto your machine and fights your own crewing; fix with SetForcedUse(false) in C# after base.OnInit (prefab variable does not work)
type: lesson
topic: siege-machines
tags: [siegeweapon, forceduse, crew, formation, hasnewmovingagents, detachment]
sources: [memory/siegeweapon-forceduse-steals-crew.md]
updated: 2026-10-18
---

# ForcedUse hijacks custom crewing

`SiegeWeapon.OnInit()` sets `ForcedUse = true`, enabling its own crewing pass (gated by `if (!ForcedUse) return;`). Two branches enlist formations:
- `!CalculateIsSufficientlyManned(side)` adds every eligible formation as a candidate.
- `HasNewMovingAgents()` (any standing point with `HasAIMovingTo && PreviousUserAgent != MovingAgent`) picks the **closest formation by `CachedMedianPosition`** and calls `StartUsingMachine`.

The second is the trap: any machine whose crew walks between standing points (ammo pile -> load point -> wait point) trips it constantly, so vanilla keeps enlisting the nearest formation (on a castle wall, Ranged, not your crew formation). Two formations then share the detachment and native `DetachmentManager` reassigns standing points mid-tick; symptom: "the crewman quits his post right after the shot". The same mid-tick release nulls `StandingPoint.UserAgent` between lines 107 and 114 of `StandingPoint.TickAux`, giving an NRE in vanilla code ([[standingpoint-tickaux-toctou]]).

**Fix:** `SetForcedUse(false)` in your override's `OnInit` **after** `base.OnInit()`. A prefab `<variable name="ForcedUse" value="false"/>` does NOT work: script variables are applied before `OnInit`. (No vanilla Native prefab sets it in XML.)

**Cost:** `SiegeWeaponOrderType` UI getters report `Stop`/`AIControlOff`, and a player clicking "AI control on" calls `SetForcedUse(true)` and brings the competitor back.

Mod case: diagnosed on a paused custom cannon; prefabs `greatcannon.xml` and `mortar.xml` in Cannons set it in XML where it is inert. Related: [[setdisabledsynched-leaks-detachments]], [[evaluate-in-debugger-without-freezing-the-game]]
