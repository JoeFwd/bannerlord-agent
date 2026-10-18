---
name: banner-icon-atlas-editing
description: Adding a banner charge means repainting a 512x512 tile in a ui atlas PSD; convention is green fill + RED stroke, padding is per-tile, and an unreferenced slot is not a free slot
type: howto
topic: banners-heraldry
tags: [banner, psd, atlas, icons, stroke]
sources: [memory/banner-icon-atlas-editing.md]
updated: 2026-10-18
---

# Editing the banner icon atlas

A new heraldic charge is **a repainted tile, not a new icon id**. Tiles live in a mod's `AssetSources/ui/custom_banner_icons*.psd`: 2048x2048 RGBA, sixteen 512x512 tiles in a 4x4 grid, `texture_index` row-major (`row = ti//4, col = ti%4`). `banner_icons.xml` needs no edit if the mod already owns those icon ids (e.g. it strips vanilla factions with XSLT). Watch name mismatches: the material `custom_banner_icons_01` may be on disk as `custom_banner_icons.psd` with no `_01`.

**Tile colour convention: green `(0,255,0)` fill, RED `(255,0,0)` stroke and interior detail**, alpha as silhouette mask. Red is what `ColorId2` paints when `DrawStroke=1`, so `DrawStroke` must be **1** on any layer using a detailed tile or the whole interior disappears. This is vanilla's encoding. Yellow `(255,255,0)` shows up on a few animal tiles as a minority accent tint; it is not the convention. Typical stroke width is 5-8 px at 512.

**Padding is per-tile, not atlas-wide.** The 88.3% of icon 505 (see [[banner-key-format-and-32-layer-cap]]) is a shape-group value; real tiles run ~44-99% of their box. Measure the tile's opaque bbox and size the layer as `want * 512 / content_px`.

**An unreferenced slot is not a free slot.** In one mod all 43 tiles unreferenced by any banner key turned out to be real art (a Welsh dragon, a Manx triskelion, a fleur-de-lys, the only triangle primitive). Choose slots that duplicate art surviving elsewhere, and assert `refs == 0` across every module's `ModuleData/**/*.xml` in the write script so a hit aborts before anything is overwritten.

**`PSDImage.frompil(img).save(path)` flattens the file.** Atlases carrying one named raster layer end up layer-less (roughly half the size). Pixels are bit-identical so the game is unaffected, but back PSDs up outside `AssetSources/` first (inside it, the importer mistakes backups for assets).

**Licensing:** traced CC BY art makes credits a shipping requirement; generate geometric charges from the blazon to avoid share-alike (CC BY-SA) obligations.

**Why:** the obvious reading of "add an icon" is to add an id, and of "unreferenced" is that it is spare. Both are wrong, and the second destroys artwork.

See [[banner-icon-psd-autoimport]] for what the write changes on disk.
