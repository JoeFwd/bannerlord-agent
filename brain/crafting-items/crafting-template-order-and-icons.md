---
name: crafting-template-order-and-icons
description: The crafting menu sorts templates by StringId (not XML order); icons key off StringId too, so renamed ids need cross-module GenericSprite aliases - with a silent load-order trap
type: lesson
topic: crafting-items
tags: [crafting, templates, sprites, genericsprite, load-order]
sources: [memory/crafting-template-order-and-icons.md]
updated: 2026-10-18
---

# Crafting template order and icons

The weapon-class list ignores XML load order: `WeaponDesignVM` does `_primaryUsages = CraftingTemplate.All.ToList(); _primaryUsages.Sort(_templateComparer)` where `TemplateComparer` is `string.Compare(x.StringId, y.StringId, OrdinalIgnoreCase)`. `WeaponClassSelectionPopupVM` renders that order verbatim. Sorting is on **StringId**, not the localized `TemplateName`, so labels do not look alphabetical. Zero-padded numeric prefixes (`01_...` to `10_...`) force an order; padding is mandatory because `'0'` (0x30) < `'_'` (0x5F), so bare `10_Pike` sorts before `2_OneHandedAxe`.

Renaming an id means updating the `CraftingTemplate id=`, every item's `crafting_template=`, and `str_crafting_template.<id>` (ids that kept vanilla names silently inherit Native's label; reuse Native's `{=key}` to keep translations).

**Icons break as a side effect.** `WeaponClassVM` sets `WeaponType = Template.StringId` and `CraftingWeaponTypeIconWidget` resolves `SpriteData.GetSprite("Crafting\\WeaponTypes\\" + WeaponType)`. Those sprites exist only in `SandBox/GUI/SandBoxSpriteData.xml`, named after the vanilla ids, so a prefixed id silently yields a null sprite (blank icon, no error).

**Alias, do not re-inject art.** `SpriteData.LoadFromDepot` accumulates *every* `*SpriteData.xml` across all modules into one shared `SpriteDataLoadResult`, so a `<GenericSprite>` in a mod file can point its `<SpritePartName>` at a part SandBox defines. No PNG, no atlas repack; the part carries its own `ui_crafting` category so it loads with the crafting screen.

Traps:
- **Load order.** Files are enumerated in `ModuleHelper.GetModules()` order; this works only if the mod's module declares `Sandbox` as `LoadBeforeThis`. A `<SpritePartName>` miss throws `KeyNotFoundException`, which `LoadFromDepot`'s try/catch swallows, silently discarding the **entire** sprite-data file. Keep such aliases in their own small file.
- The parser reads `xmlElement["SpriteCategories"]` / `["SpriteParts"]` / `["Sprites"]` unguarded, so all three elements must exist; self-closing `<SpriteCategories />` is fine.
- Stock ships only 12 `Crafting\WeaponTypes\*` icons and **none is a lance, longsword or pollaxe**; new templates must borrow.

Related: [[bannerlord-xml-load-abort-semantics]]
