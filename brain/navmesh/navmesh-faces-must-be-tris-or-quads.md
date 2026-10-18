---
name: navmesh-faces-must-be-tris-or-quads
description: Bannerlord navmesh faces may only have 3 or 4 vertices; an n-gon parses fine offline but crashes the game natively during navmesh load, before "NAV_MESH: load finished"
type: lesson
topic: navmesh
tags: [navmesh, ngon, native-crash, load-order, ear-clipping]
sources: [memory/navmesh-faces-must-be-tris-or-quads.md]
updated: 2026-10-18
---

# Navmesh faces: triangles and quads only

Across 285 `navmesh.bin` files (Native + SandBox + a large mod), about 2.83M faces, the face-size histogram is exactly `{3: 243325, 4: 2585295}` with zero exceptions.

A face with 5/6/8 vertex ids parses fine with the studio parser (the format stores an explicit per-face count, the footer lands correctly) but kills the game with a native access violation during navmesh load. Offline validators and the scene editor tolerate n-gons; only the runtime loader rejects them, with no managed exception and no dialog. "The file parses" and "the editor saved it" are worthless as evidence.

**How to apply:**
- Diagnose by log ordering. A healthy load prints `Loading xml file: .../scene.xscene`, `.../atmosphere.xml`, `N entities are registered as oro.`, `NAV_MESH: load finished, first load for scene: 1`. If the log stops after the oro line, the crash is inside navmesh load; look at `navmesh.bin`.
- Gate any generated or merged navmesh on `Counter(len(f.vertex_ids) ...)` having only keys 3 and 4 before launch.
- Repair by ear-clipping each n-gon in the XY projection, copying the parent's `g1..g6` to each piece. Faces are CCW seen from +Z and ear clipping preserves winding. Verify parent signed area equals the sum of pieces' (~1e-9).
- `NavMesh.serialize()` round-trips byte-identically and `rebuild_edges()` is a faithful no-op on a consistent mesh, so both are safe on live files; check on the specific file first.
- Do NOT treat stacked faces or duplicate vertex positions as a defect on their own: vanilla stacks near-coincident faces (`empire_town_f` 67273, `khuzait_town_004` 91478, `sturgia_castle_siege_001` 70354 pairs within 10 cm).
- The studio README's "every edge referenced by 1 or 2 faces" is not enforced by the runtime; shipped scenes violate it and load fine. A smell, not a crash gate; the face-size histogram is the gate.

Related: [[navmesh-studio-tool]], [[navmesh-fragmentation-is-not-a-crash-cause]], [[xscene-orphan-group-guid-crash]], [[navmesh-duplicate-corner-face-crash]]
