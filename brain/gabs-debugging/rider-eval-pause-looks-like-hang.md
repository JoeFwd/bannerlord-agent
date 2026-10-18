---
name: rider-eval-pause-looks-like-hang
description: A debugger pause (breakpoint, first-chance exception, eval) stops the whole game process and makes GABS calls time out, which looks exactly like a hang.
type: lesson
topic: gabs-debugging
tags: [gabs, rider, debugger, timeout]
sources: [runtime-evidence/private-wars-no-solo-siege.feature.md, runtime-evidence/ws-fmod-sail-sound-hang]
updated: 2026-10-18
---

# A debugger pause looks like a game hang

When the Rider/JetBrains debugger is attached, any pause stops every game thread. The GABP bridge then answers nothing and every GABS tool call times out (typically 20-30 s). Two consecutive timeouts mean "check the debugger" before "the game hung".

How to tell: call the debugger's `get_debug_session_status`. `state=paused` (often `pausedReason="step"` even when the real cause is a first-chance exception) means a genuine pause, not a soft-lock. Read `$exception` at frame 0 to see what it stopped on.

Gotchas:
- The same applies to the FMOD sail-sound livelock investigation: a pause caused by an evaluation was mistaken for the hang being studied.
- A debugger configured to break on every first-chance exception will stop on vanilla exceptions that the game would have swallowed.

Related: [[resuming-from-first-chance-exception-kills-process]], [[clr-exception-breakpoints-needed-to-catch-silent-death]], [[ws-fmod-sail-sound-hang]]
