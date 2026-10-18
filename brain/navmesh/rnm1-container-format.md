---
name: rnm1-container-format
description: RNM1 navmesh.bin container layout: header, runtime-pointer garbage, LZ4 raw block stream holding an NMG8/NMG9 payload.
type: reference
topic: navmesh
tags: [navmesh, format, lz4]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# RNM1 navmesh.bin container

`navmesh.bin` is an RNM1 wrapper around an LZ4-compressed polygon navmesh.

| offset | content |
|---|---|
| 0x00 | magic `RNM1` |
| 0x04 | u32 file size - 8 |
| 0x08 | u32 version = 3 |
| 0x10 | u64 uncompressed size |
| 0x18 | u64 compressed size - 8 |
| 0x20 | 16 bytes of runtime pointer garbage (copy, never interpret) |
| 0x30 | LZ4 raw block stream (no size prefix) |

The decompressed payload begins with `NMG8` or `NMG9` ([[nmg8-nmg9-scene-navmesh-format]]).

Writing: re-compress with an LZ4 high-compression encoder with no stored size. The result is a valid LZ4 stream but NOT byte-identical to the engine's own encoder; the decompressed payload is byte-identical. See [[lz4-reencode-not-byte-identical]].

Related: [[navmesh-reverse-engineering-decompress-first]], [[zgr6-terrain-bin-format]]
