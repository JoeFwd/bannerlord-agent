---
name: precrafted-item-piece-must-be-in-template-usable-pieces
description: A pre-crafted item whose piece was removed from the template UsablePieces crashes CraftingOrder.InitializeCraftingOrderOnLoad at campaign start, not at the smithy.
type: lesson
topic: crafting-items
tags: [crafting, nre, campaign-start]
sources: [runtime-evidence/smithy-longsword-crash (2026-08-03)]
updated: 2026-10-18
---

# Pre-crafted items must stay valid against their template

`CraftingOrder.InitializeCraftingOrderOnLoad` (`CraftingOrder.cs:132`) NREs when `PreCraftedWeaponDesignItem` is null. That happens when the pre-crafted item's design cannot be built, for example its Handle was removed from the template's `UsablePieces`. Vanilla dereferences before its own null guard on the next line, so the failure is fatal at campaign start even though the player never opens a smithy.

Fix: repoint the item to a template that still lists its pieces. Verify live by selecting pieces on each bench (14 selections, no CLR exception).

Live-measured usage facts: `GenerateCraftedItem` emits a usage only if all four used pieces are in that usage description's `AvailablePieces`. In the observed mod the half-sword and two-hand usages were unreachable for a longsword because one description had zero Handle pieces and another covered 0 of 17 handles. UI piece lists were also smaller than template piece counts (12 vs 15, 14 vs 17); cause unidentified.

Related: [[crafting-usage-vs-bench-list-rules]], [[bannerlord-xml-load-abort-semantics]]
