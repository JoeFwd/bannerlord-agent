---
name: ws-ship-upgrade-slot-mechanism
description: How War Sails turns hull XML slots into visible prefab children - upgrade_slot tag + hull tag_id key + piece slot_prefab_child_id, base/platform semantics, XML load ids, culture and AI upgrade rules
type: reference
topic: war-sails-naval
tags: [war-sails, navaldlc, ship-upgrade, upgrade_slot, ShipHull, ShipSlot, ShipUpgradePiece, MissionShipFactory]
sources: [NavalDLC 1.4.8 decompile - MissionShipFactory.cs, NavalDLCSubModule.cs, ShipUpgradeCampaignBehavior.cs, NavalDLCExtensions.cs; TaleWorlds.Core 1.4.8 ShipHull.cs, ShipSlot.cs, ShipUpgradePiece.cs, Ship.cs]
updated: 2026-10-23
---

# War Sails ship upgrade slots

## Prefab side

`MissionShipFactory.CleanNonExistingUpgrades` runs when a mission ship spawns:

- It collects every descendant tagged `upgrade_slot`. The search is recursive (`CollectChildrenEntitiesWithTag`), so a slot can sit under any holder.
- A slot matches an equipped piece when one of the slot entity's tags equals the piece's **slot key**.
- In a matched slot, the child tagged with the piece's `slot_prefab_child_id` stays. Every other child is removed, except children tagged `base` or `platform`.
- `base` children are removed when a piece is present. `platform` children are kept only when a piece is present.
- When no piece matches, the slot entity is removed. If it has `base` children, only the non-base children are removed instead.
- The pairs come from `Ship.GetShipVisualSlotInfos()`: (slot key, `SlotPrefabChildTagId`) for each piece, plus ("figurehead", figurehead id).

## XML side

**`ShipHull/AvailableSlots/ShipSlot`**
- `id` names the ShipSlot object.
- `tag_id` is the **dictionary key**. That key is also the `Ship._shipPieces` key and the tag the prefab slot entity must carry.
- An unknown slot id raises a FailedAssert and the entry is skipped.

**`ShipSlot`**
- Attributes are `id`, `type_id` (the UI name is `str_ship_slot_type.<type_id>`) and `prefab_id`.
- Its `ShipUpgradePieces` child list links pieces to the slot in both directions.

**`ShipUpgradePiece`**
- `TargetSlots/ShipSlot id=…` creates or links the slot itself, so a new piece can target a slot without editing ship_slots.xml.
- Attributes:
  - `slot_prefab_child_id`, which defaults to the piece id
  - `siege_engine="SiegeEngineType.x"`, used by the campaign simulation
  - `required_port_level`
  - `required_culture_1_id` and `required_culture_2_id`
  - `light_value`, `medium_value` and `heavy_value`

**Loading**
- `NavalDLCSubModule.RegisterSubModuleObjects` loads the XmlName ids in this order: `ShipUpgradePieces`, `ShipSlots`, `ShipHulls`, `ShipPhysicsReferences`, `MissionShips`.
- A mod adds files under the same ids with `<XmlNode>` entries in its SubModule.xml.
- `SiegeEngines` loads earlier, so a piece can reference a mod's own SiegeEngineType.

## Who gets pieces

- **Port shop** (`NavalDLCExtensions`): a piece is offered when all of these hold:
  - it is not `NotMerchandise`;
  - its `RequiredPortLevel` is at most the port level;
  - either both required cultures are null (offered everywhere), or the port culture equals one of them.
- **AI lords** (`ShipUpgradeCampaignBehavior`): each day there is a chance scaled by clan tier. The lord picks a random hull slot and a random merchandise piece with `RequiredPortLevel == current piece level + 1` (level 1 for an empty slot).
  - There is **no culture check**.
  - The same tick runs once for every party at new-game creation, so a level-1 piece appears on some AI ships from day one.

Related: [[ws-one-siege-weapon-per-ship]], [[ws-ship-ballista-prefab-requirements]], [[bannerlord-xml-load-abort-semantics]]
