---
name: navmesh-bridge-deck-over-water-construction
description: How a campaign-map bridge is modelled in navmesh - a terrain-1 convex quad deck laid over retained river/underbridge water faces, with an intentional 0.17 m vertical split.
type: reference
topic: navmesh
tags: [navmesh, bridges, campaign-map, rivers]
sources: [src/.tmp/xy-layer-audit.md, src/.tmp/astra-bridge-final-review/REPORT.md]
updated: 2026-10-18
---

# Bridge decks in navmesh

The working model (matched the reference Thames bridges):

- The river stays as water faces (terrain 11, plus terrain 25 under the deck). Water is NOT cut away.
- A convex quad of terrain 1 sits on top, roughly Z 10.45, while water sits at ~10.28 (0.17 m split, intentional). Deck quads cover the pier positions within 0.1 m; reference deck quads had min angles 79-88 degrees.
- Deck ends connect to bank faces through short "connector" faces.
- A correct bridge produces many XY edge crossings and partial collinear overlaps (deck vs water, deck vs shoreline) that are height-layered, not defects. 157 new crossings were all <0.5 m apart vertically, so a Z threshold cannot separate good from bad; face ownership must (see [[navmesh-xy-overlap-classification-gate]]).
- Connectors that cross a dry bank (terrain 6) edge are genuine defects: trim or move connector vertices so they clear dry faces in XY.
- Verify passability with a graph walk ([[navmesh-bridge-two-bank-route-gate]]).

Pier origins are reliable but scene data has no mesh extents ([[scene-transforms-lack-mesh-bounds]]).

Related: [[campaign-navmesh-terrain-type-ids]]
