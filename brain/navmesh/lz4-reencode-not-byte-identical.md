---
name: lz4-reencode-not-byte-identical
description: A navmesh or terrain file recompressed with a different LZ4 encoder decompresses identically but differs byte for byte, so byte-compare payloads, not files.
type: lesson
topic: navmesh
tags: [navmesh, lz4, verification]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-19
---

# Re-encoded LZ4 is valid but not byte-identical

The engine's LZ4 encoder output cannot be reproduced exactly by a standard high-compression encoder (about 94% of the engine's size at level 12). Round-trip decompress, compare payload bytes: that is the correct identity check. Do not diff compressed files to prove "unchanged".

Open: in-game load of a re-encoded RNM1 was still listed as untested in the tool docs. The ZGR6 writer (now on the studio's `scene-generation` branch), however, was in-game validated (see [[zgr6-terrain-bin-format]]).

Related: [[rnm1-container-format]]
