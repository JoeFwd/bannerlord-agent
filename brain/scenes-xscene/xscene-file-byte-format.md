---
name: xscene-file-byte-format
description: scene.xscene exact text format: CRLF, tab indent, no BOM, self-closing tags without a space; round-trip serialisers change it.
type: reference
topic: scenes-xscene
tags: [xscene, format]
sources: [Bannerlord Navmesh Studio (README, blnav docstrings)]
updated: 2026-10-18
---

# scene.xscene byte format

CRLF line endings, tab indentation, `<?xml version="1.0"?>` header, no BOM, self-closing tags written `<x/>` (no space), floats `%.3f`, file ends with `</root>` plus two CRLFs. ElementTree and .NET serialisers alter these bytes, so anchor edits on the raw text (regex/offset), not a parse and re-dump.

Related: [[xscene-declares-level-bit-mapping]]
