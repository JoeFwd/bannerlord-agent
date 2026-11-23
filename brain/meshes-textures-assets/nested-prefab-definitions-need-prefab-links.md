---
name: nested-prefab-definitions-need-prefab-links
description: Loose editor nested prefabs need prefab_link identities on scripts, entities and components; XML well-formedness alone does not prevent native startup crashes.
type: lesson
topic: meshes-textures-assets
tags: [editor, nested-prefab, crash, guid, xml]
sources: [Bannerlord 1.4.8 rglNested_prefab.cpp assertion at line 3883, NavalDLC cog_ship_nested ship_burning_system definitions, editor startup logs 17704 and 23168 and repaired run 42756 on 2026-11-14]
updated: 2026-11-14
---

Loose `<prefab_definition>` files must retain editor identities on entity, script and component definitions. Each needs a direct `<prefab_link>` with `<instance guid="{...}"/>` and `<prefab guid="{...}"/>`. Give new local definitions unique nonzero instance GUIDs and a zero prefab GUID; preserve inherited prototype references on copied definitions.

On 1.4.8, a new script without its link caused `rglNested_prefab.cpp:3883`, `prefab_link_node != nullptr`, then `Incorrect nested prefab definition found (script)` and a native access violation during startup. Parsing the XML successfully and validating gameplay tags did not detect it. After adding the missing links without changing any other XML semantics, the editor loaded all affected prefabs and continued asset loading.

Validate the native schema as well as XML syntax: require both GUID children for every definition, parse their GUIDs, reject duplicate instance identities within a definition file, and test the generator is idempotent. Keep prototype links intact. Verify a real editor launch after the static checks.

Related: [[xscene-editor-vs-runtime-data-split]], [[xscene-orphan-group-guid-crash]]
