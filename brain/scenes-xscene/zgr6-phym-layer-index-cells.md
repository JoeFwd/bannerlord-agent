---
name: zgr6-phym-layer-index-cells
description: PHYM nodes are per-cell layer indices (0-based into xscene layer list); 0 is a safe uniform fill; not derivable from WGHT.
type: reference
topic: scenes-xscene
tags: [terrain, zgr6, physics-material]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings), bisect/phym_*.py]
updated: 2026-10-18
---

# PHYM physics-material grid

Node = `[u32 0, u32 res^2, 24 B header, res^2 x u8]` (66,596 B at res 129). Each cell byte is the layer index (0-based into the xscene `<layer>` list). Writing 0 everywhere is the safe uniform choice.

PHYM cannot be predicted from WGHT by a weight-based rule (bisect and held-out accuracy test failed). Whether the 24 header bytes are a per-node dominant-material palette is UNCONFIRMED.

Related: [[zgr6-terrain-bin-format]]
