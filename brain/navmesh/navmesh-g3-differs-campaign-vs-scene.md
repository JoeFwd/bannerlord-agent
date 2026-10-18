---
name: navmesh-g3-differs-campaign-vs-scene
description: g3 is a dynamic face id in scene navmeshes but a terrain-type enum in the campaign Main_map navmesh.
type: lesson
topic: navmesh
tags: [navmesh, g3, campaign-map]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings), native_rivers/findings.md]
updated: 2026-10-18
---

# g3 means different things

- Scene/siege navmesh: g3 is the face id used by `SetAbilityOfFacesWithId`, ladder marking, gate ids and AI counting, see [[siege-dynamic-navmesh-id-convention]].
- Campaign Main_map: g3 is the terrain type, see [[campaign-navmesh-terrain-type-ids]].

Check which kind of navmesh you hold before interpreting or "normalising" g3.

Related: [[navmesh-face-field-meanings-g1-g6]]
