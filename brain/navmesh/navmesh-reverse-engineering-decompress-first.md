---
name: navmesh-reverse-engineering-decompress-first
description: Never reverse-engineer RNM1/ZGR6/OK01 by diffing the file bytes: the body is LZ4, so diffs show compression artefacts, not structure.
type: lesson
topic: navmesh
tags: [navmesh, reverse-engineering, trap]
sources: [old navmesh scripts: crash_bytes_*, probe_lz4.py, probe_nmg9*.py]
updated: 2026-10-18
---

# Decompress first, then analyse

An early analysis of navmesh.bin treated the body as raw bytes and reported "geometry chunks with F0/F1/F2 separators", a header field overflowing at 32760 as a siege nav-id limit, "islands merged when F0 count < 5", and "67 extra bytes before the terminal chunk". All were artefacts of diffing LZ4 output: a one-vertex change reshuffles every later compressed byte. Claims about big-endian float face centres and bytecode topology were likewise wrong.

The true format only appeared after decompressing ([[nmg8-nmg9-scene-navmesh-format]]). Rule: decompress, parse into structures, diff the structures.


Related: [[rnm1-container-format]]
