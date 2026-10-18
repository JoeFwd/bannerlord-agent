---
name: zgr6-wght-needs-16-slots
description: Every WGHT node must carry all 16 slot entries; fewer makes the loader read past the node buffer (access violation on scene load).
type: lesson
topic: scenes-xscene
tags: [terrain, crash, zgr6]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings), bisect/wght_slots.txt]
updated: 2026-10-18
---

# WGHT: always 16 slots per node

Each node is exactly 16 slots, each `u32 count` followed by `count x (u32 png_len; PNG)`. Vanilla nodes always have all 16 slot flags. A node with fewer slots makes the native reader run past its buffer and crash on load. Write empty slots with count 0.

Related: [[zgr6-terrain-bin-format]], [[xscene-terrain-node-records-must-match-terrain-bin]]
