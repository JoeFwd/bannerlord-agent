---
name: coop-replication-gotchas-for-content-mods
description: What a content mod must expect from a campaign co-op layer: authority gates, exact-type tournament checks, puppet equipment re-rolls and usage-index sync.
type: reference
topic: coop-multiplayer
tags: [coop, replication, tournament, equipment]
sources: [doc/coop-compatibility-analysis.md]
updated: 2026-10-18
---

# Coop replication gotchas for content mods

Observed in a co-op layer analysis (source read-only, 2026-10-11):

- **Authority:** each siege machine is simulated on exactly one peer; the layer gates vanilla `SiegeWeapon.TickAux`, transpiles `RangedSiegeWeapon.OnTick`, and blocks `Shoot` on non-owners. A mod's own `OnTick` additions (crew AI, ammo pickup, recoil) are not gated, so they run on every peer and crews flap. Expose a static "is simulated locally" hook defaulting to true.
- **Observer visuals:** effects driven by the mod's own state transitions (smoke, sound, recoil on `State = Shooting`) never fire on non-owners. Provide a public `PlayShotEffects()` the adapter can call when a shot is replayed.
- **Ammo:** the layer syncs ammo only for native machine types.
- **Tournaments:** support is gated by exact type `GetType() == typeof(FightTournamentGame)`; any subclass (custom prizes, jousts) is greyed out. A joust cannot ride this support because the launcher rebuilds a plain fight game.
- **Equipment:** puppets are spawned from the owner's equipment, then a mod's `SpawnAgent` prefix that re-rolls loadouts on an exact XML match overrides it. Provide a skip predicate.
- **Usage index:** wielded weapons sync by item id plus raw usage index; if a mod rewrites an item's usage list on one machine (for example a couch-only lance), the index points somewhere else on the puppet. Apply such changes in `OnAgentBuild`, which also runs for puppets.
- Save data reaches joiners in memory and the module list must match.
- Third-party campaign behaviours are not gated generically; check live whether they tick on clients.

Related: [[coop-two-prefixes-on-one-method-ordering]]
