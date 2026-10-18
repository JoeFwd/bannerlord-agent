---
name: clr-exception-breakpoints-needed-to-catch-silent-death
description: Without CLR exception breakpoints a managed crash in Bannerlord leaves no dump and no log; set them (and a stop-on-first-chance AV capture for native faults).
type: howto
topic: gabs-debugging
tags: [crash, clr, debugger, native-av]
sources: [runtime-evidence/banner-editor-nre-blocker, runtime-evidence/warsails crash runs]
updated: 2026-10-18
---

# Catching silent deaths

Bannerlord can exit with no dump, no crash window and no log line when an exception escapes on a UI/main thread. Two ways to catch the cause:
- Managed: attach Rider with CLR exception breakpoints (NRE, ArgumentNull, AccessViolation). The pause shows `$exception` and the stack.
- Native: for a fault inside the engine (the managed stack is all unresolved frames, or `AccessViolationException` inside `ManagedCallbacks.ScriptingInterfaceOf*`), see [[cdb-native-av-capture-method]].

A native `AccessViolationException` from a scene call is often caused by data the call was handed, so read the managed frames above it (settlement ids, positions, `IsOnLand`) before blaming the engine. The first stack may be truncated; a second reproduction resolved the full chain.

Related: [[resuming-from-first-chance-exception-kills-process]], [[cdb-native-av-capture-method]], [[harmony-patch-failure-kills-game-silently]]
