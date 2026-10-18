---
name: scene-transforms-lack-mesh-bounds
description: Scene (xscene) entity transforms give origins/yaw/scale but no mesh extents; nested entities compose parent transforms and some use non_orthogonal_rotation_mat, so bridge spans and building footprints cannot be derived from scene data alone.
type: lesson
topic: scenes-xscene
tags: [xscene, transforms, bridges]
sources: [src/.tmp/roman-corridor-design/README.md, src/.tmp/wye-relocation-candidate/REPORT.md]
updated: 2026-10-18
---

# Origins are not extents

- A scene reader exposes entity transforms only; compiled mesh bounds are unavailable. Pier anchor spans (e.g. 3.10 m) do not prove the rendered meshes meet, reach dry ground or line up with a nav deck.
- Nested entities (e.g. a bridge group under a town) use world transforms composed from parents; moving only some children breaks the assembly.
- Some objects store `non_orthogonal_rotation_mat`; naive child-end positions are not authoritative. Decode the matrix for axis/yaw.
- Pier world Z (~9.4-9.55) and deck nav Z (10.45) are different layers; matching Z across references is a placement hint, not proof of a physical deck top.
- To judge an object's expected reach, compare against many identical prefab instances (34 identical prefabs showed one pier 1.2 m short of the far bank).
- Hand-editing scene XML: keep LF endings and make byte-surgical edits; a scene-tool save round-trips the source exactly only after restoring line endings.

Related: [[navmesh-bridge-two-bank-route-gate]]
