---
name: ws-sail-cloth-params-frozen
description: FIXED 2026-10-02 - sail cloth meshes keep importer-default cloth params (anchor 1, wind 1, damping 0.95) so the cloth is near-rigid; vanilla square_sail_a uses anchor 0, wind 15, damping 0.2; a fresh FBX import has no cloth settings at all
type: lesson
topic: war-sails-naval
tags: [war-sails, cloth, sail, clothingmaterial, force_enable_cloth, tpac, tpactool]
sources: [memory/ws-sail-cloth-params-frozen.md]
updated: 2026-10-18
---

# Sail cloth params live per mesh in the tpac

A read-only TpacTool.Lib dump (reflection over `Mesh`) compared seven mod `*_cloth` sail meshes with vanilla NavalDLC `square_sail_a`. The mod meshes kept the importer defaults (anchor 1, wind 1, damping 0.95: nearly rigid) and lacked the `force_enable_cloth` flag; their `*_burning` meshes had no cloth flags. Vanilla: anchor 0, wind 15, damping 0.2.

**Facts:**
- Cloth parameters are stored per mesh in the tpac. NavalDLC `cloth_materials.xml` holds only a roof preset.
- **Never binary-patch them; set them in the Cloth Editor.**
- A fresh FBX import creates the cloth mesh with no cloth flags or settings: tick "Use cloth" and set the values on each import.
- Fixed 2026-10-03: with all 7 set to vanilla values, in a live sea battle every sail had a non-null `SailClothComponent` and the sail deployed textured and billowing, **without** `force_enable_cloth`. No editor UI for that flag was found; "Always keep state" is NOT it; leave it.

**How to apply:** for "sail doesn't animate", dump the mesh `ClothingMaterial` and flags before suspecting SailVisual or prefab tags. A separate white-material problem is a material alias issue. If sails fly up like flags, it is vertex paint, not these params: [[ws-sail-vertex-paint-pins]].

Related: [[fbx-edits-need-tpac-reimport]]
