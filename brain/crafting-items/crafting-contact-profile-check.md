---
name: crafting-contact-profile-check
description: Acceptance test for a Bannerlord blade/guard joint is the per-column contact percentage across the blade's base width, calibrated against healthy swords (88-100% @ 0.11-0.15 median gap)
type: howto
topic: crafting-items
tags: [crafting, joint, render, acceptance-test]
sources: [memory/crafting-contact-profile-check.md]
updated: 2026-10-18
---

# Contact-profile acceptance test for crafted joints

The acceptance test for a joint is a **per-column contact profile**, not a single gap number. Classify blade vs guard pixels in the colour-coded `render.png`; for every x-column across the blade's base measure the vertical distance from the blade's lowest pixel to the nearest guard pixel below it. Report the fraction of columns in contact (gap <= ~0.35 world) plus the median gap.

Healthy one-handers all look the same: **88-100% of columns in contact, median gap 0.11-0.15**. Measured on an arming sword being fixed: original 0% / 3.28, after a centre-only fix 15% / 1.75, after the correct fix 100% / 0.13.

**Why:** a centre measurement (or any single-point gap) passes a blade that touches only the guard's tallest central point while floating over the rest of its width, which is exactly what a player sees as "still not right". Calibrating against several known-good weapons turns "looks about right" into pass/fail; it is cheap (render each reference weapon, run the same profile).

**How to apply:** never call a joint fixed on JSON numbers or one cropped eyeball. Run the profile and quote it beside two or three reference swords.

Related: [[crafting-joint-gap-formula]], [[blade-mesh-origin-inflates-reach]]
