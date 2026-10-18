---
name: scabbard-anchored-to-blade-pivot
description: The holster follows the Blade pivot, so a blade seated too deep in the guard drags the scabbard over the cross; reseat by splitting distance_to_previous/next_piece (zero stat change), and never aim for seam == 0
type: lesson
topic: crafting-items
tags: [scabbard, blade, previous_piece_offset, distance_to_previous_piece, reach, seam]
sources: [memory/scabbard-anchored-to-blade-pivot.md]
updated: 2026-10-18
---

# Scabbard is anchored to the Blade pivot

For templates with `piece_type_to_scale_holster_with="Blade"` the holster is placed at the **Blade piece's pivot** and nothing else, so the mouth rigidly tracks the blade. A third failure mode beyond wrong-mesh-family ([[scabbard-length-families]]): the scabbard sheathes the blade perfectly but the *blade* sits too deep in the guard, so the mouth swallows the crossguard and touches the hilt.

**Do not aim for `Guard->Blade` seam == 0.** Seam = `blade.MinY - guard.MaxY`, and `guard.MaxY` is the bbox top, usually the **upturned quillon tips**, not the central block the blade seats on. Zeroing parks the blade level with the tips, floating (same bbox trap as [[scabbard-mouth-metric-pitfall]]). The real seat is the guard silhouette top in the columns under the blade, excluding the decorative nub; measure it off the render PNG (per-column topmost guard pixel, calibrated to world Y from two known piece bounds). Healthy swords have `blade.MinY - nub_top` **negative** (fleet -0.03 to -4.63, median -1.77): the blade sinks into the block.

`previous_piece_offset` on the Blade raises/lowers it (**positive pulls the blade DOWN**) but also changes reach. Engine (`CraftingPiece.Parse`, `CalculateWeaponLength`, TaleWorlds.Core): the pivot accumulates `+ScaledDistanceToPreviousPiece + ScaledPieceOffset - ScaledPreviousPieceOffset`; `weaponLength = piecePivotDistance[Blade] + ScaledDistanceToNextPiece`.

**Move the blade with zero stat change by splitting the distances.** `length="L"` is shorthand for `DistanceToNextPiece = DistanceToPreviousPiece = L/2`; give `distance_to_previous_piece` and `distance_to_next_piece` separately, adding X to one and subtracting X from the other. The pivot rises by X, reach is unchanged, and since `Length = next + previous` and `Inertia = 1/12 * Weight * Length^2`, both stay exactly as shipped.

Side effect: the visible blade extends X further while reach is unchanged, so `meshTip - reach` grows; no tight convention exists (fleet -14.1 to +9.0), a judgement call.

Related: [[handle-length-drives-both-joints]]
