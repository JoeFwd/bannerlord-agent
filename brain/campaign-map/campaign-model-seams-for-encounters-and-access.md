---
name: campaign-model-seams-for-encounters-and-access
description: Public GameModel overrides that let a mod change encounters, settlement access and army creation without Harmony.
type: reference
topic: campaign-map
tags: [models, encounter, army, 1.4]
sources: [doc/feudal-private-wars-design.md, doc/private-war-scarcity-analysis.md]
updated: 2026-10-18
---

# Campaign model seams for encounters and access

Model overrides are the cleanest way to bend vanilla. Verified seams:

- `EncounterModel`: defender/joiner methods (including `GetNextDefenderPartyOfSettlement`, which also buckets the overlay shown to the player) and `IsEncounterExemptFromHostileActions`.
- `EncounterGameMenuModel.GetEncounterMenu`: pick which encounter menu the player lands in.
- `SettlementAccessModel.CanMainHeroEnterSettlement`: gate entry to a settlement.
- `TargetScoreCalculatingModel.GetTargetScoreForFaction`: AI target scoring.
- Army creation: 1.4 has `CanLordCreateArmy(..., out MBList<MobileParty>)`, replacing 1.3's `GetMobilePartiesToCallToArmy`. Code written for 1.3 will not compile on 1.4.

Remember a model swap is global: only one mod's override wins per model type, so chain to the previous model rather than replacing it outright.

Related: [[vanilla-hostility-consumer-sites]], [[army-creation-hourly-tick-lifo-shared-cache]]
