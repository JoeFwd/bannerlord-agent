---
name: settlement-scene-binding-by-wall-level
description: Settlement to scene binding via Location scene_name / scene_name_1..3, selected by wall level, falling back to the first.
type: reference
topic: campaign-map
tags: [campaign-map, settlements, scenes]
sources: [docs/siege-scene-design.md]
updated: 2026-10-18
---

# Settlement scene binding

`<Location id="center" scene_name=... scene_name_1=... scene_name_2=... scene_name_3=...>`. The wall level (from the `building_castle_fortifications` building) selects which loads; `Location.GetSceneName(upgradeLevel)` falls back to `_sceneNames[0]`. A new scene can therefore be test-bound by pointing all four attributes at it.

Related: [[siege-scene-hard-requirements]]
