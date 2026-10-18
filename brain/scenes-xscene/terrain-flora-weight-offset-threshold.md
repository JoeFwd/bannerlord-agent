---
name: terrain-flora-weight-offset-threshold
description: Scene grass/bushes are usually terrain-layer flora - a layer mesh spawns only where the weight mask exceeds weight_offset*255; cap the layer below that, never zero it (it often paints the ground texture too)
type: lesson
topic: scenes-xscene
tags: [terrain, flora, weight_offset, layer, xscene, grass, bushes]
sources: [memory/terrain-flora-weight-offset-threshold.md]
updated: 2026-10-18
---

# Terrain flora spawns above weight_offset * 255

Grass and bushes in a scene are usually **terrain-layer flora**, not `flora.bin` records nor `scene.xscene` entities. Each `<mesh>` inside a `<layer>` of the `<terrain>` block carries a `weight_offset`; it spawns only where the layer's weight mask exceeds `weight_offset * 255`.

**Worked case:** bushes through spectator deck floors and fence bays came from slot 6 `7_forest_flora`, whose `shrub__mix` has `weight_offset` 0.900, threshold 229/255. Platforms sat at exactly 255, the accepted floor at 201: that threshold was the whole defect. The obvious suspect `8_bushes_tall_grass` measured 0 within every prop radius.

**Why not zero it:** the emitting layer is often also the layer painting the *correct ground texture*; zeroing strips the floor. Capping below the threshold kills the flora and keeps the texture.

**How to apply:**
- Read each layer's `<mesh weight_offset=...>`, convert to 0-255, sample the mask at the offending spot vs. a good spot. Don't guess from layer names.
- **Cap, don't zero:** just under the lowest `weight_offset*255` among the layer's meshes (120 clears every mesh at offset 0.5).
- Weights are NOT normalised: independent 0-255 opacity masks (per-sample sums 0-1562). Do not renormalise.
- Refill cleared areas by tiling the mottle from a known-good region, not a flat fill (visible rectangle otherwise). Feather prop-clearance radii (about 2 m).
- `flora.bin` is a different thing, a manual placement brush; check its census before blaming it.

Mask geometry is per node: a 6x6-node scene with 100 m nodes and 129x129 samples per node per layer gives one sample = 0.78125 m.

Editing `terrain.bin` alone desyncs the editor half ([[xscene-editor-vs-runtime-data-split]]); `terrain_ed.bin` lives in `SceneEditData/<scene>/`, NOT `SceneObj/<scene>/`. Tooling: [[navmesh-studio-tool]]. Mod case: a custom joust scene, 2026-08-18.
