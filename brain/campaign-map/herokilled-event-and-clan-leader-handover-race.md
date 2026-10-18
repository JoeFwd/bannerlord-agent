---
name: herokilled-event-and-clan-leader-handover-race
description: On a hero death, vanilla's ChangeClanLeaderAction and your HeroKilledEvent handler run in unspecified order; never read Clan.Leader to find an heir.
type: lesson
topic: campaign-map
tags: [hero, death, succession, events]
sources: [doc/feudal-succession.md]
updated: 2026-10-18
---

# Herokilled event and clan leader handover race

`HeroKilledEvent` listeners and vanilla's clan-leader handover fire on the same death and their relative order is not guaranteed. A succession routine that reads `Clan.Leader` can see the dead hero, or the new leader, depending on order.

Use bloodline data (father, children, siblings) first, and treat the clan leader only as a last-resort backstop that must be checked for being alive. Marriage moves the bride's clan (`MarriageAction`), so anything derived from `Hero.Clan` follows automatically; do not cache a hero's clan.

Related: [[authored-genealogy-cycles-overflow-the-stack]]
