#if DEBUG
import SwiftUI

/// A live resize harness for environments without a Duo runtime. These are illustrative
/// content sizes, not hardware specifications. No controls or overrides ship in Release.
struct QALayoutHost<Content: View>: View {
    @ViewBuilder let content: Content
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var expanded = QAScreenHost.argument("--qa-layout") != "compact"
    @State private var largeText = QAScreenHost.argument("--qa-type") == "accessibility"

    private var mode: String? { QAScreenHost.argument("--qa-layout") }

    var body: some View {
        if mode == nil {
            content.environment(\.dynamicTypeSize, largeText ? .accessibility5 : typeSize)
        } else {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    if mode == "resizable" {
                        HStack {
                            Button("Compact") { expanded = false }
                                .buttonStyle(.bordered).accessibilityValue(expanded ? "" : "Selected")
                            Button("Expanded") { expanded = true }
                                .buttonStyle(.bordered).accessibilityValue(expanded ? "Selected" : "")
                            Toggle("Large text", isOn: $largeText).fixedSize()
                        }
                        .padding(8)
                    }
                    content
                        .environment(\.horizontalSizeClass, expanded ? .regular : .compact)
                        .environment(\.dynamicTypeSize, largeText ? .accessibility5 : typeSize)
                        .frame(width: min(geometry.size.width, expanded ? 900 : 390))
                        .frame(maxHeight: expanded ? 650 : 760)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
        }
    }
}
#endif
