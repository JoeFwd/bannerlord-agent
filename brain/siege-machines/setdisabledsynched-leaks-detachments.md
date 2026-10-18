---
name: setdisabledsynched-leaks-detachments
description: SetDisabledSynched does NOT remove a machine from Formation._detachments; only UsableMachine.Disable() does and it never runs on the deployment path - a live sibling must prune disabled machines via IsDeactivated
type: lesson
topic: siege-machines
tags: [setdisabledsynched, detachments, usablemachine, isdeactivated, deployment]
sources: [memory/setdisabledsynched-leaks-detachments.md]
updated: 2026-10-18
---

# Disabled siege machines stay in Formation detachments

Verified identical in Bannerlord 1.2.12 and 1.4.6.

`SiegeDeploymentHandler.RemoveDeploymentPoints(side)` disables every non-chosen `DeployableWeapons` entry via `siegeWeapon.SetDisabledSynched()` -> `SetDisabledAndMakeInvisible()` -> `Mission.DeactivateMissionObject(this); IsDisabled = true;`. This never touches `Formation._detachments`.

The only method that tears detachments down is `UsableMachine.Disable()` (`DetachmentManager.DestroyDetachment(this)` + stops UserAgent/MovingAgent). Its only callers are `Mission.OnObjectDisabled(DestructableComponent)` (actual destruction) and `DisableSiegeEngines()`; deployment cleanup calls neither.

Consequence for mods calling `Formation.StartUsingMachine` from a machine's own `OnTick`: a disabled machine leaves `ActiveMissionObjects` and stops ticking, so it can never drop itself. A still-live sibling must prune it. Test with `UsableMachine.IsDeactivated` (`public virtual`; the `SiegeWeapon` override returns true when `IsDisabled`), covering both deployment-disabled and destroyed-mid-battle.

Mod effect: dead falconets stayed in Bodyguard, each soaking two crew.

Related: [[formation-detachments-includes-strategicareas]]
