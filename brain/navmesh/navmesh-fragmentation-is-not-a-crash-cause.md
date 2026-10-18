---
name: navmesh-fragmentation-is-not-a-crash-cause
description: A valid navmesh can still be heavily fragmented (many tiny islands) - a pathfinding quality concern, not a crash cause; benchmark component counts against peers and vanilla
type: reference
topic: navmesh
tags: [navmesh, fragmentation, components, islands, rnm1, validation]
sources: [memory/york-navmesh-fragmentation.md]
updated: 2026-10-18
---

# Navmesh fragmentation is not a crash cause

A settlement navmesh can be structurally sound (no orphan or over-referenced edges, no out-of-range indices, no NaN, all vertices inside the terrain, spawn point on a real face) and still be far more fragmented than peers. Fragmentation means agents can get stranded on tiny islands: a pathfinding quality issue only.

**Benchmark numbers:** a town scene with 6876 verts / 12289 edges / 5405 faces had 74 connected components with 31 islands of <=2 faces (largest 2158/1195/1170), vs 37 components / 7 tiny islands for a comparable town and 17 / 5 for vanilla `empire_town_s`.

**How to apply:** do not chase fragmentation as the cause of a crash; in this case the real cause was a missing marker script ([[missing-commonareamarker-crash]]). Treat as separate lower-priority cleanup. Validation tip: the navmesh reader in the navmesh studio's `blnav.rnm1.read` takes a PATH, and `Face` fields are `vertex_ids`/`edge_ids`, not `vertices`/`edges` ([[navmesh-studio-tool]]).

