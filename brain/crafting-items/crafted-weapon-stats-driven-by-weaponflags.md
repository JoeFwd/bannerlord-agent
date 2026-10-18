---
name: crafted-weapon-stats-driven-by-weaponflags
description: Bannerlord crafted-weapon speed/damage branch on WeaponDescription WeaponFlags, never on weapon_class; WideGrip without NotUsableWithOneHand is a data trap
type: reference
topic: crafting-items
tags: [crafting, weaponflags, widegrip, swing-speed, damage]
sources: [memory/crafted-weapon-stats-driven-by-weaponflags.md]
updated: 2026-10-18
---

# Crafted stats come from WeaponFlags, not weapon_class

In `TaleWorlds.Core.Crafting`, crafted-weapon stats are computed **only from `WeaponDescription.WeaponFlags`**. `weapon_class` never enters the stat model; it selects animations/usage only.

```csharp
// CalculateStats()
_stoppingTorque = 10f; _armInertia = 2.9f;
if (flags.HasAllFlags(MeleeWeapon | NotUsableWithOneHand)) { _stoppingTorque *= 1.5f; _armInertia *= 1.4f; }
if (flags.HasAllFlags(MeleeWeapon | WideGrip))             { _stoppingTorque *= 1.5f; _armInertia *= 1.4f; }

// CalculateSwingSpeed() - compensation gated ONLY on NotUsableWithOneHand
if (flags.HasAllFlags(MeleeWeapon | NotUsableWithOneHand)) {
    if (flags.HasAnyFlag(WideGrip)) { num += 1.5; num6 *= 4.0; num5 *= 1.7; num3 *= 1.3; num2 *= 1.15; }
    else                            { num += 1.0; num6 *= 2.4; num5 *= 1.3; num3 *= 1.35; num2 *= 1.15; }
}
```

**`WideGrip` without `NotUsableWithOneHand` is a data trap:** it charges the inertia/torque penalty and unlocks none of the two-handed leverage compensation. One mod's half-sword description had exactly that; adding `NotUsableWithOneHand` took a longsword half-sword swing from 45/67 to 101/100 and a two-hander half-sword from 47/62 to 114/97, with `weapon_class="TwoHandedPolearm"` unchanged.

Tuning consequences:
- Damage is **derived from** speed (`CalculateBaseBlowMagnitudeForSwing(swingSpeed, reach, weight, inertia, com, ...)`), so a usage cannot be made faster *and* weaker through description data; that needs a Harmony post-adjust of the generated `WeaponComponentData`.
- `_swingDamageFactor`/`_thrustDamageFactor` come from `UsedPieces[0].CraftingPiece.BladeData`, i.e. the blade, shared by every usage of the item.
- A `WeaponDescription` exposes only `weapon_class`, `item_usage_features`, `WeaponFlags`, `AvailablePieces`. `item_usage_features` drives animation/blocking, never numbers. **`WeaponFlags` is the entire per-usage numeric lever**: 4 useful melee combinations.

Related: [[crafting-usage-vs-bench-list-rules]]
