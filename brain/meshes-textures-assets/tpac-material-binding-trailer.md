---
name: tpac-material-binding-trailer
description: A mesh's material binding is a length-prefixed name in the _geo.tpac trailer; "default" means no material was bound and the mesh renders flat grey - fix it in the Modding Tools, never by binary patching
type: lesson
topic: meshes-textures-assets
tags: [tpac, material, trailer, default, flat-grey, binary-patch]
sources: [memory/tpac-material-binding-trailer.md]
updated: 2026-10-18
---

# Material binding lives in the _geo.tpac trailer

A mesh that renders **flat matte grey with no lighting response** next to correctly-lit siblings is bound to the engine fallback material, not mis-shaded. The binding is a plain name string in the **trailer of the `_geo.tpac`** (the bytes after the LZ4 geometry blob): a 4-byte LE length prefix followed by ASCII.

**Locate the trailer properly:** `trailer_start = blob_offset + compressed_size`, both **64-bit** header fields. Fixed offsets are only stable within one file (one prop pack: blob@928, comp=159780, trailer@160708, 142 bytes; the same offsets read as garbage in a pack with a longer header name table).

**Diagnosis:**
- Decode only the trailer and match names **length-prefixed**. A loose whole-file string scan yields junk and substring false positives (`cannonball_pile` matches inside `<prefix>_cannonball_pile`).
- `default` in the material slot = nothing bound. A healthy `_geo.tpac` has **zero** occurrences of `default`.
- The FBX is usually innocent. Parse the binary FBX **Connections** section, not just object names: a `Material` object can exist while no `OO` connection links it to the `Model`. A bare `default` string inside an FBX is typically the UV set name.

**Worked case (2026-09-02):** every input was correct and the binding was still lost. FBX declared the Material and connected it to the Model; the material tpac existed and was saved 2h24m *before* the geo was compiled; the trailer still read `default`. Editing texture flags did nothing, since the flags were on a material the mesh never referenced.

**Vanilla reference:** `Native/AssetPackages/props_siege_shared.tpac` holds `grapeshot_pile` plus LODs `.0`-`.3` and names the real material `trebuchet_counter_rocks`. That material is NOT in Native's `materials.tpac`; vanilla ships prop materials inside the same asset package as the mesh.

**Why:** the runtime resolves materials by name at load; that one string is the whole contract.

**How to apply:** fix it in the Modding Tools (assign the material to the mesh and save, or reimport the FBX). **Never binary-patch the trailer** (tried 2026-09-02; the Modding Tools reported the file corrupted). Changing the name's length invalidates the container: the header carries hash-like guard values bracketing the 64-bit size fields (`0x1f0` and `0x210` in that file). Restore from a `.bak` if patched. If a binding fails, suspect layout: keep `_geo.tpac` and `_mtl.tpac` in the same folder.

Related: [[invisible-mesh-is-scale-not-shader]], [[reimport-keeps-second-material]], [[fbx-edits-need-tpac-reimport]]
