---
name: army-requires-kingdom-use-besiegercamp-setter
description: A Bannerlord Army with a null Kingdom crashes the player's encounter menu - kingdomless mod factions should put parties in a siege via the public MobileParty.BesiegerCamp setter, not Army
type: lesson
topic: campaign-ai
tags: [army, besiegercamp, kingdom, encounter-menu, nre]
sources: [memory/customspawns-army-infeasible.md]
updated: 2026-10-18
---

# Army needs a Kingdom; BesiegerCamp does the job without one

Established 2026-08-18 against the 1.4.6 index and shipped v1.4.8 DLLs: forming an `Army` for a **kingdomless minor clan** is not buildable.

**Why not:**
- `EncounterGameMenuBehavior.army_encounter_background_on_init` guards on `Army != null` but dereferences `Army.Kingdom.Culture.EncounterBackgroundMesh`. It is a static `[GameMenuInitializationHandler]`, so a null-`Kingdom` army crashes the *player's* encounter menu when they engage it during a siege, unavoidable from mod code.
- `Army.OnAddPartyInternal` guards only `LeaderParty.LeaderHero != null`, never the member, so adding a leaderless member reaches `CalculatePartyInfluenceCost` then `LeaderHero.GetRelation(null)`; `GetEffectiveRelation` calls `GetHeroesForEffectiveRelation` *before* its null check, which does `hero2.Clan` and NREs.
- The two fixes are mutually exclusive: giving companions heroes unmasks three unguarded `Kingdom` derefs in `Army`'s own AI (shielded only because `LeaderHero == null` takes the else branch); faking a kingdom grafts the clan into real diplomacy.

**Alternative:** the only thing `Army` adds is `SetAttachedToInternal` copying `BesiegerCamp`/`MapEventSide`/`CurrentSettlement` to members, and the public `MobileParty.BesiegerCamp` setter does the whole job: it calls `OnPartyJoinedSiegeInternal()` (runs `_besiegerCamp.AddSiegePartyInternal(this)`, snaps the party to a siege-camp position, dispatches `OnMobilePartyJoinedToSiegeEvent`) and fans out to `_attachedParties`. It works for *leaderless* parties because `BesiegerCamp.GetInvolvedPartiesForEventType` just iterates `_besiegerParties` through `InvolveCondition` (true unconditionally except blockade battles), consulting no hero, army or kingdom; and `CheckBesiegerPartiesAndMakeThemLeave` evicts camp members whose `DefaultBehavior` is not `BesiegeSettlement`/`EscortParty`/`AssaultSettlement`, so escorts forced onto `EscortParty` stay enrolled. Settlement capture is army-agnostic (`KingdomManager.SiegeCompleted` uses `MapFaction.Leader` and `Party.Owner`).

Related: [[partycomponent-owner-must-be-own-leader]]
