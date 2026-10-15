# Pourtime 3.1 — App Review notes

Pourtime is a timestamped drink journal. Version 3.1 adapts every screen to compact and regular widths for iPhone Duo, adds iPhone landscape support, improves large-text layouts, and fixes graph fill and custom-button hit areas. Home and Profile navigation and all logging actions remain available in both layouts. No account or additional hardware is required.

On the open display, Home shows pace and drink-breakdown charts alongside the active log; Profile shows profile/activity alongside session history; session details show summary/chart alongside drinks. The closed display keeps the chart pager before the log. Add Drink is in the native toolbar. Native sheets and dialogs adapt to folds; drafts remain in memory during layout changes. Accessibility text sizes use a single column.

The graph shading fix uses unstacked fill for intentional before/after samples at the same timestamp. It does not change calculations. No external API, persistence schema, purchase entitlement, privacy practice, or physiological calculation was added or changed. The minimum OS remains iOS 17.6; distribution remains iPhone only.

Pace describes logged consumption, not BAC, impairment, or when someone will be sober. Average pace is total logged US standard drinks divided by elapsed session hours, with the existing disclosed five-minute denominator floor. The existing Remove Ads purchase remains com.betterbac.removeads.

## Review steps

1. Accept the introduction, then use the plus toolbar action to add a drink. Select its actual consumption time; 0% ABV is supported.
2. Add a second entry. On Duo, open/close and rotate the device: inspect charts and log together on the open display and the chart pager before the log when closed.
3. Start adding or editing a drink, type an amount, then change pose. The draft remains without saving or dismissing.
4. Inspect the pace graph: the translucent teal fill stays below the line at each logged-drink event.
5. Tap a drink card to edit it. End & Save archives the session; Profile → Session History opens its details. Change pose while viewing the details.
6. Inspect Profile → Settings and How pace works. Large accessibility text uses a single column with wrapping labels. No sign-in is required.
