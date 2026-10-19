---
name: bannerlord-navmesh-preview
description: Render an offline top-down preview of a Bannerlord scene navmesh over decoded terrain, including face edges, vertices, and Mountain/Lake classifications. Use when inspecting navmesh coverage or comparing a candidate navmesh.bin; this is not runtime or editor validation.
---

# Bannerlord Navmesh Preview

Use `scripts/render_navmesh_preview.py` to produce a read-only PNG from a scene directory containing `scene.xscene`, `terrain.bin`, and `navmesh.bin`.

```powershell
python scripts/render_navmesh_preview.py "<scene-directory>" --bounds X0 X1 Y0 Y1 --output "<preview.png>"
```

Pass `--navmesh <candidate.navmesh.bin>` to preview a candidate while retaining the scene terrain, The script imports Bannerlord Navmesh Studio's parsers: pass `--studio <checkout>` or set `BANNERLORD_NAVMESH_STUDIO`; if neither is given it uses `./submodules/bannerlord-agent/tools/BannerlordSceneStudio` relative to the working directory, else the script exits asking for one of them. In that case resolve the checkout as the `bannerlord-navmesh-studio` skill describes and pass it as `--studio`.

The plot preserves Bannerlord world X/Y orientation (Y increases upward), decodes terrain elevation from `terrain.bin` using the scene parameters, reads the scene water level when present, draws actual polygon edges and red vertices, and fills `g3=7` Mountain faces purple and `g3=8` Lake faces blue.

Treat the image as an offline diagnostic plot, not a Bannerlord editor screenshot. It does not validate navmesh connectivity, topology, agent traversal, face abilities, serialization safety, or runtime behavior. Use the editor/game and appropriate structural checks for those claims.

For a full navmesh setup or repair, the mod's own agent package may ship a setup and repair guide; a simple preview render does not need one.
