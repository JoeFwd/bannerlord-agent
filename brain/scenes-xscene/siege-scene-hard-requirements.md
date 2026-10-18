---
name: siege-scene-hard-requirements
description: What a campaign siege scene needs to load and function, ordered by failure risk.
type: reference
topic: scenes-xscene
tags: [siege, scenes, requirements]
sources: [docs/siege-scene-design.md]
updated: 2026-10-18
---

# Siege scene requirements (managed 1.4.6)

Required: navmesh joining attacker camp, walls and interior; at least one WallSegment per defended side (with DefenseSide); a CastleGate whose GateNavMeshId matches an authored g3; a primary attacker spawner (ladder, tower or ram) with unique ids and a `<path>` for towers/rams; deployment points `siege_deployment_placeholder_part_a/_b`; spawn side tagging such that `GetInitialSpawnPathDataOfSide` returns a valid path; entities tagged `strategyCameraAttacker` / `strategyCameraDefender`. Campaign sieges do not use `sp_zone_`.

Degrades but loads: archer/cover points, sally door, defender engines, merlon tags.

Failure risk order: navmesh disconnection, missing ids, WallSegment, spawn paths, cameras. Cheaper first milestone: a town-visit scene (navmesh, `spawnpoint_player`, Passages, `npc_common`).

Cheapest approach: harvest a working castle's whole entity cluster, terrain patch and flora, and copy its navmesh too so g3 ids still match the script values ([[siege-dynamic-navmesh-id-convention]]).

Related: [[settlement-scene-binding-by-wall-level]]
