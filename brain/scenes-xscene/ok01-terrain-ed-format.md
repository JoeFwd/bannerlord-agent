---
name: ok01-terrain-ed-format
description: OK01 terrain_ed.bin (editor-only terrain source) layout: header, column-major nodes, normals, heights, sparse weight layers.
type: reference
topic: scenes-xscene
tags: [terrain, format, ok01, editor]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# OK01 terrain_ed.bin

Header: `OK01`; 0x04 u32 size-12; 0x0C u32 version=2; 0x14 u64 usz; 0x1C u64 size-12; 16 B garbage; LZ4 stream at 0x34 (decompression consumed exactly the declared size on 108 scenes; lz4 round trip is byte-identical).

Payload: `u32 node_dim_x, node_dim_y`, then nodes walked column-major, each:
```
u32 node_x, node_y ; u32 mask[4] ; u32 res_x, res_y   (5/33/65/129/257/513)
f32 normals[N][4]   # 4th f32 is uninitialised padding, sometimes inf: copy, never read
u32 res header repeat
f32 blockB[N]       # all zero in 104/108 scenes, meaning unknown
u32 layer_res[32]   # 16-slot palette capacity table
f32 heights[N]
u32 nlayers ; nlayers x { u32 layer_index (1-based) ; f32 weights[N] }
```
Traps: [[ok01-orientation-and-palette-traps]]. Normals are derivable: [[terrain-normals-derivable-from-heights]].

Coverage: 392 of 494 terrain-bearing vanilla scenes (79%) ship compiled-only (SandBoxCore 196, SandBox 128, Native 63, StoryMode 4); only 102 have a terrain_ed.bin. ZGR6 to OK01 is a lossy decompile.

Related: [[zgr6-terrain-bin-format]], [[xscene-editor-vs-runtime-data-split]]
