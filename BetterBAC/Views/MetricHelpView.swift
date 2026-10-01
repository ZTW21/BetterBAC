import SwiftUI

struct MetricHelpView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List {
                Section("Average pace") {
                    Text("Total US standard drinks logged ÷ hours since your first drink. The elapsed-time denominator has a five-minute minimum. Adding a drink raises pace; between drinks, pace falls once five minutes have elapsed.")
                    Text("A lower pace describes your consumption history. It does not describe alcohol remaining in your body.")
                }
                Section("Logged in past hour") {
                    Text("Counts the US standard drinks you logged in the preceding 60 minutes. An entry leaves this total exactly one hour after its consumption time. Zero means no drinks were logged in that window.")
                }
                Section("US standard drinks") {
                    Text("One US standard drink contains 14 grams of alcohol. We calculate intake from the volume and ABV you enter. Serving sizes and alcohol content vary; these totals depend on your entries.")
                    Link("NIAAA: What is a standard drink?", destination: URL(string: "https://rethinkingdrinking.niaaa.nih.gov/how-much-too-much/whats-standard-drink")!)
                }
                Section("Saving your log") {
                    Text("Tap End & Save to archive a session. If the next drink follows a gap of eight hours or more, the previous log is saved at its last drink time. This rule organizes logs and has no relationship to sobriety.")
                }
                Section("Personal awareness") {
                    Text("Pace describes your logged consumption over time. It does not estimate BAC, impairment, or when you will be sober. Never use Pourtime to decide whether to drive or operate machinery.")
                }
            }
            .navigationTitle("How pace works").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }
}
