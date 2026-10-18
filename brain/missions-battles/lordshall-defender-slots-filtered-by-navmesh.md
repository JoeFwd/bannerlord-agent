---
name: lordshall-defender-slots-filtered-by-navmesh
description: In the lord's-hall siege mission, archer spawn helpers are kept only if on an enabled navmesh face, and SpawnTroops dereferences the chosen slot with no null check.
type: reference
topic: missions-battles
tags: [lords-hall, spawn, navmesh, nre]
sources: [runtime-evidence/keep-* reports (2026-08-31)]
updated: 2026-10-18
---

# Lord's hall defender slots

`LordsHallFightMissionController.AreaData.AddAreaMarker` keeps every `defender_infantry` entity, but keeps a `defender_archer` entity only if `GetNavMeshFaceIndex(checkIfDisabled: true)` finds an enabled face at its position. `MissionSide.SpawnTroops` then indexes the chosen slot without a null check, so a hall with fewer retained slots than defenders (default 27 defenders, 19 attackers, up to 19 defender archers) throws an NRE.

Fix pattern: replace unreachable archer prefabs with infantry prefabs at the same positions, so every position is retained. Layout rules learned: infantry hold the breach, archers sit to the defenders' side so a barricade does not block shots, helpers sit about 2 cm above the floor, and facing is set from yaw = atan2(-dx, dy). Native `AreaEntityData.AssignAgent` issues a `DefaultMove`.

Static geometric membership checks do not prove the active navmesh: see [[navmesh-level-mask-must-match-mission-mask]].

Related: [[navmesh-level-mask-must-match-mission-mask]], [[xscene-declares-level-bit-mapping]]
