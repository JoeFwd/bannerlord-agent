---
name: map-border-entities-bound-camera
description: The campaign camera pan limits, zoom cap and MapDiagonal come from the border_min and border_max entities in the map scene, not from terrain size.
type: reference
topic: campaign-map
tags: [camera, scene, borders]
sources: [runtime-evidence/scotland-camera-pan-north-bound (2026-07-28)]
updated: 2026-10-18
---

# border_min / border_max bound the map camera

`SandBox.MapScene.GetMapBorders` reads two scene entities named `border_min` and `border_max`: XY of each give the pan rectangle and Z of `border_max` is the maximum camera height. Fallbacks when absent are (900, 900) and 670. `Campaign` caches them as `MapMinimumPosition`, `MapMaximumPosition`, `MapMaximumHeight`.

Symptom: settlements placed beyond `border_max` Y cannot be reached by the camera even though terrain, physics and flora extend there. In one mod live values were (1000, 750), 620 while a town sat at y = 925.9.

Fix: edit the entity's position in the scene file (`border_max` Y 750 -> 1120). Consumers are only the camera clamp, the zoom cap and `MapDiagonal`; there is no navmesh, pathfinding or fog dependency, so moving the border is safe.

Related: [[map-settlement-position-two-files]]
