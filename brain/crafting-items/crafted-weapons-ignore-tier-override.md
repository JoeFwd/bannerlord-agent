---
name: crafted-weapons-ignore-tier-override
description: items.xml tier_override="N" pins the shown tier (and price) of hand-authored items only; crafted weapons get tier from the ItemValueModel, so retier them with an ItemValueModel decorator. Vanilla armour tier saturates at 6
type: lesson
topic: crafting-items
tags: [items, tiers, crafting, prices, models]
sources: [1.4.8 ItemObject / DefaultItemValueModel, DADG DadgItemValueModel 2026-11-07]
updated: 2026-11-07
---

# tier_override works on hand-authored items only

- `tier_override="N"` on an `<Item>` pins the tier shown to N. It is stored internally as N+1. Price follows the tier.
- **Vanilla's armour tier formula saturates.** Mail and anything heavier all show Tier 6, so heavy-armour mods need explicit overrides.
- **Crafted weapons (`<CraftedItem>`) can't take it.** Their tier comes from `ItemValueModel.CalculateTier` over the crafted stats. To pin a crafted weapon's tier, decorate `ItemValueModel` ([[agent-apply-damage-model-decorator]] shows the pattern). Return your tier for the listed ids, defer to `BaseModel` for everything else, and let price follow.

Related: [[head-armour-sums-all-slots]], [[crafted-weapon-stats-driven-by-weaponflags]], [[dadg-weapon-ladder]]
