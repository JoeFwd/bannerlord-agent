---
name: crafting-joint-gap-formula
description: Bannerlord crafting joint-gap formula, why mesh bounds/seam gaps lie about visible blade-guard gaps, and how to decide which piece owns an offset error
type: lesson
topic: crafting-items
tags: [crafting, joint-gap, offsets, guard, blade]
sources: [memory/crafting-joint-gap-formula.md]
updated: 2026-10-18
---

# Joint-gap formula and its measurement traps

Logical gap at a crafting joint (verified against every joint of an arming sword):

`joint_gap = scaled_piece_offset(this) - scaled_previous_piece_offset(this) - scaled_next_piece_offset(previous)`

`scaled_* = raw * owner_scale`. A tool's `audit` sweep renders every candidate at **100%**, so a correction tuned at a piece's declared scale (e.g. a 95% guard) reads slightly differently there.

**Mesh-bounds measurements lie.** The crafting tool's `render` `seams[].axis_gap` and `audit` `visual_gap` compare **whole-mesh bounds**, so they are worthless at a blade/guard joint whose guard has raised quillon tips. A sword reported -1.52 "overlap" (dead on the mod median) while the blade visibly floated 1.23 units above the guard's central collar: the tips were taller than the blade base and swallowed the measurement. Only a pixel measurement of the colour-coded `render.png` (blade rows vs guard rows inside the blade's x-footprint) found it. A cropped, upscaled PNG of the junction is the acceptance evidence; JSON numbers alone pass a broken weapon (see [[crafting-contact-profile-check]]).

**Trap: front-face detail is not a support surface.** A guard's raised central boss looked like a recessed collar that no blade could seat on, tempting a cut of `next_piece_offset` 4 to 2.0. The boss is decorative on the front face and renders over the blade in depth; the real support plane is where the quillon arms meet, well below the boss apex. Seating a blade on a front-face detail leaves a big air gap under most of the blade width. Check a piece's **side view** in the `--render-dir` piece gallery before treating any high point as a support surface.

**Compensating an origin move is exact and 1:1 in raw units** regardless of the piece's scale percent (mesh and offset are both multiplied by owner scale): shift geometry +delta, add +delta to `previous_piece_offset`, and every world position, authored pair and all cross-pairs, is unchanged. See [[blade-mesh-origin-inflates-reach]] for why fixing the mesh is still worth it.

**Deciding ownership:** ask which mesh is wrong, not which number looks off. One blade wrong on every guard means blade `previous_piece_offset`; one guard wrong under every blade means guard `next_piece_offset`. Collapsing both onto one piece makes the authored pair render perfectly while every cross-pair breaks (what `is_hidden="true"` on a blade usually means). After editing, check the authored pair's junction crop *and* run `audit --template <T>` for cross-pairs.

See also [[handle-piece-offset-semantics]].
