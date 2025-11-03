//
//  ProfileView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    @State private var selectedSex: SexAssignedAtBirth = .male
    @State private var weight: String = ""
    @State private var selectedWeightUnit: WeightUnit = .pounds
    @State private var showingSaveConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
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
                        HStack {
                            Text("Sex Assigend At Birth")
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
            }
            .navigationTitle("Profile")
            .onAppear(perform: loadCurrentProfile)
            .alert("Profile Saved", isPresented: $showingSaveConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your profile has been saved successfully.")
            }
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
            selectedSex = profile.sex
            weight = String(format: "%.1f", profile.weight)
            selectedWeightUnit = profile.weightUnit
        }
    }
    
    private func saveProfile() {
        guard let weightValue = Double(weight), weightValue > 0 else {
            return
        }
        
        viewModel.saveProfile(sex: selectedSex, weight: weightValue, weightUnit: selectedWeightUnit)
        showingSaveConfirmation = true
    }
    
    private func deleteProfile() {
        viewModel.deleteProfile()
        weight = ""
        selectedSex = .male
        selectedWeightUnit = .pounds
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}
