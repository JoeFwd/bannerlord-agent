---
name: constant-war-peace-loop
description: IsAtConstantWar short-circuits IsAtWarAgainstFaction before the StanceLink, so MakePeaceAction can never converge - classic infinite "X and Y have made peace" spam
type: lesson
topic: campaign-ai
tags: [diplomacy, constant-war, makepeace, stancelink]
sources: [memory/constant-war-peace-loop.md]
updated: 2026-10-18
---

# Constant-war pairs make peace loops spam forever

`FactionManager.IsAtWarAgainstFaction` checks `DiplomacyModel.IsAtConstantWar` **first** and returns true immediately; it reads the real `StanceLink` only if that is false. `MakePeaceAction` calls `FactionManager.SetNeutral`, which writes the StanceLink, so peace is **invisible** while a constant-war rule applies.

`MakePeaceAction.ApplyInternal` dispatches `CampaignEventDispatcher.OnMakePeace` **unconditionally**, so the on-screen notification prints even when the peace had no effect.

Together: any behaviour looping "if `IsAtWarWith` then `MakePeaceAction.Apply`" spams one notification per tick against a constant-war pair. The tell is a strictly alternating pair of peace messages that never stops.

`DefaultDiplomacyModel.IsAtConstantWar` fires when one faction is `IsOutlaw` + `IsMinorFaction`, the other `IsKingdomFaction`, and **both share a culture**. A minor outlaw clan can never be at peace with a same-culture kingdom via the StanceLink alone.

**Fix shape** for a decorating `DiplomacyModel`: give the mod's forced-peace policy a chance to return `false` *before* delegating to vanilla, not just let forced-war return `true`.

Related: [[bannerlord-xml-load-abort-semantics]]
