---
name: gauntlet-sprite-atlas-repack-workflow
description: How to add sprites to a Gauntlet atlas tpac: decompose, add PNGs at exact sizes, repack, update SpriteData.
type: howto
topic: ui-gauntlet
tags: [gauntlet, sprite, atlas, tpac]
sources: [doc/adding-a-cannon.md]
updated: 2026-10-18
---

# Gauntlet sprite atlas repack workflow

1. Prepare PNGs at the exact dimensions the UI expects.
2. Decompose the existing atlas tpac with the BannerEdge tool into a SpriteParts-style folder.
3. Add the PNGs at paths matching the sprite names (`Order/SiegeIcons/<id>.png`).
4. Repack; the tool assigns `SheetX`/`SheetY`.
5. Recompile with the modding kit to regenerate the tpac.
6. Add `<SpritePart>` (`SheetID`, `Name`, `Width`, `Height`, `SheetX`, `SheetY`, `CategoryName`) and `<GenericSprite>` entries to the SpriteData XML.

An atlas is a fixed size (for example 256x256) and sprites cannot overlap. If it is full, start a new `SpriteCategory` with its own atlas. Keep other sprite source folders out of the folder the tool scans, or it will mix them in.

Related: [[campaign-siege-engine-registration-numbers]]
