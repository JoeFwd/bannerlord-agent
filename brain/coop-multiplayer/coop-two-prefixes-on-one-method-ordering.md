---
name: coop-two-prefixes-on-one-method-ordering
description: When two mods prefix the same method, registration order decides whether a capture/replication prefix sees the call; use HarmonyPriority.
type: lesson
topic: coop-multiplayer
tags: [coop, harmony, priority, replication]
sources: [doc/coop-compatibility-analysis.md]
updated: 2026-10-18
---

# Coop two prefixes on one method ordering

A replication layer often sets a "capturing" flag in a prefix and publishes the result in a postfix of an inner call. If another mod prefixes the same method, calls the inner method itself and returns false, the outcome depends on which prefix ran first. If the other mod runs first, the inner call fires before the flag is set and the event is never replicated.

Fix: give the replacing patch `[HarmonyPriority(Priority.Low)]` so it runs after. Harmony.DependencyInjection style builders use `new HarmonyMethod(patch.PatchMethod)`, which reads method attributes, so the attribute works. It changes nothing in single player.

General rule for mods that replace a vanilla method wholesale: check what other mods prefix there and set priority explicitly.

Related: [[coop-replication-gotchas-for-content-mods]]
