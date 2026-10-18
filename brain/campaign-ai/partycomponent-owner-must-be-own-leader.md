---
name: partycomponent-owner-must-be-own-leader
description: A custom PartyComponent whose party captures a fortification must return its OWN leader hero from PartyOwner (and SetCustomOwner), or ChangeOwnerOfSettlementAction NREs
type: lesson
topic: campaign-ai
tags: [partycomponent, owner, siege, nre, changeownerofsettlementaction]
sources: [memory/customspawns-partyowner-must-be-leader.md]
updated: 2026-10-18
---

# PartyOwner must be the party's own leader

Found 2026-08-17: a custom-component party that captures a castle throws `NullReferenceException` in `ChangeOwnerOfSettlementAction.ApplyInternal`, reached via `KingdomManager.SiegeCompleted` then `ApplyBySiege`.

**Why:** vanilla's capture path does not use `MobileParty.LeaderHero`; it uses `capturerParty.Party.Owner`, and the first statement in the `IsFortification` branch is an unguarded `DestroyPartyAction.Apply(capturerHero.PartyBelongedTo.Party, ...)`. The mod set both `PartyOwner` and `Party.SetCustomOwner(...)` to a clan leader sitting in a settlement with `PartyBelongedTo == null`. Vanilla never hits this because `LordPartyComponent.OnChangePartyLeader` calls `ChangePartyOwner(newLeader)`, keeping owner == leader.

**How to apply:** return the party's *own* leader hero from `PartyOwner` and pass the same hero to `SetCustomOwner` (it wins over `PartyOwner` inside `PartyBase.Owner`). Re-stamp on every load since `OnInitialize` re-runs the invariants. A generated lord was healthy: `HeroCreator.CreateSpecialHero(template, null, clan, null, age)` fills in `BornSettlement` despite the null argument, so null-argument suspicion there is a red herring.

Related: [[army-requires-kingdom-use-besiegercamp-setter]], [[bannerlord-live-version]]
