---
name: runtime-overlay-on-map-terrain
description: To paint runtime colours over campaign-map terrain, use small vertex-coloured meshes on vertex_color_mat; decals reject runtime textures and AddTriangle cost is quadratic in mesh size.
type: lesson
topic: campaign-map
tags: [mesh, decal, texture, vertex-color, overlay, performance, 1.4]
sources: [DADG doc/political-map-ui-proposal.md, live spike on 1.4.8 2026-10-27..29]
updated: 2026-10-29
---

# Runtime overlay on the campaign-map terrain

The working recipe for a runtime-coloured, translucent overlay draped over the map:

- Material `vertex_color_mat` (shader `notexture`, stock blend `AddAlpha`); `CreateCopy()` it.
- `Mesh.CreateMesh()`, `LockEditDataWrite`, then **`AddTriangleWithVertexColors`**.
  Plain `AddTriangle(..., color, ...)` leaves the mesh white.
- Translucency comes from the **vertex colour's alpha byte** (ARGB, `0x5A......` ≈ 35%).
  `GameEntity.SetAlpha` and `Mesh.SetColorAlpha` are ignored by this material.
- Heights from `scene.GetTerrainHeight(Vec2)` plus a small lift (0.3).
- Skip `ComputeNormals`/`ComputeTangents` (unlit shader); `RecomputeBoundingBox`, unlock,
  `GameEntity.CreateEmpty(scene, true, true, true)` + `AddMesh` per mesh.

## Traps

- **Build cost is quadratic in a single mesh's triangle count.** 2k triangles took 72 ms,
  8k took 1042 ms, and 131k froze the game for minutes. Split the geometry into meshes of at most
  about 512 triangles: 131k triangles in 256 meshes builds in 1.17 s, about 9 µs per triangle.
- **Map decals never render runtime textures.** `CreateFromByteArray`, `CreateFromMemory`,
  always-valid + preload and `Decal.CheckAndRegisterToDecalSet()` all fail; decals sample only the
  compiled decal atlas. Stock atlas textures tinted with `SetFactor1` do work
  (`decal_city_circle_a`, Modulate blend).
- Runtime textures *do* render on a mesh (all four creation paths), but no stock material found
  shows them in true colour:
  - `editor_map_border` masks the texture under a fixed green hatch.
  - `agent_label_with_tableau`, `tableau_with_alpha_mask` and `formation_icon` draw nothing on
    a terrain mesh.
- `MBMapScene.SetPoliticalColor` is a dead native stub: no visible effect for any argument.

Related: [[dadg-political-map-overlay]]
