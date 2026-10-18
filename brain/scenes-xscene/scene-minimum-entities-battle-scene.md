---
name: scene-minimum-entities-battle-scene
description: Minimum content for a loadable battle scene (terrain, flora stub, navmesh, borders, spawn set, tactical regions, sound/reflection).
type: reference
topic: scenes-xscene
tags: [scenes, battle]
sources: [docs/scene-authoring-reference.md]
updated: 2026-10-18
---

# Minimum battle scene

Modelled on a vanilla ~82-entity inline battle scene (no prefab references): terrain, flora stub, navmesh, `border_soft` / `border_1` / `barrier_path_*`, the `sp_battle_set` hierarchy, reinforcement spawns, TacticalPosition/Region, AmbientSoundEmitter, ReflectionCapturer.

Navmesh doc rules: 1.5 m clearance; the navmesh must contain spawn point pivots; dynamic ids 0 basic, 1 raid, 2 walkable, 3 animal isolation. A `spawnpointdebug` entity helps validate scenes.

Related: [[siege-scene-hard-requirements]], [[scene-registration-by-folder-name]]
