---
name: navmesh-editor-runtime-acceptance-checklist
description: Editor/runtime checks to run on a modified campaign navmesh before calling it accepted; static audits are not a substitute.
type: howto
topic: navmesh
tags: [navmesh, howto, validation]
sources: [sdd/scottish-navmesh/phase4/editor-runtime-checklist.md, phase6/editor-runtime-acceptance.feature.md]
updated: 2026-10-18
---

# Navmesh editor runtime acceptance checklist

Checklist used for a candidate navmesh (all items were NOT RUN at the time; static evidence only).

1. Load only the candidate as the scene's navmesh in a backed-up validation scene; confirm the active hash first. Do not copy RuntimeDataCache, distance caches, terrain or settlements. Expect clean parse and the expected face count.
2. Select Unconnected with the same filter and island seeds on baseline and candidate. Inspect land-only connectivity, not just the all-face water-inclusive result. Islands are intentionally separate; no new orphan land, no new inter-island link.
3. Mark Elevation Problem over every changed face and seam neighbourhood; record pre-existing problems separately.
4. Ensure Faces Not Below Ground only on a validation copy: it mutates the mesh. Never run it on the active scene.
5. Find Path both directions across each mountain pass with Mountain and Lake travel disabled; the exact path may differ from the recorded chain but must not cut Mountain or sea. Test several party sizes (a 6 m bottleneck is not 8 m clearance; do not claim otherwise).
6. Mountain vs passes: a land path to a blocked peak must be rejected or routed around; pass destinations stay accessible. Lake face count must not change.
7. Island repairs: path from existing navigable land to the editor-reported centroid of each repaired face (use the exact centroid, not a rounded coordinate near a shore).
8. Water-gap negatives: land points on either side of a water gap in different components must stay unreachable by land.
9. Then campaign routing, a fresh campaign, and a copied save.

Fail-closed rule: if no editor window or process exists, record the result as BLOCKED with the active and candidate SHA-256; disk hash equality does not prove what a running editor loaded. Do not click on a guessed window.

Related: [[navmesh-surgery-rules-for-existing-meshes]], [[xscene-declares-level-bit-mapping]], [[navmesh-presence-probe-in-rider]]
