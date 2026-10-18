---
name: scene-registration-by-folder-name
description: The engine finds a scene by folder name in any active module's SceneObj; custom battle menu entries come from a SubModule.xml node.
type: howto
topic: scenes-xscene
tags: [scenes, registration]
sources: [docs/scene-authoring-reference.md]
updated: 2026-10-18
---

# Registering a scene

Drop the folder in `<mod module>/SceneObj/<name>/`; it is found by name across active modules. To list it in Custom Battle add in SubModule.xml an XmlNode `CustomBattleScenes` containing `<Scene id=... name=... terrain="Plain"/>` (optional attributes such as `is_siege_map`).

Related: [[scene-minimum-entities-battle-scene]]
