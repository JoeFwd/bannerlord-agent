---
name: bannerlord-xml-load-abort-semantics
description: MBObjectManager.LoadXml has no try/catch - one bad node silently kills every object after it in the merged document; classic cause of cascading NREs
type: reference
topic: xml-data
tags: [xml, mbobjectmanager, nre, migration, equipment]
sources: [memory/bannerlord-xml-load-abort-semantics.md]
updated: 2026-10-18
---

# XML load aborts the whole merged document

`MBObjectManager.LoadXml(XmlDocument, bool)` iterates sibling nodes with **no try/catch**:

```csharp
for (XmlNode n = doc.ChildNodes[i].ChildNodes[0]; n != null; n = n.NextSibling)
    GetPresumedObject(typeName, n.Attributes["id"].Value, true).Deserialize(this, n);
```

A single throwing node aborts the **entire merged document** (all modules' contributions for that xml id). Every object defined after the throw point is never registered. The caught-and-logged exception you see is usually the second-order NRE, not the cause.

Diagnostic tell: objects early in a file work, objects later in the same file resolve to `null`. Bisect by file position, not by object.

Two 1.2 to 1.4 data breaks that trigger exactly this (found migrating a total-conversion mod):

- `<Flags>` on `EquipmentRoster` is parsed with `Enum.Parse(typeof(EquipmentCategories), attribute.Name)` and **throws** on unknown names. 1.2's enum was `EquipmentFlags` (IsNobleTemplate, IsNoncombatantTemplate, IsCombatantTemplate, IsCivilianTemplate, IsMediumTemplate); 1.4's is `EquipmentCategories` with only `None, IsFemaleTemplate, IsLordTemplate, IsChildEquipmentTemplate, IsTeenagerEquipmentTemplate, IsKingdomRulerTemplate`.
- In `BasicCharacterObject.Deserialize`, `Culture` is assigned **after** the `<Equipments>` child loop. Any throw in equipment parsing leaves `CharacterObject.Culture` null forever, which later NREs in `CharacterObject.StealthEquipments` and (1.4-only) `LordNeedsHorsesIssueBehavior.ConditionsHold`, which does an unguarded `issueGiver.Culture.StringId != "nord"`.

`ReadObjectReferenceFromXml` routes through `GetPresumedObject`, which fabricates a placeholder rather than returning null, so a *dangling* id reference does not itself throw. Null from `GetObject<T>` means the object was never registered, i.e. a load abort.

Related: [[constant-war-peace-loop]]
