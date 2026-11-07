---
name: head-armour-sums-all-slots
description: Agent ArmorHead (used for Head AND Neck hits) = Equipment.GetHeadArmorSum, which adds head_armor from every armour slot including Cape - bevors/gorgets authored as capes raise head armour
type: lesson
topic: crafting-items
tags: [armour, items, equipment, agent-stats]
sources: [1.4.8 SandboxAgentStatCalculateModel / CustomBattleAgentStatCalculateModel (ArmorHead = GetHeadArmorSum)]
updated: 2026-11-07
---

# Head armour sums every slot

The agent stat models set `ArmorHead = spawnEquipment.GetHeadArmorSum()`. That covers SandboxAgentStatCalculateModel, CustomBattleAgentStatCalculateModel and the rest. The function adds `head_armor` from **every** armour slot, not only the helmet. Head and Neck hits both use ArmorHead.

- An item in the **Cape** slot with `head_armor` > 0 (a bevor, gorget or crest) adds to head and neck armour.
- A helmet's value is therefore not the total. Budget helmet plus cape when setting head values.
- Body pieces follow the same pattern (`GetHumanBodyArmorSum` and the arm and leg sums), so a body armour with `leg_armor` adds to leg armour.

Related: [[vanilla-blow-damage-formula]], [[crafted-weapons-ignore-tier-override]], [[dadg-armour-values]]
