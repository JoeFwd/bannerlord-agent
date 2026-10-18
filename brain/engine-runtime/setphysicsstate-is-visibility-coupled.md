---
name: setphysicsstate-is-visibility-coupled
description: GameEntity.SetPhysicsState(false) hides the entity as well as disabling its rigid body - the native call drives both, and the managed override is empty so C# reading cannot reveal it
type: lesson
topic: engine-runtime
tags: [setphysicsstate, visibility, collider, native, gameentity]
sources: [memory/setphysicsstate-is-visibility-coupled.md]
updated: 2026-10-18
---

# SetPhysicsState also toggles visibility

`GameEntity.SetPhysicsState(isEnabled, setChildren)` is a thin pass-through to native `EngineApplicationInterface.IGameEntity.SetPhysicsState` (`GameEntityPhysicsExtensions.cs:163`). It is **not** physics-only: natively it toggles render visibility too.

Vanilla evidence: `DeploymentPoint.cs:327,342,347,358` pass a local named `visible` straight into `SetPhysicsStateSynched`; managed `SynchedMissionObject.SetPhysicsStateSynched` is an empty virtual, so the coupling is entirely native.

**Why it bites:** disabling a collider "just to let agents walk through" silently makes the mesh vanish, reading as a missing-asset or shader bug.

**How to apply:** to turn off collision but keep the mesh drawn, use a collider-only body or `SetVisibilityExcludeParents` separately. Example: an ammo pile calling `SetPhysicsState(AmmoCount > 0, ...)` on `pile_collider` children hides the whole pile once empty.

Related: [[invisible-mesh-is-scale-not-shader]]
