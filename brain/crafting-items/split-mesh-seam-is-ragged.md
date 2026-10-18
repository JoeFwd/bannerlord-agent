---
name: split-mesh-seam-is-ragged
description: Splitting one mesh into two crafting pieces - mate halves at ORIGINAL positions (the seam ring is not flat), mirror BOTH halves, restore custom split normals or the seam shades as a hard band, and register the piece in both registries
type: howto
topic: crafting-items
tags: [mesh-split, seam, custom-normals, mirror, blender, registries, acceptance-test]
sources: [memory/split-mesh-seam-is-ragged.md]
updated: 2026-10-18
---

# Splitting a mesh into two crafting pieces

A split is a pure partition, so the reassembled weapon must be **pixel-identical** to the original. Acceptance test: render before touching the FBX, mask both `render.png` files against the background and compare lit-pixel sets (a grip+pommel split scored 57111 vs 57111, zero drift).

**Seam is not flat.** A cut along an existing edge ring has rake (example: game_y -12.588..-12.480, 0.108 raw), so the halves' bounding boxes legitimately overlap. Aligning `pommel.max_y` to `handle.min_y` (gap 0.000, looks like success) seats the pommel 0.097 too low and the union comes out longer. **Mate at original positions** and check the **union** extent against the pre-split piece (min_y/max_y), every other piece untouched, `weapon_length` unchanged. Joint-gap and contact profile read green on the wrong answer.

**Mirror both halves, never one.** Mirroring only one makes the rakes oppose and the joint opens (contact 96% / 3 px to 75% / 2 px with a black sliver); mirroring both kept 100% / gap 0. A symmetric bounding box is no evidence the seam ring is symmetric. Mirror with `obj.scale.x = -1` + `transform_apply(scale=True)`, never by negating `v.co.x` (the operator transforms custom normals and reverses winding together; manual negation leaves normals untransformed and `flip_normals()` then negates all three components).

**Shading breaks at the seam, invisible to geometry checks.** Meshes carry *custom split normals*. A seam-ring vertex held one averaged normal across faces above and below; after the split each half keeps only its side: **mean 89 deg, max 112 deg on 26/26 ring vertices**. In game: a hard horizontal band, one piece washed out, other too dark, looking like a material/lighting bug. Silhouette diff, contact profile, `weapon_length` and the tool's `render.json` stay byte-identical. Fix: key each corner by `(vertex position, polygon centroid)` rounded to about 5 dp, copy the original's corner normal back, apply with `mesh.normals_split_custom_set` (mean 89 to 4.9 deg, median 0.65, visible corners median 0.0000). Unmatched corners are the cap faces the split created (verify they span only the ring's axial range, leave them; hidden in the joint). Sharp-edge counts must partition exactly (96 = 20 + 76). Verify by rendering both halves *shaded* (grey Principled BSDF, one sun, ortho camera on the joint); the crafting tool paints flat by type and cannot show shading.

**Register the new piece in BOTH registries** or it never reaches the bench: the template's `<UsablePiece>` and the weapon descriptions' `<AvailablePiece>` ([[crafting-usage-vs-bench-list-rules]]). Forgetting: `audit --all-pairs` silently omits it while `render` places it fine. Mirror wherever the sibling handle is listed.

Related: [[crafting-offsets-are-scale-multiplied]], [[crafting-contact-profile-check]], [[blender-fbx-roundtrip-breaks-scale]], [[fbx-edits-need-tpac-reimport]]
