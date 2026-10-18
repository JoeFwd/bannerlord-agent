---
name: scabbard-mouth-metric-pitfall
description: Scabbard fit needs TWO reference points - blade.MinY (does it sheathe the blade) and guard.MaxY (does the mouth meet the cross); either alone gives false verdicts and their disagreement is the real signal
type: lesson
topic: crafting-items
tags: [scabbard, metric, mouth_gap, bbox, render, verification]
sources: [memory/scabbard-mouth-metric-pitfall.md]
updated: 2026-10-18
---

# Scabbard mouth metric: use both references

A tool's scabbard number `mouth_gap = scabbard.MinY - guard.MaxY` looks wrong on a **swept hilt**: `guard.MaxY` is the knucklebow tip sweeping up alongside the blade, not the crossguard. Re-basing on `blade.MinY` traded one blind spot for another, and then masked a real bug (a drooping cross where `-5.68` was real, `-0.13` hid it).

| metric | answers | blind spot |
|---|---|---|
| `scabbard.MinY - blade.MinY` | does the scabbard sheathe the blade mesh? | blind to where the blade sits on the guard |
| `scabbard.MinY - guard.MaxY` | does the mouth meet the cross? | knucklebow tips on swept hilts |

They disagree exactly when the blade is mis-seated in the guard ([[scabbard-anchored-to-blade-pivot]]): the scabbard wraps the blade perfectly while swallowing the whole crossguard.

**Lessons:** a metric's name is a claim, not proof; "I found the flaw in the old metric" is not proof the replacement has none. Read a metric's implementation before optimising it; when two references disagree, treat the disagreement as the signal. Fleet sanity checks (14 of 17 near 0) identify outliers only for the reference you chose. **When a number and a render disagree, the render wins, as does the user describing what they see.**

Related: [[scabbard-length-families]], [[crafting-contact-profile-check]]
