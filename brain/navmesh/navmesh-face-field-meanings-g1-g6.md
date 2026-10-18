---
name: navmesh-face-field-meanings-g1-g6
description: What each navmesh face field means: g1/g2/g4 constants, g3 face id or terrain type, g5 scene-level mask, g6 flag.
type: reference
topic: navmesh
tags: [navmesh, face-fields]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# Face fields g1..g6

| field | value / meaning |
|---|---|
| g1 | always 2 |
| g2, g4 | always 0 |
| g3 | face id / type; meaning depends on navmesh kind, see [[navmesh-g3-differs-campaign-vs-scene]] |
| g5 | signed visibility bitmask over scene levels, see [[navmesh-g5-scene-level-mask-not-island]] |
| g6 | byte flag; some modded siege scenes set 1 on ~45% of faces, native siege scenes use 0. Plausibly walkable/roof, UNCONFIRMED |

Related: [[nmg8-nmg9-scene-navmesh-format]]
