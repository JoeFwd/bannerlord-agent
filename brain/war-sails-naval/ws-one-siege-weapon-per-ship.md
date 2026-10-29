---
name: ws-one-siege-weapon-per-ship
description: MissionShip supports exactly one ranged siege weapon - InitializeLists keeps the LAST RangedSiegeWeapon found; crewing, ammo, raid-disable and direct control all go through that single reference
type: lesson
topic: war-sails-naval
tags: [war-sails, navaldlc, MissionShip, ShipSiegeWeapon, ballista, ship-gun]
sources: [NavalDLC 1.4.8 decompile - MissionShip.InitializeLists, ShipOrder, CalculateShipSiegeWeaponAmmoCount]
updated: 2026-10-24
---

# One siege weapon per ship

`MissionShip.InitializeLists` scans the ship's children recursively. It assigns `ShipSiegeWeapon` to the **last** `RangedSiegeWeapon` it finds. The field holds one weapon; it is not a list.

Everything downstream uses that one reference:
- ShipOrder crewing
- `SetStartAmmo` through `CalculateShipSiegeWeaponAmmoCount`
- disabling the weapon during raids
- the player's direct control

A second gun on the same hull is never crewed by the AI, never gets its starting ammo, and is not disabled correctly.

**How to apply:** give each hull one gun slot, as vanilla does with its single fore ballista. More guns per ship need code, either a Harmony patch or a custom MissionShip.

A MissionLogic that crews the extra guns must get past two more traps (verified live, 2026-10-24):
- **No sailor is free.** Once the ship is set up, `ShipOrder` puts every idle agent into `MissionShip.ShipPlacementDetachment`. Those agents are `IsDetachedFromFormation`, so `CanBeAssignedForScriptedMovement()` is false for the whole crew. Take one the way `ShipOrder` itself does (`ShipPlacementDetachment.PickLastAgent`): `placement.RemoveAgent(a); formation.AttachUnit(a);` then `gun.AddAgentAtSlotIndex(a, gun.PilotStandingPointSlotIndex)`.
- **The target list is null.** `RangedSiegeWeaponAi.ThreatSeeker._potentialTargetObjects` is only filled by `InitializeTargetableObjects()`, and vanilla calls that only for `ShipSiegeWeapon`. An AI pilot on any other gun throws an NRE in `ThreatSeeker.GetAllThreats`. Call `(gun.Ai as RangedSiegeWeaponAi)?.InitializeThreatSeeker()` before seating.

Related: [[ws-ship-upgrade-slot-mechanism]], [[ws-ship-ballista-prefab-requirements]]
