---
name: ws-ship-navmesh-boarding-face-rules
description: NavalDLC ship navmesh boarding ids (NMG9 g3, 1..50) must each be on exactly ONE face with at least one unshared edge, and every attachment machine must sit inside the face with its id; split quads are suspected of a native AV in boarding melee
type: lesson
topic: war-sails-naval
tags: [war-sails, navmesh, nmg9, g3, boarding, shipattachmentmachine, checkattachednavmeshsanityaux]
sources: [memory/ws-ship-navmesh-boarding-face-rules.md]
updated: 2026-10-18
---

# Ship navmesh boarding-face rules

NavalDLC `MissionShip.CheckAttachedNavmeshSanityAux` enforces on a ship's NavMeshPrefab:
- each non-zero face group id (NMG9 face field **g3**), range 1..50, is on **exactly one face**;
- that face has **at least one unshared edge** (not fully enclosed);
- every `ShipAttachmentMachine` / `ShipAttachmentPointMachine` with `RelatedShipNavmeshOffset` N sits **inside** the face with id N (not on a cell corner).

**Failure shape:** a boarding id on a split quad (2 triangles), fully enclosed, with machines exactly on cell corners. Suspected cause (hypothesis until a boarding playtest passes) of a native AV at `Native!create_game_application+0x2c4bb` in the boarding melee.

**Fix:** one outboard quad per id, machines re-centred on it.

**How to apply:** rerun the check after ANY navmesh regeneration by authoring scripts; regeneration reintroduces the split. Check with a navmesh dump tool that lists faces per id (`.bin` = u32 size + NMG9).

Related: [[navmesh-faces-must-be-tris-or-quads]], [[ws-climber-yaw-convention]]
