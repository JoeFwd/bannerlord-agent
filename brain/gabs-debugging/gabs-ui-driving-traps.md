---
name: gabs-ui-driving-traps
description: Small GABS UI-driving traps: arguments key name, save-list widgets, crafting-screen saves, click_widget exceptions, missing MCM.
type: reference
topic: gabs-debugging
tags: [gabs, ui, traps]
sources: [runtime-evidence/private-wars-goal-army-fix-verification, runtime-evidence/smithy-longsword-crash, runtime-evidence/cannon-assault-startup-gabs-blocker]
updated: 2026-10-18
---

# GABS UI-driving traps

- `games_call_tool` takes `arguments`, not `args`; the wrong key silently sends nothing.
- Save-list ViewModel property names cannot be guessed. Click the save's own text via `ui.click_widget` with the slot name as `widgetId`. Never use `core.load_save` (see [[gabs-load-save-forbidden]]).
- Inside the crafting screen a save request did not complete (`wait_for_save` timed out). Save before entering.
- For crafting piece selection use `call_viewmodel_method_at_index` with `ExecuteSelect`; `click_widget` can raise a silent `TargetInvocationException` that looks like a real crash but is not.
- A party that runs out of food flips to `GoToPoint` and leaves the wait menu, which unfreezes AI time.
- A GABS submodule startup failure `FileNotFoundException MCMv5 5.10.2.0` in `StartServer` means the MCM dependency is not in the module order or bin; it is an environment problem, not a mod bug (see [[gabs-on-1-4-7]]).
- An unconditional breakpoint left on a per-frame behaviour re-pauses every frame; remove stale breakpoints from earlier investigations (one pointed at a different install path) before each run.

Related: [[gabs-load-save-forbidden]], [[gabs-on-1-4-7]], [[rider-eval-pause-looks-like-hang]]
