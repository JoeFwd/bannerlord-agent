---
name: siege-vanilla-1-4-facts
description: 1.4 SiegeEvent.Tick makes illegitimate besiegers leave, and ChangeOwnerOfSettlementAction destroys the garrison on BySiege.
type: reference
topic: campaign-map
tags: [siege, 1.4, garrison]
sources: [doc/feudal-private-wars-design.md, doc/private-war-scarcity-analysis.md]
updated: 2026-10-18
---

# Siege vanilla 1 4 facts

- 1.4 `SiegeEvent.Tick` calls `CheckBesiegerPartiesAndMakeThemLeave`; parties that are no longer legitimate besiegers (for example because the hostility they relied on vanished) are ejected from the siege each tick.
- `ChangeOwnerOfSettlementAction` with detail `BySiege` destroys the garrison party. Other details (gift, barter, default) leave it for the new owner to reuse. A mod that transfers ownership without a real assault should pick the detail deliberately.
- A same-faction siege never runs an assault `MapEvent`; completing the siege preparations does not by itself transfer ownership. Anything that needs a capture has to create it.

Related: [[vanilla-garrison-rebalance-on-enter]], [[settlement-owner-change-details]]
