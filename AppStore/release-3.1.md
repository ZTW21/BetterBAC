# Pourtime 3.1 (13)

Prepared October 15, 2026 for existing app 6504423512 and bundle com.ZackWilson.BetterBAC.

## Changes

- Compact/regular layouts across Home, Profile, session details, forms, help, settings, and welcome; native Add Drink toolbar action; iPhone landscape support.
- Large-text single-column layouts, wrapping labels/rows/legends, independent metric accessibility values, and Reduce Motion handling.
- Unstacked chart area prevents false teal spikes at duplicate-time drink events.
- Custom button labels own their padded hit areas; drink/session cards and photo/purchase labels use explicit content shapes.
- DEBUG-only isolated fixtures, resize harness, and native Duo screenshot evidence. No changes to calculations, storage schema, external APIs, privacy practices, or purchase entitlements.

## Validation and artifact

All 17 core tests passed on October 15. Signed Release archive and App Store IPA export passed with Xcode 27.1 RC (27A9275), iOS 27.1 SDK, and team 3ZWQ27S93Y. Verified version 3.1, build 13, minimum OS 17.6, iPhone-only device family, portrait and both landscapes, packaged privacy manifest, and absence of DEBUG-only routing/fixture/ad-suppression code.

Ignored local artifacts: `AppStore/Build/Pourtime-3.1-13.xcarchive` and `AppStore/Build/3.1-13/BetterBAC.ipa`. Upload succeeded. Vendor dSYMs for GoogleMobileAds and UserMessagingPlatform were unavailable; symbol warnings did not block upload.

See [adaptive-layout validation](QA/Duo/Validation.md) for simulator evidence and remaining manual checks. Those checks were not represented as completed during submission preparation.

## App Store Connect

Version 3.0 was Ready for Distribution. Created 3.1, saved What's New and reviewer instructions, retained the description/contact/privacy/purchase settings and five inherited iPhone screenshots. Automatic release after approval was already selected and is retained; ratings are retained and phased release is off.

Build 13 is uploaded; review submission status will be recorded below after App Store Connect processing and submission.
