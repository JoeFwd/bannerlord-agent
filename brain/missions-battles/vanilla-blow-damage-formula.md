---
name: vanilla-blow-damage-formula
description: DefaultStrikeMagnitudeModel.ComputeRawDamage - 50/(50+armour) scaling plus a flat armour subtraction per damage type (cut 0.5, pierce 0.33, blunt 0.2) blended by blunt factor; makes high armour near-immune to cuts
type: reference
topic: missions-battles
tags: [combat, damage, armour, models]
sources: [1.4.8 DefaultStrikeMagnitudeModel.cs ComputeRawDamage / GetBluntDamageFactorByDamageType]
updated: 2026-11-07
---

# Vanilla blow damage formula

`DefaultStrikeMagnitudeModel.ComputeRawDamage(type, magnitude, armour, absorbedRatio)` on 1.4.8:

```
scaled  = magnitude × 50 / (50 + armour)
flat    = max(0, scaled − armour × k)     k: Cut 0.5, Pierce 0.33, Blunt 0.2
damage  = (b × scaled + (1 − b) × flat) × absorbedRatio
          b (blunt factor): Cut 0.1, Pierce 0.25, Blunt 0.6
```

- **The flat subtraction is why heavy armour is close to immune to cuts.** A 100-magnitude cut on 85 armour gives `scaled` = 37 and `flat` = 0, so the result is 0.1 × 37 = **3.7**. Only the blunt-factor share gets through.
- **Lowering swing magnitude makes armour stronger, not weaker.** `flat` hits 0 sooner, so a weapon rebalance on its own pushes things further towards immunity.
- `armour` is the value `CalculateAdjustedArmorForBlow` returned. That method is **virtual**, so a model decorator can change armour per blow without Harmony. A decorator keeps vanilla perks when it calls `BaseModel` first and then scales the result.
- The armour value itself comes from `AgentDrivenProperties` (ArmorHead, ArmorTorso, ArmorArms, ArmorLegs) for the bone's body part. For head and neck, see [[head-armour-sums-all-slots]].
- Final damage then goes through `AgentApplyDamageModel.CalculateDamage`: [[agent-apply-damage-model-decorator]].

Related: [[agent-apply-damage-model-decorator]], [[head-armour-sums-all-slots]], [[dadg-combat-overhaul]]
