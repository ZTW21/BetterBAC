# Adaptive layout validation

Checked October 14, 2026. Implementation is in place; the remaining interaction checks below still need manual verification before release sign-off.

## Design and behavior

Compact Home retains summary → chart pager → log. Regular Home shows summary above equal-width insights and log columns. Profile places profile/activity alongside history; saved-session details place summary/chart alongside drinks. Accessibility Dynamic Type uses one column. Metrics use four columns only when their measured content fits, otherwise two; accessibility sizes use one.

Navigation, view models, sheets, confirmation state, and drafts remain above layout changes. Stable scroll targets identify sections and records. The Add Drink action is a native labeled plus toolbar item with high visibility priority on iOS 27; older systems use the primary toolbar action. Native presentation handles the side controls and fold avoidance. There are no device-name, screen-size, or hinge checks.

The graph fix disables AreaMark stacking and draws the fill before the line. The timeline intentionally contains before/after samples at identical drink timestamps. Default stacking added those values and caused the false teal spikes; unstacked fill follows the same samples as the line. Calculation and persistence sources are unchanged.

These choices follow Apple's [design guidance](https://developer.apple.com/videos/play/tech-talks/111466/) and [preparation guide](https://developer.apple.com/iphone-duo/prepare/).

## Tooling and builds

Installed Xcode 27.1 RC (27A9275) and the iOS 27.1 runtime through Xcodes after account access was restored. The system-selected Xcode remains 27.0. Build this source using the newer toolchain explicitly:

```sh
DEVELOPER_DIR=/Applications/Xcode-27.1.0-Release.Candidate.app/Contents/Developer \
xcodebuild -project BetterBAC.xcodeproj -scheme BetterBAC \
  -configuration Debug -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone Duo' \
  -derivedDataPath /tmp/PourtimeDuoBuild CODE_SIGNING_ALLOWED=NO build
```

Both final Debug and Release simulator builds passed. Only the informational App Intents metadata warning appeared. Release Info.plist confirms minimum OS 17.6, iPhone device family only, portrait, and both landscape orientations. Release binary inspection confirms that the new QA hosts and fixture/layout arguments are absent. `git diff --check` and project plist validation passed.

All 17 core Swift package regression tests passed using isolated defaults:

```sh
CLANG_MODULE_CACHE_PATH=/tmp/PourtimeAdaptiveClangCache \
SWIFTPM_MODULECACHE_OVERRIDE=/tmp/PourtimeAdaptiveModuleCache \
swift test --disable-sandbox --scratch-path /tmp/PourtimeAdaptiveCoreTests
```

## DEBUG harness

Launch with `--qa-screen home --qa-fixture populated --qa-no-ads`. Routes: home, profile, details, add, edit, settings, metrics, welcome, insights. Fixtures: empty, populated, long (40 active entries and 20 saved sessions), single, simultaneous, zero. Explicit fixtures use the separate `com.pourtime.AdaptiveLayoutQA` defaults suite; launches reseed that suite. Omit fixture only when intentionally using the existing journal. All validation launches here used explicit fixtures and suppressed ads.

Optional arguments: `--qa-layout compact|regular|resizable`, `--qa-type accessibility`, `--qa-appearance dark`. The resizable harness retains its content while switching compact/expanded and largest text. Its illustrative dimensions are not device specifications. DEBUG previews include compact, expanded, empty, and long-log/largest-text states. Production remains iPhone only; an iPad simulator build override was used solely to exercise this harness.

## Completed checks

| Check | Observed result |
| --- | --- |
| Native Duo closed/open, partial fold, and rotation | Native controls remain in safe areas; compact pager and expanded columns appear. Portrait and landscape were exercised. |
| Home, Profile, saved-session details | Correct content order and columns. Selecting a session, folding, and returning retains detail navigation and selected Profile tab. |
| Add/edit, settings, help, welcome | Native forms and readable content widths; date controls, keyboard, and toolbar actions remain available. |
| Drink draft through repeated poses | Typed 16.5 remained through closing, opening, partial fold, and keyboard changes. After Save, isolated storage had five drinks with exactly one 16.5 entry (four initial fixtures). |
| Profile-name draft | Unsaved name remained through closing/opening with keyboard visible. |
| Confirmation presentation | Clear All remained presented across a fold. No destructive action was taken. |
| Compact chart selection | Second page survived compact/expanded/compact switching in the live resize harness. |
| Largest Dynamic Type | Layout stacks; session summary labels move above values; drink rows and legends wrap. Native details were reviewed open and closed. |
| Accessibility metadata | Native tree exposes each summary metric independently, then elapsed time; drink rows include type, volume, ABV, and timestamp. Charts and actions have labels. |
| Reduce Motion | Enabled native simulator override; hydration dismissal completed without the explicit ease-out animation. Override restored afterward. |
| Ordinary phones | Final visual checks on small iOS 18.1 phone and iPhone 17 Pro Max/iOS 26.5. Small-phone largest text/dark long-log and chart states, and large-phone empty state captured. Earlier default-phone build/run and keyboard/rotation checks also passed. |
| Graph regression | Populated, saved session, long log, simultaneous timestamps, single exact sample, and zero ABV visually reviewed. Fill stays beneath the line. |

## Remaining manual release checks

Follow-up hit-area fix: custom button sizing now lives inside the label, and drink/session cards, the profile-photo picker, and the purchase label have explicit content shapes. Welcome, hydration dismiss, help, retry, Clear All, and End & Save include their padded areas in the hit target. The updated Debug simulator build passed and the welcome action was smoke-tested through the native accessibility control. Coordinate-based edge-tap validation remains limited by the Device Hub automation bridge.

- End-to-end VoiceOver focus traversal in both poses. The native accessibility tree was inspected, but the system's first-use VoiceOver tutorial was not exposed through Device Hub's automation tree, preventing a reliable spoken-navigation pass.
- Exact long-log scroll restoration after repeated folding. Stable anchors are implemented, but Device Hub wheel/drag forwarding failed (`noWindowsAvailable` or unchanged content), so this interaction is not signed off.
- Native two-app split view, vertically reduced app space, and overflow under competing system controls/Live Activities. Size-class harness coverage does not replace those system scenarios.
- Ads were suppressed during QA. The detail presentation now guards interstitial consideration once per presentation, but live interstitial behavior and banner rendering still need an ad-enabled device pass. Purchase behavior was not changed.
- Physical Duo hardware and a final pass with the shipping Xcode/runtime release when available. The native checks here used the 27.1 release candidate simulator.

## Screenshot review

All images use fictional QA records. They are validation captures, not App Store marketing screenshots. Open captures use native inner display ID 3; closed captures use outer display ID 1. Matching content can show different amounts because the safe content area differs.

| Screen | Closed | Open |
| --- | --- | --- |
| Home | [Closed](home-closed.png) | [Open](home-open.png) |
| Profile | [Closed](profile-closed.png) | [Open](profile-open.png) |
| Session details | [Closed](details-closed.png) | [Open](details-open.png) |
| Edit drink | [Closed](edit-closed.png) | [Open](edit-open.png) |
| Settings | [Closed](settings-closed.png) | [Open](settings-open.png) |
| Metric help | [Closed](metrics-closed.png) | [Open](metrics-open.png) |
| Welcome | [Closed](welcome-closed.png) | [Open](welcome-open.png) |

Additional evidence: [draft closed](drink-draft-closed.png), [draft partially folded](drink-draft-partial.png), [largest-text details](details-accessibility-closed.png), [long log](home-long-open.png), [simultaneous events](graph-simultaneous-open.png), [zero ABV](graph-zero-open.png), [single sample](graph-single-open.png), [small dark largest-text Home](small-dark-accessibility-long.png), [small dark largest-text chart](small-dark-accessibility-charts.png), [large-phone empty state](large-empty.png).
