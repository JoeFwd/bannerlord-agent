---
name: bannerlord-navmesh-studio
description: >
  Bannerlord Navmesh Studio: a Python library, web GUI and MCP server that reads and
  writes scene navmesh.bin (RNM1/NMG9) and navmesh prefabs (NMG8), reads terrain.bin (ZGR6),
  and documents the terrain_ed.bin container (OK01). Use it when inspecting, validating, generating or
  hand-editing a scene or campaign-map navmesh, sampling terrain heights, checking g5
  scene-level masks, or placing settlements on a campaign map navmesh.
---

# Bannerlord Navmesh Studio

The studio is a Git repository (https://github.com/JoeFwd/BannerlordSceneStudio). Its path is
`$env:BANNERLORD_NAVMESH_STUDIO`. If the variable is unset, resolve it with the bannerlord-agent
package's resolver (`apm_modules/JoeFwd/bannerlord-agent` in a consumer repo):

```powershell
$env:BANNERLORD_NAVMESH_STUDIO = & <bannerlord-agent>/scripts/resolve-tool.ps1 BannerlordSceneStudio
```

It returns the `tools/` submodule of an editing checkout if one exists. Otherwise it clones the
studio into `~/.bannerlord-agent/tools/BannerlordSceneStudio` at the commit pinned in
`tools.lock.json`. It never updates an existing clone; pass on any commit-mismatch warning to
the user. Never guess a path.

Run its scripts with uv and this skill's `requirements.txt`, which pins the studio's dependencies.
uv keeps them in its own cache, so nothing is installed into your Python and nothing is written
into the checkout. `<skill>` below is the absolute path of this skill's folder (`.claude/skills/bannerlord-navmesh-studio`).

## Layout

- `blnav/`: core formats (`rnm1`, `nmg9`, `nmg8`, `terrain`, `xscene`, `lz4raw`, `generate`)
- `server/web.py`: web GUI on http://127.0.0.1:8770
- `server/mcp_server.py`: MCP server for LLM-driven editing
- `tests/`: round-trip and validation suite
- `README.md`: the full decoded format reference (RNM1, NMG9, NMG8, ZGR6, OK01). Read it before
  reasoning about bytes.

The experimental scene composer (`blscene/`), corpus harvesting and the ZGR6 terrain writer
(`blnav/terrain_write.py`) are not on `develop`. They live on the studio's `scene-generation`
branch.

## Web GUI

```powershell
uv run --isolated --no-project --python 3.12 --with-requirements "<skill>\requirements.txt" "$env:BANNERLORD_NAVMESH_STUDIO\server\web.py" "<module>\SceneObj\<scene>"
# open http://127.0.0.1:8770
```

It shows terrain and navmesh in 3D. You can select faces, delete them, set the face id or
scene-level mask, generate a navmesh from the terrain, and save. The first save keeps a `.bak`.

## MCP server

To use it, register it in the project's MCP config:

```jsonc
"bannerlord-navmesh": {
  "command": "uv",
  "args": ["run", "--isolated", "--no-project", "--python", "3.12", "--with-requirements",
           "<skill>/requirements.txt", "<BANNERLORD_NAVMESH_STUDIO>/server/mcp_server.py"]
}
```

| Kind | Tools |
|---|---|
| Read-only | `load_scene`, `scene_info`, `sample_height`, `query_faces`, `inspect_navmesh_region`, `probe_navmesh_point`, `validate_navmesh` |
| Mutating | `generate_navmesh`, `add_face`, `delete_faces`, `set_face_attributes`, `move_vertex`, `snap_to_terrain` |
| Writes files | `save_navmesh`, `export_obj` |

Typical flow:
1. `load_scene(dir)`
2. `validate_navmesh` and `inspect_navmesh_region`
3. Edit.
4. `validate_navmesh` again.
5. `save_navmesh()`, only when the user asked for the change.

## Safety rules

- **Read-only by default.** Never call `save_navmesh`, `/api/save` or `export_obj` over a game
  file unless the user asked for that write. Tests and probes use read-only endpoints only.
- **Don't take over the user's server.** Do not start, restart or kill a web server already
  listening on port 8770 without asking. It may hold the user's unsaved edits.
- **Don't touch the checkout.** Never commit, reset or clean the studio repo. It usually has
  uncommitted work in progress.
- **Preserve g5 masks.** `g5` is a signed scene-level visibility bitmask, not an island id:
  base=1, level_1=2, level_2=4, level_3=8, civilian=16, siege=32, looted=64.
  - The vanilla Main_map mostly uses `-109`. New Main_map faces default to `-109`, and faces
    in other scenes default to `-1`.
  - Never normalise existing masks.
  - Read the scene's `<levels>` block in `scene.xscene` before decoding.
- **Use only tris and quads.** An n-gon face, or a quad with a repeated corner, crashes the
  native navmesh loader.
- **Accept the LZ4 difference.** Re-encoded LZ4 is valid but not byte-identical to TaleWorlds'
  encoder. Payloads round-trip byte-identically.

## Validation

```powershell
cd $env:BANNERLORD_NAVMESH_STUDIO
uv run --isolated --no-project --python 3.12 --with-requirements "<skill>\requirements.txt" tests/test_roundtrip.py  # byte-identical NMG9 re-serialisation
uv run --isolated --no-project --python 3.12 --with-requirements "<skill>\requirements.txt" tests/test_mcp.py        # MCP tools end-to-end, in-process
```

`tests/test_web.py` needs the web server running. Ask before you start one.

Related skills: `bannerlord-navmesh-preview` (headless PNG renders through the studio),
`bannerlord-modding-tools` (`references/navmesh.md`).
