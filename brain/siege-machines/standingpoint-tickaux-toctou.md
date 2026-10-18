---
name: standingpoint-tickaux-toctou
description: StandingPoint.TickAux checks HasUser once then dereferences UserAgent repeatedly; never call StopUsingGameObject from an OnAgentWieldedItemChange handler (raised from inside TickAux on AutoSheathWeapons points)
type: lesson
topic: siege-machines
tags: [standingpoint, tickaux, nre, toctou, autosheathweapons, stopusinggameobject]
sources: [memory/standingpoint-tickaux-toctou.md]
updated: 2026-10-18
---

# StandingPoint.TickAux TOCTOU

`StandingPoint.TickAux(bool isParallel)` checks `HasUser` **once** (line 84 of decompiled source) then re-dereferences `this.UserAgent` at lines 86, 94, 107, 112, 114, 119, 123 without re-checking. Anything nulling `UserAgent` mid-method crashes vanilla with an NRE you did not write.

Only the `AutoSheathWeapons` branch can trip it (it calls code that raises events before the next deref):
- 112 `UserAgent.TryToSheathWeaponInHand(MainHand, Instant)` raises `Agent.OnAgentWieldedItemChange`
- 114 `UserAgent.GetOffhandWieldedItemIndex()` -> **NRE**

The `else` branch (121-129) is safe: nothing before the deref at 123 raises an event.

**Rule:** never call `Agent.StopUsingGameObject()` from an `OnAgentWieldedItemChange` handler. It nulls `StandingPoint.UserAgent`, and that event is routinely raised inside `TickAux`. Guard the handler on which object the agent is using, and prefer a point whose `AutoSheathWeapons` is false.

`AmmoPickupHandler.OnCarriedProjectileDropped`: a crewman carrying a cannonball on `use_reload_r` (`AutoSheathWeapons=true`) had the ball sheathed by TickAux, the event fired, the handler called `StopUsingGameObject`, vanilla NRE'd. FIXED by cancelling usage only when `agent.CurrentlyUsedGameObject == loadAmmoPoint` (`use_load`, `AutoSheathWeapons=false`), which also avoids evicting the crewman from the sole `can_pick_up_ammo` seat.

Related: [[siegeweapon-forceduse-steals-crew]] (same NRE signature, different trigger), [[evaluate-in-debugger-without-freezing-the-game]]
