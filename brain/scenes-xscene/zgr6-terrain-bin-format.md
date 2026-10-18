---
name: zgr6-terrain-bin-format
description: ZGR6 terrain.bin layout: five LZ4 sections (MIDX/HGHT/NRML/WGHT/PHYM), node tables, per-node encodings.
type: reference
topic: scenes-xscene
tags: [terrain, format, zgr6]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# ZGR6 terrain.bin

Header `ZGR6RTRN`, version 2, then five 20-byte descriptors in order MIDX HGHT NRML WGHT PHYM, each `[tag][u32 count=1][u32 offset][u32 csz][u32 usz]`. Each section: optional node-offset table (u32, strictly increasing from 0, offsets into the uncompressed stream), a 32-byte stream header `{u32 mode=3, pad, u64 usz, u64 csz, u64 ptr}`, 8 B runtime garbage, then an LZ4 raw stream. The decompressor must tolerate trailing input (prefix decode).

- HGHT node: `u32 png_size` + 16-bit grayscale PNG, 129x129 for battle scenes (257x257 world map), 1 px overlap, row-major node order. `h = min + u16/65535*(max-min)`, min/max from the xscene `<terrain>` element.
- NRML node: 129x129 RGBA8, R = clip(round(127 - dh_dx/11.75)), G likewise, B = 63, A = 0.
- MIDX: 4 LOD PNGs (nx*256 square); 255 means material 0.
- WGHT: see [[zgr6-wght-needs-16-slots]].
- PHYM: see [[zgr6-phym-layer-index-cells]].

The writer was validated in game. Campaign-map orientation: X east, Y north, no flip.

Related: [[ok01-terrain-ed-format]], [[xscene-terrain-node-records-must-match-terrain-bin]]
