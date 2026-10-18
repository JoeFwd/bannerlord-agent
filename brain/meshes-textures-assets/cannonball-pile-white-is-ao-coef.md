---
name: cannonball-pile-white-is-ao-coef
description: Washed-out white spheres on a stone_pile_deformer material trace to the Ambient Occlusion Coef, not the diffuse/specular textures
type: lesson
topic: meshes-textures-assets
tags: [material, ambient-occlusion, shader, stone_pile_deformer]
sources: [memory/cannonball-pile-white-is-ao-coef.md]
updated: 2026-10-18
---

# Dense sphere piles go white when AO coef is lowered

A cannonball pile rendered blown-out white instead of grey iron. The cause was the pile material's **Ambient Occlusion Coef**; restoring it to `1` gave the correct grey (confirmed in game 2026-09-15).

Everything upstream was a dead end: unticking `use_vertex_colors`, adjusting `use_specular`, and a hand-repainted diffuse all failed. The repainted PNG ended up orphaned and the Diffuse slot reverted to a known-good sibling (`musketball_diffuse`).

**Why:** a lowered AO coef removes the occlusion darkening that gives a dense pile of spheres its shading, so the mesh flattens to near-white and reads as "wrong texture" or "wrong shader". The material inspector makes the texture slots the obvious suspects and buries the coefficient.

**How to apply:** when a `stone_pile_deformer` (or any dense-cluster) material looks washed out, check Ambient Occlusion Coef *before* touching textures or shader flags, and compare against a known-good sibling material (`musketball_mtl.tpac` was the reference).

Same asset, separate bugs: size from [[blender-fbx-roundtrip-breaks-scale]], and in-battle invisibility from the mesh being stripped from the live prefab while surviving in the editor-only `_ghost` prefab.
