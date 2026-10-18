---
name: campaign-perf-measurement-method
description: Howto - measure campaign-map frame cost with a temporary Harmony Stopwatch probe loaded through the debugger, and the pitfalls (inclusive times, warmup, drift, unmatched baselines).
type: howto
topic: engine-runtime
tags: [performance, harmony, campaign, profiling]
sources: [src/.tmp/warsails-perf/findings.txt, src/.tmp/perfview-analysis/summarize_stacks.py]
updated: 2026-10-18
---

# Campaign perf method that worked

- Compile a standalone temporary probe DLL and load it into the running process via the debugger; Harmony-patch main-thread boundaries (Campaign.Tick, MapScreen.TickVisuals, MBMapScene.TickVisuals, periodic-event managers) with Stopwatch; record a per-frame CSV and an inclusive per-method CSV. Remove patches/callbacks and restore settings afterwards; verify via the debugger (remaining patches = 0). Loaded probe DLLs stay inert until process exit.
- 90 warmup frames then 400-600 measured frames per stage; sequence stages automatically (paused / normal / fast) and restore the previous time mode.
- Inclusive nested times must not be summed. Native visual-update time includes waiting inside the call. Engine dt clamps long frames, so a method max can exceed dt. Debugger and instrumentation add overhead.
- A/B needs matched conditions: campaign time advancing or the player moving invalidates a stage. Run-to-run drift was ~0.5 ms, as large as the effect of hiding the sea or lowering water quality.
- Suspending all map visual ticks saved 3.5-4.8 ms/frame (native visual update is ~5 ms even paused): a diagnostic, not a fix.
- Compare navmesh metrics (face counts, water components, largest water component) against the pre-change mesh and the official DLC mesh before blaming navmesh size.
- For deeper sampling, export PerfView stacks to XML and bucket CPU by frame-name pattern per second (see `summarize_stacks.py`); this showed one behaviour eating three quarters of main-thread time.

Related: [[harmony-patch-failure-kills-game-silently]], [[ws-fmod-sail-sound-hang]]
