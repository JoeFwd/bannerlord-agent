---
name: banner-icon-psd-autoimport
description: Bannerlord's asset watcher rebuilds ui _tex.tpac AND the RuntimeDataCache .rdc within seconds of a PSD write, so a one-tile edit is a 3-file commit and the .rdc is raw RGBA you can diff
type: lesson
topic: meshes-textures-assets
tags: [psd, tpac, rdc, asset-watcher, ui]
sources: [memory/banner-icon-psd-autoimport.md]
updated: 2026-10-18
---

# UI PSD edits auto-import; FBX edits do not

Writing `<mod module>/AssetSources/ui/*.psd` makes Bannerlord's asset watcher rebuild **both** `Assets/ui/<name>_tex.tpac` and the matching `RuntimeDataCache/<GUID>.rdc` by itself, within seconds, with no Resource Browser step (measured: PSD written 22:14:36, tpac + rdc rewritten 22:14:40). This is the opposite of the FBX path in [[fbx-edits-need-tpac-reimport]]. Do not generalise either way: **check the mtimes.**

- A one-tile edit is a **3-file change set per atlas** (PSD, tpac, rdc), all git-tracked if the module tracks compiled assets; commit together. Staging only the PSD ships nothing; staging only the tpac desyncs the source.
- "Never hand-edit `RuntimeDataCache/`" still holds: the watcher regenerates it, which is the sanctioned path.
- A running game holds the old atlas resident. Restart before judging a tile.

**The `.rdc` is directly verifiable.** Each ui atlas rdc is 16,777,381 bytes and the last 16,777,216 are an uncompressed 2048x2048 RGBA payload:

```python
np.frombuffer(open(rdc,'rb').read()[-16777216:], np.uint8).reshape(2048,2048,4)
```

Compare byte-for-byte against the PSD composite; `maxdiff == 0` over the full atlas proves the whole pipeline without a launch (used 2026-09-12 on seven repainted tiles).

**Why it matters:** the mental model "AssetSources edits do not reach the game until re-imported" leads either to an unneeded hand re-import or to committing the PSD alone with compiled assets left as uncommitted noise.

**How to apply:** after writing a ui PSD, `ls -l` the sibling `Assets/ui/*_tex.tpac` and `RuntimeDataCache/*.rdc`; if mtimes moved, the import already happened.

Related: [[banner-icon-atlas-editing]]
