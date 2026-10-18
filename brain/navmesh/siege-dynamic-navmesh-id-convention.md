---
name: siege-dynamic-navmesh-id-convention
description: Siege-scene navmesh g3 conventions: 1 inside castle, 2 approach, 7 gate, ladder drop ids, reserved dynamic range.
type: reference
topic: navmesh
tags: [navmesh, siege, g3]
sources: [docs/siege-scene-design.md]
updated: 2026-10-18
---

# Siege navmesh id conventions (g3)

- `1` = inside the castle. AI counts units via `Formation.CountUnitsOnNavMeshIDMod10(1, ...)`, i.e. id % 10 == 1.
- `2` = approach / ground / walkway.
- `7` = default `CastleGate.GateNavMeshId`.
- Ladder drop faces: ids ~100-670, 1-40 faces each. Ladders call `MarkFacesWithIdAsLadder` and toggle with `SetAbilityOfFacesWithId`.
- The script value must equal a g3 actually authored: ladder spawners with `OnWallNavMeshId` 211/311/201/301 need faces with exactly those g3 values.
- The editor warns that OnWallNavMeshId must not be -1, 0, or end in 1 and must be unique, yet shipped scenes use 201/211/301/311; it is only a warning. Safe policy for new ids: 202, 302, 402...
- `MaxNavMeshId` = 1,000,000; runtime-created dynamic ids start at 1,000,010 in steps of 10. Never author faces there.
- Disconnected islands are allowed (stairs, ramparts).

Related: [[navmesh-g3-differs-campaign-vs-scene]], [[siege-scene-hard-requirements]]
