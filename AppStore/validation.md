# Validation evidence

Core tests: `swift test --scratch-path /tmp/ClearSipCoreTests` — 17 passed, 0 failures (October 1, 2026). Sources are shared with the iOS target. Coverage includes exact past-hour boundaries, five-minute floor, spaced versus simultaneous drinks, rising/falling pace, 14-gram units, 0% ABV, empty/short sessions, future/invalid input, localized numeric input, graph jumps and bounded sampling, edit/delete/discard, End & Save, eight-hour splitting/backdating, suspension/relaunch, verified migration, and corrupt/future-schema preservation.

Final archive: AppStore/Build/Pourtime-3.0-12.xcarchive. IPA: AppStore/Build/3.0-12/BetterBAC.ipa. Signing/export/upload used the configured Apple team 3ZWQ27S93Y. SDK framework dSYM warnings did not block upload.

Simulator captures in QA/ document default and largest Dynamic Type on iPhone SE (iOS 18.1). Screenshots/ contains five real views on iPhone 17 Pro Max (iOS 26.5), with fictitious data and DEBUG-only ad suppression. Numeric fields expose “Amount, in US fluid ounces” and “Alcohol by volume, percent.” The final release binary contains no QA routing or ad-suppression flags.

The code/store-copy audit found no physiological calculation or driving-readiness indicators. Remaining BAC references explain that estimates have been removed or are unsupported; the legacy `peakBAC` decoding key marks migration and its numeric value is never read or re-encoded. The existing bundle and purchase identifiers and persistence key remain for continuity.

The app adds no cryptographic implementation. The technical export-compliance choice follows Apple's [platform-encryption guidance](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations) and the Google Mobile Ads SDK team's [HTTPS description](https://groups.google.com/g/google-admob-ads-sdk/c/vWQhDgpUH8g); it is an inference about the linked app/services, not a claim that HTTPS is unencrypted.

See release-checklist.md for remaining physical-device, regional-consent, and external-review checks. No real purchase, live user-record migration, or device-wide data deletion was performed.

Submission follow-through (October 1, 2026): all five finished store posters were inspected, verified as 1320 × 2868 JPEG with no alpha, uploaded, and ordered in App Store Connect. All smaller iPhone sizes inherit the new set. The current production Settings view loaded the real StoreKit product and localized $4.99 price in the isolated simulator; no purchase or restore was performed. A DEBUG-only Settings route was added and its simulator build succeeded. The IAP review screenshot and notes were saved and verified in a fresh page. The uploaded Release build remains 3.0 (12), unchanged. Apple confirmed submission and Waiting for Review with submission ID 586487a1-3435-437f-a723-54141e16ba88. Physical-device and regional-consent checks remain unverified.
