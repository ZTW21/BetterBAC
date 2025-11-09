//
//  SettingsView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject private var purchaseManager = PurchaseManager.shared
    
    @State private var name: String = ""
    @State private var selectedSex: SexAssignedAtBirth = .male
    @State private var weight: String = ""
    @State private var selectedWeightUnit: WeightUnit = .pounds
    @State private var showingSaveConfirmation = false
    @State private var showingPurchaseSuccess = false
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Name", text: $name)
                    .textContentType(.name)
            }
            
            Section(header: Text("Sex Assigned At Birth")) {
                Picker("Sex Assigned At Birth", selection: $selectedSex) {
                    ForEach(SexAssignedAtBirth.allCases, id: \.self) { sex in
                        Text(sex.rawValue).tag(sex)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section(header: Text("Weight")) {
                HStack {
                    TextField("Enter weight", text: $weight)
                        .keyboardType(.decimalPad)
                    
                    Picker("Unit", selection: $selectedWeightUnit) {
                        ForEach(WeightUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 120)
                }
            }
            
            Section {
                Button(action: saveProfile) {
                    HStack {
                        Spacer()
                        Text("Save Profile")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(!isValidInput)
                
                if viewModel.hasProfile {
                    Button(role: .destructive, action: deleteProfile) {
                        HStack {
                            Spacer()
                            Text("Delete Profile")
                            Spacer()
                        }
                    }
                }
            }
            
            if viewModel.hasProfile, let profile = viewModel.profile {
                Section(header: Text("Current Profile")) {
                    if let profileName = profile.name, !profileName.isEmpty {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(profileName)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Sex Assigned At Birth")
                        Spacer()
                        Text(profile.sex.rawValue)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Weight")
                        Spacer()
                        Text("\(String(format: "%.1f", profile.weight)) \(profile.weightUnit.rawValue)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section(header: Text("Remove Ads")) {
                if purchaseManager.hasRemoveAdsPurchase {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Ads Removed")
                            .fontWeight(.semibold)
                    }
                } else {
                    Button(action: {
                        Task {
                            await purchaseManager.purchase()
                            if purchaseManager.hasRemoveAdsPurchase {
                                showingPurchaseSuccess = true
                            }
                        }
                    }) {
                        HStack {
                            Spacer()
                            if purchaseManager.isLoading {
                                ProgressView()
                                    .padding(.trailing, 8)
                            }
                            VStack(spacing: 4) {
                                Text("Remove Ads Forever")
                                    .fontWeight(.semibold)
                                Text("$4.99")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                    .disabled(purchaseManager.isLoading)
                    
                    Button("Redeem Offer Code") {
                        Task {
                            await purchaseManager.presentOfferCodeRedemption()
                        }
                        
                    }
                    .disabled(purchaseManager.isLoading)
                }
                
                Button("Restore Purchases") {
                    Task {
                        await purchaseManager.restorePurchases()
                    }
                }
                .disabled(purchaseManager.isLoading)
                
                if let error = purchaseManager.purchaseError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadCurrentProfile)
        .alert("Profile Saved", isPresented: $showingSaveConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your profile has been saved successfully.")
        }
        .alert("Success!", isPresented: $showingPurchaseSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Ads have been removed! Thank you for your support.")
        }
    }
    
    private var isValidInput: Bool {
        guard let weightValue = Double(weight), weightValue > 0 else {
            return false
        }
        return true
    }
    
    private func loadCurrentProfile() {
        if let profile = viewModel.profile {
            name = profile.name ?? ""
            selectedSex = profile.sex
            weight = String(format: "%.1f", profile.weight)
            selectedWeightUnit = profile.weightUnit
        }
    }
    
    private func saveProfile() {
        guard let weightValue = Double(weight), weightValue > 0 else {
            return
        }
        
        let profileName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.saveProfile(
            name: profileName.isEmpty ? nil : profileName,
            sex: selectedSex,
            weight: weightValue,
            weightUnit: selectedWeightUnit
        )
        showingSaveConfirmation = true
    }
    
    private func deleteProfile() {
        viewModel.deleteProfile()
        name = ""
        weight = ""
        selectedSex = .male
        selectedWeightUnit = .pounds
    }
}

#Preview {
    NavigationView {
        SettingsView(viewModel: ProfileViewModel())
    }
}
