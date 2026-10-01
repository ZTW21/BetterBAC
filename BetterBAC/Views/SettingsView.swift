import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject private var purchaseManager = PurchaseManager.shared
    @ObservedObject private var adConsent = AdConsentManager.shared
    @State private var name = ""
    @State private var showingSaveConfirmation = false
    @State private var showingPurchaseSuccess = false
    @State private var showingDeleteConfirmation = false
    @State private var showingMetricHelp = false

    var body: some View {
        Form {
            Section("Optional profile") {
                TextField("Name", text: $name).textContentType(.name)
                Button("Save Profile") { showingSaveConfirmation = viewModel.saveProfile(name: name) }
                if viewModel.profile != nil {
                    Button("Delete Profile", role: .destructive) { showingDeleteConfirmation = true }
                }
                if viewModel.profileImage != nil { Button("Remove Profile Photo", role: .destructive) { viewModel.removeProfilePicture() } }
            }
            if let error = viewModel.storageError { Section { Text(error).foregroundStyle(AppTheme.destructive) } }
            Section("About your log") {
                Button("How pace works") { showingMetricHelp = true }
                Text("Drink logs, your optional name, and your profile photo are stored locally. Pourtime does not send these records to the advertising SDK.")
                Text("Advertising may collect device identifiers, approximate location derived from your IP address, ad interactions, and diagnostics. Tracking permission is optional.")
                Link("Privacy Policy", destination: URL(string: "https://pourtime-privacy.wilsocs.chatgpt.site")!)
            }
            if adConsent.privacyOptionsRequired {
                Section("Advertising privacy") {
                    Button("Manage Advertising Privacy") { Task { await adConsent.showPrivacyOptions() } }
                }
            }
            if let error = adConsent.errorMessage {
                Section { Text(error).font(.caption).foregroundStyle(.secondary) }
            }
            Section("Remove Ads") {
                if purchaseManager.hasRemoveAdsPurchase {
                    Label("Ads Removed", systemImage: "checkmark.circle.fill").foregroundStyle(.green)
                } else {
                    Button {
                        Task {
                            await purchaseManager.purchase()
                            showingPurchaseSuccess = purchaseManager.hasRemoveAdsPurchase
                        }
                    } label: {
                        VStack(spacing: 2) {
                            Text("Remove Ads Forever").bold()
                            if let price = purchaseManager.displayPrice { Text(price).font(.caption).foregroundStyle(.secondary) }
                            else { Text("Loading price…").font(.caption) }
                        }.frame(maxWidth: .infinity)
                    }
                    .disabled(purchaseManager.isLoading || purchaseManager.displayPrice == nil)
                    Button("Redeem Offer Code") { Task { await purchaseManager.presentOfferCodeRedemption() } }
                        .disabled(purchaseManager.isLoading)
                }
                Button("Restore Purchases") { Task { await purchaseManager.restorePurchases() } }
                    .disabled(purchaseManager.isLoading)
                if let error = purchaseManager.purchaseError { Text(error).font(.caption).foregroundStyle(AppTheme.destructive) }
            }
        }
        .navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
        .task { name = viewModel.profile?.name ?? "" }
        .sheet(isPresented: $showingMetricHelp) { MetricHelpView() }
        .alert("Profile Saved", isPresented: $showingSaveConfirmation) { }
        .alert("Ads Removed", isPresented: $showingPurchaseSuccess) { } message: { Text("Thank you for your support!") }
        .confirmationDialog("Delete Optional Profile?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete Profile", role: .destructive) { viewModel.deleteProfile(); if viewModel.storageError == nil { name = "" } }
        } message: { Text("This removes your name and photo. Your drink logs and saved sessions remain available.") }
    }
}
