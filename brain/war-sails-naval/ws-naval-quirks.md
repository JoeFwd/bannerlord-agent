---
name: ws-naval-quirks
description: Smaller War Sails facts: cheat mission needs imperial troops, grappled ships fold sails, sail toggle key, port screen figurehead tooltip NRE, hull XSD warnings.
type: reference
topic: war-sails-naval
tags: [war-sails, cheat, sail, port]
sources: [runtime-evidence/ws runs 2026-09-30 to 2026-10-03]
updated: 2026-10-18
---

# War Sails quirks (1.4.8, War Sails 1.2.8)

- `naval.start_mission` from a save with no encounter NREs: the NavalDLC cheat hard-codes the `imperial_recruit` and `imperial_archer` troop ids. A mod that strips Imperial troops must supply them. A save with a pending encounter pre-empts a forced mission.
- Sail toggle is game key 110 (Z by default; physical key, so it moves on AZERTY). Grappled ships do not set sail (`_foldSailsOnBridgeConnection`). `SetCustomSailSetting` latches `HasCustomSailSetting` and then overrides player input.
- A hull with `oar_count=0` has no oars, and also violates the XSD `positiveIntType`; the `AvailableSlots` XSD warnings on hulls are harmless noise.
- After a sea battle the port screen (`GauntletPortScreen`/`PortVM`/`ShipItemVM`) threw a figurehead tooltip NRE; resuming from it killed the process. Unverified hypothesis: a figurehead with an unresolved culture. A later figurehead fix suggests it was resolved.
- NavalDLC save compatibility: port towns missing a `SettlementShipyard` need it created (see [[resuming-from-first-chance-exception-kills-process]]).

Related: [[war-sails-sail-cloth-requirements]]
