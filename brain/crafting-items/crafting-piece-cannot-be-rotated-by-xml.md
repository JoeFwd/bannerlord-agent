---
name: crafting-piece-cannot-be-rotated-by-xml
description: A crafting piece's orientation is 100% baked into its mesh - no XML attribute rotates it and the engine places every piece with Mat3.Identity
type: reference
topic: crafting-items
tags: [crafting, craftingpiece, rotation, mesh]
sources: [memory/crafting-piece-cannot-be-rotated-by-xml.md]
updated: 2026-10-18
---

# No XML rotation for crafting pieces

Verified against shipped 1.4.x sources on 2026-08-06.

`CraftingPiece.Deserialize` (TaleWorlds.Core) reads exactly three `BuildData` attributes, `piece_offset`, `previous_piece_offset`, `next_piece_offset`, all axial scalars multiplied by `0.01f`. The full `<CraftingPiece>` schema is `id / name / tier / piece_type / mesh / culture / length / weight / is_unique / is_default / is_hidden / full_scale / excluded_item_usage_features / required_skill_value` plus child nodes `StatContributions`, `BladeData`, `BuildData`, `Materials`, `Flags`. **Nothing angular.**

`BuildWeaponMesh` (TaleWorlds.MountAndBlade.View) places every piece with `Mat3.Identity` and a pure translation `PiecePivotDistances[pieceType] * Vec3.Up`. The only rotation in the path is `RotateAboutForward(PI)` on *holster* meshes when `RotateWeaponInHolster` is set. `full_scale` only switches scaling between `Vec3.One * sf` and `(1, 1, sf)` (default true for Guard and Pommel); it is not a rotation.

**How to apply:** a wrong-facing piece is always a mesh problem: mirror or rotate the vertices in the FBX and re-import ([[fbx-edits-need-tpac-reimport]]). A pure x-mirror leaves y and z untouched, so tuned `BuildData` offsets stay valid; confirm with FBX bboxes (`game_y`/`game_z` bit-identical).

Related: [[crafting-offsets-are-scale-multiplied]], [[split-mesh-seam-is-ragged]], [[crafting-contact-profile-check]]
