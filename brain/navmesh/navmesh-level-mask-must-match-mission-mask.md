---
name: navmesh-level-mask-must-match-mission-mask
description: A mission loads only navmesh faces whose g5 level bits match the mission mask; a scene whose faces lack the siege bit loads one face and every query returns -1.
type: lesson
topic: navmesh
tags: [navmesh, level-mask, siege]
sources: [runtime-evidence/keep-nav (2026-08-31)]
updated: 2026-10-18
---

# Level mask decides which faces exist at runtime

In a siege-mission scene the runtime showed 1 navigation face loaded (mask 5 = base 1 + siege 4) and breach queries returned face -1, although the source navmesh had 40 faces. Faces 0..38 had g5 = -6 (siege bit absent) and the rear face had -4. Setting the siege bit (XOR 4 on the payload bytes, -6 -> -2) restored the mesh; defenders then held the breach instead of retreating to the rear wall.

Rule: a navmesh that is geometrically correct can still be invisible to a mission. Compare the face g5 bits with the mask the mission logs, and check the scene's declared level bit mapping (see [[xscene-declares-level-bit-mapping]]) before blaming geometry or AI.

Related: [[navmesh-g5-scene-level-mask-not-island]], [[navmesh-g5-level-bits-must-cover-all-castle-levels]], [[xscene-declares-level-bit-mapping]], [[lordshall-defender-slots-filtered-by-navmesh]]
