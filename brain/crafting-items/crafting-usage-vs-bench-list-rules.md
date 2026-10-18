---
name: crafting-usage-vs-bench-list-rules
description: Bannerlord crafting - UsablePieces drives the bench list, AvailablePieces drives which weapon usage is emitted; the two are independent, and saves bake in the design
type: reference
topic: crafting-items
tags: [crafting, usablepieces, availablepieces, weapondescription, saves]
sources: [memory/crafting-usage-vs-bench-list-rules.md]
updated: 2026-10-18
---

# Three crafting-data rules that are easy to conflate

Verified against 1.4.7 decompiled source.

1. **`CraftingTemplate.Pieces` comes ONLY from `<UsablePieces>`.** If a `CraftedItem` in XML references a piece not in its template's `UsablePieces`, `GenerateCraftedItem` returns **null**, causing an NRE at `CraftingOrder.InitializeCraftingOrderOnLoad` (`CraftingOrder.cs:132`, which dereferences before its null guard at 134) on campaign start / save load.
2. **A `WeaponDescription` emits a usage only if EVERY valid used piece is in that description's `<AvailablePieces>`.** In `TaleWorlds.Core.Crafting.GenerateCraftedItem`, `num` starts at 4, decrements once per invalid (unused) piece and once per used piece found in `AvailablePieces`; the usage fires at `num <= 0`. If a template declares a piece type mandatory (`build_order` != `-1`) and the description lists **zero** pieces of that type, the usage is **unreachable for every weapon**. `build_order="-1"` types are optional (unused means `IsValid == false`), so need no coverage.
3. **Bench piece lists are NOT filtered by `AvailablePieces`.** `WeaponDesignVM` fills each `CraftingPieceListVM` straight from `_crafting.UsablePiecesList`, gated only by `IsPieceTypeUsable` and `IsHiddenOnDesigner`; `AvailablePieces` is only an `orderby` key for auto-select. A piece in `UsablePieces` that matches no description is selectable and produces an unclassifiable design.

Also: `is_hidden="true"` on a `CraftingPiece` hides it from the designer unless `Campaign.Current.GameMode == CampaignGameMode.Tutorial`, which is why UI piece counts are lower than the template's `UsablePieces` count.

Saves store the resolved `WeaponDesign` (template id + piece ids) inside `CraftingOrder`/`CraftedItemInitializationData`, so **XML data fixes do not repair existing saves**.

Related: [[crafted-weapon-stats-driven-by-weaponflags]]
