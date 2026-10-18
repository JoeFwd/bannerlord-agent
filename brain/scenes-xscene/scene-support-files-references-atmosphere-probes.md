---
name: scene-support-files-references-atmosphere-probes
description: Companion scene files: references.txt manifest, atmosphere.xml, prt_data.bin - what is known about whether they are required.
type: reference
topic: scenes-xscene
tags: [xscene, files]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# Companion files

- `references.txt`: first line count, then `mesh <name>` lines (asset preload manifest). Copying a donor's verbatim goes stale but is harmless. Whether it is required is untested.
- `atmosphere.xml`: flat list; copy from a template scene.
- `prt_data.bin` (light probes): probably optional, unverified.

Related: [[scene-composer-workflow]]
