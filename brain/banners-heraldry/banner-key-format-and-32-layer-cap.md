---
name: banner-key-format-and-32-layer-cap
description: banner_key is 10 ints per layer; the 32-layer parse cap was removed in 1.4.7 but multiplayer still caps at 31; icon 505 covers only 88.3% of its Size box
type: reference
topic: banners-heraldry
tags: [banner, banner_key, layers, multiplayer]
sources: [memory/banner-key-format-and-32-layer-cap.md]
updated: 2026-10-18
---

# Banner key format and layer cap

A Bannerlord `banner_key` is dot-separated, **10 ints per layer**:

`MeshId . ColorId . ColorId2 . SizeX . SizeY . PosX . PosY . DrawStroke . Mirror . Rotation`

Canvas is 1528x1528 (`Banner.BannerFullSize`), Y down, `Pos` is the layer *centre*, `Rotation` int = degrees / 0.0027777778. Layer 0 is the background; mesh `11` is the plain base. On icon layers `ColorId` is the fill and `ColorId2` the stroke. Colour ids come from `Native/ModuleData/banner_icons.xml` (229 `<Color hex="0xffRRGGBB">`); colour ids and icon ids are **separate namespaces** in that file.

**Icon 505 does NOT fill its Size box.** Icons are 512x512 atlas tiles; 505's opaque pixels are only `(30,30)..(482,483)`, so a layer renders at **452/512 = 88.3%** of the requested Size. Multiply by `512/452 = 1.1327` to get the intended on-screen size. Also measured: 502 `(30,32,482,479)`, 510 `(27,216,486,296)`, 511 `(28,114,484,397)`, 522 `(38,38,473,475)`. Hand-authored banners often show odd centres (e.g. +/-150 instead of +/-175) because the author compensated by eye.

**The 32-layer cap is gone as of 1.4.7** (confirmed against 1.4.8 source). The old `RemoveRange(31, Count - 32)` truncation in `Banner.TryGetBannerDataFromCode` is stripped; what remains is the decompiler artifact `_ = bannerDataList.Count; _ = 32;`. Singleplayer XML parses keys of any length. **Two limits survive:** `Banner.AddIconData` still guards `if (_bannerDataList.Count < 33)` (the in-game editor path, not XML parsing), and multiplayer still caps the count at 31 via `CompressionBasic.BannerDataCountCompressionInfo = Integer(0, 31, maximumValueGiven: true)`, so an over-long banner will not network-serialise. Compound charges are built from primitives (a cross pattee is 8 layers), so heraldic banners easily exceed 32.

**Why:** nothing documents the key layout, the old truncation was silent, and tile padding makes every ordinary render ~12% small with no diagnostic.

**How to apply:** singleplayer-only mods on 1.4.7+ have no layer budget; stay at 31 and one icon per charge only if the banner must work in multiplayer.

Related: [[banner-party-palette-mismatch]], [[banner-icon-atlas-editing]]
