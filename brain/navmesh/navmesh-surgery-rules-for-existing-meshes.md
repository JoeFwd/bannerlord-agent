---
name: navmesh-surgery-rules-for-existing-meshes
description: Rules that kept a large navmesh edit safe: area overlap, constrained triangulation, stable ids, shape gates, no component merges.
type: howto
topic: navmesh
tags: [navmesh, howto, review]
sources: [sdd/scottish-navmesh/task-2..6 reports and reviews, plans/scottish-navmesh.md]
updated: 2026-10-18
---

# Navmesh surgery rules for existing meshes

Lessons from reshaping a shipped campaign navmesh in six phases (candidate deployed 2026-10).

- Decide face membership by polygon-area overlap with the target mask, not centroid-in-polygon. Centroids misclassify long thin faces.
- Split with constrained triangulation and weld vertices at float32 precision; otherwise cracks open between neighbours.
- Keep original face ids stable and append children, so protected id ranges and external references stay valid.
- Apply shape gates to every generated triangle: edge >= 0.01 m, altitude >= 0.005 m, aspect <= 200. In one run 611 sub-0.001 m2 triangles blocked promotion and whole patches had to be rejected (a 106 m2 gain shrank to 65 m2).
- Reject any patch that would join two separate land components (a patch linking components 4 and 76 was excluded). Connectivity changes are a pathfinding behaviour change, not a cosmetic fix.
- Where a pass corridor overlaps a Mountain mask, corridor wins.
- Preserve `g5` raw; hash-pin base and candidate SHA-256 in the ledger and check them before each phase.
- Reviewer-caught pitfalls: a region of interest that leaked into a neighbouring landmass; a circular clearance metric (measured against geometry the patch itself created); missing routing for confirmed lakes.
- Validate in the editor: Select Unconnected, Mark Elevation Problem, Ensure Faces Not Below Ground, Find Path.

Related: [[navmesh-editor-runtime-acceptance-checklist]], [[campaign-navmesh-terrain-type-ids]], [[navmesh-faces-must-be-tris-or-quads]], [[navmesh-duplicate-corner-face-crash]]
