---
name: settlement-owner-change-details
description: The ChangeOwnerOfSettlementDetail values and what each means, for mods that react to ownership changes.
type: reference
topic: campaign-map
tags: [settlement, events, ownership]
sources: [doc/feudal-title-transfer-design.md]
updated: 2026-10-18
---

# Settlement owner change details

`CampaignEvents.OnSettlementOwnerChangedEvent` carries `ChangeOwnerOfSettlementAction.ChangeOwnerOfSettlementDetail`. Meaning:

| Detail | Meaning |
|---|---|
| `BySiege` | military conquest |
| `ByRebellion` | rebels seize it (rebel clans are often kingdomless) |
| `ByKingDecision` | outcome of the kingdom's claimant election or a royal grant |
| `ByGift`, `ByBarter` | consensual conveyance |
| `ByLeaveFaction`, `ByClanDestruction`, `Default` | administrative |

A siege fires `BySiege`, the kingdom then runs a claimant election whose result fires `ByKingDecision`. A mod that tracks "who is lawful holder" can use this two-step pattern: treat `BySiege` as occupation only, and let `ByKingDecision` finalise.

Related: [[siege-vanilla-1-4-facts]], [[kingdom-decision-lifecycle]]
