import SwiftUI

struct HomeView: View {
    @ObservedObject var sessionViewModel: SessionViewModel
    @ObservedObject private var purchaseManager = PurchaseManager.shared
    @ObservedObject private var adConsent = AdConsentManager.shared
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var showingAddDrink = false
    @State private var showingClearConfirmation = false
    @State private var editingDrink: Drink?
    @State private var deletingDrink: Drink?
    @State private var showingDeleteConfirmation = false
    @State private var showingMetricHelp = false
    @State private var scrollAnchor: String?

    private var layout: AppLayout { AppLayout(sizeClass: sizeClass, typeSize: typeSize) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppLayout.sectionSpacing) {
                    if let error = sessionViewModel.storageError {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(error).foregroundStyle(AppTheme.destructive)
                            Button { sessionViewModel.reload() } label: {
                                Text("Retry Loading").frame(minHeight: 44).contentShape(Rectangle())
                            }
                        }
                    }
                    SessionStatsGrid(metrics: sessionViewModel.metrics).id("home.summary")
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pace describes your logged consumption over time. It does not estimate BAC, impairment, or when you will be sober.")
                            .font(.caption).foregroundStyle(.secondary)
                        Button { showingMetricHelp = true } label: {
                            Label("How pace works", systemImage: "info.circle")
                                .frame(minHeight: 44).contentShape(Rectangle())
                        }
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .id("home.explanation")
                    if sessionViewModel.shouldShowHydrationNudge {
                        HydrationNudge(action: dismissHydrationNudge).id("home.hydration")
                    }
                    AdaptiveColumnsLayout(expanded: layout.usesColumns && !sessionViewModel.drinks.isEmpty, footerIndex: 1, layoutDirection: layoutDirection) {
                        VStack(spacing: AppLayout.sectionSpacing) {
                            if !sessionViewModel.drinks.isEmpty {
                                SessionInsightsView(dataPoints: sessionViewModel.graphData, breakdown: sessionViewModel.drinkBreakdown)
                                Button { sessionViewModel.endSession() } label: {
                                    Label("End & Save", systemImage: "checkmark.circle")
                                        .frame(minHeight: 44).contentShape(Rectangle())
                                }
                                    .buttonStyle(.bordered)
                                    .disabled(sessionViewModel.storageError != nil)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .accessibilityElement(children: .contain)
                        .id("home.insights")
                        HomeBannerView(isVisible: adConsent.canShowAds && !purchaseManager.hasRemoveAdsPurchase)
                        drinksLog
                    }
                }
                .scrollTargetLayout()
                .padding(AppLayout.contentMargin)
                .frame(maxWidth: AppLayout.dashboardWidth)
                .frame(maxWidth: .infinity)
            }
            .scrollPosition(id: $scrollAnchor, anchor: .top)
            .navigationTitle("Pourtime")
            .toolbar { addDrinkToolbar }
            .sheet(isPresented: $showingAddDrink) { AddDrinkView(viewModel: sessionViewModel) }
            .sheet(item: $editingDrink) { AddDrinkView(viewModel: sessionViewModel, drink: $0) }
            .sheet(isPresented: $showingMetricHelp) { MetricHelpView() }
            .confirmationDialog("Delete This Drink?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete Drink", role: .destructive, action: deleteSelectedDrink)
            }
        }
    }

    @ToolbarContentBuilder
    private var addDrinkToolbar: some ToolbarContent {
        if #available(iOS 27.0, *) {
            ToolbarItem(placement: .topBarPinnedTrailing) {
                Button("Add Drink", systemImage: "plus") { showingAddDrink = true }
                    .disabled(sessionViewModel.storageError != nil)
            }
            .visibilityPriority(.high)
        } else {
            ToolbarItem(placement: .primaryAction) {
                Button("Add Drink", systemImage: "plus") { showingAddDrink = true }
                    .disabled(sessionViewModel.storageError != nil)
            }
        }
    }

    private var drinksLog: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Drinks Log").font(.headline)
                Spacer()
                if !sessionViewModel.drinks.isEmpty {
                    Button(role: .destructive) { showingClearConfirmation = true } label: {
                        Text("Clear All").frame(minHeight: 44).contentShape(Rectangle())
                    }
                        .font(.subheadline)
                        .disabled(sessionViewModel.storageError != nil)
                        .confirmationDialog("Clear All Drinks?", isPresented: $showingClearConfirmation, titleVisibility: .visible) {
                            Button("Clear All", role: .destructive) { sessionViewModel.clearAllDrinks() }
                        } message: {
                            Text("This discards your active log without saving it to history. Saved sessions remain available.")
                        }
                }
            }
            .id("home.log")
            if sessionViewModel.drinks.isEmpty {
                ContentUnavailableView("No drinks logged yet", systemImage: "wineglass",
                                       description: Text("Use Add Drink to start your log."))
                    .id("home.empty")
            } else {
                ForEach(sessionViewModel.drinks.reversed()) { drink in
                    Button { editingDrink = drink } label: { DrinkRowView(drink: drink) }
                        .buttonStyle(.plain)
                        .accessibilityHint("Edit this drink or its consumption time")
                        .contextMenu {
                            Button("Edit Drink", systemImage: "pencil") { editingDrink = drink }
                            Button("Delete Drink", systemImage: "trash", role: .destructive) {
                                deletingDrink = drink
                                showingDeleteConfirmation = true
                            }
                        }
                        .disabled(sessionViewModel.storageError != nil)
                        .id("home.drink.\(drink.id)")
                }
            }
        }
        .scrollTargetLayout()
        .accessibilityElement(children: .contain)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private func dismissHydrationNudge() {
        withAnimation(reduceMotion ? nil : .easeOut) { sessionViewModel.dismissHydrationNudge() }
    }

    private func deleteSelectedDrink() {
        if let drink = deletingDrink { sessionViewModel.deleteDrink(id: drink.id) }
        deletingDrink = nil
    }
}
