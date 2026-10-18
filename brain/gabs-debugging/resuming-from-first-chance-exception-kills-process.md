---
name: resuming-from-first-chance-exception-kills-process
description: Resuming after a paused vanilla first-chance NRE (NavalDLC, PatrolParty) can silently kill the game, so inspect and stop instead.
type: lesson
topic: gabs-debugging
tags: [debugger, exception, process-death]
sources: [runtime-evidence/private-war-prosecution-fixes, runtime-evidence/private-wars-no-solo-siege.feature.md]
updated: 2026-10-18
---

# Do not resume from a vanilla first-chance exception

Several vanilla code paths throw NullReferenceExceptions that are normally caught or that kill the game the moment the debugger lets them propagate. Observed in 1.4.8:
- `PatrolPartiesCampaignBehavior.SpawnPatrolParty`: `templateForPatrolParty` is null for a settlement whose owner/culture has no patrol template.
- `NavalDLC ShipUpgradeCampaignBehavior.OnSettlementEntered`: a leaderless AI caravan (`LeaderHero == null`) entering a port town with a shipyard. The guard at the top does not null-check the hero.
- `NavalDLC ShipUpgradeCampaignBehavior` also fails when a port town has no `SettlementShipyard` object (old saves). A live evaluate_expression patch that adds the missing shipyards, then re-saving, gives a usable fixture.

Resuming from the first-chance pause killed the process in the PatrolParty case. Blanket "break on any .NET exception" breakpoints therefore make long runs fragile: use them only to catch a known silent death, and capture the evidence (stack, locals) then stop.

Related: [[rider-eval-pause-looks-like-hang]], [[clr-exception-breakpoints-needed-to-catch-silent-death]], [[debugger-pause-kills-gabp-game]]
