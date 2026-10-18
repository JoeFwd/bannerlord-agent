---
name: campaign-navmesh-terrain-type-ids
description: Campaign map navmesh g3 terrain-type enum (1 Plain ... 25 UnderBridge) and code facts about water types.
type: reference
topic: navmesh
tags: [navmesh, campaign-map, terrain-type]
sources: [native_rivers/findings.md, tmp/campaign-navmesh-face-terrain-id-g3, superpowers/navmesh-face-terraintype-g3-classifier]
updated: 2026-10-18
---

# Campaign navmesh terrain types (g3)

1 Plain, 2 Desert, 4 Forest, 5 Steppe, 6 Fording, 7 Mountain, 8 Lake, 10 Water, 11 River, 13 Canyon, 14 RuralArea, 17 Bridge, 18 CoastalSea, 19 OpenSea, 20 Beach, 21 Cliff, 22 NonNavigableRiver, 23 LandRestriction, 24 SeaRestriction, 25 UnderBridge.

Types 17-25 only have faces when the naval (War Sails) content is present; on a machine without it they had zero faces, so conclusions about them come from decompiled code, not data.

Code facts (decompiled 1.4.6): River and UnderBridge give RiverCrossingBattle; land parties take a -30% speed malus on water types; `GetPathBetweenAIFaces` takes separate land-to-sea and sea-to-land switch costs, so a water sheet must be edge-connected to land wherever embarking is allowed; naval patrol AI samples until the face type is CoastalSea, NonNavigableRiver, River or UnderBridge.

Observed on a War Sails campaign map (NMG9 inside an RNM1 container; each face has `g3` terrain id and `g5` flag bits, bit 4 marking naval faces with g3=0 in scene navmeshes): 1 is ordinary passable land and also bridge decks, 6 is a dry bank variant (deck-vs-6 crossings are real defects), 11 river, 14 RuralArea (town/village ground), 18/19 open sea, 25 water passing beneath a deck.

The default party navigation model admitted `{1,2,3,4,5,6,7,9,12,13}` for land parties. Terrain 14 is NOT in that set, so a deck whose banks are terrain 14 is topologically connected yet unreachable for land parties.

Classify by `g3` membership, never by vertex Z or height: an audit that used vertex Z reported a false failure on a small island whose land faces sit near sea level. Treat water as the set {8,10,11,18,19,22,24}. Use g3 ownership to classify any overlap ([[navmesh-xy-overlap-classification-gate]]). `g5` is a separate raw attribute (level/siege bit mask) and must be preserved verbatim by any surgery ([[navmesh-surgery-rules-for-existing-meshes]]).

Terrain grid reference for a campaign map: 2049x2049 nodes, 70 m spacing, about 1120 m world extent per the scene.

Related: [[navmesh-bridge-deck-over-water-construction]], [[xscene-declares-level-bit-mapping]], [[navmesh-g3-differs-campaign-vs-scene]], [[campaign-navmesh-river-lake-conventions]], [[campaign-position-is-vec2-plus-onland-flag]]
