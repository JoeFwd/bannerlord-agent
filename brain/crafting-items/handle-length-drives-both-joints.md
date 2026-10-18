---
name: handle-length-drives-both-joints
description: A Handle's declared length moves the pommel AND guard attach points symmetrically (+/-length/2 about pivot), so length cannot fix one joint without breaking the other - use previous_piece_offset
type: lesson
topic: crafting-items
tags: [crafting, handle, length, previous_piece_offset, pommel, guard]
sources: [memory/handle-length-drives-both-joints.md]
updated: 2026-10-18
---

# Handle length moves both joints

A `piece_type="Handle"` places both neighbours at `pivot +/- length/2`: Pommel at `pivot - length/2`, Guard at `pivot + length/2`. Changing `length` moves the two joints in opposite directions by the same amount; no `length` fixes a single joint.

`previous_piece_offset` on the Handle moves ONLY the pommel joint, 1:1 in raw units, leaving guard, blade and `weapon_length` untouched. That is the correct lever (`next_piece_offset` moves only the guard joint).

Measured on an off-centre hilt (mesh spans -15.834..+5.988 about pivot 0, off-centre by -4.923, the handle analogue of an off-origin blade):

| length | prev_offset | weapon_length | Guard pos | Pommel to hilt |
|---|---|---|---|---|
| 12 | 0.0 | 91.297 | 4.277-7.145 ok | -9.910 bad |
| 21.822 (mesh extent) | 0.0 | 95.717 bad | 8.697 bad | -4.999 bad |
| 21.822 | -4.923 | 95.717 bad | 8.697 bad | -0.076 ok |
| 31.668 | 0.0 | 100.148 bad | 13.128 bad | -0.076 ok |
| **12** | **-9.91** | **91.297 ok** | **4.277 ok** | **0.000 ok** |

"Handles declare `length` == mesh extent" holds only for meshes **symmetric about their pivot**; for an off-centre mesh the two requirements diverge and matching extent is wrong.

**Detection:** in an `audit --all-pairs` run, this defect shows a **constant** gap against every pommel (all 13 at about -9.9) instead of a spread; a constant across partners means the handle is at fault.

**Gotcha:** a weapon whose own `CraftedItem` omits a Pommel hides the defect completely; it appears only when pieces are un-`is_hidden` into the shared bench pool. To see it, temporarily graft a Pommel onto the CraftedItem and render.

Related: [[handle-piece-offset-semantics]], [[crafting-joint-gap-formula]], [[blade-mesh-origin-inflates-reach]]
