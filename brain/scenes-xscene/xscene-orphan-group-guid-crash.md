---
name: xscene-orphan-group-guid-crash
description: An edit_mode_data group_object_guid not declared in editor_data crashes the Modding Kit editor with a native AV on scene load while the game runs fine; fix by declaring the group
type: incident
topic: scenes-xscene
tags: [xscene, group_object_guid, editor_data, edit_mode_data, access-violation, crlf]
sources: [memory/xscene-orphan-group-guid-crash.md, navmesh-agent/editor-data-merge-overwrites-group-declarations]
updated: 2026-10-18
---

# Orphan group_object_guid crashes the editor

In `scene.xscene`, every `<edit_mode_data group_object_guid="{...}"/>` must have a matching `<group_object guid="{...}"/>` inside `<editor_data><group_objects>`. An undeclared GUID crashes the editor on scene load:

```
Faulting application: TaleWorlds.MountAndBlade.Launcher.exe (bin\Win64_Shipping_wEditor)
Faulting module: TaleWorlds.Native.dll   Exception 0xc0000005 (access violation)
```

**Cause pattern:** copying entity subtrees between scenes carries `edit_mode_data` with them, but `editor_data` is a single top-level node that merge scripts overwrite wholesale instead of unioning. The runtime reads neither, so it is invisible in game ([[xscene-editor-vs-runtime-data-split]]).

**Check before launching anything:**
```python
r = ET.parse("scene.xscene").getroot()
declared = {g.get("guid") for g in r.iter("group_object")}
used = {e.get("group_object_guid") for e in r.iter("edit_mode_data")} - {None}
print(used - declared)   # must be empty
```
Fix by declaring the missing group (preserves grouping), not by stripping the attribute. Scene-composition tooling should assert used GUIDs are a subset of declared ones before writing, and a merge of a second donor scene must union `<editor_data>` rather than replace it.

**Format notes:** `scene.xscene` is CRLF, tab-indented, self-closing tags with NO space before `/>`, and NO BOM. .NET's `OuterXml` re-serializes and will not match on-disk bytes; anchor byte-level edits on the raw text.

