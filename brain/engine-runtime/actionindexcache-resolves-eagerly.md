---
name: actionindexcache-resolves-eagerly
description: ActionIndexCache.Create resolves the action index immediately and for good; a static field initialised during module load caches -1 because action types are read later
type: lesson
topic: engine-runtime
tags: [animation, action-set, static-init, module-load]
sources: [session 2026-10-25 visor conversation clip]
updated: 2026-10-25
---

# ActionIndexCache resolves eagerly

In 1.4.8, `ActionIndexCache.Create(name)` calls `new ActionIndexCache(name)`, which sets
`Index = MBAnimation.GetActionCodeWithName(name)` on the spot. The value is never re-resolved.

The engine reads the action type XMLs ("reading action files" in the rgl log) after
`OnSubModuleLoad`. A `static readonly ActionIndexCache` on a class whose statics run during module
load (for example because a static `IsSupported` check is called from `SubModule`) caches
index -1 for good. Playing it then fails with "Action index -1 ... animation ''".

The same field pattern works on a class first touched in a mission, which is why copying it from
mission code looks safe.

Fix: call `ActionIndexCache.Create(name)` where you use it, or keep the statics on a class that
module load never touches. Treat `== ActionIndexCache.act_none` as "not loaded".

Related: [[bannerlord-live-version]]
