---
name: campaign-settlement-height-from-terrain-raycast
description: Campaign-map settlement entities take their Z from a physics raycast on the terrain (Scene.GetHeightAtPoint), not the navmesh; a settlement over terrain below water_level floats, fix by raising the heightmap
type: lesson
topic: campaign-map
tags: [campaign-map, terrain, water, settlement, heightmap]
sources: [dadg scotland terrain_island_plan.md]
updated: 2026-10-29
---

# Settlement height comes from the terrain, not the navmesh

Campaign-map settlement entities get their Z from `Scene.GetHeightAtPoint`, a physics raycast on the terrain. The navmesh height is not used. A settlement placed over terrain below the scene's `water_level` therefore looks like it floats on the sea.

**Fix:** raise the heightmap under the settlement above `water_level`. The shoreline forms wherever the terrain crosses `water_level`, so no water-mask edit is needed. Re-lifting the navmesh Z is only cosmetic. The heightmap can be edited offline with a ZGR6 writer ([[zgr6-terrain-bin-format]]).

**Texture trap:** sea-floor texels often carry a beach layer at full weight, so a newly raised island renders sandy until its terrain-layer weights are repainted to the base layer.

Related: [[map-settlement-position-two-files]], [[dadg-hebrides-island-float-terrain-fix]]
