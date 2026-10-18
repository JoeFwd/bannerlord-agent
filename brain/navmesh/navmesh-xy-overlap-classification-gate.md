---
name: navmesh-xy-overlap-classification-gate
description: Howto - classify every XY edge crossing/overlap/T-junction in a navmesh by owning-face terrain ids; dry/dry, water-only, coplanar and T-junction classes must be zero.
type: howto
topic: navmesh
tags: [navmesh, validation, gate]
sources: [src/.tmp/xy-layer-audit.md, src/.tmp/xy-layer-repair/REPORT.md, src/.tmp/astra-bridge-final-review/final-v2-gate.md]
updated: 2026-10-18
---

# Strict XY layer gate

Run on any navmesh with layered geometry (bridges, undercrossings). Collect per edge: proper crossings, partial collinear overlaps, vertices strictly inside another edge (T-junctions). Classify by the terrain ids of the owning faces.

Must be ZERO: pure dry/dry crossings, water-only crossings, coplanar overlaps (same surface, 0 Z separation), T-junctions.
Allowed: deck-over-water and deck-vs-shoreline crossings where Z diverges (meet at one endpoint, differ ~0.17 m at the other).

Reference clean result on a bridge-heavy map: 181 layered crossings, 203 partial overlaps, 0/0/0/0. Counts drift when faces are dissolved (4 layered crossings vanished with removed interior diagonals), so gate on the zero-classes, not totals. Do not cap listings (`[:50]`); list every item with edge, vertex, owner face and terrain ids.

Related: [[navmesh-bridge-deck-over-water-construction]], [[navmesh-sliver-dissolve-cleanup]], [[navmesh-load-validation-checklist]]
