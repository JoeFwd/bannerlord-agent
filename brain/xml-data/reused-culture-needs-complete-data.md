---
name: reused-culture-needs-complete-data
description: Reusing a vanilla culture id for new content crashes in kingdom init, hero creation and patrol spawning when the culture lacks policies, notable templates or patrol templates.
type: lesson
topic: xml-data
tags: [culture, crash, nre]
sources: [runtime-evidence/scotland-campaign-load, runtime-evidence/scotland-kingdom-load-gate, runtime-evidence/private-war-prosecution-fixes, memory/kingdom-culture-needs-default-policy-list]
updated: 2026-10-18
---

# Culture data gaps crash at campaign start

If a mod reuses a culture whose vanilla data is stripped or incomplete, each consumer fails with a different null:
- `Kingdom.InitializeKingdom` NRE (`Kingdom.cs:530`): it iterates `Culture.DefaultPolicyList` with no null guard, so a `<Kingdom>` whose `culture=` has a null/unpopulated list throws a hard NRE on campaign load, before the map appears. Fix: give the kingdom a culture that has default policies (in one total-conversion mod the kingdoms used `Culture.empire` while `Culture.battania` had a null list). Only the KINGDOM object's culture triggers this path; clans and settlements can still use the culture.
- `DefaultHeroCreationModel.GetRandomTemplateByOccupation` ArgumentNullException (a `.Where` on null): `Culture.NotableAndWandererTemplates` is null. It hits the first settlement processed whose culture lacks notable/wanderer templates, and lord templates are likely missing too.
- `PatrolPartiesCampaignBehavior.SpawnPatrolParty` NRE: `templateForPatrolParty` null for a settlement whose owner/culture has no patrol template.
- Births crash when the hero's culture has no child roster.

Apply: when adding settlements/kingdoms with a culture, check that culture's `default_policy_list`, notable, wanderer, lord, child roster and patrol templates exist, or point the content at a fully-populated culture. Each is only found one crash at a time, so audit them together.

Related: [[bannerlord-xml-load-abort-semantics]]
