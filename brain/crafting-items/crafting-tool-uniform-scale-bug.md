---
name: crafting-tool-uniform-scale-bug
description: Engine rule - non-full_scale crafting pieces scale on the length axis only (full_scale defaults true for Guard/Pommel); a crafting tool that scaled uniformly rendered laterally too fat (FIXED 2026-08-08)
type: lesson
topic: crafting-items
tags: [crafting, full_scale, scale_factor, tooling]
sources: [memory/crafting-tool-uniform-scale-bug.md]
updated: 2026-10-18
---

# full_scale rule and the tool bug (FIXED 2026-08-08)

Engine rule: `FullScale ? Vec3.One * ScaleFactor : new Vec3(1, 1, ScaleFactor)`, applied only when `scale_factor != 100`. `full_scale` defaults to `PieceType == Guard || PieceType == Pommel` (`CraftingPiece.cs:202-203`, decompiled 1.4.6), so Blades and Handles are axis-only by default. The tool's GUI/CLI axis is **+Y** rather than the engine's +Z, so axis-only is `ScaleTransform3D(1, sf, 1)`.

The private crafting tool (CLI via `RenderPieceFactory`, GUI `Refresh3D`; env var `BANNERLORD_CRAFTING_TOOL` locates it) originally scaled uniformly (UNFIXED on 2026-08-07, FIXED 2026-08-08). It is a **behaviour change**: any render or `lateral_offset` captured before 2026-08-08 for a non-`full_scale` piece at `scale_factor != 100` was laterally too fat. Re-measure rather than trusting old output. Axial measurements ([[crafting-contact-profile-check]], seam gaps, [[crafting-joint-gap-formula]]) were never affected.

The transform is no longer duplicated between measurement and PNG rendering, so JSON and image cannot silently disagree.

Related: [[crafting-offsets-are-scale-multiplied]], [[scabbard-holster-mesh-placement]] (the scabbard inherits the Blade's scale under this same rule)
