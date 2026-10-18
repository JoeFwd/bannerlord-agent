---
name: formation-transferunits-selective-pop-uses-stale-orderposition
description: Formation.TransferUnits with useSelectivePop pops the units nearest the TARGET formation's OrderPosition, and an empty target's order position is stale-copied from the source on first transfer
type: lesson
topic: missions-battles
tags: [formation, transferunits, orderposition, ai]
sources: [memory/bodyguard-orderposition-drafts-distant-crew.md]
updated: 2026-10-18
---

# TransferUnits picks the unit nearest the target's OrderPosition

`OrderController.TransferUnits` calls `source.TransferUnitsAux(target, count, isPlayerOrder: false, useSelectivePop)` where `useSelectivePop = count < source.CountOfUnits && target.CountOfUnits > 0`. When true, `Formation.cs:2001` uses `GetUnitsToPopWithReferencePosition` and pops the units **nearest `target.OrderPosition`**, not arbitrary ones.

If the target is empty on the first-ever transfer (`Formation.cs:1992-1996`), `CopyOrdersFrom(this)` plus `SetPositioning(_orderPosition, ...)` runs, so the target **permanently inherits the source formation's order position**. A small special-purpose formation (a siege-crew or bodyguard pool) that never gets its own order position will therefore draft its replacements from near the source formation's location, however far away the machine needing crew is.

Gotchas: formations outside `Team.FormationsIncludingEmpty` (indices 0-7) cannot be donors, so a hard-coded donor lookup always picks the same formation.

**How to apply:** set the target's order position to where the units are needed before transferring.
