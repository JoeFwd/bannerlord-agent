---
name: character-creation-roster-needs-horse
description: Character creation's age-menu flow dereferences the selected equipment roster's Horse and HorseHarness, so every battle set a culture's character creation can pick needs both
type: lesson
topic: xml-data
tags: [character-creation, roster, equipment, horse, xml]
sources: [dadg runtime-evidence/character-creation-mount-rosters (2026-07-21)]
updated: 2026-10-29
---

# Character creation rosters need a horse and harness

The character-creation age-menu flow dereferences `Horse` and `HorseHarness` of the selected equipment roster. Every battle set that character creation can pick must therefore have both slots filled, or the flow crashes. There must also be a single `player_char_creation_default` roster for Empire.

Related: [[reused-culture-needs-complete-data]], [[banner-editor-shield-texture-nre]], [[character-creation-roster-requirements]]
