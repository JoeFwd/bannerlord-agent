---
name: artillery-detachment-weight-gated-on-ammo-point
description: A siege weapon using GetDetachmentWeightAuxForExternalAmmoWeapons decides its detachment weight ONLY from the can_pick_up_ammo standing point; the pilot seat and HasAmmo are ignored, so a dead gunner is never replaced
type: reference
topic: siege-machines
tags: [siege, detachment, ai, crew, vanilla-code]
sources: [memory/artillery-detachment-weight-gated-on-ammo-point.md, evidence/uncrewed-machine-detachment-weight]
updated: 2026-10-18
---

# Artillery detachment weight keys off the ammo point only

A custom `RangedSiegeWeapon` subclass that overrides `GetDetachmentWeightAux` to call `GetDetachmentWeightAuxForExternalAmmoWeapons(side)` gets vanilla's (1.4.6, `RangedSiegeWeapon.cs`) behaviour, which scans **only** standing points tagged `can_pick_up_ammo`:

```csharp
AreUsableStandingPointsVacant = flag2;
if (!flag)  return float.MinValue;   // no usable can_pick_up_ammo point
if (flag2)  return 1f;               // one is vacant, nobody moving to it
if (IsDetachmentRecentlyEvaluated) return 0.01f;
return 0.1f;
```

In a prefab where the sole `can_pick_up_ammo` point is the reload-right point (`use_reload_r`), the consequences are:

1. **`HasAmmo` is never consulted.** The `if (HasAmmo) ... else float.MinValue` check lives in the sibling `RangedSiegeWeapon.GetDetachmentWeightAux` that the override replaces. Measured live: `HasAmmo=False` weapons report weight **1**, not `float.MinValue`. A comment claiming "vanilla drops spent weapons to MinValue" is wrong for this class.
2. **Ammo point occupied means `IsUsableBySide=False`, so `flag=false` and weight is `float.MinValue`.** `DetachmentManager` skips every detachment whose weight is not above `float.MinValue`, so the machine advertises for nobody. If the **pilot** (`use_reload_fire_l`) dies while the reloader still holds `use_reload_r`, the weapon stays closed forever: gunner seat empty, no replacement.
3. Same closure when `ReloaderAgent != null` and the ammo point is `ReloaderAgentOriginalPoint` (the outer `if (ReloaderAgent == null || sp != ReloaderAgentOriginalPoint)` fails, `flag` never set).
4. `UsableStandingPoints` is cleared and refilled with `can_pick_up_ammo` points only, so even an open detachment offers **only the reload slot**. The pilot seat is filled solely by the promotion branch (`flag3` = pilot seat empty), which moves the `use_reload_r` occupant to the pilot point and requires `standingPoint != null`, i.e. `ammoPt.HasAIUser` or a live `ReloaderAgent`. With both false the weapon sits unmanned at weight 1 forever.

Verified live in a siege (missionTime 221s, 2 attacker + 4 defender cannons): `Idle` guns with `use_reload_r` taken gave `w=-3.4e38`; `LoadingAmmo` guns with it free gave `w=1`; `IsDisabledForBattleSideAI` was `False` on all six, so the fire-safety veto was not involved.

Further facts:
- A machine registered in a detachment with no user gets weight `float.MinValue`, so it is never attractive for formation recruitment until something else seats it.
- `GetDetachmentWeightAuxForExternalAmmoWeapons` skips any pickup point equal to `ReloaderAgentOriginalPoint`; a reloader parked on that point contributes nothing.
- `Agent.AIMoveToGameObjectIsEnabled()` does not exist in 1.4.7; do not write code against it.
- The AI branch of `AIFormationManager.Update` evicts stale user formations; the player branch only tests `userFormations.Count == 0`, so stale `UserFormations` persist there ([[standingpoint-tickaux-toctou]]).

Related: [[setdisabledsynched-leaks-detachments]], [[siegeweapon-forceduse-steals-crew]]
