---
name: ws-sail-vertex-paint-pins
description: Cloth pinning lives in per-vertex colour - alpha 0 pins, blue 0 marks the border ring; sails with only the top pinned fly up like flags in wind. TpacTool prints Color as BGRA
type: lesson
topic: war-sails-naval
tags: [war-sails, cloth, vertex-paint, pinning, bgra, tpactool, square_sail_a]
sources: [memory/ws-sail-vertex-paint-pins.md]
updated: 2026-10-18
---

# Sail pinning is per-vertex colour, not cloth settings

Symptom: sails move "like a piece of cloth in the wind, flying higher and higher with wind strength" even though cloth settings match vanilla ([[ws-sail-cloth-params-frozen]]). Cause: a read-only dump of `MeshEditData.Vertices[].Color` shows the pinning differs. **TpacTool prints colour in BGRA**: an authoring (R,G,B,A) appears as <B,G,R,A>.

| Sail | A=0 (pinned) | R=0 / G=0 (bottom-left / bottom-right corner) | B=0 |
|---|---|---|---|
| vanilla `square_sail_a` | top row (6 vertices) + both corner vertices | 1 vertex each, also A=0 (pinned) | **whole border ring, 348 vertices** |
| typical mod carrack/boat_b | top band ~170 vertices | ~16-30 vertex blobs, **not pinned** (A=255) | none |
| typical mod kogge | top row, 25 vertices | no corner marks | none |

With only the top pinned the bottom is free and wind lifts the sheet like a flag. Skinning also differs: vanilla puts nearly every vertex on bone 0 with only corners on the sheet bones.

**Two-sheet cloths:** meshes made of two stitched sheets have no open boundary; the rim is joined by edges ~0.008 long. Find the rim from vertices on edges shorter than 0.25x the median edge length, and pin each corner on both sheets.

**How to apply:** fix colours in the authoring script or in Blender, export the FBX, reimport in the editor ([[fbx-edits-need-tpac-reimport]]), then re-check the cloth settings survived the reimport. Never binary-patch the tpac. Verify with an FBX comparer that only colours changed.

In one mod the authoring script wrote A=0 only for the top band and never B (reported 2026-10-03). Related: [[ws-sail-cloth-params-frozen]]
