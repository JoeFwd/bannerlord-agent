---
name: fbx-import-root-package-path-error
description: Modding Kit refused a NEW FBX at the AssetSources root with "Unable to import file - Package path must contain /Assets/ element"; the same FBX copied into an AssetSources subfolder imported fine
type: lesson
topic: meshes-textures-assets
tags: [fbx, import, resource-browser, modding-kit, tpac, package-path]
sources: [DADG helm whipstaff import 2026-10-24]
updated: 2026-10-24
---

# New FBX at the AssetSources root: "Package path must contain /Assets/ element"

**Fact:** on 2026-10-24 the Modding Kit (Bannerlord 1.4.8) refused to import a new `<module>/AssetSources/x.fbx` from the Discovered Files list. The error was "Unable to import file: Package path must contain /Assets/ element". The module was loaded and `Assets/` was the selected Resource Browser folder. A byte-identical copy at `AssetSources/<sub>/<sub2>/x.fbx` imported at once, into `Assets/<sub>/<sub2>/x_geo.tpac`. So the importer mirrors the AssetSources subpath into Assets.

**Evidence:** older tpacs in the same module sit at the `Assets/` root, and their source paths point at root-level FBXs (`$BASE/Modules/<mod>/AssetSources/<name>.fbx`). Root imports therefore worked at some earlier point, and the cause of the refusal is unknown. The FBX was not at fault: its materials existed, and the copy in the subfolder imported.

**How to apply:** put new FBX sources in a subfolder of `AssetSources/`. Never hard-code the tpac location in follow-up scripts: glob `Assets/**/<name>_geo.tpac`. Meta mesh names are global, so prefabs don't care where the tpac lives.

Related: [[fbx-edits-need-tpac-reimport]], [[tpac-material-binding-trailer]], [[blender-fbx-roundtrip-breaks-scale]]
