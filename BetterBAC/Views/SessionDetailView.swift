import SwiftUI

struct SessionDetailView: View {
    let session: DrinkingSession
    @ObservedObject var viewModel: SessionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    LabeledContent("US standard drinks", value: session.metrics.standardDrinks.formatted(.number.precision(.fractionLength(1))))
                    LabeledContent("Average pace", value: "\(session.metrics.averagePace.formatted(.number.precision(.fractionLength(1)))) US std drinks/hr")
                    LabeledContent("Estimated calories", value: "\(session.metrics.estimatedCalories) kcal")
                    LabeledContent("Log duration", value: "\(Int(session.duration) / 3600)h \((Int(session.duration) % 3600) / 60)m")
                    Text("Calories are a rough estimate from alcohol and typical beverage carbohydrates; mixers vary.").font(.caption).foregroundStyle(.secondary)
                }
                .padding().background(.fill.quaternary).clipShape(.rect(cornerRadius: AppTheme.cardRadius)).padding(.horizontal)
                SessionGraphView(dataPoints: SessionMetricsCalculator.timeline(drinks: session.drinks, through: session.endTime))
                Text("Pace describes logged consumption, not BAC or impairment.").font(.caption).foregroundStyle(.secondary).padding(.horizontal)
                Text("Drinks Consumed").font(.headline)
                ForEach(session.drinks) { drink in DrinkRowView(drink: drink) }
                if let error = viewModel.storageError { Text(error).foregroundStyle(AppTheme.destructive).padding(.horizontal) }
            }.padding(.vertical)
        }
        .navigationTitle("Session Details").navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Delete", systemImage: "trash", role: .destructive) { showingDeleteConfirmation = true }
            }
        }
        .confirmationDialog("Delete Session?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { viewModel.deleteSession(id: session.id); if viewModel.storageError == nil { dismiss() } }
        } message: { Text("This permanently deletes this saved session.") }
        .task {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let controller = scene.windows.first(where: \.isKeyWindow)?.rootViewController {
                AdManager.shared.showInterstitialIfNeeded(from: controller)
            }
        }
    }
}
