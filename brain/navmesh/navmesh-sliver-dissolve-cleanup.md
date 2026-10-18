---
name: navmesh-sliver-dissolve-cleanup
description: Howto - remove needle faces by dissolving the shared edge of two same-terrain triangles into a convex quad, preserving exact XY footprint; thresholds used.
type: howto
topic: navmesh
tags: [navmesh, slivers, cleanup]
sources: [src/.tmp/astra-bridge-final-review/water-residuals/REPORT.md, src/.tmp/river-quad-merge-candidate/REPORT.md]
updated: 2026-10-18
---

# Dissolving slivers

- Find faces with tiny min angle/area. Practical review thresholds used: >= 3 degrees and >= 0.05 m2 (engineering thresholds, not engine requirements).
- Fix by merging with a same-terrain, same-metadata neighbour across the shared edge: no vertex moves, no extra subdivision. Examples: 2.58 deg -> 68.6 deg, 0.78 deg -> 80.4 deg.
- Accept only if the union is strictly convex. A scan found 483 same-metadata pairs forming convex quads with angles >= 20 deg, but they overlap - an opportunity count, not a safe simultaneous set.
- Keep exact exterior edge multiset and XY area per terrain id (symmetric difference ~1e-5 m2 or less).
- Deleting a face renumbers; emit an old-id -> new-id map so deck/bridge records stay indexable. Edge-id renumbering after an edge rebuild is harmless.
- If a sliver cannot be merged, repartition around an existing shoreline vertex (0.00002 m2 / 0.001 deg became 0.22 m2 / 21 deg).

Related: [[navmesh-xy-overlap-classification-gate]], [[navmesh-load-validation-checklist]]
