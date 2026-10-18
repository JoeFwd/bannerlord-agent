---
name: bannerlord-live-version
description: Identify the installed game version from bin/Win64_Shipping_Client/Version.xml, not DLL metadata or ButterLib's log; verify APIs against shipped DLLs (install was v1.4.8 build 119303 on 2026-08-17)
type: reference
topic: engine-runtime
tags: [version, api-drift, butterlib, decompile]
sources: [memory/bannerlord-live-version.md]
updated: 2026-10-18
---

# Determining the live game version

As of 2026-08-17 the checked install was **v1.4.8**, build `119303`, verified from `bin/Win64_Shipping_Client/Version.xml` (`<Singleplayer Value="v1.4.8"/>`), the `Modules/Native/SubModule.xml` version tag, and `ApplicationVersion.FromParametersFile` read live in a debugger. It had moved on from 1.4.7 (War Sails, `1.4.7.117484`) seen on 2026-07-20.

- `TaleWorlds.CampaignSystem.dll` reports FileVersion `1.0.0.0`; DLL metadata is useless. Use `Version.xml`.
- ButterLib logs "game v1.4.6.0" and loads its 1.4.6 implementation: that is its version-bucket fallback, **not** the game version.

**Why it matters:** APIs move between point releases, e.g. `CustomPartyComponent.CreateQuestParty` became `CreateCustomPartyWithPartyTemplate`, `MobileParty.Position2D` became `Position` (`CampaignVec2`), `Ai.SetMoveGoToSettlement` became `AiHelper.GetBestNavigationTypeAndAdjustedDistanceOfSettlementForMobileParty` + `SetPartyAiAction.GetActionForVisitingSettlement`, and `Ai.NeedTargetReset` was removed.

**How to apply:** verify exact signatures against the shipped decompiled DLLs (ilspycmd, or the IDE decompiler on the loaded assembly). A source-search MCP of an older point release is fine for vanilla control flow and ordering (much campaign code is byte-identical) but unreliable for current signatures.

Related: [[bannerlord-source-mcp-1_4_6-workaround]]
