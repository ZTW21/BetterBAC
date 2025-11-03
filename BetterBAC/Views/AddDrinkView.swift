//
//  AddDrinkView.swift
//  BetterBAC
//
//  Created by Zack Wilson on 11/2/24.
//

import SwiftUI

struct AddDrinkView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: BACViewModel
    
    @State private var selectedType: DrinkType = .beer
    @State private var amountOz: String = ""
    @State private var abvPercent: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Drink Type")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(DrinkType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedType) { _, newValue in
                        updateDefaults(for: newValue)
                    }
                }
                
                Section(header: Text("Amount (oz)")) {
                    TextField("Amount in oz", text: $amountOz)
                        .keyboardType(.decimalPad)
                    
                    Text("Common: \(String(format: "%.1f", selectedType.defaultAmount)) oz")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Alcohol by Volume (%)")) {
                    TextField("ABV %", text: $abvPercent)
                        .keyboardType(.decimalPad)
                    
                    Text("Common: \(String(format: "%.1f", selectedType.defaultABV))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section {
                    Button(action: useDefaults) {
                        HStack {
                            Spacer()
                            Text("Use Common Values")
                            Spacer()
                        }
                    }
                }
                
                Section {
                    Button(action: saveDrink) {
                        HStack {
                            Spacer()
                            Text("Add Drink")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!isValidInput)
                }
            }
            .navigationTitle("Add Drink")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                updateDefaults(for: selectedType)
            }
        }
    }
    
    private var isValidInput: Bool {
        guard let amount = Double(amountOz), amount > 0,
              let abv = Double(abvPercent), abv > 0, abv <= 100 else {
            return false
        }
        return true
    }
    
    private func updateDefaults(for type: DrinkType) {
        if amountOz.isEmpty {
            amountOz = String(format: "%.1f", type.defaultAmount)
        }
        if abvPercent.isEmpty {
            abvPercent = String(format: "%.1f", type.defaultABV)
        }
    }
    
    private func useDefaults() {
        amountOz = String(format: "%.1f", selectedType.defaultAmount)
        abvPercent = String(format: "%.1f", selectedType.defaultABV)
    }
    
    private func saveDrink() {
        guard let amount = Double(amountOz), amount > 0,
              let abv = Double(abvPercent), abv > 0, abv <= 100 else {
            return
        }
        
        let drink = Drink(
            timestamp: Date(),
            type: selectedType,
            amountOz: amount,
            abvPercent: abv
        )
        
        viewModel.addDrink(drink)
        dismiss()
    }
}

#Preview {
    AddDrinkView(viewModel: BACViewModel(profileViewModel: ProfileViewModel()))
}
