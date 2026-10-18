---
name: xscene-declares-level-bit-mapping
description: scene.xscene declares its own <levels> mask bits - never assume a base/level_1/level_2/civilian/siege bit order when decoding navmesh g5; enablement is AND across mission-type and level bits
type: reference
topic: scenes-xscene
tags: [xscene, levels, mask, navmesh, g5, civilian, siege]
sources: [memory/xscene-declares-level-bit-mapping.md]
updated: 2026-10-18
---

# Read the scene's <levels> block before decoding g5

Every scene declares its own level bit assignment near the top of `scene.xscene`:

```xml
<levels>
  <level name="base"     mask="1"/>
  <level name="civilian" mask="2"/>
  <level name="siege"    mask="4"/>
  <level name="level_1"  mask="8"/>
  <level name="level_2"  mask="16"/>
  <level name="level_3"  mask="32"/>
</levels>
```

The plausible alternative (base=1, level_1=2, level_2=4, level_3=8, civilian=16, siege=32) is wrong for this scene and produced an inverted diagnosis: two near-duplicate navmesh sheets were labelled "level_1 vs level_2 variants" when they are **civilian vs siege** variants (hence 4 cm apart, each covering the whole castle).

**Enablement is AND across categories:** a face is live when it has both the mission-type bit (`civilian` or `siege`) and the current level bit. With the mapping above, `g5 = -6` = civilian-only, `g5 = -4` = siege-only, `g5 = -51` (base+siege+level_1) is live **only** in a level_1 siege.

**Why:** a wrong decode does not error; it yields a coherent but false story, and all component/connectivity results inherit it.

**How to apply:** parse `<levels>` first, decode g5 against it, filter to the mission you care about BEFORE computing connected components. A face set carrying `siege` but only `level_1` is a classic authoring bug ([[navmesh-g5-level-bits-must-cover-all-castle-levels]]). Preserve upper bits when editing a mask (`-51 | 16 | 32 = -3`); never normalise to a small positive number. Tooling: [[navmesh-studio-tool]].

General g5 reference: [[navmesh-g5-scene-level-mask-not-island]]; runtime symptom: [[navmesh-level-mask-must-match-mission-mask]].

