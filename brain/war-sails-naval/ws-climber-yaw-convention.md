---
name: ws-climber-yaw-convention
description: War Sails rope climbers face local X (yaw 0 starboard / pi port, climb_point at local -x, inboard); using +-pi/2 stands the ropes edge-on to the hull
type: reference
topic: war-sails-naval
tags: [war-sails, climber, rope, yaw, climb_point, ship]
sources: [memory/ws-climber-yaw-convention.md]
updated: 2026-10-18
---

# Rope climber orientation on War Sails ships

Vanilla `longboat_rope_climber_*_nested` instances use yaw ~0 on starboard and ~pi on port (plus small hull-following tilts), with `climb_point` at local **-x** (inboard). Local +Y is NOT outboard; assuming so and using +-pi/2 makes ropes perpendicular to the hull ("not parallel" reports).

**How to apply:** when placing new climbers, copy the vanilla frame. Remap child offsets (x,y)->(y,-x) when converting from the old +-pi/2 frame. Authoring scripts that regenerate the climber files must carry the fix or it regresses.

Related: [[ws-ship-navmesh-boarding-face-rules]]
