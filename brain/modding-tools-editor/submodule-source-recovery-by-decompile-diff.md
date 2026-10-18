---
name: submodule-source-recovery-by-decompile-diff
description: How to recover and verify lost C# source from deployed DLLs - ilspycmd -p, then diff decompile-vs-decompile of the live build to cancel decompiler noise; grep binaries case-insensitively
type: howto
topic: modding-tools-editor
tags: [decompile, ilspy, recovery, git, submodule, worktree]
sources: [memory/faction-wars-v2-lost-submodule-commit.md]
updated: 2026-10-18
---

# Recovering lost source from a deployed DLL

If a commit exists only as built binaries, `ilspycmd -p` (project output) recovers the sources (114 .cs files in the case seen).

**Porting method: decompiler-output-vs-decompiler-output diffing.** Build the live tree, decompile it with the same `ilspycmd -p`, and diff that against the recovered tree. This cancels decompiler noise: it shrank ~20 "modified" files to 2 real ones. Known noise classes (newer Roslyn vs older): ternary vs `if/return` flattening, `int result` lambda flattening, `if (1 == 0)` / `if (true)` switch markers, local renames, `//IL_` comments, enum `== 0` vs `<= 0`. Field and const names are metadata and are NOT noise. Verification rule for any residual line: diff it against the pre-port live-vs-recovered baseline too; if it was already there, the port did not introduce it.

**Pitfalls:**
- Grep binaries case-insensitively and for the PascalCase symbol (`Supporters`, `AttackerSupporters`), not lowercase `supporter`. A false-negative case-sensitive grep once shut down the correct recovery path for a whole session.
- Provenance: check `AssemblyInformationalVersion`. A build of the outer solution stamps the OUTER repo SHA; a standalone submodule solution stamps the submodule. A SHA that matches the outer repo and files absent from newer commits rule out a circular decompile of regenerated code.
- A project excluded from the build (e.g. an API project) will not be in the DLL set; reconstruct from a surviving consumer's call site instead.
- **Worktree hazard:** a worktree's submodule git dir lives under `.git/worktrees/<name>/modules/`, so `git worktree remove` deletes unpushed submodule commits. Fetch them out first.
