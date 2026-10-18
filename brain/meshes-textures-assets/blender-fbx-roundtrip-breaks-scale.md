---
name: blender-fbx-roundtrip-breaks-scale
description: Blender FBX export silently rescales Bannerlord meshes 100x in game unless apply_scale_options is FBX_SCALE_ALL/UNITS; the importer applies Lcl Scaling and ignores UnitScaleFactor; audit/render tools cannot detect either failure
type: lesson
topic: meshes-textures-assets
tags: [blender, fbx, scale, import, lcl-scaling]
sources: [memory/blender-fbx-roundtrip-breaks-scale.md]
updated: 2026-10-18
---

# Blender FBX round-trip and the 100x scale trap

Blender can safely round-trip Bannerlord FBX files, but **only** with the right exporter scale mode. Isolated 2026-08-06 by sweeping `bpy.ops.export_scene.fbx(apply_scale_options=...)` on a no-edit round-trip and diffing bytes:

| `apply_scale_options` | Result |
|---|---|
| `FBX_SCALE_NONE` (**the default**) | CORRUPTS |
| `FBX_SCALE_CUSTOM` | CORRUPTS |
| `FBX_SCALE_UNITS` | safe |
| `FBX_SCALE_ALL` | safe |

Use `apply_scale_options='FBX_SCALE_ALL', global_scale=1.0, apply_unit_scale=True`.

Corruption signature:

```text
original      UnitScaleFactor = 100.0   node Lcl Scaling = 1,1,1
corrupted     UnitScaleFactor =   1.0   node Lcl Scaling = 100,100,100
```

Blender converts cm to metres and compensates with a baked 100x node scale. **Net scale is unchanged**, so tools that resolve both factors (the crafting tool's `render`/`audit`) report every extent, centre and lateral offset as correct. The Modding Kit importer bakes geometry WITHOUT applying a compensating factor the same way, so the weapon is 100x oversized in game. In one case a sword passed a 100%-contact profile, a corrected `weapon_length`, an all-pairs audit and a visual render, and was still unusable. Tool-verified and game-verified are independent.

**Mandatory byte gate:** before accepting any exported FBX, run an `fbxscale.py` check on original and output. It searches the binary FBX for `UnitScaleFactor` / `OriginalUnitScaleFactor` / `Lcl Scaling` / `GeometricScaling` / `CoordAxis` / `UpAxis` and unpacks following `D` (LE f64) and `I` (i32) slots. Never accept a green render/audit as evidence on this axis.

## Mirror failure: un-applied object scale (100x too SMALL, found 2026-09-15)

```text
exporter bug (above)   Lcl Scaling = 100    -> 100x too BIG
un-applied scale       Lcl Scaling = 0.01   -> 100x too SMALL
healthy                Lcl Scaling = 1,1,1, or no model-level node at all
```

**The importer applies `Lcl Scaling` and ignores `UnitScaleFactor`.** Proven by diffing two versions of one FBX out of the Git LFS store: the healthy one had `UnitScaleFactor = 1` and no model-level `Lcl Scaling`; the bad one had `UnitScaleFactor = 100` with `Lcl Scaling = 0.01` and imported 100x small. So `UnitScaleFactor` is not the discriminator and is not worth asserting (this corrects the earlier "must still be 100.0" claim); the only invariant is that model-level `Lcl Scaling` is 1 or absent.

The Blender-side cause is a leftover 0.01 *object* scale. Fix with Alt+S (Clear Scale), NOT Ctrl+A (Apply Scale): applying a 0.01 object scale multiplies the vertices by 0.01 and bakes the tininess in. It is not an exporter flag, so `FBX_SCALE_ALL` does not prevent it.

**Do not trust a prefab `scale=` attribute as evidence of the true factor.** When a hand-tuned scale is not a clean unit conversion, find a shared primitive in a correctly-scaled asset and take the ratio.

Where a purely axial bad origin can be corrected with an XML `previous_piece_offset`, prefer that: zero risk, no tpac re-import. Reach/`weapon_length` errors genuinely require geometry. Compiled `Assets/**/*_geo.tpac` tracked in Git LFS means a bad re-import is recoverable with `git checkout <pre-corruption-commit> -- <path>`.

Related: [[crafting-joint-gap-formula]], [[fbx-edits-need-tpac-reimport]], [[crafting-contact-profile-check]], [[handle-length-drives-both-joints]], [[cannonball-pile-white-is-ao-coef]]
