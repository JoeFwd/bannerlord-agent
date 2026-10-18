---
name: ws-psai-duplicate-ids-with-native-soundtrack
description: Keeping native music alongside a mod soundtrack crashes at startup when the mod reuses Native theme/segment ids with an empty ModuleIdPrefix.
type: lesson
topic: audio
tags: [psai, soundtrack, startup-crash]
sources: [runtime-evidence/ws-fmod run 4 (2026-10-03)]
updated: 2026-10-18
---

# PSAI duplicate keys

A patch that kept the native music manager (`KeepNativeMusic = true`) crashed at startup with a PSAI duplicate-key error. The mod's `soundtrack.xml` reused Native theme ids (1, 5, 7, 9, 12, 13) and segment ids (17, 100-113) with an empty `ModuleIdPrefix`. NavalDLC uses prefix 1024 and does not collide.

Rule: any mod soundtrack that coexists with vanilla/DLC music must give its themes and segments a non-empty, unique `ModuleIdPrefix`.

Related: [[ws-fmod-sail-sound-hang]]
