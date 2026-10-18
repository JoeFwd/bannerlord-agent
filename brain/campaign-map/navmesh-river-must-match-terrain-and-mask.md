---
name: navmesh-river-must-match-terrain-and-mask
description: Moving river navmesh vertices only changes navigability; visible water and terrain paint come from the river mask, heightmap and river paths, so a bend change needs all of them in sync.
type: lesson
topic: campaign-map
tags: [rivers, navmesh, terrain, war-sails]
sources: [src/.tmp/severn-bend-terrain-candidate/decision.md, src/.tmp/ouse-approach-remesh-candidate/NO-GO.md]
updated: 2026-10-18
---

# River navmesh is only one of several river layers

A War Sails style campaign river is defined independently by: the river path (scene Paths), a river-mask PNG, the world heightmap, runtime `terrain.bin`, editor `terrain_ed.bin`, plus the navmesh terrain classification. Editing navmesh river vertices alone leaves the visible water/terrain paint at the old boundary.

Tool limits found: a Python scene tool could read/write `terrain.bin` (only guarantees equal decompressed sections) but had no `terrain_ed.bin` reader/writer and no mask paint/calibration tool, so a coordinated bend change could not be authored or audited with it. Decision then: no-go; ship navmesh-only cleanup that does not reshape banks.

Approach-slope gate used for bank edits: the first inland row 1.5 m from the shoreline should rise <= tan(20 deg). With fixed shoreline Z that forced lowering >= 13 vertices by 0.1-1.6 m across 31 faces and touched terrain 14/18 neighbours, so a four-vertex edit cannot do it. Also compare navmesh Z with decoded terrain Z at the bank: a navmesh floating 0.33-0.88 m above terrain at the shore makes a deck look connected while the approach is physically off.

Related: [[xscene-editor-vs-runtime-data-split]], [[navmesh-bridge-deck-over-water-construction]]
