---
name: cdb-native-av-capture-method
description: How to capture and read a native access violation in TaleWorlds.Native using cdbX64 without Rider, including the non-invasive sampling variant.
type: howto
topic: gabs-debugging
tags: [cdb, native, dump, av]
sources: [runtime-evidence/ws crash investigation 2026-09-30 to 2026-10-03]
updated: 2026-10-18
---

# Native AV capture with cdbX64

1. Run the game without Rider attached (two debuggers cannot share a process).
2. Attach cdbX64 invasively with a first-chance AV exception handler filtered to the TaleWorlds.Native module address range, so unrelated first-chance AVs are ignored.
3. On hit, write a full dump, then analyse with `.loadby sos clr` and `~*e !clrstack`. TaleWorlds.Native ships export symbols only, so name functions by RVA (function entry minus module base).
4. For a hang rather than a crash, attach non-invasively with `-pv` and sample the stacks; quitting cdb in invasive mode kills the game.
5. A native fault may occur on a worker thread while the managed stack shows only the main thread inside `Mission.Tick`. Read frame-1 registers and decode the data being indexed: a garbage index consisting of ASCII bytes (for example 0x2c303030 = "000,") means the read ran off the start of a table into adjacent text.

Related: [[ws-movement-set-swim-dive-slots-must-be-defined]], [[clr-exception-breakpoints-needed-to-catch-silent-death]]
