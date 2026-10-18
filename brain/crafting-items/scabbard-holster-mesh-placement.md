---
name: scabbard-holster-mesh-placement
description: A crafted weapon's scabbard is the Blade piece's BladeData holster_mesh, placed at the Blade's own pivot (PiecePivotDistances[0]); two template flags suppress it; body placement and the quiver skeleton branch are unmodellable offline
type: reference
topic: crafting-items
tags: [scabbard, holster_mesh, blade, pivot, crafteddataview, quiver]
sources: [memory/scabbard-holster-mesh-placement.md]
updated: 2026-10-18
---

# Scabbard = Blade's holster_mesh at the Blade pivot

The scabbard is `<BladeData holster_mesh="...">` on the **Blade** piece (a MetaMesh name, not a raw mesh name). `CraftedDataView.BuildHolsterMesh` places it at `PiecePivotDistances[0]`, the Blade's own pivot (the value [[crafting-joint-gap-formula]] tooling already computes), and applies the Blade's scale factor. The origin offset happens **before** `frame.Scale`, and `MatrixFrame.Scale` touches only the rotation basis, so the pivot is never scaled.

Returns null (no scabbard) if the template sets `use_weapon_as_holster_mesh="true"` or `always_show_holster_with_weapon="true"`, or the Blade has no `holster_mesh`.

`holster_mesh_length` is inert in the non-skeleton path; it feeds only the skeleton (quiver) branch.

**Use:** offline scabbard-vs-weapon alignment (mouth vs guard, tip coverage, lateral centring) is computable with no new pivot math. Scabbard-vs-body is not: `item_holsters`, `default_item_holster_position_offset` and holster bones live on the human skeleton. The quiver/skeleton branch of `BuildHolsterMeshWithWeapon` (keyed on a `<name>_skeleton` model, `quiver_deformer` shader) is unreproducible; detect and mark unsupported.

Verified byte-identical between 1.4.6 decompiled source and shipped 1.4.7 DLLs. `TaleWorlds.MountAndBlade.View.dll` lives under `Modules\Native\bin\Win64_Shipping_Client\`; all TaleWorlds DLLs report FileVersion 1.0.0.0, so confirm version from `Modules\Native\SubModule.xml` ([[bannerlord-live-version]]).

Related: [[scabbard-length-families]], [[scabbard-anchored-to-blade-pivot]], [[scabbard-mouth-metric-pitfall]]
