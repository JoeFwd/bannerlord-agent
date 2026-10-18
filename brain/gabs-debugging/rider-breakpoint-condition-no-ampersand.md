---
name: rider-breakpoint-condition-no-ampersand
description: In Rider conditional breakpoints `&&` is parsed as a format specifier; use null-conditional operators instead, and find bad XML with a conditional breakpoint in LoadXml.
type: howto
topic: gabs-debugging
tags: [rider, breakpoint, xml]
sources: [.claude/knowledge/jetbrains-debugger-tips.md]
updated: 2026-10-18
---

# Rider breakpoint condition quirks

- `&&` inside a breakpoint condition is mis-parsed (read as a format specifier). Write `a?.b == x` and `??` instead of `a != null && a.b == x`.
- IDE modal dialogs cannot be detected or dismissed through MCP. A stuck debugger session may simply be a dialog waiting.
- Breakpoints in decompiled framework source live in the Rider DecompilerCache; use the full cached path.
- Finding which XML file breaks loading: `MBObjectManager.LoadXml` has a `node.Attributes["id"].Value` NRE (a node with no `id`) that is swallowed by a catch, so it appears only as a first-chance exception on save load. Set a conditional breakpoint just before the load of each merged document, for example `mergedXmlForManaged?.DocumentElement?.Name == "MusicTracks"`, and walk the root names until the failing document is isolated.
- Evaluate at stack frame index 1: frame 0 is native with a null module. `CORDBG_E_ILLEGAL_AT_GC_UNSAFE_POINT` means retry from a managed breakpoint.
- `ReferenceEquals(null, null)` is true-looking noise in dumps: a "match" row between two null fields proves nothing.
- A logpoint with `hitCount:0` means "never reached", not "nothing exists"; one such reading produced a wrong "no cannons in the mission" conclusion.
- A mission clock read while stopped at a breakpoint is frozen; do not conclude "nothing is changing" from it.

Related: [[bannerlord-xml-load-abort-semantics]]
