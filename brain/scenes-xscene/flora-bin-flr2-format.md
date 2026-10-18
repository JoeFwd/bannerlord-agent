---
name: flora-bin-flr2-format
description: flora.bin (FLR2) record layout and the ground-clearance caveat when transplanting flora.
type: reference
topic: scenes-xscene
tags: [flora, format]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# flora.bin (FLR2)

`FLR2`, u32 total_size = file length - 8, u32 record_count; each record: `name_len, name, u32 kind (0-14), f32[12] 3x4 matrix, f32[3] position, f32[5] extra (RGBA tint)`. The 4th matrix column is 0 or FLT_MAX. An empty file is 12 bytes. Transplanting flora to new terrain needs a ground-clearance re-snap of Z.

Related: [[scene-minimum-entities-battle-scene]]
