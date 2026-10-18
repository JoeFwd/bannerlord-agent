---
name: main-map-override-last-module-wins
description: SandBox.MapScene.GetMainMapModule picks the last active module containing SceneObj/Main_map/scene.xscene.
type: reference
topic: campaign-map
tags: [campaign-map, modules]
sources: [native_rivers/findings.md]
updated: 2026-10-18
---

# Main_map override mechanism

`MapScene.GetMainMapModule()` returns the last active module that ships `SceneObj/Main_map/scene.xscene`. That is how DLCs and total conversions replace the campaign map: load order decides, and a mod map must come after the module it overrides.

Related: [[campaign-navmesh-river-lake-conventions]]
