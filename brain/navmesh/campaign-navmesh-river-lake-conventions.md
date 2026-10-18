---
name: campaign-navmesh-river-lake-conventions
description: How vanilla Main_map navmesh models rivers, lakes, fords and sea: quad ladders, terrain-following +0.4 m, no transition type.
type: reference
topic: navmesh
tags: [navmesh, campaign-map, rivers]
sources: [native_rivers/findings.md]
updated: 2026-10-18
---

# Vanilla campaign navmesh water conventions (SandBox Main_map, v1.4.7 analysis)

- Whole map is one manifold sheet: 16,436 vertices, 17,153 faces, 935 border edges; world 848 m, terrain 4097^2 at 0.207 m/px.
- Rivers are a one-face-wide ladder of quads bank to bank (width ~4-14 m, step 3-5 m). 95% of river vertices are shared with land faces (fully conforming).
- Navmesh follows terrain at about +0.4 m for land, rivers and lakes alike; lakes drape the terrain (not flat).
- 62 Fording faces break river strips into 71 components; fords sit level with the river (+0.004 m).
- River and Water share edges directly (14 mouths); there is no transition type.
- Native sea level is 2.17 m; the scene has no global water plane (water_level -100).
- Open sea has no navmesh before the naval module; Water (10) is only a coastal fringe.
- The vanilla SandBox navmesh.bin was byte-identical between 1.3 and 1.4.

Related: [[campaign-navmesh-terrain-type-ids]], [[main-map-override-last-module-wins]]
