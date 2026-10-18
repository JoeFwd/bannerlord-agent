---
name: navmesh-g5-scene-level-mask-not-island
description: g5 is a signed scene-level visibility bitmask (base/level_1..3/civilian/siege/looted), not an island or group id.
type: lesson
topic: navmesh
tags: [navmesh, g5, levels]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings), editor inspector comparison]
updated: 2026-10-18
---

# g5 = scene-level mask, not an island id

Bits (the tool's default mapping; a scene may declare a different one, so the declaration wins): base=1, level_1=2, level_2=4, level_3=8, civilian=16, siege=32, looted=64. Stored as signed i32 (upper bits set, so values are negative). An older design doc called g5 an "island id" - wrong, confirmed against the editor's face inspector.

Vanilla campaign Main_map census (17,153 faces): -109 on 13,304 (base+level_1+civilian, upper bits preserved), -101 on 3,564, -103 on 276, -69 on 9. Rivers and lakes carry the same g5 as surrounding land; it is not a water-body id.

Tool defaults: new Main_map faces get -109, other scenes -1 (all levels). The API parameter `group` was renamed `scene_level_mask`.

Always read the scene's declared level-to-bit mapping first: [[xscene-declares-level-bit-mapping]]. See [[scene-entity-levels-require-all]].

Traps built on this mask: [[navmesh-g5-level-bits-must-cover-all-castle-levels]], [[navmesh-level-mask-must-match-mission-mask]].

Related: [[navmesh-face-field-meanings-g1-g6]]
