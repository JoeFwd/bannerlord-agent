---
name: editor-save-regenerates-terrain-bin-from-ok01
description: Opening a scene in the editor and saving rebuilds terrain.bin from terrain_ed.bin; patch both or back up terrain.bin first.
type: lesson
topic: scenes-xscene
tags: [editor, terrain, trap]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# Editor save overwrites your terrain.bin

If you edit terrain.bin (ZGR6) directly but leave a stale donor terrain_ed.bin, the editor shows the donor terrain and an editor save regenerates terrain.bin from it, destroying the runtime edit. Either patch OK01 in place (only vertices that differ by more than 3 height quantisation steps or 4/255 weight; keep the original as `.orig`) or back up terrain.bin before any editor save.

Extends [[xscene-editor-vs-runtime-data-split]]. Related: [[ok01-terrain-ed-format]]
