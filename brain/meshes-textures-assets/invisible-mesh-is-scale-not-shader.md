---
name: invisible-mesh-is-scale-not-shader
description: A mesh that renders in the modding tool but is invisible in game is usually millimetre-scale; measure the compiled tpac bbox (LZ4-compressed geometry) first, and fix via meta_mesh_component scale
type: lesson
topic: meshes-textures-assets
tags: [tpac, bbox, lz4, scale, meta_mesh_component, invisible]
sources: [memory/invisible-mesh-is-scale-not-shader.md]
updated: 2026-10-18
---

# Invisible mesh: suspect world scale before shaders

If a mesh is invisible in game but fine in the modding tool's inspector, suspect **world scale** before shaders, materials or import flags. The inspector auto-frames whatever it loads, so a 9 mm prop fills the viewport.

**Diagnosis:** read the compiled `_geo.tpac`, not the FBX.
- Geometry is **LZ4-block compressed**; the offset / uncompressed-size / compressed-size triple sits at about `0x1f4`. Raw byte scans find nothing and give false dead ends.
- The per-mesh header carries vertex count and **bounding box** (min/max float3). Compare against a known-good sibling mesh in the same scene.

**Worked case (2026-09-02):** a cannonball pile compiled to 9.3 x 9.2 x 1.3 mm with 1.25 mm balls, against a sibling `small_cannonball` at about 50 mm, roughly 40x too small. The vertex-colour alpha ramp was intact in the tpac, so shader, material and import flags were never at fault. Cause: Blender object scale 0.01 baked into the export ([[blender-fbx-roundtrip-breaks-scale]]).

A passing cull/shader test proves the shader works, never the world size.

**Fix:** `<meta_mesh_component name="..." scale="40.000, 40.000, 40.000"/>` in the prefab scales the **mesh only**, leaving child standing points and colliders in place (scaling the entity `<transform>` would drag them). Non-unit mesh scale is honoured and used by vanilla (Native `quest_props.xml` `item_highlight_cylinder scale="0.150, 0.150, 10.000"`, `inventory_character_scene` `scale="0.870, 0.870, 0.870"`). The durable fix is applying the object scale in Blender and re-exporting.

Related: [[cannonball-pile-white-is-ao-coef]]
