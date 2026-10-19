# bannerlord-agent

A generic [APM](https://github.com/microsoft/apm) package for AI-assisted
Mount & Blade II: Bannerlord modding with Claude Code or Codex. It is mod-neutral.
A mod adds its own context in a separate package that depends on this one.

## Quick start

APM (Agent Package Manager) installs agent packages the way npm installs libraries. It copies
each package's skills, agents, hooks and instructions into your project's `.claude/` and
`.codex/` folders, and writes `.mcp.json` from the `mcp:` list in `apm.yml`.

```powershell
irm https://aka.ms/apm-windows | iex   # install APM once (macOS/Linux: see the APM README)
apm install                             # in the repo with apm.yml: fetch packages, deploy them
apm update --yes                        # after bumping a dependency tag in apm.yml
```

See [Install](#install) for the `apm.yml` lines that add this package.

## What it installs on your machine

| When | What | Where |
|---|---|---|
| `apm install` | This package and its dependencies, pinned to the tags in `apm.lock.yaml` | `apm_modules/`, `.claude/`, `.codex/` and `.mcp.json` in your project |
| Each session start (hook) | `BannerlordSearch.Mcp.Server` 0.2.0, a global .NET tool | `~/.dotnet/tools` |
| | `BannerlordSearch.Source`, one NuGet package per `bannerlord-search-<version>` server (the game's source, for code search) | `~/.nuget/packages/bannerlordsearch.source/<version>` |
| | `JetBrainsDebuggerPauseMonitor` 1.0.0, a global .NET tool, plus an `nlog.config` next to it if the package lacks one | `~/.dotnet/tools` |
| | Background processes: one search server per version (ports 5000+), the pause monitor (7777) and GABS (8080). If port 8080 is not answering, any running `gabs` process is stopped and restarted | logs in `%TEMP%` |
| First use of `bannerlord-crafting-offsets` or the navmesh skills | A `git clone` of the tool at the commit pinned in `tools.lock.json`, skipped if `BANNERLORD_*` or the `tools/` submodule already provides it. The skill then builds it (`dotnet build`) or installs it (`pip install -e`) | `~/.bannerlord-agent/tools/<name>` |
| Sprite skills | `pip install Pillow` | your Python environment |
| `bannerlord-music-classify` | `mcp_local_music_analysis` 0.1.0 and `mcp` 1.30.0 from PyPI, run by `uvx` for the `music-analysis` MCP server (their other dependencies are not pinned). The skill also expects `ffmpeg` on PATH; it does not install it | uv's tool environment |

Nothing else is downloaded. Every version above except Pillow and the music server's indirect dependencies is pinned by the package release,
so upgrading the package is the only thing that changes them. APM deploys the hooks without a
trust prompt (it only gates `bin/` executables, which this package has none of), so the
session-start hook runs as soon as you open the next session. An existing tool clone is never updated in
place; the skill reports a commit mismatch instead.

## Contents

| Path | What it is |
|---|---|
| `.apm/skills/` | Debugging and tooling skills: `bannerlord-debug`, `bannerlord-gabs-start` / `-session-reset` / `-battle-manager`, `bannerlord-modding-tools`, `bannerlord-crafting-offsets`, `bannerlord-navmesh-studio`, `bannerlord-navmesh-preview`, `bannerlord-lord-hall-battle`, sprite tools, music classification |
| `.apm/agents/` | `bannerlord-debug-playtester`: a live GABS/Rider verification agent |
| `.apm/hooks/` | SessionStart (starts the local MCP backends and GABS) and a PreToolUse guard that blocks GABS calls while Rider is paused |
| `.apm/mcp/mcp-http-stdio-bridge.py` | A stdio-to-HTTP MCP bridge for the local servers |
| `brain/` | The knowledge base: one lesson per note, Obsidian wikilinks. Start at `brain/INDEX.md` |

## Prerequisites for live debugging

The GABS / Rider skills (`bannerlord-gabs-*`, `bannerlord-debug`, the playtester agent) need:

| Requirement | Why |
|---|---|
| JetBrains Rider 2026.1+ | runs the mod's debug configuration |
| [Debugger MCP Server](https://plugins.jetbrains.com/plugin/29233-debugger-mcp-server) Rider plugin | exposes the debugger at `http://127.0.0.1:29202/debugger-mcp/streamable-http` (the `jetbrains-debugger` MCP server and the PreToolUse pause guard use it) |
| [rider-clr-exception-override](https://github.com/JoeFwd/rider-clr-exception-override) Rider plugin | enforces the project's CLR exception breakpoint set, so the debugger stops on real crash exceptions instead of benign first-chance ones |
| [GABS](https://github.com/pardeike/GABS) + a GABP-enabled game | game control for the `bannerlord-game-controller` MCP server (`GABS_EXE`) |

Install both Rider plugins via **Settings -> Plugins** (the exception override from its release
`.zip` via **Install Plugin from Disk**). Then add a `.rider-debugger-settings` file next to the
mod's `.sln`, for example:

```properties
DotNetDebuggerSettings.processExceptionsOutsideMyCode=true

CLRExceptionBreakpoints=System.NullReferenceException,                         System.AccessViolationException,                         System.StackOverflowException,                         System.TypeInitializationException,                         System.IndexOutOfRangeException,                         System.ArgumentOutOfRangeException,                         System.ArgumentNullException
```

Listed types break on every suspend condition; all other CLR exception breakpoints are disabled
while the project is open, and restored when it closes.

## Install

In your mod's agent package (or directly in the mod repo's `apm.yml`):

```yaml
dependencies:
  apm:
    - JoeFwd/bannerlord-agent#v0.1.6
```

That is all. `apm install` writes these MCP servers into `.mcp.json`:

| Server | What it connects to |
|---|---|
| `bannerlord-search-1_2_12`, `-1_3_15`, `-1_4_8` | Game source search per version, on ports 5000-5002 (started by the session-start hook) |
| `bannerlord-game-controller` | GABS, port 8080 |
| `jetbrains-debugger` | The Rider Debugger MCP plugin, port 29202 |
| `music-analysis` | `mcp_local_music_analysis`, run by `uvx` |

APM only deploys MCP servers from packages your `apm.yml` lists directly. If you depend on this
package through another package (a mod layer such as dadg-agent), that layer must copy the
`mcp:` block from this `apm.yml` into its own. To add a game version, add a
`bannerlord-search-<version>` entry on a free port in your own `apm.yml`; the hook reads the
port from its `--url`.

## Environment variables

| Variable | Purpose |
|---|---|
| `GABS_EXE` | The `gabs.exe` path. If unset, `gabs` must be on PATH |
| `ASSERT_AUTO_IGNORE_EXE` | Optional. The AssertAutoIgnore popup dismisser |
| `BANNERLORD_CRAFTING_TOOL` | The BannerlordCraftingTool CLI checkout, for `bannerlord-crafting-offsets`. If unset, `scripts/resolve-tool.ps1` finds or clones it |
| `BANNERLORD_NAVMESH_STUDIO` | The Bannerlord Scene Studio checkout, for the navmesh skills. If unset, `scripts/resolve-tool.ps1` finds or clones it |

## Tool sources

The tool source is checked out as git submodules under `tools/`:

| Path | Repository |
|---|---|
| `tools/BannerlordCraftingTool.CLI` | https://github.com/JoeFwd/BannerlordCraftingTool.CLI |
| `tools/BannerlordSceneStudio` | https://github.com/JoeFwd/BannerlordSceneStudio |

Run `git submodule update --init --recursive` in an editing checkout to fetch them. Build the
CLI with `dotnet build tools/BannerlordCraftingTool.CLI/BannerlordCraftingTool.Cli -c Release`.

APM snapshots drop submodule contents, so `tools.lock.json` pins each tool's commit for consumers.
`scripts/resolve-tool.ps1 <name>` prints the checkout to use, in this order:
1. the tool's env var
2. the `tools/` submodule
3. `~/.bannerlord-agent/tools/<name>`, cloned at the pinned commit if missing

To release a tool bump, move the submodule pointer, update `tools.lock.json` to the same commit,
and check that they agree before tagging:

```powershell
./scripts/resolve-tool.ps1 -Check
```

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
