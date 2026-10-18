---
name: nmg8-navmesh-prefab-format
description: The prefab navmesh imported by Scene.ImportNavigationMeshPrefab is an uncompressed triangle NMG8, distinct from the RNM1 polygon navmesh.
type: reference
topic: navmesh
tags: [navmesh, format, prefab]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# NMG8 navmesh prefab

Used by `Scene.ImportNavigationMeshPrefab`. Uncompressed and size-prefixed:

```
u32 size - 4 ; 'NMG8'
u32 nv ; nv x (f32 x,y,z)
u32 nt ; nt x (u32 a,b,c)       # triangles only
```

Not the NMG8 inside an RNM1 scene navmesh ([[nmg8-nmg9-scene-navmesh-format]]), which holds polygon faces with attributes. Older viewer notes called the prefab "face data partially unknown"; it is fully decoded.

Related: [[rnm1-container-format]]
