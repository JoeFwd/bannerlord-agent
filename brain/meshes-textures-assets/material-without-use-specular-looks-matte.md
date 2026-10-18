---
name: material-without-use-specular-looks-matte
description: A material whose saved flags omit use_specular samples no specular map, so identical textures still look matte; metallic versus standard workflow also changes reflection.
type: lesson
topic: meshes-textures-assets
tags: [material, shader, specular, tpac]
sources: [src/doc/investigations/cannonball-pile-material.md]
updated: 2026-10-18
---

# Material without use specular looks matte

`standart.rsh` initialises specularity to zero and reads the specular sample only when the material flag (or shader feature) enables it. A material that references the same three textures as a shiny sibling but lacks `use_specular` renders matte. A second, independent difference: `pbr_metallic` enables `USE_METALLIC_WORKFLOW`, while deformer shaders such as `stone_pile_deformer` use the standard workflow (which squares the specular red channel and reconstructs reflection colour differently). Even with specular enabled, an exact match to a metallic material may need texture tuning.

Corrections to common wrong turns:
- The string `default` inside compressed editor or import data is not proof the runtime falls back to the default material. Parse the tpac with a real reader and resolve GUIDs.
- A raw string replacement inside a geo tpac is invalid: it holds structured descriptors and compressed segments. Never patch tpacs textually.
- A zero-alpha theory for a depleting pile was disproved: the alpha ramp (20 levels) matched native.

Fix: enable `use_specular`, keep vertex colours and shader, save the material in the editor; no FBX reimport needed. Validate with the deformer argument at several values.

Related: [[tpac-material-binding-trailer]], [[cannonball-pile-white-is-ao-coef]]
