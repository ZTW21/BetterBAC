# Pourtime 3.0 release

## Completed October 1, 2026

- Implemented the timestamped drink journal, shared pacing/intake calculations, session saving and eight-hour organization rule, optional profile, and verified legacy migration.
- App record: 6504423512; bundle: com.ZackWilson.BetterBAC; existing non-consumable: com.betterbac.removeads.
- Preserved the existing iOS 17.6 deployment target and current interface styling.
- User created version 3.0. Saved name Pourtime and subtitle “Drink Log & Live Pacing”; retained Food & Drink / Lifestyle.
- Checked the full TestFlight history: the previous highest build was 10. Uploaded 3.0 build 11, then build 12 with accessibility fixes. Both builds processed and are Ready to Submit after their encryption questionnaires. Use build 12 for the revised release.
- Re-answered and saved age rating: frequent alcohol references and advertising, no medical-treatment advice, health/wellness content. Result 18+ (regional ratings can differ).
- Published the SDK-aligned seven-type privacy disclosure. Saved the new privacy policy URL in App Store Connect.
- Published public policy and support pages through the existing Sites project: https://pourtime-privacy.wilsocs.chatgpt.site and /support.html. Support uses the developer's public portfolio contact, clt@zackwilson.me.
- Confirmed Remove Ads is Approved, available in all selected countries/regions, and uses the existing product ID. Its display name and description contain no BAC claims.
- Prepared metadata.json and review-notes.md. Manual release is selected in the draft form.
- Captured five real production views with fictitious simulator records. Template recommendation and screenshot copy are in screenshot-direction.md. The previous store screenshots have not yet been replaced.
- 17 focused core tests passed. Debug simulator build, signed Release archive, App Store IPA export, and upload succeeded. Final IPA and archive are in ignored AppStore/Build/.
- Confirmed final release display name Pourtime, version 3.0, build 12, bundle identifier, deployment target, packaged privacy manifest, and absence of DEBUG-only QA flags.
- Checked iPhone SE (iOS 18.1) and iPhone 17 Pro Max (iOS 26.5) layouts. Largest Dynamic Type uses one-column metrics and stacked charts; chart time labels move into wrapping text. Verified accessible amount/ABV names and metric value/unit labels in runtime snapshots.

## Submitted October 1, 2026 at 12:52 PM EDT

- User saved the review contact and attached build 12. Corrected remaining ClearSip references, saved Pourtime metadata, review notes, public support URL, and manual release. Cleared the optional marketing URL to avoid linking an unrelated/legacy app page. Kept the user's 2026 copyright.
- Finished five 1320 × 2868 JPEG store posters in StoreScreenshots/. The independently rendered layout follows the recommended minimal direction; the App Mockup Studio editor was not used for the final export. Production screen captures remain unretouched inside the frames. Inspected every poster for clipping and accurate claims; verified dimensions and no alpha.
- Replaced the six legacy screenshot copies in the 3.0 draft. Ordered the new set: live pace, timestamp entry, session detail, history, metric explanation. All smaller iPhone sizes inherit this set. English (U.S.) is the only localized listing; all iPad sizes are empty and the app targets iPhone only. No custom product pages or optimization tests exist.
- Replaced the approved Remove Ads review screenshot with the current Settings view and saved updated reviewer notes. Verified both in a freshly loaded page; the product remains Approved. The DEBUG-only QA harness gained a Settings route to capture this production view. No Release code or uploaded build changed.
- Apple confirmed **1 Item Submitted**, then **Waiting for Review** for **3.0 (12)**. Submission ID: `586487a1-3435-437f-a723-54141e16ba88`. Evidence: submission-confirmed.jpg and waiting-for-review.jpg.
- Review: https://appstoreconnect.apple.com/apps/6504423512/distribution/reviewsubmissions/details/586487a1-3435-437f-a723-54141e16ba88

## Remaining validation and release work

- Verify purchase restoration and purchased-user advertising suppression on an authorized physical device. No purchase was made during this task.
- Verify AdMob account consent-message configuration and consent behavior in required regions. A US simulator reached the ATT prompt after UMP readiness; region-specific forms were not verified. Screenshot captures suppress advertising only in DEBUG builds.
- Verify actual VoiceOver navigation/gestures and chart exploration on a device; runtime semantic snapshots are not a complete screen-reader test. An iOS 17.6 simulator runtime was not installed, so the oldest runtime used was iOS 18.1.
- Apple must finish review. After approval, manually release version 3.0; no automatic release or recurring monitoring was configured.
- After Apple approval and release, verify the unresolved 1.4.0 removal issue and distribution availability are resolved. They remain unresolved before Apple's review.

GoogleMobileAds and UserMessagingPlatform vendor dSYMs were absent during upload, producing symbol-upload warnings. The app archive/export/upload succeeded; these warnings limit crash symbolication within those SDKs.

Apple approval and restored availability require external review and cannot be confirmed in advance.
