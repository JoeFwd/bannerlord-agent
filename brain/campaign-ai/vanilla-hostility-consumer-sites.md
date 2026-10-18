---
name: vanilla-hostility-consumer-sites
description: The list of vanilla code sites that decide whether two parties are enemies, and which are overridable models versus private or non-virtual code.
type: reference
topic: campaign-ai
tags: [campaign, ai, harmony, war]
sources: [doc/feudal-private-wars-design.md]
updated: 2026-10-18
---

# Vanilla hostility consumer sites

If a mod fakes hostility between same-faction parties, these are the places that must agree (1.4.x):

| Site | Notes |
|---|---|
| `DefaultMobilePartyAIModel.IsEnemy`, `CalculateStanceScore` | private; the AI's target and threat choice. Needs Harmony or a replacement model |
| `TargetScoreCalculatingModel.GetTargetScoreForFaction` | public model seam for AI target scoring |
| `MapEvent.CanPartyJoinBattle` | non-virtual; decides who can join a battle |
| `SiegeEvent.CanPartyJoinSide` | who may join a siege |
| `PlayerEncounter.SetupFields` | player encounter side assignment |
| `PrisonerReleaseCampaignBehavior`, `PlayerCaptivityCampaignBehavior.CheckCaptivityChange` | release captives when the captor and captive are "not at war", so an internal war's prisoners get freed |
| `ChangeCrimeRatingAction.ApplyInternal` | guarded by `MainHero.MapFaction != faction` |

Rule of thumb: prefer the public model seams, fall back to Harmony only on the private or non-virtual ones, and write a test that walks the whole list when a new hostility source is added. A single missed consumer produces a hostile party the AI treats as a friend (or the reverse).

Surprising consumers are the prisoner-release ones. A faked war leaks captives unless those two behaviours are patched.

Related: [[mapfaction-wall-blocks-same-kingdom-hostility]], [[campaign-model-seams-for-encounters-and-access]]
