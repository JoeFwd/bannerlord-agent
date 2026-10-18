---
name: same-kingdom-mapevent-diplomatically-finished
description: Vanilla MapEvent.Update ends any battle whose leader parties' MapFactions are not at war (DiplomaticallyFinished, no winner) on its FIRST tick, so same-kingdom battles never resolve or score and the AI re-engages every tick
type: lesson
topic: campaign-ai
tags: [mapevent, diplomaticallyfinished, same-kingdom, isatwarwith, scoring]
sources: [memory/same-kingdom-mapevent-diplomatically-finished.md]
updated: 2026-10-18
---

# Same-kingdom MapEvents auto-finish

`MapEvent.Update` (1.4.8) starts with `if (!_sides[0].LeaderParty.MapFaction.IsAtWarWith(_sides[1].LeaderParty.MapFaction)) DiplomaticallyFinished = true;`. That finishes the event with `WinningSide=None` and calls `RecalculateShortTermBehavior` on the leaders. A patch that creates the event (SiegeOutside or FieldBattle) for same-kingdom foes does not touch this check.

Result: with IsEnemy/StanceScore patched, AI EngageParty -> battle created -> killed next tick -> re-engage, forever. Verified live 2026-10-11 by invoking `Update` via reflection in the debugger: WaitingRemoval / dipFin=True / winner=None. `OnMapEventEnded` scoring ignores `WinningSide None`, so such battles never score. Battles that do score are those whose leaders' MapFactions differ.

**How to apply:** fix it before trusting any same-kingdom battle playtest. `Kingdom.IsAtWarWith` is a non-virtual one-liner reached through the `IFaction` interface, so it is patchable; scope the patch with a flag set by a prefix on `MapEvent.Update`.

Related: [[gathering-army-aibehaviorobject-not-target]]
