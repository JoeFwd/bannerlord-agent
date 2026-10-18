---
name: clan-createclan-cadet-spinoff-recipe
description: How to spin a runtime clan off an existing clan in 1.4: Clan.CreateClan, set leader, move the hero, and join the parent kingdom.
type: howto
topic: campaign-map
tags: [clan, create, kingdom, 1.4]
sources: [doc/feudal-hero-claims-and-succession-design.md, doc/feudal-hero-titles-and-houses.md]
updated: 2026-10-18
---

# Clan createclan cadet spinoff recipe

Vanilla does this itself in `Clan.CreateSettlementRebelClan`. A public-API recipe (verified against 1.3.15 and 1.4.6):

```csharp
var cadet = Clan.CreateClan(parent.StringId + "_cadet");   // id is auto-uniquified
cadet.ChangeClanName(name, informalName);
cadet.Culture = parent.Culture; cadet.Banner = ...; cadet.Color = parent.Color;
cadet.AddRenown(parent.Renown / 2f, false);                // Tier's setter is private in 1.4.6
cadet.SetInitialHomeSettlement(seat ?? parent.HomeSettlement);
claimant.Clan = cadet;                                      // public setter
foreach (var c in claimant.Children) c.Clan = cadet;
cadet.SetLeader(claimant);
cadet.IsNoble = true;
ChangeKingdomAction.ApplyByJoinToKingdom(cadet, parent.Kingdom, default, false);
CampaignEventDispatcher.Instance.OnClanCreated(cadet, false);
```

The join to the parent's kingdom is the step most easily forgotten: a kingdomless clan gets autonomous war/peace decisions, degraded services and a 28-day discontinuation countdown when it is landless. To reabsorb: set `hero.Clan = parent` then `DestroyClanAction.Apply(cadet)`.

Untested: banner, encyclopedia and AI behaviour of a clan created mid-campaign need a smoke test.

Related: [[mapfaction-wall-blocks-same-kingdom-hostility]]
