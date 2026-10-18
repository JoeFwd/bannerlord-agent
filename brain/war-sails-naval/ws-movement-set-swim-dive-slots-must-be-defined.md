---
name: ws-movement-set-swim-dive-slots-must-be-defined
description: A movement set with swimming/diving action slots = -1 makes the native action lookup read off the table and crash the main tick when an agent enters diving mode.
type: incident
topic: war-sails-naval
tags: [movement-set, native-av, animation]
sources: [runtime-evidence/ws crash runs 2026-09-30 to 2026-10-01]
updated: 2026-10-18
---

# Native AV from undefined swim/dive movement slots (FIXED 2026-10-01)

Symptom: a native access violation in `Mission.Tick` via `IMBMission.Tick`, fault on a worker thread inside the native `GetAnimationIndexOfAction` (function RVA 0x5a4050, fault 0x5a4266 in TaleWorlds.Native 1.4.8). The action index was garbage (0x2c303030, ASCII "000,") read 0x48 bytes before the movement-set table.

Cause: a custom `full_movement_set` defined swimming and diving slots as -1 for some sets (long pike and firearm). An agent holding such a weapon (usage set `polearm_pike`) entering diving movement mode (mode 5) indexed table[-1]. Vanilla sets define `swim_unarmed` and `dive_unarmed`.

Fix: set swimming = `swim_unarmed` and diving = `dive_unarmed` for every set. Verified over a 30-minute sea battle with 0 AVs.

Disproved: the boarding-face navmesh fix and the coarse navmesh/climber yaw changes were suspected and were not the cause.

Method: [[cdb-native-av-capture-method]] (read frame-1 registers, decode the table row).

Related: [[cdb-native-av-capture-method]], [[war-sails-sail-cloth-requirements]]
