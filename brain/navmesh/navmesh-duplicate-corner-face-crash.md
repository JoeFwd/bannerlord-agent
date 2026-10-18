---
name: navmesh-duplicate-corner-face-crash
description: A navmesh face whose corner list repeats a vertex (zero-area quad) leaves a NULL link slot and the native loader AVs at Native+0x4140D7; the repair is uniquely determined by the orphaned edges
type: lesson
topic: navmesh
tags: [navmesh, duplicate-vertex, quad, native-crash, rnm1, repair]
sources: [memory/navmesh-duplicate-corner-face-crash.md]
updated: 2026-10-18
---

# Duplicate-corner navmesh face crashes the loader

The scene editor can write a quad whose corner list repeats a vertex, e.g. `[7148, 7057, 7148, 7149]` where corner 2 should have been 7056: three distinct corners, zero area, and two of four `edge_ids` still reference the dropped vertex. The native loader binds four link slots per face and `TaleWorlds.Native+0x4140D7` dereferences all four unconditionally (`cmp byte ptr [rax+0x20], 2`); the unbindable slot stays NULL and the game takes an access violation reading `0x20` during navmesh load, a worker-thread native crash with nothing in ModLogs.

The defect is invisible to face-count/index-range checks and to the n-gon rule ([[navmesh-faces-must-be-tris-or-quads]]).

**Validate** with the navmesh studio tool (env `BANNERLORD_NAVMESH_STUDIO`, `blnav`): `nmg9.NavMesh.parse(rnm1.read(path))`, then per face check `len(set(vertex_ids)) == n` and that unordered vertex pairs of the corner ring equal the unordered endpoint pairs of `edge_ids`.

**Repair** is uniquely determined: the stored edges name the missing vertex; brute-forcing closed rings leaves two orderings differing only in area sign; pick the one matching the mesh's global winding (compute area in the **X/Y** plane; Bannerlord is Z-up, and X/Z falsely flags flat faces as zero-area). Edit that one face and re-serialize; never call `rebuild_edges()` (renumbers the whole edge list). Preserve header bytes 0x20-0x2F when rewriting the RNM1 container.

Mod instance: a castle scene, face 4844. See [[xscene-declares-level-bit-mapping]] for reading `g5`.
