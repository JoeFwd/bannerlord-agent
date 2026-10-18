---
name: navmesh-g5-level-bits-must-cover-all-castle-levels
description: Siege navmesh connector faces tagged with only level_1 vanish at castle level 2/3 and shatter the sheet into unreachable islands; sweep for faces with siege but not all level bits
type: lesson
topic: navmesh
tags: [navmesh, g5, siege, castle-level, connectivity, islands]
sources: [memory/framlingham-navmesh-hole.md]
updated: 2026-10-18
---

# Face level bits must span all castle upgrade levels

A castle siege stalled: 2 defenders pinned on a tower top, ~59 attackers milling 11.5 m below, zero casualties. Cause: 335 faces carried `g5 = -51` = `base, siege, level_1`, with `level_2` and `level_3` bits missing. Those faces were the connective tissue of the siege navmesh (stairs and wall-walk links, z 10-35). At upgrade level 2 or 3 they drop out and the siege sheet shatters from 34 components into 47, leaving the tower (28 faces) and the 135-face rampart walk unreachable islands.

**Fix:** edit `g5` `-51 -> -3` on those faces (adds level_2|level_3, civilian stays off, upper bits preserved). Pure attribute edit, no geometry authored; back up `navmesh.bin` first. Afterwards siege connectivity is identical at all three levels.

**False trails:**
1. A wrong `g5` bit mapping made the two sheets look like level variants; they are civilian vs siege. Read the level mapping first ([[xscene-declares-level-bit-mapping]]).
2. Apparent "unmeshed terrain holes" were building footprints (wall tower 1.3 m, wall 4.3 m away). Absent navmesh there is correct; filling would let agents walk through solid geometry.

**Sweep rule:** look for face sets with `siege` but only `level_1`. The civilian sheet can have the same class of defect (orphan islands, T-junction components that share a vertex but no edge).

Related: [[navmesh-g5-scene-level-mask-not-island]], [[navmesh-level-mask-must-match-mission-mask]], [[navmesh-presence-probe-in-rider]], [[navmesh-studio-tool]]
