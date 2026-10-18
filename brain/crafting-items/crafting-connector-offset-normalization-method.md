---
name: crafting-connector-offset-normalization-method
description: Method for normalising crafting piece connectors across a template: seam sign, scale-weighted cancellation, fallback by removing UsablePieces.
type: howto
topic: crafting-items
tags: [crafting, howto, decision]
sources: [sdd/action-plan task-004a..e, 005a, 005b reports]
updated: 2026-10-18
---

# Crafting connector offset normalization method

Seam convention in the audit: negative seam = overlap, positive = visible gap. Connector fields: `previous_piece_offset` / `next_piece_offset`.

Procedure used on sword, axe, mace, two-handed melee, halberd and two-handed sword templates:
1. Run the physical pair audit (all adjacent matrices per joint) and group contradictions per piece family.
2. Shift one family's connector on one side AND the matching opposite-side piece so the canonical authored item keeps its length and pivots. Cancellation must be scale-weighted: with shaft scale 1.10 and head scale 0.80, a head correction of +21.22 pairs with a shaft value of -15.432727 (-15.43*1.10 + 21.22*0.80 ~= 0). Equal shifts change reach.
3. If a family cannot be reconciled (e.g. a guard-to-blade convention forcing -6.9 to -8.9 penetration against every other pool member), do NOT offset-hack. Remove that family's piece ids from the template `UsablePieces` only. The piece defs and global-id CraftedItems stay and still render. Do not create new templates.
4. Hide a piece from the UI with `is_hidden="true"` on the global CraftingPiece (applies to every template referencing it).
5. Verify at scales 90/100/110, not only 100; each positive over-tolerance candidate needs side/front/top inspection (all 130 in the final sweep were loose bounds, none real).

Gotchas: a trial +3.0 on one blade worsened a seam; an equal-and-opposite shift on a staff changed reach; the audit tool's scale option must apply to ALL pieces including placeholders; intentionally empty placeholder slots collapse and have no render.

Related: [[crafting-offsets-are-scale-multiplied]], [[handle-piece-offset-semantics]], [[crafting-joint-gap-formula]], [[crafting-contact-profile-check]], [[fbx-edits-need-tpac-reimport]]
