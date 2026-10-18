---
name: navmesh-bridge-two-bank-route-gate
description: Howto - prove a bridge deck is usable by walking the passable-face graph from the deck to land on both banks, using the terrain ids the real party navigation model accepts.
type: howto
topic: navmesh
tags: [navmesh, bridges, pathfinding]
sources: [src/.tmp/audit_bridge_land_routes.py, src/.tmp/roman-corridor-design/README.md]
updated: 2026-10-18
---

# Two-bank route gate

Convex geometry covering the piers does not mean the bridge works. Build face adjacency over edges owned by exactly two faces, restrict to terrain ids the installed navigation model admits ([[campaign-navmesh-terrain-type-ids]]), and BFS from the deck face. Each deck must touch passable land on both recorded banks and be inside the largest passable component (~19,000 faces on one map).

Failures found: deck isolated because both banks were terrain 14 (RuralArea town ground); bank on one side only. Do not repaint whole terrain-14 faces passable: towns extend across them. A narrow corridor needs real clearance (>= 0.6-0.8 m) between building origins; origin-based checks gave only 0.2-0.54 m, so none was built. Building bounds are not in scene transforms ([[scene-transforms-lack-mesh-bounds]]).

Related: [[navmesh-bridge-deck-over-water-construction]]
