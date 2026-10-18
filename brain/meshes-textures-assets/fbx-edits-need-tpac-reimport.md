---
name: fbx-edits-need-tpac-reimport
description: Editing a source FBX changes tool renders at once but the game loads the compiled _geo.tpac - re-import through the Modding Kit before trusting in-game results; shipped tpacs can be mirrored vs their FBX
type: lesson
topic: meshes-textures-assets
tags: [fbx, tpac, import, crafting-tool, mirror]
sources: [memory/fbx-edits-need-tpac-reimport.md]
updated: 2026-10-18
---

# FBX edits need a tpac re-import

A tool that reads source FBX directly (the crafting tool, env `BANNERLORD_CRAFTING_TOOL`, `audit`/`render`) sees edits immediately. The **game** loads the compiled `<mod module>/Assets/<category>/<name>_geo.tpac`. So tool-verified is not game-verified.

**Why it bites:** a fix verified green in the tool can look *worse* in game, because XML offsets were retuned for the new mesh while the game still draws the old one; the errors add instead of cancelling.

**How to apply:** after any `AssetSources/**/*.fbx` edit, re-import through the Modding Kit Resource Browser to regenerate the `_geo.tpac`, then relaunch, before trusting an in-game screenshot. Both FBX and tpac are git-tracked in the content module.

**Mirrored tpac:** a shipped `_geo.tpac` can be flipped about x relative to its own AssetSources FBX. The first re-import then silently flips every x-asymmetric feature (butt hook, guard arms) and it LOOKS like your edit rotated something. Diagnose with FBX bboxes across the edit (if `game_x` is unchanged your edit flipped nothing) plus before/after zooms. Fix in the mesh ([[crafting-piece-cannot-be-rotated-by-xml]]); if the mesh is split, mirror ALL halves ([[split-mesh-seam-is-ragged]]). A flat blade hides a mirror in side silhouette, so the flip is usually cosmetic only.

**Mesh path only:** UI textures behave oppositely; a write to `AssetSources/ui/*.psd` is auto-imported within seconds ([[banner-icon-psd-autoimport]]). Check mtimes rather than assume.

Related: [[blade-mesh-origin-inflates-reach]]
