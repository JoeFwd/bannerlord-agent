---
name: ws-fmod-sail-sound-hang
description: UNRESOLVED - War Sails sea-battle hang with FMOD Studio update thread spinning and the game thread blocked in MissionSail.UpdateSoundPos; intermittent, not music, not camera churn; a Rider pause looks identical
type: incident
topic: war-sails-naval
tags: [war-sails, fmod, hang, missionsail, updatesoundpos, sea-battle, audio]
sources: [memory/ws-fmod-sail-sound-hang.md, runtime-evidence/ws-fmod runs 2026-10-01 to 2026-10-03]
updated: 2026-10-18
---

# FMOD sail-sound hang in sea battles (UNRESOLVED as of 2026-10-03)

**Signature:** the "FMOD Studio update thread" holds critical sections while walking a large list (7779 entries; Native RVA 0x83a790; later `get_ftdn_managed_interface+0xe88e0`), spins at 100% of a core, and the main thread waits in `_Cnd_wait`; the game thread is blocked in NavalDLC `MissionSail.UpdateSoundPos -> SoundEvent.SetPosition`. GABP stops answering.

**Timeline of repros:**
- 2026-10-01: hang ~6.5 min into a sea battle. In the next 30-min run the list peaked at 4153 entries by ~4 min, then drained to 0-1: no hang.
- 2026-10-03 (PID 4436): ~8 min in, with heavy teleporting and camera swings between ships.
- 2026-10-03 (PID 20056, Run 3): NO teleports, custom cameras, eval pauses or SetCustomSailSetting, same signature. FMOD thread CPU suggests spin began ~20 s after battle start, before any sail input; GABP stopped 4-5 min in. This weakens the camera-churn theory.
- 2026-10-03 (PID 18568, Run 4b), Native+NavalDLC music only (custom soundtrack stripped): the music hypothesis is **refuted**. FMOD thread CPU per 30 s: ~8 s on the campaign map, stable 15-20 s in battle (no gradual climb), then a step to pegged ~29 s at ~536 s into the battle. 3 `NAV_MESH: load finished` lines appeared in the 40 s before onset (correlation unchecked).
- 2026-10-03 (PID 22852, Run 5): **no hang**; battle completed (765 s). The later "GABS silent + FMOD ~100%" was a Rider pause (reason "step"), which looks identical from outside: **check the Rider session state before calling it a hang.**

**Code facts:** the fleet has ~10 sails; vanilla `MissionSail` Stop()s its 2 events without Release() whenever the camera leaves the ship's 100 m radius (a plausible list-growth source). Mid-battle `NAV_MESH: load finished` lines are NOT ship spawns: `ShipAttachmentMachine` imports `ship_connection_plank_navmesh_1` for each boarding plank or bridge.

**Next:** avoid teleports, camera swings and GABS polling; A/B test with vanilla ships via the `naval.set_mission_ships` and `naval.start_mission` console commands, sampling the FMOD thread CPU from battle start (sampler: PowerShell script polling thread CPU per 30 s).

It is believed to be an intermittent vanilla FMOD issue, not mod ship data (it reproduced with the mod's soundtrack stripped). Related: [[ws-psai-duplicate-ids-with-native-soundtrack]], [[rider-eval-pause-looks-like-hang]], [[debugger-pause-kills-gabp-game]]
