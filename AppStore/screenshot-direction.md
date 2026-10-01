# Pourtime screenshot direction

Recommended template: [Minimal Food App Screenshots — iOS](https://appmockupstudio.com/t/minimal-food-app-ios) from App Mockup Studio. Inspected October 1, 2026. It provides five editable slides, with editable text, backgrounds, colors, screenshots, and device frames. No template purchase or subscription was made.

Use the simple upright device treatment, large readable headlines, pale gray/white backgrounds, and Pourtime's teal accent. Keep the app's actual interface visible and its pacing explanation readable. Remove all sample food-app text and imagery. Keep each slide independently understandable.

| Order | Headline | Supporting copy | Actual screen capture |
| --- | --- | --- | --- |
| 1 | See your pace change over time | Follow your logged intake as the session unfolds. | 01-Pourtime-Live-Pace.png |
| 2 | Log drinks when you had them | Choose the actual consumption time, even when you log later. | 02-Pourtime-Timestamp-Entry.png |
| 3 | Review your night, drink by drink | See recorded times, serving sizes, and ABV together. | 04-Pourtime-Session-Details.png |
| 4 | Save sessions for later | Keep your drink journal and review past sessions. | 03-Pourtime-Session-History.png |
| 5 | Understand what you logged | Clear definitions for pace and US standard drinks. | 05-Pourtime-Metric-Help.png |

The captures use fictitious records on an isolated iPhone 17 Pro Max simulator. They show real production views, with ads suppressed by a DEBUG-only QA flag. The routing flags and fixtures are excluded from release builds. They are source material for the renewed screenshot set, not the finished store assets.

Do not claim BAC accuracy, sobriety, alcohol clearance, impairment, legal limits, or driving readiness. The revised app's pace is a consumption-history rate. Do not change the graph into a physiological estimate or remove the in-app metric explanation from a shown screen.

Also compared: [Green Habit Tracker — iOS](https://appmockupstudio.com/t/green-habit-tracker-ios), with inset callouts but a busier background, and AppMockUp Studio's paid Tracking habits app ($9.97 at inspection) and free Food app layouts at [studio.app-mockup.com](https://studio.app-mockup.com/).

Final export must use Apple's accepted screenshot dimensions, replace the previous BAC screenshots, and include all populated sizes/localizations and custom product pages.

## Finished set — October 1, 2026

The final five posters are in `StoreScreenshots/`, in the order above, with slightly shortened headlines where appropriate. They use an independent native AppKit renderer (`render-store-screenshots.swift`) following this minimal direction; they were not exported from the third-party template. The captured interfaces are unchanged apart from whole-screen scaling and rounded frame corners. Every poster was inspected at full resolution and exported as 1320 × 2868 JPEG without alpha. Apple accepted them and they replace the six legacy screenshots for version 3.0, with smaller iPhone sizes inheriting the new set. The existing Remove Ads review attachment was also replaced with `Screenshots/06-Pourtime-Remove-Ads.png`, showing current Settings and the real localized StoreKit price.
