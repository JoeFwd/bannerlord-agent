---
name: harmony-patch-failure-kills-game-silently
description: An exception while applying a Harmony patch in OnSubModuleLoad (e.g. AmbiguousMatchException from AccessTools.Method on an overloaded method) exits Bannerlord with no log, dump or debugger pause; test patches offline first
type: lesson
topic: harmony-patching
tags: [harmony, accesstools, ambiguousmatch, transpiler, silent-exit, offline-harness]
sources: [memory/harmony-patch-failure-kills-game-silently.md]
updated: 2026-10-18
---

# A throwing Harmony patch exits the game silently

A transpiler used `AccessTools.Method(typeof(BannerVisual), "GetTableauTextureLarge")`. The method is overloaded, so it threw `AmbiguousMatchException` inside the transpiler and Bannerlord exited silently during module load:
- mod log and rgl_log both end right after the Harmony.DependencyInjection "Auto-patched assembly" line;
- Rider dropped the session without pausing;
- WER logged no Bannerlord event.

It looks like a mystery launch failure and costs relaunch cycles (one playtester run was wasted).

**How to apply:** before relaunching with a new manual Harmony patch, apply it offline in a net8 console harness referencing the game's TaleWorlds DLLs (bin + `Modules/Native/bin`, with an `AssemblyResolve` hook) and Lib.Harmony 2.4.2. Call its `Apply()` and compare `PatchProcessor.GetOriginalInstructions` against `GetCurrentInstructions`. Match overloaded call operands by name and declaring type, or by parameter types, rather than bare `AccessTools.Method`.

Mod instance: `BannerTabardMeshLifetimePatch`, 2026-10-11 (precedent harness in `tools/ui_migration/LoadingPatchChecks`). Related: [[debugger-pause-kills-gabp-game]]
