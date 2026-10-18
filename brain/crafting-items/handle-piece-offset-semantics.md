---
name: handle-piece-offset-semantics
description: For a shaft mesh centred on its origin, hand_to_bottom = length/2 - piece_offset; piece_offset == length/2 puts the hand on the butt and shoves the weapon forward
type: lesson
topic: crafting-items
tags: [crafting, handle, piece_offset, hand_to_bottom, weapon_length]
sources: [memory/handle-piece-offset-semantics.md]
updated: 2026-10-18
---

# Handle piece_offset sets the grip position

For a `piece_type="Handle"` whose shaft mesh is authored **centred on its origin**, the assembled piece spans `piece_offset +/- length/2` with the hand at y=0, so:

`hand_to_bottom = length/2 - piece_offset`

`piece_offset = length/2` collapses `hand_to_bottom` to 0: rear hand exactly on the butt, the weapon reads shoved forward with the hand gripping empty air. Native never does this; `spear_handle_*` use a small constant `piece_offset` of about 22.9 regardless of shaft length. When a piece uses `distance_to_previous_piece`/`distance_to_next_piece` instead of `length`, effective length is `2 x distance_to_previous_piece`.

Expect: raising `hand_to_bottom` **reduces** reported `weapon_length`, since reach is measured from the grip forward. That is correct, not a regression.

Verify with the crafting tool (env `BANNERLORD_CRAFTING_TOOL`) `inspect`, reading `hand_to_bottom`.

Related: [[crafting-usage-vs-bench-list-rules]], [[crafted-weapon-stats-driven-by-weaponflags]], [[handle-length-drives-both-joints]]
