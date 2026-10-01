import SwiftUI

struct HomeView: View {
    @ObservedObject var sessionViewModel: SessionViewModel
    @ObservedObject private var purchaseManager = PurchaseManager.shared
    @ObservedObject private var adConsent = AdConsentManager.shared
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showingAddDrink = false
    @State private var showingClearConfirmation = false
    @State private var editingDrink: Drink?
    @State private var deletingDrink: Drink?
    @State private var showingDeleteConfirmation = false
    @State private var showingMetricHelp = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let error = sessionViewModel.storageError {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(error).foregroundStyle(AppTheme.destructive)
                            Button("Retry Loading") { sessionViewModel.reload() }
                        }
                        .padding(.horizontal)
                    }
                    SessionStatsGrid(metrics: sessionViewModel.metrics)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pace describes your logged consumption over time. It does not estimate BAC, impairment, or when you will be sober.")
                            .font(.caption).foregroundStyle(.secondary)
                        Button("How pace works", systemImage: "info.circle") { showingMetricHelp = true }
                            .font(.caption)
                    }
                    .padding(.horizontal)
                    Button("Add Drink", systemImage: "plus") { showingAddDrink = true }
                        .bold().frame(maxWidth: .infinity).padding(.vertical, 14)
                        .foregroundStyle(.white).background(AppTheme.accent)
                        .clipShape(.rect(cornerRadius: AppTheme.buttonRadius)).padding(.horizontal)
                        .disabled(sessionViewModel.storageError != nil)
                    if sessionViewModel.shouldShowHydrationNudge {
                        HydrationNudge {
                            withAnimation(reduceMotion ? nil : .easeOut) { sessionViewModel.dismissHydrationNudge() }
                        }
                    }
                    if !sessionViewModel.drinks.isEmpty {
                        SessionInsightsView(dataPoints: sessionViewModel.graphData, breakdown: sessionViewModel.drinkBreakdown)
                        Button("End & Save", systemImage: "checkmark.circle") { sessionViewModel.endSession() }
                            .buttonStyle(.bordered).disabled(sessionViewModel.storageError != nil)
                    }
                    if adConsent.canShowAds && !purchaseManager.hasRemoveAdsPurchase { BannerAdView().frame(height: 50) }
                    drinksLog
                }
                .padding(.vertical)
            }
            .navigationTitle("Pourtime")
            .sheet(isPresented: $showingAddDrink) { AddDrinkView(viewModel: sessionViewModel) }
            .sheet(item: $editingDrink) { AddDrinkView(viewModel: sessionViewModel, drink: $0) }
            .sheet(isPresented: $showingMetricHelp) { MetricHelpView() }
            .confirmationDialog("Clear All Drinks?", isPresented: $showingClearConfirmation, titleVisibility: .visible) {
                Button("Clear All", role: .destructive) { sessionViewModel.clearAllDrinks() }
            } message: {
                Text("This discards your active log without saving it to history. Saved sessions remain available.")
            }
            .confirmationDialog("Delete This Drink?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete Drink", role: .destructive) {
                    if let drink = deletingDrink { sessionViewModel.deleteDrink(id: drink.id) }
                    deletingDrink = nil
                }
            }
        }
    }

    private var drinksLog: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Drinks Log").font(.headline)
                Spacer()
                if !sessionViewModel.drinks.isEmpty {
                    Button("Clear All", role: .destructive) { showingClearConfirmation = true }
                        .font(.subheadline).disabled(sessionViewModel.storageError != nil)
                }
            }.padding(.horizontal)
            if sessionViewModel.drinks.isEmpty {
                ContentUnavailableView("No drinks logged yet", systemImage: "wineglass")
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
                }
            }
        }
    }
}
