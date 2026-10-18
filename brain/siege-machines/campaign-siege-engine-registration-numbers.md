---
name: campaign-siege-engine-registration-numbers
description: Native campaign siege machine type ids 0-7 are reserved; custom machines use 8 and up, and the map-icon projectile bone index depends on the skeleton.
type: reference
topic: siege-machines
tags: [siege, campaign-map, machine-type]
sources: [doc/adding-a-cannon.md]
updated: 2026-10-18
---

# Campaign siege engine registration numbers

- Campaign UI machine type ids: 0 wall, 1 broken wall, 2 ballista, 3 trebuchet, 4 ladder, 5 ram, 6 tower, 7 mangonel. A custom engine must use an id above 7, unique per engine.
- Map-icon projectile bone index: onager/catapult 2, ballista 7, trebuchet 4, bricole 20, unknown -1. When reusing the shared `trebuchet_a_mapicon_skeleton`, bone 0 (root) is right if the prefab has a `projectile_position` child; use another index only for a custom skeleton with a muzzle bone.
- Sprite sizes used by siege UI: 146x146 deployment icon, 30x23 map marker, 52x52 selection icon. Wrong sizes render visibly broken.
- Sound category for loud siege sounds must be `mission_siege_loud` or sounds are silently dropped.

Related: [[gauntlet-sprite-atlas-repack-workflow]]
