---
name: mapfaction-wall-blocks-same-kingdom-hostility
description: Two clans in the same kingdom cannot be at war in vanilla: MapFaction resolves them to one faction, so clan-pair StanceLinks are dead data.
type: lesson
topic: campaign-ai
tags: [campaign, diplomacy, stance, kingdom]
sources: [doc/feudal-private-wars-design.md, doc/cross-kingdom-private-wars-analysis.md]
updated: 2026-10-18
---

# Mapfaction wall blocks same kingdom hostility

`Clan.MapFaction` is `Kingdom ?? this`. Every war query ends up comparing map factions, so anything inside one kingdom is "same faction" and can never be hostile.

- `FactionManager.IsAtWarAgainstFaction` short-circuits to false when both sides resolve to the same faction, before looking at any `StanceLink`.
- `EncounterManager.StartPartyEncounter` merges the two sides on a direct `MapFaction ==` comparison, so same-kingdom parties meet as friends.
- A `StanceLink` created between two clans of one kingdom is therefore dead data: it is never read. Do not try to declare war "between clans" by writing stances.
- Vanilla only gets internal hostility through kingdomless clans (rebel or minor-faction clans), whose MapFaction is themselves.

Implication for mods that want feuds or civil wars: either put the clans in different factions (splinter kingdoms, lone-clan ejection) or manufacture hostility at the consumer sites listed in [[vanilla-hostility-consumer-sites]]. Both have large costs, so check which one fits before designing.

Evidence: decompiled 1.3 and 1.4 sources of `FactionManager`, `Clan`, `EncounterManager`.

Related: [[vanilla-hostility-consumer-sites]], [[campaign-model-seams-for-encounters-and-access]], [[same-kingdom-mapevent-diplomatically-finished]]
