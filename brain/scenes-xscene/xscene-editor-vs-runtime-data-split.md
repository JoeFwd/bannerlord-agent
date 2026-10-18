---
name: xscene-editor-vs-runtime-data-split
description: Bannerlord scenes store terrain/entities twice - editor source (terrain_ed.bin OK01, edit_mode_data) and runtime (terrain.bin ZGR6, other xscene nodes); editing only the runtime half leaves the game fine but the editor stale, and an editor save destroys the runtime work
type: reference
topic: scenes-xscene
tags: [xscene, terrain, ok01, zgr6, terrain_ed.bin, editor, lz4, index-transposition]
sources: [memory/xscene-editor-vs-runtime-data-split.md]
updated: 2026-10-18
---

# Editor source vs runtime scene data

| Concern | Editor source | Runtime |
|---|---|---|
| Terrain | `SceneEditData/<scene>/terrain_ed.bin`, magic `OK01` | `SceneObj/<scene>/terrain.bin`, magic `ZGR6RTRN`, chunked `MIDX`/`HGHT`/`NRML`/`WGHT`/`PHYM` nodes |
| Entities | `edit_mode_data` + `editor_data` nodes inside `scene.xscene` | every other node in `scene.xscene` |

The runtime **ignores** `edit_mode_data`/`editor_data`. A generator that rewrites only `SceneObj/` yields a scene that plays correctly but is stale or fatal in the Modding Kit editor ([[xscene-orphan-group-guid-crash]]).

**Why:** the two terrain formats are unrelated encodings, and no tooling *writes* `OK01` by default, so `terrain_ed.bin` tends to remain a verbatim donor copy (hash it against the donor: identical = zero edits landed).

**OK01 facts (read-decoded 2026-08-18, container and payload):** per node, f32 normals + heights + per-layer f32 weights. Validated on all 108 scenes of one install (exact payload consumption; heights match ZGR6 within one quantisation step). Documented in the navmesh studio's README ([[navmesh-studio-tool]]). Open: `blockB` (all-zero in 104/108) and what distinguishes the four per-node layer masks (four *independent* masks, not copies; stored weight planes are their union).
- `OK01` is the *source* format with more channels than `ZGR6`, so `ZGR6 -> OK01` is a **lossy decompile**, not a round trip. Still worth building: **392 of 494 (79%) terrain-bearing vanilla scenes ship compiled-only** (SandBoxCore 196, SandBox 128, Native 63, StoryMode 4), so a decompiler is the only way to open native terrain in the editor. Composer rule: generate OK01 first and compile ZGR6 down from it, never the reverse.
- **Writable in principle:** recipe is re-LZ4 the payload and re-emit the 0x34 header (`sz1 == sz2 == file_size-12`, pointer bytes ignorable); a re-encode lands at ~93-94% of TaleWorlds' size (their LZ4 differs, pointer bytes nonzero). No OK01 module existed in the tool (only `lz4raw` plus prose), so budget for writing the reader/writer. Normals are derivable: `normalize(-dh/dx, -dh/dy, 1)`, spacing `node_size/(res-1)`; recompute only where height changed. `ZGR6 NRML`'s blue channel is NOT z; the 4th f32 of an OK01 normal is uninitialised padding.
- **Repair method:** fold compiled heights + layer weights back into `terrain_ed.bin`, patching only vertices differing by >3 quantisation steps so untouched ones keep editor f32 precision.

**Index translation (both are transposes; verified 2026-08-18 by reading each node's stored `(node_x, node_y)`):** OK01 node order is column-major `file_index = node_x*dim_y + node_y`; ZGR6 is row-major `zgr6_index = node_y*dim_x + node_x`. Vertex order inside a node: `flat = ix*res_y + iy` (OK01) vs the transposed ZGR6 PNG. On a square grid some node indices coincide, hiding errors; always look up by `(node_x, node_y)` and assert. Decisive check: transposed height reads agree with ZGR6 `HGHT` to ~0.003 m, non-transposed are off by tens of metres.

**How to apply:**
- After any scripted scene edit, hash `terrain_ed.bin` against its donor.
- Warn before opening such a scene in the editor: it shows donor terrain, and **saving terrain there overwrites `terrain.bin`**. Back up `terrain.bin` first, or fold the edits back into `terrain_ed.bin`.
- Terrain node geometry lives in `scene.xscene`'s `<terrain>` element (`node_dimension_x/y`, `node_size`, `<layers>` table); it must agree with `terrain.bin`'s chunk table but is shared by both halves, so rarely the culprit.

Related: [[terrain-flora-weight-offset-threshold]]
