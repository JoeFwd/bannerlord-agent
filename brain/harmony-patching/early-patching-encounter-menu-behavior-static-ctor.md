---
name: early-patching-encounter-menu-behavior-static-ctor
description: Patching EncounterGameMenuBehavior members during OnSubModuleLoad forces its static constructor, which calls GameTexts.FindText before it is initialised, giving a TypeInitializationException on save load.
type: incident
topic: harmony-patching
tags: [harmony, static-ctor, crash, menu]
sources: [doc/feudal-private-wars-design.md]
updated: 2026-10-18
---

# Early patching encounter menu behavior static ctor

Applying a Harmony patch to a member of `EncounterGameMenuBehavior` early (for example in `OnSubModuleLoad`) makes Harmony resolve the type, which runs its static constructor. That constructor calls `GameTexts.FindText`, and the text manager does not exist yet. The result is a `TypeInitializationException` and a crash when a save is loaded, which looks unrelated to the patch.

Rule: patch types with text or content-dependent static constructors only after `Game.Initialize` (for example in `OnGameStart`), not during module load.

Status: FIXED by deferring the patch.

Related: [[harmony-patch-failure-kills-game-silently]]
