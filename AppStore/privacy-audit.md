# Privacy audit — Pourtime 3.0

Audited the installed Google Mobile Ads 12.12.0 privacy manifest and its existing User Messaging Platform dependency. Sources:
- https://developers.google.com/admob/ios/privacy/data-disclosure
- https://developers.google.com/admob/ios/privacy

## First-party records
Drink times, beverage type, volume, ABV, optional name and profile image remain in a local UserDefaults data envelope. No app networking path sends these records to Google. Weight and biological-sex inputs have been removed; successful migration removes the legacy profile and derived session fields. Apple's device backups may include local app data. Device Photos selection uses PhotosPicker.

The app privacy manifest declares UserDefaults access using reason CA92.1. SDK privacy manifests are bundled separately in the release archive.

## SDK disclosures to reconcile in App Store Connect

The current published label contains only Advertising Data. The installed SDK manifest declares:

| Data type | Linked to identity | Tracking | Purposes declared by SDK |
| --- | --- | --- | --- |
| Coarse location | Yes | No | Third-party advertising, developer advertising, analytics |
| Device ID | Yes | Yes | Third-party advertising, developer advertising, analytics |
| Advertising data | Yes | No | Third-party advertising, developer advertising, analytics |
| Product interaction | Yes | No | Third-party advertising, developer advertising, analytics |
| Crash data | No | No | Analytics |
| Performance data | No | No | Third-party advertising, developer advertising, analytics |
| Other diagnostic data | No | No | Third-party advertising, developer advertising, analytics |

Use this installed-manifest mapping as the baseline; confirm any AdMob optional features or account-level settings before publishing disclosures. This code has no mediation adapters or custom targeting based on drink/profile data.

Consent information is refreshed each launch. Required UMP forms and ATT complete before Google Mobile Ads initializes. Ad requests require canRequestAds. Advertising privacy options appear in Settings when required. When consent is unavailable or the refresh fails without usable prior consent, no ads are initialized. Remove Ads entitlement is checked before SDK initialization.

AdMob Privacy & messaging forms must be configured in the owner's AdMob account for the territories served. This configuration cannot be confirmed from the project alone. Actual purchase, regional-consent, and ATT device testing must be recorded before submission.
