import SwiftUI

struct AddDrinkView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SessionViewModel
    private let existingDrink: Drink?
    @State private var selectedType: DrinkType
    @State private var amountText: String
    @State private var abvText: String
    @State private var consumptionTime: Date
    @State private var showingDeleteConfirmation = false

    init(viewModel: SessionViewModel, drink: Drink? = nil) {
        self.viewModel = viewModel
        existingDrink = drink
        _selectedType = State(initialValue: drink?.type ?? .beer)
        _amountText = State(initialValue: Self.inputText(drink?.amountOz ?? DrinkType.beer.defaultAmount))
        _abvText = State(initialValue: Self.inputText(drink?.abvPercent ?? DrinkType.beer.defaultABV))
        _consumptionTime = State(initialValue: drink?.timestamp ?? Date())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Drink Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(DrinkType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: AppTheme.icon(for: type)).tag(type)
                        }
                    }
                    .onChange(of: selectedType) { _, _ in useDefaults() }
                }
                Section("Amount (US fl oz)") {
                    TextField("Amount in ounces", text: $amountText)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Amount, in US fluid ounces")
                    Text("Common: \(selectedType.defaultAmount, specifier: "%.1f") oz")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Section("ABV (%)") {
                    TextField("ABV percentage", text: $abvText)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Alcohol by volume, percent")
                    Text("Enter 0% for an alcohol-free drink.").font(.caption).foregroundStyle(.secondary)
                }
                Section("Time consumed") {
                    DatePicker("Consumed at", selection: $consumptionTime, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                    Text("Use the actual time you had the drink, even if you log it later.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Section { Button("Use Common Values", action: useDefaults) }
                if let error = viewModel.storageError {
                    Section { Text(error).foregroundStyle(AppTheme.destructive) }
                }
                Section {
                    if !isValidInput {
                        Text("Enter an amount greater than zero, an ABV from 0–100%, and a time that is not in the future.")
                            .font(.caption).foregroundStyle(AppTheme.destructive)
                    }
                    Button(existingDrink == nil ? "Add Drink" : "Save Changes", action: saveDrink)
                        .bold().frame(maxWidth: .infinity).disabled(!isValidInput || viewModel.storageError != nil)
                    if existingDrink != nil {
                        Button("Delete Drink", role: .destructive) { showingDeleteConfirmation = true }
                    }
                }
            }
            .navigationTitle(existingDrink == nil ? "Add Drink" : "Edit Drink")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            }
            .confirmationDialog("Delete This Drink?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete Drink", role: .destructive) {
                    if let drink = existingDrink {
                        viewModel.deleteDrink(id: drink.id)
                        if viewModel.storageError == nil { dismiss() }
                    }
                }
            }
        }
    }

    private var draft: Drink? {
        guard let amount = Self.number(amountText), let abv = Self.number(abvText) else { return nil }
        return Drink(id: existingDrink?.id ?? UUID(), timestamp: consumptionTime,
                     type: selectedType, amountOz: amount, abvPercent: abv)
    }
    private var isValidInput: Bool { draft?.isValid == true && consumptionTime <= Date() }
    private func useDefaults() {
        amountText = Self.inputText(selectedType.defaultAmount)
        abvText = Self.inputText(selectedType.defaultABV)
    }
    private func saveDrink() {
        guard isValidInput, let draft else { return }
        let saved = existingDrink == nil ? viewModel.addDrink(draft) : viewModel.updateDrink(draft)
        if saved { dismiss() }
    }
    private static func inputText(_ value: Double) -> String {
        DrinkInputParser.text(value)
    }
    private static func number(_ text: String) -> Double? {
        DrinkInputParser.number(text)
    }
}
