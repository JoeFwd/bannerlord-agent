---
name: ok01-orientation-and-palette-traps
description: OK01 vertex and node order are transposed relative to ZGR6, masks are per-node unions, and the layer palette is sparse and keyed by name prefix.
type: lesson
topic: scenes-xscene
tags: [terrain, ok01, trap]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# OK01 traps

- Vertex order is transposed: heights and weights are `[res_x][res_y]`; reshape then transpose to match ZGR6.
- Node order is transposed: `zgr6_index = node_y * node_dim_x + node_x`.
- The four masks are independent per-node layer bitmasks (equal in only 60/108 scenes). Stored weight planes are their union: `layer_index == bit + 1`.
- `layer_res` holds 16 contiguous slots, usually all 16 - it is not the declared layer count.
- The palette is sparse: the numeric name prefix in the xscene (`1_base`, `2_grass_flora`, `14_wet_flora`), not the list position, is the layer_index.

Related: [[ok01-terrain-ed-format]]
