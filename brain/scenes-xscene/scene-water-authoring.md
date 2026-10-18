---
name: scene-water-authoring
description: Scenes get water from a global water_properties plane or from local water_plane/water_body entities; 1.4.8 added choppiness and a non-naval material override; a terrain re-save can silently drop rivers.
type: reference
topic: scenes-xscene
tags: [water, scene, xscene, 1.4.8]
sources: [doc/scene-water-audit.md, doc/ws-sail-cloth-guide.md]
updated: 2026-10-18
---

# Scene water authoring

- A scene can have one global `water_properties` plane (sea level), plus local `water_plane` / `water_body` entities for moats, rivers and ponds.
- 1.4.8 adds `choppiness` and `non_naval_water_material_override` parameters.
- The War Sails naval mod ships its own `water_prefabs.xml` with `wat_naval_*` materials; those materials are meant for sea scenes, not for moats.
- A terrain re-save in the editor can silently remove rivers or ponds even though the XML you diff looks identical. After any terrain save, compare water entities and take a screenshot.

In one mod a castle's moat disappeared this way: the scene XML was unchanged but the water body no longer rendered. Audit every scene with local water after any terrain edit.


