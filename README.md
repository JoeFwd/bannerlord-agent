# bannerlord-agent

A generic [APM](https://github.com/microsoft/apm) package for AI-assisted
Mount & Blade II: Bannerlord modding with Claude Code or Codex. It is mod-neutral.
A mod adds its own context in a separate package that depends on this one.

## Contents

| Path | What it is |
|---|---|
| `.apm/skills/` | Debugging and tooling skills: `bannerlord-debug`, `bannerlord-gabs-start` / `-session-reset` / `-battle-manager`, `bannerlord-modding-tools`, `bannerlord-crafting-offsets`, `bannerlord-navmesh-studio`, `bannerlord-navmesh-preview`, `bannerlord-lord-hall-battle`, sprite tools, music classification |
| `.apm/agents/` | `bannerlord-debug-playtester`: a live GABS/Rider verification agent |
| `.apm/hooks/` | SessionStart (starts the local MCP backends and GABS) and a PreToolUse guard that blocks GABS calls while Rider is paused |
| `.apm/mcp/mcp-http-stdio-bridge.py` | A stdio-to-HTTP MCP bridge for the local servers |
| `brain/` | The knowledge base: one lesson per note, Obsidian wikilinks. Start at `brain/INDEX.md` |

## Install

In your mod's agent package (or directly in the mod repo's `apm.yml`):

```yaml
dependencies:
  apm:
    - JoeFwd/bannerlord-agent#v0.1.1
```

MCP servers are declared by the consuming project, which owns the ports. Example:

```yaml
  mcp:
    - name: bannerlord-game-controller
      registry: false
      transport: stdio
      command: python
      args:
        - apm_modules/JoeFwd/bannerlord-agent/.apm/mcp/mcp-http-stdio-bridge.py
        - --url
        - http://localhost:8080/mcp
    - name: jetbrains-debugger
      registry: false
      transport: stdio
      command: python
      args:
        - apm_modules/JoeFwd/bannerlord-agent/.apm/mcp/mcp-http-stdio-bridge.py
        - --url
        - http://localhost:29202/debugger-mcp/streamable-http
    - name: bannerlord-search-1_4_8      # one per game version
      registry: false
      transport: stdio
      command: python
      args:
        - apm_modules/JoeFwd/bannerlord-agent/.apm/mcp/mcp-http-stdio-bridge.py
        - --url
        - http://localhost:5002
```

The SessionStart hook reads the `bannerlord-search-<version>` entries from `.mcp.json` and
starts one BannerlordSearch server per version, on port 5000 and up.

## Environment variables

| Variable | Purpose |
|---|---|
| `GABS_EXE` | The `gabs.exe` path. If unset, `gabs` must be on PATH |
| `ASSERT_AUTO_IGNORE_EXE` | Optional. The AssertAutoIgnore popup dismisser |
| `BANNERLORD_CRAFTING_TOOL` | The BannerlordCraftingTool checkout, for `bannerlord-crafting-offsets` |
| `BANNERLORD_NAVMESH_STUDIO` | The Bannerlord Navmesh Studio checkout, for the navmesh skills |

## Project settings

Mod-specific values are shipped by the mod's package as a "Bannerlord agent settings"
instruction. These values are:
- the Rider debug configuration and `project_path`
- the log file
- the new-game option
- the evaluation-breakpoint anchor
- the cheat commands
- the module and install locations

## Brain

`brain/` is plain markdown. Open it, or a parent folder that also contains your mod's brain,
as an Obsidian vault. Link notes as `[[slug]]`, where the file name equals the slug. To edit
the brain:
1. Change the bannerlord-agent git checkout, not `apm_modules/`.
2. Tag a release.
3. Bump the tag in the consumer.
