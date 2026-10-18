---
name: authored-genealogy-cycles-overflow-the-stack
description: A hero listed as his own father in authored XML makes any recursive ancestry walk recurse until a StackOverflow, which .NET cannot catch.
type: incident
topic: xml-data
tags: [xml, hero, crash, recursion]
sources: [doc/feudal-succession.md]
updated: 2026-10-18
---

# Authored genealogy cycles overflow the stack

Hero XML is authored, not engine-generated, and nothing validates parent links. In one mod a hero was listed as his own father; an unguarded descendant walk recursed until the process died. A `StackOverflowException` cannot be caught, so this is a crash, not a bad result.

Fix: carry a visited set seeded with the starting hero in every ancestry/descendant walk. It also removes the hero from his father's children list without a special case. Add a data audit for self-parent and parent cycles.

Status: FIXED in the mod.

Related: [[herokilled-event-and-clan-leader-handover-race]]
