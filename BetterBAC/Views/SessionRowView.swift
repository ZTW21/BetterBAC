import SwiftUI

struct SessionRowView: View {
    let session: DrinkingSession
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(session.startTime, format: .dateTime.month().day().year()).font(.subheadline.bold())
                Spacer()
                Text("^[\(session.totalDrinks) drink](inflect: true)").font(.caption).foregroundStyle(.secondary)
            }
            Text("\(session.metrics.standardDrinks, specifier: "%.1f") US standard drinks · \(session.metrics.averagePace, specifier: "%.1f")/hr average")
                .font(.caption).foregroundStyle(.secondary)
            MiniGraphPreview(session: session).frame(height: 48)
        }
        .padding().background(.fill.quaternary).clipShape(.rect(cornerRadius: AppTheme.cardRadius)).padding(.horizontal)
    }
}
