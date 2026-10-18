---
name: navmesh-vertex-touch-is-not-an-edge-connection
description: Two navmesh faces that share only a vertex are not connected; the engine walks shared edge ids, so T-junctions create orphan islands.
type: lesson
topic: navmesh
tags: [navmesh, t-junction, connectivity]
sources: [src/doc/framlingham-siege-stall-diagnostic.md]
updated: 2026-10-18
---

# Navmesh vertex touch is not an edge connection

Navmesh connectivity is computed over shared edge ids, the way the engine walks face to face. A face that touches the main mesh at a single vertex (distance 0.000 m) but shares no edge cannot be traversed: it is an orphan island, even though a vertex distance check says "connected". Analyse components over edge ids, not over vertex proximity.

Useful analysis rules learnt in a castle-siege stall investigation:
- A real point-in-polygon test with z interpolated on the face plane is required; centroid proximity yields false positives.
- A scene may ship two near-duplicate navmesh variants distinguished by a level bitmask; one variant's tower can be an orphan island while the other is connected. Read the scene's `<levels>` declaration before decoding the mask.
- Agents standing at a spot where `GetNavigationMeshForPosition` returns null cannot be pathed at all; defenders there never move, attackers pile up at the nearest reachable cell.

Related: [[xscene-declares-level-bit-mapping]], [[navmesh-presence-probe-in-rider]]
