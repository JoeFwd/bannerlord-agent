---
name: settlement-gate-on-non-land-face-pathfinding-av
description: A native AccessViolation in GetPathBetweenAIFaceIndicesWithRegionSwitchCost during AI distance scoring means a settlement GATE sits on a non-land navmesh face (face index -1); scan Settlement.All for gate face < 0 and move the gate onto land
type: lesson
topic: campaign-map
tags: [settlement, gate_pos, navmesh, access-violation, pathfinding, ai-scoring]
sources: [memory/scotland-port-village-pathfinding-av.md]
updated: 2026-10-18
---

# Gate off the land navmesh = native pathfinding AV

**Symptom:** a first-chance, fatal `AccessViolationException` about one in-game hour after unpausing. Stack, no mod frames: `AiMilitaryBehavior.AiHourlyTick` -> besiege/raid distance scoring -> `NavalDLCMapDistanceModel.GetDistance` -> `SandBoxNavigationCache.GetRealDistanceAndLandRatioBetweenSettlements` -> native path query (`GetPathBetweenAIFaceIndicesWithRegionSwitchCost`).

**Root cause:** a castle's gate sat on a water face, so the land `GetFaceIndex` returns -1 and the native path search crashes on start face -1. Nearby port villages with `port_posX/Y` were a red herring, as were the caches. Fix: move each gate about 1.3 units onto land via `gate_posX/gate_posY` in settlements.xml. Any settlement type accepts these attributes (`Settlement.Deserialize`), so the scene capsule is untouched.

**Scan (evaluate in any paused managed frame):** filter `Settlement.All` (fortifications and villages) to those where `MapSceneWrapper.GetFaceIndex(new CampaignVec2(s.GatePosition.ToVec2(), true)).FaceIndex < 0`, plus port villages whose `PortPosition` gives a sea face < 0. Run it after any navmesh or settlement move.

**Triage:** frame locals by index: frame 4 = `GetRealDistance` (`settlement1/2`), frame 8 = `NavalDLCMapDistanceModel.GetDistance` (`fromMobileParty`, `toSettlement`). Reproduces on committed and uncommitted navmesh alike, so do not blame the WIP edit.

Related: [[map-settlement-position-two-files]], [[navmesh-faces-must-be-tris-or-quads]]
