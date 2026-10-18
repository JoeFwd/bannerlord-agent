---
name: nmg8-nmg9-scene-navmesh-format
description: Decompressed NMG8/NMG9 polygon navmesh layout: vertices, 24/20 byte edges, variable-size face records with fields g1-g6.
type: reference
topic: navmesh
tags: [navmesh, format, nmg9]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# NMG8 / NMG9 polygon navmesh payload

```
magic ('NMG8' | 'NMG9')
u32 vertex_count ; vertex_count x (f32 x, y, z)   # Z is up
u32 edge_count   ; edges
u32 face_count   ; faces
footer: u32 32 + 256 zero bytes
```

- Edge: NMG9 = 24 B `(-1, va, vb, -1, -1, 0)`; NMG8 = 20 B (no trailing u32). The `-1` slots are runtime adjacency, always -1 on disk.
- Face record (4 + 8n + 21 bytes, unaligned):
  `u32 n; n x u32 vertex idx; n x u32 edge idx; i32 g1=2; i32 g2=0; i32 g3; i32 g4=0; i32 g5; u8 g6`
- Every edge is referenced by one face (border) or two (interior). Winding is counter-clockwise viewed from +Z.
- A parser should reject n outside 3..64, unexpected edge fields and a wrong footer.

Loader crash classes: n-gon faces ([[navmesh-faces-must-be-tris-or-quads]]) and duplicate-corner faces ([[navmesh-duplicate-corner-face-crash]]).
Field meanings: [[navmesh-face-field-meanings-g1-g6]].

Related: [[rnm1-container-format]], [[nmg8-navmesh-prefab-format]]
