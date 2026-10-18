---
name: siege-weapon-release-angle-clamp-and-range
description: Ranged siege weapon elevation is clamped by MBMath.ClampAngle around (Top+Bottom)/2, so widening only the Bottom restriction never raises max angle; at a fixed cap range scales with muzzle velocity squared
type: reference
topic: siege-machines
tags: [ranged-siege-weapon, release-angle, muzzle-velocity, ballistics]
sources: [memory/cannon-trajectory-investigation.md]
updated: 2026-10-18
---

# Release-angle clamp and range

Native `MBMath.ClampAngle(angle, center, range)` clamps to `[center - range/2, center + range/2]` where `center = (Top + Bot)/2` and `range = Top - Bot` of the weapon's Top/BottomReleaseAngleRestriction. So the **maximum release angle equals `TopReleaseAngleRestriction`** regardless of Bottom: a prefab change from Top 0.2 / Bottom -0.1 to Top 0.2 / Bottom -0.5 only adds downward aim.

A weapon pinned at its elevation cap (here 0.2 rad, about 11.5 degrees) has range proportional to the square of muzzle velocity (`BaseMuzzleVelocity`): cutting 120 to 90 leaves (90/120)^2 about 56% of the range, and the player cannot compensate by aiming higher because aim is already at the cap. Symptom reports of "I must aim higher / shots fall short" after a re-balance should first compare muzzle velocity and the Top restriction in the prefab before suspecting formula changes. Gravity is `MBGlobals.Gravity = 9.806`; cannonballs set as `weapon_class="Boulder"` can have air friction zeroed by a patch on `GetAirFrictionConstant` for a pure vacuum parabola.

