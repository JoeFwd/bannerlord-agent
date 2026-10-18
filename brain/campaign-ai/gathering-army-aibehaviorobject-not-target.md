---
name: gathering-army-aibehaviorobject-not-target
description: A gathering Besieger Army's AiBehaviorObject is a gathering fortress, never the siege target, so "targets goal" tests are false while gathering; and vanilla Defender scoring pulls a whole kingdom onto same-kingdom sieges
type: lesson
topic: campaign-ai
tags: [army, aibehaviorobject, gather, defender-scoring, same-kingdom, siege]
sources: [memory/gathering-army-aibehaviorobject-not-target.md]
updated: 2026-10-18
---

# Never identify an army's target by AiBehaviorObject

`Army.Gather` (vanilla 1.4.8) sets `AiBehaviorObject` to a *gathering* fortress and explicitly excludes the focus/target settlement. So `AiBehaviorObject == goal` is false for the whole gathering phase, and an army that *defends* the goal also has it as `AiBehaviorObject`.

Second vanilla trap: `AiMilitaryBehavior` Defender scoring targets any besieged settlement in the party's own kingdom, so a same-kingdom siege draws the besieger's own side into DefendSettlement. Counter with `PartyThinkParams.SetBehaviorScore` to zero those scores.

**Rule:** both failure modes look like "AI indecision" in logs. For any same-kingdom conflict feature, assume vanilla relief AI will respond to it; record the intended leader/target yourself instead of inferring it.

Related: [[same-kingdom-mapevent-diplomatically-finished]]
