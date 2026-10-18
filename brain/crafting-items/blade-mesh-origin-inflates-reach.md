---
name: blade-mesh-origin-inflates-reach
description: Bannerlord crafted-weapon reach is computed from XML lengths/offsets, not mesh bounds - an off-origin blade mesh silently overstates reach
type: lesson
topic: crafting-items
tags: [crafting, reach, weapon_length, blade, origin]
sources: [memory/blade-mesh-origin-inflates-reach.md]
updated: 2026-10-18
---

# Off-origin blade mesh inflates reach

A crafted weapon's `weapon_length` (reach) is derived from the **declared XML** piece lengths and BuildData offsets. It never inspects the mesh. A blade whose geometry is authored off-origin gets a reach that does not match its visible blade: the hitbox extends past the tip you can see.

Measured on one mod's arming sword (2026-08-05): blade mesh centre was -5.353, declared reach **107.119** while the rendered tip sat at world **101.779**, about 5.3 units of phantom reach. After recentring the mesh origin and adding the same delta to `previous_piece_offset`, every piece stayed in an identical world position (tip 101.782, all 24 cross-pair gaps within 0.003) but declared reach became **101.769**, matching the visible tip to 0.013.

**Why:** this is the argument for fixing an off-origin blade in the DCC tool rather than papering over it with `previous_piece_offset`. The offset alone fixes the *visual* joint and leaves the *stat* wrong, and nothing in an audit/render JSON flags it. You only see it by comparing `weapon_length` against the max `axis_extent.max_y` across the render's pieces.

**How to apply:** when a blade mesh is off-origin, compare `weapon_length` with the rendered tip before deciding the BuildData fix suffices. If they disagree, fix the mesh origin (and remember [[fbx-edits-need-tpac-reimport]]).

Related: [[crafting-joint-gap-formula]], [[blender-fbx-roundtrip-breaks-scale]]
