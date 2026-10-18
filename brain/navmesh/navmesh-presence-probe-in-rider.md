---
name: navmesh-presence-probe-in-rider
description: Only Scene.GetNavigationMeshForPosition reliably answers "is there navmesh here" from the Rider evaluator; GetGroundZ is physics height and most path APIs are broken or lie
type: howto
topic: navmesh
tags: [navmesh, rider, evaluator, getnavigationmeshforposition, worldposition]
sources: [memory/navmesh-presence-probe-in-rider.md]
updated: 2026-10-18
---

# Probing navmesh presence from a paused evaluator

From a paused Rider evaluator inside a mission tick, the ONLY trustworthy test is `Scene.GetNavigationMeshForPosition(in Vec3, out int faceGroupId, float heightDifferenceLimit, false)`: `UIntPtr.Zero` / `faceGroupId == int.MinValue` means no nav face within `heightDifferenceLimit` of that z. Sweeping z at fixed x,y with a small limit (0.06) maps the navmesh heights of a column.

Corroboration: `new WorldPosition(scene, vec3)`, then `GetNavMeshZ()` **then** `GetNavMesh()`. Order matters: `GetNavMeshZ` runs `ValidateZ(ValidAccordingToNavMesh)`, which populates `_navMesh`.

**Traps:**
- `WorldPosition.GetGroundZ()` / `GetGroundVec3()` is physics/ground height; it returns a floor where there is no navmesh.
- `Agent.GetWorldPosition().GetNavMesh()` returns 0 for every agent (struct arrives `State == Valid`, so `ValidateZ` short-circuits). Rebuild from `agent.Position`.
- `Agent.GetPathDistanceToPoint(ref Vec3)` returns 1e30 even self to self.
- `Scene.GetNavMeshFaceIndex(ref PathFaceRecord, Vec3, bool)` returns -1 everywhere.
- `Scene.GetPathDistanceBetweenPositions` / `DoesPathExistBetweenPositions` collapse to 2D when the WorldPosition has no navmesh pointer (measured a "1.3 m path" across an 11.5 m vertical gap).
- `Scene.GetPathBetweenAIFaces(...)` throws `AccessViolationException`; never call from the evaluator.
- `Agent.GetCurrentNavigationFaceId() % 10 == 1` is a face GROUP id ("inside the fortification"), identical on every floor; do not use it to tell levels apart.

Multi-statement evaluation needs `((System.Func<string>)(() => { ... return s; }))()`; a bare block is `void`.

Related: [[navmesh-g5-level-bits-must-cover-all-castle-levels]]
