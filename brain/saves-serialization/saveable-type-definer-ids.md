---
name: saveable-type-definer-ids
description: Each mod needs its own SaveableTypeDefiner base id and must keep ids stable; custom decision outcomes use consecutive ids.
type: lesson
topic: saves-serialization
tags: [save, definer]
sources: [doc/feudal-title-transfer-design.md, doc/feudal-titles.md]
updated: 2026-10-18
---

# Saveable type definer ids

Register custom saveable classes through a `SaveableTypeDefiner` with a unique base id (mods pick a large arbitrary number) and give each class a fixed offset. Never renumber: ids are part of the save format. Decision/outcome classes follow the vanilla pattern of `[SaveableField]` string ids and an empty image identifier.

For mod state that is not worth a saveable class, flatten to pipe-delimited strings under a `SyncData` key and keep a tolerant deserialiser (skip malformed lines, accept old field counts). Add new state under a new key instead of changing an existing format. Derived data (for example claims computed from bloodlines) should be rebuilt on load, not trusted from the save.

Related: [[kingdom-decision-lifecycle]], [[vanilla-save-container-definitions]]
