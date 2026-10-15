import SwiftUI

struct DrinkRowView: View {
    let drink: Drink
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: AppTheme.icon(for: drink.type)).font(.title3)
                .foregroundStyle(AppTheme.accent).frame(width: 28).accessibilityHidden(true)
            ViewThatFits(in: .horizontal) {
                if !typeSize.isAccessibilitySize {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) { title; time }
                            .fixedSize(horizontal: true, vertical: true)
                        Spacer(minLength: 0)
                        details.fixedSize(horizontal: true, vertical: true)
                    }
                }
                VStack(alignment: .leading, spacing: 6) {
                    title
                    time
                    details
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding().background(.fill.quaternary).clipShape(.rect(cornerRadius: AppTheme.cardRadius))
        .contentShape(.rect(cornerRadius: AppTheme.cardRadius))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(drink.type.rawValue), \(drink.amountOz.formatted()) US fluid ounces, \(drink.abvPercent.formatted()) percent ABV, consumed \(drink.timestamp.formatted(date: .abbreviated, time: .shortened))")
    }

    private var title: some View { Text(drink.type.rawValue).font(.subheadline.bold()) }
    private var time: some View {
        Text(drink.timestamp, format: Calendar.current.isDateInToday(drink.timestamp) ? .dateTime.hour().minute() : .dateTime.month().day().hour().minute())
            .font(.caption).foregroundStyle(.secondary)
    }
    private var details: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) { amount; abv }.fixedSize(horizontal: true, vertical: true)
            VStack(alignment: .leading, spacing: 4) { amount; abv }
        }
    }
    private var amount: some View { Text("\(drink.amountOz, specifier: "%.1f") oz").font(.subheadline).foregroundStyle(.secondary) }
    private var abv: some View { Text("\(drink.abvPercent, specifier: "%.1f")% ABV").font(.caption).foregroundStyle(.secondary) }
}
