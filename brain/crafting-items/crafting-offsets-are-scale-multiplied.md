---
name: crafting-offsets-are-scale-multiplied
description: BuildData offsets are multiplied by the CraftedItem's scale_factor, and a Pommel's piece_offset is positive-downward (away from the blade)
type: lesson
topic: crafting-items
tags: [crafting, buildata, scale_factor, pommel, offsets]
sources: [memory/crafting-offsets-are-scale-multiplied.md]
updated: 2026-10-18
---

# Offsets are scale-multiplied; pommel offset sign

`BuildData` offsets are **not** raw world units in the assembled weapon: they are multiplied by the piece's `scale_factor` in the `CraftedItem`. Measured on a messer pommel (2026-08-06) at `scale_factor="90"`: `piece_offset="14.157"` moved the pommel **12.742** in the render (14.157 x 0.9 = 12.741). Solve in assembled units, then divide by the scale factor before writing XML.

Sign convention for `piece_type="Pommel"`: **positive `piece_offset` moves the pommel DOWN**, away from the blade, measured along the grip direction (not world +y).

Placement model (confirmed to 3 decimals against `render.json`):

```text
attach          = handle_pivot - (handle.length/2)*s_h + handle.previous_piece_offset*s_h
pommel_origin   = attach - (pommel.length/2)*s_p
pommel_mesh_y   = pommel_origin + (local_mesh_y - pommel.piece_offset)*s_p
```

This retro-explained an old hilt `previous_piece_offset="-9.91"`: -9.91 x 0.9 = -8.919 assembled against -8.851 needed, leaving the familiar ~0.07 residual.

**Why:** without the scale factor you solve a lever, write the number and land ~10% short, then mistake the residual for a second defect.

**How to apply:** never guess an offset's sign or units. Render once at 0, once at a round value, compute `delta_assembled / delta_offset` (signed scale directly), solve in closed form, and verify against `render.json` `axis_extent`, not the picture alone.

Related: [[handle-length-drives-both-joints]], [[handle-piece-offset-semantics]], [[crafting-joint-gap-formula]], [[split-mesh-seam-is-ragged]]
