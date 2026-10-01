import SwiftUI

struct DrinkRowView: View {
    let drink: Drink
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: AppTheme.icon(for: drink.type)).font(.title3)
                .foregroundStyle(AppTheme.accent).frame(width: 28).accessibilityHidden(true)
            if typeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: 6) { title; time; details }
            } else {
                VStack(alignment: .leading, spacing: 2) { title; time }
                Spacer(minLength: 4)
                details
            }
        }
        .padding().background(.fill.quaternary).clipShape(.rect(cornerRadius: AppTheme.cardRadius)).padding(.horizontal)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(drink.type.rawValue), \(drink.amountOz.formatted()) US fluid ounces, \(drink.abvPercent.formatted()) percent ABV, consumed \(drink.timestamp.formatted(date: .abbreviated, time: .shortened))")
    }

    private var title: some View { Text(drink.type.rawValue).font(.subheadline.bold()) }
    private var time: some View {
        Text(drink.timestamp, format: Calendar.current.isDateInToday(drink.timestamp) ? .dateTime.hour().minute() : .dateTime.month().day().hour().minute())
            .font(.caption).foregroundStyle(.secondary)
    }
    private var details: some View {
        HStack(spacing: 8) {
            Text("\(drink.amountOz, specifier: "%.1f") oz").font(.subheadline).foregroundStyle(.secondary)
            Text("\(drink.abvPercent, specifier: "%.1f")% ABV").font(.caption).foregroundStyle(.secondary)
        }
    }
}
