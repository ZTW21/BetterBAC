import SwiftUI

struct SessionRowView: View {
    let session: DrinkingSession
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ViewThatFits(in: .horizontal) {
                HStack {
                    Text(session.startTime, format: .dateTime.month().day().year()).font(.subheadline.bold())
                        .fixedSize(horizontal: true, vertical: true)
                    Spacer(minLength: 12)
                    Text("^[\(session.totalDrinks) drink](inflect: true)").font(.caption).foregroundStyle(.secondary)
                        .fixedSize(horizontal: true, vertical: true)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.startTime, format: .dateTime.month().day().year()).font(.subheadline.bold())
                    Text("^[\(session.totalDrinks) drink](inflect: true)").font(.caption).foregroundStyle(.secondary)
                }
            }
            Text("\(session.metrics.standardDrinks, specifier: "%.1f") US standard drinks · \(session.metrics.averagePace, specifier: "%.1f")/hr average")
                .font(.caption).foregroundStyle(.secondary)
            MiniGraphPreview(session: session).frame(height: 48)
        }
        .padding().background(.fill.quaternary).clipShape(.rect(cornerRadius: AppTheme.cardRadius))
        .contentShape(.rect(cornerRadius: AppTheme.cardRadius))
    }
}
