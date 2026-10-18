---
name: map-settlement-position-two-files
description: A campaign-map settlement's position lives in TWO places that must stay in sync - settlements.xml posX/posY (+gate_pos) and the map scene's settlement capsule parent transform; scene has no BOM, settlements.xml has one
type: howto
topic: campaign-map
tags: [settlement, posX, gate_pos, xscene, capsule, bom]
sources: [memory/map-settlement-position-two-files.md]
updated: 2026-10-18
---

# Moving a map settlement edits two files

1. `ModuleData/settlements.xml`: `posX`/`posY` on `<Settlement>`. Towns and castles also carry `gate_posX`/`gate_posY`, to be shifted by the *same delta* (about 0.02 off the settlement pos, not independent).
2. The map `scene.xscene`: the settlement's capsule entity. Change only its `<transform position>`; the whole visual tree (child entity, decal, meshes, about 113 KB for a town) hangs off it as *relative* children, so the layout is preserved.

**Invariant to assert before and after:** `capsule.position.xy + child.transform.position.xy == settlements.xml posX/posY`, exactly (held to 1e-13 across 160 settlements in one mod; a reliable correctness gate).

**Z convention:** settlement root world z (capsule z + child z) was a flat 10.5 for 120 of 160, not terrain-following. When a move lands on higher ground, raise the capsule z; never lower it.

**Why:** editing only settlements.xml moves the party/click target but leaves the mesh behind; editing only the scene does the reverse.

**How to apply:** patch both in one pass keyed by settlement id, back both up, re-read and diff; the scene should differ by exactly one line per settlement.

**BOM gotcha:** `scene.xscene` has NO BOM; `settlements.xml` HAS one. Reading/writing both with `utf-8-sig` silently prepends a BOM to the scene.

