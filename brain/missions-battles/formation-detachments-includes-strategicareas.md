---
name: formation-detachments-includes-strategicareas
description: Formation.Detachments is not a machine list - ArrangementOrder.TickOccasionally keeps joining every StrategicArea near the formation's OrderPosition, so sizing a crew pool off Detachments.Count runs away
type: lesson
topic: missions-battles
tags: [formation, detachments, strategicarea, orderposition, transferunits]
sources: [memory/formation-detachments-includes-strategicareas.md]
updated: 2026-10-18
---

# Formation.Detachments includes StrategicAreas

`Formation.Detachments` holds **everything** the formation is committed to, not just attached `UsableMachine`s. `ArrangementOrder.TickOccasionally` (vanilla 1.4.6, `ArrangementOrder.cs:390-428`) runs whenever the arrangement is `Scatter` and joins **every `StrategicArea` within `DistanceToCheck` of `formation.OrderPosition`** (gated by `IsStrategicAreaClose`, line 375, which skips Charge/ChargeToTarget).

Measured live in a siege: defender Bodyguard 142 units, detach=71 = 4 machines + 67 StrategicArea; attacker 308 units, detach=305 = 2 machines + 303 StrategicArea, so a crew pool sized `Detachments.Count * SeatsPerCannon` asked for 610 men for 1 cannon and drained every other formation. Trigger: giving a formation a valid `OrderPosition` (a `SetPositioning` call).

**Rules:**
1. Never treat `Detachments.Count` as a machine count; filter by type (`Detachments.OfType<BaseFieldSiegeWeapon>()`).
2. Be wary of `Formation.SetPositioning` on a formation used only as a crew pool; an order position is what makes strategic areas attach.
3. To move a specific agent, assign `agent.Formation = target`. `Formation.TransferUnitsAux` (`Formation.cs:2038-2041`) does that per unit plus `Team.TriggerOnFormationsChanged` (public, `Team.cs:685`). `Formation.TransferUnits` routes to `OrderController` with `useSelectivePop: true`, discarding your choice ([[formation-transferunits-selective-pop-uses-stale-orderposition]]). Direct assignment also runs `SetPositioning` once if `!HasBeenPositioned` (`Agent.cs:1138`).

Related: [[setdisabledsynched-leaks-detachments]]
