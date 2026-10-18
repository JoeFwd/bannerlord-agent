---
name: xscene-terrain-node-records-must-match-terrain-bin
description: The xscene <terrain><nodes> records size the engine's buffers; stale or partial records cause out-of-bounds reads and a native crash on scene load.
type: lesson
topic: scenes-xscene
tags: [xscene, terrain, crash]
sources: [blscene/compose.py (_rebuild_terrain_nodes), bisect/dump_analysis.txt]
updated: 2026-10-18
---

# xscene node records must match terrain.bin

The engine sizes its terrain buffers from the xscene's per-node records: `heightmap_level` (log2 of cells per node), `weightmap_levels` and `layer_is_used_mask_{summer,fall,winter,spring}`.

Failures seen:
1. 257-px template records left on 129-px data: out-of-bounds reads, crash at scene load.
2. `weightmap_levels` written only for used layers: access violation inside TaleWorlds.Native once a mask bit activated a layer path. Register dump: two registers held 0x01010101, two held 0x4101 (16641 = 129^2), and mask value 3 was spilled twice on the stack - i.e. the layer-1 data buffer was uninitialised or the wrong size.

Rule that matches native scenes: set the mask to the WGHT-present slots (minus seasonal-only layers) and fill ALL 16 `weightmap_levels` at `heightmap_level`.

Related: [[zgr6-wght-needs-16-slots]]
