---
name: behostileaction-escalates-to-kingdom-war
description: BeHostileAction.ApplyEncounterHostileAction turns a player attack on a same-kingdom party into a kingdom war with -10 relation against the defending leader; EncounterModel.IsEncounterExemptFromHostileActions is the override seam.
type: reference
topic: campaign-ai
tags: [player, war, relation, encounter]
sources: [doc/feudal-private-wars-design.md]
updated: 2026-10-18
---

# Behostileaction escalates to kingdom war

When the player attacks a party of another faction in an encounter, `BeHostileAction.ApplyEncounterHostileAction` declares a kingdom war and applies -10 relation against the defending leader. It applies to the player only.

Mods that give the player a legitimate reason to fight (a feud, a tournament, a sanctioned duel) should return true from `EncounterModel.IsEncounterExemptFromHostileActions` for those encounters, otherwise the first skirmish starts a full kingdom war.

Related: [[campaign-model-seams-for-encounters-and-access]]
