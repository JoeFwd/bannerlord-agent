---
name: xscene-byte-preserving-span-edits
description: Edit a huge .xscene by byte spans (Expat offsets), hash-pinned and failure-atomic, instead of re-serialising the XML.
type: howto
topic: scenes-xscene
tags: [xscene, howto, tooling]
sources: [sdd/scottish-prefab-compaction, sdd/scottish-prefab-rollout, sdd/scotland-layout-v3]
updated: 2026-10-18
---

# Xscene byte preserving span edits

Re-serialising a 34 MB scene XML rewrites formatting and risks silent diffs. Method used across several scene migrations:

1. Parse once with Expat and record start/end byte offsets of the target elements.
2. Compute replacements as (span, new bytes) pairs; apply from the end of the file backwards so offsets stay valid.
3. Pin the input SHA-256 and refuse to apply if it differs; write output to a temp file and verify the expected SHA-256 before swapping in.
4. Windows atomic replace failed once when the target was open; use an explicit one-use swap with backup files.
5. Verify afterwards that untouched spans are byte-identical. Scene files can have no BOM; preserve that.

Pitfall found by review: a move step claimed 145 collision roots were moved while they were left in place. Count entities by role before and after, not just total transforms.

Related: [[settlement-shell-prefab-structure-rules]], [[xscene-editor-vs-runtime-data-split]], [[map-settlement-position-two-files]]
