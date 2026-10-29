---
name: ws-fmod-sail-sound-hang
description: RESOLVED - War Sails sea-battle FMOD hang is hook_grab one-shot spam (~350/s) when a mod strips NavalDLC's "hook" item, leaving ShipAttachmentMachine._hookItem null; not a vanilla FMOD or sail bug
type: incident
topic: war-sails-naval
tags: [war-sails, fmod, hang, shipattachmentmachine, hook, item-stripping, sea-battle, audio]
sources: [memory/ws-fmod-sail-sound-hang.md, runtime-evidence/ws-fmod runs 2026-10-01 to 2026-10-25]
updated: 2026-10-29
---

# FMOD hang in sea battles (RESOLVED 2026-10-25)

**Root cause:** a mod removed NavalDLC's `hook` item (`naval_weapons.xml`, Type=Thrown), so `ShipAttachmentMachine._hookItem` is null. In `ShipAttachmentMachine.OnTick` (pilot present, no attachment, hook_ready action OK), the check `PilotAgent.WieldedWeapon.Item != _hookItem` is then true whenever the pilot holds any weapon. Every tick it fires the `hook_grab` sound and runs `EquipWeaponToExtraSlotAndWield`, which also calls DropItem on the extra slot. That is about 350 one-shot sounds per second. FMOD walks its mixer input list in O(n²) (`Native+0xe88e0`, up to 8.6k inputs), so the game freezes for about 90 s. The list drains even while Rider has the game paused.

**Fix:** keep the `hook` item loaded. Verified in 2 sea battles on 2026-10-25 with no hang or sound glitches.

**Evidence:** a temporary Harmony probe on sound playback logged hook_grab at 335-360/s just before a 93 s freeze.

**Signature (for recognising it):** the FMOD Studio update thread spins at 100% of a core holding critical sections, the main thread waits in `_Cnd_wait`, and the game thread is blocked in NavalDLC `MissionSail.UpdateSoundPos -> SoundEvent.SetPosition`. GABP stops answering. Thread descriptions are empty, so tell the threads apart by CPU (main thread low, one native thread pegged). Onset was intermittent (20 s to 18 min into a battle) because it needs a pilot standing at a hook point with a weapon in hand.

**Wrong theories ruled out:** vanilla FMOD, sail sounds, music (it reproduced with the mod soundtrack stripped), and camera or teleport churn. `SoundEvent.GetTotalEventCount()` is the bank's event-TYPE count (constant 1835), NOT the number of live instances. The ~1817 "Could not find the event index" log lines are the same in good and bad runs. A Rider pause looks identical from outside, so check the Rider session state before calling it a hang.

**General rule:** when War Sails sounds or behaviours break, first check whether something NavalDLC looks up with `GetObject<ItemObject>("id")` was removed by the mod's item filtering.

Related: [[caravan-camel-icon-hardcoded]], [[ws-psai-duplicate-ids-with-native-soundtrack]], [[rider-eval-pause-looks-like-hang]], [[debugger-pause-kills-gabp-game]], [[dadg-ws-hook-item-stripped]]
