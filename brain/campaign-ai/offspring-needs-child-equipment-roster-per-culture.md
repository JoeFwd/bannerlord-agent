---
name: offspring-needs-child-equipment-roster-per-culture
description: DeliverOffSpring NREs in EquipmentHelper.AssignHeroEquipmentFromEquipment when no EquipmentRoster matches the hero's culture with flags exactly IsLordTemplate|IsChildEquipmentTemplate (+IsFemaleTemplate for girls)
type: lesson
topic: campaign-ai
tags: [offspring, birth, equipmentroster, culture, nre, daily-tick]
sources: [memory/offspring-child-roster-per-culture.md]
updated: 2026-10-18
---

# Births need a per-culture child equipment roster

`DefaultEquipmentSelectionModel.GetEquipmentForDeliveredOffspring` needs a roster whose culture equals `hero.Culture` and whose flags are EXACTLY `IsLordTemplate|IsChildEquipmentTemplate` (+`IsFemaleTemplate` for girls). With none it returns null, and `HeroCreator.InitializeHeroFromSettings` NREs on the daily tick: a hard campaign crash. The rgl log ends with "creating hero from template with id: <father>"; in a run-mode game it shows 0xC0000005 with managed frames `InitializeHeroFromSettings < DeliverOffSpring`.

It only fires when a birth happens, so any mod that strips vanilla rosters or gives noble heroes a new culture silently arms it.

**Triage:** count `culture=` across `is_hero="true"` NPCCharacters and check each has both child rosters. To resolve rgl pdb tokens (100663296+n) use `Assembly.LoadFrom(...).ManifestModule.ResolveMethod(token)` in PowerShell. In Rider the crash shows as a pause with reason "step" in `EquipmentHelper.cs:17`, not an obvious exception stop; resuming it crashes.

**How to apply:** when adding a culture to lords, add its child rosters too; check this before blaming nearby code for a daily-tick crash.

