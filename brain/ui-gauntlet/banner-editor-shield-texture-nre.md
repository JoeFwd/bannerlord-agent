---
name: banner-editor-shield-texture-nre
description: BannerEditorView.OnNewBannerReadyForShield can throw an intermittent vanilla NRE at character-creation age selection via the thumbnail cache.
type: incident
topic: ui-gauntlet
tags: [banner-editor, nre, intermittent]
sources: [runtime-evidence/banner-editor-nre-blocker (2026-08-03)]
updated: 2026-10-18
---

# Intermittent BannerEditor NRE (UNFIXED, vanilla)

`SandBox.GauntletUI.BannerEditor.BannerEditorView.OnNewBannerReadyForShield` throws an NRE on the Next click of the age-selection step, via `BannerEditorTextureCache` and `ThumbnailCache`. Three byte-identical crashes were followed by one success with the same inputs, so it is timing-dependent and not culture-specific. Without CLR exception breakpoints the process dies silently.

Related trap: choosing the "joined a commander's staff" youth option in the same flow throws a `TargetInvocationException`; avoiding that option avoids the exception.

Related: [[clr-exception-breakpoints-needed-to-catch-silent-death]]
