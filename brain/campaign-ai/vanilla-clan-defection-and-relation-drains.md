---
name: vanilla-clan-defection-and-relation-drains
description: Vanilla clan defection is a purchase (join+leave value x2 same culture, up to x2.5 when buyer weak, buyer pays up to half their gold) and relations are randomised at new game; sieges, captures and annexation votes drain relation without checking MapFaction
type: reference
topic: campaign-ai
tags: [defection, diplomaticbarters, relations, siege, annexation]
sources: [memory/dadg-lord-defection-sources.md, docs/lord-defection-and-relation-randomisation]
updated: 2026-10-18
---

# Vanilla defection and relation mechanics (decompiled 1.4.8)

- **Defection** (`DiplomaticBartersBehavior`): needs a low relation with the current ruler and a target ruler who can pay (cost <= their gold / 2). `ConsiderDefection` is a **purchase**: it sums the clan's join+leave value with the target kingdom's `GetScoreOfKingdomToGetClan`, x2 for same culture and up to x2.5 when the buyer is weaker than its enemies; the buyer's ruler pays the clan's deficit. Grudges explain leaves; the buyer's war position and gold explain many defections (defections seen at +34 and -1 relation).
- **Initial relations are random:** `CharacterRelationCampaignBehavior.UpdateFriendshipAndEnemies` randomises lord-to-lord relations at new game via `SetPersonalRelation`, which fires **no event**, so early realm changes have no logged cause. Leaders with Honor -1 (reliability 0.3) leave at about -40 instead of about -75.
- `DiplomaticBartersBehavior.DailyTickClan` evaluates each clan daily for leaving or defecting; defection is also offered as a barter. The score weighs relation to the ruler, the leader's Honor trait and kingdom strength. A leader with Honor -1, or a ruler with negative relations to many clans, produces a steady stream of defections; no `HeroRelationChanged` event fires for the seeding, so listeners never see it.
- AI battles do not change relations between AI lords. Raid penalties are skipped when raider and village share a MapFaction.
- **Drains that do not check MapFaction** (so intra-realm private wars trigger them): `SiegeEvent` ctor -5 between holder and besieger; SiegeAftermath capture -10 between old owner and capturer and -6 between old owner and the CAPTURER'S RULER (in a same-realm war, the victim's own king); annexation loop: `GetRandomAnnexationDecision` fires against a fief-holder that a clan holds below -25 relation, each vote against costing -20 with him (more for Sturgian culture). `KingdomElection` relation changes are player-only.
- `Clan.LastFactionChangeTime` dates each realm change.

See also [[constant-war-peace-loop]].
