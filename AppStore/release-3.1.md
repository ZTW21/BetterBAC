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

Build 13 finished processing. With the user's explicit approval, saved “None of the algorithms mentioned above” for its export-compliance declaration. No encryption implementation changed.

With the user's explicit approval, uploaded four Duo listing screenshots: Home open/closed, Profile open, and details open. They use fictional QA records and occupy only the iPhone Duo screenshot slot. After the upload, verified that all five original `01-Pourtime.jpg` through `05-Pourtime.jpg` remain in order in the non-Duo slot as “Using Existing Assets.” No original screenshot was removed or replaced.

## Submitted October 15, 2026

Apple confirmed **1 Item Submitted**, then **Waiting for Review** for **3.1 (13)**. Submission ID: `864809b9-807e-4d60-be59-6bb16e882f69`.

[App Review submission](https://appstoreconnect.apple.com/apps/6504423512/distribution/reviewsubmissions/details/864809b9-807e-4d60-be59-6bb16e882f69). Confirmation and Waiting for Review screenshots are stored locally in ignored `AppStore/Build/submission-3.1-confirmed.jpg` and `AppStore/Build/submission-3.1-waiting-for-review.jpg`; account/submission images are not published to GitHub.

Automatic release after Apple's approval remains selected. Apple approval and public availability are not yet confirmed. No recurring monitoring was configured.

GitHub source sync completed on `main` with release commit `47d7bbd`. IPA SHA-256: `12120dcb68b7cf65bca588a7e7fda1ee24ccee71e36fe48dbe776ddf4203d20d`.
