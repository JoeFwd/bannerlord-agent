---
name: ws-ship-ballista-prefab-requirements
description: Entity tree a Ballista/ShipBallista script needs (navel, body, skeleton, projectile tagged with MissileItemID, projectile_leaving_position sibling, Pilot, camera, targeting entity), its axis conventions, and what is hardcoded (sounds, ship damage path)
type: reference
topic: war-sails-naval
tags: [war-sails, navaldlc, Ballista, ShipBallista, RangedSiegeWeapon, prefab, ship-gun]
sources: [TaleWorlds.MountAndBlade 1.4.8 Ballista.cs; NavalDLC 1.4.8 ShipBallista.cs and MissionShip.OnHit; NavalDLC AssetPackages nested_prefabs_packed.xml ballista_c / ship_ballista_holder]
updated: 2026-10-23
---

# ShipBallista prefab requirements

These rules let you reskin the ballista with no new code, for example as a swivel gun.

## Required entities

Each is found by tag, searching recursively from the script's entity.

- **Navel:** a `SynchedMissionObject` tagged `NavelTag` (default `BallistaNavel`).
  - It **yaws**: `ApplyAimChange` rotates the navel's initial frame about its own up axis by `CurrentDirection`.
  - The Pilot standing point orbits with it.
- **Body:** a `SynchedMissionObject` tagged `BodyTag` (`BallistaBody`). It **pitches** about its local side axis.
- **Skeleton:** under the body, a `SynchedMissionObject` tagged `SkeletonTag` (`SkeletonEntity`) carrying `<skeleton name="ballista_skeleton">`.
  - `RegisterAnimationParameters` dereferences `Skeletons[0]` with no null check.
  - `ballista_fire` and `ballista_set_up` play on this skeleton.
  - With no tagged entity, the body itself is used, so the body then needs the skeleton.
- **Projectile:** a `SynchedMissionObject` tagged with the **`MissileItemID`** value (vanilla also tags it `projectile`). This is the loaded-shot model.
- **Leaving position:** an entity named `projectile_leaving_position`. It must be a **sibling** of the projectile, i.e. a child of the projectile's parent.
- **Others:** a `StandingPoint` tagged `Pilot`, an entity tagged `cameraHolder` and an entity tagged `targeting_entity`.

## Conventions

- The weapon fires along local **−y**. On vanilla ships `ballista_c` sits at yaw π, facing the bow.
- `HorizontalDirectionRestriction` is a **half-angle**. Vanilla's ship holder uses 3.13 (a full circle); 1.3 gives ±74°.
- `BallistaShootingSpeed` sets the muzzle speed: 170 in the prefab, 110 in the ship holder.
- `MultipleProjectileCount` only matters for the grape item ids hardcoded in `ShipBallista` (`ballista_c_projectile_grape*`).
- `ShipBallista` adds the ship's velocity to the shot and to its aim estimate.

## Hardcoded

- Sound events are fixed to `event:/mission/ballista_naval/*` in `GetSoundEventIndices`. Other sounds need a patch.
- Ship damage from any ship siege-engine missile takes the same path, whatever the item id: `MissionShip.OnHit` → `MissionSiegeEngineCalculationModel.CalculateDamage(attacker, inflictedDamage)`.
  - A new ammo item works if its `thrust_damage` is in vanilla's range: iron 2400, stone 1285, bolt 3550, grape 120.
  - The template is `ballista_c_projectile_iron`: `weapon_class="BallistaBoulder"`, `ammo_class="Boulder"`.

Related: [[ws-one-siege-weapon-per-ship]], [[ws-ship-upgrade-slot-mechanism]]
