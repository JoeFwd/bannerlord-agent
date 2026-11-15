---
name: mesh-material-from-later-module-warning
description: The editor pops "RGL CONTENT WARNING - Unable to find material for mesh X.N" when submesh N binds a material defined in a module that loads after the mesh's module; move the mesh to the module that owns the material, not the material to the mesh.
type: lesson
topic: meshes-textures-assets
tags: [editor, materials, tpac, module-load-order, rgl-warning]
sources: [DADG Scottish merged map meshes, 2026-11-15]
updated: 2026-11-15
---

# Material from a later module

The Modding Tools editor shows "Unable to find material for mesh `<mesh>.<submesh>`" (then "Always Ignore?") when a mesh in module A binds, by GUID, a material that lives in module B, and B loads after A. Module B usually depends on A. The `.N` suffix is the submesh index, and `.lodK.N` is the same submesh at a lower LOD.

The check runs per package, when the package's own module loads. Scenes are not affected. A scene in A can place meshes from B by name, because scene entities resolve after every module has loaded. So a mesh does not need to live in the module whose scene uses it.

Typical cause: a mesh is built by merging parts from B's meshes and imported into A. The merged mesh keeps B's material bindings. B's own meshes never warn, because their material is in their own module.

Fix: move the offending mesh package into B, next to the materials it binds. A's scenes keep using it by name. Do not pull B's materials down into A. Shared materials drag in their textures and other meshes, and every mesh moved into A can bind another B-only material, so the warnings just move elsewhere. You can't fix it by making A depend on B when B already depends on A, because that is circular.

A move between modules is the `.tpac` plus its `RuntimeDataCache/<guid>.rdc`. Find a package's cache file by searching the `.tpac` bytes for the `.rdc` GUID (little-endian byte order). Material-only `.tpac` files have no `.rdc`. The package keeps its embedded source path, which only matters on reimport.

To find which material a submesh index points to, list the mesh's materials in the order the importer numbered them. For a Blender export that sorts the material slots, that is alphabetical order.

Once one submesh of a package binds a later-module material, its other submeshes can warn too, including ones bound to vanilla materials (here `objects_a` from Native `core_game.tpac`). Moving the package cleared all of them.

Related: [[dadg-scottish-merged-mesh-material-warnings]]
