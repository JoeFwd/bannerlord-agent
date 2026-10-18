---
name: caravan-camel-icon-hardcoded
description: Vanilla CaravanPartyComponent hardcodes item id "camel" for aserai/khuzait-culture caravans; a mod that strips camels gets an NRE in MobilePartyVisual - fix by aliasing the item in XSLT, not C#
type: lesson
topic: campaign-ai
tags: [caravan, camel, nre, xslt, hardcoded-id]
sources: [memory/caravan-camel-icon-hardcoded.md]
updated: 2026-10-18
---

# Vanilla hardcodes the "camel" item for aserai/khuzait caravans

`CaravanPartyComponent.GetMountAndHarnessVisualIdsForPartyIcon` returns mount `"camel"` (harness `camel_saddle_a/b`) whenever `party.MapFaction.Culture.StringId` is `aserai` or `khuzait`. `MobilePartyVisual.AddMountToPartyIcon` derefs the item lookup without a null check, so a mod that stripped the camel item and reuses those culture ids gets an NRE. A missing harness is fine (null). It can surface unexpectedly: a rebel clan inherits the settlement culture, so a rebelling settlement of that culture spawns such caravans.

**Fix:** alias the id in data. An XSLT rule turning vanilla `Item[@id='camel']` into a copy of the mule with `is_merchandise=false` (camel-monster items still stripped) removes the crash with no Harmony patch.

**How to apply:** when vanilla code hardcodes an item, character or culture id that a mod stripped, alias the id in XML/XSLT before reaching for a Harmony patch.

Related: [[bannerlord-xml-load-abort-semantics]]
