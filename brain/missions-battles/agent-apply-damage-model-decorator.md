---
name: agent-apply-damage-model-decorator
description: AgentApplyDamageModel.CalculateDamage is non-virtual but dispatches every step through MissionGameModels.Current, so a decorator added with AddModel can override ApplyGeneralDamageModifiers etc. - no Harmony patch needed
type: lesson
topic: missions-battles
tags: [combat, damage, models, decorator, harmony-alternative]
sources: [1.4.8 AgentApplyDamageModel.cs, DADG DadgAgentApplyDamageModel (replaced a Harmony patch 2026-11-07)]
updated: 2026-11-07
---

# Decorate AgentApplyDamageModel instead of patching CalculateDamage

`AgentApplyDamageModel.CalculateDamage` is **not virtual**, which makes it look as though you need Harmony. You don't. Its body resolves `MissionGameModels.Current.AgentApplyDamageModel` and calls each step on that instance:

```
IsDamageIgnored → ApplyDamageAmplifications → ApplyDamageScaling
→ ApplyDamageReductions → ApplyGeneralDamageModifiers → max(0, …)
```

All of those steps are abstract and overridable. To change final damage:

1. Subclass `AgentApplyDamageModel`. Forward every member to `BaseModel` and override only the step you need. `ApplyGeneralDamageModifiers` is last, so it sees the fully modified damage.
2. Register it with `gameStarter.AddModel(new MyModel())` in `InitializeGameStarter`. `MBGameModel<T>.BaseModel` is set to the model that was current before yours, so the chain is preserved and other mods' decorators still run.

The same pattern works for `StrikeMagnitudeCalculationModel`, where `CalculateAdjustedArmorForBlow` is virtual ([[vanilla-blow-damage-formula]]), and for `ItemValueModel`.

**Forward every abstract member.** That includes the naval ones (`CalculateSailFireDamage`, `CalculateHullFireDamage`) on builds that have them. A decorator that answers them itself breaks War Sails and similar mods further down the chain.

Related: [[vanilla-blow-damage-formula]], [[harmony-patch-failure-kills-game-silently]], [[dadg-combat-overhaul]]
