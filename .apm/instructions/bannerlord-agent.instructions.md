---
description: How to use the bannerlord-agent harness, its knowledge brain, and machine-specific settings.
---

# Bannerlord Agent

Generic Mount & Blade II: Bannerlord modding harness. A mod's own agent package layers its
project context on top.

## Knowledge brain

`brain/` in the bannerlord-agent repo holds durable, mod-neutral lessons: engine behaviour,
vanilla code facts, file formats, editor quirks and debugging traps. Each lesson is one
markdown note, and notes link to each other with Obsidian `[[slug]]` wikilinks. Start from
`brain/INDEX.md`.

- **Before you investigate.** Before debugging a crash, a format, or vanilla behaviour, grep the
  brain (`brain/**/*.md`) for the symptom, API or file name.
- **Write to the editing checkout.** Add new lessons to the bannerlord-agent editing checkout
  (usually a git submodule of the mod repo, e.g. `submodules/bannerlord-agent/brain/`). Never
  write to the deployed copy under `apm_modules/`.
- **Keep notes mod-neutral.** Mod-specific incidents belong in the mod's own brain, linked back
  to the generic note.
- **Follow the note format.** Frontmatter is `name` (== file name), `description`, `type`
  (lesson|reference|incident|howto|decision), `topic` (== folder), `tags`, `sources` and
  `updated` (YYYY-MM-DD). The body states the fact first, then the evidence, then
  `Related: [[...]]`. Add the note to `brain/INDEX.md`.

## Machine-specific settings

Skills never hard-code machine paths. They read these environment variables:

| Variable | Used by | Fallback |
|---|---|---|
| `GABS_EXE` | session-start hook, `bannerlord-gabs-*` | `gabs` on PATH |
| `ASSERT_AUTO_IGNORE_EXE` | `bannerlord-gabs-start` | skip popup auto-dismiss |
| `BANNERLORD_CRAFTING_TOOL` | `bannerlord-crafting-offsets` | ask the user |
| `BANNERLORD_NAVMESH_STUDIO` | `bannerlord-navmesh-studio`, `bannerlord-navmesh-preview` | ask the user |

Mod-specific values live in the mod package's **Bannerlord agent settings** instruction:
- the Rider debug configuration name and `project_path`
- the mod log file
- the new-game option
- a safe evaluation-breakpoint anchor
- cheat command families
- module locations and game installs

If no such instruction exists, ask the user rather than guessing.
