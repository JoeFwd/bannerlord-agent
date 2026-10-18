---
name: settlement-shell-prefab-structure-rules
description: Town/castle prefab shells have a functional subtree (gates, siege anchors, breach) that must not be scaled, retagged or reordered.
type: lesson
topic: campaign-map
tags: [campaign-map, prefab, siege]
sources: [sdd/scottish-siegeable-prefab-shells, sdd/scottish-campaign-prefabs]
updated: 2026-10-18
---

# Settlement shell prefab structure rules

- Town and Castle campaign prefabs have a fixed functional shell: tag cardinalities and the order of children under siege/breach anchors matter. Tags are located recursively, and the FIRST child of a siege/breach anchor is what code reads.
- Never scale, retag or reorder functional subtrees. Scale or move the decorative wrapper instead.
- `main_map_city_gate` is consumed by the settlement visual code. The native castle map icon carries both gate tags, so a custom castle shell must keep both.
- Scene instances already expanded from a prefab do NOT follow later prefab edits; re-expand or patch the scene.
- A village prefab with root scale 1.247 needs inverse compensation on children that must stay at world scale.
- Breach wrappers were found buried more than 10 m below the shell's ground reference; check them before shipping.
- Offline LOD0 preview renders do not prove collision, navigation or terrain. Preview with a common camera and shared ground plane, not auto-framing (auto-framing hides scale errors). A preview-card ground z bug made card tops disagree with prefab-local ground.
- A guide that used generic names (`circle`, `camp_area_1`) instead of the real ids (`map_settlement_circle`, `map_camp_area_1`) was caught by review; verify identifiers against shipped prefabs.

Related: [[xscene-byte-preserving-span-edits]], [[map-settlement-position-two-files]]
