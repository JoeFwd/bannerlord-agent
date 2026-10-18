---
name: settlement-nameplate-relation-ints
description: The settlement nameplate relation integer: 0 default, 1 same faction, 2 war, 3 alliance (3 added in 1.4).
type: reference
topic: campaign-map
tags: [ui, nameplate, 1.4]
sources: [doc/feudal-private-wars-manual-test-guide.md, doc/feudal-private-wars-design.md]
updated: 2026-10-18
---

# Settlement nameplate relation ints

Settlement and party nameplate VMs colour by a relation int: 0 default, 1 same faction, 2 at war, 3 alliance (alliance added in 1.4). A mod that wants a custom tint (feud, vassalage) can extend the nameplate prefabs through UIExtenderEx and switch on its own state. Nameplates must be refreshed when the state changes, and recycled nameplates must be tested after panning away and back. UIExtenderEx logs failed prefab extensions: check that log after changes.
