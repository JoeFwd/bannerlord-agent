---
name: banner-party-palette-mismatch
description: bannerlord.party's palette parks duplicate swatches in the game palette's gaps; 8 ids are dead and render 0xDEADBEEF, and the remap is lossless and by hex
type: lesson
topic: banners-heraldry
tags: [banner, palette, colour-id, bannerlord.party]
sources: [memory/banner-party-palette-mismatch.md]
updated: 2026-10-18
---

# bannerlord.party palette vs game palette

`bannerlord.party/banner/` ships a **158-colour** palette; the game's `Native/ModuleData/banner_icons.xml` has **229** `<Color>` entries (ids 0..250, with gaps).

**The site palette is NOT "shifted by one".** All 143 ids present in both palettes have identical hex (zero hue drift). The site's surplus ids are duplicate swatches parked in the game palette's gaps: 13 duplicate-hex groups, 12 of them consecutive pairs in the 122-145 range, each with one game-valid and one gap member. So every dead-to-live remap is **lossless**, and "remap only the dead ids" and "remap everything through the table" are the same edit.

**Eight dead ids:** `40 128 129 132 140 141 144 145`. `BannerManager.GetColor(int)` returns `3735928559u` (**0xDEADBEEF**, a pale semi-transparent lilac) for an unknown id. No crash, no log line; it reads as an art bug.

Remap (confirmed by hex match, a third-party palette migrator's 8/8, and an independent rederivation):

```
40->172 ffffff   128->127 f3f3f3   129->126 34671e   132->131 f1c232
140->139 d9d9d9  141->138 3a6298   144->143 f4ca14   145->142 830808
```

`#ffffff` is ambiguous: game ids **172** and 250 are byte-identical. Use **172**; it is flagged `player_can_choose_for_sigil`.

**How to apply:** author banner keys with game palette ids read from `banner_icons.xml`; if a key comes from the site, remap by hex first. Colour ids sit at offsets 1 and 2 of each 10-int group, see [[banner-key-format-and-32-layer-cap]].
