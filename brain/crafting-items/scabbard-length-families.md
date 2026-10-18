---
name: scabbard-length-families
description: Scabbard meshes come in fixed length families (about -32/-39/-52/-64 mouth offset); a misfit is the wrong mesh assigned - swap holster_mesh, never trim a shared mesh; colour variants share geometry; tpac names are lowercase
type: lesson
topic: crafting-items
tags: [scabbard, length-family, holster_mesh, tpac, shared-assets]
sources: [memory/scabbard-length-families.md]
updated: 2026-10-18
---

# Scabbard length families

Scabbard meshes in a shared detail-kit FBX come in discrete **length families**, measured as the mouth's local Y offset from the shared blade pivot: `(scabbard.world.MinY - pivot) / scale`. Observed families: about -32.4, -39.7, -52.1, -64.5.

A scabbard fits when its `mouth_local` matches the blade's own `blade_local` (same formula on the Blade piece); a correctly paired weapon lands within about +/-0.35. 14 of 17 weapons in one mod already sat within that with stock meshes.

**A misfitting scabbard is almost always the wrong mesh assigned, not a mesh needing edits.** Swap `holster_mesh` in the Blade's `<BladeData>` to a mesh in the matching family. Do NOT trim the mesh: shared assets (one mesh served 4 weapons) mean geometry edits break every other user.

Colour variants within a numbered series **share identical geometry** (`03_red` and `03_black` both measure -52.14), so intended colour can be kept while changing family.

If all scabbard objects are already in the compiled `scabbards_geo.tpac`, a family swap needs **no tpac re-import** (contrast [[fbx-edits-need-tpac-reimport]], which applies only when the FBX changes). The tpac stores mesh names **lowercased**; a case-sensitive grep finds nothing, search case-insensitively.

Related: [[scabbard-holster-mesh-placement]], [[scabbard-mouth-metric-pitfall]]
