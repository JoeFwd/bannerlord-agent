---
name: raycast-collision-roots-must-follow-relocated-art
description: Selection colliders (bo_sphere_collider, raycast-only) on campaign settlements keep stale positions when art is compacted; relocate them with the art.
type: lesson
topic: scenes-xscene
tags: [campaign-map, collision, review]
sources: [sdd/scottish-prefab-compaction/task-2-report.md, task-2-review.md]
updated: 2026-10-18
---

# Raycast collision roots must follow relocated art

Campaign settlement shells carry raycast-only sphere colliders (`bo_sphere_collider` + `only_collide_with_raycast`) that decide where a click selects the settlement. They are siblings of the art, not children, so moving or shrinking the art leaves them behind.

- In one compaction, 145 such roots (4 `bo_town` per Town, 3 `bo_castle` per Castle) kept their old positions; one Town collider sat outside the new shell. The first report claimed they had moved. A reviewer diffed transforms against the parent commit and found all 145 unchanged.
- Fix: give each collider path a declared new selection centre inside the new curtain envelope (spread over districts: e.g. court, service range, keep), change position only, keep scale/flags/orientation/descendants.
- Add a hard assertion that the movement manifest covers every required collider path, and prove the fix by replaying exactly those position substitutions on the earlier scene bytes and reproducing the final bytes.
- Coverage here means selection-centre distribution; sphere extents and native hit continuity are not proven offline.

Legacy tag detail: a castle's siege ancestor can carry `main_map_castle_gate` while a separate functional child carries `main_map_city_gate`; the settlement visual reads `main_map_city_gate`. Keep both as shipped natively.

Related: [[settlement-shell-prefab-structure-rules]], [[xscene-byte-preserving-span-edits]]
