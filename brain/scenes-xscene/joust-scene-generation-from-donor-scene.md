---
name: joust-scene-generation-from-donor-scene
description: Generating a joust/tournament scene from a donor scene plus a navmesh produced through the navmesh studio API.
type: howto
topic: scenes-xscene
tags: [scenes, navmesh, howto]
sources: [sdd/dadg-joust-v3 reports]
updated: 2026-10-18
---

# Joust scene generation from donor scene

Approach that worked:
- Start from a donor tournament scene; translate everything uniformly so the arena is recentred, using 9-decimal XML precision so values match float32 vertices.
- Remove obstruction entities, widen the lists, merge `references.txt`, and keep `terrain_ed.bin` byte-identical to the donor (editor data is not regenerated).
- Build the joust navmesh through the navmesh studio tool API, then splice it into the scene.
- Verify with hash checks and a navmesh coverage/connectivity audit, not only visual inspection.

Related: [[navmesh-surgery-rules-for-existing-meshes]], [[xscene-byte-preserving-span-edits]]
