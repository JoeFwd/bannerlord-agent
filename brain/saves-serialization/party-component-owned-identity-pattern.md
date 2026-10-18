---
name: party-component-owned-identity-pattern
description: Persist per-party custom state on the PartyComponent itself, rebuild any registry at first tick, and never persist derived data.
type: decision
topic: saves-serialization
tags: [saves, party-component, decision]
sources: [plans/customspawns-component-identity.md, sdd/customspawns-component-identity task-1 report+review]
updated: 2026-10-18
---

# Party component owned identity pattern

Instead of a saved `Dictionary<MobileParty, Data>` on a behaviour, give a small saveable identity value to the party's component (a `PartyComponent` subtype). The component is saved with the party, so the data cannot desync from party removal.

- Keep the in-memory registry (party set) non-persisted and rebuild it from loaded components on the first campaign tick.
- Do not persist values that can be recomputed (nearest settlement).
- For bandits, subclass `BanditPartyComponent` and add ONLY the identity. Overriding `Name`/`HomeSettlement` changes native hideout accounting (native bandit behaviour reads `HomeSettlement` per hideout), and forcing `ShouldJoinPlayerBattles` changes battle joining. A reviewer caught this; customise name/home on the MobileParty after creation as before.
- Register every new saveable class in the SaveableTypeDefiner and assert the mappings in a test.
- Distinguish primary from supporting parties in count accounting, or a supporting party reusing a primary template decrements its count.

Related: [[vanilla-save-container-definitions]]
