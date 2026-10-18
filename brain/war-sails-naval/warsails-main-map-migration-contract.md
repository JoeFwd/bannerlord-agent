---
name: warsails-main-map-migration-contract
description: What a campaign map needs for War Sails/NavalDLC (v1.2.8): terrain ids, ports, bridges, water plane, caches, blockade and pirate setup.
type: reference
topic: war-sails-naval
tags: [war-sails, campaign-map, navmesh, reference]
sources: [plans/warsails-main-map-migration.md]
updated: 2026-10-18
---

# Warsails main map migration contract

Contract distilled from a migration plan. The plan was later executed in one mod (map repo commits from 2026-09-22; first non-crashing War Sails map 2026-09-29), but no per-item acceptance report exists.

Navmesh
- TerrainType ids in use: 1 land, 8 lake, 10/11 river, 18 CoastalSea, 19 OpenSea, 22, 23, 24, 25 (UnderBridge).
- Ports and drop points must sit on CoastalSea or River faces, never OpenSea.
- One contiguous id-25 UnderBridge component per bridge, joining both river sides. Bridge visuals fade via alpha/sail-alpha; `FoldSails` depends on wind angle.

Scene entities and tags
- Ports: `town_port` / `main_map_city_port`. Blockade: `town_blockade_start` / `_end` with `BlockadePositionScript`. Village drop points: `drop_point` / `main_map_village_dropoff`. Pirates: `PirateSpawnPoint`.
- `SettlementPositionScript` overrides feed `NavalPartyNavigationModel` and `NavalDLCMapDistanceModel`.
- Water plane: entity `naval_worldmap_water`, tag `snapped_water_body`, scripts `water_flowmap` and `CampaignMapAmbientOccluder`, plus a flowmap texture.
- Pirate spawn clearance used 7 OpenSea rings plus a 60 m edge margin.

Distance caches
- Three caches (Default / Naval / All) under `ModuleData/DistanceCaches`. A same-settlement gate/port pair yields NaN; repair to 0.5. Never copy caches from another map.
- Editor data (`terrain_ed.bin` under `SceneEditData`) is separate from runtime data.

Known engine trap: NavalDLC `ShipUpgradeCampaignBehavior.OnSettlementEntered` throws a NullReferenceException for a port town with no shipyard, so every port town needs one.

Related: [[ws-ship-navmesh-boarding-face-rules]], [[xscene-editor-vs-runtime-data-split]]
