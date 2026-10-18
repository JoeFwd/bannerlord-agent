---
name: army-dispersal-noactivewar-check
description: Army.CheckArmyDispersion disbands armies at 25 percent per hour when the kingdom has no active war; armies created for non-war purposes need a patch.
type: lesson
topic: campaign-ai
tags: [army, dispersal, 1.4.8]
sources: [doc/private-war-scarcity-analysis.md, doc/feudal-private-wars-design.md]
updated: 2026-10-18
---

# Army dispersal noactivewar check

In 1.4.8, `Army.CheckArmyDispersion` (`Army.cs` around line 423) disbands an army with a 25 percent per hour chance when the kingdom's `NoActiveWar` condition holds. An army formed for a feud or any purpose that is not a kingdom war will melt away within hours.

Fix used by one mod: a Harmony patch that vetoes the dispersal for armies the mod marked as its own.

Open discrepancy (2026-10-18): a design document written against 1.4.6 claims this path is gone there. Treat it as present in 1.4.8 (decompile-confirmed) and recheck on 1.4.6 before relying on either.

Related: [[army-creation-hourly-tick-lifo-shared-cache]]
