---
name: reloader-frozen-at-ammo-point-gate-hypothesis-falsified
description: A cannon reloader frozen centimetres from the ammo point, with a live move order that never becomes a use, is not explained by shouldEnablePickup or the load standing point.
type: incident
topic: siege-machines
tags: [artillery, reloader, ai, unsolved]
sources: [runtime-evidence/cannon-crew-bodyguard-fix-verification (2026-08-13)]
updated: 2026-10-18
---

# Reloader stuck beside the ammo point (UNFIXED root cause)

Observed on 1.4.7 in an attacker/defender siege with 12 cannons, over 449 mission seconds with no state change:
- Reloaders stood 0.19-0.32 m from `ammo_pos_g` with the AI move order live but never converting into a use.
- `AmmoPickUpPoints.Count == 1` and the point was active and usable.
- `ReloaderAgentOriginalPoint == ammo_pos_g` on all four stuck machines.
- The load standing point (`use_load`) was occupied by nobody on all 12 machines; it is distinct from the pilot point (`use_reload_fire_l`).
- Some machines showed machine-level `IsDeactivated = True` and `IsUsableBySide = False`; they were absent in the first sample and present from the second. Who calls `Deactivate()` is unproven.

Disproved: the `shouldEnablePickup` gate hypothesis (the gate was open). The user's report that killing the pilot unblocks the reloader is unexplained.

A different stall with a similar look was later solved: a loader that drops its ball en route latches `use_load` as `HasAIMovingTo` forever.

Related: [[artillery-detachment-weight-gated-on-ammo-point]]
