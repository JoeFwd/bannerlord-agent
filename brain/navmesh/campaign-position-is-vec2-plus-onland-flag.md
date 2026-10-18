---
name: campaign-position-is-vec2-plus-onland-flag
description: CampaignVec2 stores a Vec2 plus an IsOnLand flag and selects the navmesh face by that flag, so land and water layers may overlap in 2D.
type: reference
topic: navmesh
tags: [campaign-map, navmesh, code-fact]
sources: [native_rivers/findings.md]
updated: 2026-10-18
---

# CampaignVec2 = (Vec2, IsOnLand)

The face is chosen by the flag, so Bridge (17, land layer) and UnderBridge (25, water layer) can occupy the same 2D area without conflict. A bridge is therefore authored as two stacked sheets, not one.

Related: [[campaign-navmesh-terrain-type-ids]]
