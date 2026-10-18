---
name: scene-entity-levels-require-all
description: An entity with several assigned scene levels appears only when the mission contains ALL of them.
type: lesson
topic: scenes-xscene
tags: [scenes, levels]
sources: [docs/scene-authoring-reference.md]
updated: 2026-10-18
---

# Level semantics

An entity (and navmesh face) is present only if the mission's active levels include every level it is assigned. Assign the narrowest set that is truly required.

Related: [[navmesh-g5-scene-level-mask-not-island]], [[xscene-declares-level-bit-mapping]]
