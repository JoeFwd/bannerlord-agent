---
name: siege-spawner-forward-axis-must-face-away-from-walls
description: Native RangedSiegeWeapon aim math flips the machine frame 180 degrees, so a custom machine spawner must face away from the walls and its visual body needs a pi rotation.
type: lesson
topic: siege-machines
tags: [siege, cannon, spawner, orientation]
sources: [doc/adding-a-cannon.md]
updated: 2026-10-18
---

# Siege spawner forward axis must face away from walls

`RangedSiegeWeapon` AI computes its local aim angle (`CalculateLocalAnglesFromGlobalDirection`) with a hardcoded 180 degree flip of the root entity's frame. Therefore:

- the spawner's forward axis (blue arrow in the editor) must point toward the siege camp, away from the enemy walls;
- the `Battery_Base` child needs `rotation_euler Z = 3.14159` so that at AI angle 0 it faces the walls.

| Spawner | Battery_Base rotation | Result |
|---|---|---|
| away from walls | pi | correct |
| away from walls | 0 | starts correct, snaps 180 degrees away on first AI tick |
| toward walls | pi | frozen facing away; AI angle always pi and `AimAtTarget` blocks it |
| toward walls | 0 | faces away, AI blocked, stays |

All broken cases show the same symptom: the machine snaps to face away at battle start and never rotates. If the shot code bypasses the model orientation, the projectile still flies toward the walls, which makes the bug confusing. Model the barrel along +Y and handle world orientation in the scene editor.

Related: [[siege-spawner-scene-requirements]]
