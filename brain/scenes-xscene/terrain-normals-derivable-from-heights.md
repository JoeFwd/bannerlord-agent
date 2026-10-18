---
name: terrain-normals-derivable-from-heights
description: Terrain normals can be recomputed from heights by central differences; the ZGR6 NRML PNG is not a usable source for OK01.
type: howto
topic: scenes-xscene
tags: [terrain, normals]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# Normals from heights

`normalize(-dh/dx, -dh/dy, 1)` with central differences at spacing `node_size / (res - 1)`. Compared with stored normals: max deviation 0.29 on 40+ degree slopes, 0.0054 on flat ground. Use this when regenerating OK01 or NRML after editing heights.

Related: [[ok01-terrain-ed-format]], [[zgr6-terrain-bin-format]]
