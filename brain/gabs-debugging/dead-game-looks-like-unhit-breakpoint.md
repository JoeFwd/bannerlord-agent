---
name: dead-game-looks-like-unhit-breakpoint
description: A game that has died looks exactly like a breakpoint that has not fired yet; any wait on a breakpoint or observation needs a liveness check at least every 60s
type: lesson
topic: gabs-debugging
tags: [gabs, debugger, rider, breakpoint, wait_for_pause, crash, playtester]
sources: [DADG private-war playtest session 2026-10-20]
updated: 2026-10-20
---

# A dead game looks like a breakpoint that has not fired yet

An agent waiting on `wait_for_pause` or a log-poll loop sees exactly the same silence whether the
breakpoint just hasn't hit yet or the game has already died. Causes of a dead game include a native
AV, a silent exit after a long pause, and a GABP disconnect. Without a liveness check the agent waits
forever.

**Evidence:** on 2026-10-20 a playtester armed a first-chance exception breakpoint and kept waiting
for it. Meanwhile Bannerlord.exe had exited, which a single `Get-Process Bannerlord` in the parent
session showed at once. The same run had already lost two earlier game sessions to a native AV and a
GABP close.

**How to apply:**
- On any wait of a minute or more, check every 60s or less:
  - `Get-Process Bannerlord`;
  - `games_status`;
  - `get_debug_session_status` / `list_debug_sessions`.
- Once the process is gone, stop waiting and collect the death evidence:
  - the rgl log tail;
  - the crash folder or dump;
  - the Windows Application event log for Bannerlord.exe;
  - the mod log tail.
- Report the faulting module and offset, and the campaign time of death.

Related: [[debugger-pause-kills-gabp-game]], [[clr-exception-breakpoints-needed-to-catch-silent-death]], [[resuming-from-first-chance-exception-kills-process]]
