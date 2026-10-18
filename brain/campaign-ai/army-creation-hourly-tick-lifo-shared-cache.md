---
name: army-creation-hourly-tick-lifo-shared-cache
description: AiHourlyTickEvent listeners run LIFO over one shared PartyThinkParams member cache, so a mod that creates armies from a listener can corrupt the cache; Kingdom.CreateArmy is the safe boundary.
type: lesson
topic: campaign-ai
tags: [army, ai, tick, kingdom]
sources: [doc/private-war-scarcity-analysis.md, doc/private-war-attacker-win-analysis.md]
updated: 2026-10-18
---

# Army creation hourly tick lifo shared cache

Campaign AI decisions run from `AiHourlyTickEvent` listeners, one party at a time. The listeners run in LIFO order and share a single `PartyThinkParams` member cache that is reused between parties.

- Do not mutate army membership from inside a listener and then keep reading the cache; later listeners see the changed state.
- `Kingdom.CreateArmy` is the safe boundary: it does the full join itself.
- A listener registered later runs earlier. Order matters when two mods both want to steer the same party.

In one mod this was the cause of "goal armies" being rebuilt wrongly each hour: the creating listener and the vanilla listener disagreed about who was already in an army.

Related: [[campaign-model-seams-for-encounters-and-access]], [[army-dispersal-noactivewar-check]]
