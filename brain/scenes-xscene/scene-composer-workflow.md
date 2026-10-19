---
name: scene-composer-workflow
description: Programmatic scene composition: SceneBuilder API, outputs, heightmap indexing, and the GUID-subset assertion.
type: howto
topic: scenes-xscene
tags: [scenes, tool, composer]
sources: [docs/scene-composer-design.md, blscene/compose.py]
updated: 2026-10-19
---

# Scene composer (blscene)

The composer, corpus harvesting and the ZGR6 terrain writer were removed from the studio's `develop` branch. They live on its `scene-generation` branch; check that branch out to use this API.

`SceneBuilder`: new_battle, from_scene, regenerate_terrain(keep_navmesh), add, copy_entities, add_flora, build. Outputs: scene.xscene, terrain.bin, flora.bin, atmosphere.xml, references.txt, navmesh.bin plus provenance.json/.md.

- Height arrays are indexed `[row=Y, col=X]`, row 0 at the south edge, shape `n*128+1`.
- Terrain stamping blends with a cosine falloff and shifts vertically relative to the border mean.
- `build()` raises if used group GUIDs are not a subset of declared ones ([[xscene-orphan-group-guid-crash]]) and warns when `sp_*` entities lie outside the terrain.

Related: [[navmesh-studio-tool]], [[xscene-terrain-node-records-must-match-terrain-bin]]
