---
name: evaluate-in-debugger-without-freezing-the-game
description: Never put logging breakpoints (or {this} log messages) on per-frame paths; let the battle run, then take snapshots from a throttled once-per-second main-thread anchor and check Mission.Current.CurrentTime advanced
type: lesson
topic: gabs-debugging
tags: [rider, breakpoint, evaluate, per-frame, snapshot, freeze]
sources: [memory/safe-evaluation-breakpoint-anchor.md]
updated: 2026-10-18
---

# Evaluating live code without freezing the game

To evaluate arbitrary campaign or mission code in a live debug session, set a suspending breakpoint on a main-thread, throttled (about once per second) line that is live in both campaign and mission contexts, hit it, run all `evaluate_expression` calls from that frame, then remove the breakpoint and resume. Prefer the mod's own source over decompiled source to avoid decompiled-breakpoint friction.

**Never** put logging breakpoints in per-frame paths (`OnTick`, `Update`, `HandleAITeamUsage`). Even with `suspend=none`, evaluating per frame across many objects freezes the game so badly a live-action battle cannot play out; `{this}` in a log message is worst (full `ToString()` per object per tick).

Instead let the battle run clean, let wall-clock time pass, then snapshot. Take two snapshots and verify `Mission.Current.CurrentTime` advanced: an identical value means the game was frozen at a breakpoint the whole time and the observations are worthless.

Related: [[debugger-pause-kills-gabp-game]]
