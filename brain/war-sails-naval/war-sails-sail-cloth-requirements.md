---
name: war-sails-sail-cloth-requirements
description: Sail cloth works only when the sail has saved Cloth Editor settings and the mission sail has a banner child; values and shortcuts that were verified.
type: howto
topic: war-sails-naval
tags: [war-sails, cloth, sail]
sources: [doc/ws-sail-cloth-guide.md, evidence/ws-sail-needs-cloth-simulator-and-top-banner, doc/ws-sail-cloth-guide.md]
updated: 2026-10-18
---

# War sails sail cloth requirements

- `SailClothComponent` needs cloth settings saved in the Cloth Editor on each sail mesh. Without saved settings the component exists but does nothing.
- `MissionSail` needs a `bd_banner_b` child entity carrying cloth on every sail.
- Native values to copy: max distance 12, collision body `sail_pole`.
- Do not copy the burning `_free` mesh of a native sail; it is a separate effect mesh.
- Cloth works without `force_enable_cloth` once the component and settings exist; there is no UI toggle for that flag.
- Sails behave like flags when the bottom corners are unpinned or the vertex-paint border ring (B=0) is missing; compare with a vanilla sail.

Two NREs that appear when these prerequisites are missing (verified fix):
1. `SailVisual.GetDimensions` NRE: the sail has no `ClothSimulator` component because the Cloth Editor settings were never saved. Open each sail mesh in the Cloth Editor and "Save mesh settings".
2. `MissionSail.UpdateForcedWindOfSailsAndTopBanner` NRE every tick: `SailTopBannerEntity` is null. NavalDLC finds it as a child entity tagged `bd_banner_b` and does not null-check. Add a child entity to each sail prefab with tags `bd_banner_b` and `banner_with_faction_color`, a flag mesh (the generic ship flag), local position about (0, 0, 1.5) and scale 2.

In one mod all seven sails were set to vanilla cloth params (FIXED 2026-10-02).

Related: [[ws-movement-set-swim-dive-slots-must-be-defined]], [[ws-sail-cloth-params-frozen]], [[ws-sail-vertex-paint-pins]]
