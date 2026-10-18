---
name: vanilla-garrison-rebalance-on-enter
description: Vanilla GarrisonTroopsCampaignBehavior.OnSettlementEntered splits garrison men into any same-faction lord party entering a fortification, bypassing mod garrison floors
type: lesson
topic: campaign-ai
tags: [garrison, garrisontroopscampaignbehavior, onsettlemententered, managegarrisonforparty]
sources: [memory/vanilla-garrison-rebalance-on-enter.md]
updated: 2026-10-18
---

# Vanilla rebalances the garrison when a same-faction lord enters

`GarrisonTroopsCampaignBehavior.OnSettlementEntered` runs `ManageGarrisonForParty` whenever a same-faction lord party enters a fortification. It redistributes regulars proportionally to the ideal sizes:

`garrison final count = total men x settlementIdeal / (settlementIdeal + partyIdeal)`, clamped to **125-750 for a town, 75-500 for a castle**.

A near-empty lord therefore walks out with about 20 garrison men. This ignores any garrison floor a mod enforces.

**How to apply:** when a garrison shrinks with no mod code removing men, suspect lord visits first. A mod-side floor has to patch or offset this behaviour; it cannot just gate its own draw.

