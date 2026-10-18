---
name: seaborne-raid-scene-requirements
description: What a village scene needs for sea-side raids: levels, navmesh faces, landing points, and world-map drop-offs.
type: reference
topic: war-sails-naval
tags: [war-sails, scene, navmesh, village]
sources: [doc/seaborne-village-raid-plan.md]
updated: 2026-10-18
---

# Seaborne raid scene requirements

Spec used for seaborne village raids (War Sails):

- Scene levels `land_raid` and `naval_raid`.
- A naval ID-0 navmesh whose shallow faces are at most 1.4 m deep.
- Three `landing_00x_0` entities with `jumping_00x` children for disembarking.
- ChokePoint and Cliff entities for AI limits.
- On the world map, drop-off points plus port coordinates are required before ships can reach the village from sea.

Test each village scene individually: a village missing any of these falls back to a land raid or leaves ships stuck.

