---
name: debugger-pause-kills-gabp-game
description: Pausing Bannerlord in a JetBrains debugger for more than ~30s while GABS is connected makes the game exit silently on resume; GABS also deletes bridge.json on disconnect
type: lesson
topic: gabs-debugging
tags: [gabs, gabp, debugger, rider, breakpoint, timeout]
sources: [memory/debugger-pause-kills-gabp-game.md]
updated: 2026-10-18
---

# A long debugger pause kills a GABS-connected game

On 2026-10-13 a game running under Rider + GABS exited silently twice right after a breakpoint pause. GABS logged "request timeout after 30s", then "invalid character 'C'" / "missing Content-Length header" and "cleaned up game resources". Rider's idea.log showed `pauseSessionTask terminate` within milliseconds of `resume_execution`. No WER entry, no rgl error, no crash folder.

GABS disconnect cleanup also deletes `<configDir>/bannerlord/bridge.json`, so `games_connect` then fails with "failed to read bridge.json" until it is rewritten (port/token/gameId).

**Why:** a breakpoint (or slow conditional-breakpoint evaluation) that freezes the game past the GABP 30 s timeout is fatal once execution resumes.

**How to apply:**
- Keep pauses short: inspect, remove the breakpoint and resume within ~20 s.
- Never leave a conditional breakpoint on a hot path.
- Before a long pause, stop the GABS poller.
- After any GABP disconnect, rewrite bridge.json before reconnecting.

**The reverse loop:** with the IDE's exception breakpoints enabled, GABS's own first-chance socket exceptions (`ObjectDisposedException` in `NetworkStream.EndWrite` on a worker thread after a 30 s poll timed out) freeze the game; a tight poll loop plus exception breakpoints means one timeout freezes it for good. Poll rarely (>=60 s) with exception breakpoints on, and stop pollers as soon as GABP reports "connection closed". Resuming is user-only: `resume_execution` is denied by the auto-mode classifier.

