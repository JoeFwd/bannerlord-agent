---
name: invasion-style-party-state-machine-observed
description: Observed phase/threshold behaviour of a CustomSpawns-style invasion party (search, recon, approach, siege abandon at 1.5 strength ratio, cooldown).
type: reference
topic: campaign-ai
tags: [customspawns, invasion, ai]
sources: [runtime-evidence/customspawns-failed-invasion-rider-only (2026-09-20)]
updated: 2026-10-18
---

# Observed invasion state machine

For a custom AI party that invades settlements (CustomSpawns-style):
- Phases: Search -> Recon (0.5-1.0 days) -> Approach -> siege; the operation window is 5-10 days, then a 2-day cooldown, then Idle and a new episode.
- A siege is abandoned when attacker-to-defender strength falls below 1.5 (roaming-hostile threshold 1.2).
- Reinforcement scheduling starts only after a confirmed capture; zero values before a foothold are expected, not a bug.
- After a retreat the healthy state is: phase Search, target null, operation clock advancing 1/24 day per hour, patrolling home, group unsuspended and unspent, no foothold.

Debugger hygiene: an unconditional breakpoint inside a per-frame diplomacy behaviour re-pauses every frame.

