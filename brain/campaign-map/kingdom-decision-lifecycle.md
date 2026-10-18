---
name: kingdom-decision-lifecycle
description: How KingdomDecision objects are enqueued, cancelled and resolved, so a mod can add its own decision type.
type: reference
topic: campaign-map
tags: [kingdom, decision, election]
sources: [doc/feudal-title-transfer-design.md]
updated: 2026-10-18
---

# Kingdom decision lifecycle

- Enqueue with `Kingdom.AddDecision(decision, ignoreInfluenceCost)`; vanilla enqueues the settlement claimant decision from the ruling clan with `ignoreInfluenceCost: true`. Dedup against `kingdom.UnresolvedDecisions` first.
- `KingdomDecisionProposalBehavior.UpdateKingdomDecisions` iterates `UnresolvedDecisions`: decisions where `ShouldBeCancelled()` is true are removed (event `OnKingdomDecisionCancelled`), the rest run `new KingdomElection(d).StartElectionWithoutPlayer()` once `TriggerTime` has passed.
- `ShouldBeCancelled()` already cancels when the kingdom dies, the proposer leaves, or `IsAllowed()` fails. Override `ShouldBeCancelledInternal()` for decision-specific rules, so the queue cleans itself with no bookkeeping behaviour.
- `TriggerTime = HoursFromNow(HoursToWait)`; `HoursToWait` is virtual (default 48).
- `NeedsPlayerResolution` plus the map popup machinery give a player ruler the UI for free. `GetFollowUpDecision()` is only used by the player flow.
- Custom decision and outcome classes need entries in a `SaveableTypeDefiner`.

Related: [[settlement-owner-change-details]], [[saveable-type-definer-ids]]
