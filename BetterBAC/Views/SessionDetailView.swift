import SwiftUI

struct SessionDetailView: View {
    let session: DrinkingSession
    @ObservedObject var viewModel: SessionViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var showingDeleteConfirmation = false
    @State private var consideredInterstitial = false
    @State private var scrollAnchor: String?

    var body: some View {
        ScrollView {
            AdaptiveColumnsLayout(expanded: AppLayout(sizeClass: sizeClass, typeSize: typeSize).usesColumns, layoutDirection: layoutDirection) {
                VStack(spacing: AppLayout.sectionSpacing) {
                    SessionSummaryView(session: session).id("details.summary")
                    SessionGraphView(dataPoints: SessionMetricsCalculator.timeline(drinks: session.drinks, through: session.endTime))
                        .id("details.chart")
                    Text("Pace describes logged consumption, not BAC or impairment.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                .scrollTargetLayout()
                .accessibilityElement(children: .contain)
                .frame(maxWidth: .infinity)
                LazyVStack(alignment: .leading, spacing: 12) {
                    Text("Drinks Consumed").font(.headline).id("details.drinks")
                    ForEach(session.drinks) { drink in
                        DrinkRowView(drink: drink).id("details.drink.\(drink.id)")
                    }
                    if let error = viewModel.storageError { Text(error).foregroundStyle(AppTheme.destructive) }
                }
                .scrollTargetLayout()
                .accessibilityElement(children: .contain)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(AppLayout.contentMargin)
            .frame(maxWidth: AppLayout.dashboardWidth)
            .frame(maxWidth: .infinity)
        }
        .scrollPosition(id: $scrollAnchor, anchor: .top)
        .navigationTitle("Session Details").navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Delete", systemImage: "trash", role: .destructive) { showingDeleteConfirmation = true }
                    .confirmationDialog("Delete Session?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                        Button("Delete", role: .destructive, action: deleteSession)
                    } message: { Text("This permanently deletes this saved session.") }
            }
        }
        .task {
            // A presentation is counted once, even if the system restarts the task while resizing.
            guard !consideredInterstitial else { return }
            consideredInterstitial = true
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let controller = scene.windows.first(where: \.isKeyWindow)?.rootViewController {
                AdManager.shared.showInterstitialIfNeeded(from: controller)
            }
        }
    }

    private func deleteSession() {
        viewModel.deleteSession(id: session.id)
        if viewModel.storageError == nil { dismiss() }
    }
}
