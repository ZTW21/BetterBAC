import SwiftUI

struct DrinkLegendRow: View {
    let type: DrinkType
    let count: Int

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: AppTheme.icon(for: type))
                .foregroundStyle(AppTheme.color(for: type)).accessibilityHidden(true)
            Text(type.rawValue)
            Spacer(minLength: 12)
            Text(count, format: .number).bold().foregroundStyle(.secondary)
        }
        .font(.caption)
        .accessibilityElement(children: .combine)
    }
}
