---
name: fbx-reexport-must-preserve-material-names
description: A Blender FBX re-export renamed materials (wood -> wood.001); restore exact material names and slot mapping or the compiled asset changes.
type: incident
topic: meshes-textures-assets
tags: [fbx, blender, materials, incident]
sources: [sdd/action-plan task-006/007a/007b reports and reviews]
updated: 2026-10-18
---

# Fbx reexport must preserve material names

Status: FIXED in the source FBX (2026-07); compiled TPAC regeneration was left to the user.

After a lateral recentre of one mesh, the regenerated TPAC showed attribute changes in all 106 child meshes. One visible cause: material datablocks were renamed on export (`wood.001`, `steel.001`, `Material.002`), and the importer rebinds by material name.

Fix and checks:
- Import old and new FBX into separate factory-reset Blender states (comparing in one session creates `.001` names itself).
- Restore the exact old names and per-object slot order; names like `Material.001` can be real baseline names.
- Compare 107 objects / 105 meshes: positions, UVs, colors, topology, face material indices, transforms. Material property hashes must match after renaming.
- Export settings that round-tripped exactly: binary FBX 7.4, scale 1.0, apply unit scale on, FBX_SCALE_NONE, forward -Z up Y, use space transform on, bake space transform off, smoothing OFF, no animation, no leaf bones.
- A TPAC/RDC change appears seconds after an FBX write because a watcher reimports; treat compiled files as a separate provenance step and decode the TPAC (Metamesh/MeshEditData) to compare per vertex.

Related: [[fbx-edits-need-tpac-reimport]], [[blender-fbx-roundtrip-breaks-scale]], [[reimport-keeps-second-material]]
