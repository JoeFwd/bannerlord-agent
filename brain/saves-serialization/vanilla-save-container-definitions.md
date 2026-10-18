---
name: vanilla-save-container-definitions
description: Vanilla SaveableCampaignTypeDefiner already registers most common generic containers; check it with ilspycmd before adding ConstructContainerDefinition to a mod's definer
type: howto
topic: saves-serialization
tags: [saveabletypedefiner, constructcontainerdefinition, ilspycmd, save-load, duplicate-registration]
sources: [memory/vanilla-save-container-definitions.md]
updated: 2026-10-18
---

# Check vanilla before adding a container definition

Before "fixing" a mod `SaveableTypeDefiner` by adding a `ConstructContainerDefinition`, see whether vanilla already defines it:

```bash
cd "<game dir>/bin/Win64_Shipping_Client"
ilspycmd -t TaleWorlds.CampaignSystem.SaveableCampaignTypeDefiner TaleWorlds.CampaignSystem.dll \
  | grep ConstructContainerDefinition
```

Vanilla **already registers** `Dictionary<Hero, CampaignTime>`, `Dictionary<MobileParty, CampaignTime>`, `Dictionary<Settlement, CampaignTime>`, `Dictionary<string, CampaignTime>`, `List<CampaignTime>`, `Dictionary<MobileParty, Settlement>` and many more. It does **not** define `Dictionary<Hero, Settlement>`, so a mod registering that one is legitimate.

**Why:** a save/load soft-lock can look like a missing container definition; adding a duplicate is not a fix and masks the real cause.

**How to apply:** an omitted container in a mod definer is only a bug if vanilla does not cover it. Verify against the shipped DLL rather than the mod source; shipped DLLs, not the MCP source servers, are the source of truth ([[bannerlord-live-version]]).

