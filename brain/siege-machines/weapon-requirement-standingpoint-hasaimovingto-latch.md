---
name: weapon-requirement-standingpoint-hasaimovingto-latch
description: A StandingPointWithWeaponRequirement refuses agents not wielding the projectile, so an agent that loses its ball en route latches HasAIMovingTo permanently and hides the point from everyone else
type: lesson
topic: siege-machines
tags: [standingpoint, hasaimovingto, siege, ammo, latch]
sources: [memory/cannon-loader-arrives-but-never-seats.md]
updated: 2026-10-18
---

# HasAIMovingTo latch on weapon-requirement standing points

`LoadAmmoStandingPoint` is a `StandingPointWithWeaponRequirement`, so `IsDisabledForAgent` returns *disabled* for anyone not wielding the projectile. An agent that loses its ball on the way can therefore **never seat**, however close it stands.

The pickup handler is what sets the `MovingAgent` latch (equip ball, then `AIMoveToGameObjectEnable(loadAmmoPoint, ...)`). Vanilla's `OnCarriedProjectileDropped` only releases the point when `agent.CurrentlyUsedGameObject == loadAmmoPoint`, i.e. only once *seated*; the still-walking case has no handler, so the latch is permanent. Vanilla's selection filters on `!sp.HasAIMovingTo`, so the latch also stops the point being offered to anyone else: one dropped ball takes the weapon out of the battle for good.

**Fix shape:** in the update loop, add `else if (point.HasAIMovingTo)` and, if the mover is not wielding the right `WeaponClass`, call `StopUsingGameObject(true, StopUsingGameObjectFlags.None)` (it calls `AIMoveToGameObjectDisable()`, which clears the latch). Vanilla's trebuchet code already has this branch.

**Diagnosis:** sample `MovingAgent.IsActive()`, distance from the point, and formation; an alive agent 0.2 m from the point with `HasAIMovingTo` stuck for minutes is this latch. Always include `IsDeactivated` in the sample.

Related: [[standingpoint-tickaux-toctou]], [[artillery-detachment-weight-gated-on-ammo-point]].
