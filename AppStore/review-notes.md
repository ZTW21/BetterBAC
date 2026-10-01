# Pourtime 3.0 — App Review notes

This update addresses the unresolved guideline 1.4.0 issue on app 6504423512. ClearBAC has been redesigned as Pourtime, a timestamped drink journal. The shipped app no longer calculates BAC, applies Widmark/body-weight/metabolism formulas, predicts sober time, or indicates driving readiness.

Average pace = total logged US standard drinks / max(hours since first recorded drink, 5/60). A US standard drink is 14 grams of alcohol. The five-minute denominator floor is disclosed in “How pace works.” The graph plots this consumption-history rate and marks actual drink times. A declining rate describes elapsed time since logged intake, not alcohol leaving the body.

“Logged in past hour” includes entries with timestamps after now minus 60 minutes and at or before now. Zero means no entries in that history window. The interface does not interpret this as sobriety.

“End & Save” archives a log. A newly added chronological entry following an eight-hour gap archives the previous log at its last entry time. This is an organizational rule, not an alcohol-clearance estimate. Backdated edits do not trigger a split.

No account, hardware, body weight, or biological-sex information is required. Existing drink records migrate to the new format; legacy derived estimates are discarded. The existing Remove Ads purchase remains available under com.betterbac.removeads.

## Review steps

1. Accept the introduction and tap Add Drink. Log a 1.5 US fl oz, 40% ABV liquor entry with its consumption time one hour ago.
2. Add the same serving with its consumption time now. Observe the separate timestamps and graph markers.
3. Inspect “How pace works.” Wait a minute: average pace declines while total intake stays constant. A past-hour entry expires when its timestamp is exactly an hour old.
4. Tap a drink to edit its time or ABV; 0% is supported. Delete from the edit form or row context menu.
5. Tap End & Save and open Profile → Session History. Inspect the saved pacing graph and intake summary.
6. In Profile → Settings, inspect optional profile controls, advertising privacy (when required), purchase/restore controls, and privacy information.

Pace and intake calculations are visible to all users and reviewers. There are no remotely enabled or hidden BAC features.
