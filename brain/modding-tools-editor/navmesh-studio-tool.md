---
name: navmesh-studio-tool
description: The user's navmesh studio (env BANNERLORD_NAVMESH_STUDIO) - read/edit/generate suite for any scene navmesh.bin; usage, limits (terrain-only generate, no weld, GUI cannot add faces) and launch gotcha
type: reference
topic: modding-tools-editor
tags: [navmesh, tool, rnm1, nmg9, fastapi, probe-point]
sources: [memory/navmesh-studio-tool.md, navmesh-studio-tool-overview]
updated: 2026-10-19
---

# Navmesh studio tool (`BANNERLORD_NAVMESH_STUDIO`)

A standalone tool outside the repos: a general **navmesh read/edit/generate/write suite** for any scene's `navmesh.bin` (RNM1 LZ4 container wrapping an NMG9/NMG8 payload), plus a campaign-map settlement-placement feature.

- **Stack:** Python + FastAPI/uvicorn on hardcoded `127.0.0.1:8770`; built React/R3F SPA in `server/static/dist`.
- **Launch:** `python server/web.py "<scene_dir>"` (works from Bash). **Gotcha (PowerShell):** `Start-Process -ArgumentList @(...)` array form splits a path containing spaces, loading the wrong dir while uvicorn still starts cleanly. Always confirm via `GET /api/info`.
- **Direct Python beats the HTTP API for analysis:** `sys.path.insert(0, tool_dir)` then `blnav.nmg9.NavMesh.parse(blnav.rnm1.read(path))`. Faces expose raw `g1..g6`; `g3` = dynamic face id (`SetAbilityOfFacesWithId`), `g5` = signed scene-level mask, `g6` = byte flag.
- **Read-only endpoints:** `/api/info`, `/api/mesh`, `/api/terrain`, `/api/navmesh/inspect-region`, `/api/navmesh/probe-point?x=&y=` (returns `decoded_terrain_height` plus every face whose XY footprint contains the point, with vertices and g1..g6). **Never** call `/api/save` or `/api/save_entities` in a test.

**Three limits deciding whether it can fix a defect:**
1. `generate` is terrain-only; it cannot produce anything above `terrain.max_height`, so prefab floors, ramparts and tower interiors are out of reach.
2. `generate` with `replace=false` does not weld: it appends vertices at an index offset and `rebuild_edges()` keys edges on vertex indices, so the patch shares no edge with the existing mesh and lands as a fresh island. Weld onto existing vertex ids.
3. The web GUI can delete faces and set `g3`/`g5` and generate, but cannot add a face. Face authoring is MCP-side (`add_face`, `move_vertex`, `snap_to_terrain`) or direct Python.

Verify a repair by recomputing connected components over **shared edge ids**, not vertex proximity. See [[navmesh-faces-must-be-tris-or-quads]], [[navmesh-duplicate-corner-face-crash]].

Parts: `blnav` (formats and editing core), an MCP server, the web GUI, and, on the `scene-generation` branch only, `blscene` (scene composer, see [[scene-composer-workflow]]). MCP tools: load_scene, scene_info, sample_height, query_faces, generate_navmesh, add_face, delete_faces, set_face_attributes, validate_navmesh, move_vertex, snap_to_terrain, save_navmesh, export_obj. The generator uses 4 m grid cells, a 40 degree slope limit and quad faces, then rebuilds edges. GUI camera keys use `event.code` (physical key position): WASD on QWERTY is ZQSD on AZERTY. Tests: unit tests plus a Gherkin/Playwright suite that boots its own server on an ephemeral port and never calls save endpoints. Formats: [[rnm1-container-format]], [[ok01-terrain-ed-format]].

