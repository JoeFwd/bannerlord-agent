---
name: siege-spawner-scene-requirements
description: A custom siege machine spawner must sit near a siege_deployment_placeholder and have the right upgrade-level visibilities or it is silently unavailable.
type: howto
topic: siege-machines
tags: [siege, spawner, scene, editor]
sources: [doc/adding-a-cannon.md]
updated: 2026-10-18
---

# Siege spawner scene requirements

For any siege machine spawner placed in a scene:

1. Place it near an existing `siege_deployment_placeholder`. Select the placeholder: valid spawners highlight red. If not highlighted, the machine is not offered in battle.
2. Upgrade Level Visibilities: `siege`, `level_1`, `level_2`, `level_3` enabled; `base` and `civilian` disabled. Mobility `Dynamic`.
3. Rotation is yaw in degrees in the inspector. Attacker spawners go in the camp with line of sight; defender spawners on battlements.
4. Mind the forward-axis rule in [[siege-spawner-forward-axis-must-face-away-from-walls]].

One spawner prefab can serve both sides; set `Team` per placement in the entity inspector.

Related: [[siege-spawner-forward-axis-must-face-away-from-walls]]
