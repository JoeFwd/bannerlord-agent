---
name: reimport-keeps-second-material
description: Modding Tools FBX reimport rebinds the primary material (slot 1) by FBX name but keeps the stale SecondMaterial (slot 2) GUID; audit slots separately and judge "white mesh" from slot 1
type: lesson
topic: meshes-textures-assets
tags: [fbx, reimport, material, secondmaterial, tpac, bindcheck]
sources: [memory/reimport-keeps-second-material.md]
updated: 2026-10-18
---

# Reimport keeps the stale second material

Observed 2026-10-02 after an alias reimport: slot 1 (Material) rebinds to the alias named in the FBX, but slot 2 (SecondMaterial) keeps the old GUID even though the FBX names only aliases. A bindcheck that counts both slots together looks like the reimport failed when it did not. **Judge "white mesh" from slot 1**; audit slots separately (a bindcheck script with `ALL=1` printing the slot per binding).

"Other" GUIDs in ship meshes were Native materials, which load first and are safe:

| GUID prefix | Native material |
|---|---|
| 39754eb5 | planks_6 |
| a962e60e | plank_b2 |
| bb774dec | crude_iron |
| 26733277 | planks_5 |
| 95776f9a | plank_b |

Related: [[tpac-material-binding-trailer]], [[ws-sail-cloth-params-frozen]]
