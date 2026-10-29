---
name: ws-ship-deck-stairs-need-collision
description: A ship navmesh ramp up to a raised deck is not walkable on its own; it needs physics-only collision boxes (bo_editor_cube, unit box) under the ramp, or agents fall through or stall at the stair foot
type: lesson
topic: war-sails-naval
tags: [war-sails, navmesh, stairs, collision, bo_editor_cube, ship-prefab]
sources: [DADG kogge/carrack deck work 2026-10-23]
updated: 2026-10-23
---

# Ship deck stairs need collision under the navmesh ramp

A navmesh ramp only tells the AI where it may path. Agents still stand on **physics**. If the hull mesh has no stair geometry under the ramp, agents walk off the ramp's support and fall through, or stall at the bottom of the stair.

**Fix:** add physics-only stair treads under the ramp. These are entities with `<physics><shape value="bo_editor_cube"/>`, no visible mesh, scaled per tread.

- `bo_editor_cube` is a **unit box**: x and y run from −0.5 to +0.5, and z runs from **0 to 1**. Its origin is on the bottom face, not at the centre.
- Tread top = position.z + scale.z. Keep it flush with the navmesh ramp height at that y.
- Put the treads under a holder that already moves with the ship, e.g. the prefab's `mesh_holder` child, with mobility 1.

**Check:**
- Sample the ramp height along the stair and compare it with the tread tops. They should agree within about 0.1 m.
- A ramp steeper than about 45° plays like a ladder.

Related: [[ws-ship-navmesh-boarding-face-rules]], [[navmesh-faces-must-be-tris-or-quads]]
