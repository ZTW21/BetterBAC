# Pourtime

An iOS drink journal with timestamped entries, live average drinking pace, and past-hour intake. It describes consumption history and does not estimate BAC, impairment, or sober time.

- Average pace: US standard drinks / elapsed hours since the first entry, using a disclosed five-minute minimum.
- Past-hour intake: entries in (now − 60 minutes, now]. One US standard drink = 14 g alcohol.
- Active entries support consumption-time editing, deletion, custom volume/ABV, and 0% ABV.
- End & Save archives a session. A next chronological entry after an eight-hour gap starts another log; this is organizational only.
- Optional name/photo, locally stored records, migration of legacy drink history, and the existing Remove Ads entitlement.

Open BetterBAC.xcodeproj to build the iOS app (deployment target iOS 17.6). The product/bundle identifier remains unchanged for existing users.

Run core regression tests with `swift test --scratch-path /tmp/PourtimeCoreTests`. These compile the same calculation, persistence, and session-management sources as the iOS app; they use isolated UserDefaults suites.

App Store metadata, review notes, privacy audit, policy source, and remaining release requirements are in AppStore/. Google Mobile Ads and its existing UMP dependency handle advertising consent; SDK setup in the AdMob account and physical-device StoreKit testing must be verified before submission.
