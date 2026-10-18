---
name: missing-commonareamarker-crash
description: A town scene whose common_area_N entities lost their CommonAreaMarker script registers zero common areas and crashes a civilian mission ~4 s in (AV reading 0x128 in TaleWorlds.Native); restore the script block
type: lesson
topic: scenes-xscene
tags: [commonareamarker, civilian-mission, access-violation, scene, native-crash]
sources: [memory/missing-commonareamarker-crash.md]
updated: 2026-10-18
---

# Missing CommonAreaMarker script crashes civilian missions

A scene can have `<game_entity prefab="common_area_N">` entities whose `<scripts><script name="CommonAreaMarker">` block was stripped, leaving a bare transform. At runtime the scene registers zero common areas, and about 4 s into a civilian mission `TaleWorlds.Native.dll` faults with an access violation reading 0x128 (`TaleWorlds.Native.dll+0x6D0BC5`, null `[rdx+0x128]`): the engine null-checks the area containing the candidate point but not the agent's assigned area.

It presents as a navmesh/scene-load failure but is neither; a valid navmesh does not rule this out, and hours on navmesh topology are the obvious-but-wrong path. Healthy reference: every vanilla town has exactly 3 CommonAreaMarker scripts.

**Fix (UNFIXED in one mod as of 2026-08-01):** restore the script block on each entity (vanilla AreaRadius 7.0-8.0):
`<scripts><script name="CommonAreaMarker"><variables><variable name="AreaRadius" value="8.000"/></variables></script></scripts>`
Prefer re-attaching in the Bannerlord editor so the scene re-saves consistently.

Related: [[navmesh-presence-probe-in-rider]]
