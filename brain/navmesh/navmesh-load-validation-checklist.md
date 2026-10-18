---
name: navmesh-load-validation-checklist
description: Howto - offline integrity checks to run on a navmesh.bin before deploying (header sizes, face arity, edge ownership, isolated vertices, round trip, water components, SHA backups).
type: howto
topic: navmesh
tags: [navmesh, validation, rnm1, nmg9]
sources: [src/.tmp/warsails-rivers-live-baseline-audit.out, src/.tmp/river-quad-merge-candidate/REPORT.md, src/.tmp/studio-candidate-scene/LIVE-RECEIPT.md]
updated: 2026-10-18
---

# Pre-deploy navmesh checklist

1. RNM1 header: version 3, declared == actual uncompressed size.
2. Every face is a triangle or quad ([[navmesh-faces-must-be-tris-or-quads]]); CCW positive area, strictly convex.
3. No invalid vertex/edge refs, no duplicate vertex or edge ids inside a face, no self edges, no isolated vertices, every edge referenced and agreeing with its face boundary, at most two owner faces per edge.
4. Parse -> serialize -> write -> read round trip is byte-identical on an untouched mesh.
5. Connectivity: water component count and largest passable land component before vs after must not change unless intended.
6. Record SHA-256 of live before/after, keep an exact backup of the pre-promotion file; after deploy reload the live scene from disk in the viewer and re-read counts.
7. Add the strict XY gate ([[navmesh-xy-overlap-classification-gate]]).

Related: [[navmesh-duplicate-corner-face-crash]]
