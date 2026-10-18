---
name: seaborne-village-raid-scene-checklist
description: Acceptance checklist for turning a village mission scene into a War Sails seaborne-raid variant, plus the map-side requirement that makes a village sea-accessible at all.
type: howto
topic: war-sails-naval
tags: [war-sails, raid, scenes, navmesh]
sources: [src/.tmp/seaborne-village-raid-plan-updated.md]
updated: 2026-10-18
---

# Seaborne raid scene variant

Map side: a village is only reachable from sea if it has BOTH port coordinates in settlements.xml and a tagged village sea drop-off on the campaign scene. A coastal-looking mission scene alone does nothing.

Per scene variant:
1. Copy SceneObj + SceneEditData to a NEW scene id; keep the original for villages without sea access.
2. Add `land_raid` and `naval_raid` levels; keep the ordinary battle set on `land_raid`; add the NavalDLC raid battle set (defenders on land, three attacker ship formations in navigable water).
3. Naval navmesh: land faces id 0 and shallow water faces no deeper than 1.4 m below the water surface; every spawn, landing, jumping, defender view, tactical, archer and flee point inside soft borders and on the active naval mesh.
4. Three spaced `landing_00x_0` shore points with child `jumping_00x` points and approach route nodes facing the next; ChokePoint with child Cliff, strategic archers, defender `player_spawn_frame`, atmosphere and sounds.
5. Validate XML, compare navmesh topology to source, inspect offline, then run a real raid mission. Reassign a village only when static checks pass.

Design hint: measure water depth vs bank height first (a bank rising 4.8 -> 15 m over a short distance needs a graded dock; a one-ship-wide winding river needs widening in both runtime and editor terrain copies). Offline checks do not prove ships dock or agents fight.

