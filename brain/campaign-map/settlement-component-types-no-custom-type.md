---
name: settlement-component-types-no-custom-type
description: Bannerlord 1.4.7 has only Town/Village/Hideout/Retirement SettlementComponents; a castle is Town is_castle="true"; a new settlement type needs C#
type: reference
topic: campaign-map
tags: [settlement, village, town, castle, settlementcomponent]
sources: [memory/dadg-abbey-church-system.md]
updated: 2026-10-18
---

# No new settlement types from XML

Bannerlord 1.4.7 has only `Town`, `Village`, `Hideout` and `Retirement` SettlementComponents (verified with ilspycmd on the shipped `TaleWorlds.CampaignSystem.dll`). A castle is `<Town ... is_castle="true">`. There is no engine extension point for a new type without C# code.

Practical pattern: model a special place (e.g. an abbey) as an ordinary **Village** (`<Village ... bound="Settlement.<fort>" village_type=... hearth=...>`) with custom name/mesh, and register it by id in the mod's own config. It keeps village mechanics: market via bound town, no garrison, not besiegeable (raidable), production from `village_type`; wealth vs estate scale is just `hearth`.

